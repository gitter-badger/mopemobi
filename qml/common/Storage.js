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

var REQUEST_URL = "http://localhost:3000"
var firstDoneIndex = 0
var sessionId = ""
var localId = 0

// Show error message and logout if necessary
function error(code, message, forceLogout)
{
    if (mainView.depth > 1 && (forceLogout || code === 403))
        logoutUser()

    errorInfo.show(message === "" ? qsTr("Unknown error") : message)
}

function checkError(data)
{
    var obj = data.error
    if (obj === undefined) {
        return true;
    }
    else {
        error(obj.code, obj.message, false)
        return false;
    }
}

function initModel(data)
{
    itemModel.clear()
    firstDoneIndex = 0;
    // Add done-items to the end of the list
    for (var i=data.length; i--;) {
        var obj = data[i];
        if (obj.done)
            itemModel.append({ "itemName": obj.text, "itemDone": obj.done, "itemId": obj.id, "itemProcessing": false })
        else
        {
            itemModel.insert(0, { "itemName": obj.text, "itemDone": obj.done, "itemId": obj.id, "itemProcessing": false })
            firstDoneIndex++;
        }
    }
}

function refreshModel(data)
{
    // 1. Update available items and delete unnecessary items
    for (var i=itemModel.count; i--;) {
        var id = itemModel.get(i).itemId
        var found = false;
        for (var j=data.length; j--;) {
            var obj = data[j];
            if (obj.id === id) {
                itemModel.setProperty(i, "itemName", obj.text);
                if (itemModel.get(i).itemDone !== obj.done)
                {
                    itemModel.setProperty(i, "itemDone", obj.done);
                    if (i !== firstDoneIndex && i !== (firstDoneIndex-1))
                        itemModel.move(i,firstDoneIndex-1,1)

                    if (obj.done)
                        firstDoneIndex--;
                    else
                        firstDoneIndex++;
                }

                data.splice(j,1);
                found = true;
                break;
            }
        }

        if (!found)
            itemModel.remove(i);
    }

    // 2. Add new items
    for (var k=0; k<data.length; k++) {
        itemModel.insert(0, { "itemName": data[k].text, "itemDone": data[k].done, "itemId": data[k].id, "itemProcessing": false })
        firstDoneIndex++;
    }

    // 3. Calculate first done-index
    firstDoneIndex = itemModel.count;
    for (var l=0; l<itemModel.count; l++) {
        if (itemModel.get(l).itemDone) {
            firstDoneIndex = l;
            break;
        }
    }
}

// HTTP-functions -->
function registerUser(name, username, password)
{
    app.loading = true

    var doc = new XMLHttpRequest();
    doc.open("POST", REQUEST_URL + "/register", true);
    doc.setRequestHeader('Content-Type', 'application/json');
    doc.onreadystatechange = function()
    {
        // When ready
        if (doc.readyState === 4) {

            // If OK
            if (doc.status === 200) {
                var data = JSON.parse(doc.responseText);
                if (checkError(data))
                    loginUser(username, password);  // Login after registering
            }
            else {
                error(doc.status, doc.statusText, true)
            }
        }
    }
    doc.send(JSON.stringify({ "name": name, "username": username, "password": password }));
}

function loginUser(username, password)
{
    app.loading = true

    var doc = new XMLHttpRequest();
    doc.open("POST", REQUEST_URL + "/login", true);
    doc.setRequestHeader('Content-Type', 'application/json');
    doc.onreadystatechange = function()
    {
        // When ready
        if (doc.readyState === 4) {

            // If OK
            if (doc.status === 200) {
                var data = JSON.parse(doc.responseText);
//
                if (checkError(data)) {
                    Qt.inputMethod.hide()
                    mainView.push({ item: Qt.resolvedUrl("MainView.qml"), replace: true });
                    app.loggedIn = true
                    app.loggedName = data.user.name
                    app.loggedInUser = data;
                    sessionId = data.session
                    // Open WebSocket connection
                    connectToWebSocket()
                    // Init items after login
                    initItems()
                }
            }
            else {
                error(doc.status, doc.statusText, true)
            }
        }
    }
    doc.send(JSON.stringify({ "email": username, "password": password }));
}

function connectToWebSocket() {
    var doc = new XMLHttpRequest();
    doc.open("GET", REQUEST_URL + "/api/websocket", true);
    doc.setRequestHeader('x-marbis-session', sessionId);
    doc.setRequestHeader('Content-Type', 'application/json');
    doc.onreadystatechange = function()
    {
        // When ready
        if (doc.readyState === 4) {

            // If OK
            if (doc.status === 200) {
                var data = JSON.parse(doc.responseText);
                console.log("Open WebSocket connection", data.uri)
                socket.url = data.uri
            }
        }
    }
    doc.send()
}

