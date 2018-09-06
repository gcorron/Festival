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

        form {
            class ="form-horizontal";
        }
    </style>

    <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
        <p class="text-danger">
            <asp:Literal runat="server" ID="FailureText" />
        </p>
    </asp:PlaceHolder>

    <div class="row">
        <div class="col-sm-6">
            <h3 class="text-center"><%: TheUser.LocationName %></h3>
        </div>
        <div class="col-sm-3 col-sm-offset-2">
            <h3 class="text-center">People</h3>
        </div>
    </div>


    <div class="row">
        <div class="col-sm-6">
            <table>
                <tr>
                    <th><%: TheUser.LocationDomain%></th>
                    <th><%: TheUser.LocationRoles %></th>
                </tr>
                <% foreach (var location in Locations)
                    {%>
                <tr>
                    <td><%: location.LocationName %></td>
                    <td>
                        <input type="radio" name="chooselocation" value="<%:location.LocationId %>">
                        <%: GetPersonName(location.ContactId)  %></td>
                </tr>
                <% } %>
            </table>
        </div>
        <div class="col-sm-2 center-block">
            <div class="btn-group-vertical center-block">
                <button id="assign" class="btn btn-primary">Assign Person</button>
                <button id="newperson" class="btn btn-primary">New Person</button>
            </div>
        </div>
        <div class="col-sm-3">
            <table>
                <tr>
                    <th>Name</th>
                </tr>
                <% foreach (var person in People)
                    { %>
                <tr>
                    <td>
                        <input type="radio" name="chooseperson" value="<%:person.Id %>"><%: person.FullName %></td>
                </tr>
                <% } %>
            </table>
        </div>
    </div>
    <div class="row well">
        <div class="col-sm-4">
            <div class="form-group">
                <label class="control-label" for="first">First Name:</label>
                <input class="form-control" type="text" id="first" placeholder="Enter First Name" name="first" maxlength="50">
            </div>
            <div class="form-group">
                <label class="control-label" for="last">Last Name:</label>
                <input class="form-control" type="text" id="last" placeholder="Enter Last Name" name="last" maxlength="50">
            </div>
            <div class="form-group">
                <label class="control-label" for="email">Email:</label>
                <input class="form-control" type="email" id="email" placeholder="Enter Email" name="email" maxlength="50">
            </div>
            <div class="form-group">
                <label class="control-label" for="phone">Phone:</label>
                <input class="form-control" type="tel" id="phone" placeholder="Enter Phone" name="phone" maxlength="50">
            </div>

        </div>
        <div class="col-sm-4">
            <!-- RH half -->
            <div class="checkbox">
                <label>
                    <input type="checkbox" name="active">
                    Active</label>
            </div>
            <div id="instrumentgroup" class="form-group">
                <label class="control-label" for="instrument">Instrument Category:</label>
                <select class="form-control" id="instrument" name="instrument">
                    <option value=" ">Select ...</option>
                    <option value="P">Piano</option>
                    <option value="S">Strings</option>
                    <option value="V">Voice</option>
                    <option value="W">Winds</option>
                </select>
            </div>

            <div class="form-group" style="position:relative">
                <div class="col-sm-offset-2 col-sm-10">
                    <button class="btn btn-primary">Submit</button>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
