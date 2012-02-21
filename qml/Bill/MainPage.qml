import QtQuick 1.1
import com.nokia.meego 1.0

import "constants.js" as UI

Page {
    id: mainPage
    //    tools: commonTools

    property int bigPixelBaseSize: 70
    property int bigPixelScaleSize: 5
    property int mediumPixelSize: 28
    property int headerHeight: 100
    property int tipPercent: tipSlider.value
    property int sliderHeight: 50
    property double totalTipSum: 0
    property double totalSum: 0
    property double totalAndTipSum: 0
    property int subTitleCapitalization: Font.Normal
    property string normalColor: "black"
    property string selectedColor: "#4477FF"

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
        height: headerHeight
        width: parent.width / 2
        Label {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: tipPercent + " %"
            font.pixelSize: bigPixelBaseSize - Math.max(4, text.length) * bigPixelScaleSize
            color: sliderItem.state == "tipSlider" ? selectedColor : normalColor
        }
        Label {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Tip"
            font.pixelSize: mediumPixelSize
            font.capitalization: subTitleCapitalization
            color: sliderItem.state == "tipSlider" ? selectedColor : normalColor
        }
        visible: parent.height > 700
        MouseArea {
            anchors.fill: parent
            onClicked: {
                sliderItem.state = "tipSlider"
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
        height: headerHeight
        Label {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: personListModel.count
            font.pixelSize: bigPixelBaseSize - Math.max(4, text.length) * bigPixelScaleSize
            color: sliderItem.state == "personSlider" ? selectedColor : normalColor
        }
        Label {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: personListModel.count > 1 ? "People" : "Person"
            font.pixelSize: mediumPixelSize
            font.capitalization: subTitleCapitalization
            color: sliderItem.state == "personSlider" ? selectedColor : normalColor
        }
        visible: parent.height > 700
        MouseArea {
            anchors.fill: parent
            onClicked: {
                sliderItem.state = "personSlider"
            }
        }
    }

    Item {
        id: sliderItem
        state: "hidden"
        states: [
            State {
                name: "tipSlider"
                PropertyChanges {
                    target: personButtonItem
                    visible: false
                }
                PropertyChanges {
                    target: tipSlider
                    visible: true
                }
                PropertyChanges {
                    target: sliderItem
                    height: sliderHeight
                    visible: true
                }
            },
            State {
                name: "personSlider"
                PropertyChanges {
                    target: personButtonItem
                    visible: true
                }
                PropertyChanges {
                    target: tipSlider
                    visible: false
                }
                PropertyChanges {
                    target: sliderItem
                    height: sliderHeight
                    visible: true
                }
            },
            State {
                name: "hidden"
                PropertyChanges {
                    target: sliderItem
                    height: 0
                    visible: false
                }
            }

        ]
        anchors {
            left: parent.left
            right: parent.right
            top: tipItem.bottom
            topMargin: UI.DEFAULT_MARGIN / 2
        }
        height: sliderHeight
        Slider {
            id: tipSlider
            anchors.fill: parent
            value: 10
            maximumValue: 30
            minimumValue: 0
            stepSize: 1
        }
        Item {
            id: personButtonItem
            anchors.fill: parent
            Button {
                id: addPersonButton
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 50
                anchors.top: parent.top
                width: 50

                text: "+"
                onClicked: {
                    addPerson()
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
                onClicked: {
                    personListModel.remove(personListModel.count - 1)
                }
            }
        }
        visible: parent.height > 700
    }

    Item {
        state: advancedCheckbox.checked ? "advanced" : "simple"
        states: [
            State {
                name: "advanced"
                PropertyChanges {
                    target: personListView
                    visible: true
                }
                PropertyChanges {
                    target: simpleItems
                    visible: false
                }
            },
            State {
                name: "simple"
                PropertyChanges {
                    target: personListView
                    visible: false
                }
                PropertyChanges {
                    target: simpleItems
                    visible: true
                }
            }
        ]
        anchors {
            left: parent.left
            right: parent.right
            top: parent.height > 700 ? headerRect.bottom : parent.top
            topMargin: UI.DEFAULT_MARGIN
            bottom: footer.top
        }
        Item {
            id: simpleItems
            Column {
                anchors.fill: parent
                Label {
                    text: "Total amount on bill:"
                    font.pixelSize: mediumPixelSize
                }
                TextField {

                }
                Label {
                    text: "Taxes per person: 1234.5"
                }
                Row {
                    Label {
                        text: "To pay per person: 1234.5"
                        font.pixelSize: mediumPixelSize
                    }
                }
            }
        }

        ListView {
            id: personListView
            anchors.fill: parent

            clip: true
            model: personListModel
            delegate:PersonDelegate {  }
        }


        BorderImage {
            anchors.fill: advancedRect
            anchors { leftMargin: -5; topMargin: -5; rightMargin: -10; bottomMargin: -20 }
            border { left: 10; top: 10; right: 10; bottom: 10 }
            source: "qrc:images/shadow.png"; smooth: true
            visible: mainPage.height > 700 // TODO: Fix this tweak
        }
        Rectangle {
            id: advancedRect
            color: "darkgrey"
            anchors.fill: advancedCheckbox
            anchors.margins: -10
            anchors.bottomMargin: -20
            visible: mainPage.height > 700 // TODO: Fix this tweak
        }
        CheckBox {
            id: advancedCheckbox
            anchors {
                bottom: parent.bottom
                bottomMargin:  20
                left: parent.left
                leftMargin: 10
            }
            text: "Advanced"
            onClicked: {
                calculate()
            }
            visible: mainPage.height > 700 // TODO: Fix this tweak
        }
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
            top: footer.top
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

    Row {
        id: footer
        height: headerHeight
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Item {
            id: totalTipItem
            height: parent.height
            width: parent.width / 3
            Label {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text: totalTipSum.toFixed(1)
                font.pixelSize: bigPixelBaseSize - Math.max(4, text.length) * bigPixelScaleSize
            }
            Label {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Tip"
                font.pixelSize: mediumPixelSize
                font.capitalization: subTitleCapitalization
            }
            visible: mainPage.height > 700
        }

        Item {
            id: totalItem
            height: parent.height
            width: parent.width / 3
            Label {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text: totalSum.toFixed(1)
                font.pixelSize: bigPixelBaseSize - Math.max(4, text.length) * bigPixelScaleSize
            }
            Label {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Total"
                font.pixelSize: mediumPixelSize
                font.capitalization: subTitleCapitalization
            }
            visible: mainPage.height > 700
        }


        Item {
            id: totalAndTipItem
            height: parent.height
            width: parent.width / 3
            Label {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text: totalAndTipSum.toFixed(1)
                font.pixelSize: bigPixelBaseSize - Math.max(4, text.length) * bigPixelScaleSize
                color: selectedColor
            }
            Label {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Total + tip"
                font.pixelSize: mediumPixelSize
                font.capitalization: subTitleCapitalization
                color: selectedColor
            }
            visible: mainPage.height > 700
        }
    }


    ListModel {
        id: personListModel
        Component.onCompleted: {
            addPerson()
        }
    }

    // mouse area to detect mouse clicks outside the header
    MouseArea {
        anchors {
            top: headerRect.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }

        onPressed: {
            sliderItem.state = "hidden"
            mouse.accepted = false
        }
    }

    function addPerson() {
        personListModel.append({
                                   name: "Person " + (personListModel.count + 1),
                                   payments: [{paymentValue: 0}],
                                   personTotal: 0,
                                   personTip: 0,
                                   personTotalAndTip: 0
                               })
    }

    function calculate() {
        totalSum = 0.0
        totalTipSum = 0.0
        for(var i = 0; i < personListModel.count; i++) {
            var payments = personListModel.get(i).payments
            var person = personListModel.get(i)
            person.personTip = 0
            person.personTotal = 0
            person.personTotalAndTip = 0
            for(var j = 0; j < payments.count; j++) {
                var payment = parseFloat(payments.get(j).paymentValue)
                var paymentTip = tipPercent / 100 * payment
                person.personTip += paymentTip
                person.personTotal += payment
                person.personTotalAndTip += payment + paymentTip
                totalSum += payment
                totalTipSum += paymentTip
            }
            //            var sum = 0.0
            //            for(var j = 0; j < payments.count; j++) {
            //                var str = "" + payments.get(j).paymentValue
            //                sum += parseFloat(str.replace(",","."))
            //            }
            //            totalSum += sum
            //            console.log("Person sum: " + sum)
        }
        totalAndTipSum = totalSum + tipPercent * totalSum / 100
    }
}
