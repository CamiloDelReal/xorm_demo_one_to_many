import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.impl 2.14
import QtQuick.Controls.Material 2.14
import QtQuick.Layouts 1.14

import XApps.XOrmDemoOneToMany 1.0

import "qrc:/qml"
import "qrc:/qml/delegates"

XPane {
    id: memberEditionView

    property var listingListener: sharedData

    MemberEditionViewModel {
        id: viewModel

        onMemberCreated: {
            homeNavController.goBack()
            listingListener.update()
        }
    }

    XScrollView {
        id: scrollview
        anchors.fill: parent
        ScrollIndicator.vertical: ScrollIndicator {}

        ColumnLayout {
            id: layout
            width: scrollview.contentView.availableWidth
            spacing: 12

            XHeadlineLabel {
                Layout.fillWidth: true
                text: qsTr("New member")
            }

            XFormTextField {
                id: txfName
                placeholderText: qsTr("Full Name")
                font.pixelSize: 18
                Layout.fillWidth: true
                Layout.topMargin: 12
            }

            XFormTextField {
                id: txfJob
                placeholderText: qsTr("Job")
                wrapMode: TextArea.Wrap
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 12

                XTitleLabel {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    text: qsTr("Projects")
                }

                ToolButton {
                    Layout.alignment: Qt.AlignVCenter
                    icon.color: memberEditionView.Material.foreground
                    icon.source: "qrc:/img/icons/plus.svg"
                    display: IconLabel.IconOnly
                    onClicked: homeNavController.gotoView(homeNavController.projectEditionViewIndex, viewModel)
                }
            }

            Repeater {
                model: viewModel.projectModel
                delegate: ProjectDelegate {}
            }
        }
    }

    XPane {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 16
        radius: height / 2
        Material.elevation: 3
        padding: 2
        visible: opacity > 0
        opacity: viewModel.isWorking ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }

        BusyIndicator {
            anchors.centerIn: parent
            implicitWidth: 32
            implicitHeight: 32
        }
    }

    XToast {
        id: toast
    }

    XRoundButton {
        id: btnNew
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        icon.source: "qrc:/img/icons/check.svg"
        onClicked: {
            if(txfName.text.length > 0 && txfJob.text.length > 0) {
                viewModel.createMember(txfName.text, txfJob.text)
            } else {
                toast.showText(qsTr("There are empty fields"))
            }
        }
    }
}
