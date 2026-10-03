local CommonTipConfirm = {
  Name = UIWindowNames.CommonTipConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.CommonTipConfirm.Controller.CommonTipConfirmCtrl"),
  View = require("UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.CommonTipConfirm.View.CommonTipConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/CommonTipConfirm.prefab"
}
return {CommonTipConfirm = CommonTipConfirm}
