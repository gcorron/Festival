﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="FestivalEntry.Admin " %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="Scripts/Admin.js"></script>
    <script src="Scripts/jquery.validate.min.js"></script>

    <link href="Content/Festival.css" rel="stylesheet" />

    <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
        <p class="text-danger">
            <asp:Literal runat="server" ID="FailureText" />
        </p>
    </asp:PlaceHolder>

    <!-- User data needed for some operations -->
    <input id="LocationId" type="hidden" value="<%:TheUser.LocationId %>" />
    <input id="RoleType" type="hidden" value="<%:TheUser.RoleType %>" />

    <!-- Locations -->

    <div style="height: 20px"></div>
    <div class="row">
        <div class="col-sm-6 well">
            <div class="row">
 
                <div class="col-sm-4">
                    <h4><%: TheUser.LocationName %> <%: TheUser.LocationDomain %></h4>
                </div>
                <div class="col-sm-2"></div>
                <div id="locationsAlert" class="col-sm-5 alert alert-info">
                    Click on any row to fill or vacate position.
                </div>
            </div>
            <table>
                <thead>
                    <tr>
                        <th><%: TheUser.LocationSlot%></th>
                        <th><%: TheUser.LocationRoleAssignments %></th>
                    </tr>
                </thead>
                <tbody id="locations">
                    <tr id="blankLocation" class="mousePointer nodisplay" onclick="AdminApp.fillOrVacate(this)">
                        <td></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- People -->
        <div class="col-sm-4 well">
            <div class="row">
                <div class="col-sm-4">
                    <h4><%:TheUser.LocationRoleAssignments %> Pool</h4>
                </div>
                <div class="col-sm-1"></div>
                <div id="peopleAlert" class="col-sm-7 alert alert-info">
                    Hover over name for details, or<br />
                    click name to edit.
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>
                            <div class="row">
                                <div class="col-sm-4">Person</div>
                                <div class="col-sm-4 pull-right">
                                    <a id="addPerson" class="btn btn-xs btn-primary" onclick="AdminApp.editPerson(0);">Add New</a>
                                </div>
                            </div>
                        </th>
                        <th class="centered"><span id="starsKey" title="Stars" class="glyphicon glyphicon-question-sign" data-container="body"
                            data-html="true" data-toggle="popover" data-trigger="hover" data-content="Test"></span>
                        </th>
                    </tr>
                </thead>
                <tbody id="people">
                    <tr id="blankPerson" class="mousePointer nodisplay">
                        <td>
                            <a onclick="AdminApp.editPerson($(this).data('pid'));" title="Contact info" data-toggle="popover" data-trigger="hover" data-content="Some content">Hover over me</a>
                        </td>
                        <td class="centered">*</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Edit People modal -->
    <div class="modal fade" id="modalEdit" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="well">
                    <div class="row">

                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label" for="first">First Name:</label>
                                <input class="form-control" type="text" id="FirstName" placeholder="Enter First Name"
                                    name="FirstName" maxlength="50" required>
                            </div>
                            <div class="form-group">
                                <label class="control-label" for="last">Last Name:</label>
                                <input class="form-control" type="text" id="LastName" placeholder="Enter Last Name"
                                    name="LastName" minlength="2" maxlength="50" required>
                            </div>
                            <div class="form-group">
                                <label class="control-label" for="email">Email:</label>
                                <input class="form-control" type="email" id="Email" placeholder="Enter Email"
                                    name="Email" maxlength="50" required>
                            </div>
                            <div class="form-group">
                                <label class="control-label" for="phone">Phone:</label>
                                <input class="form-control" type="tel" id="Phone" placeholder="Enter Phone"
                                    name="Phone" maxlength="50" required>
                            </div>

                        </div>
                        <div class="col-sm-6">
                            <!-- RH half -->
                            <div id="instrumentGroup" class="form-group">
                                <label class="control-label" for="instrument">Instrument Category:</label>
                                <select class="form-control" id="Instrument" name="Instrument" required>
                                    <option value="" disabled selected hidden>Select ...</option>
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
                                <a class="btn btn-default" onclick="AdminApp.updatePerson()">Save</a>
                                <a class="btn btn-default" onclick="$('#modalEdit').modal('hide')" title="Close">Cancel</a>
                                <a id="deleteButton" class="btn btn-warning" onclick="AdminApp.deletePerson()" title="Delete"
                                    data-toggle="popover" data-trigger="hover" data-content="You can delete only people who are not assigned to a position.">Delete</a>
                            </div>
                            <div class="alert alert-danger" id="submitError">
                                <strong>Server error! </strong><span id="serverError"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="infoModal" role="dialog">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Modal Header</h4>
                </div>
                <div class="modal-body">
                    <p>This is a small modal.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <div id="cancelAssignment" class="hide">
        <a>&lt; Cancel this assignment ></a>
    </div>


    <div class="clear"></div>
</asp:Content>
