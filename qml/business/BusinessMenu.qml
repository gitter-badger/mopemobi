import QtQuick 2.0
import "../common" as COMMON

Rectangle {
    id: root

    property alias header: header
     property int buttonHeight: parent.height * 0.08

    width: parent.width
    height: parent.height
    objectName: "businessMenu"

    //![model]
    COMMON.JsonListModel {
        id: listmodel
        source: qsTr("%1/businessmoduleCategoriesREST").arg(settings.hostUrl)
    }

    //![model]

    // A simple layout:
    // a listview and a line edit with button to add to the list
    Rectangle {
        id: header
        anchors.top: parent.top
        //            width: Math.max(headertitle.width+30, parent.width)
        width: parent.width + 30
        height: 0
        color: "white"
        scale: 0.5
        opacity: 0


        Row {
            id: logo
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -4
            spacing: 4
            Image {
                //                    source: "qrc:/images/enginio.png"
                //                    width: 160 ; height: 60
                fillMode: Image.PreserveAspectFit
            }
            Text {
                id: headertitle
                text: "Start Purchasing!"
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -3
                font.bold: true
                font.pixelSize: 0
                color: "#555"

            }
        }
        Rectangle {
            width: parent.width ; height: 1
            anchors.bottom: parent.bottom
            color: "#bbb"
        }
    }

    //![view]
    ListView {
        id: listview
        model: listmodel
        delegate: listItemDelegate
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        clip: true

        // Animations
        add: Transition { NumberAnimation { properties: "y"; from: root.height; duration: 250 } }
        removeDisplaced: Transition { NumberAnimation { properties: "y"; duration: 150 } }
        remove: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 150 } }
    }
    //![view]

    Component {
        id: listItemDelegate

        Rectangle {
            id: itemDelegate
            height: buttonHeight
            width: listview.width
            color:  "#f1f1f1"
            radius: 1

            Text {
                id: content
                anchors { left: parent.left; verticalCenter: parent.verticalCenter; margins: parent.width * 0.03 }
                verticalAlignment: Text.AlignVCenter
                width: parent.width - buttonHeight
                wrapMode: Text.WordWrap
                color: itemDone ? "#555555" : "#333333"
                font.pixelSize: Math.min(parent.width*0.1, parent.height*0.4)
                text: name
            }

            COMMON.ImageButton {
                id: btn
                anchors { right: parent.right; top: parent.top; }
                height: buttonHeight
                width: height
                buttonEnabled: !itemProcessing
                visible: false
                icon: {
                    if (itemProcessing)
                        return "qrc:/images/loading.png";
                    else
                        return itemDone ? "qrc:/images/close.png" : "qrc:/images/accept.png";
                }
                onClicked: {
                    if (itemDone)
                        app.deleteItem(index, true);
                    else
                        app.finishItem(index, true);
                }

                NumberAnimation {
                    target: btn
                    property: "rotation"
                    duration: 1000
                    from: 0
                    to: 360
                    alwaysRunToEnd: true
                    running: itemProcessing
                    loops: Animation.Infinite
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 2
                color: "#e5e5e5"
            }

            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: 2
                color:  "#ffffff"
            }
            //![setProperty]
            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {


                    if(mainview.state != "ShowingBusinessModules" && mainview.state != "")
                        mainview.state = ""
                    if(mainview.state != "ShowingBusinessModules")
                        mainview.state = "ShowingBusinessModules"
                    else
                        businessView.selected = name


                }
            }
        }


    }

}


