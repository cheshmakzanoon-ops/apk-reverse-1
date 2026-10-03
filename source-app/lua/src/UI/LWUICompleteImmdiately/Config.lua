local CompleteImmdiatelyPanel = {
  Name = UIWindowNames.CompleteImmdiatelyPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUICompleteImmdiately.LWCompleteImmdiatelyPanelCtrl"),
  View = require("UI.LWUICompleteImmdiately.LWCompleteImmdiatelyPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWCompleteImmdiately/LWCompleteImmdiatelyPanel.prefab"
}
return {CompleteImmdiatelyPanel = CompleteImmdiatelyPanel}
