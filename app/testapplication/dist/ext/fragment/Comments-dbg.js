sap.ui.define([
    "sap/m/MessageToast"
], function(MessageToast) {
    'use strict';

    return {
        onPost: function(oEvent) {
            var that = this;
            var oUiModel = that.getModel("ui").getData(); // accessing the ui properties
            MessageToast.show("Custom handler invoked.");
            var data = {
                text: oEvent.getParameter("value")
 
            };
            
            var oDataModel = this.getBindingContext().getModel()
            const sPath = oDataModel.sServiceUrl + this.getBindingContext().sPath.slice(1, this.getBindingContext().sPath.length) + "/_Comments";
    
            $.ajax({
                url: sPath,
                async: false,
                headers : {
                    'X-CSRF-Token' : oDataModel.getHttpHeaders()["X-CSRF-Token"]
                },
                type: "POST",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (json) {
                    that.refresh();
                    MessageToast.show("Comment added successfully!");
                },
                error: function (error) {
                    // Handle the error scenario
                    MessageToast.error("Failed to add comment: " + error);
                },complete: function(xhr, status) {
            } });
            
        }
    };
});
