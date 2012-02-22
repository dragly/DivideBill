import QtQuick 1.1
import com.nokia.meego 1.0
import org.dragly 1.0

import "constants.js" as UI
import "helpers.js" as Helpers

Page {
    id: mainPage
    //    tools: commonTools

    property bool headerAndFooterVisible: mainPage.height > 700
    property bool advancedMode
    property bool includeTaxes
    property bool peopleLoaded: false

    property int hideAnimationDuration: 350

    property int smallPixelSize: 24
    property int bigPixelBaseSize: 70
    property int bigPixelScaleSize: 5
    property int mediumPixelSize: 28
    property int headerHeight: 100
    property int tipPercent: tipSlider.value
    property int taxPercent
    property int sliderHeight: 70
    property double totalTipSum: 0
    property double totalSum: 0
    property double totalAndTipSum: 0

    property double totalOnBill: 0
    property double totalPerPerson: totalOnBill / personListModel.count
    property double tipPerPerson: totalPerPerson * tipPercent / 100
    property double totalAndTipPerPerson: totalPerPerson + tipPerPerson

    property string currencySymbol: settings.value("currencySymbol","€")

    property int subTitleCapitalization: Font.Normal
    property string normalColor: "black"
    property string selectedColor: "#4477FF"
    property string mildColor: "#888888"

    anchors.margins: UI.DEFAULT_MARGIN

    orientationLock: PageOrientation.LockPortrait

    Component.onCompleted: {
        console.log("Main page loaded!")
    }

    Settings {
        id: settings
    }

    Item {
        id: mainViewItem
        state: advancedMode ? "advanced" : "simple"
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
            top: headerRect.bottom
            bottom: footer.top
        }
        Item {
            id: simpleItems
            anchors {
                fill: parent
            }
            Label {
                id: totalOnBillText
                anchors.centerIn: parent
                anchors.verticalCenterOffset: mainPage.height < 700 ? -parent.height / 3 : -parent.height / 5
                text: "Total on your bill:"
                font.pixelSize: 40
            }
            Label {
                anchors {
                    top: totalOnBillField.top
                    topMargin: height/2
                    left: totalOnBillField.left
                    leftMargin: -width * 4/3
                }
                text: mainPage.currencySymbol
                font.pixelSize: totalOnBillField.height / 3
            }
            TextFieldZero {
                id: totalOnBillField
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: totalOnBillText.bottom
                text: "0.0"
                font.pixelSize: 40
                height: 80
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                onTextChanged: {
                    mainPage.calculatePayments()
                }
                Keys.onReturnPressed: {
                    mainPage.calculatePayments()
                    platformCloseSoftwareInputPanel()
                }
                onActiveFocusChanged: {
                    if(!activeFocus) {
                        mainPage.calculatePayments()
                    }
                }
            }
            HeaderItem {
                id: tipsPerPersonItem
                anchors.left: parent.left
                anchors.top: totalOnBillField.bottom
                anchors.topMargin: 40
                height: headerHeight
                width: parent.width / 2

                color: mildColor

                titleText:  Helpers.rounded(tipPerPerson)
                subTitleText: "Tips each"
            }
            HeaderItem {
                id: totalPerPersonItem
                anchors.left: tipsPerPersonItem.right
                anchors.top: tipsPerPersonItem.top
                height: headerHeight
                width: parent.width / 2

                color: selectedColor

                titleText:  Helpers.rounded(totalAndTipPerPerson)
                subTitleText:"Total each"
            }
        }

        ListView {
            id: personListView
            anchors.fill: parent
            clip: true
            model: personListModel
            spacing: -UI.LIST_LAST_ELEMENT
            delegate:PersonDelegate {  }
            onCountChanged: {
                if(peopleLoaded) {
                    settings.setValue("people", personListModel.count)
                }
            }
        }


        BorderImage {
            anchors.fill: settingsButtonRect
            anchors { leftMargin: -5; topMargin: -5; rightMargin: -8; bottomMargin: -20 }
            border { left: 10; top: 10; right: 10; bottom: 10 }
            source: "qrc:images/shadow.png"; smooth: true
//            visible: mainPage.headerAndFooterVisible // TODO: Fix this tweak
        }

        Rectangle {
            id: settingsButtonRect
            color: "#CCC"
            anchors.fill: settingsButton
            anchors.margins: -10
            anchors.bottomMargin: -20
            radius: 6
//            visible: mainPage.headerAndFooterVisible // TODO: Fix this tweak
        }

        Button {
            id: settingsButton
            anchors {
                bottom: parent.bottom
                bottomMargin: UI.DEFAULT_MARGIN * 2/3
                left: parent.left
                leftMargin: UI.DEFAULT_MARGIN / 2
            }
            width: 50

            iconSource: "image://theme/icon-m-toolbar-settings"
            onClicked: {
                settingsSheet.open()
            }
//            visible: mainPage.headerAndFooterVisible
        }
    }


    BorderImage {
        anchors.fill: headerRect
        anchors { leftMargin: -10; topMargin: 0; rightMargin: -10; bottomMargin: -10 }
        border { left: 10; top: 10; right: 10; bottom: 10 }
        source: "qrc:images/shadow.png"; smooth: true
    }
    Rectangle {
        id: headerRect
        anchors {
            right: parent.right
            top: parent.top
            left: parent.left
            bottom: header.bottom
            leftMargin: -UI.DEFAULT_MARGIN
            topMargin: -UI.DEFAULT_MARGIN
            rightMargin: -UI.DEFAULT_MARGIN
            bottomMargin: -UI.DEFAULT_MARGIN / 2
        }
        gradient: Gradient {
            GradientStop {position: 0; color: "#CCC" }
            GradientStop {position: 1; color: "#BBB" }
        }
    }

    Item {
        id: header
        height: {
            if(sliderItem.state == "hidden") {
                return headerHeight
            } else {
                return headerHeight + sliderHeight
            }
        }

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: mainPage.headerAndFooterVisible ? 0 : -mainPage.headerHeight
        }

        Behavior on anchors.topMargin {
            NumberAnimation {
                duration: mainPage.hideAnimationDuration
                easing.type: Easing.InOutCubic
            }
        }

        HeaderItem {
            id: tipItem
            anchors {
                left: parent.left
                top: parent.top
            }
            height: headerHeight
            width: parent.width / 2

            titleText:  tipPercent + " %"
            subTitleText: "Tip"

            color: sliderItem.state == "tipSlider" ? selectedColor : normalColor
            currencySymbolVisible: false
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    sliderItem.state = "tipSlider"
                }
            }
        }

        HeaderItem {
            id: peopleItem
            anchors {
                left: tipItem.right
                top: parent.top
                right: parent.right
            }
            height: headerHeight
            width: parent.width / 2

            titleText: personListModel.count
            subTitleText: personListModel.count > 1 ? "People" : "Person"

            color: sliderItem.state == "personSlider" ? selectedColor : normalColor
            currencySymbolVisible: false
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
                value: settings.value("tipValue", 10)
                maximumValue: 30
                minimumValue: 0
                stepSize: 1
                onValueChanged: {
                    tipPercent = value
                    mainPage.calculatePayments()
                    settings.setValue("tipValue", value)
                }
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
                        if(personListModel.count > 1) {
                            personListModel.remove(personListModel.count - 1)
                        }
                    }
                }
            }
        }
    }



    BorderImage {
        anchors.fill: footerRect
        anchors { leftMargin: -10; topMargin: -10; rightMargin: -10; bottomMargin: 0 }
        border { left: 10; top: 10; right: 10; bottom: 10 }
        source: "qrc:images/shadow.png"; smooth: true
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
    }

    Row {
        id: footer
        height: mainPage.headerHeight
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: headerAndFooterVisible ? 0 : - mainPage.headerHeight
        }

        Behavior on anchors.bottomMargin {
            NumberAnimation {
                duration: mainPage.hideAnimationDuration
                easing.type: Easing.InOutCubic
            }
        }

        //        HeaderItem {
        //            id: totalItem
        //            color: mildColor
        //            width: parent.width / 3
        //            titleText:  Helpers.rounded(totalSum)
        //            subTitleText: "Total"
        //        }


        HeaderItem {
            id: totalTipItem
            color: mildColor
            width: parent.width / 2
            titleText: Helpers.rounded(totalTipSum)
            subTitleText: "Tip"
        }

        HeaderItem {
            id: totalAndTipItem
            width: parent.width / 2
            titleText:  Helpers.rounded(totalAndTipSum)
            subTitleText: "Total + tip"

            color: selectedColor
        }
    }
    Sheet {
        id: settingsSheet
        //        visualParent: mainViewItem
        acceptButtonText: qsTr("Save")
        content {
            SettingsView {
                id: settingsView
            }
        }
    }

    ListModel {
        id: personListModel
        Component.onCompleted: {
            var nPeople = settings.value("people", 3)
            console.log("Adding " + nPeople + " people")
            for(var i = 0; i < nPeople; i++) {
                mainPage.addPerson()
            }
            peopleLoaded = true
        }
    }

    // mouse area to detect mouse clicks outside the header
    MouseArea {
        id: outsideArea
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
                                   personTotalAndTip: 0,
                                   personTaxes: 0
                               })
    }

    function calculatePayments() {
        totalSum = 0.0
        totalTipSum = 0.0
        if(advancedMode) {
            for(var i = 0; i < personListModel.count; i++) {
                var payments = personListModel.get(i).payments
                var person = personListModel.get(i)
                person.personTip = 0
                person.personTotal = 0
                person.personTotalAndTip = 0
                for(var j = 0; j < payments.count; j++) {
                    var payment = Helpers.parseFloatComma(payments.get(j).paymentValue)
                    var paymentTip = tipPercent / 100 * payment
                    var paymentTaxes = taxPercent / 100 * payment
                    person.personTip += paymentTip
                    person.personTaxes += paymentTaxes
                    person.personTotal += payment + paymentTaxes
                    person.personTotalAndTip += payment + paymentTaxes + paymentTip
                    totalSum += payment + paymentTaxes
                    totalTipSum += paymentTip
                }
                //            var sum = 0.0
                //            for(var j = 0; j < payments.count; j++) {
                //                var str = "" + payments.get(j).paymentValue
                //                sum += Helpers.parseFloatComma(str.replace(",","."))
                //            }
                //            totalSum += sum
                //            console.log("Person sum: " + sum)
            }
        } else {
            totalOnBill = Helpers.parseFloatComma(totalOnBillField.text)
            totalSum = totalOnBill
            totalTipSum  = totalSum * tipPercent / 100
        }
        totalAndTipSum = totalSum + totalTipSum
    }
}
