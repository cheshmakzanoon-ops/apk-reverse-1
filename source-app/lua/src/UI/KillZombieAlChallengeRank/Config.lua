local KillZombieAlChallengeRank = {
  Name = UIWindowNames.KillZombieAlChallengeRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.KillZombieAlChallengeRank.Controller.KillZombieAlChallengeRankCtrl"),
  View = require("UI.KillZombieAlChallengeRank.View.KillZombieAlChallengeRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/UIKillZombieDmgRank.prefab"
}
return {KillZombieAlChallengeRank = KillZombieAlChallengeRank}
