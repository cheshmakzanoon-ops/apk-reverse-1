local UIChatViewBigPhotoView = {
  Name = UIWindowNames.UIChatViewBigPhotoView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatViewBigPhoto.Controller.UIChatViewBigPhotoCtrl"),
  View = require("UI.UIChatViewBigPhoto.View.UIChatViewBigPhotoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatSendPhoto/UIChatViewBigPhotoView.prefab",
  HideBack = true
}
return {UIChatViewBigPhotoView = UIChatViewBigPhotoView}
