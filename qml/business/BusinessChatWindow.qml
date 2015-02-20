import QtQuick 2.0
import "." as DIR
import "../common" as COMMON


Item {
    id: businessChat
    width: parent.width/2
    height: parent.height*0.9
    anchors.right: parent.right
    anchors.rightMargin: settings.fontM
    anchors.top: parent.top
    anchors.topMargin: parent.height*0.02


    property int buttonHeight: parent.height * 0.08
    property bool like: false
    property var selected
    signal additem(string name)

    function addItem(name)
    {
        if (name !== "")
        {
            businessChat.additem(name)
            textinput.text = "";
        }
    }

    function updateItem(index)
    {
        var item = statusModel.get(index);
        item.like = businessChat.like;
        app.updateStatus(item, null);
    }

    function refreshStatuses(){
        app.refreshStatuses();
    }

    function showComments(index){
        mainview.state = "showingComments"
        var selectedStatus = {};

        selectedStatus = statusModel.get(index)

        console.log("index: "+ index)
        comments.refreshComments(selectedStatus)
    }

    Component.onCompleted: refreshStatuses()

    Item {
        id: textArea
        anchors { top: parent.top; topMargin: buttonHeight * 0.5; horizontalCenter: parent.horizontalCenter }
        width: parent.width * 0.9
        height: buttonHeight

        COMMON.TextInputField {
            id: textinput
            anchors.left: parent.left
            height: parent.height
            width: parent.width * 0.8
            onAccepted: addItem(text,  null)
            placeholderText: qsTr("Talk to %1").arg(selected.name)
        }

        COMMON.Button {
            anchors.right: parent.right
            width: parent.width * 0.2
            height: parent.height
            text: qsTr("Send")
            fontSize: Math.min(width * 0.3, height * 0.3)
            onClicked: addItem(textinput.text, null)
        }
    }


    Text {
        id: emptyText
        anchors.centerIn: parent
        text: qsTr("No Comments.")
        color: "#676767"
        visible: view.count == 0
        font.pixelSize: Math.min(parent.width, parent.height) * 0.05
    }

    ListView {
        id: view
        anchors {
            top: textArea.bottom;
            bottom: parent.bottom;
            topMargin: buttonHeight * 0.5;
            bottomMargin: buttonHeight*0.5;
            horizontalCenter: parent.horizontalCenter
        }
        width: textArea.width
        clip: true

        add: Transition { NumberAnimation { property: "y"; from: -buttonHeight; duration: 300 } }
        addDisplaced: Transition { NumberAnimation { property: "y"; duration: 300 } }
        removeDisplaced: Transition { NumberAnimation { property: "y"; duration: 300 } }
        moveDisplaced: Transition { NumberAnimation { property: "y"; duration: 300 } }

        model: statusModel

        delegate: Rectangle {
            id: itemDelegate

            property bool likes: model.like

            height: buttonHeight;
            width: view.width
            color: itemDone ? "#bbbbbb" : "#f1f1f1"
            radius: 1
            clip: true

            Item {
                id: profileItem
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
                    visible: false
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
                    anchors { left: userIcon.right; top: userIcon.top; margins: parent.height * 0.1 }
                    verticalAlignment: Text.AlignVCenter
                    color: "#333333"
                    font.pixelSize: Math.min(parent.width*0.1, parent.height*0.4)
                    text: model.user? model.user.name:app.loggedName
                    font.family: "Trebuchet MS"
                    //                text:"Ahabwe Emmanuel"
                }
                Text {
                    id: content
                    anchors { left:userIcon.right; top: loginName.bottom; bottom: parent.bottom; margins: parent.width * 0.03 }
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width - buttonHeight*0.3
                    wrapMode: Text.WordWrap
                    color: itemDone ? "#555555" : "#333333"
                    font.pixelSize: Math.min(parent.width * 0.07, buttonHeight*0.3)
                    text: status
                    elide: Text.ElideRight

                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -parent.width*0.5
                    onClicked: showComments(index)
                }
            }



            COMMON.ImageButton {
                id: btn
                anchors { right: parent.right; top: parent.top; }
                height: buttonHeight
                width: height
                buttonEnabled: !itemProcessing
                scale: 0.5
                icon: {
                    if (itemProcessing){
                        console.log("processing")
                        return "qrc:/images/loading.png";
                    }
                    else
                        return !likes ? "qrc:/images/checkbox.png" : "qrc:/images/accept.png";
                }
                onClicked: {
                    likes = !likes
                    trending.like = likes;
                    updateItem(index)
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

                Text {
                    id: comment
                    text: qsTr("Comments %1").arg(totalComments)
                    color: "#6d6d6d"
                    anchors.top: parent.bottom
                    anchors.right: parent.right
                    visible: !itemProcessing
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            showComments(index)
                        }
                    }

                }


            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 2
                color: itemDone ? "#cccccc" : "#e5e5e5"
            }

            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: 2
                color: itemDone ? "#aaaaaa" : "#ffffff"
            }
        }

    }

}



