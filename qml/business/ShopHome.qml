import QtQuick 2.0
import QtQuick.Controls 1.0
import "." as DIR


StackView {
    id: shopview
    width: parent.width
    height: parent.height
    x: parent.width
    objectName: "Shops"

    property var selected

    initialItem: DIR.ShopList {

    }

}

