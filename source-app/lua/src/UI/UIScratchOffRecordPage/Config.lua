local ScratchOffRecordPage = {
  Name = UIWindowNames.ScratchOffRecordPage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIScratchOffRecordPage.Ctrl.UIScratchOffRecordPageCtrl"),
  View = require("UI.UIScratchOffRecordPage.View.UIScratchOffRecordPageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIScratchOffRecordPage/ScratchOffRecordPage.prefab"
}
return {ScratchOffRecordPage = ScratchOffRecordPage}
