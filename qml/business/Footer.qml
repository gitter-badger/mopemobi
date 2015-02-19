import QtQuick 2.0
import "../common" as COMMON

Item {
    id: footer
    anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
    width: parent.width * 0.9
    height: buttonHeight

    property alias model: horinzontallistview.model
    
    //![view]
    ListView {
        id: horinzontallistview
        anchors.fill: parent
        clip: true
        orientation: ListView.Horizontal
        delegate: COMMON.GridMenuItem {
            textColor: "#6D6D6D"
            source: "qrc:/images/radiobutton_selecteddotted.png"
            text: modelData
            onClicked: {

            }
        }
        
    }

    
}
