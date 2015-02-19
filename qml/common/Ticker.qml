
import QtQuick 2.0
import QtQuick.Controls 1.1
import "." as DIR


Rectangle {
    id: ticker
    color: "#f5f5f5"
    height: parent.height*0.08
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    opacity: 1


    Row {

        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10
        DIR.GridMenuItem {
            text: "User Profile"
            source: "qrc:/icons/user1.jpeg"
            onClicked: {
                settings.m_middleviewCategory = 1
            }
        }
        DIR.GridMenuItem {
            text: "Gifts"
            source: "qrc:/icons/GIFTS.png"
            onClicked: {
                settings.m_middleviewCategory = 2
            }
        }
        DIR.GridMenuItem {
            text: "Meets"
            source: "qrc:/icons/GROUP.png"
        }
        DIR.GridMenuItem {
            text: "Settings"
            source: "qrc:/icons/settings.png"
        }
    }

    states: [
        State {
            name: "shown"
            when: sideview.state === ""
//            when: settings.m_fullscreen === true
            PropertyChanges {
                target: ticker
                opacity: 1
                height: parent.height*0.1
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { properties: "y, opacity, height"; duration: 800; easing.type: Easing.InOutQuad }
        }
    ]
}
