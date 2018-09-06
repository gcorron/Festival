<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="FestivalEntry.Admin " %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        tr:nth-child(even) {
            background-color: #dddddd;
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
            <h3 class="text-center">Available People</h3>
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
                    <td><input type="radio" name="chooselocation" value="<%:location.LocationId %>">  <%: GetPersonName(location.ContactId)  %></td>
                </tr>
                <% } %>
            </table>
        </div>
        <div class="col-sm-2 center-block">
            <button id="assign" class="btn-primary center-block">Assign Person</button>
            <button id="newperson" class="btn-primary center-block">New Person</button>
        </div>
        <div class="col-sm-3">
            <table>
                <tr>
                    <th>Name</th>
                </tr>
                <% foreach (var person in People)
                    { %>
                <tr>
                    <td><input type="radio" name="chooseperson" value="<%:person.Key %>"><%: person.Value.FullName %></td>
                </tr>
                <% } %>
            </table>
        </div>


    </div>
</asp:Content>
