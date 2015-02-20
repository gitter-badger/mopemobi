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
        anchors.topMargin: settings.fontL*2
        anchors.bottom: footer.top
    }


    DIR.Footer {
        id: footer
        model: 10
    }

}

