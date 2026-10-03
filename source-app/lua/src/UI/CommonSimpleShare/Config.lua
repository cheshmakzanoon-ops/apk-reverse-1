local UICommonSimpleShareConfirm = {
  Name = UIWindowNames.UICommonSimpleShareConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.CommonSimpleShare.Ctrl.UICommonSimpleShareConfirmCtrl"),
  View = require("UI.CommonSimpleShare.View.UICommonSimpleShareConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonSimpleShareConfirm.prefab"
}
return {UICommonSimpleShareConfirm = UICommonSimpleShareConfirm}
