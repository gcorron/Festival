<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Chair.aspx.cs" Inherits="FestivalEntry.Chair" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><%: Page.Title %> - Festival Entry App</title>

    <asp:PlaceHolder runat="server">
        <%: Scripts.Render("~/bundles/modernizr") %>
    </asp:PlaceHolder>
    <webopt:BundleReference runat="server" Path="~/Content/css" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />


</head>
<body onhashchange="myFunction()">
    <form id="form1" runat="server">
           <asp:ScriptManager runat="server">
            <Scripts>
                <%--To learn more about bundling scripts in ScriptManager see https://go.microsoft.com/fwlink/?LinkID=301884 --%>
                <%--Framework Scripts--%>
                <asp:ScriptReference Name="MsAjaxBundle" />
                <asp:ScriptReference Name="jquery" />
                <asp:ScriptReference Name="bootstrap" />
                <asp:ScriptReference Name="WebForms.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebForms.js" />
                <asp:ScriptReference Name="WebUIValidation.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebUIValidation.js" />
                <asp:ScriptReference Name="MenuStandards.js" Assembly="System.Web" Path="~/Scripts/WebForms/MenuStandards.js" />
                <asp:ScriptReference Name="GridView.js" Assembly="System.Web" Path="~/Scripts/WebForms/GridView.js" />
                <asp:ScriptReference Name="DetailsView.js" Assembly="System.Web" Path="~/Scripts/WebForms/DetailsView.js" />
                <asp:ScriptReference Name="TreeView.js" Assembly="System.Web" Path="~/Scripts/WebForms/TreeView.js" />
                <asp:ScriptReference Name="WebParts.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebParts.js" />
                <asp:ScriptReference Name="Focus.js" Assembly="System.Web" Path="~/Scripts/WebForms/Focus.js" />
                <asp:ScriptReference Name="WebFormsBundle" />
                <%--Site Scripts--%>
            </Scripts>
        </asp:ScriptManager>
        <div>
        </div>
    </form>
    <script src="Scripts/Chair.js"></script>

    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <div class="navbar-brand">Festival Chair</div>
            </div>
            <ul id="navbar" class="nav navbar-nav">
                <li class="active"><a href="#" onclick="changePart('home')">Home</a></li>
                <li><a href="#" onclick="changePart('event')">Event</a></li>
                <li><a href="#" onclick="changePart('teachers')">Teachers</a></li>
                <li><a href="#" onclick="changePart('entries')">Entries</a></li>
                <li><a href="#" onclick="changePart('schedule')">Schedule</a></li>
                <li><a href="#" onclick="changePart('ratings')">Ratings</a></li>
            </ul>
        </div>
    </nav>
    <div class="container" style="display:none">
        <div class="content" id="home">
            <p>This is home</p>
        </div>
        <div class="content" id="event">
            <p>This is event!</p>
        </div>
        <div class="content" id="teachers">
            <p>This is teachers</p>
        </div>
        <div class="content" id="entries">
            <p>This is entries</p>
        </div>
        <div class="content" id="schedule">
            <p>This is schedule</p>
        </div>
        <div class="content" id="ratings">
            <p>This is ratings</p>
        </div>
    </div>


</body>
</html>

