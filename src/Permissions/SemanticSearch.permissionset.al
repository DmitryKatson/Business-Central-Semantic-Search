permissionset 80100 "GPT Semantic Search"
{
    Assignable = true;
    Permissions = tabledata "GPT Embedding" = RIMD,
        tabledata "GPT Embedding Vector" = RIMD,
        tabledata "GPT Semantic Search Result" = RIMD,
        tabledata "GPT Semantic Search Setup" = RIMD;
}