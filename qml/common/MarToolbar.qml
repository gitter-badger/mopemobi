import QtQuick 2.0

Rectangle {
    id: toolbar
    anchors { top: parent.top; left: parent.left; right: parent.right }
    height: parent.height * 0.1
    color: "#e5e5e5"

    Item {
        anchors.left: parent.left
        height: parent.height
        width: parent.width * 0.5

        Image {
            id: leftIcon
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: parent.height * 0.05
            height: parent.height * 0.4
            width: height
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/left.png"
        }
        Image {
            id: userIcon
            anchors.left: leftIcon.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: parent.height * 0.05
            height: parent.height * 0.8
            width: height
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/user.png"
        }
        Text {
            id: loginName
            anchors { left: userIcon.right; verticalCenter: userIcon.verticalCenter; margins: parent.height * 0.1 }
            verticalAlignment: Text.AlignVCenter
            color: "#333333"
            font.pixelSize: Math.min(parent.width*0.08, parent.height*0.4)
            text: app.loggedName
//                text:"Ahabwe Emmanuel"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: app.logout()
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: "#aaaaaa"
    }
}


