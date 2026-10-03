local UIPVESelectBattleBuff = {
  Name = UIWindowNames.UIPVESelectBattleBuff,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPVE.UIPVESelectBattleBuff.Controller.UIPVESelectBattleBuffCtrl"),
  View = require("UI.UIPVE.UIPVESelectBattleBuff.View.UIPVESelectBattleBuffView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPVE/UIPVESelectBattleBuff.prefab"
}
return {UIPVESelectBattleBuff = UIPVESelectBattleBuff}
