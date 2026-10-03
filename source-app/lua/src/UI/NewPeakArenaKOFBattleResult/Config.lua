local NewPeakArenaKOFBattleResult = {
  Name = UIWindowNames.NewPeakArenaKOFBattleResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.NewPeakArenaKOFBattleResult.Controller.NewPeakArenaKOFBattleResultCtrl"),
  View = require("UI.NewPeakArenaKOFBattleResult.View.NewPeakArenaKOFBattleResultView"),
  PrefabPath = "Assets/Main/Prefabs/NewPeakArena/NewPeakArenaKOFBattleResult.prefab"
}
return {NewPeakArenaKOFBattleResult = NewPeakArenaKOFBattleResult}
