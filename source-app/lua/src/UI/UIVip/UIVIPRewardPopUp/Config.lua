local UIVIPRewardPopUp = {
  Name = UIWindowNames.UIVIPRewardPopUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIVip.UIVIPRewardPopUp.Controller.UIVIPRewardPopUpCtrl"),
  View = require("UI.UIVip.UIVIPRewardPopUp.View.UIVIPRewardPopUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWVIPPanel/UIVIPRewardPopUp.prefab"
}
return {WorldDesUI = UIVIPRewardPopUp}
