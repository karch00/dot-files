import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    
    // Background with wallpaper
    Image {
        id: background
        anchors.fill: parent
        source: "WP.png"
        fillMode: Image.PreserveAspectCrop
    }
    
    // Dark overlay
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.45
    }
    
    Column {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -100
        spacing: 0
        
        // Clock
        Text {
            id: timeLabel
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "JetBrains Mono"
            font.pixelSize: 80
            color: "#efefef"
            text: Qt.formatTime(new Date(), "hh:mm:ss")
            
            Timer {
                interval: 1000
                repeat: true
                running: true
                onTriggered: {
                    timeLabel.text = Qt.formatTime(new Date(), "hh:mm:ss")
                    dateLabel.text = Qt.formatDate(new Date(), "dd/MM/yyyy")
                }
            }
        }
        
        // Date
        Text {
            id: dateLabel
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "JetBrains Mono"
            font.pixelSize: 24
            color: "#efefef"
            text: Qt.formatDate(new Date(), "dd/MM/yyyy")
            
            // Add some spacing
            anchors.topMargin: -16
        }
        
        // Spacer
        Item {
            width: 1
            height: 80
        }
        
        // Main login container
        Rectangle {
            id: loginContainer
            width: 500
            height: 300
            anchors.horizontalCenter: parent.horizontalCenter
            
            color: "transparent"
            border.color: "rgba(255,255,255,0.75)"
            border.width: 2
            radius: 15
            
            // Background with transparency
            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.45
                radius: 15
            }
            
            Column {
                anchors.centerIn: parent
                spacing: 20
                
                // Welcome text
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "JetBrains Mono"
                    font.pixelSize: 24
                    color: "#efefef"
                    text: "-Welcome back-"
                }
                
                // Profile section
                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: -16
                    
                    // Profile picture
                    Rectangle {
                        id: profilePic
                        width: 80
                        height: 80
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        color: "transparent"
                        border.color: "rgba(255,255,255,0.75)"
                        border.width: 2
                        radius: 8
                        
                        Image {
                            anchors.fill: parent
                            anchors.margins: 2
                            source: "PF.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                    
                    // Profile name
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: "JetBrains Mono"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        color: "#efefef"
                        text: "karch"
                    }
                }
                
                // Login form
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 0
                    
                    // Password input
                    Rectangle {
                        width: 100
                        height: 30
                        color: "black"
                        opacity: 0.5
                        border.color: "rgba(255,255,255,0.75)"
                        border.width: 2
                        radius: 10
                        
                        // Remove right border and radius
                        Rectangle {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 2
                            color: "black"
                            opacity: 0.5
                        }
                        
                        TextInput {
                            id: passwordInput
                            anchors.fill: parent
                            anchors.margins: 8
                            anchors.rightMargin: 10
                            
                            font.family: "JetBrains Mono"
                            font.pixelSize: 16
                            color: "#efefef"
                            echoMode: TextInput.Password
                            focus: true
                            
                            selectByMouse: true
                            selectionColor: "rgba(255,255,255,0.3)"
                            
                            onAccepted: {
                                sddm.login(sddm.userModel.lastUser, passwordInput.text, sessionCombo.currentIndex)
                            }
                            
                            Keys.onPressed: {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    sddm.login(sddm.userModel.lastUser, passwordInput.text, sessionCombo.currentIndex)
                                }
                            }
                        }
                    }
                    
                    // Login button
                    Rectangle {
                        width: 32
                        height: 30
                        color: "black"
                        opacity: 0.5
                        border.color: "rgba(255,255,255,0.75)"
                        border.width: 2
                        radius: 10
                        
                        // Remove left border and radius
                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 2
                            color: "black"
                            opacity: 0.5
                        }
                        
                        // Arrow SVG
                        Canvas {
                            id: arrow
                            anchors.centerIn: parent
                            width: 25
                            height: 25
                            
                            property real scale: loginMouseArea.containsMouse ? 1.15 : 1.0
                            transform: Scale { 
                                xScale: arrow.scale
                                yScale: arrow.scale
                                origin.x: arrow.width/2
                                origin.y: arrow.height/2
                            }
                            
                            Behavior on scale {
                                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                            }
                            
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.strokeStyle = "#efefef"
                                ctx.lineWidth = 1.5
                                ctx.beginPath()
                                
                                // Draw arrow path (simplified version of your SVG)
                                ctx.moveTo(8, 12)
                                ctx.lineTo(17, 12)
                                ctx.moveTo(13, 8)
                                ctx.lineTo(17, 12)
                                ctx.lineTo(13, 16)
                                
                                ctx.stroke()
                            }
                        }
                        
                        MouseArea {
                            id: loginMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                sddm.login(sddm.userModel.lastUser, passwordInput.text, sessionCombo.currentIndex)
                            }
                        }
                    }
                }
                
                // Error message
                Text {
                    id: errorMessage
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "JetBrains Mono"
                    font.pixelSize: 12
                    color: "red"
                    text: "Incorrect password"
                    visible: false
                }
            }
        }
        
        // Spacer
        Item {
            width: 1
            height: 16
        }
        
        // Utility buttons
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16
            
            // Shutdown button
            Rectangle {
                width: 40
                height: 40
                color: "black"
                opacity: 0.45
                border.color: "rgba(255,255,255,0.75)"
                border.width: 2
                radius: 10
                
                Image {
                    id: shutdownIcon
                    anchors.centerIn: parent
                    width: 25
                    height: 25
                    source: "assets/shutdown.png"
                    
                    property real scale: shutdownMouseArea.containsMouse ? 1.15 : 1.0
                    transform: Scale { 
                        xScale: shutdownIcon.scale
                        yScale: shutdownIcon.scale
                        origin.x: shutdownIcon.width/2
                        origin.y: shutdownIcon.height/2
                    }
                    
                    Behavior on scale {
                        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                    }
                }
                
                MouseArea {
                    id: shutdownMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.powerOff()
                }
            }
            
            // Restart button
            Rectangle {
                width: 40
                height: 40
                color: "black"
                opacity: 0.45
                border.color: "rgba(255,255,255,0.75)"
                border.width: 2
                radius: 10
                
                Image {
                    id: restartIcon
                    anchors.centerIn: parent
                    width: 25
                    height: 25
                    source: "assets/restart.png"
                    
                    property real scale: restartMouseArea.containsMouse ? 1.15 : 1.0
                    transform: Scale { 
                        xScale: restartIcon.scale
                        yScale: restartIcon.scale
                        origin.x: restartIcon.width/2
                        origin.y: restartIcon.height/2
                    }
                    
                    Behavior on scale {
                        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                    }
                }
                
                MouseArea {
                    id: restartMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.reboot()
                }
            }
            
            // Suspend button
            Rectangle {
                width: 40
                height: 40
                color: "black"
                opacity: 0.45
                border.color: "rgba(255,255,255,0.75)"
                border.width: 2
                radius: 10
                
                Image {
                    id: suspendIcon
                    anchors.centerIn: parent
                    width: 25
                    height: 25
                    source: "assets/suspend.png"
                    
                    property real scale: suspendMouseArea.containsMouse ? 1.15 : 1.0
                    transform: Scale { 
                        xScale: suspendIcon.scale
                        yScale: suspendIcon.scale
                        origin.x: suspendIcon.width/2
                        origin.y: suspendIcon.height/2
                    }
                    
                    Behavior on scale {
                        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                    }
                }
                
                MouseArea {
                    id: suspendMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.suspend()
                }
            }
        }
    }
    
    // Hidden session combo (you can make this visible if needed)
    ComboBox {
        id: sessionCombo
        visible: false
        model: sessionModel
        currentIndex: sessionModel.lastIndex
    }
    
    // Handle login attempts
    Connections {
        target: sddm
        function onLoginFailed() {
            errorMessage.visible = true
            passwordInput.text = ""
            passwordInput.focus = true
            
            // Hide error after 3 seconds
            errorTimer.start()
        }
        
        function onLoginSucceeded() {
            errorMessage.visible = false
        }
    }
    
    Timer {
        id: errorTimer
        interval: 3000
        onTriggered: {
            errorMessage.visible = false
        }
    }
}