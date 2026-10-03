local UIALChallengeRank = {
  Name = UIWindowNames.UIALChallengeRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieALChallenge.UIALChallengeRankCtrl"),
  View = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieALChallenge.UIALChallengeRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/UIALChallengeRank.prefab"
}
return {UIALChallengeRank = UIALChallengeRank}
