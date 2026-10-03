local UIAllyDuelScieneTipInfo = {
  Name = UIWindowNames.UIAllyDuelScienceTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDuel.Component.AllyDuelScieneTip.Controller.UIAllyDuelScieneTipCtrl"),
  View = require("UI.UIAllyDuel.Component.AllyDuelScieneTip.View.UIAllyDuelScieneTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UIScienceTip.prefab"
}
return {UIAllyDuelScieneTipInfo = UIAllyDuelScieneTipInfo}
