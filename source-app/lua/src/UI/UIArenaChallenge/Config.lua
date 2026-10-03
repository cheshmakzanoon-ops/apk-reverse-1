local UIArenaChallenge = {
  Name = UIWindowNames.UIArenaChallenge,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIArenaChallenge.Controller.UIArenaChallengeCtrl"),
  View = require("UI.UIArenaChallenge.View.UIArenaChallengeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIArena/UIArenaChallenge.prefab"
}
return {UIArenaChallenge = UIArenaChallenge}
