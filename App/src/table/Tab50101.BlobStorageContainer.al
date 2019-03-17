table 50101 "MME BlobStorage Container"
{
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Name"; Text[250])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(2; "Last Modified"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(3; "Lease Status"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(4; "Lease State"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}