/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import "." as Content

Item {
    id: commentsItem
    width: parent.width
    height: parent.height
    x: parent.width

    property int buttonHeight: parent.height * 0.08
    property var status

    function addItem(name, parent)
    {
        if (name !== "")
        {
            app.addComment(name, parent, null)
            textinput.text = "";
        }
    }

    function refreshComments(status){
        commentsItem.status = status
        app.refreshComments(status._id);
    }


    Rectangle {
        id: toolbar
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: parent.height*0.1
        color: "#e5e5e5"


        Item {
            id: contentItem
            anchors.left: parent.left
            height: parent.height
            width: parent.width * 0.5


            Image {
                id: leftIcon
                anchors.left: parent.left
                anchors.verticalCenter: userIcon.verticalCenter
                anchors.margins: parent.height * 0.05
                height: userIcon.height/2
                width: height
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/left.png"

            }
            Image {
                id: userIcon
                anchors.left: leftIcon.right
                anchors.top: parent.top
                anchors.margins: parent.height * 0.05
                height: parent.height*0.8
                width: height
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/user.png"
            }
            Text {
                id: loginName
                anchors { left: userIcon.right; verticalCenter: userIcon.verticalCenter; margins: parent.height * 0.1 }
                verticalAlignment: Text.AlignVCenter
                color: "#333333"
                font.pixelSize: Math.min(parent.width*0.1, parent.height*0.4)
                text: status.user.name
            }
            Text {
                id: content
                anchors { left:parent.left; leftMargin: parent.width * 0.1; top: userIcon.bottom; topMargin: parent.height * 0.3 ; margins: parent.width * 0.03 }
                verticalAlignment: Text.AlignVCenter
                width: parent.width*1.8
                wrapMode: Text.WordWrap
                color: itemDone ? "#555555" : "#333333"
                font.pixelSize: Math.min(parent.width * 0.07, buttonHeight*0.3)
                text: status.status
                elide: Text.ElideRight
                font.italic: true

            }

            MouseArea {
                anchors.fill: parent
                    onClicked: mainview.state = ""
            }
        }


        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: "#aaaaaa"
        }
    }


    Text {
        id: emptyText
        anchors.centerIn: parent
        text: qsTr("No comments.")
        color: "#676767"
        visible: view.count == 0
        font.pixelSize: Math.min(parent.width, parent.height) * 0.05
    }

    ListView {
        id: view
        anchors {
            top: toolbar.bottom;
            bottom: textArea.top;
            topMargin: content.contentHeight*1.5;
            bottomMargin: buttonHeight*0.5;
            horizontalCenter: parent.horizontalCenter
        }
        width: textArea.width
        clip: true

        add: Transition { NumberAnimation { property: "y"; from: -buttonHeight; duration: 300 } }
        addDisplaced: Transition { NumberAnimation { property: "y"; duration: 300 } }
        removeDisplaced: Transition { NumberAnimation { property: "y"; duration: 300 } }
        moveDisplaced: Transition { NumberAnimation { property: "y"; duration: 300 } }

        model: commentsModel

        delegate: Rectangle {
            id: itemDelegate
            height: commentcontent.contentHeight*3;
            width: view.width
//            color: itemDone ? "#bbbbbb" : "#f1f1f1"
            radius: 1
            clip: true

            Item {
                id: profileItem
                anchors.left: parent.left
                height: parent.height
                width: parent.width * 0.5


                Image {
                    id: commentleftIcon
                    anchors.left: parent.left
                    anchors.verticalCenter: commentuserIcon.verticalCenter
                    anchors.margins: parent.height * 0.05
                    height: commentuserIcon.height/2
                    width: height
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/images/left.png"

                }
                Image {
                    id: commentuserIcon
                    anchors.left: commentleftIcon.right
                    anchors.top: parent.top
                    anchors.margins: parent.height * 0.05
                    height: commentsItem.height*0.08/4
                    width: height
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/images/user.png"
                }
                Text {
                    id: commentloginName
                    anchors { left: commentuserIcon.right; verticalCenter: commentuserIcon.verticalCenter; margins: parent.height * 0.1 }
                    verticalAlignment: Text.AlignVCenter
                    color: "#333333"
                    font.pixelSize: Math.min(parent.width*0.1, parent.height*0.4)/2
                    text: model.user.name
                }
                Text {
                    id: commentcontent
                    anchors { left:parent.left; leftMargin: parent.width * 0.1; top: commentuserIcon.bottom; topMargin: parent.height * 0.05 ; margins: parent.width * 0.03 }
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width*1.8
                    wrapMode: Text.WordWrap
                    color: itemDone ? "#555555" : "#333333"
                    font.pixelSize: settings.fontS//Math.min(parent.width * 0.07, buttonHeight*0.3)/2
                    text: body
                    elide: Text.ElideRight

                }

                MouseArea {
                    anchors.fill: parent
//                    onClicked: app.logout()
                }
            }



            Content.ImageButton {
                id: btn
                anchors { right: parent.right; top: parent.top; }
                height: buttonHeight
                width: height
                buttonEnabled: !itemProcessing
                scale: 0.5
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



    Item {
        id: textArea
        anchors { bottom: parent.bottom; bottomMargin: buttonHeight * 0.5; horizontalCenter: parent.horizontalCenter }
        width: parent.width * 0.9
        height: buttonHeight

        Content.TextInputField {
            id: textinput
            anchors.left: parent.left
            height: parent.height
            width: parent.width * 0.8
            onAccepted: addItem(text,  null)
            placeholderText: "Write a comment"
        }

        Content.Button {
            anchors.right: parent.right
            width: parent.width * 0.2
            height: parent.height
            text: qsTr("Comment")
            fontSize: Math.min(width * 0.3, height * 0.3)
            onClicked: addItem(textinput.text, status._id, null)
        }
    }

}
