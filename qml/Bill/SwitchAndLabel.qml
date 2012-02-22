// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

    Switch {
        property string text: ""
        property alias color: switchLabel.color
        Label {
            id: switchLabel
            text: parent.text
            enabled: parent.enabled
            anchors {
                leftMargin: 10
                left: parent.right
                verticalCenter: parent.verticalCenter
            }
        }
        MouseArea {
            anchors.left: parent.left
            anchors.right: switchLabel.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            onClicked: {
                parent.checked = !parent.checked
            }
        }
    }
