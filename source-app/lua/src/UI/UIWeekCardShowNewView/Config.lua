local UIWeekCardShowNew = {
  Name = UIWindowNames.UIWeekCardShowNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWeekCardShowNewView.Ctrl.UIWeekCardShowNewCtrl"),
  View = require("UI.UIWeekCardShowNewView.View.UIWeekCardShowNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGift/WeekCard/UIWeekCardShowNew.prefab"
}
return {UIWeekCardShowNew = UIWeekCardShowNew}
