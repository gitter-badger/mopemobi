import QtQuick 2.0
import "." as DIR
import "../common" as COMMON

Rectangle {
    id: container
    width: parent.width
    height: parent.height


    COMMON.JsonListModel {
        id: shopmodel
        source: qsTr("%1/shops/").arg(settings.hostUrl) //"http://localhost:3000/shops/"

    }

    BusinessTemplate {

        body.model: shopmodel
        body.onClicked:{
            shopview.selected = shopmodel.xmldata[body.currentIndex]
            console.log(JSON.stringify(shopmodel.xmldata[body.currentIndex].itemCategories))
            footer.model = shopmodel.xmldata[body.currentIndex].itemCategories
        }
    }

    DIR.BusinessChatWindow {
        id: businesschatwindow
        selected: shopview.selected
        onAdditem: {
            var status = {};
            status.status = name;
            status.itemId = null;
            status.shopId = shopview.selected;
            app.addStatus(status);

        }
    }


}