function logoutUser()
{

    // Pop pages
    while (mainView.depth > 1)
        mainView.pop()

    app.loading = false

    // Hide keyboard
    Qt.inputMethod.hide()

    // Send logout-info to the server
    var doc = new XMLHttpRequest();
    doc.open("GET", REQUEST_URL + "/logout", true);
    doc.setRequestHeader('Content-Type', 'application/json');
    doc.send();
}

function initItems()
{
    app.loading = false;
    var doc = new XMLHttpRequest();
    doc.open("GET", REQUEST_URL + "/api/todos", true);
    doc.setRequestHeader('Content-Type', 'application/json');
    doc.setRequestHeader('x-todo-session', sessionId);
    doc.onreadystatechange = function()
    {
        // When ready
        if (doc.readyState === 4) {

            // If OK
            if (doc.status === 200) {
                var data = JSON.parse(doc.responseText);
                if (checkError(data)) {
                    initModel(data)
                    localId = itemModel.count + 1
                    app.loading = false
                }
            }
            else {
                error(doc.status, doc.statusText, false)
            }
        }
    }
    doc.send();
}

function refreshItems()
{
    var doc = new XMLHttpRequest();
    doc.open("GET", REQUEST_URL + "/api/todos", true);
    doc.setRequestHeader('Content-Type', 'application/json');
    doc.setRequestHeader('x-todo-session', sessionId);
    doc.onreadystatechange = function()
    {
        // When ready
        if (doc.readyState === 4) {

            // If OK
            if (doc.status === 200) {
                var data = JSON.parse(doc.responseText);
                if (checkError(data))
                    refreshModel(data);
            }
            else {
                error(doc.status, doc.statusText, false)
            }
        }
    }
    doc.send();
}

function addItem(name, itemId)
{
    console.log('Create item '+name)
    var locId = itemId || "local_" + (localId++);
    var processing = itemId ? false : true
    // Add item locally
    itemModel.insert(0, { "itemName": name, "itemDone": false, "itemId": locId, "itemProcessing": processing  })
    firstDoneIndex++;
    // if itemId not provided sync to backend
    if(!itemId){
        // Send info to the server
        var doc = new XMLHttpRequest();
        doc.open("POST", REQUEST_URL + "/api/todos", true);
        doc.setRequestHeader('Content-Type', 'application/json');
        doc.setRequestHeader('x-todo-session', sessionId);
        doc.onreadystatechange = function()
        {
            // When ready
            if (doc.readyState === 4) {

                // If OK
                if (doc.status === 200) {
                    var data = JSON.parse(doc.responseText);
                    if (checkError(data)) {
                        for (var i=0; i<itemModel.count; i++) {
                            if (itemModel.get(i).itemId === locId) {
                                itemModel.setProperty(i, "itemId", data.id);
                                itemModel.setProperty(i, "itemProcessing", false)
                                break;
                            }
                        }
                    }
                    else {
                        error(doc.status, doc.statusText, false)
                    }
                }
            }
        }

        doc.send(JSON.stringify({ "text": name, "done": false, "device": device }));
    }
}

function addStatus(name, itemId)
{
    console.log('Create item '+name)
    var locId = "local_" + (new Date().getTime());
    var processing = itemId ? false : true
    // Add item locally
    statusModel.insert(0, { "itemId": locId, "status": name, "itemDone": false, "itemProcessing": processing, "like": false})
    firstDoneIndex++;
    // if itemId not provided sync to backend
    if(!itemId){
        // Send info to the server
        var doc = new XMLHttpRequest();
        doc.open("POST", REQUEST_URL + "/api/status", true);
        doc.setRequestHeader('Content-Type', 'application/json');
        doc.setRequestHeader('x-marbis-session', sessionId);
        doc.onreadystatechange = function()
        {
            // When ready
            if (doc.readyState === 4) {

                // If OK
                if (doc.status === 200) {
                    var data = JSON.parse(doc.responseText);


                    if (checkError(data)) {
                        for (var i=0; i<statusModel.count; i++) {
                            if (statusModel.get(i).itemId === locId) {
                                console.log(locId);
                                statusModel.setProperty(i, "status", data.status);
                                statusModel.setProperty(i, "itemProcessing", false)
                                break;
                            }
                        }
                    }
                    else {
                        error(doc.status, doc.statusText, false)
                    }
                }
            }
        }

        doc.send(JSON.stringify({ "itemId": locId, "status": name, "itemDone": false, "itemProcessing": processing, "like": false}));
    }
}

