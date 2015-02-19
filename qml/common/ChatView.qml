
import QtQuick 2.0
import "." as DIR

Item {
    id: chatview
    width: parent.width
    height: parent.height

    property alias header: header
    property alias footer: footer
    property var recipient: Object()
     property int buttonHeight: parent.height * 0.08

    function refreshChats(userId){
        app.refreshChats(userId);
    }


    Rectangle {
        id: root
        color: "#f4f4f4"
        anchors.fill: parent

        //![model]
        DIR.JsonListModel {
            id: listmodel
            source: qsTr("%1/users/friends").arg(settings.hostUrl)
        }

        //![model]

        // A simple layout:
        // a listview and a line edit with button to add to the list
        Rectangle {
            id: header
            anchors.top: parent.top
            width: parent.width
            height: 70
            color: "white"
            scale: 0.5

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
                    text: "Friends!"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -3
                    font.bold: true
                    font.pixelSize: settings.fontL
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
            anchors.bottom: footer.top
            width: parent.width
            clip: true

            // Animations
            add: Transition { NumberAnimation { properties: "y"; from: root.height; duration: 250 } }
            removeDisplaced: Transition { NumberAnimation { properties: "y"; duration: 150 } }
            remove: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 150 } }
        }
        //![view]

        BorderImage {
            id: footer

            width: parent.width
            anchors.bottom: parent.bottom
            source: "qrc:/images/delegate.png"
            border.left: 5; border.top: 5
            border.right: 5; border.bottom: 5
            opacity: 0

        }
        //![append]

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
                    anchors { left: parent.left; leftMargin: parent.width * 0.1; verticalCenter: parent.verticalCenter; margins: parent.width * 0.03 }
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width - buttonHeight
                    wrapMode: Text.WordWrap
                    color: "#555555"
                    font.pixelSize: Math.min(parent.width*0.1, parent.height*0.4)
                    text: name
                }

               DIR.ImageButton {
                    id: btn
                    anchors { right: parent.right; top: parent.top; }
                    height: buttonHeight
                    width: height
                    buttonEnabled: !itemProcessing
                    icon: {
                        if (itemProcessing)
                            return "qrc:/images/loading.png";
                        else
                            return done ? "qrc:/images/close.png" : "qrc:/images/accept.png";
                    }
                    onClicked: {
                        if (done)
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

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {

                        if(mainview.state != "ShowingChat" && mainview.state != "")
                            mainview.state = ""
                        else if(mainview.state != "ShowingChat")
                            mainview.state = "ShowingChat"
                        else if(mainview.state === "ShowingChat"){
                            if (index !== -1) {
                                // populate user chats
                                chatview.refreshChats(_id)

                                chatview.recipient.id = _id
                                chatview.recipient.name = name
                                console.log(chatview.recipient);
                                chatview.state = "showingChatItem"
                            }
                        }

                        else
                        {  if (index !== -1 && _synced) {
                                //                            enginioModel.setProperty(index, "completed", !completed)
                                container.state = "showingChatItem"
                            }}

                    }
                }
            }

        }


    }

    DIR.ChatItem {
        id: chatitem

    }

    states: [
        State {
            name: "showingChatItem"
            PropertyChanges {
                target: chatitem
                opacity: 1
                visible: true
            }
            PropertyChanges {
                target: root
                opacity: 0
            }
        }
    ]

    transitions: [
        Transition {

            NumberAnimation {
                property: "opacity"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    ]
}
