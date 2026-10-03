local LWUIMasterySkillPanel = {
  Name = UIWindowNames.LWUIMasterySkillPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMasterySkillPanel.Controller.LWUIMasterySkillPanelCtrl"),
  View = require("UI.LWUIMasterySkillPanel.View.LWUIMasterySkillPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIMastery/LWUIMasterySkillPanel.prefab",
  HideBack = true
}
return {LWUIMasterySkillPanel = LWUIMasterySkillPanel}
