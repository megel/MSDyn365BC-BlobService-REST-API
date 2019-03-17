try {   
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OnInitialized', []);
} catch (error) {
    console.error("[Control] InvokeExtensibilityMethod - OnInitialized " + error);
}