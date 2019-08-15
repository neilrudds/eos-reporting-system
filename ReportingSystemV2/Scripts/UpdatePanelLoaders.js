$(function () {
    //Get all the update panel requests
    var requests = Sys.WebForms.PageRequestManager.getInstance();

    //When an update panel begins to update
    requests.add_beginRequest(ShowPageLoader);

    //When an update panel completes loading
    requests.add_endRequest(HidePageLoader);
});

function ShowPageLoader(sender, args){
    //Add a loader on every update panel that is changing
    for (var i = 0; i < sender._updatePanelClientIDs.length; i++) {
        var panelId = sender._updatePanelClientIDs[i];
        var $updatedPanel = $("#" + panelId);

        if (panelId.indexOf("UpdatePanelDateChanged") == -1 && panelId.indexOf("updSubNav") == -1) { // ignore the date range selector and secondary nav
            //create and position an overlay
            var overlay = $("<div id='overlay_" + panelId + "' class='overlay' />").css({
                height: $updatedPanel.height(),
                width: $updatedPanel.width(),
                top: $updatedPanel.position().top,
                left: $updatedPanel.position().left
            });

            //create and position a loader
            var loader = $("<div id='loader_" + panelId + "' class='page-loader loading' />").css({
                left: $updatedPanel.position().left + ($updatedPanel.width() / 2),
                top: $updatedPanel.position().top + ($updatedPanel.height() / 2)
            });

            //Add them to the page and fade them in
            overlay.add(loader).insertBefore($updatedPanel).fadeIn(300);
        }
    }
}
function HidePageLoader(sender, args) {
    //Remove the loader from update panels that have finished loading
    for (var i = 0; i < sender._updatePanelIDs.length; i++) {
        var panelId = sender._updatePanelClientIDs[i];
        if (panelId.indexOf("UpdatePanelDateChanged") == -1 && panelId.indexOf("updSubNav") == -1) {
            $("#loader_" + panelId + ",#overlay_" + panelId).stop().fadeOut(300, function () {
                $(this).remove();
            });
        }
    }

    // Finally, Call the link update function in Navlinks.js
    updateNavBarActiveLinks();
}
