local UIFestivalActivityCommonGroupShow = {
  Name = UIWindowNames.UIFestivalActivityCommonGroupShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFestivalActivityCommonGroupShow.Controller.UIFestivalActivityCommonGroupShowCtrl"),
  View = require("UI.UIFestivalActivityCommonGroupShow.View.UIFestivalActivityCommonGroupShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/FestivalCommon/UIFestivalActivityCommonGroupShow.prefab",
  HideBack = true
}
return {UIFestivalActivityCommonGroupShow = UIFestivalActivityCommonGroupShow}
