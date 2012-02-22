// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

TextField {
    MouseArea {
        anchors.fill: parent
        onPressed: {
            if(parent.text == "0" || parent.text == "0.0") {
                parent.selectAll()
                parent.forceActiveFocus()
            } else {
                mouse.accepted = false
            }
        }
        z: parent.z + 1
    }
}
