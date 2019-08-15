/*
 Edina Navlinks JS v1.0.3 (2016-02-20)

 (c) 2015-2016 Neil Rutherford

 License: www.edina.eu/license
*/

// Adds the active class to the relevant navlinks.

function updateNavBarActiveLinks() {
    // Updating the active nav links
    var url = window.location.href;
    var substr = url.split('/');
    var dirurlaspx = substr[substr.length - 2];
    var pgurlaspx = substr[substr.length - 1];

    console.log('dir=' + dirurlaspx + ', pg=' + pgurlaspx);

    // Clear all links
    //$('.nav').find('.active').removeClass('active');

    // Check the directory path first to update main navbar
    if (dirurlaspx) {
        $('.navbar navbar-nav li a').each(function () {
            if (this.href.indexOf(dirurlaspx) >= 0) {
                $(this).parent().addClass('active');
            }
        });

        switch (dirurlaspx) {
            case "Dashboard":
                $('#liDashboard').addClass('active');
                break;
            case "Reporting":
                $('#liReporting').addClass('active');
                break;
            case "CPanel":
                $('#liCPanel').addClass('active');
                break;
            case "Admin":
                $('#liAdmin').addClass('active');
                break;
            case "GlobalReports":
                $('#liReporting').addClass('active');
                break;
            default:
                $('#liDashboard').addClass('active');
                console.log('no dir!');
        }
    } else {
        // No directory url, where on Default.aspx
        $('#liDashboard').addClass('active');
    }


    //Check the page path to update the sub navbar
    if (pgurlaspx) {
        $('.nav li a').each(function () {
            var current_substr = this.href.split('/');
            var current_pgurlaspx = current_substr[current_substr.length - 1];
            if (current_pgurlaspx == pgurlaspx) {
                if (!$(this).parent().parent().hasClass('nav-tabs')) { // Except on the tab panels!
                    $(this).parent().addClass('active');
                }
            }
        });

        switch (pgurlaspx) {
            case "GensetCharts.aspx":
                $('#liChartsDDL').addClass('active');
                break;
            case "GensetCharting.aspx":
                $('#liChartsDDL').addClass('active');
                break;
            default:
                console.log('no pg!');
        }
    }
}