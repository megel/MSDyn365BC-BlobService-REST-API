table 50100 "MME BlobStorage Account"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Account Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }

        field(2; "Account Url"; Text[250])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }

        field(3; "SaS Token"; Text[250])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
    }

    keys
    {
        key(PK; "Account Name")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}