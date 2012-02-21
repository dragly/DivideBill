// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

Page {
    id: calculatedPage
    property alias listModel: myListModel
    property double totalSum
    property double totalSumWithTip: totalSum + totalSum * tipTumblerColumn.selectedIndex / 100
    property double totalTip: totalSum * tipTumblerColumn.selectedIndex / 100

    anchors.margins: 20

    ListModel {
        id: myListModel
    }

    tools: ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {pageStack.pop()}
        }
    }

    Label {
        id: tipText
        text: "Tip:"
        anchors {
            verticalCenter: tipField.verticalCenter
            left: parent.left
        }
    }

    ListModel {
        id: percentList
        Component.onCompleted: {
            for(var i = 0; i < 100; i++) {
                percentList.append({value: i})
            }
        }
    }

    TumblerColumn {
        id: tipTumblerColumn
        selectedIndex: 0
        items: percentList
    }

    Item {
        id: tipField
        anchors {
            left: tipText.right
            leftMargin: 20
            top: parent.top
        }
        width: 100
        height: 200
        Tumbler {
            id: tipTumbler
            anchors.fill: parent
            columns: [tipTumblerColumn]
        }
    }

    Label {
        text: "%"
        anchors {
            left: tipField.right
            verticalCenter: tipField.verticalCenter
        }
    }

    ListView {
        id: personListView
        anchors {
            left: parent.left
            top: tipField.bottom
            topMargin: 20
            bottom: parent.bottom
            right: parent.right
        }
        model: myListModel
        clip: true
        delegate: Item {
            height: 50
            width: parent.width
            Label {
                anchors.left: parent.left
                anchors.top: parent.top
                text: model.name
            }
            Label {
                anchors.top: parent.top
                anchors.right: parent.right
                text: model.sum + model.sum * tipTumblerColumn.selectedIndex / 100
            }
        }
    }

    Label {
        text: "Tip: " + totalTip
        anchors {
            bottom: totalText.top
            left: parent.left
        }
    }

    Label {
        id: totalText
        text: "Total: " + totalSumWithTip
        anchors {
            bottom: parent.bottom
            left: parent.left
        }
    }
}
