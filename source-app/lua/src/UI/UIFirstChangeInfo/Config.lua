local UIFirstPay = {
  Name = UIWindowNames.UIFirstChangeInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFirstChangeInfo.Controller.UIFirstChangeInfoCtrl"),
  View = require("UI.UIFirstChangeInfo.View.UIFirstChangeInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Set/New/UIFirstChangeInfo.prefab"
}
return {UIFirstPay = UIFirstPay}
