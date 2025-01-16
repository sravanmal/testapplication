sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'sravan/testapplication/test/integration/FirstJourney',
		'sravan/testapplication/test/integration/pages/Request_HeaderList',
		'sravan/testapplication/test/integration/pages/Request_HeaderObjectPage',
		'sravan/testapplication/test/integration/pages/Request_ItemObjectPage'
    ],
    function(JourneyRunner, opaJourney, Request_HeaderList, Request_HeaderObjectPage, Request_ItemObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('sravan/testapplication') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheRequest_HeaderList: Request_HeaderList,
					onTheRequest_HeaderObjectPage: Request_HeaderObjectPage,
					onTheRequest_ItemObjectPage: Request_ItemObjectPage
                }
            },
            opaJourney.run
        );
    }
);