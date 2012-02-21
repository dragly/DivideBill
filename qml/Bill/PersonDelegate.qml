// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: delegateItem

    width: parent.width
    height: 75 + payments.count * 70
    anchors.margins: 20
    Label {
        id: nameLabel
        text: model.name + ":"
        clip: true
        font.bold: true
        font.pixelSize: 30

        anchors  {
            top: parent.top
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
            top: parent.top
            right: parent.right
        }
        spacing: 10

        Repeater {
            id: paymentRepeater
            model: payments
            Row {
                spacing: 10
                TextField {
                    id: paymentField
                    width: delegateItem.width / 2 - removeButton.width - parent.spacing
                    text: model.paymentValue
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    onActiveFocusChanged: {
                        if(!focus) {
                            payments.set(index, {paymentValue: text})
                            calculate()
                        }
                    }
                }
                Button {
                    id: removeButton
                    text: "-"
                    width: 50
                    enabled: payments.count > 1

                    onClicked: {
                        payments.remove(index)
                        calculate()
                    }
                }
            }
        }
    }
    Label {
        id: tipCalculatedText
        text: "Tip: " + personTip.toFixed(1)
        anchors {
            verticalCenter: addPaymentButton.verticalCenter
            left: parent.left
        }
    }
    Label {
        text: "Total: " + personTotal.toFixed(1)
        anchors {
            verticalCenter: addPaymentButton.verticalCenter
            left: columnDelegate.left
        }
    }
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
}
