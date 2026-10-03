local UIHeroPowerDetailTip = {
  Name = UIWindowNames.UIActivityDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityDetailWindow.Controller.UIActivityDetailWindowCtrl"),
  View = require("UI.UIActivityDetailWindow.View.UIActivityDetailWindowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UIActivityDetailPanel.prefab"
}
return {UIHeroPowerDetailTip = UIHeroPowerDetailTip}
