
Qt.include('ajaxmee.js')
//Qt.include('underscore.js')
Qt.include('storage.js')

function dir(ob, print) {
    print = print || true;
    out = [];
    for (attr in ob) {
        out.push(attr);
    }
    out.sort();
    if (print) {
//        console.log(out.sort());
        return;
    }
    return out;
}

function switchButtons() {
//    searchButton.visible = false;
    displayRoutesButton.visible = true;
}

function restoreButtons() {
//    searchButton.visible = true;
//    displayRoutesButton.visible = false;
}

function dateParser(dateString) {
//    dateString = "2010-08-09 01:02";
    var reggie = /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})/g;
    var dateArray = reggie.exec(dateString);
//    console.log('dateArray', dateArray)
    var dateObject = new Date(
        dateArray[1],
        dateArray[2]-1, // Careful, month starts at 0!
        dateArray[3],
        dateArray[4],
        dateArray[5]
    );
//    console.log('hujja', dateObject)

    return dateObject;
}


function helper(myObject, direction, model, input_field, input_id) {
    var index;
    var loopFrom;
    var bestMatchFrom, bestMatchTo;

    if (typeof(myObject.findlocationresult[direction].location.length) == 'undefined') {
        loopFrom = myObject.findlocationresult[direction];
    } else {
        loopFrom = myObject.findlocationresult[direction].location;
    }

    for (index in loopFrom) {
        if (loopFrom[index].bestmatch === 'true') {
            bestMatchFrom = loopFrom[index]
        }

        model.append({
                             'name': loopFrom[index].displayname,
                             'from_id': loopFrom[index].locationid
                         })
    }

                console.log('best match', direction, bestMatchFrom.displayname);
    if (direction == 'from') {
        fromLocationID = bestMatchFrom.locationid
    } else {
        toLocationID = bestMatchFrom.locationid
    }


    setKeyValue(direction, input_field.text)

    input_field.text = bestMatchFrom.displayname;


}


function query(from, to) {
    var url = 'https://api.trafiklab.se/samtrafiken/resrobot/FindLocation.json';
    var key = '572c2d123fd4be66099351005ef88ef9';

    var data = { 'key': key, 'from': from, 'to': to, 'coordSys': 'RT90', 'apiVersion': 2.1 };

    ajaxmee('GET', url, data,
            function(data) {
//                console.log('ok', data)
                var index;
                var myObject = JSON.parse(data);
//                console.log(myObject.findlocationresult.from.length, myObject.findlocationresult.to.location.length)
                helper(myObject, 'from', fromListModel, from_input, fromLocationID);
                helper(myObject, 'to', toListModel, to_input, toLocationID);
                switchButtons();

            },
            function(status, statusText) {
                console.log('error', status, statusText)
            })
}


function search(from, to, callback) {
    var url = 'https://api.trafiklab.se/samtrafiken/resrobot/Search.json';
    var key = '572c2d123fd4be66099351005ef88ef9';



    var data = { 'key': key, 'fromId': from, 'toId': to, 'coordSys': 'RT90', 'apiVersion': 2.1 };

    console.log(from, to)

    ajaxmee('GET', url, data,
            function(data) {
                console.log('ok', data)
                var index, index2;
                var departure = 0;
                var arrival = 0;
                var tmp, tmp2, tmp3;
                var myObject = JSON.parse(data);
                for (index in myObject.timetableresult.ttitem) {
                    tmp = myObject.timetableresult.ttitem[index]
                    console.log('grabbar', JSON.stringify(tmp))
                    console.log('length', tmp.segment.length)


                    if (typeof(tmp.segment.length) == 'undefined') {
//                        tmp = tmp.segment;
                    } else {
                        tmp = tmp.segment
                    }

                    for (index2 in tmp) {
                        tmp2 = tmp[index2]
                        console.log('y', JSON.stringify(tmp2))
                        console.log(JSON.stringify(tmp2.departure));
                        departure = departure || dateParser(tmp2.departure.datetime);

                        tmp3 = dateParser(tmp2.departure.datetime);
                        if (tmp3 < departure) {
                            departure = tmp3
                        }

//                        console.log('date', tmp3);
                    }

                    routesModel.append({
//                                           'name': myObject.timetableresult.ttitem[index].segmentid.mot,
                                           'cost': '23'
                                       })
                }

                console.log('departure', departure)

////                console.log(myObject.findlocationresult.from.length, myObject.findlocationresult.to.location.length)
//                helper(myObject, 'from', fromListModel, from_input, fromLocationID);
//                helper(myObject, 'to', toListModel, to_input, toLocationID);
//                switchButtons();

            },
            function(status, statusText) {
                console.log('error', status, statusText)
            })
}
