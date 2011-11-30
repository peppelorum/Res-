import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0


import "script.js" as Script
import "storage.js" as Storage

Page {

    id: mainPage
    property string from
    property int fromLocationID
    property string to
    property int toLocationID
    property bool dateDialogOpened: false
//    property /*type*/ name: value

    tools: commonTools


    Component.onCompleted: {
        Storage.getKeyValue('from', function(key, result){
                                console.log(key, result)
                                to_input.text = result;
                            })

        Storage.getKeyValue('to', function(key, result){
                                console.log(key, result)
                                from_input.text = result;
                            }

                            )
    }

    Flow {

        Rectangle {
            Text {
                text: 'Res!'
                color: '#fff'
            }

            width: parent.width;
            height: 60
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#f4d018" }
//                GradientStop { position: 0.33; color: "yellow" }
                GradientStop { position: 1.0; color: "#dc6a00" }
            }
        }

        anchors.fill: parent
//        anchors.centerIn: parent
//        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 10

        Label {
            text: "Från: "
            width: parent.width - 10
        }

        TextField {
            id: from_input
//            text: 'Björskogsgatan'
            width: parent.width - 60
            onTextChanged: Script.restoreButtons()

        }

        Button {
            width: 40
            text: "v"
            onClicked: {
                fromSelectionDialog.open();
            }
        }

        Label {
            text: "Till: "
            width: parent.width - 10
        }

        TextField {
            id: to_input
//            text: 'Stora gatan'
            width: parent.width - 60
            onTextChanged: Script.restoreButtons()
        }

        Button {
            id: button
            width: 40
            text: "v"
            onClicked: {
                toSelectionDialog.open();
            }
        }

        Button {
            id: dateButton
            width: parent.width-200
            text: Qt.formatDateTime(new Date(), "yyyy-MM-dd")
            onClicked: {
                console.log(dateDialog.month)
//                dateDialog.fields = DateTime.Years | DateTime.Months | DateTime.Days;

                dateDialog.year = (dateDialogOpened) ? dateDialog.year : Qt.formatDateTime(new Date(), "yyyy")
                dateDialog.month = (dateDialogOpened) ? dateDialog.month : Qt.formatDateTime(new Date(), "MM")
//                dateDialog.month = dateDialog.month || Qt.formatDateTime(new Date(), "MM")
                dateDialog.day = (dateDialogOpened) ? dateDialog.day : Qt.formatDateTime(new Date(), "dd")

                dateDialog.open();
            }
        }


        DatePickerDialog {
            id: dateDialog
            titleText: "Datum"
            onAccepted: {
                dateButton.text = dateDialog.year + "-" + dateDialog.month + "-" + dateDialog.day;
            }
        }

//        function launchDialog() {
//            dateDialog.open();
//        }

//        function launchDialogToToday() {
//            var d = new Date();
//            dateDialog.year = d.getFullYear();
//            dateDialog.month = d.getMonth();
//            dateDialog.day = d.getDate();
//            dateDialog.open();
//        }

        Button {
            id: timeButton
            width: parent.width-350
            text: Qt.formatDateTime(new Date(), "hh:mm")
            onClicked: {
                timeDialog.fields = DateTime.Hours | DateTime.Minutes;
                timeDialog.hour = timeDialog.hour || Qt.formatDateTime(new Date(), "hh")
                timeDialog.minute = timeDialog.minute || Qt.formatDateTime(new Date(), "mm")
                timeDialog.open();
            }
        }

        TimePickerDialog {
            id: timeDialog
            titleText: "Tid"
            onAccepted: {
                timeButton.text = timeDialog.hour + ":" + timeDialog.minute;
            }
        }

        ButtonRow {
            Button {
                text: "Avgång"
//                onClicked: console.log(departureTime.checked)
            }
            Button {
                id: arrivalTime
                text: "Ankomst" }



        }


        Button {
            id: searchButton
            text: "Sök"
            onClicked: {
                from = from_input.text
                to = to_input.text

                fromListModel.clear();
                toListModel.clear();

//                pageStack.push(routes) ;
                Script.query(from, to)
//                myWorker.sendMessage({ 'x': 123, 'y': 80 })
            }}

//        WorkerScript {
//              id: myWorker
//              source: "worker.js"

//              onMessage: function(messageObject) {

//                             hejsan2.text = messageObject.reply

//                         }
//          }


//        Button {
//            id: displayRoutesButton
//            text: "Visa turer"
//            visible: false
//            onClicked: {

//                pageStack.push(routes) ;
//                Script.search(fromLocationID, toLocationID)
//            }}


//        Button {
//            text: "bla"
//            visible: true
//            onClicked: {

//                console.log('bla', hejsan2.text)
////                 pageStack.push(routes) ;
////                Script.search(fromLocationID, toLocationID)
//            }}



        ListModel {  id:toListModel }
        ListModel {  id:fromListModel }




        SelectionDialog {
            id: toSelectionDialog
            titleText: "Till"
            property int currentIndex: 4

            selectedIndex: 0
            model : toListModel
            onAccepted: {
                console.log('vald', toSelectionDialog.currentIndex, toSelectionDialog.model.get(toSelectionDialog.currentIndex).to_id, toSelectionDialog.model.get(toSelectionDialog.currentIndex).name)
                to_input.text = toSelectionDialog.model.get(toSelectionDialog.currentIndex).name
                toLocationID = toSelectionDialog.model.get(toSelectionDialog.currentIndex).to_id
            }
            delegate: Rectangle {
                 width: parent.width
                 height: 35
                 color: '#000'

                 Text {
                     property int to_id: 3
                     text: name
                     color: '#fff'
                     font.pixelSize: 20
                     height: 25
                 }
                 MouseArea { id: mouse; anchors.fill: parent; onClicked: {
                        toSelectionDialog.currentIndex = index
//                         delegate.SelectionDialog.view.currentIndex = index
                         console.log('click', index, model.to_id)
                         toSelectionDialog.accept()
                     }}
            }
        }


        SelectionDialog {
            id: fromSelectionDialog
            titleText: "Från"
            property int currentIndex: 4

            selectedIndex: 0
            model : fromListModel
            onAccepted: {
                console.log('vald', fromSelectionDialog.currentIndex, fromSelectionDialog.model.get(fromSelectionDialog.currentIndex).to_id, fromSelectionDialog.model.get(fromSelectionDialog.currentIndex).name)
                from_input.text = fromSelectionDialog.model.get(fromSelectionDialog.currentIndex).name
                fromLocationID = toSelectionDialog.model.get(toSelectionDialog.currentIndex).from_id
            }
            delegate: Rectangle {
                 width: parent.width
                 height: 35
                 color: '#000'

                 Text {
                     property int from_id: 3
                     text: name
                     color: '#fff'
                     font.pixelSize: 20
                     height: 25
                 }
                 MouseArea { id: mouse2; anchors.fill: parent; onClicked: {
                        fromSelectionDialog.currentIndex = index
//                         delegate.SelectionDialog.view.currentIndex = index
                         console.log('click', index, model.from_id)
                         fromSelectionDialog.accept()
                     }}
            }
        }


    }
}
