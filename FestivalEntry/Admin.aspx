<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="FestivalEntry.Admin " %>

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
          opacity:50;
          pointer-events: none;
        }

    </style>
    <script>
        $(document).ready(function () {
            getPeople();
        });

        function ShowCurrentTime() {
            $.ajax({
                type: "POST",
                url: "Admin.aspx/GetCurrentTime",
                data: '{name: "Greg" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    alert(response.d);
                }
            });
        }
        function OnSuccess(response) {
            alert(response.d);
        }

        function updatePerson() {
            $.ajax({
                type: "POST",
                url: "Admin.aspx/UpdatePerson",
                data: InputJSON($('.form-control')),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    alert(response.d);
                }
            });

            location.hash = "#close";
        }

        function addPerson() {
            populatePerson(0);
            location.hash = "#modal";
        }

        function populatePerson(id) {
            var key = personKey(id);
            var person = localStorage.getItem(key);
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

        function appendPerson(person) {
            var row = document.getElementById('blankperson'); // find row to copy
            var table = document.getElementById('people'); // find table to append to
            var clone = row.cloneNode(true); // copy children too
            clone.getElementsByTagName('input')[0].setAttribute('value', person.id);
            clone.getElementsByTagName('td')[1].textContent = person.FirstName + ' ' + person.LastName;
            clone.removeAttribute("style"); //make it visible
            clone.removeAttribute("id"); //avoid id collision
            table.appendChild(clone); // add new row to end of tablebody
        }


        /* retrieve people from server and save to local storage */
        function getPeople() {
            $.ajax({
                type: "POST",
                url: "Admin.aspx/GetPeople",
                data: '{locationId: "' + $('#LocationId').val() + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: storeAndRenderPeople,
                failure: function (response) {
                    alert(response.d);
                }
            });
        }

        function storeAndRenderPeople(response) {
            localStorage.clear();
            var people = JSON.parse(response.d);
            people.forEach(storeAndRender2);

            function storeAndRender2(person) {
                if (person.Id)
                    appendPerson(person);
                localStorage.setItem(personKey(person.Id),JSON.stringify(person));
            }
        }

        function enableButton(buttonName) {
             document.getElementById(buttonName).classList.remove('disabled');
        }

        function enableFill() {
            if ($('input[name="chooseLocation"]:checked').val())
                if ($('input[name="choosePerson"]:checked').val())
                    enableButton('fill');
        }

        function enableEditAndFill() {
            enableButton('edit');
            enableFill();
        }

        function personKey(id) {
            return 'person' + id;
        }

    </script>

    <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
        <p class="text-danger">
            <asp:Literal runat="server" ID="FailureText" />
        </p>
    </asp:PlaceHolder>

    <input id="LocationId" type="hidden" value="<%:TheUser.LocationId %>" />
    <div style="height: 20px"></div>
    <div class="row">
        <div class="col-sm-6 well">
            <h4><%: TheUser.LocationName %></h4>
            <table>
                <tr>
                    <th><%: TheUser.LocationDomain%></th>
                    <th style="width:50px"><a id="fill" class="btn btn-xs btn-primary centered disabled"
                        onclick="fillSlot()">Fill</a></th>
                    <th><%: TheUser.LocationRoles %></th>
                </tr>
                <% foreach (var location in Locations)
                    {%>
                <tr>
                    <td><%: location.LocationName %></td>
                    <td class="centered">
                        <input type="radio" id="chooseLocation" name="chooseLocation" value="<%:location.LocationId %>"
                            onclick="enableFill()"></td>
                    <td>
                        <%: GetPersonName(location.ContactId)  %>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
        <div class="col-sm-3 well">
            <div class="row">
                <div class="col-sm-4">
                    <h4>People</h4>
                </div>
            </div>

            <table id="people">
                <tr>
                    <th style="width:50px; text-align:center"">
                        <a class="btn btn-xs btn-primary disabled" id="edit" onclick="editPerson()">Edit</a></th>
                    <th>Name
                        <div class="col-sm-2 pull-right" style="margin-right: 10px;">
                            <a class="btn btn-xs btn-primary" onclick="addPerson()">Add</a>
                        </div>
                    </th>
                </tr>
                <tr id="blankperson" style="visibility: collapse">
                    <td class="centered">
                        <input type="radio" id="choosePerson" name="choosePerson" value="0" onclick="enableEditAndFill()">
                    </td>
                    <td>Name</td>
                </tr>
            </table>
        </div>
    </div>

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
                    <div id="instrumentgroup" class="form-group">
                        <label class="control-label" for="instrument">Instrument Category:</label>
                        <select class="form-control" id="Instrument" name="Instrument">
                            <option value="-">Select ...</option>
                            <option value="P">Piano</option>
                            <option value="S">Strings</option>
                            <option value="V">Voice</option>
                            <option value="W">Winds</option>
                        </select>
                    </div>

                    <div class="checkbox">
                    <label><input type="checkbox" value="" name="Available" id="Available">Active</label>
                    </div>

                    <input id="Id" name="Id" style="visibility: collapse" />

                    <div class="form-group" style="position: relative; top: 50px">
                        <a class="btn btn-default" onclick="UpdatePerson();">Submit</a>
                        <a class="btn btn-default" href="#close" title="Close">Cancel</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
</asp:Content>
