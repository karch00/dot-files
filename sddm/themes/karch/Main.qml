import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    id: canvas
    width: 1920
    height: 1080

    property string avatar: "file:///var/lib/AccountsService/icons/" + userModel.lastUser
    property string wallpaper: "file:///usr/share/backgrounds/main_wp.png"

    // Load
    Component.onCompleted: {
        passwordinput.focus = true
    }

    // Wallpaper
    Image {
        id: wP
        x: 0
        y: 0
        source: wallpaper
        fillMode: Image.PreserveAspectFit
    }

    // Clock and date
    Text {
        id: clock
        x: 724
        y: 174
        color: "#efefef"
        text: Qt.formatTime(new Date(), "hh:mm:ss")
        font.pixelSize: 98
        horizontalAlignment: Text.AlignHCenter
        font.styleName: "SemiBold"
        font.family: "JetBrains Mono"
    }
    Text {
        id: clockdate
        x: 865
        y: 285
        color: "#efefef"
        text: Qt.formatDate(new Date(), "dd/MM/yyyy")
        font.pixelSize: 32
        font.styleName: "SemiBold"
        font.family: "JetBrains Mono"
    }
    Timer {
        id: clocktimer
        triggeredOnStart: true
        running: true
        repeat: true
        interval: 1000
        onTriggered: clock.text = Qt.formatTime(new Date(), "hh:mm:ss")
    }
    Timer {
        id: datetimer
        triggeredOnStart: true
        running: true
        repeat: true
        interval: 1000
        onTriggered: clockdate.text = Qt.formatDate(new Date(), "dd/MM/yyyy")
    }

    // Login panel
    Rectangle {
        id: loginpanel
        width: 600
        height: 400
        color: "#7c000000"
        radius: 10
        border.color: "#96ffffff"
        border.width: 2
        z: 1
        x: 660
        y: 409

        // Welcome
        Text {
            id: welcometext
            x: 162
            y: 28
            color: "#efefef"
            text: qsTr("Welcome back")
            font.pixelSize: 38
            font.styleName: "Bold"
            font.family: "JetBrains Mono"
        }

        // Avatar
        Image {
            id: avatarpic
            x: 236
            y: 91
            width: 128
            height: 128
	    source: avatar
            fillMode: Image.PreserveAspectCrop
	    
	    layer.enabled: true
	    layer.effect: OpacityMask {
		maskSource: Rectangle {
		    width: avatarpic.width
		    height: avatarpic.height
		    radius: avatarpic.width / 2
		    visible: false
		}
	    }
        }

        // Username
        Text {
            id: username
            x: 265
            y: 225
            color: "#efefef"
            text: userModel.lastUser
            font.pixelSize: 24
            font.styleName: "ExtraBold"
            font.family: "JetBrains Mono"
        }

        // Password
        Rectangle {
            id: passwordcontainer
            x: 190
            y: 289
            width: 220
            height: 35
            color: "#68000000"
            radius: 5
            border.color: "#96ffffff"
            border.width: 1.5

            TextInput {
                id: passwordinput
                x: 10
                y: 6
                width: 202
                height: 25
                color: "#efefef"
                font.pixelSize: 20
                maximumLength: 14
                font.family: "JetBrains Mono"
                echoMode: TextInput.Password
                focus: true
                selectByMouse: true

                HoverHandler {
                    cursorShape: Qt.IBeamCursor
                }

                onAccepted: {
                    sddm.login(userModel.lastUser, passwordinput.text, sessionModel.lastIndex)
                }

                Keys.onReturnPressed: {
                    sddm.login(userModel.lastUser, passwordinput.text, sessionModel.lastIndex)
                }

                Keys.onEnterPressed: {
                    sddm.login(userModel.lastUser, passwordinput.text, sessionModel.lastIndex)
                }
            }
        }

        // Incorrect Password Text
        Text {
            id: incorrectpassword
            x: 237
            y: 330
            color: "#ff0000"
            text: qsTr("Incorrect password")
            font.pixelSize: 12
            font.family: "JetBrains Mono"
            visible: false
        }
    }

    // Handle login response
    Connections {
        target: sddm
        function onLoginFailed() {
            incorrectpassword.visible = true
            passwordinput.text = ""
            passwordinput.focus = true
            
            // Hide error message after 3 seconds
            errorTimer.restart()
        }
        
        function onLoginSucceeded() {
            incorrectpassword.visible = false
        }
    }

    // Timer to hide error message
    Timer {
        id: errorTimer
        interval: 3000
        onTriggered: {
            incorrectpassword.visible = false
        }
    }

    // Hide error when user starts typing
    Connections {
        target: passwordinput
        function onTextChanged() {
            if (incorrectpassword.visible) {
                incorrectpassword.visible = false
            }
        }
    }
    
    // Login panel blur
    
    ShaderEffectSource {
        id: blursource
        sourceItem: wP
        sourceRect: Qt.rect(loginpanel.x, loginpanel.y, loginpanel.width,
                            loginpanel.height)
        live: true
        hideSource: false
        width: loginpanel.width
        height: loginpanel.height
        x: 660
        y: 409
        z: 0
    }
    FastBlur {
        id: loginblur
        anchors.fill: blursource
        source: blursource
        radius: 32
        z: 0
    }

    // Shutdown button
    Button {
        id: shutdownbutton
        x: 670
	y: 812
	z: 1
        width: 25
        height: 25
        flat: true

        contentItem: Item {
            x: 0
            y: 6
            width: shutdownbutton.width
            height: shutdownbutton.height

            Image {
                id: shutdownimage
		anchors.centerIn: parent
		antialiasing: true
		smooth: true
		mipmap: true

                source: "images/shutdown.svg"
                width: 15
                height: 15


                scale: shutdownarea.hovered ? 1.1 : 1
                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        HoverHandler {
            id: shutdownarea
            cursorShape: Qt.PointingHandCursor
        }

        background: Rectangle {
            color: "#68000000"
            radius: 5
            border.color: "#96ffffff"
            border.width: 1
        }

        onClicked: sddm.powerOff()
    }

    // Restart Button
    Button {
        id: restartbutton
        x: 700
	y: 812
	z: 1
        width: 25
        height: 25
        flat: true

        contentItem: Item {
            x: 0
            y: 6
            width: restartbutton.width
            height: restartbutton.height

            Image {
                id: restartimage
		anchors.centerIn: parent
		antialiasing: true
		smooth: true
		mipmap: true

                source: "images/restart.svg"
                width: 15
                height: 15

                scale: restartarea.hovered ? 1.1 : 1
                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        HoverHandler {
            id: restartarea
            cursorShape: Qt.PointingHandCursor
        }

        background: Rectangle {
            color: "#68000000"
            radius: 5
            border.color: "#96ffffff"
            border.width: 1
        }

        onClicked: sddm.reboot()
    }

    // Suspend button
    Button {
        id: suspendbutton
        x: 730
        y: 812
        width: 25
        height: 25
        flat: true

        contentItem: Item {
            x: 0
	    y: 6
	    z: 1
            width: suspendbutton.width
            height: suspendbutton.height

            Image {
                id: suspendimage
                anchors.centerIn: parent
		antialiasing: true
		smooth: true
		mipmap: true

                source: "images/suspend.svg"
                width: 15
                height: 15

                scale: suspendarea.hovered ? 1.1 : 1
                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        HoverHandler {
            id: suspendarea
            cursorShape: Qt.PointingHandCursor
        }

        background: Rectangle {
            color: "#68000000"
            radius: 5
            border.color: "#96ffffff"
            border.width: 1
        }

        onClicked: sddm.suspend()
    }


    states: [
        State {
            name: "clicked"
        }
    ]
}
