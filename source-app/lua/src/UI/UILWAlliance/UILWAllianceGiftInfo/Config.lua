local UILWAllianceGiftInfo = {
  Name = UIWindowNames.UILWAllianceGiftInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAllianceGiftInfo.Controller.UILWAllianceGiftInfoCtrl"),
  View = require("UI.UILWAlliance.UILWAllianceGiftInfo.View.UILWAllianceGiftInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAllianceGiftInfo.prefab"
}
return {UILWAllianceGiftInfo = UILWAllianceGiftInfo}
