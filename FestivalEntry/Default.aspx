<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="FestivalEntry._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>National Music Festival</h1>
        <p class="lead">The NFMC Festivals Program is designed to give Junior (age 18 and younger)
            and Adult member musicians of all abilities the opportunity to perform and receive
            a yearly evaluation in a non-competitive environment.</p>
        <p><a href="http://www.nfmc-music.org/festival/" class="btn btn-primary btn-lg">Learn more &raquo;</a></p>
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2>Festival Program App</h2>
            <p>
                This App is for NFMC Festival participating teachers and administrators.
                Here, they can enroll students and manage their entries, ratings, and awards.
            </p>
            <p>
                <a class="btn btn-default" href="http://www.nfmc-music.org/festival/">Learn more &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Sign In</h2>
            <p>
                Participating teachers and administrators will receive login instructions by email.
            </p>
        </div>
        <div class="col-md-4">
            <h2>Participation</h2>
            <p>
                Teachers can contact their local affiliate for more information.
            </p>
            <p>
                <a class="btn btn-default" href="http://www.nfmc-music.org/festival/">Learn more &raquo;</a>
            </p>
        </div>
    </div>

</asp:Content>
