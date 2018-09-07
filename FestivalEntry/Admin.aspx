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
    </style>

    <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
        <p class="text-danger">
            <asp:Literal runat="server" ID="FailureText" />
        </p>
    </asp:PlaceHolder>

    <div style="height: 20px"></div>
    <div class="row">
        <div class="col-sm-6 well">
            <h4><%: TheUser.LocationName %></h4>
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
                        <a class="btn btn-xs btn-primary" onclick="<%:$"function fillSlot({location.LocationId});" %>"><%:location.ContactId is null ? "Fill":"Replace" %></a>
                        <%: GetPersonName(location.ContactId)  %></td>
                </tr>
                <% } %>
            </table>
        </div>
        <div class="col-sm-3 well">
            <div class="row">
                <div class="col-sm-4">
                    <h4>People</h4>
                </div>
                <div class="col-sm-2 pull-right">
                    <a class="btn btn-xs btn-primary" href="#modal">Add</a>
                </div>
            </div>

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


    <div id="modal" class="row modalDialog">
        <!-- not visible until the Add button is clicked -->
        <div class="well col-sm-6">
            <div class="col-sm-6">
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
            <div class="col-sm-6">
                <!-- RH half -->
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

                <div class="form-group">
                    <label class="control-label" for="active">Festival Status</label>
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" name="active">
                            Active</label>
                    </div>
                </div>

                <div class="form-group" style="position: relative; top: 50px">
                    <a class="btn btn-default">Submit</a>
                    <a class="btn btn-default" href="#close" title="Close">Cancel</a>
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
</asp:Content>
