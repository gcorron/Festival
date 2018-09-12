"use strict";

var AdminApp = (function () {

    $(document).ready(setupPopover());
    var myStorage = new classStorage();
    var pendingLocation;
    var personAvailIcon = '<span class="glyphicon glyphicon-star-empty"></span>';
    var personBusyIcon = '<span class="glyphicon glyphicon-star"></span>';

    getData();

    return {
        fillOrVacate: function (elt) {
            var person;
            var location = $(elt).data('lid');
            var keys = {};
            var tlocation;

            if (assignmentMode()) {
                cancelAssignmentMode();
                return;
            }
            if (location.ContactId) {
                person = myStorage.getPerson(location.ContactId);
                if (confirm('Remove ' + fullName(person) + ' from ' + location.LocationName + '?')) {
                    location.ContactId = 0;
                    pendingLocation = location;
                    updateLocation();
                }
            }
            else {
                //check how many are eligibile to fill

                myStorage.begin(); //create keys to search
                while ((tlocation = myStorage.nextLocation())) {
                    if (tlocation.ContactId) {
                        keys['p' + tlocation.ContactId] = 'Y';
                    }
                }

                // search for available people not assigned
                myStorage.begin();

                var count = 0;
                while ((person = myStorage.nextPerson()) && count <= 2) {
                    if (person.Available && !keys['p' + person.Id]) {
                        eligibleName = fullName(person);
                        count++;
                    }
                }

                switch (count) {
                    case 0: {
                        showModal('Fill vacancy', 'No people are eligile right now.\nA person can only fill one position, and must have available status.\n' +
                            'Add a person or edit one who is not assigned,\nchanging their available status.');
                        return;
                    }
                    case 1: {
                        if (confirm('One person is eligible right now. Assign ' + eligibleName + ' to ' + location.LocationName + '?')) {
                            return;
                        }
                        return;
                    }
                    default: {
                        //showModal('Fill vacancy', 'Select a person to fill this position, then click "Assign"');
                        changeAlertBox('#locationsAlert', 'Now, select a person with a ' + personAvailIcon + ' or click the cancel link.');
                        hide('#peopleAlert');
                        hide('#addPerson');
                        $(elt).children('td')[1].append($('#cancelAssignment > a')[0]); //move the the cancel link out of the invisible div
                        pendingLocation = location;
                        return;
                    }
                }
            }
        },

        editPerson: function (id) {
            var person;

            if (assignmentMode()) {
                person = myStorage.getPerson(id);
                if (confirm('Assign ' + fullName(person) + ' to ' + pendingLocation.LocationName + '?')) {
                    pendingLocation.ContactId = id;
                    cancelAssignmentMode();
                    updateLocation();
                }
                return;
            }
            else {
                populatePerson(id);
                hide('.no-new, #submitError');
                if (id !== 0) {
                    show('.no-new');
                }
                location.hash = "modalEdit";
            }
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
        }

    };

    function updateLocation() {
        $.ajax({
            type: "POST",
            url: "Admin.aspx/UpdateLocation",
            data: JSON.stringify({ location: pendingLocation }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: onUpdateLocationSuccess,
            failure: onAJAXFailure,
            error: onAJAXFailure
        });
    }

    function onUpdateLocationSuccess(response) {
        myStorage.setLocation(pendingLocation);
        renderTables();
    }

    function onUpdatePersonSuccess(response) {
        var person = JSON.parse(response.d);
        myStorage.setPerson(person);
        renderTables();
        location.hash = "#closemodal";
    }

    function onUpdatePersonFailure(response) {
        $('#serverError').text(parseResponse(response));
        show('#submitError');

    }

    function cancelAssignmentMode() {
        $('#cancelAssignment').append($('#locations').find('a')[0]); // move the cancel link back into invisible div
        restoreAlertBox('#locationsAlert');
        show('#peopleAlert');
        show('#addPerson');
    }

    /* retrieve people and locations from server, display, and save the objects  */
    /* so that we don't have to go back to the server while this page is loaded */

    function getData() {
        $.ajax({
            type: "POST",
            url: "Admin.aspx/GetPeople",
            data: '{}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: onGetDataSuccess,
            failure: onAJAXFailure,
            error: onAJAXFailure
        });
    }


    function onAJAXFailure(response) {
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
        var person = myStorage.getPerson(id);
        var mess;
        var control;

        if (!person) {
            mess = + 'person ' + id + ' not found!';
            alert(mess);
            throw mess;
        }

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

    function onGetDataSuccess(response) {
        var array = JSON.parse(response.d);
        var people = array[0];
        var locations = array[1];

        people.forEach(function (person) { myStorage.setPerson(person); });
        locations.forEach(function (location) { myStorage.setLocation(location); });
        renderTables();
    }

    function renderTables() {
        var row;
        var tr;
        var table;
        var clone;
        var anchor;
        var person;
        var location;
        var assigned = {};

        // erase any existing rows, except the blank template row
        $('#locations>tr').not('#blankLocation').remove();
        $('#people>tr').not('#blankPerson').remove();

        // add locations (sort order never changes)

        myStorage.begin();
        row = document.getElementById('blankLocation');
        table = document.getElementById('locations');
        while ((location = myStorage.nextLocation()) !== null) {
            if (location.ContactId) {
                assigned[location.ContactId] = 'Y';
            }
            clone = row.cloneNode(true);
            clone.getElementsByTagName('td')[0].innerText = location.LocationName;
            clone.getElementsByTagName('td')[1].innerText = contactName(location.ContactId);
            clone.setAttribute('id', location.key);
            $(clone).data('lid', location);
            show(clone);
            table.append(clone);
        }

        // add people
        myStorage.begin();
        row = document.getElementById('blankPerson');
        table = document.getElementById('people'); // find table body to append to

        while ((person = myStorage.nextPerson()) !== null) {
            clone = row.cloneNode(true); // true means get all descendant nodes too
            clone.setAttribute('id', person.key);
            anchor = clone.getElementsByTagName('a')[0];
            anchor.innerText = fullName(person);
            anchor.setAttribute('title', person.Email + '  ph. ' + person.Phone); //should be 'data-content' but doesn't work!
            $(anchor).data("pid", person.Id);
            clone.getElementsByTagName('td')[1].innerHTML = assigned[person.Id] ? personBusyIcon : person.Available ? personAvailIcon : '';

            show(clone);
            clone.setAttribute('name', (person.LastName + ' ' + person.FirstName).toLowerCase()); //for putting edits in proper order

            for (var i = 0; (tr = table.rows[i]); i++) {
                if (tr.getAttribute('name')) {
                    if (clone.getAttribute('name') < tr.getAttribute('name')) {
                        tr.insertAdjacentElement('beforebegin', clone);
                    }
                }
            }
            table.append(clone); // add new row to end of tablebody
        }
    }

    function setupPopover() {
        $('[data-toggle="popover"]').popover(); // enable popover anchor for person
    }

    function enableButton(buttonName) {
        document.getElementById(buttonName).classList.remove('disabled');
    }

    function classStorage() {
        var dict = {};
        var index;
        var keyz;

        return {
            begin: function () {
                keyz = Object.keys(dict);
                index = 0;
            },

            nextPerson: function () {
                return nextObject('p');
            },

            nextLocation: function () {
                return nextObject('l');
            },

            setPerson: function (person) {
                set((person.Id === 0 ? 'P' : 'p') + person.Id, person); // P for blank person, so nextPerson does not return it
            },

            getPerson: function (id) {
                return get((id === 0 ? 'P' : 'p') + id);
            },

            setLocation: function (location) {
                set('l' + location.Id, location);
            },

            getLocation: function (id) {
                return get('l' + id);
            }
        };

        function set(key, datum) {
            dict[key] = datum;
        }

        function get(key) {
            var o = dict[key];

            Object.defineProperty(o, "key", {
                value: key,
                writable: false,
                enumerable: false,
                configurable: true
            });
            return o;
        }

        function nextObject(keytype) {
            while (index < keyz.length && keyz[index].slice(0, 1) !== keytype) {
                index++;
            }
            if (index < keyz.length) {
                return get(keyz[index++]);
            }
            else {
                return null;
            }
        }
    }

    function formPersonJson() {
        var control;
        var person = myStorage.getPerson(0); //just to get the property names

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

    function changeAlertBox(selector, message) {
        var o = $(selector);
        // save the original message to restore later
        if (!(o.data('defaultMessage'))) {
            o.data('defaultMessage', o.text());
        }
        o.html(message);
        o.toggleClass('alert-info alert-warning');
    }

    function restoreAlertBox(selector) {
        var o = $(selector);
        var message = o.data('defaultMessage');
        o.text(message);
        o.toggleClass('alert-info alert-warning');
    }

    function assignmentMode() {
        return ($('#cancelAssignment').has('a').length === 0);
    }

    function showModal(heading, message) {
        $('#infoModal h4').text(heading);
        $('#infoModal p').text(message);
        $("#infoModal").modal();
    }


    function show(selector) {
        $(selector).removeClass('hide');
    }

    function hide(selector) {
        $(selector).addClass('hide');
    }

    function contactName(id) {
        var person;
        if (id) {
            person = myStorage.getPerson(id);
            return fullName(person);
        }
        return '';
    }

    function fullName(person) {
        return person.FirstName + ' ' + person.LastName;
    }
})();