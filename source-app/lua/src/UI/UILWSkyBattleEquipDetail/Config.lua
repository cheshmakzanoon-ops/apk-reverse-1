local UISkyBattlePlaneEquipDetail = {
  Name = UIWindowNames.UISkyBattlePlaneEquipDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWSkyBattleEquipDetail.UISkyBattleEquipDetailPanelCtrl"),
  View = require("UI.UILWSkyBattleEquipDetail.UISkyBattleEquipDetailPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIStageSkyBattleChapter/UISkyBattleEquipDetailPanel.prefab"
}
return {UISkyBattlePlaneEquipDetail = UISkyBattlePlaneEquipDetail}
