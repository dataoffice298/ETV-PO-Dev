tableextension 50069 ItemExtB2B extends Item //27
{
    fields
    {
        //B2BMSOn03Nov2022>>
        field(60000; "QC Enabled B2B"; Boolean)
        {
            Caption = 'QC Enabled';
            DataClassification = CustomerContent;
        }
        //B2BMSOn03Nov2022<<
    }

    //B2BMSOn30Sep2022>> Added for report sorting
    keys
    {
        key(Key20; "Item Category Code")
        {
        }
    }
    //B2BMSOn30Sep2022<<
}