function updateStatus(status, itemId)
{

    var locId = "local_" + status.itemId;
    console.log('updating item '+status.itemId)

    firstDoneIndex++;
    // if itemId not provided sync to backend
    if(!itemId){
        // Send info to the server
        var doc = new XMLHttpRequest();
        doc.open("PUT", REQUEST_URL + qsTr("/api/status/%1").arg(status._id), true);
        doc.setRequestHeader('Content-Type', 'application/json');
        doc.setRequestHeader('x-marbis-session', sessionId);
        doc.onreadystatechange = function()
        {
            // When ready
            if (doc.readyState === 4) {

                // If OK
                if (doc.status === 200) {
                    var data = JSON.parse(doc.responseText);


                    if (checkError(data)) {
                        for (var i=0; i<statusModel.count; i++) {
                            if (statusModel.get(i).itemId === locId) {
                                console.log(locId);
                                statusModel.setProperty(i, "like", data.like);
                                break;
                            }
                        }
                    }
                    else {
                        error(doc.status, doc.statusText, false)
                    }
                }
            }
        }

        doc.send(JSON.stringify(status));
    }
}


function refreshStatuses(userId){

    if(userId){
        // Send info to the server
        var doc = new XMLHttpRequest();
        doc.open("GET", REQUEST_URL + qsTr("/api/status"), true);
        doc.setRequestHeader('Content-Type', 'application/json');
        doc.setRequestHeader('x-marbis-session', sessionId);
        doc.onreadystatechange = function()
        {
            // When ready
            if (doc.readyState === 4) {

                // If OK
                if (doc.status === 200) {
                    var data = JSON.parse(doc.responseText);


                    if (checkError(data)) {
                        statusModel.clear();
                        statusModel.append(data);
                    }
                    else {
                        error(doc.status, doc.statusText, false)
                    }
                }
            }
        }

        doc.send();
    }
}


function addComment(name, parent, itemId)
{
    console.log('Create item '+name)
    var locId = "local_" + (new Date().getTime());
    var processing = itemId ? false : true
    // Add item locally
    commentsModel.insert(0, { "itemId": locId, "body": name, "status":parent, "itemDone": false, "itemProcessing": processing})
    firstDoneIndex++;
    // if itemId not provided sync to backend
    if(!itemId){
        // Send info to the server
        var doc = new XMLHttpRequest();
        doc.open("POST", REQUEST_URL + "/api/comments", true);
        doc.setRequestHeader('Content-Type', 'application/json');
        doc.setRequestHeader('x-marbis-session', sessionId);
        doc.onreadystatechange = function()
        {
            // When ready
            if (doc.readyState === 4) {

                // If OK
                if (doc.status === 200) {
                    var data = JSON.parse(doc.responseText);


                    if (checkError(data)) {
                        for (var i=0; i<commentsModel.count; i++) {
                            if (commentsModel.get(i).itemId === locId) {
                                console.log(locId);
                                commentsModel.setProperty(i, "body", data.body);
                                commentsModel.setProperty(i, "itemProcessing", false)
                                break;
                            }
                        }
                    }
                    else {
                        error(doc.status, doc.statusText, false)
                    }
                }
            }
        }

        doc.send(JSON.stringify({ "itemId": locId, "body": name, "status":parent, "itemDone": false, "itemProcessing": processing}));
    }
}


function refreshComments(statusId){

    if(statusId){
        // Send info to the server
        var doc = new XMLHttpRequest();
        doc.open("GET", REQUEST_URL + qsTr("/api/comments/status/%1").arg(statusId), true);
        doc.setRequestHeader('Content-Type', 'application/json');
        doc.setRequestHeader('x-marbis-session', sessionId);
        doc.onreadystatechange = function()
        {
            // When ready
            if (doc.readyState === 4) {

                // If OK
                if (doc.status === 200) {
                    var data = JSON.parse(doc.responseText);


                    if (checkError(data)) {
                        commentsModel.clear();
                        commentsModel.append(data);
                    }
                    else {
                        error(doc.status, doc.statusText, false)
                    }
                }
            }
        }

        doc.send();
    }
}


