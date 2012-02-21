import QtQuick 1.1
import com.nokia.meego 1.0

import "constants.js" as UI

Page {
    //    tools: commonTools

    property int bigPixelSize: 56
    property int mediumPixelSize: 36
    property int itemHeight: 120
    property int tipPercent: tipSlider.value
    property double totalSum: 0
    property double totalAndTip: 0

    onTipPercentChanged: {
        calculate()
    }

    anchors.margins: UI.DEFAULT_MARGIN

    BorderImage {
        anchors.fill: headerRect
        anchors { leftMargin: -10; topMargin: 0; rightMargin: -10; bottomMargin: -10 }
        border { left: 10; top: 10; right: 10; bottom: 10 }
        source: "qrc:images/shadow.png"; smooth: true
        visible: parent.height > 700
    }
    Rectangle {
        id: headerRect
        anchors {
            right: parent.right
            top: parent.top
            left: parent.left
            bottom: sliderItem.bottom
            leftMargin: -UI.DEFAULT_MARGIN
            topMargin: -UI.DEFAULT_MARGIN
            rightMargin: -UI.DEFAULT_MARGIN
            bottomMargin: -UI.DEFAULT_MARGIN / 2
        }
        gradient: Gradient {
            GradientStop {position: 0; color: "#CCC" }
            GradientStop {position: 1; color: "#BBB" }
        }
        visible: parent.height > 700
    }
    Item {
        id: tipItem
        anchors {

            left: parent.left
            top: parent.top

        }
        height: itemHeight
        width: parent.width / 2
        Label {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: tipPercent + " %"
            font.pixelSize: bigPixelSize
        }
        Label {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Tip"
            font.pixelSize: mediumPixelSize
        }
        visible: parent.height > 700
        MouseArea {
            anchors.fill: parent
            onClicked: {
                addPersonButton.visible = false
                removePersonButton.visible = false
                tipSlider.visible = true
            }
        }
    }

    Item {
        id: peopleItem
        anchors {
            left: tipItem.right
            top: parent.top
            right: parent.right
        }
        height: itemHeight
        Label {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: personListModel.count
            font.pixelSize: bigPixelSize
        }
        Label {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: "People"
            font.pixelSize: mediumPixelSize
        }
        visible: parent.height > 700
        MouseArea {
            anchors.fill: parent
            onClicked: {
                addPersonButton.visible = true
                removePersonButton.visible = true
                tipSlider.visible = false
            }
        }
    }

    Item {
        id: sliderItem
        anchors {
            left: parent.left
            right: parent.right
            top: tipItem.bottom
            topMargin: UI.DEFAULT_MARGIN / 2
        }
        height: 50
        Slider {
            id: tipSlider
            anchors.fill: parent
            value: 10
            maximumValue: 30
            minimumValue: 0
            stepSize: 1
        }
        Button {
            id: addPersonButton
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: 50
            anchors.top: parent.top
            width: 50

            text: "+"
            visible: false
            onClicked: {
                personListModel.append({
                                           name: "Person " + (personListModel.count + 1),
                                           payments: [{paymentValue: 0}],
                                           personTotal: 0,
                                           personTip: 0
                                       })
            }
        }
        Button {
            id: removePersonButton
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -50
            anchors.rightMargin: UI.DEFAULT_MARGIN
            anchors.top: parent.top
            width: 50

            text: "-"
            visible: false
            onClicked: {
                personListModel.remove(personListModel.count - 1)
            }
        }
        visible: parent.height > 700
    }

    ListView {
        id: personListView
        anchors {
            left: parent.left
            right: parent.right
            top: parent.height > 700 ? headerRect.bottom : parent.top
            topMargin: UI.DEFAULT_MARGIN
            bottom: totalItem.top
        }
        clip: true
        model: personListModel
        delegate:PersonDelegate {  }
    }

    BorderImage {
        anchors.fill: footerRect
        anchors { leftMargin: -10; topMargin: -10; rightMargin: -10; bottomMargin: 0 }
        border { left: 10; top: 10; right: 10; bottom: 10 }
        source: "qrc:images/shadow.png"; smooth: true
        visible: parent.height > 700 // TODO: Fix this tweak
    }
    Rectangle {
        id: footerRect
        anchors {
            right: parent.right
            top: totalItem.top
            left: parent.left
            bottom: parent.bottom
            leftMargin: -UI.DEFAULT_MARGIN
            topMargin: -UI.DEFAULT_MARGIN / 2
            rightMargin: -UI.DEFAULT_MARGIN
            bottomMargin: -UI.DEFAULT_MARGIN
        }
        gradient: Gradient {
            GradientStop {position: 0; color: "#CCC" }
            GradientStop {position: 1; color: "#BBB" }
        }
        visible: parent.height > 700
    }
    Item {
        id: totalItem
        anchors {

            left: parent.left
            bottom: parent.bottom

        }
        height: itemHeight
        width: parent.width / 2
        Label {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: totalSum.toFixed(1)
            font.pixelSize: bigPixelSize
        }
        Label {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Total"
            font.pixelSize: mediumPixelSize
        }
        visible: parent.height > 700
    }


    Item {
        id: totalTipItem
        anchors {
            left: totalItem.right
            right: parent.right
            bottom: parent.bottom

        }
        height: itemHeight
        Label {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: totalAndTip
            font.pixelSize: bigPixelSize
        }
        Label {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Total + tip"
            font.pixelSize: mediumPixelSize
        }
        visible: parent.height > 700
    }


    ListModel {
        id: personListModel

        ListElement {
            name: "Person 1"
            payments: [
                ListElement {
                    paymentValue: 0
                }
            ]
            personTotal: 0
            personTip: 0
        }
    }

    function calculate() {
        totalSum = 0.0
        for(var i = 0; i < personListModel.count; i++) {
            var payments = personListModel.get(i).payments
            var person = personListModel.get(i)
            person.personTip = 0
            person.personTotal = 0
            for(var j = 0; j < payments.count; j++) {
                var payment = parseFloat(payments.get(j).paymentValue)
                var paymentTip = tipPercent / 100 * payment
                person.personTip += paymentTip
                person.personTotal += payment + paymentTip
                totalSum += payment
            }
            console.log(personListModel.get(i).name)
//            var sum = 0.0
//            for(var j = 0; j < payments.count; j++) {
//                var str = "" + payments.get(j).paymentValue
//                sum += parseFloat(str.replace(",","."))
//            }
//            totalSum += sum
//            console.log("Person sum: " + sum)
        }
        totalAndTip = totalSum + tipPercent * totalSum / 100
        console.log("Total sum: " + totalSum)
    }
}
