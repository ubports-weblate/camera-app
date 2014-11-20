/*
 * Copyright 2014 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.2
import Ubuntu.Components 1.0
import QtQuick.Layouts 1.1

Item {
    id: header
    anchors {
        left: parent.left
        right: parent.right
    }
    y: shown ? 0 : -height
    Behavior on y { UbuntuNumberAnimation {} }
    opacity: shown ? 1.0 : 0.0
    Behavior on opacity { UbuntuNumberAnimation {} }

    height: units.gu(7)

    property bool shown: true
    property alias actions: actionsDrawer.actions
    property bool gridMode: false
    property bool validationVisible
    property bool userSelectionMode: false
    signal exit
    signal toggleViews
    signal validationClicked

    function show() {
        shown = true;
    }

    function toggle() {
        shown = !shown;
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.6
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        IconButton {
            objectName: "backButton"
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            width: units.gu(8)
            iconName: "back"
            iconColor: Theme.palette.normal.foregroundText
            onClicked: header.exit()
        }

        Label {
            text: userSelectionMode ? i18n.tr("Select") : i18n.tr("Photo Roll")
            fontSize: "x-large"
            color: Theme.palette.normal.foregroundText
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        IconButton {
            objectName: "viewToggleButton"
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            iconName: header.gridMode ? "stock_image" : "view-grid-symbolic"
            onClicked: header.toggleViews()
            visible: !main.contentExportMode && !userSelectionMode
        }

        IconButton {
            objectName: "additionalActionsButton"
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            iconName: "contextual-menu"
            visible: actionsDrawer.actions.length > 0
            onClicked: actionsDrawer.opened = !actionsDrawer.opened
        }

        IconButton {
            objectName: "validationButton"
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            iconName: "ok"
            onClicked: header.validationClicked()
            visible: header.validationVisible
        }
    }

    Item {
        id: actionsDrawer

        anchors {
            top: parent.bottom
            right: parent.right
        }
        width: units.gu(20)
        height: childrenRect.height
        clip: actionsColumn.y != 0

        function close() {
            opened = false;
        }

        property bool opened: false
        property list<Action> actions

        InverseMouseArea {
            onPressed: actionsDrawer.close();
            enabled: actionsDrawer.opened
        }

        Column {
            id: actionsColumn
            anchors {
                left: parent.left
                right: parent.right
            }
            y: actionsDrawer.opened ? 0 : -height
            Behavior on y { UbuntuNumberAnimation {} }

            Repeater {
                model: actionsDrawer.actions
                delegate: AbstractButton {
                    id: actionButton
                    objectName: "actionButton" + label.text
                    anchors {
                        left: actionsColumn.left
                        right: actionsColumn.right
                    }
                    height: units.gu(6)

                    action: modelData
                    onClicked: actionsDrawer.close()

                    Rectangle {
                        anchors.fill: parent
                        color: actionButton.pressed ? Qt.rgba(1.0, 1.0, 1.0, 0.3) : Qt.rgba(0.0, 0.0, 0.0, 0.6)
                    }

                    Label {
                        id: label
                        anchors {
                            left: icon.right
                            leftMargin: units.gu(2)
                            right: parent.right
                            rightMargin: units.gu(2)
                            verticalCenter: parent.verticalCenter
                        }
                        text: model.text
                        elide: Text.ElideRight
                        color: Theme.palette.normal.foregroundText
                    }

                    Icon {
                        id: icon
                        anchors {
                            left: parent.left
                            leftMargin: units.gu(2)
                            verticalCenter: parent.verticalCenter
                        }
                        width: height
                        height: label.paintedHeight
                        color: Theme.palette.normal.foregroundText
                        name: model.iconName
                    }
                }
            }
        }
    }
}
