
import QtQuick 2.0
import "../business" as BUSINESS

Item {
    id: businessView
    width: parent.width
    height: parent.height

    property alias header: businessMenu.header
    property string selected: ""


    BUSINESS.ShopHome {
        id: shopHome
    }

    BUSINESS.CinemaView {
        id: cinemaView
    }

    BUSINESS.RestaurantView {
        id: restaurantView
    }

    BUSINESS.HotelView {
        id: hotelView
    }

    BUSINESS.EntertainmentView {
        id: entertainmentView
    }

    BUSINESS.BusinessMenu {
        id: businessMenu
    }

    states: [
        State {
            name: businessMenu.objectName
            when: businessView.selected === businessMenu.objectName
            PropertyChanges {
                target: businessMenu
                visible: true
                opacity: 1
                x: 0
            }
        },
        State {
            name: shopHome.objectName
            when: businessView.selected === shopHome.objectName
            PropertyChanges {
                target: shopHome
                visible: true
                opacity: 1
                x: 0
            }
            PropertyChanges {
                target: businessMenu
                opacity: 0
                x: -parent.width
            }
        },
        State {
            name: cinemaView.objectName
            when: businessView.selected === cinemaView.objectName
            PropertyChanges {
                target: cinemaView
                visible: true
                opacity: 1
                x: 0
            }
            PropertyChanges {
                target: businessMenu
                opacity: 0
                x: -parent.width
            }
        },
        State {
            name: restaurantView.objectName
            when: businessView.selected === restaurantView.objectName
            PropertyChanges {
                target: restaurantView
                visible: true
                opacity: 1
                x: 0
            }
            PropertyChanges {
                target: businessMenu
                opacity: 0
                x: -parent.width
            }
        },
        State {
            name: hotelView.objectName
            when: businessView.selected === hotelView.objectName
            PropertyChanges {
                target: hotelView
                visible: true
                opacity: 1
                x: 0
            }
            PropertyChanges {
                target: businessMenu
                opacity: 0
                x: -parent.width
            }
        },
        State {
            name: entertainmentView.objectName
            when: businessView.selected === entertainmentView.objectName
            PropertyChanges {
                target: entertainmentView
                visible: true
                opacity: 1
                x: 0
            }
            PropertyChanges {
                target: businessMenu
                opacity: 0
                x: -parent.width
            }
        }

    ]

    transitions: [
        Transition {

            NumberAnimation {
                properties: "x, opacity"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    ]
}
