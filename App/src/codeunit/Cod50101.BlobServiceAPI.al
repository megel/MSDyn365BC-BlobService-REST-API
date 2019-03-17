codeunit 50101 "MME Blob Service API"
{
    procedure ListContainers(var containers: Record "MME BlobStorage Container" temporary): Boolean
    var
        blobStorageAccount: Record "MME BlobStorage Account";
        client: HttpClient;
        response: HttpResponseMessage;
        xmlContent: Text;
        xmlDoc: XmlDocument;
        root: XmlElement;
        nodes: XmlNodeList;
        node: XmlNode;
        i: Integer;
    begin
        if not blobStorageAccount.FindFirst() then exit;
        //GET https://<accountname>.blob.core.windows.net/?comp=list&<sastoken>
        if not client.Get(StrSubstNo('%1?comp=list&%2', blobStorageAccount."Account Url", blobStorageAccount."SaS Token"), response) then begin
            response.Content.ReadAs(xmlContent);
            exit;
        end;
        if not response.Content().ReadAs(xmlContent) then exit;
        if not XmlDocument.ReadFrom(xmlContent, xmlDoc) then exit;
        xmlDoc.GetRoot(root);
        root.WriteTo(xmlContent);
        if not root.SelectNodes('/*/Containers/Container/Name', nodes) then exit;
        for i := 1 to nodes.Count() do begin
            nodes.Get(i, node);
            containers.Init();
            containers.Name := node.AsXmlElement().InnerText();

            if root.SelectSingleNode(StrSubstNo('/*/Containers/Container[%1]/Properties/Last-Modified', i), node) then
                containers."Last Modified" := node.AsXmlElement().InnerText();
            if root.SelectSingleNode(StrSubstNo('/*/Containers/Container[%1]/Properties/LeaseStatus', i), node) then
                containers."Lease Status" := node.AsXmlElement().InnerText();
            if root.SelectSingleNode(StrSubstNo('/*/Containers/Container[%1]/Properties/LeaseState', i), node) then
                containers."Lease State" := node.AsXmlElement().InnerText();
            containers.Insert();
        end;
        exit(true);
    end;

    procedure ListBlobs(containerName: Text; var blobs: Record "MME BlobStorage Blob" temporary): Boolean
    var
        blobStorageAccount: Record "MME BlobStorage Account";
        client: HttpClient;
        response: HttpResponseMessage;
        xmlContent: Text;
        xmlDoc: XmlDocument;
        root: XmlElement;
        nodes: XmlNodeList;
        node: XmlNode;
        i: Integer;
        len: Integer;
    begin
        if not blobStorageAccount.FindFirst() then exit;
        //GET https://<accountname>.blob.core.windows.net/<container>?restype=container&comp=list&<sastoken>
        if not client.Get(StrSubstNo('%1/%2?restype=container&comp=list&%3', blobStorageAccount."Account Url", containerName, blobStorageAccount."SaS Token"), response) then exit;
        if not response.Content().ReadAs(xmlContent) then exit;
        if not XmlDocument.ReadFrom(xmlContent, xmlDoc) then exit;
        xmlDoc.GetRoot(root);
        root.WriteTo(xmlContent);
        if not root.SelectNodes('/*/Blobs/Blob/Name', nodes) then exit;
        for i := 1 to nodes.Count() do begin
            nodes.Get(i, node);
            blobs.Init();
            blobs.Container := containerName;
            blobs.Name := node.AsXmlElement().InnerText();

            if root.SelectSingleNode(StrSubstNo('/*/Blobs/Blob[%1]/Properties/Last-Modified', i), node) then
                blobs."Last Modified" := node.AsXmlElement().InnerText();
            if root.SelectSingleNode(StrSubstNo('/*/Blobs/Blob[%1]/Properties/LeaseStatus', i), node) then
                blobs."Lease Status" := node.AsXmlElement().InnerText();
            if root.SelectSingleNode(StrSubstNo('/*/Blobs/Blob[%1]/Properties/LeaseState', i), node) then
                blobs."Lease State" := node.AsXmlElement().InnerText();
            if root.SelectSingleNode(StrSubstNo('/*/Blobs/Blob[%1]/Properties/Creation-Time', i), node) then
                blobs."Creation Time" := node.AsXmlElement().InnerText();
            if root.SelectSingleNode(StrSubstNo('/*/Blobs/Blob[%1]/Properties/BlobType', i), node) then
                blobs."Blob Type" := node.AsXmlElement().InnerText();
            if root.SelectSingleNode(StrSubstNo('/*/Blobs/Blob[%1]/Properties/Content-Type', i), node) then
                blobs."Content Type" := node.AsXmlElement().InnerText();
            if root.SelectSingleNode(StrSubstNo('/*/Blobs/Blob[%1]/Properties/Content-Length', i), node) then
                if Evaluate(len, node.AsXmlElement().InnerText()) then
                    blobs."Content Length" := len;
            blobs.Insert();
        end;
        exit(true);
    end;

    procedure GetBlob(containerName: Text; blobName: Text; var text: Text): Boolean
    var
        blobStorageAccount: Record "MME BlobStorage Account";
        client: HttpClient;
        response: HttpResponseMessage;
    begin
        if not blobStorageAccount.FindFirst() then exit(false);
        //GET https://<accountname>.blob.core.windows.net/<container>/<blob>?<sastoken>
        if not client.Get(StrSubstNo('%1/%2/%3?%4', blobStorageAccount."Account Url", containerName, blobName, blobStorageAccount."SaS Token"), response) then exit(false);
        exit(response.Content().ReadAs(text));
    end;

    procedure GetBlob(containerName: Text; blobName: Text; var stream: InStream): Boolean
    var
        blobStorageAccount: Record "MME BlobStorage Account";
        client: HttpClient;
        response: HttpResponseMessage;
    begin
        if not blobStorageAccount.FindFirst() then exit(false);
        //GET https://<accountname>.blob.core.windows.net/<container>/<blob>?<sastoken>
        if not client.Get(StrSubstNo('%1/%2/%3?%4', blobStorageAccount."Account Url", containerName, blobName, blobStorageAccount."SaS Token"), response) then exit(false);
        exit(response.Content().ReadAs(stream))
    end;

    procedure PutBlob(containerName: Text; blobName: Text; var text: Text): Boolean
    var
        blobStorageAccount: Record "MME BlobStorage Account";
        memoryStream: Codeunit "MemoryStream Wrapper";
        client: HttpClient;
        response: HttpResponseMessage;
        content: HttpContent;
        headers: HttpHeaders;
        len: Integer;
    begin
        if not blobStorageAccount.FindFirst() then exit;

        // Write the test into HTTP Content and change the needed Header Information 
        content.WriteFrom(text);
        content.GetHeaders(headers);
        headers.Remove('Content-Type');
        headers.Add('Content-Type', 'application/octet-stream');
        headers.Add('Content-Length', StrSubstNo('%1', StrLen(text)));
        headers.Add('x-ms-blob-type', 'BlockBlob');

        //PUT https://<accountname>.blob.core.windows.net/<container>/<blob>?<sastoken>
        exit(client.Put(StrSubstNo('%1/%2/%3?%4', blobStorageAccount."Account Url", containerName, blobName, blobStorageAccount."SaS Token"), content, response));
    end;

    procedure PutBlob(containerName: Text; blobName: Text; var stream: InStream): Boolean
    var
        blobStorageAccount: Record "MME BlobStorage Account";
        memoryStream: Codeunit "MemoryStream Wrapper";
        client: HttpClient;
        response: HttpResponseMessage;
        content: HttpContent;
        headers: HttpHeaders;
        len: Integer;
    begin
        if not blobStorageAccount.FindFirst() then exit;
        client.SetBaseAddress(blobStorageAccount."Account Url");

        // Load the memory stream and get the size
        memoryStream.Create(0);
        memoryStream.ReadFrom(stream);
        len := memoryStream.Length();
        memoryStream.SetPosition(0);
        memoryStream.GetInStream(stream);

        // Write the Stream into HTTP Content and change the needed Header Information 
        content.WriteFrom(stream);
        content.GetHeaders(headers);
        headers.Remove('Content-Type');
        headers.Add('Content-Type', 'application/octet-stream');
        headers.Add('Content-Length', StrSubstNo('%1', len));
        headers.Add('x-ms-blob-type', 'BlockBlob');

        //PUT https://<accountname>.blob.core.windows.net/<container>/<blob>?<sastoken>
        exit(client.Put(StrSubstNo('%1/%2/%3?%4', blobStorageAccount."Account Url", containerName, blobName, blobStorageAccount."SaS Token"), content, response));
    end;

    procedure GetBlobUrl(containerName: Text; blobName: Text): Text
    var
        blobStorageAccount: Record "MME BlobStorage Account";
    begin
        if not blobStorageAccount.FindFirst() then exit;
        exit(StrSubstNo('%1/%2/%3?%4', blobStorageAccount."Account Url", containerName, blobName, blobStorageAccount."SaS Token"));
    end;
}