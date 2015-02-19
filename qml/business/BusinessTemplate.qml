import QtQuick 2.0
import "." as DIR

Rectangle {
    id: template
    width: parent.width
    height: parent.height

    property alias body: listview
    property alias footer: footer
    property alias header: header


    DIR.Header {
        id: header
    }


    //![view]
    DIR.ListBody {
        id: listview
        anchors.top: header.bottom
        anchors.topMargin: settings.fontL
        anchors.bottom: footer.top
        model: 10
    }

    DIR.BusinessChatWindow {
        id: businesschatwindow
    }


    DIR.Footer {
        id: footer
        model: 10
    }

}

