local BirthdayDataSetPanel = {
  Name = UIWindowNames.BirthdayDataSetPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Birthday.BirthdayDataSetPanel.Controller.BirthdayDataSetPanelCtrl"),
  View = require("UI.Birthday.BirthdayDataSetPanel.View.BirthdayDataSetPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/Birthday/BirthdayDataSetPanel.prefab"
}
return {BirthdayDataSetPanel = BirthdayDataSetPanel}
