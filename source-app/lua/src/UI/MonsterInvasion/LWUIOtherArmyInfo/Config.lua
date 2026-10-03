local LWUIOtherArmyInfo = {
  Name = UIWindowNames.LWUIOtherArmyInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.MonsterInvasion.LWUIOtherArmyInfo.Controller.LWUIOtherArmyInfoCtrl"),
  View = require("UI.MonsterInvasion.LWUIOtherArmyInfo.View.LWUIOtherArmyInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/LWUIWorldBossArmyInfoView.prefab"
}
return {LWUIOtherArmyInfo = LWUIOtherArmyInfo}
