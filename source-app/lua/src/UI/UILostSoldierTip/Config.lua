local UILostSoldierTip = {
  Name = UIWindowNames.UILostSoldierTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILostSoldierTip.Controller.UILostSoldierTipCtrl"),
  View = require("UI.UILostSoldierTip.View.UILostSoldierTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMail/Soldier/UILostSoldierTip.prefab"
}
return {UILostSoldierTip = UILostSoldierTip}
