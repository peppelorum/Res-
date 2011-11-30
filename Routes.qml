import QtQuick 1.1
import com.nokia.meego 1.0

import "script.js" as Script

Page {

    tools: stackTools

    Flow {
        anchors.fill: parent
        spacing: 10

        Rectangle {
            Text {
                id: hejsan
                text: 'Res!'
                color: '#fff'
            }

            width: parent.width;
            height: 60
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#3ca00a" }
//                GradientStop { position: 0.33; color: "yellow" }
                GradientStop { position: 1.0; color: "#34880a" }
            }
        }

        Component {
            id: fruitDelegate
            Row {
                width: parent.width
                height: 35
                spacing: 10
                Text { text: name }
                Text { text: '$' + cost }
            }
        }

        ListView {
            anchors.fill: parent
            model: routesModel
            delegate: fruitDelegate


        }





    }
}
