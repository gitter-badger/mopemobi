import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import "." as DIR

Rectangle {
    id: mainview
    width: parent? parent.width:Stack.width
    height: parent?  parent.height: Stack.height

    property int buttonHeight: parent.height * 0.08

    SplitView {
        id: splitview
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: ticker.top
        orientation: Qt.Horizontal

        Rectangle {
            id: trendingrect
            width: parent.width/2

            MouseArea {
                id: trendingmouseArea
                anchors.fill: parent
                onClicked: {


                    if(mainview.state != "ShowingTrending" && mainview.state != "")
                        mainview.state = ""
                    else if(mainview.state != "ShowingTrending")
                        mainview.state = "ShowingTrending"
                    else
                        mainview.state = ""

                }
            }

           DIR.CommentsView {
                id: comments
            }

            DIR.Trending {
                id: trending
            }




        }

        SplitView {
            id: innersplitview
            width: parent.width/2
            height: parent.height
            orientation: Qt.Vertical

            Rectangle {
                id: chatrect
                height: parent.height/2
                width: parent.width

                DIR.ChatView {
                    id: chatview
                }

            }
            Rectangle {
                id:businessmodulerect
                Layout.minimumWidth: 50
//                Layout.fillWidth: true

                DIR.BusinessModulesView {
                    id: businessmoduleview
                }
            }

        }
    }

    DIR.Ticker {
        id: ticker
    }

    states: [
        State {
            name: "ShowingBusinessModules"

            PropertyChanges {
                target: trendingrect
                width: parent.width*0.1
            }

            PropertyChanges {
                target: chatrect
                height: 10
            }
            PropertyChanges {
                target: businessmoduleview
                header.scale: 1
                header.opacity: 1
                header.height: 70
            }

            PropertyChanges {
                target: businessmodulerect
                y: 0
                height: 0
            }
        },
        State {
            name: "showingComments"
            PropertyChanges {
                target: comments
                x: 0

            }
            PropertyChanges {
                target: trending
                x: -parent.width

            }
            PropertyChanges {
                target: trendingrect
                width: parent.width*0.9
            }

        },

        State {
            name: "ShowingChat"
            PropertyChanges {
                target: trendingrect
                width: parent.width*0.1
            }

            PropertyChanges {
                target: chatrect
                height: parent.height
            }
            PropertyChanges {
                target: chatview
                header.scale: 1
                header.opacity: 1
            }

            PropertyChanges {
                target: businessmodulerect
                x: 0
                y: 0
                height: 2
            }
        },
        State {
            name: "ShowingTrending"

            PropertyChanges {
                target: trendingrect
                width: parent.width*0.9
            }
        }
    ]

    transitions: [
        Transition {

            NumberAnimation {
                properties: "height, width"
                duration: 200
                easing.type: Easing.InOutQuad
            }

        }
    ]

}

