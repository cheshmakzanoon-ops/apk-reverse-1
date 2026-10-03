local UIFormationSoldierTip = {
  Name = UIWindowNames.UIFormationSoldierTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormation.UIFormationSoldierTip.Controller.UIFormationSoldierTipCtrl"),
  View = require("UI.UIFormation.UIFormationSoldierTip.View.UIFormationSoldierTip"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWCommon/UIFightSoldierTip.prefab"
}
return {UIFormationSoldierTip = UIFormationSoldierTip}
