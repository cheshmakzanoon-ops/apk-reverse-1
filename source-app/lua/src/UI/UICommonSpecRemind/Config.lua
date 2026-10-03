local UICommonSpecRemind = {
  Name = UIWindowNames.UICommonSpecRemind,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonSpecRemind.Controller.UICommonSpecRemindCtrl"),
  View = require("UI.UICommonSpecRemind.View.UICommonSpecRemindView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonSpecRemind.prefab",
  HideInBattle = true
}
return {UICommonSpecRemind = UICommonSpecRemind}
