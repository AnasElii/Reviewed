import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item{
    id: commentCard

    width: parent.width
    implicitHeight: glContent.height
    
    property string commentID
    property int commentIndex: 0
    property alias usernameText: username.text
    property url imageSource: profilePic.source
    property alias timeText: time.text
    property alias commentText: comment.text
    property bool awner : false
    property ListModel replyList : replyList
    
    function getAlpha() {
        return root.username.substring(0, 1).toUpperCase();
    }

    ListModel{
        id: replyList
    }

    GridLayout{
        id: glContent

        width: parent.width
        columns: 2
        columnSpacing: 10

        // Profile Picture
        Rectangle{
            id: profileImage

            color: root.userColor
            width: 50
            height: 50
            radius: width/2

            Image {
                id: profilePic

                width: parent.width
                source: "qrc:/resources/images/Bitmap.png"
                fillMode: Image.PreserveAspectFit
                visible: false

                // Profile Image Mask
                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskSource: Image{
                        width: 50
                        source: "qrc:/resources/images/Pic_Circle.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }

            Text{
                id: profileText

                visible: true
                text: getAlpha()
                font{
                    family: "Texta"
                    styleName: "Bold"
                    pixelSize: 20
                }
                color: "white"
                anchors.centerIn: parent
            }
        }

        ColumnLayout{
            spacing: 5
            Text{
                id: username
                text: "@Ridhwan Nordin"
                font{
                    styleName: "Bold"
                    pixelSize: 11
                }
            }

            Text{
                id: time
                text: "36 minutes ago"
            }
        }

        Rectangle{
            color: "transparent"
        }

        Rectangle{
            implicitHeight: clContent.height
            color: "#e7e3e6"
            radius: 10

            Layout.fillWidth: true
            Layout.rightMargin: 10

            ColumnLayout{
                id: clContent


                width: parent.width
                spacing: 2
                clip: true

                RowLayout{
                    Layout.alignment: Qt.AlignRight
                    spacing: 0
                    visible: awner ? true : awner

                    ToolButton {
                        Layout.alignment: Qt.AlignRight
                        display: Qt.ToolButtonIconOnly
                        icon.source: "qrc:/resources/icons/pen.png"
                        visible: true
                        text: "edit"
                        onClicked: {
                            canvasPage.newComment.type = "updateComment";
                            canvasPage.newComment.commentID = commentCard.commentIndex;
                            canvasPage.newComment.newCommentTextField.text = commentCard.commentText;
                            canvasPage.newComment.open();
                        }
                    }
                    ToolButton {
                        Layout.alignment: Qt.AlignRight
                        display: Qt.ToolButtonIconOnly
                        icon.source: "qrc:/resources/icons/delete.png"
                        visible: true
                        text: "delete"
                        onClicked:{
                            root.commentList.get(commentCard.commentIndex).pin.get(0).visible = false;
                            root.commentList.get(commentCard.commentIndex).visible = false;
                            displayPins();
                            deleteComment();
                            root.commentList.remove(commentCard.commentIndex, 1);
                        }
                    }
                }

                Text {
                    id: comment

                    Layout.fillWidth: true
                    Layout.leftMargin: 10
                    Layout.topMargin: awner ? 0 : 10

                    text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
                    wrapMode: Text.WordWrap
                }

                ToolButton {
                    Layout.alignment: Qt.AlignRight
                    display: Qt.ToolButtonTextBesideIcon
                    icon.source: "qrc:/resources/icons/reply.png"
                    visible: true
                    text: "Reply"
                    onClicked: {
                        canvasPage.newComment.type = "addReply";
                        canvasPage.newComment.commentID = commentCard.commentIndex;
                        canvasPage.newComment.open();
                    }
                }
            }
        }

        Rectangle{
            color: "transparent"
        }
        
        ColumnLayout{
            id: clReply

            Layout.fillWidth: true

            Repeater{
                model: commentCard.replyList
                Layout.fillWidth: true

                delegate: ReplyCumponent{
                    Layout.fillWidth: true

                    commentID: commentCard.commentID
                    replyID: model.index
                    usernameText: model.username
                    commentText: model.comment
                    timeText: model.time
                    awner: model.awner
                }
            }
        }
    }
}
