controladdin BlobPreviewControl
{
    RequestedHeight = 400;
    MinimumHeight = 300;
    MaximumHeight = 500;
    RequestedWidth = 300;
    MinimumWidth = 250;
    MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    Scripts =
        './src/control/js/BlobPreview.js';
    StyleSheets =
        './src/control/css/style.css';
    StartupScript = './src/control/js/BlobPreview.startup.js';

    // The event is raised from Control AddIn, when it is loaded and ready to use from AL
    event OnInitialized()

    // Show an Image
    procedure SetImageUri(imageUri: Text);

    // Show the text
    procedure SetText(content: Text);

    // Reset the view
    procedure Reset();

}