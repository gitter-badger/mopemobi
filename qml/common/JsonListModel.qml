import QtQuick 2.0


ListModel {
    id: root

    property string source

    function httpRequest(method, url) {
        var response;
        var doc = new XMLHttpRequest();
                       doc.onreadystatechange = function() {
                           if (doc.readyState === XMLHttpRequest.HEADERS_RECEIVED) {

                           } else if (doc.readyState === XMLHttpRequest.DONE) {

                               response = doc.responseText;
                                console.log(response);
                               var res = JSON.parse(response);

                               root.append(res)
                           }
                       }

                       doc.open(method, url);
                       doc.send();
    }


    function get(resource){
        root.httpRequest("GET", resource);
    }

    Component.onCompleted: {
        root.get(root.source)
    }
}
