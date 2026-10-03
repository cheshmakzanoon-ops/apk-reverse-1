local UIActivityDetailCommon = {
  Name = UIWindowNames.UIActivityDetailCommon,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Controller.UIActivityDetailCommonCtrl"),
  View = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.View.UIActivityDetailCommonView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/CommonSecondPopUpPanel/UIActivityDetailCommon.prefab"
}
return {UIActivityDetailCommon = UIActivityDetailCommon}
