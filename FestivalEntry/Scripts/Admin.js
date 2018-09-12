var AdminApp = (function () {

    myStorage = new classStorage();
    var pendingLocation;

    getData();

    return {
        fillSlot: function () {
            pendingRow = $('input[name=chooseLocation]:checked').closest('tr');

            var locationId = $('input[name=chooseLocation]:checked').val();
            var personId = $('input[name=choosePerson]:checked').val();

            var location = myStorage.getLocation(locationId);
            var locationName = location.LocationName;
            var personName = fullName(myStorage.getPerson(personId));
            var message;
            if (location.ContactId == null) {
                message = 'Assign ' + personName + ' to ' + locationName + '?';
            }
            else {
                var oldPersonName = fullName(myStorage.getPerson(location.ContactId));
                message = 'Replace ' + oldPersonName + ' with ' + personName + ' for ' + locationName + '?';
            }
            if (confirm(message)) {
                location.ContactId = personId;
                pendingLocation = location;
                $.ajax({
                    type: "POST",
                    url: "Admin.aspx/UpdateLocation",
                    data: JSON.stringify({ location: location }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: onUpdateLocationSuccess,
                    failure: onAJAXFailure,
                    error: onAJAXFailure
                });
            }
        },

        editPerson: function (mode) {
            var id = (mode === 'A' ? 0 : $('input[name=choosePerson]:checked').val());
            populatePerson(id);
            hide('.no-new, #submitError');
            if (mode === 'E') {
                show('.no-new');
            }
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
        myStorage.setLocation(pendingLocation);
        renderTables();
    }

    function onUpdatePersonSuccess(response) {
        person = JSON.parse(response.d);
        myStorage.setPerson(person);
        renderTables();
        location.hash = "#close";
    }

    function onUpdatePersonFailure(response) {
        $('#serverError').text(parseResponse(response));
        show('#submitError');

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
        if (!person) {
            var mess =  + 'person ' + id + ' not found!';
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
        var row, tr,table, clone;
        var person, location;
        var assigned = {};
        var personAvailIcon = '<span class="glyphicon glyphicon-star-empty"></span>'
        var personBusyIcon = '<span class="glyphicon glyphicon-star"></span>'

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
            clone.getElementsByTagName('input')[0].setAttribute('value', location.Id);
            clone.getElementsByTagName('td')[2].innerText = contactName(location.ContactId);
            clone.setAttribute('id', location.key);
            clone.removeAttribute('class');
            table.append(clone);
        }

        // add people
        myStorage.begin();
        row = document.getElementById('blankPerson');
        table = document.getElementById('people'); // find table body to append to

        while ((person = myStorage.nextPerson()) !== null) {
            clone = row.cloneNode(true); // true means get all descendant nodes too
            clone.setAttribute('id', person.key);
            clone.getElementsByTagName('input')[0].setAttribute('value', person.Id);
            clone.getElementsByTagName('td')[1].innerText = fullName(person);
            clone.getElementsByTagName('td')[2].innerHTML = assigned[person.Id] ? personBusyIcon : person.Available ? personAvailIcon : '';

            clone.removeAttribute('class');
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

    function enableButton(buttonName) {
        document.getElementById(buttonName).classList.remove('disabled');
    }

    function classStorage() {
        var dict = {};
        var index;
        var keyz;

        this.begin = function () {
            keyz = Object.keys(dict);
            index = 0;
        };

        this.nextPerson = function () {
            return nextObject('p');
        };

        this.nextLocation = function () {
            return nextObject('l');
        };

        this.setPerson = function (person) {
            set(person.Id===0 ? 'P':'p' + person.Id, person); // for blank person, not included in list
        };

        this.getPerson = function (id) {
            return get(id === 0 ? 'P': 'p' + id);
        };

        this.setLocation = function (location) {
            set('l' + location.Id, location);
        };
         
        this.getLocation = function (id) {
            return get('l' + id);
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
        person = myStorage.getPerson(0); //just to get the property names
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
        person = myStorage.getPerson(id);
        return fullName(person);
    }

    function fullName(person) {
        return person.FirstName + ' ' + person.LastName;
    }

})();