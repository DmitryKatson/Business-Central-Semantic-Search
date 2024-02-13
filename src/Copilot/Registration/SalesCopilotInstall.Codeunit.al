codeunit 80105 "GPT Sales Copilot Install"
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    begin
        RegisterCapability();
    end;

    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        EnvironmentInformation: Codeunit "Environment Information";
        LearnMoreUrlTxt: Label 'https://katson.com/blog', Locked = true;
    begin
        if EnvironmentInformation.IsSaaS() then
            if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"GPT Sales Copilot") then
                CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"GPT Sales Copilot", LearnMoreUrlTxt);
    end;
}