local UIActValentineMatchSuccessList = {
  Name = UIWindowNames.UIActValentineMatchSuccessList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActValentineMatchSuccessList.Ctrl.UIActValentineMatchSuccessListCtrl"),
  View = require("UI.UIActValentineMatchSuccessList.View.UIActValentineMatchSuccessListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/UIActValentineMatchSuccessList.prefab"
}
return {UIActValentineMatchSuccessList = UIActValentineMatchSuccessList}
