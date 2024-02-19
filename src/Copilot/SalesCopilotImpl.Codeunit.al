codeunit 80102 "GPT Sales Copilot Impl."
{
    procedure GenerateSalesOrder(ContactEmail: text[80]; LinesDescription: text; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        if ContactEmail = '' then
            exit;
        if LinesDescription = '' then
            exit;

        CreateSalesHeader(SalesHeader, ContactEmail);
        CreateSalesLines(SalesHeader, SalesLine, LinesDescription);
    end;

    procedure SaveGeneratedSalesOrder(var SalesHeaderGenerated: Record "Sales Header"; var SalesLineGenerated: Record "Sales Line"): Guid
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader := SalesHeaderGenerated;
        SalesHeader.Insert(true);

        if SalesLineGenerated.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine.Validate("Document Type", SalesLineGenerated."Document Type");
                SalesLine.Validate("Document No.", SalesLineGenerated."Document No.");
                SalesLine.Validate("Line No.", SalesLineGenerated."Line No.");
                SalesLine.Validate("Type", SalesLineGenerated.Type);
                SalesLine.Validate("No.", SalesLineGenerated."No.");
                SalesLine.Validate("Variant Code", SalesLineGenerated."Variant Code");
                SalesLine.Validate("Quantity", SalesLineGenerated.Quantity);
                SalesLine.Insert(true);
            until SalesLineGenerated.Next() = 0;

        exit(SalesHeader.SystemId);
    end;

    procedure CreateSalesHeader(var SalesHeader: Record "Sales Header"; ContactEmail: text[80])
    var
        Contact: Record "Contact";
        CustomerNo: Code[20];
    begin
        Contact.SetRange("E-Mail", ContactEmail);
        if Contact.IsEmpty then
            exit;

        Contact.FindFirst;
        FindCustomer(Contact, CustomerNo);

        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.InitInsert();
        SalesHeader.Insert(true);

        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Modify(true);
    end;

    local procedure FindCustomer(Contact: Record Contact; var CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        BusinessRelation: Record "Business Relation";
    begin
        if Contact.CountNoOfBusinessRelations("Contact Business Relation Link To Table"::Customer) = 0 then
            exit;

        FilterBusinessRelations(Contact, ContBusRel, "Contact Business Relation Link To Table"::Customer, true);
        ContBusRel.FindFirst;

        CustomerNo := ContBusRel."No.";
    end;

    local procedure FilterBusinessRelations(Contact: Record Contact; var ContBusRel: Record "Contact Business Relation"; LinkToTable: Enum "Contact Business Relation Link To Table"; All: Boolean)
    begin
        ContBusRel.Reset();
        if (Contact."Company No." = '') or (Contact."Company No." = Contact."No.") then
            ContBusRel.SetRange("Contact No.", Contact."No.")
        else
            ContBusRel.SetFilter("Contact No.", '%1|%2', Contact."No.", Contact."Company No.");
        if not All then
            ContBusRel.SetFilter("No.", '<>''''');
        if LinkToTable <> LinkToTable::" " then
            ContBusRel.SetRange("Link to Table", LinkToTable);
    end;


    local procedure CreateSalesLines(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; LinesDescription: text)
    var
        SalesLinesJsonArray: JsonArray;
        SalesLineJTok: JsonToken;
        i: Integer;
    begin
        GenerateSalesLinesJsonArray(LinesDescription, SalesLinesJsonArray);
        if SalesLinesJsonArray.Count = 0 then
            exit;

        for i := 0 to SalesLinesJsonArray.Count() - 1 do begin
            SalesLinesJsonArray.Get(i, SalesLineJTok);
            CreateSalesLine(SalesHeader, SalesLine, SalesLineJTok, i);
        end;
    end;

    local procedure GenerateSalesLinesJsonArray(InputText: text; var SalesLinesJsonArray: JsonArray)
    var
        SystemPromptTxt: Text;
        SalesCopilotPrompt: Codeunit "GPT Sales Copilot Prompt";
        TokenCountImpl: Codeunit "GPT Tokens Count Impl.";
        CompletePromptTokenCount: Integer;
        Completion: Text;
    begin
        SystemPromptTxt := SalesCopilotPrompt.SystemPrompt();

        CompletePromptTokenCount := TokenCountImpl.PreciseTokenCount(SystemPromptTxt) + TokenCountImpl.PreciseTokenCount(InputText);
        if CompletePromptTokenCount <= MaxInputTokens() then begin
            Completion := GenerateSalesLines(SystemPromptTxt, InputText);
            if CheckIfValidCompletion(Completion) then
                SalesLinesJsonArray.ReadFrom(Completion);
        end;
    end;

    local procedure GenerateSalesLines(SystemPromptTxt: Text; InputText: text): Text
    var
        AzureOpenAI: Codeunit "Azure OpenAi";
        AOAIDeployments: Codeunit "AOAI Deployments";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        CompletionAnswerTxt: Text;
    begin
        if not AzureOpenAI.IsEnabled(Enum::"Copilot Capability"::"GPT Sales Copilot") then
            exit;

        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", GetEndpoint(), GetDeployment(), GetSecret());
        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"GPT Sales Copilot");
        AOAIChatCompletionParams.SetMaxTokens(MaxOutputTokens());
        AOAIChatCompletionParams.SetTemperature(0);
        AOAIChatMessages.AddSystemMessage(SystemPromptTxt);
        AOAIChatMessages.AddUserMessage(InputText);
        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);
        if AOAIOperationResponse.IsSuccess() then
            CompletionAnswerTxt := AOAIChatMessages.GetLastMessage()
        else
            Error(AOAIOperationResponse.GetError());

        exit(CompletionAnswerTxt);
    end;

    [TryFunction]
    local procedure CheckIfValidCompletion(var Completion: Text)
    var
        JsonArray: JsonArray;
    begin
        JsonArray.ReadFrom(Completion);
    end;

    local procedure CreateSalesLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; SalesLineJTok: JsonToken; i: Integer)
    var
        Description, Specification, UnitOfMeasureText : Text;
        Quantity: Decimal;
        ItemNo: Code[20];
        VariantCode: Code[20];
    begin
        ParseSalesLine(Description, Quantity, Specification, UnitOfMeasureText, SalesLineJTok);
        FindItemWithSemanticSearch(Description, Specification, UnitOfMeasureText, ItemNo, VariantCode);
        InsertSalesLine(SalesHeader, SalesLine, ItemNo, VariantCode, Quantity, i);
    end;

    local procedure ParseSalesLine(var Description: Text; var Quantity: Decimal; var Specification: Text; var UnitOfMeasureText: Text; SalesLineJTok: JsonToken)
    var
        JValueTok: JsonToken;
    begin
        if not SalesLineJTok.SelectToken('description', JValueTok) then
            exit;
        Description := JValueTok.AsValue().AsText();

        if not SalesLineJTok.SelectToken('quantity', JValueTok) then
            exit;
        Quantity := JValueTok.AsValue().AsDecimal();

        if not SalesLineJTok.SelectToken('specification', JValueTok) then
            exit;
        Specification := JValueTok.AsValue().AsText();

        if not SalesLineJTok.SelectToken('unitOfMeasure', JValueTok) then
            exit;
        UnitOfMeasureText := JValueTok.AsValue().AsText();
    end;

    local procedure FindItemWithSemanticSearch(Description: Text; Specification: Text; UnitOfMeasureText: Text; var ItemNo: Code[20]; var VariantCode: Code[20])
    var
        SemanticSearchImpl: Codeunit "GPT Semantic Search Impl.";
        SearchText: Text;
        SemanticSearchResult: Record "GPT Semantic Search Result";
    begin
        SearchText := BuildSearchText(Description, Specification, UnitOfMeasureText);
        SemanticSearchImpl.SemanticSearch(SemanticSearchResult, SearchText, StrSubstNo('%1|%2', Database::Item, Database::"Item Variant"), 0.8);
        if SemanticSearchResult.IsEmpty then
            exit;

        SemanticSearchResult.FindFirst;
        GetItemAndVariant(ItemNo, VariantCode, SemanticSearchResult);
    end;

    local procedure BuildSearchText(var Description: Text; var Specification: Text; var UnitOfMeasureText: Text): Text
    var
        Item: Record "Item";
        SearchText: TextBuilder;
    begin
        SearchText.AppendLine(StrSubstNo('%1: %2', Item.FieldCaption(Description), Description));
        SearchText.AppendLine(StrSubstNo('%1: %2', Item.FieldCaption("Variant Filter"), Specification));
        SearchText.AppendLine(StrSubstNo('%1: %2', Item.FieldCaption("Base Unit of Measure"), UnitOfMeasureText));
        exit(SearchText.ToText());
    end;

    local procedure GetItemAndVariant(var ItemNo: Code[20]; var VariantCode: Code[20]; SemanticSearchResult: Record "GPT Semantic Search Result")
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef := SemanticSearchResult.RecordId.GetRecord();
        case RecRef.Number of
            Database::Item:
                begin
                    FieldRef := RecRef.Field(1);
                    ItemNo := FieldRef.Value;
                end;
            Database::"Item Variant":
                begin
                    FieldRef := RecRef.Field(1);
                    VariantCode := FieldRef.Value;
                    FieldRef := RecRef.Field(2);
                    ItemNo := FieldRef.Value;
                end;
        end;
    end;

    local procedure InsertSalesLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ItemNo: Code[20]; VariantCode: Code[20]; Quantity: Decimal; i: Integer)
    begin
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := (i + 1) * 10000;
        SalesLine.Type := SalesLine.Type::"Item";
        SalesLine."No." := ItemNo;
        SalesLine.Description := GetItemDescription(ItemNo);
        SalesLine."Variant Code" := VariantCode;
        SalesLine.Quantity := Quantity;
        SalesLine.Insert();
    end;

    local procedure GetItemDescription(ItemNo: Code[20]): Text
    var
        Item: Record "Item";
    begin
        Item.Get(ItemNo);
        exit(Item.Description);
    end;

    local procedure GetEndpoint(): Text
    var
        SalesCopilotSetup: Record "GPT Semantic Search Setup";
    begin
        exit(SalesCopilotSetup.GetChatEndpoint())
    end;

    local procedure GetDeployment(): Text
    var
        SalesCopilotSetup: Record "GPT Semantic Search Setup";
    begin
        exit(SalesCopilotSetup.GetChatDeployment())
    end;

    [NonDebuggable]
    local procedure GetSecret(): Text
    var
        SalesCopilotSetup: Record "GPT Semantic Search Setup";
    begin
        SalesCopilotSetup.Get();
        exit(SalesCopilotSetup.GetSecretKeyFromIsolatedStorage())
    end;

    local procedure MaxInputTokens(): Integer
    begin
        exit(MaxModelTokens() - MaxOutputTokens());
    end;

    local procedure MaxOutputTokens(): Integer
    begin
        exit(2500);
    end;

    local procedure MaxModelTokens(): Integer
    begin
        exit(4096); //GPT 3.5 Turbo
    end;
}
