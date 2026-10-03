local UIActLimitedTimeFeastNoticeCommon = {
  Name = UIWindowNames.UIActLimitedTimeFeastNoticeCommon,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWActivityCommonSecondPopUp.UIActLimitedTimeFeastNoticeCommon.Controller.UIActLimitedTimeFeastNoticeCommonCtrl"),
  View = require("UI.LWActivityCommonSecondPopUp.UIActLimitedTimeFeastNoticeCommon.View.UIActLimitedTimeFeastNoticeCommonView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/CommonSecondPopUpPanel/UIActLimitedTimeFeastNoticeCommon.prefab"
}
return {UIActLimitedTimeFeastNoticeCommon = UIActLimitedTimeFeastNoticeCommon}
