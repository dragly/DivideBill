// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import org.dragly 1.0
import "constants.js" as UI

Item {
    property alias titleText: titleLabel.text
    property alias subTitleText: subTitleLabel.text
    property string color: "black"
    property alias currencySymbolVisible: currencySymbolLabel.visible
    height: parent.height
    Label {
        id: currencySymbolLabel
        anchors {
            top: titleLabel.top
            topMargin: height/4
            left: titleLabel.left
            leftMargin: -width * 4/3
        }
        text: mainPage.currencySymbol
        font.pixelSize: parent.height / 5
        color: parent.color
    }

    Label {
        id: titleLabel
        anchors.top: parent.top
        anchors.topMargin: UI.DEFAULT_MARGIN / 2
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: bigPixelBaseSize - Math.max(4, text.length) * bigPixelScaleSize
        color: parent.color
    }
    Label {
        id: subTitleLabel
        anchors.bottom: parent.bottom
        anchors.bottomMargin: UI.DEFAULT_MARGIN / 2
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: mediumPixelSize
        font.capitalization: subTitleCapitalization
        color: parent.color
    }
}
