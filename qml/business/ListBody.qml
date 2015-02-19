import QtQuick 2.0
import "../common" as COMMON

ListView {
    id: listview
    delegate:  Item {
        id: container
        width: parent.width
        height: listview.height*0.08

        signal clicked

        transformOrigin: Item.Right

        Rectangle {
            anchors.fill: parent
            color: "#11ffffff"
            visible: mouse.pressed
        }

        Text {
            id: textitem
            color: "#4D4D4D"
            font.pixelSize: Math.min(parent.width*0.1, parent.height*0.4)
            text: "The Bistro"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 30
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 15
            height: 1
            color: "silver"
            visible: false
        }

        Image {
            id: arrow
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
//                source: "../images/next.png"
            scale: 0.2
            visible: false
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            onClicked: {
                container.ListView.view.currentIndex = index

                container.clicked()
            }

        }

        states: [
            State {
                name: 'selected'
                when: container.ListView.isCurrentItem
                PropertyChanges { target: textitem; scale: 1.2; opacity:  1 }
                PropertyChanges { target: arrow; scale: 0.5; opacity:  1 }

            }
        ]

        transitions: Transition {
            SequentialAnimation {
                PropertyAction { target: textitem; property: "smooth"; value: "false" }
                ParallelAnimation {
                    NumberAnimation { property: "scale"; duration: 300; easing.type: Easing.InOutQuad }
                    NumberAnimation { property: "opacity"; duration: 300; easing.type: Easing.InOutQuad }
                }
                PropertyAction { target: textitem; property: "smooth"; value: "true" }
            }
        }
    }

    width: parent.width
    clip: true
    
    // Animations
    add: Transition { NumberAnimation { properties: "y"; from: root.height; duration: 250 } }
    removeDisplaced: Transition { NumberAnimation { properties: "y"; duration: 150 } }
    remove: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 150 } }
}
