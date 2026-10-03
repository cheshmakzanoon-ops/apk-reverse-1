local LWUIPopupActivityDataPanel = {
  Name = UIWindowNames.LWUIPopupActivityDataPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIPopupActivityData.Ctrl.LWUIPopupActivityDataPanelCtrl"),
  View = require("UI.LWUIPopupActivityData.View.LWUIPopupActivityDataPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPopupActivityDataPanel/UIPopupActivityDataPanel.prefab"
}
return {LWUIPopupActivityDataPanel = LWUIPopupActivityDataPanel}
