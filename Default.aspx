<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="GMaps" Namespace="Subgurim.Controles" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title></title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <meta charset="utf-8" />
    <style type="text/css">
        .auto-style5 {
            width: 336px;
        }
        .auto-style6 {
            width: 339px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <table style="width:100%;">
            <tr>
                <td class="auto-style5">
                    <asp:Button ID="btnSaveData" runat="server" OnClick="Button1_Click" Text="Save Data to Data base" />
                </td>
                <td class="auto-style6" dir="ltr" style="text-align:center">
                    &nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            </table>
            <cc1:GMap ID="GMap1" runat="server" Key="Your API Code" Width="90%" Height="900px"/>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            
    </div>
        <asp:HiddenField runat="server" ID="SendUserName" Value="" />
        <asp:HiddenField runat="server" ID="SendFireStationName" Value="" />
        <asp:HiddenField runat="server" ID="SendTime" Value="" />
        <asp:HiddenField runat="server" ID="SendDistance" Value="" />
        <asp:HiddenField runat="server" ID="SendFireStationAddress" Value="" />
        <asp:HiddenField runat="server" ID="SendUserAddress" Value="" />
        <div id="output">
        </div>
        <br />
         <script>
             //Global Var
             var infowindow;
             var destinationLat=[];
             var destinationLng = [];
             var secretMessages = [];
        
             function initMap() {
                 var pyrmont = { lat: 29.631487, lng: 52.489700 };
                 GMap1 = new google.maps.Map(document.getElementById('GMap1'), {
                     center: pyrmont,
                     zoom: 15
                 });

                 infowindow = new google.maps.InfoWindow();
                 randomMarker();
                 
                 var service = new google.maps.places.PlacesService(GMap1);
                 service.nearbySearch({
                     location: pyrmont,
                     radius: 50000,
                     type: ['fire_station']
                 }, callback);
             }

             function callback(results, status) {
                 if (status === google.maps.places.PlacesServiceStatus.OK) {
                     for (var j = 0; j < results.length; j++) {
                         createMarker(results[j]);
                     }
                 }
             }
             function createMarker(place) {
                 var marker = new google.maps.Marker({
                     map: GMap1,
                     position: place.geometry.location,
                     icon: 'image/4.png'
                 });
                 //
                 var originLat = marker.getPosition().lat();
                 var originLng = marker.getPosition().lng();
                 getDistance(originLat, originLng, place.name);

                 google.maps.event.addListener(marker, 'mouseover', function () {
                     infowindow.setContent(place.name);
                     infowindow.open(GMap1, this);
                 });
             }
             //random marker
             // Attaches an info window to a marker with the provided message. When the
             // marker is clicked, the info window will open with the secret message.
             function attachSecretMessage(marker, secretMessage) {
                 var infowindow = new google.maps.InfoWindow({
                     content: secretMessage
                 });
                 marker.addListener('mouseover', function() {
                     infowindow.open(marker.get('GMap1'), marker);
                 });
             }

             function calculateAndDisplayRoute(directionsService, directionsDisplay, orgLat, orgLng, destLat, destLng) {
                 directionsService.route({
                     origin: { lat: orgLat, lng: orgLng },
                     destination: { lat: destLat, lng: destLng },
                     // Note that Javascript allows us to access the constant
                     // using square brackets and a string value as its
                     // "property."
                     travelMode: 'DRIVING',
                     unitSystem: google.maps.UnitSystem.METRIC,
                     drivingOptions: {
                         departureTime: new Date(Date.now() + 30),  // for the time N milliseconds from now.
                         trafficModel: 'bestguess'
                     }
                 }, function (response, status) {
                     if (status == 'OK') {
                         directionsDisplay.setDirections(response);
                     }
                     else {
                         window.alert('Directions request failed due to ' + status);
                     }
                 });
             }
             function getDistance(orgLat, orgLng,PlaceName) {
                 var originA = { lat: orgLat, lng: orgLng };
                 var destination1 = { lat: destinationLat[0], lng: destinationLng[0] };

                 var service = new google.maps.DistanceMatrixService;
                 service.getDistanceMatrix({
                     origins: [originA],
                     destinations: [destination1],
                     travelMode: 'DRIVING',
                     unitSystem: google.maps.UnitSystem.METRIC,
                     avoidHighways: false,
                     avoidTolls: false
                 }, function (response, status) {
                     if (status !== 'OK') {
                         alert('Error was: ' + status);
                     }
                     else {
                         var originList = response.originAddresses;
                         var destinationList = response.destinationAddresses;
                         var outputDiv = document.getElementById('output');
                         for (var i = 0; i < originList.length; i++) {
                             var results = response.rows[i].elements;
                             for (var j = 0; j < results.length; j++) {
                                 var userName = secretMessages[j];
                                 var fireStationName = PlaceName;
                                 var time = results[j].duration.value;
                                 var distance = results[j].distance.text;
                                 var fireStationAddress = originList[i];
                                 var userAddress = destinationList[j];

                                 document.getElementById("<%=SendUserName.ClientID%>").value = document.getElementById("<%=SendUserName.ClientID%>").value + ";" + userName;
                                 document.getElementById("<%=SendFireStationName.ClientID%>").value = document.getElementById("<%=SendFireStationName.ClientID%>").value + ";" + fireStationName;
                                 document.getElementById("<%=SendTime.ClientID%>").value = document.getElementById("<%=SendTime.ClientID%>").value + ";" + time;
                                 document.getElementById("<%=SendDistance.ClientID%>").value = document.getElementById("<%=SendDistance.ClientID%>").value + ";" + distance;
                                 document.getElementById("<%=SendFireStationAddress.ClientID%>").value = document.getElementById("<%=SendFireStationAddress.ClientID%>").value + ";" + fireStationAddress;
                                 document.getElementById("<%=SendUserAddress.ClientID%>").value = document.getElementById("<%=SendUserAddress.ClientID%>").value + ";" + userAddress;
                             }
                         }
                     }
                 });
             }
             function randomMarker() {
                 var bounds = {
                     north: 29.651487,
                     south: 29.581487,
                     east: 52.549700,
                     west: 52.429700
                 };
                 // Display the area between the location southWest and northEast.
                 GMap1.fitBounds(bounds);
                 //random marker 
                 // Add 10 markers to map at random locations.
                 // For each of these markers, give them a title with their index, and when
                 // they are clicked they should open an infowindow with text from a secret
                 // message.
                 var str ="User_" +(Math.floor((Math.random() * 10000) + 1)).toString();
                 secretMessages = [str];
                 var lngSpan = bounds.east - bounds.west;
                 var latSpan = bounds.north - bounds.south;
                 for (var i = 0; i < secretMessages.length; ++i) {
                     var marker = new google.maps.Marker({
                         position: {
                             lat: bounds.south + latSpan * Math.random(),
                             lng: bounds.west + lngSpan * Math.random()
                         },
                         map: GMap1
                     });
                     attachSecretMessage(marker, secretMessages[i]);
                     destinationLat[i] = marker.getPosition().lat();
                     destinationLng[i] = marker.getPosition().lng();
                 }
             }
             function sleep(milliseconds) {
                 var start = new Date().getTime();
                 for (var i = 0; i < 1e7; i++) {
                     if ((new Date().getTime() - start) > milliseconds) {
                         break;
                     }
                 }
             }
    </script>
    </form>
    <%-- insert your Api code --%>
    <script src="https://maps.googleapis.com/maps/api/js?key= Your Api Code &libraries=places&callback=initMap" async="async" defer="defer"></script>
</body>
</html>
