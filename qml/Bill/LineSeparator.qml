// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    height: 4
    width: parent.width
    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.0) }
        GradientStop { position: 0.2; color: Qt.rgba(1, 1, 1, 0.4) }
        GradientStop { position: 0.8; color: Qt.rgba(1, 1, 1, 0.4) }
        GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.0) }
    }

}

