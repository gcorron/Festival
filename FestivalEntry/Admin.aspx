﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="FestivalEntry.Admin " %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
            margin: 5px;
        }

        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        tr:nth-child(even) {
            background-color: #dddddd;
        }

        .hide {
            display: none;
        }

        .well {
            margin: 5px;
        }

        .clear {
            clear: both;
        }

        .modalDialog:target {
            opacity: 1;
            pointer-events: auto;
        }

        .modalDialog > div {
            width: 800px;
            position: relative;
            margin: 10% auto;
            padding: 5px 20px 13px 20px;
            border-radius: 10px;
            background: #fff;
            background: -moz-linear-gradient(#fff, #999);
            background: -webkit-linear-gradient(#fff, #999);
            background: -o-linear-gradient(#fff, #999);
        }

        .modalDialog {
            position: fixed;
            font-family: Arial, Helvetica, sans-serif;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            background: rgba(0,0,0,0.8);
            z-index: 99999;
            opacity: 0;
            -webkit-transition: opacity 400ms ease-in;
            -moz-transition: opacity 400ms ease-in;
            transition: opacity 400ms ease-in;
            pointer-events: none;
        }

        .close {
            background: #606061;
            color: #FFFFFF;
            line-height: 25px;
            position: absolute;
            right: -12px;
            text-align: center;
            top: -10px;
            width: 24px;
            text-decoration: none;
            font-weight: bold;
            -webkit-border-radius: 12px;
            -moz-border-radius: 12px;
            border-radius: 12px;
            -moz-box-shadow: 1px 1px 3px #000;
            -webkit-box-shadow: 1px 1px 3px #000;
            box-shadow: 1px 1px 3px #000;
        }

            .close:hover {
                background: #00d9ff;
            }

        .centered {
            text-align: center;
        }

        a.disabled {
            opacity: 50;
            pointer-events: none;
        }
    </style>
    <script>

    var AdminApp = (function () {

        myStorage = new classStorage();
        var pendingKey = 'pending';
        getPeople();

        return {
            fillSlot: function () {
                pendingRow = $('input[name=chooseLocation]:checked').closest('tr');

                var locationId = $('input[name=chooseLocation]:checked').val;
                var personId = $('input[name=choosePerson]:checked').val;

                var location = myStorage.get(locationKey(locationId));
                var locationName = location.LocationName;
                var personName = fullName(myStorage.get(locationKey(personId)));
                var message;
                if (location.ContactId == null) {
                    message = 'Assign ' + personName + ' to ' + locationName ? ';
                }
                else {
                    var oldPersonName = fullName(myStorage.get(locationKey(location.ContactId)));
                    message = 'Replace ' + oldPersonName + ' with ' + personName + ' for ' + locationName + '?';
                }
                if (confirm(message)) {
                    location.ContactId = personId;
                    myStorage.set(pendingKey, location);
                    $.ajax({
                        type: "POST",
                        url: "Admin.aspx/UpdateLocation",
                        data: JSON.stringify(location),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: onUpdateLocationSuccess,
                        failure: AJAXFailure,
                        error: AJAXFailure
                    });
                }
            },

            editPerson: function (mode) {
                var id = (mode === 'A' ? 0 : $('input[name=choosePerson]:checked').val());
                populatePerson(id);
                hide('.no-new, #submitError');
                location.hash = "#modal";
            },

            updatePerson: function () {
                $.ajax({
                    type: "POST",
                    url: "Admin.aspx/UpdatePerson",
                    data: formPersonJson(),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: onUpdatePersonSuccess,
                    failure: onUpdatePersonFailure,
                    error: onUpdatePersonFailure
                });
            },

            enableFill: function () {
                if ($('input[name="chooseLocation"]:checked').val())
                    if ($('input[name="choosePerson"]:checked').val())
                        enableButton('fill');
            },

            enableEditAndFill: function () {
                enableButton('edit');
                this.enableFill();
            }

        };

        function onUpdateLocationSuccess(response) {
            location = myStorage.get(pendingKey);
            myStorage.set(locationKey(location.LocationId));
            myStorage.delete(pendingKey);
            person = myStorage.get(personKey(location.ContactId));
            $('#' + locationKey(location.LocationId)).children()[2].innerText(fullName(person));
        }

        function onUpdatePersonSuccess(response) {
            person = JSON.parse(response.d);
            storeAndRender2(person);
            location.hash = "#close";
        }

        function onUpdatePersonFailure(response) {
            $('#serverError').text(parseResponse(response));
            show('#submitError');

        }

        /* retrieve people and locations from server, display, and save the objects  */
        /* so that we don't have to go back to the server while this page is loaded */

        function getPeople() {
            $.ajax({
                type: "POST",
                url: "Admin.aspx/GetPeople",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: storeAndRenderPeople,
                failure: AJAXFailure,
                error: AJAXFailure
            });
        }

        function AJAXFailure(response) {
            alert(parseResponse(response));
        }

        function parseResponse(response) {
            if (response.d) {
                try {
                    return JSON.parse(response.d);
                }
                catch (e) {
                    return response.d;
                }
            }
            else if (response.responseJSON) {
                return response.responseJSON.Message;
            }
            else if (response.responseText) {
                return response.responseText;
            }
            else {
                return 'No response from server.';
            }
        }

        function populatePerson(id) {
            var key = personKey(id);
            var person = myStorage.get(key);
            if (!person) {
                var mess = key + ' not found!';
                alert(mess);
                throw mess;
            }
            person = JSON.parse(person);
            for (var name in person) {
                control = $('#' + name);
                if (control) {
                    if ($(control).attr('type') === 'checkbox')
                        control.prop('checked', person[name]);
                    else
                        control.val(person[name]);
                }
            }
        }

        function storeAndRenderPeople(response) {
            //localStorage.clear();

            var array = JSON.parse(response.d)
            var people = array[0];
            var locations = array[1];
            people.forEach(storeAndRender2);

            var table = document.getElementById('locations');
            locations.forEach(displayLocation);


            function displayLocation(location) {
                var row = document.getElementById('blankLocation');
                var clone = row.cloneNode(true);
                clone.getElementsByTagName('td')[0].innerText = location.LocationName;
                clone.getElementsByTagName('input')[0].setAttribute('id', location.LocationId);
                clone.getElementsByTagName('td')[2].innerText = contactName(location.ContactId);
                clone.getElementsByTagName('tr')[0].setAttribute("id", locationKey(location.LocationId));
                clone.removeAttribute('class');
                table.append(clone);
            }
        }

        function storeAndRender2(person) {
            if (person.Id)
                appendPerson(person);
            myStorage.set(personKey(person.Id), JSON.stringify(person));
        }

        function appendPerson(person) {
            /* remove existing row if any*/
            var row = document.getElementById(personKey(person.Id));
            if (row) {
                row.remove();
            }

            row = document.getElementById('blankperson'); // find blank to copy
            var table = document.getElementById('people'); // find table body to append to
            var clone = row.cloneNode(true); // true means get all descendant nodes too
            clone.setAttribute('id', personKey(person.Id));
            clone.getElementsByTagName('input')[0].setAttribute('value', person.Id);
            clone.getElementsByTagName('td')[1].innerText = fullName(person);
            clone.removeAttribute('class');
            clone.setAttribute('name', (person.LastName + ' ' + person.FirstName).toLowerCase()); //for putting edits in proper order


            for (var i = 0; (row = table.rows[i]); i++) {
                if (row.getAttribute('name')) {
                    if (clone.getAttribute('name') < row.getAttribute('name')) {
                        row.insertAdjacentElement('beforebegin', clone);
                        return;
                    }
                }
            }

            table.append(clone); // add new row to end of tablebody
        }

        function enableButton(buttonName) {
            document.getElementById(buttonName).classList.remove('disabled');
        }

        function personKey(id) {
            return 'person' + id;
        }

        function classStorage() {
            var store = {};

            this.set = function (key, datum) {
                store[key] = datum;
            };

            this.get = function (key) {
                return store[key];
            };

            this.delete = function (key) {
                delete store[key];
            };
        }


        function formPersonJson() {
            person = JSON.parse(myStorage.get(personKey(0)));
            for (var name in person) {
                control = $('#' + name);
                if (control) {
                    if ($(control).attr('type') === 'checkbox')
                        person[name] = control.prop('checked');
                    else
                        person[name] = control.val();
                }

            }
            return JSON.stringify({ person: person });
        }

        function show(selector) {
            $(selector).removeClass('hide');
        }

        function hide(selector) {
            $(selector).addClass('hide');
        }

        function contactName(id) {
            if (id == null) {
                return '';
            }
            person = myStorage.get(personKey(id));
            return fullName(person);
        }

        function fullName(person) {
            return person.FirstName + ' ' + person.LastName;
        }

        function locationKey(id) {
            return 'location' + id;
        }
    })();
    </script>

    <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
        <p class="text-danger">
            <asp:Literal runat="server" ID="FailureText" />
        </p>
    </asp:PlaceHolder>

    <!-- Locations -->
    <input id="LocationId" type="hidden" value="<%:TheUser.LocationId %>" />
    <div style="height: 20px"></div>
    <div class="row">
        <div class="col-sm-6 well">
            <h4><%: TheUser.LocationName %></h4>
            <table>
                <thead>
                    <tr>
                        <th><%: TheUser.LocationDomain%></th>
                        <th style="width: 50px"><a id="fill" class="btn btn-xs btn-primary centered disabled"
                            onclick="AdminApp.fillSlot()">Fill</a></th>
                        <th><%: TheUser.LocationRoles %></th>
                    </tr>
                </thead>
                <tbody id="locations">
                    <tr id="blankLocation" class="hide">
                        <td></td>
                        <td class="centered">
                            <input type="radio" id="chooseLocation" name="chooseLocation" value="0" onclick="AdminApp.enableFill()">
                        </td>
                        <td></td>
                    </tr>
                </tbody>
            </table>
        </div>


        <!-- People -->
        <div class="col-sm-3 well">
            <div class="row">
                <div class="col-sm-4">
                    <h4>People</h4>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th style="width: 50px; text-align: center">
                            <a class="btn btn-xs btn-primary disabled" id="edit" onclick="AdminApp.editPerson('E')">Edit</a>
                        </th>
                        <th>Name
                        <div class="col-sm-2 pull-right" style="margin-right: 10px;">
                            <a class="btn btn-xs btn-primary" onclick="AdminApp.editPerson('A')">Add</a>
                        </div>
                        </th>
                    </tr>
                </thead>
                <tbody id="people">
                    <tr id="blankperson" class="hide">
                        <td class="centered">
                            <input type="radio" id="choosePerson" name="choosePerson" value="0" onclick="AdminApp.enableEditAndFill()">
                        </td>
                        <td>Name2</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Edit People modal -->
    <div id="modal" class="modalDialog">
        <div class="row">
            <!-- not visible until the Add button is clicked -->
            <div class="well">
                <div class="col-sm-6">
                    <div class="form-group">
                        <label class="control-label" for="first">First Name:</label>
                        <input class="form-control" type="text" id="FirstName" placeholder="Enter First Name" name="FirstName" maxlength="50">
                    </div>
                    <div class="form-group">
                        <label class="control-label" for="last">Last Name:</label>
                        <input class="form-control" type="text" id="LastName" placeholder="Enter Last Name" name="LastName" maxlength="50">
                    </div>
                    <div class="form-group">
                        <label class="control-label" for="email">Email:</label>
                        <input class="form-control" type="email" id="Email" placeholder="Enter Email" name="Email" maxlength="50">
                    </div>
                    <div class="form-group">
                        <label class="control-label" for="phone">Phone:</label>
                        <input class="form-control" type="tel" id="Phone" placeholder="Enter Phone" name="Phone" maxlength="50">
                    </div>

                </div>
                <div class="col-sm-6">
                    <!-- RH half -->
                    <div id="instrumentgroup" class="form-group hide">
                        <label class="control-label" for="instrument">Instrument Category:</label>
                        <select class="form-control" id="Instrument" name="Instrument">
                            <option value="-">Select ...</option>
                            <option value="P">Piano</option>
                            <option value="S">Strings</option>
                            <option value="V">Voice</option>
                            <option value="W">Winds</option>
                        </select>
                    </div>

                    <div class="checkbox no-new">
                        <label>
                            <input type="checkbox" value="" name="Available" id="Available">Active</label>
                    </div>

                    <input id="Id" name="Id" class="hide" />

                    <div class="form-group">
                        <a class="btn btn-default" onclick="AdminApp.updatePerson()">Submit</a>
                        <a class="btn btn-default" href="#close" title="Close">Cancel</a>
                    </div>
                    <div class="alert alert-danger" id="submitError">
                        <strong>Server error! </strong><span id="serverError"></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
</asp:Content>
