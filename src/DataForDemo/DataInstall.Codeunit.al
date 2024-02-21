codeunit 80107 "GPT Data Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        Item: Record Item;
        ItemAttribute: Record "Item Attribute";
        ItemVariant: Record "Item Variant";
        WhichType: Option "Option","Text","Integer","Decimal","Date";
    begin
        // Create Demonstration customers with contoso.com email addresses
        CreateCustomer('9001', 'Contoso Ltd.', 'alan@contoso.com');
        CreateCustomer('9002', 'Contoso A/S', 'sven@contoso.com');
        CreateCustomer('9003', 'Contoso GmbH', 'otto@contoso.com');
        CreateCustomer('9004', 'Contoso S.p.A.', 'marco@contoso.com');
        CreateCustomer('9005', 'Contoso S.a.r.l.', 'margruite@contoso.com');

        // Create Item Attributes (in case Color and Material Description are not already present)
        CreateItemAttribute(ItemAttribute, 'Color', WhichType::Option);
        AddItemAttributeOptions(ItemAttribute, 'Red,Orange,Yellow,Green,Blue,Violet,Purple,Black,White');
        CreateItemAttribute(ItemAttribute, 'Material Description', WhichType::Text);

        // Create some T-Shirts and Sweatshirts, each coming in a variety of colors and sizes
        CreateItem(Item, 'TSHIRT-001', 'Classic Red T-Shirt', 'Red', false);
        CreateItem(Item, 'TSHIRT-002', 'Classic Orange T-Shirt', 'Orange', false);
        CreateItem(Item, 'TSHIRT-003', 'Classic Yellow T-Shirt', 'Yellow', false);
        CreateItem(Item, 'TSHIRT-004', 'Classic Green T-Shirt', 'Green', false);
        CreateItem(Item, 'TSHIRT-005', 'Classic Blue T-Shirt', 'Blue', false);
        CreateItem(Item, 'TSHIRT-006', 'Classic Violet T-Shirt', 'Violet', false);
        CreateItem(Item, 'TSHIRT-007', 'Classic Purple T-Shirt', 'Purple', false);
        CreateItem(Item, 'TSHIRT-008', 'Classic Black T-Shirt', 'Black', false);
        CreateItem(Item, 'TSHIRT-009', 'Classic White T-Shirt', 'White', false);
        CreateItem(Item, 'TSHIRT-010', 'Stretchy Red T-Shirt', 'Red', false);
        CreateItem(Item, 'TSHIRT-011', 'Stretchy Orange T-Shirt', 'Orange', false);
        CreateItem(Item, 'TSHIRT-012', 'Stretchy Yellow T-Shirt', 'Yellow', false);
        CreateItem(Item, 'TSHIRT-013', 'Stretchy Green T-Shirt', 'Green', false);
        CreateItem(Item, 'TSHIRT-014', 'Stretchy Blue T-Shirt', 'Blue', false);
        CreateItem(Item, 'TSHIRT-015', 'Stretchy Violet T-Shirt', 'Violet', false);
        CreateItem(Item, 'TSHIRT-016', 'Stretchy Purple T-Shirt', 'Purple', false);
        CreateItem(Item, 'TSHIRT-017', 'Stretchy Black T-Shirt', 'Black', false);
        CreateItem(Item, 'TSHIRT-018', 'Stretchy White T-Shirt', 'White', false);
        CreateItem(Item, 'TSHIRT-019', 'Eco-Friendly Red T-Shirt', 'Red', true);
        CreateItem(Item, 'TSHIRT-020', 'Eco-Friendly Orange T-Shirt', 'Orange', true);
        CreateItem(Item, 'TSHIRT-021', 'Eco-Friendly Yellow T-Shirt', 'Yellow', true);
        CreateItem(Item, 'TSHIRT-022', 'Eco-Friendly Green T-Shirt', 'Green', true);
        CreateItem(Item, 'TSHIRT-023', 'Eco-Friendly Blue T-Shirt', 'Blue', true);
        CreateItem(Item, 'TSHIRT-024', 'Eco-Friendly Violet T-Shirt', 'Violet', true);
        CreateItem(Item, 'TSHIRT-025', 'Eco-Friendly Purple T-Shirt', 'Purple', true);
        CreateItem(Item, 'TSHIRT-026', 'Eco-Friendly Black T-Shirt', 'Black', true);
        CreateItem(Item, 'TSHIRT-027', 'Eco-Friendly White T-Shirt', 'White', true);

        CreateItem(Item, 'SWEATSHIRT-001', 'Classic Red Sweatshirt', 'Red', false);
        CreateItem(Item, 'SWEATSHIRT-002', 'Classic Orange Sweatshirt', 'Orange', false);
        CreateItem(Item, 'SWEATSHIRT-003', 'Classic Yellow Sweatshirt', 'Yellow', false);
        CreateItem(Item, 'SWEATSHIRT-004', 'Classic Green Sweatshirt', 'Green', false);
        CreateItem(Item, 'SWEATSHIRT-005', 'Classic Blue Sweatshirt', 'Blue', false);
        CreateItem(Item, 'SWEATSHIRT-006', 'Classic Violet Sweatshirt', 'Violet', false);
        CreateItem(Item, 'SWEATSHIRT-007', 'Classic Purple Sweatshirt', 'Purple', false);
        CreateItem(Item, 'SWEATSHIRT-008', 'Classic Black Sweatshirt', 'Black', false);
        CreateItem(Item, 'SWEATSHIRT-009', 'Classic White Sweatshirt', 'White', false);
        CreateItem(Item, 'SWEATSHIRT-010', 'Stretchy Red Sweatshirt', 'Red', false);
        CreateItem(Item, 'SWEATSHIRT-011', 'Stretchy Orange Sweatshirt', 'Orange', false);
        CreateItem(Item, 'SWEATSHIRT-012', 'Stretchy Yellow Sweatshirt', 'Yellow', false);
        CreateItem(Item, 'SWEATSHIRT-013', 'Stretchy Green Sweatshirt', 'Green', false);
        CreateItem(Item, 'SWEATSHIRT-014', 'Stretchy Blue Sweatshirt', 'Blue', false);
        CreateItem(Item, 'SWEATSHIRT-015', 'Stretchy Violet Sweatshirt', 'Violet', false);
        CreateItem(Item, 'SWEATSHIRT-016', 'Stretchy Purple Sweatshirt', 'Purple', false);
        CreateItem(Item, 'SWEATSHIRT-017', 'Stretchy Black Sweatshirt', 'Black', false);
        CreateItem(Item, 'SWEATSHIRT-018', 'Stretchy White Sweatshirt', 'White', false);
        CreateItem(Item, 'SWEATSHIRT-019', 'Eco-Friendly Red Sweatshirt', 'Red', true);
        CreateItem(Item, 'SWEATSHIRT-020', 'Eco-Friendly Orange Sweatshirt', 'Orange', true);
        CreateItem(Item, 'SWEATSHIRT-021', 'Eco-Friendly Yellow Sweatshirt', 'Yellow', true);
        CreateItem(Item, 'SWEATSHIRT-022', 'Eco-Friendly Green Sweatshirt', 'Green', true);
        CreateItem(Item, 'SWEATSHIRT-023', 'Eco-Friendly Blue Sweatshirt', 'Blue', true);
        CreateItem(Item, 'SWEATSHIRT-024', 'Eco-Friendly Violet Sweatshirt', 'Violet', true);
        CreateItem(Item, 'SWEATSHIRT-025', 'Eco-Friendly Purple Sweatshirt', 'Purple', true);
        CreateItem(Item, 'SWEATSHIRT-026', 'Eco-Friendly Black Sweatshirt', 'Black', true);
        CreateItem(Item, 'SWEATSHIRT-027', 'Eco-Friendly White Sweatshirt', 'White', true);

    end;

    local procedure CreateCustomer(NewNo: Code[20]; NewName: Text; NewEmail: Text)
    var
        Customer: Record Customer;
    begin
        if not Customer.Get(NewNo) then begin
            Customer.Init();
            Customer."No." := NewNo;
            Customer.Name := NewName;
            Customer."E-Mail" := NewEmail;
            Customer."GPT Demo Data" := true;
            Customer.Insert(true);
        end;
    end;

    local procedure CreateItem(var Item: Record Item; NewNo: Code[20]; NewDescription: Text; WhichColor: Text; IsEco: Boolean)
    begin
        if not Item.Get(NewNo) then begin
            Item.Init();
            Item."No." := NewNo;
            Item.Description := NewDescription;
            Item."Base Unit of Measure" := 'PCS';
            Item."Gen. Prod. Posting Group" := 'RETAIL';
            Item."Inventory Posting Group" := 'FINISHED';
            Item."Unit Cost" := 10;
            Item."Unit Price" := 20;
            Item."GPT Demo Data" := true;
            Item.Insert(true);
        end;
        // Add the variant sizes
        AddItemVariant(Item, 'S', 'Small');
        AddItemVariant(Item, 'M', 'Medium');
        AddItemVariant(Item, 'L', 'Large');
        AddItemVariant(Item, 'XL', 'Extra Large');
        AddItemVariant(Item, 'XXL', 'Double Extra Large');

        // Based on the color, we need to add the Item Attribute for this item
        if WhichColor <> '' then begin
            AddItemAttribute(Item, 'Color', WhichColor);
        end;

        // If the item is Eco, we need to add "Material Description" attribute, and set the value to 'ecological'
        if IsEco then begin
            AddItemAttribute(Item, 'Material Description', 'Ecological (eco)');
        end;
    end;

    local procedure AddItemVariant(var Item: Record Item; NewVariantCode: Code[20]; NewVariantDescription: Text)
    var
        ItemVariant: Record "Item Variant";
    begin
        if not ItemVariant.Get(Item."No.", NewVariantCode) then begin
            ItemVariant.Init();
            ItemVariant."Item No." := Item."No.";
            ItemVariant.Code := NewVariantCode;
            ItemVariant.Description := NewVariantDescription;
            ItemVariant.Insert(true);
        end;
    end;

    local procedure CreateItemAttribute(var ItemAttribute: Record "Item Attribute"; NewName: Text; WhichType: Option "Option","Text","Integer","Decimal","Date")
    begin
        ItemAttribute.SetRange("Name", NewName);
        if not ItemAttribute.FindFirst() then begin
            ItemAttribute.Init();
            ItemAttribute.ID := 0;
            ItemAttribute.Name := NewName;
            ItemAttribute.Type := WhichType;
            ItemAttribute.Insert(true);
        end;
    end;

    local procedure AddItemAttributeOptions(var ItemAttribute: Record "Item Attribute"; NewOptionList: Text)
    var
        ItemAttributeValue: Record "Item Attribute Value";
        OptionList: List of [Text];
        OptionValue: Text;
    begin
        OptionList := NewOptionList.Split(',');
        foreach OptionValue in OptionList do begin
            ItemAttributeValue.SetRange("Attribute ID", ItemAttribute.ID);
            ItemAttributeValue.SetRange("Value", OptionValue);
            if ItemAttributeValue.IsEmpty() then begin
                ItemAttributeValue.Init();
                ItemAttributeValue."Attribute ID" := ItemAttribute.ID;
                ItemAttributeValue.ID := 0;
                ItemAttributeValue.Value := OptionValue;
                ItemAttributeValue.Insert(true);
            end;
        end;
    end;

    local procedure AddItemAttribute(var Item: Record Item; WhichAttributeName: Text; WhichAttributeValue: Text)
    var
        ItemAttribute: Record "Item Attribute";
        ItemAttributeValue: Record "Item Attribute Value";
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
    begin
        ItemAttribute.SetRange("Name", WhichAttributeName);
        if ItemAttribute.FindFirst() then begin

            ItemAttributeValue.SetRange("Attribute ID", ItemAttribute.ID);
            ItemAttributeValue.SetRange("Value", WhichAttributeValue);
            if ItemAttributeValue.FindFirst() then begin
                // Try to add the Item mapping
                ItemAttributeValueMapping.SetRange("Table ID", Database::Item);
                ItemAttributeValueMapping.SetRange("No.", Item."No.");
                ItemAttributeValueMapping.SetRange("Item Attribute ID", ItemAttribute.ID);
                ItemAttributeValueMapping.SetRange("Item Attribute Value ID", ItemAttributeValue.ID);
                if ItemAttributeValueMapping.IsEmpty() then begin
                    ItemAttributeValueMapping.Init();
                    ItemAttributeValueMapping."Table ID" := Database::Item;
                    ItemAttributeValueMapping."No." := Item."No.";
                    ItemAttributeValueMapping."Item Attribute ID" := ItemAttribute.ID;
                    ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                    ItemAttributeValueMapping.Insert(true);
                end;
            end else begin
                // Common in text description, we will need to create the Attribute Value
                ItemAttributeValue.Init();
                ItemAttributeValue."Attribute ID" := ItemAttribute.ID;
                ItemAttributeValue.Value := WhichAttributeValue;
                ItemAttributeValue.Insert(true);
                // Now we can add the Item mapping
                ItemAttributeValueMapping.Init();
                ItemAttributeValueMapping."Table ID" := Database::Item;
                ItemAttributeValueMapping."No." := Item."No.";
                ItemAttributeValueMapping."Item Attribute ID" := ItemAttribute.ID;
                ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                ItemAttributeValueMapping.Insert(true);
            end;
        end;
    end;
}
