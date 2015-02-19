import QtQuick 2.0

Rectangle {
    id: header
    anchors.top: parent.top
    width: parent.width
    color: "white"
    Rectangle {
        width: listview.width - 10
        height: listview.height/10
        color: "transparent"

        Text {
            id: textItemTitle

            text: "Near By"//section

            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            color: "#424246"
            font.pixelSize: Math.min(parent.width*0.1, parent.height*0.4)
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            styleColor: "white"
            font.bold: true
            font.italic: true

        }

        Rectangle {
            width: parent.width*0.8
            height: 1
            color: "#424246"
            anchors.bottom: textItemTitle.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

    }

}
