local UIActValentineRankView = {
  Name = UIWindowNames.UIActValentineRankView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActValentineRankView.Ctrl.UIActValentineRankCtrl"),
  View = require("UI.LWUIActValentineRankView.View.UIActValentineRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineRankView.prefab"
}
return {UIActValentineRankView = UIActValentineRankView}
