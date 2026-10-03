local UIFormationTip = {
  Name = UIWindowNames.UIFormationTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIFormationTip.Controller.UIFormationTipCtrl"),
  View = require("UI.UIFormation.UIFormationTip.View.UIFormationTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIFormationTip.prefab"
}
return {UIFormationTip = UIFormationTip}
