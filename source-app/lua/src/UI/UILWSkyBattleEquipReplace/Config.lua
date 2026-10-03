local SkyBattleEquipReplaceListPanel = {
  Name = UIWindowNames.SkyBattleEquipReplaceListPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWSkyBattleEquipReplace.SkyBattleEquipReplaceListPanelCtrl"),
  View = require("UI.UILWSkyBattleEquipReplace.SkyBattleEquipReplaceListPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIStageSkyBattleChapter/SkyBattleEquipReplaceListPanel.prefab"
}
return {SkyBattleEquipReplaceListPanel = SkyBattleEquipReplaceListPanel}
