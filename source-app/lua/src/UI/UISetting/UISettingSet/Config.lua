local UISettingSet = {
  Name = UIWindowNames.UISettingSet,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UISettingSet.Controller.UISettingSetCtrl"),
  View = require("UI.UISetting.UISettingSet.View.UISettingSetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingSetNew.prefab"
}
return {UISettingSet = UISettingSet}
