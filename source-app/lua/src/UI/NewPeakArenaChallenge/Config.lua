local NewPeakArenaChallenge = {
  Name = UIWindowNames.NewPeakArenaChallenge,
  Layer = UILayer.Normal,
  Ctrl = require("UI.NewPeakArenaChallenge.Controller.NewPeakArenaChallengeCtrl"),
  View = require("UI.NewPeakArenaChallenge.View.NewPeakArenaChallengeView"),
  PrefabPath = "Assets/Main/Prefabs/NewPeakArena/NewPeakArenaChallenge.prefab"
}
return {NewPeakArenaChallenge = NewPeakArenaChallenge}
