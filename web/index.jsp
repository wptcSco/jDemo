<%--
    Document   : index
    Created on : Dec 4, 2012, 1:41:02 PM
    Author     : craigscofield
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.9.1/themes/base/jquery-ui.css" />
        <script src="http://code.jquery.com/jquery-1.8.2.js"></script>
        <script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
        <script type="text/javascript"
                src="https://maps.googleapis.com/maps/api/js?sensor=false&libraries=places,geometry,visualization">
        </script>
        <script src="http://gmaps-samples-v3.googlecode.com/svn/trunk/symbols/walmarts.json"></script>
        <style>

            html, body {
                margin: 1px;
                padding: 0;
                height: 100%;
                width: 99%;
                font-family: arial;
                font-size: 13px;
                overflow: auto;

            }

            #map_canvas {
                z-index: 1;
                float: left;
                width: 65%;
                height: 506px;
                margin-top: 13px;
                position:relative;
                border: outset #888;
                border-radius: 10px;
                -moz-border-radius: 10px;
                box-shadow: 4px 5px 9px #666;
                -webkit-box-shadow: 3px 3px 9px #666;
            }
            #map3d {
                font-size: 20px;
                font-family: sans-serif;
                text-shadow: 0.1em 0.1em 0.2em black;
                color: black;
                z-index: 1;
                float: left;
                width: 95%;
                height: 100%;
                margin-top: 13px;
                position:relative;
                border: outset #888;
                border-radius: 10px;
                -moz-border-radius: 10px;
                box-shadow: 4px 5px 9px #666;
                -webkit-box-shadow: 3px 3px 9px #666;
            }
            #listing {
                background: #888;
                opacity: 1;
                font-size: medium;
                color: orangeRED;
                position:relative;
                float: left;
                left:1px;
                margin-top: 13px;
                width: 64%;
                height: 606px;


                z-index:99;
                border: outset #888;
                border-radius: 10px;
                -moz-border-radius: 10px 10px 10px;
                box-shadow: 4px 5px 9px #666;
                -webkit-box-shadow: 3px 3px 9px #666;
            }

            #controls,#placeSV  {
                padding: 5px;
                width:250px;
                float:left;
            }
            .placeIcon {
                width: 16px;
                height: 16px;
                margin: 2px;
            }
            #keyword {font-size: x-large;}
            #results {

                border-collapse: collapse;
                width: 25%;
                position:absolute;
                height: 506px;
                float:right;
                top:30px;
                overflow:auto;
                margin: 5px 5px 5px 2px;
            }

            #panelBtn{color:red;position:absolute;top:14px;z-index:999999;}


            #street {float:left;border:2px solid gray; margin: 5px 5px 5px 2px; padding: 0; width: 98%; height:500px;                margin-top: 13px;
                     position:relative;
                     border: outset #888;
                     border-radius: 10px;
                     -moz-border-radius: 10px;
                     box-shadow: 3px 4px 6px #666;
                     -webkit-box-shadow: 2px 2px 6px #666; }
            #toolbar {background:black;float:right;height:15px;right:35px;width:315px;padding:5px 5px 15px 5px;z-index:9999;                border: outset #888;
                      border-radius: 10px;
                      -moz-border-radius: 10px;
                      box-shadow: 4px 5px 9px #999;
                      -webkit-box-shadow: 3px 3px 9px #999;}
            #toolbar button {height:25px;width:25px}

            #year {
                position: absolute;
                top: 4px;
                left: 128px;
                font-size: 30px;
                font-family: sans-serif;
                text-shadow: 0.1em 0.1em 0.2em black;
                color: black;
            }
            #month {
                position: absolute;
                top: 4px;
                left: 268px;
                font-size: 30px;
                font-family: sans-serif;
                text-shadow: 0.1em 0.1em 0.2em black;
                color: black;
            }
            .bigmap{
                width:100%;
                height:100%;
            }

            .minimap{
                width:250px;
                height:220px;
            }


        </style>

        <script type="text/javascript">
                    var map;
                    var places;
                    var iw;
                    var markers = [];
                    var point;
                    var heading;
                    var gradient;
                    function initialize() {
                        var options = {
                            zoom: 5,
                            center: new google.maps.LatLng(30.259, -97.768),
                            mapTypeId: google.maps.MapTypeId.ROADMAP,
                            streetViewControl: true
                        };
                        var mapCanvas = document.getElementById('map_canvas');
                        map = new google.maps.Map(mapCanvas, options);
                        places = new google.maps.places.PlacesService(map);
                        //google.maps.event.addListenerOnce(map, 'idle', alert('Demo'));
//                        google.maps.event.addListener(iw, 'domready', function() {
//                            setInterval($('#street').clone().prependTo('#map3d'), 1000);
//                        });
                        toggleListing();
                    }

                    function toggleListing() {
                        $('#listing').slideToggle('slow');
                        $('#street,#toolbar').slideToggle('slow');
                        $('#map3d').slideToggle('fast');
                    }

                    function updateKeyword(event) {
                        updateRankByCheckbox();
                        blockEvent(event);
                    }

                    function blockEvent(event) {
                        if (event.which === 13) {
                            event.cancelBubble = true;
                            event.returnValue = false;
                        }
                    }

                    function updateRankByCheckbox() {
                        var types = getTypes();
                        var keyword = document.controls.keyword.value;
                        var disabled = !types.length && !keyword;
                        var label = document.getElementById('rankbylabel');
                        label.style.color = disabled ? '#cccccc' : '#333';
                        document.controls.rankbydistance.disabled = disabled;
                    }

                    function getTypes() {
                        var types = [];
                        for (var i = 0; i < document.controls.type.length; i++) {
                            if (document.controls.type[i].checked) {
                                types.push(document.controls.type[i].value);
                            }
                        }
                        return types;
                    }

                    function search(event) {
                        if (event) {
                            event.cancelBubble = true;
                            event.returnValue = false;
                        }

                        var search = {};
                        // Set desired types.
                        var types = getTypes();
                        if (types.length) {
                            search.types = types;
                        }

                        // Set keyword.
                        var keyword = document.controls.keyword.value;
                        if (keyword) {
                            search.keyword = keyword;
                        }

                        // Set ranking.
                        if (!document.controls.rankbydistance.disabled &&
                                document.controls.rankbydistance.checked) {
                            search.rankBy = google.maps.places.RankBy.DISTANCE;
                            search.location = map.getCenter();
                        } else {
                            search.rankBy = google.maps.places.RankBy.PROMINENCE;
                            search.bounds = map.getBounds();
                        }

                        // Search.
                        places.search(search, function(results, status) {
                            if (status === google.maps.places.PlacesServiceStatus.OK) {
                                clearResults();
                                clearMarkers();
                                for (var i = 0; i < results.length; i++) {
                                    var letter = String.fromCharCode(65 + i);
                                    markers[i] = new google.maps.Marker({
                                        position: results[i].geometry.location,
                                        animation: google.maps.Animation.DROP,
                                        icon: 'http://maps.gstatic.com/intl/en_us/mapfiles/marker' +
                                                letter + '.png'
                                    });
                                    google.maps.event.addListener(
                                            markers[i], 'click', getDetails(results[i], i));
                                    dropMarker(markers[i], i * 100);
                                    addResult(results[i], i);
                                }
                            }
                        });
                    }

                    function clearMarkers() {
                        for (var i = 0; i < markers.length; i++) {
                            if (markers[i]) {
                                markers[i].setMap(null);
                                delete markers[i];
                            }
                        }
                    }

                    function dropMarker(marker, delay) {
                        window.setTimeout(function() {
                            marker.setMap(map);
                        }, delay);
                    }

                    function addResult(result, i) {
                        var results = document.getElementById('results');
                        var tr = document.createElement('tr');
                        tr.style.backgroundColor = i % 2 == 0 ? '#F0F0F0' : '#FFFFFF';
                        tr.onclick = function() {
                            google.maps.event.trigger(markers[i], 'click');
                        };
                        var iconTd = document.createElement('td');
                        var nameTd = document.createElement('td');
                        var icon = document.createElement('img');
                        icon.src = result.icon;
                        icon.className = 'placeIcon';
                        var name = document.createTextNode(result.name);
                        iconTd.appendChild(icon);
                        nameTd.appendChild(name);
                        tr.appendChild(iconTd);
                        tr.appendChild(nameTd);
                        results.appendChild(tr);
                    }

                    function clearResults() {
                        var results = document.getElementById('results');
                        while (results.childNodes[0]) {
                            results.removeChild(results.childNodes[0]);
                        }
                    }

                    function getDetails(result, i) {
                        return function() {
                            places.getDetails({
                                reference: result.reference
                            }, showInfoWindow(i));
                        };
                    }

                    function showInfoWindow(i) {

                        return function(place, status) {
                            if (iw) {
                                iw.close();
                                iw = null;
                            }

                            if (status == google.maps.places.PlacesServiceStatus.OK) {
                                iw = new google.maps.InfoWindow({
                                    content: getIWContent(place)
                                });

                                iw.open(map, markers[i]);

                                var bounds = new google.maps.LatLngBounds();
                                bounds.extend(markers[i].getPosition());
                                map.fitBounds(bounds);
                                map.setZoom(17);
                                point = new google.maps.LatLng(markers[i].position.lat(), markers[i].position.lng());
                                street = new google.maps.StreetViewPanorama(document.getElementById("street"), {
                                    position: new google.maps.LatLng(markers[i].position.lat(), markers[i].position.lng()),
                                    zoomControl: true,
                                    pov: {heading: hVal, pitch: 0, zoom: 1},
                                    enableCloseButton: false,
                                    addressControl: true,
                                    panControl: true,
                                    linksControl: true
                                });
                                $("#message").html("");
                                var service = new google.maps.StreetViewService;
                                service.getPanoramaByLocation(street.getPosition(), 65, function(panoData, status) {
                                    processSVData(panoData, status);
                                });
                            }
                        };
                    }

                    function processSVData(data, status) {

                        if (status == google.maps.StreetViewStatus.OK) {
                            var marker = new google.maps.Marker({
                                position: data.location.latLng,
                                draggable: false,
                                map: map,
                                title: data.location.description
                            });
                            street.setPano(data.location.pano);
                            heading = google.maps.geometry.spherical.computeHeading(data.location.latLng, point);
                            // alert(data.location.latLng+":"+myLatLng+":"+heading);
                            street.setPov({
                                heading: heading,
                                pitch: 0,
                                zoom: 1
                            });
                            street.setVisible(true);
                            //$('#headVal').val(street.getPov().heading);
                            //$('#street').clone().prependTo('#placeSV');


                            google.maps.event.addListener(marker, 'click', function() {

                                var markerPanoID = data.location.pano;
                                // Set the Pano to use the passed panoID
                                street.setPano(markerPanoID);
                                street.setPov({
                                    heading: heading,
                                    pitch: 0,
                                    zoom: 1
                                });
                                street.setVisible(true);
                                //$('#street').clone().prependTo('#placeSV');
                                //$('#headVal').val(street.getPov().heading);
                            });
                        }
                        else {
                            //alert("Sorry, distant Street View data!");
                            $("#message").html("Sorry, distant Street View data?");
                            var service = new google.maps.StreetViewService;
                            service.getPanoramaByLocation(street.getPosition(), 350, function(panoData, status) {
                                processSVData(panoData, status);
                                var panoCenter = panoData.location.latLng;
                                heading = google.maps.geometry.spherical.computeHeading(point, panoCenter);
                                hVal = heading;
                                var pov = street.getPov();
                                street.heading = heading;
                                street.setPov(pov);
                            });
                            street.setVisible(true);

                            //$('#headVal').val(street.getPov().heading);
                            return;
                        }
                    }



                    function getIWContent(place) {
                        var content = '<table id="placeSV" style="background:transparent;height:120px;width:200px;border:2px solid red"><tr><td style="border:0;">';
                        content += '<img class="placeIcon" src="' + place.icon + '"></td>';
                        content += '<td style="border:0;"><b><a href="' + place.url + '">';
                        content += place.name + '</a></b>';
                        content += '</td></tr></table>';
                        return content;


                    }


                    function printastic(url) {
                        //alert('here');
                        var WindowObject;
                        WindowObject = window.open(url, 'name', "width=940,height=1025,top=100,left=150,resizable=yes");
                        if (window.focus) {
                            WindowObject.focus();
                        }
                        var dataUrl = [];
                        var i = 0;

                        $("#map_canvas canvas").filter(function() {
                            dataUrl.push(this.toDataURL("image/png"));
                        });

                        //var DocumentContainer = "<DIV style='page-break-after:always'></DIV>";
                        var DocumentContainer = document.getElementById('map_canvas');

                        var DocumentContainer_temp = $(DocumentContainer).clone();

                        $(DocumentContainer_temp).find('canvas').each(function() {
                            $(this).replaceWith('<img class="prmap" title="abc" src="' + dataUrl[i] + '" style="position: relative; left: 0px; top: 0px; width: 256px; height: 256px;">');
                            i++;

                        });

                        $(DocumentContainer_temp).find('.gmnoprint').each(function() {
                            //alert('gotone');
                            $(this).replaceWith('<img class="screen" title="abc" src="' + dataUrl[i] + '" style="display: none;">');
                            i++;
                        });

                        var html = $("#street").clone().html();

                        //var WindowObject = window.open('', "PrintMap", "width=740,height=2525,top=200,left=250,resizable=yes");
                        WindowObject.document.open("text/html");

                        WindowObject.document.writeln('<html><head><title>Page Title Here</title>');
//        WindowObject.document.writeln('<style>#title{page-break-after:always;position:absolute;border:5px double gray;z-index:9;background:transparent;left:29px;top:-90px;height:90px;width:700px;margin:20px 20px 20px 20px;padding:20px 20px 20px 20px;}</style>');
                        WindowObject.document.writeln('<style>#map_div{position:absolute;border:5px double gray;left:29px;top:1px;height:450px;width:700px;margin:10px 10px 10px 20px;padding:20px 20px 20px 20px;}</style>');
                        WindowObject.document.writeln('<style>#textbox{position:absolute;border:5px double gray;left:29px;top:510px;height:450px;width:700px;margin:10px 10px 10px 20px;padding:20px 20px 20px 20px;}</style>');
                        //WindowObject.document.writeln('<link rel="stylesheet" href="http://www.wptc.com/iir/demos/styles/site.css" />');
                        WindowObject.document.writeln('</head><body style="height:1000px;width:800px">');
//        WindowObject.document.writeln('<DIV id="title" style="text-align:center;font-size:x-Large"><input value="Cover Page" style="height:100px; width:600px;font-size: .9em;" type="text"/></DIV><br/>');
                        WindowObject.document.writeln('<DIV id="map_div" >');
                        WindowObject.document.writeln(DocumentContainer_temp.html());
                        WindowObject.document.writeln('</DIV><br/>');
                        //$("#map3d").clone().appendTo("#map_div");
                        WindowObject.document.writeln('<DIV id="textbox" >');
                        WindowObject.document.writeln(html);
                        WindowObject.document.writeln('</DIV>');

                        // WindowObject.document.write('<p><a href="javascript:self.close()">Close</a> the popup.</p>');
                        WindowObject.document.write('</body></html>');
                        WindowObject.document.print();
                        WindowObject.document.close();

                        WindowObject.focus();
                        WindowObject.print();
                        WindowObject.close();

                        //$('#textbox').load('http://localhost:8085/cScoWeb2/index.html #map3d');
                    }
                    google.maps.event.addDomListener(window, 'load', initialize);</script>

        <style type="text/css">

        </style>

    </head>

    <body class="docs framebox_body" style="font-family: Arial;font-size:13px;border: 0 none;" onresize="handleFullScreen();">
        <div id="fullscreencontainer" style="position: absolute; left: 0px; top: 0px; width: 90%; height: 100%;"></div>
        <div id="sizecontainer" style="position: absolute; left: 300px;width: 480px; height: 508px;"></div>

        <div id="container">
            <input type="button" class="ui-btn button" id="panelBtn" value="PANEL" style="float:left" onclick="toggleListing();" />
            <br/>

            <div id="year">Map Book</div>        <div id="month">2012</div>



            <table style="display:inline" id="results"></table>
            <div id="listing">

                <input id="headVal" type="text" style="float:right;width:37px;height:30px"/>
                <span id="toolbar" class="ui-widget-header ui-corner-all" >

                    <button class="ui-btn button" type="button" onclick="search();" id="searchBtn">Search</button>
                    <button class="ui-btn button" type="button" id="clearBtn">Trash</button>
                    <button class="ui-btn button" type="button" id="streetBtn">Show Pano</button>
                    <button class="ui-btn button" type="button" id="mapSV">Show Map</button>
                    <button class="ui-btn button" type="button" id="beginning">North</button>
                    <button class="ui-btn button" type="button" id="rewind">-45</button>
                    <button class="ui-btn button" type="button" id="play">Play</button>
                    <button class="ui-btn button" type="button" id="stop">Stop</button>
                    <button class="ui-btn button" type="button" id="forward">+45</button>
                    <button class="ui-btn button" type="button" id="end">South</button>

                </span>
                <div style="width:100%;float:left;font-size:small;text-align:center;" id="message"></div>
                <div id="street"></div>


                <br/>
                <div id="controls" style="width:100%;">
                    <form name="controls">
                        <span id="toolbar2" class="ui-widget-header ui-corner-all" >
                            <input id="keyword" type="text" value="Walmart" style="position:absolute;top:1px;float:left;height:30px;width:25%" />
                            <button type="button" onclick="initializeHeat();">HeatMap</button>
                            <button type="button" onclick="toggleHeatmap();">On/Off</button>
                            <button type="button" onclick="changeGradient();">Color</button>
                            <button type="button" onclick="initializeHeat2();" style="float:right;margin-right:10%;margin-left: 40%; color: red">Timeline</button> <br/>
                            <!-- <button type="button" onclick="changeRadius()">Radius</button>
                            <button type="button" onclick="changeOpacity()">Opacity</button> -->
                            <div id="sliderOpacity" style="width:90%;float:left;color:orange">Opacity</div> 
                            <br/> 

                            <div id="sliderRadius" style="width:90%;float:left;color:#ff9933">Radius</div>
                            <br/> 
                            <hr/>

                            <input type="checkbox" name="type" value="store"
                                   onclick="updateRankByCheckbox();" /> store<br/>
                            <input type="checkbox" name="type" value="clothing_store"
                                   onclick="updateRankByCheckbox();" /> clothing_store<br/>
                            <input type="checkbox" name="type" value="restaurant"
                                   onclick="updateRankByCheckbox();" /> restaurant<br>
                            <input type="checkbox" name="type" value="lodging"
                                   onclick="updateRankByCheckbox();" /> lodging<br>
                            <input type="checkbox" name="type" value="museum"
                                   onclick="updateRankByCheckbox();" /> museum<br>
                            <div id="rankbylabel" style="float:left;margin-left: 25px; color: #cccccc">
                                <input type="checkbox" checked="checked"
                                       name="rankbydistance" /> Rank by distance
                            </div>



                        </span>


                    </form>
                </div>

                <!--                <input id="location" type="text" value="Austin, Tx"/><br/>
                                <input type="button" onclick="buttonClickFlyHere();" value="Fly Here!"/>-->
                <div id="sample-ui"></div>

            </div>
            <div id="map_canvas"></div><div id="map3d">2012 Map Book</div>
        </div>
    </div>
    <script>
                    var swirl;
                    $(function() {
                        $("#searchBtn").button({
                            text: false,
                            icons: {
                                primary: "ui-icon-search"
                            }
                        })
                                .click(function() {
                            search();
                        });
                        $("#clearBtn").button({
                            text: false,
                            icons: {
                                primary: "ui-icon-trash"
                            }
                        })
                                .click(function() {

                            var options;
                            if ($(this).text() === "play") {
                                options = {
                                    label: "Clear Search",
                                    icons: {
                                        primary: "ui-icon-trash"
                                    }
                                };
                            } else {

                                options = {
                                    label: "play",
                                    icons: {
                                        primary: "ui-icon-trash"
                                    }
                                };
                            }
                            $(this).button("option", options);
                            clearMarkers();
                            clearResults();
                            removeMarkersSetup();
                        });
                        $("#mapSV").button({
                            text: false,
                            icons: {
                                primary: "ui-icon-circle-arrow-s"
                            }
                        })
                                .click(function() {

                            var options;
                            if ($(this).text() === "play") {
                                options = {
                                    label: "Show Map",
                                    icons: {
                                        primary: "ui-icon-circle-arrow-s"
                                    }
                                };
                            } else {

                                options = {
                                    label: "play",
                                    icons: {
                                        primary: "ui-icon-circle-arrow-n"
                                    }
                                };
                            }
                            $(this).button("option", options);
                            //    init();
                            //  $('#map3d').slideToggle('slow');
                            $('#toolbar2').slideToggle('slow');
                            $('#map_canvas').slideToggle('slow', function() {
                                // Animation complete.
                                google.maps.event.trigger(map, 'resize');
                            });
                        });
                        $("#streetBtn").button({
                            text: false,
                            icons: {
                                primary: "ui-icon-video"
                            }
                        })
                                .click(function() {

                            var options;
                            if ($(this).text() === "play") {
                                options = {
                                    label: "Show Street",
                                    icons: {
                                        primary: "ui-icon-video"
                                    }
                                };
                            } else {

                                options = {
                                    label: "play",
                                    icons: {
                                        primary: "ui-icon-video"
                                    }
                                };
                            }
                            $(this).button("option", options);
                            $('#map_canvas').clone().appendTo('#map3d');
                            $('#street').clone().appendTo('#map3d');
                        });
                        $("#beginning").button({
                            text: false,
                            icons: {
                                primary: "ui-icon-seek-start"
                            }
                        })
                                .click(function() {
                            window.clearInterval(swirl);
                            street.getPov().heading = 0;
                            street.setVisible(true);
                            $('#headVal').val(street.getPov().heading);
                        });
                        $("#rewind").button({
                            text: false,
                            icons: {
                                primary: "ui-icon-seek-prev"
                            }
                        })
                                .click(function() {
                            window.clearInterval(swirl);
                            street.getPov().heading = street.getPov().heading - 45;
                            street.setVisible(true);
                            $('#headVal').val(street.getPov().heading);
                        });
                        $("#play").button({
                            text: false,
                            icons: {
                                primary: "ui-icon-play"
                            }
                        })
                                .click(function() {
                            window.clearInterval(swirl);
                            swirl = window.setInterval(lookAround, 3000);
                            var options;
                            if ($(this).text() === "play") {
                                options = {
                                    label: "pause",
                                    icons: {
                                        primary: "ui-icon-pause"
                                    }
                                };
                            } else {
                                window.clearInterval(swirl);
                                options = {
                                    label: "play",
                                    icons: {
                                        primary: "ui-icon-play"
                                    }
                                };
                            }
                            $(this).button("option", options);
                        });
                        $("#stop").button({
                            text: false,
                            icons: {
                                primary: "ui-icon-stop"
                            }
                        })
                                .click(function() {
                            window.clearInterval(swirl);
                            street.setVisible(true);
                            $('#headVal').val(street.getPov().heading);
                            $("#play").button("option", {
                                label: "play",
                                icons: {
                                    primary: "ui-icon-play"
                                }
                            });
                        });
                        $("#forward").button({
                            text: false,
                            icons: {
                                primary: "ui-icon-seek-next"
                            }
                        })
                                .click(function() {
                            window.clearInterval(swirl);
                            street.getPov().heading = street.getPov().heading + 45;
                            street.setVisible(true);
                            $('#headVal').val(street.getPov().heading);
                        });
                        $("#end").button({
                            text: false,
                            icons: {
                                primary: "ui-icon-print"
                            }
                        })
                                .click(function() {
                            window.clearInterval(swirl);

                            var url = "print.html";
                            printastic(url);

                        });
                    });
                    //var map;
                    var hVal = 0;
                    var mapOptions = {center: new google.maps.LatLng(30.0, -97.0), zoom: 16,
                        mapTypeId: google.maps.MapTypeId.ROADMAP};
                    function initializePOV() {

                        $('#headVal').val(hVal);
                        //map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
                        street = new google.maps.StreetViewPanorama(document.getElementById("street"), {
                            position: new google.maps.LatLng(30.25, -97.7283),
                            zoomControl: true,
                            pov: {heading: hVal, pitch: 0, zoom: 1},
                            enableCloseButton: false,
                            addressControl: false,
                            panControl: false,
                            linksControl: true
                        });
                        var infow = new google.maps.InfoWindow({content: document.getElementById("street")});
                        var myLatLng = new google.maps.LatLng(30.25, -97.7283);
                        var marker = new google.maps.Marker({position: myLatLng, map: map, visible: true, draggable: true});
                        map.setCenter(myLatLng);
                        google.maps.event.addListener(street, 'pov_changed', function() {
                            $('#headVal').val(street.getPov().heading);

                        });
                        google.maps.event.addListener(marker, "dragend", function(e) {
                            street = new google.maps.StreetViewPanorama(document.getElementById("street"), {
                                position: new google.maps.LatLng(e.latLng.lat(), e.latLng.lng()),
                                zoomControl: true,
                                pov: {heading: hVal, pitch: 0, zoom: 1},
                                enableCloseButton: false,
                                addressControl: false,
                                panControl: false,
                                linksControl: false
                            });
                            point = new google.maps.LatLng(e.latLng.lat(), e.latLng.lng());
                            street.setVisible(true);
                        });
                    }

                    var lookAround = function(point) {
                            $('#map_canvas').clone().appendTo('#map3d');
                            $('#street').clone().appendTo('#map3d');
                        if (street.getPov().heading > 360) {
                            street.getPov().heading = 0;
                            street.getPov().heading = street.getPov().heading + 30;
                            street.setVisible(true);
                            $('#headVal').val(street.getPov().heading);

                        } else
                        {
                            street.getPov().heading = street.getPov().heading + 30;
                            street.setVisible(true);
                            $('#headVal').val(street.getPov().heading);

                        }

                    };
                    google.maps.event.addDomListener(window, 'load', initializePOV);
                    // Adding Data Points
                    var map, pointarray, heatmap;
                    function initializeHeat() {
                        var taxiData = [
                            {location: new google.maps.LatLng(markers[0].position.lat(), markers[0].position.lng()), weight: 9},
                            new google.maps.LatLng(markers[0].position.lat(), markers[0].position.lng()),
                            {location: new google.maps.LatLng(markers[1].position.lat(), markers[1].position.lng()), weight: 8},
                            {location: new google.maps.LatLng(markers[2].position.lat(), markers[2].position.lng()), weight: 7},
                            {location: new google.maps.LatLng(markers[3].position.lat(), markers[3].position.lng()), weight: 6},
                            new google.maps.LatLng(markers[3].position.lat(), markers[3].position.lng()),
                            {location: new google.maps.LatLng(markers[4].position.lat(), markers[4].position.lng()), weight: 5},
                            {location: new google.maps.LatLng(markers[5].position.lat(), markers[5].position.lng()), weight: 4},
                            {location: new google.maps.LatLng(markers[6].position.lat(), markers[6].position.lng()), weight: 3},
                            new google.maps.LatLng(markers[6].position.lat(), markers[6].position.lng()),
                            {location: new google.maps.LatLng(markers[7].position.lat(), markers[7].position.lng()), weight: 2},
                            new google.maps.LatLng(markers[7].position.lat(), markers[7].position.lng()),
                            {location: new google.maps.LatLng(markers[8].position.lat(), markers[8].position.lng()), weight: 1},
                            {location: new google.maps.LatLng(markers[9].position.lat(), markers[9].position.lng()), weight: .5},
                            {location: new google.maps.LatLng(markers[10].position.lat(), markers[10].position.lng()), weight: .4},
                            {location: new google.maps.LatLng(markers[11].position.lat(), markers[11].position.lng()), weight: .3},
                            new google.maps.LatLng(markers[11].position.lat(), markers[11].position.lng()),
                            {location: new google.maps.LatLng(markers[12].position.lat(), markers[12].position.lng()), weight: .2},
                            new google.maps.LatLng(markers[12].position.lat(), markers[12].position.lng()),
                            {location: new google.maps.LatLng(markers[13].position.lat(), markers[13].position.lng()), weight: .1}
                        ];
                        pointArray = new google.maps.MVCArray(taxiData);
                        heatmap = new google.maps.visualization.HeatmapLayer({
                            data: pointArray,
                            radius: 16,
                            dissipate: false,
                            maxIntensity: 12,
                            gradient: gradient
                        });
                        heatmap.setMap(map);
                    }

                    function toggleHeatmap() {
                        heatmap.setMap(heatmap.getMap() ? null : map);
                    }

                    function changeGradient() {
                        gradient = [
                            'rgba(0, 255, 255, 0)',
                            'rgba(0, 255, 255, 1)',
                            'rgba(0, 191, 255, 1)',
                            'rgba(0, 127, 255, 1)',
                            'rgba(0, 63, 255, 1)',
                            'rgba(0, 0, 255, 1)',
                            'rgba(0, 0, 223, 1)',
                            'rgba(0, 0, 191, 1)',
                            'rgba(0, 0, 159, 1)',
                            'rgba(0, 0, 127, 1)',
                            'rgba(63, 0, 91, 1)',
                            'rgba(127, 0, 63, 1)',
                            'rgba(191, 0, 31, 1)',
                            'rgba(255, 0, 0, 0.50)'
                        ];
                        fillColorArray();
                        heatmap.setOptions({
                            gradient: heatmap.get('gradient') ? null : gradient
                        });
                    }

                    function changeRadius() {
                        heatmap.setOptions({radius: heatmap.get('radius') ? null : 20});
                    }

                    function changeOpacity() {
                        heatmap.setOptions({opacity: heatmap.get('opacity') ? null : 0.8});
                    }



                    $(document).ready(function() {
                        $('#sliderOpacity').slider({min: 0, max: 1, step: 0.1, value: 0.5})
                                .bind("slidechange", function() {
                            //get the value of the slider with this call
                            var o = $(this).slider('value');
                            heatmap.setOptions({opacity: o});
                        });
                    });
                    $(document).ready(function() {
                        $('#sliderRadius').slider({min: 0, max: 30, step: 1, value: 15})
                                .bind("slidechange", function() {
                            //get the value of the slider with this call
                            var o = $(this).slider('value');
                            heatmap.setOptions({radius: o});
                        });
                    });
                    var heatmap, data;
                    var markers2;
                    var nextStore = 0;
                    var year = 1962;
                    var month = 1;
                    var colors = [];
                    var unlock = false;
                    var running = false;
                    function initializeHeat2() {
                        data = new google.maps.MVCArray();
                        heatmap = new google.maps.visualization.HeatmapLayer({
                            map: map,
                            data: data,
                            radius: 16,
                            dissipate: false,
                            maxIntensity: 8,
                            gradient: gradient
                        });
                        nextMonth();
                        nextMonth2();
                        unlock = true;
                        running = true;
                        fillColorArray();
                    }

                    function nextMonth() {
                        while (stores[nextStore].date[0] <= year && stores[nextStore].date[1] <= month) {
                            data.push(new google.maps.LatLng(stores[nextStore].coords[0], stores[nextStore].coords[1]));
                            nextStore++;
                        }
                        if (nextStore < stores.length) {
                            if (month == 12) {
                                month = 1;
                                year++;
                                document.getElementById('year').innerHTML = year;
                            } else {
                                month++;
                                document.getElementById('month').innerHTML = month;
                            }
                            setTimeout(nextMonth, 40);
                        }
                    }



                    function nextMonth2() {

                        while (stores[nextStore].date[0] <= year && stores[nextStore].date[1] <= month) {
                            addStore(stores[nextStore].coords, year, month);
                            nextStore++;
                        }

                        updateColors(year, month);
                        if (nextStore < stores.length) {
                            if (month == 12) {
                                month = 1;
                                year++;
                                document.getElementById('year').innerHTML = year;
                            } else {
                                month++;
                            }
                            setTimeout(nextMonth2, 20);
                        }
                    }

                    var markersByMonth = [];
                    for (var i = 0; i < 12; ++i) {
                        markersByMonth.push([]);
                    }

                    function updateColors(year, month) {
                        markers2 = markersByMonth[month - 1];
                        for (var i = 0, I = markers2.length; i < I; ++i) {
                            var inner = markers2[i];
                            var age = year - inner.year;
                            if (age % 2) {
                                var icon = inner.get('icon');
                                icon.fillColor = colors[age];
                                inner.notify('icon');
                            }
                        }

                    }
                    function removeMarkersSetup() {
                        month = 1;
                        year = 1962;
                        removeMarkers2();
                    }

                    function removeMarkers2() {
                        markers2 = markersByMonth[month - 1];
                        if (month == 12) {
                            month = 1;
                            year++;
                            document.getElementById('year').innerHTML = year;
                            if (year === 2007) {
                                return;
                            }
                        } else {
                            month++;
                            document.getElementById('month').innerHTML = month;
                            for (var i = 0, I = markers2.length; i < I; ++i) {
                                //alert(markers2.length);
                                if (markers2[i]) {
                                    markers2[i].setMap(null);
                                    delete markers2[i];
                                }

                            }


                        }

                        setTimeout(removeMarkers2, 40);
                    }


                    function addStore(coords, year, month) {
                        var location = new google.maps.LatLng(coords[0], coords[1]);
                        var outer = new google.maps.Marker({
                            position: location,
                            clickable: false,
                            icon: {
                                path: google.maps.SymbolPath.CIRCLE,
                                fillOpacity: 0.5,
                                fillColor: colors[0],
                                strokeOpacity: 1.0,
                                strokeColor: colors[0],
                                strokeWeight: 1.0,
                                scale: 0,
                            },
                            optimized: false,
                            zIndex: year,
                            map: map
                        });
                        var inner = new google.maps.Marker({
                            position: location,
                            clickable: true,
                            icon: {
                                path: google.maps.SymbolPath.CIRCLE,
                                fillOpacity: 1.0,
                                fillColor: colors[0],
                                strokeWeight: 0.10,
                                scale: 4
                            },
                            optimized: false,
                            zIndex: year
                        });
                        inner.year = year;
                        google.maps.event.addListener(inner, 'click', function(e) {

                            street = new google.maps.StreetViewPanorama(document.getElementById("street"), {
                                position: new google.maps.LatLng(e.latLng.lat(), e.latLng.lng()),
                                zoomControl: true,
                                pov: {heading: hVal, pitch: 0, zoom: 1},
                                enableCloseButton: false,
                                addressControl: false,
                                panControl: false,
                                linksControl: false
                            });
                            point = new google.maps.LatLng(e.latLng.lat(), e.latLng.lng());
                            $("#message").html("");
                            var service = new google.maps.StreetViewService;
                            service.getPanoramaByLocation(street.getPosition(), 65, function(panoData, status) {
                                processSVData(panoData, status);
                            });
                            street.setVisible(true);
                            var contentString = [
                                '<div id="tabs" style="width:250px;height:200px;">',
                                '<ul>',
                                '<li><a href="#tab-1"><span>One</span></a></li>',
                                '<li><a href="#tab-2"><span>Two</span></a></li>',
                                '<li><a href="#tab-3"><span>Three</span></a></li>',
                                '</ul>',
                                '<div id="tab-1">',
                                '<p>Tab 1</p><div id="pano"></div>',
                                '</div>',
                                '<div id="tab-2">',
                                '<p>Tab 2</p>',
                                '</div>',
                                '<div id="tab-3">',
                                '<p>Tab 3</p>',
                                '</div>',
                                '</div>'
                            ].join('');
                            var infowindow = new google.maps.InfoWindow({
                                content: contentString
                            });
                            google.maps.event.addListener(infowindow, 'domready', function() {
                                $("#tabs").tabs();
                            });
                            infowindow.open(map.getStreetView().getVisible() ?
                                    map.getStreetView() : map, inner);
                        });
                        markersByMonth[month - 1].push(inner);
                        for (var i = 0; i <= 10; i++) {
                            setTimeout(setScale(inner, outer, i / 10), i * 60);
                        }
                    }

                    function setScale(inner, outer, scale) {
                        return function() {
                            if (scale == 1) {
                                outer.setMap(null);
                            } else {
                                var icono = outer.get('icon');
                                icono.strokeOpacity = Math.cos((Math.PI / 2) * scale);
                                icono.fillOpacity = icono.strokeOpacity * 0.5;
                                icono.scale = Math.sin((Math.PI / 2) * scale) * 15;
                                outer.set('icon', icono);
                                var iconi = inner.get('icon');
                                var newScale = (icono.scale < 2.0 ? 0.0 : 2.0);
                                if (iconi.scale != newScale) {
                                    iconi.scale = newScale;
                                    inner.set('icon', iconi);
                                    if (!inner.getMap())
                                        inner.setMap(map);
                                }
                            }
                        };
                    }

                    function fillColorArray() {
                        var max = 198;
                        for (var i = 0; i < 44; i++) {
                            if (i < 11) { // red to yellow
                                r = max;
                                g = Math.floor(i * (max / 11));
                                b = 0;
                            } else if (i < 22) { // yellow to green
                                r = Math.floor((22 - i) * (max / 11));
                                g = max;
                                b = 0;
                            } else if (i < 33) { // green to cyan
                                r = 0;
                                g = max;
                                b = Math.floor((i - 22) * (max / 11));
                            } else { // cyan to blue
                                r = 0;
                                g = Math.floor((44 - i) * (max / 11));
                                b = max;
                            }
                            colors[i] = 'rgb(' + r + ',' + g + ',' + b + ')';
                        }
                    }

    </script>


</body>
</html>

