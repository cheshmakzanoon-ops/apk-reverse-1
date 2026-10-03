local UIAllianceGiftInfo = {
  Name = UIWindowNames.UIAllianceGiftInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceGiftInfo.Controller.UIAllianceGiftInfoCtrl"),
  View = require("UI.UIAlliance.UIAllianceGiftInfo.View.UIAllianceGiftInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceGiftInfo.prefab"
}
return {UIAllianceGiftInfo = UIAllianceGiftInfo}
