<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="FestivalEntry.Admin " %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="Scripts/Admin.js" type="text/javascript"></script>
    <link href="Content/Admin.css" rel="stylesheet" />

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
                        <th style="width: 50px">
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-primary btn-xs dropdown-toggle" data-toggle="dropdown">
                                    Change
                                </button>
                                <div class="dropdown-menu">
                                    <a id="fill" class="dropdown-item disabled" onclick="AdminApp.fillSlot()">Fill</a>
                                    <a id="remove" class="dropdown-item disabled" onclick="AdminApp.fillSlot()">Remove</a>
                                </div>
                            </div>
                        </th>
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
            <h4>People</h4>
            <table>
                <thead>
                    <tr>
                        <th style="width: 50px; text-align: center">
                            <div class="btn-group" role="group">
                                <a class="btn btn-xs btn-primary disabled" id="edit" onclick="AdminApp.editPerson('E')">Edit</a>
                                <a class="btn btn-xs btn-primary" onclick="AdminApp.editPerson('A')">Add</a>
                            </div>
                        </th>
                        <th>Name
                        </th>
                        <th class="text-right"></th>
                    </tr>
                </thead>
                <tbody id="people">
                    <tr id="blankPerson" class="hide">
                        <td class="centered">
                            <input type="radio" id="choosePerson" name="choosePerson" value="0" onclick="AdminApp.enableEditAndFill()">
                        </td>
                        <td>Name2</td>
                        <td class="centered">*</td>
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
