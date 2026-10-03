local UIGetDuelScoreTip = {
  Name = UIWindowNames.UIGetDuelScoreTip,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIGetDuelScoreTip.Controller.UIGetDuelScoreTipCtrl"),
  View = require("UI.UIGetDuelScoreTip.View.UIGetDuelScoreTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGetDuelScoreTip/UIGetDuelScoreTip.prefab",
  HideInBattle = true
}
return {UIGetDuelScoreTip = UIGetDuelScoreTip}
