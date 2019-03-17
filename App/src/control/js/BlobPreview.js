function SetImageUri(imageUri)
{
    var controlAddIn = document.getElementById('controlAddIn');
    if (! controlAddIn) {
        console.error('controlAddIn not found!')
        return;
    }

    if (! imageUri || imageUri === "") {
        controlAddIn.innerHTML = '<div>'
            + 'no Preview'
            + '</div>';
        return;
    }

    controlAddIn.innerHTML = '<div>'
          + '<img id="edImage" src="' + imageUri + '"></ image>'
          + '</div>';
}

function SetText(content)
{
    var controlAddIn = document.getElementById('controlAddIn');
    if (! controlAddIn) {
        console.error('controlAddIn not found!')
        return;
    }

    controlAddIn.innerHTML = '<div id="edText">'
       + '</div>';

    var edText = document.getElementById('edText');
    if (! edText) {
        console.error('edText not found!')
        return;
    }
    edText.innerText = content;
}

function Reset()
{
    var controlAddIn = document.getElementById('controlAddIn');
    if (! controlAddIn) {
        console.error('controlAddIn not found!')
        return;
    }

    controlAddIn.innerHTML = '<div>'
       + 'no Preview'
       + '</div>';
}