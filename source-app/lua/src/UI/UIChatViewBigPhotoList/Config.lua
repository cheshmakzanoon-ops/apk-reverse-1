local UIChatViewBigPhotoListView = {
  Name = UIWindowNames.UIChatViewBigPhotoListView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatViewBigPhotoList.Controller.UIChatViewBigPhotoListCtrl"),
  View = require("UI.UIChatViewBigPhotoList.View.UIChatViewBigPhotoListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatSendPhoto/UIChatViewBigPhotoListView.prefab",
  HideBack = true
}
return {UIChatViewBigPhotoListView = UIChatViewBigPhotoListView}
