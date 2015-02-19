import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
    id: root
    width: mainview.width/5
    height: parent.height
    color: "transparent"

    property string source
    property string text
    property string textColor
    property int topMargin: 10
    signal clicked()
    property ExclusiveGroup exclusiveGroup: null
    property bool checked: false

    onExclusiveGroupChanged: {
        if (exclusiveGroup)
            exclusiveGroup.bindCheckable(root)
    }

    Image {
        id: image
        source: root.source
        anchors.top: parent.top
//        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        height: settings.fontM
        fillMode: Image.PreserveAspectFit
        Text {
            id: textitem
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.textColor
            text: root.text
            font.pixelSize: settings.fontXS
            scale: 0.8

        }
    }


    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
