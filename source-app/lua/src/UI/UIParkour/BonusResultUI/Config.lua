local UIParkourBonusResult = {
  Name = UIWindowNames.UIParkourBonusResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIParkour.BonusResultUI.Ctrl.UIParkourBonusResultCtrl"),
  View = require("UI.UIParkour.BonusResultUI.View.UIParkourBonusResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/UIParkourBonusResult.prefab"
}
return {UIParkourBonusResult = UIParkourBonusResult}
