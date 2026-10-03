local UIMailTroopBuffAddPanel = {
  Name = UIWindowNames.UIMailTroopBuffAddPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMailNew.UIMailTroopBuffAddPanel.Controller.UIMailTroopBuffAddPanelCtrl"),
  View = require("UI.UIMailNew.UIMailTroopBuffAddPanel.View.UIMailTroopBuffAddPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Mail/TroopBuffAddPanel/UIMailTroopBuffAddPanel.prefab"
}
return {UIMailTroopBuffAddPanel = UIMailTroopBuffAddPanel}
