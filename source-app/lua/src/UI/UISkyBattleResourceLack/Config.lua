local SkyBattleResourceLackView = {
  Name = UIWindowNames.SkyBattleResourceLackView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISkyBattleResourceLack.SkyBattleResourceLackCtrl"),
  View = require("UI.UISkyBattleResourceLack.SkyBattleResourceLackView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIStageSkyBattleChapter/SkyBattleResourceLack.prefab"
}
return {SkyBattleResourceLackView = SkyBattleResourceLackView}
