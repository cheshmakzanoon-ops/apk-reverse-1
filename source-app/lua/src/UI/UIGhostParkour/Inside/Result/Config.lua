local UIGhostParkourBattleResult = {
  Name = UIWindowNames.UIGhostParkourBattleResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Inside.Result.Controller.UIGhostParkourBattleResultCtrl"),
  View = require("UI.UIGhostParkour.Inside.Result.View.UIGhostParkourBattleResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/Inside/UIGhostParkourBattleResult.prefab"
}
return {UIGhostParkourBattleResult = UIGhostParkourBattleResult}
