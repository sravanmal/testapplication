sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'sravan.testapplication',
            componentId: 'Request_ItemObjectPage',
            contextPath: '/Request_Header/_Items'
        },
        CustomPageDefinitions
    );
});