local UIGhostParkourChallengeResult = {
  Name = UIWindowNames.UIGhostParkourChallengeResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGhostParkour.Inside.ChallengeResult.Controller.UIGhostParkourChallengeResultCtrl"),
  View = require("UI.UIGhostParkour.Inside.ChallengeResult.View.UIGhostParkourChallengeResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GhostParkourBattle/Inside/UIGhostParkourChallengeResult.prefab"
}
return {UIGhostParkourChallengeResult = UIGhostParkourChallengeResult}
