// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "constants.js" as UI
import "helpers.js" as Helpers

Item {
    id: delegateItem

    width: parent.width
    height:  65 + model.payments.count * 70 + UI.LIST_LAST_ELEMENT
    anchors.margins: 20
    Item {
        id: spacer
        anchors.top: parent.top
        height: UI.DEFAULT_MARGIN
    }

    Label {
        id: nameLabel
        text: model.name + ":"
        clip: true
        font.bold: true
        font.pixelSize: 30

        anchors  {
            top: spacer.bottom
            topMargin: 5
            left: parent.left
        }
    }
//    Button {
//        id: removePersonButton
//        text: "-"
//        width: 50
//        anchors  {
//            top: parent.top
//            right: parent.right
//        }

//        onClicked: {
//            personListModel.remove(index)
//        }
//    }

    Column {
        id: columnDelegate
        anchors {
            top: spacer.bottom
            right: parent.right
        }
        spacing: 10

        Repeater {
            id: paymentRepeater
            model: payments
            Row {
                spacing: 10
                TextFieldZero {
                    id: paymentField
                    width: delegateItem.width / 2 - removeButton.width - parent.spacing
                    text: model.paymentValue
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    onActiveFocusChanged: {
                        if(!activeFocus) {
                            payments.set(index, {paymentValue: text})
                            mainPage.calculatePayments()
                        }
                    }
                    onTextChanged: {
                        payments.set(index, {paymentValue: text})
                        mainPage.calculatePayments()
                    }

                    Keys.onReturnPressed: {
                        payments.set(index, {paymentValue: text})
                        mainPage.calculatePayments()
                        platformCloseSoftwareInputPanel()
                        focus = false
                    }
                }
                Button {
                    id: removeButton
                    text: "-"
                    width: 50
                    enabled: payments.count > 1

                    onClicked: {
                        payments.remove(index)
                        mainPage.calculatePayments()
                    }
                }
            }
        }
    }
    Label {
        id: tipLabel
        text: "Tip: "
        anchors {
            top: columnDelegate.bottom
            right: totalAndTipSumLabel.left
            rightMargin: 20
        }
        font.pixelSize: mainPage.smallPixelSize
        color: mainPage.mildColor
    }
    Label {
        id: tipSumLabel
        text: Helpers.rounded(personTip)
        anchors {
            top: tipLabel.top
            left: columnDelegate.left
            leftMargin: 20
        }
        font.pixelSize: mainPage.smallPixelSize
        color: mainPage.mildColor
    }
    Label {
        id: totalAndTipLabel
        text: "Total + tip: "
        anchors {
            top: tipLabel.bottom
            right: totalAndTipSumLabel.left
            rightMargin: 20
        }
        font.pixelSize: mainPage.smallPixelSize
        color: selectedColor
    }
    Label {
        id: totalAndTipSumLabel
        text: Helpers.rounded(personTotalAndTip)
        anchors {
            top: totalAndTipLabel.top
            left: columnDelegate.left
            leftMargin: 20
        }
        font.pixelSize: mainPage.smallPixelSize
        color: selectedColor
    }
//    Label {
//        id: totalLabel
//        text: "Total: " + personTotal.toFixed(1)
//        anchors {
//            top: addPaymentButton.top
//            left: columnDelegate.left
//            leftMargin: -30
//        }
//    }
    Button {
        id: addPaymentButton
        text: "+"
        width: 50
        anchors  {
            top: columnDelegate.bottom
            topMargin: 10
            right: parent.right
        }

        onClicked: {
            payments.append({paymentValue: 0})
            paymentRepeater.itemAt(paymentRepeater.count-1).children[0].forceActiveFocus()
            paymentRepeater.itemAt(paymentRepeater.count-1).children[0].selectAll()
        }
    }

    LineSeparator {
        anchors {
            top: addPaymentButton.bottom
            topMargin: UI.DEFAULT_MARGIN / 2
            left: parent.left
            right: parent.right
        }
    }

//    Label {
//        text: "Total + tip: " + personTotalAndTip.toFixed(1)
//        anchors {
//            top: totalLabel.bottom
//            left: totalLabel.left
//        }
//    }
}
