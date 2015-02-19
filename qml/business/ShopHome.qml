import QtQuick 2.0
import QtQuick.Controls 1.0
import "." as DIR


StackView {
    width: parent.width
    height: parent.height
    x: parent.width
    objectName: "Shops"

    initialItem: DIR.ShopList {

    }

}

