// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "constants.js" as UI

Flickable {
    property alias includeTaxesChecked: includeTaxesCheckbox.checked
    property alias advancedModeChecked: advancedCheckbox.checked
    property alias taxValue: taxSlider.value
    anchors {
        fill: parent
        margins: UI.DEFAULT_MARGIN
    }
    contentHeight: sheetColumn.height
    Column {
        id: sheetColumn
        width: parent.width
        spacing: UI.DEFAULT_MARGIN
        SwitchAndLabel {
            id: advancedCheckbox
            text: "Advanced mode"
            checked: settings.value("advancedMode", false)
            onCheckedChanged: {
                mainPage.advancedMode = checked
                mainPage.calculatePayments()
                if(!checked) {
                    includeTaxesCheckbox.checked = false
                }
                settings.setValue("advancedMode", checked)
            }
        }
        Label {
            width: parent.width
            text: "The advanced mode let's you specify several items per person."
            font.pixelSize: smallPixelSize
            wrapMode: Text.WordWrap
        }
        Row {
            spacing: UI.DEFAULT_MARGIN
            Label {
                text: "Currency symbol:"
                anchors {
                    verticalCenter: parent.verticalCenter
                }
            }
            TextField {
                anchors {
                    verticalCenter: parent.verticalCenter
                }
                width: 150
                text: mainPage.currencySymbol
                onTextChanged: {
                    settings.setValue("currencySymbol", text)
                    mainPage.currencySymbol = text
                }
            }
        }

        SwitchAndLabel {
            id: includeTaxesCheckbox
            text: "Calculate taxes"
            enabled: advancedMode
            checked: settings.value("includeTaxes", false)
            onCheckedChanged: {
                updateTaxes()
                settings.setValue("includeTaxes", includeTaxesCheckbox.checked)
            }
            color: advancedMode ? "black" : "darkGrey"
        }
        Label {
            text: "Taxes:    " + taxSlider.value.toFixed(0) + " %"
            enabled: mainPage.includeTaxes
            color: mainPage.includeTaxes ? "black" : "darkGrey"
        }
        Slider {
            width: parent.width
            id: taxSlider
            value: settings.value("taxValue", 25)
            minimumValue: 0
            maximumValue: 50
            enabled: mainPage.includeTaxes
            onValueChanged: {
                updateTaxes()
                settings.setValue("taxValue", taxSlider.value)
            }
        }
        Label {
            width: parent.width
            text: "When '" + includeTaxesCheckbox.text + "' is enabled, it is assumed that every item entered is before tax. Tax will then be calculated based on the above settings and included in the total sum. Tips are still calculated based on the before tax values."
            font.pixelSize: smallPixelSize
            wrapMode: Text.WordWrap
            visible: mainPage.includeTaxes
        }
        Label {
            text: "About Split That Bill"
            font.pixelSize: mediumPixelSize
        }
        Label {
            width: parent.width
            text: "Split That Bill is a simple application that helps you divide your bill between your friends. In the simple mode it lets you type in a total sum, a tip percentage and the number of people that should split the bill.\n\nIn the advanced mode you may specify the exact items that each person should pay for, get the total and tips for each person and the grand total with tips included.\n\nSplit That Bill is free (libre) open source software released under the GNU GPLv3 license.\n\nThis application is provided as-is, with no warranty expressed or implied.  Use this application at your own risk.  The author assumes no liability for any loss associated with the use of this application.  If you do not agree with the terms of this license, do not use this application.\n\nFor support, visit/contact:\nhttp://dragly.org/source/split-that-bill/\nsplitbill@dragly.org"
            font.pixelSize: smallPixelSize
            wrapMode: Text.WordWrap
        }
    }
    function updateTaxes() {
        mainPage.includeTaxes = includeTaxesCheckbox.checked
        if(includeTaxesCheckbox.checked) {
            mainPage.taxPercent = taxSlider.value
        } else {
            mainPage.taxPercent = 0
        }

        mainPage.calculatePayments()
    }
}