function addChat(name, recipient)
{
    console.log('Create item '+name)
    var locId = "local_" + (localId++);
    var processing = recipient._id ? false : true
    // Add item locally
    chatModel.insert(0, { "itemId": locId, "chat": name, "recipient": recipient, "itemDone": false, "itemProcessing": processing})
    firstDoneIndex++;
    // if itemId not provided sync to backend
    if(recipient.id){
        // Send info to the server
        var doc = new XMLHttpRequest();
        doc.open("POST", REQUEST_URL + "/api/chats", true);
        doc.setRequestHeader('Content-Type', 'application/json');
        doc.setRequestHeader('x-marbis-session', sessionId);
        doc.onreadystatechange = function()
        {
            // When ready
            if (doc.readyState === 4) {

                // If OK
                if (doc.status === 200) {
                    var data = JSON.parse(doc.responseText);


                    if (checkError(data)) {
                        for (var i=0; i<chatModel.count; i++) {
                            if (chatModel.get(i).itemId === locId) {
                                console.log(locId);
                                chatModel.setProperty(i, "chat", data.chat);
                                chatModel.setProperty(i, "itemProcessing", false)
                                break;
                            }
                        }
                    }
                    else {
                        error(doc.status, doc.statusText, false)
                    }
                }
            }
        }

        doc.send(JSON.stringify({ "itemId": locId, "chat": name, "recipient": recipient, "itemDone": false, "itemProcessing": processing}));
    }
}

function refreshChats(userId){

    if(userId){
        // Send info to the server
        var doc = new XMLHttpRequest();
        doc.open("GET", REQUEST_URL + qsTr("/api/chats/user/%1").arg(userId), true);
        doc.setRequestHeader('Content-Type', 'application/json');
        doc.setRequestHeader('x-marbis-session', sessionId);
        doc.onreadystatechange = function()
        {
            // When ready
            if (doc.readyState === 4) {

                // If OK
                if (doc.status === 200) {
                    var data = JSON.parse(doc.responseText);


                    if (checkError(data)) {
                        chatModel.clear();
                        chatModel.append(data);
                    }
                    else {
                        error(doc.status, doc.statusText, false)
                    }
                }
            }
        }

        doc.send();
    }
}


function finishItem(row, remote)
{
    console.log('Complete item')
    var processing = remote ? true : false
    if (row >= 0 && row < itemModel.count)
    {
        // Set item finished locally
        itemModel.setProperty(row, "itemDone", true);
        itemModel.setProperty(row, "itemProcessing", processing);
        var obj = itemModel.get(row)
        if (row !== firstDoneIndex && row !== (firstDoneIndex-1))
            itemModel.move(row,firstDoneIndex-1,1)
        firstDoneIndex--;
        if(remote === true) {
            // Send information to the server
            var doc = new XMLHttpRequest();
            doc.open("PUT", REQUEST_URL + "/api/todos/"+obj.itemId, true);
            doc.setRequestHeader('Content-Type', 'application/json');
            doc.setRequestHeader('x-todo-session', sessionId);
            doc.onreadystatechange = function()
            {
                // When ready
                if (doc.readyState === 4) {

                    // If OK
                    if (doc.status === 200) {
                        var data = JSON.parse(doc.responseText);
                        if (checkError(data)) {
                            for (var i=0; i<itemModel.count; i++) {
                                if (itemModel.get(i).itemId === data.id) {
                                    itemModel.setProperty(i, "itemProcessing", false)
                                    break;
                                }
                            }
                        }
                    }
                    else {
                        error(doc.status, doc.statusText, false)
                    }
                }
            }
            doc.send(JSON.stringify({ "text": obj.itemName, "done": true, "device": device }));
        }
    }
}

function deleteItem(row, remote)
{
    console.log("Delete item")
    if (row >= 0 && row < itemModel.count)
    {
        // Delete locally
        var id = itemModel.get(row).itemId;
        itemModel.remove(row);

        if(remote === true) {
            // Send info to server
            var doc = new XMLHttpRequest();
            doc.open("DELETE", REQUEST_URL + "/api/todos/"+id, true);
            doc.setRequestHeader('Content-Type', 'application/json');
            doc.setRequestHeader('x-todo-session', sessionId);
            doc.send();
        }
    }
}

function handleWebsocketMessage(message) {
    var messageJson = JSON.parse(message)
    var event = messageJson.meta.eventName
    var object = messageJson.object
    console.log("Message received", event, object.text);
    console.log("Message payload:" ,message);

    if(object.device !== device) { // ignore events created by this app
        var i
        if(event === "create") {
            addItem(object.text, object.id)
        }
        else if(event === "update") {
            for (i=itemModel.count; i--;) {
                if( object.id === itemModel.get(i).itemId) {
                    finishItem(i, false)
                    break;
                }
            }
        }
    }
    if(event === "delete") {
        for (i=itemModel.count; i--;) {
            if( object.id === itemModel.get(i).itemId) {
                deleteItem(i, false)
                break;
            }
        }
    }
}
