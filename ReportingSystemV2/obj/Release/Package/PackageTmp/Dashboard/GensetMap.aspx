<%@ Page Title="Map" Language="C#" MasterPageFile="~/Dashboard/Dashboard.Master" AutoEventWireup="true" CodeBehind="GensetMap.aspx.cs" Inherits="ReportingSystemV2.Dashboard.GensetMap" %>
<asp:Content ID="Content1" ContentPlaceHolderID="DashboardSubContent" runat="server">
<script type="text/javascript">
    var markers = [
        <asp:Repeater ID="rptMarkers" runat="server">
            <ItemTemplate>
            {
                "title": '<%# Eval("Name") %>',
                "lat": '<%# Eval("Latitude") %>',
                "lng": '<%# Eval("Longitude") %>',
                "description": '<%# Eval("Description") %>'
            }
            </ItemTemplate>
        <SeparatorTemplate>,</SeparatorTemplate>
        </asp:Repeater>
    ];
</script>

<script type="text/javascript">
    function initMap() {
            var mapOptions = {
                center: new google.maps.LatLng(markers[0].lat, markers[0].lng),
                zoom: 12,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };

            var infoWindow = new google.maps.InfoWindow();

            var map = new google.maps.Map(document.getElementById("MainContent_DashboardSubContent_mapContainer"), mapOptions);

            for (i = 0; i < markers.length; i++) {
                var data = markers[i]
                var myLatlng = new google.maps.LatLng(data.lat, data.lng);
                var marker = new google.maps.Marker({
                    position: myLatlng,
                    map: map,
                    title: data.title,
                    icon: '//operations.edina.eu/img/Maps/control_green1.gif'
                });

                (function (marker, data) {
                    google.maps.event.addListener(marker, "click", function (e) {
                        infoWindow.setContent(data.description);
                        infoWindow.open(map, marker);
                    });
                })(marker, data);
            }
        }
</script>

<script src="//maps.googleapis.com/maps/api/js?key=AIzaSyDIu5GiYhpbFS_x8Cff4TOab-hR-IKlC0c&callback=initMap"
    async defer></script>


<div class="container-fluid">
    <div class="row">
        <div id="mapContainer" runat="server" class="fill map-border"></div>
    </div>
</div>
</asp:Content>
