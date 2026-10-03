local UITCCardBook = {
  Name = UIWindowNames.UITCCardBook,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUITC.UITCCardBookPanel.Ctrl.UITCCardBookCtrl"),
  View = require("UI.LWUITC.UITCCardBookPanel.View.UITCCardBookView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Book/TCCardBook.prefab",
  HideBack = true
}
return {UITCCardBook = UITCCardBook}
