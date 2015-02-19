
import QtQuick 2.0
import QtQuick.Controls 1.1


Loader {
    id: topbar
    width: parent.width; height: parent.height*0.08
    property alias image: image
    property string title: "Home"

    Loader {
        id: image
        sourceComponent: component
        anchors.right: textitem.left
        anchors.verticalCenter: parent.verticalCenter

        MouseArea {
            anchors.fill: parent
            anchors.margins: -50
            onClicked: {
                sideview.state = ""
            }
        }
    }


    Text {
        id: textitem
        text: qsTr(topbar.title)
        color: "#6d6d6d"
        font.pixelSize: 14
        anchors.centerIn: parent
    }

    Component {
        id: component
    Image {

        source: "qrc:/icons/HomeIcon.png"
        scale: 0.5
        MouseArea {
            anchors.fill: parent
            anchors.margins: -50
            onClicked: {
//                sideview.state = ""
               mainView.state = ""

            }
        }
    }

    }



    states: [
        State {
            name: "hidden"
            when: settings.m_fullscreen === true
            PropertyChanges {
                target: topbar
                y:-topbar.height - 10
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { property: "y"; duration: 800; easing.type: Easing.InOutQuad }
        }
    ]

}
