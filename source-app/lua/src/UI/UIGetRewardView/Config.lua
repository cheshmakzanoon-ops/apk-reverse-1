local UIGetRewardView = {
  Name = UIWindowNames.UIGetRewardView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGetRewardView.Controller.UIGetRewardCtrl"),
  View = require("UI.UIGetRewardView.View.UIGetRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GiftPackage/UIGetRewardView.prefab"
}
return {UIGetRewardView = UIGetRewardView}
