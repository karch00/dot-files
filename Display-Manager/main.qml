import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtGraphicalEffects 1.12

Item {
    id: canvas
    width: 1920
    height: 1080

    property string username: "karch" // Make permanent
    property string avatar: "images/PF.png" // Change sddm

    // Load
    Component.onCompleted: {
        auth.user = "karch"
    }

    // Wallpaper
    Image {
        id: wP
        x: 0
        y: 0
        source: "images/WP.png"
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
        }

        // Username
        Text {
            id: username
            x: 265
            y: 225
            color: "#efefef"
            text: username
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
                y: 8
                width: 202
                height: 25
                color: "#efefef"
                font.pixelSize: 24
                maximumLength: 14
                font.family: "JetBrains Mono"
                echoMode: TextInput.Password

                HoverHandler {
                    cursorShape: Qt.IBeamCursor
                }

                onAccepted: {
                    auth.password = passwordinput.text
                    auth.login()
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
            visible: auth.failed
        }

    // Login panel blur
    }
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
    Blur {
        id: loginblur
        anchors.fill: blursource
        source: blursource
        radius: 32
        samples: 32
        z: 1
    }

    // Shutdown button
    Button {
        id: shutdownbutton
        x: 660 + 20
        y: 815
        width: 50
        height: 60
        flat: true

        contentItem: Item {
            x: 0
            y: 6
            width: 50
            height: 48

            Image {
                id: shutdownimage
                anchors.centerIn: parent

                source: "images/shutdown.svg"
                width: 30
                height: 30


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
            border.width: 2
        }

        onClicked: sddm.powerOff()
    }

    // Restart Button
    Button {
        id: restartbutton
        x: 750
        y: 815
        width: 50
        height: 60
        flat: true

        contentItem: Item {
            x: 0
            y: 6
            width: 50
            height: 48

            Image {
                id: restartimage
                anchors.centerIn: parent

                source: "images/restart.svg"
                width: 30
                height: 30

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
            border.width: 2
        }

        onClicked: sddm.reboot()
    }

    // Suspend button
    Button {
        id: suspendbutton
        x: 820
        y: 815
        width: 50
        height: 60
        flat: true

        contentItem: Item {
            x: 0
            y: 6
            width: 50
            height: 48

            Image {
                id: suspendimage
                anchors.centerIn: parent

                source: "images/suspend.svg"
                width: 30
                height: 30

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
            border.width: 2
        }

        onClicked: sddm.suspend()
    }


    states: [
        State {
            name: "clicked"
        }
    ]
}
