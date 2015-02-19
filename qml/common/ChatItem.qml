import QtQuick 2.0

Item {
    width: parent.width
    height: parent.height
    opacity: 0
    visible: false

    function addItem(chat, to)
    {
        if (chat !== "")
        {
            app.addChat(chat, to)
            textInput.text = "";
        }
    }

    Rectangle {
        id: root
        color: "#f4f4f4"
        anchors.fill: parent

        //![model]
        ListModel {
            id: listmodel
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
            scale: 0.7

            Row {
                id: logo
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -4
                spacing: 10
                Image {
                    source: "qrc:/icons/back_icon.png"
//                    width: 160 ; height: 60
                    scale: 0.7
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
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    chatview.state = ""

                }
            }
        }

        //![view]
        ListView {
            id: listview
            model: chatModel
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
            opacity: 1

            Rectangle {
                y: -1 ; height: 1
                width: parent.width
                color: "#bbb"
            }
            Rectangle {
                y: 0 ; height: 1
                width: parent.width
                color: "white"
            }

            //![append]

            BorderImage {

                anchors.left: parent.left
                anchors.right: addButton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 16
                source:"qrc:/images/textfield.png"
                border.left: 14 ; border.right: 14 ; border.top: 8 ; border.bottom: 8

                TextInput{
                    id: textInput
                    anchors.fill: parent
                    clip: true
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: settings.fontM
                    Text {
                        id: placeholderText
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        visible: !(parent.text.length || parent.inputMethodComposing)
                        font: parent.font
                        text: "Search ..."
                        color: "#aaa"
                    }
                    onAccepted: {
                        addItem(textInput.text, chatview.recipient)
                        textInput.text = ""
                    }
                }
            }

            Item {
                id: addButton

                width: 40 ; height: 40
                anchors.margins: 20
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                enabled: textInput.text.length
                Image {
                    source: addMouseArea.pressed ? "qrc:icons/add_icon_pressed.png" : "qrc:icons/add_icon.png"
                    anchors.centerIn: parent
                    opacity: enabled ? 1 : 0.5
                }
                MouseArea {
                    id: addMouseArea
                    anchors.fill: parent
                    onClicked: textInput.accepted()
                }
            }
        }
        //![append]

        Component {
            id: listItemDelegate

            BorderImage {
                id: item

                width: parent.width ; height: 70
                source: mouse.pressed ? "qrc:images/delegate_pressed.png" : "qrc:images/delegate.png"
                border.left: 5; border.top: 5
                border.right: 5; border.bottom: 5

                Image {
                    id: shadow
                    anchors.top: parent.bottom
                    width: parent.width
                    visible: !mouse.pressed
                    source: "qrc:images/shadow.png"
                }

                //![setProperty]
                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (index !== -1 && _synced) {
                            chatModel.setProperty(index, "completed", !completed)
                        }
                    }
                }
                //![setProperty]
                Image {
                    id: checkbox
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    width: 32
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    source: completed ? "qrc:images/checkmark.png" : ""
                }

                //![delegate-properties]
                Text {
                    id: todoText
                    text: chat
                    font.pixelSize: settings.fontM
                    color: "#333"

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: checkbox.right
                    anchors.right: parent.right
                    anchors.leftMargin: 12
                    anchors.rightMargin: 40
                    elide: Text.ElideRight
                }
                //![delegate-properties]

                // Show a delete button when the mouse is over the delegate
                //![sync]
                Image {
                    id: removeIcon

                    source: removeMouseArea.pressed ? "qrc:icons/delete_icon_pressed.png" : "qrc:images/user.png"
                    anchors.margins: 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    opacity: enabled ? 1 : 0.5
                    height: parent.height
                    fillMode: Image.PreserveAspectFit
                    scale: 0.5
                    Behavior on opacity {NumberAnimation{duration: 100}}
                    Text {
                        id: name
                        text: model.user.name// This is available in all editors.
                        anchors.top: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        elide: Text.ElideRight
                        color: "silver"
                    }
                    //![remove]
                    MouseArea {
                        id: removeMouseArea
                        anchors.fill: parent
                        onClicked: chatModel.remove(index)
                    }
                    //![remove]
                }
                //![sync]
            }
        }


    }

}

