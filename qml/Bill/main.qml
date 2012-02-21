import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    MainPage {
        id: mainPage
    }

//    ToolBarLayout {
//        id: commonTools
//        visible: true
//        ToolIcon {
//            id: backButton
//            iconId: "toolbar-back-dimmed";
//            onClicked: {
//                console.log("Stop clicking backwards! You are already on the first page!")
//            }
//        }
//        ToolIcon {
//            id: addPersonButton
//            anchors.left: backButton.right
//            platformIconId: "toolbar-add"
//            onClicked: mainPage.addPerson()
//        }
//        ToolIcon {
//            id: calculateButton
//            anchors.left: addPersonButton.right
//            platformIconId: "toolbar-mediacontrol-play"
//            onClicked: mainPage.calculate()
//        }
//        ToolIcon {
//            id: menuButton
//            platformIconId: "toolbar-view-menu"
//            anchors.right: (parent === undefined) ? undefined : parent.right
//            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
//        }
//    }

//    Menu {
//        id: myMenu
//        visualParent: pageStack
//        MenuLayout {
//            MenuItem { text: qsTr("Sample menu item") }
//        }
//    }
}
