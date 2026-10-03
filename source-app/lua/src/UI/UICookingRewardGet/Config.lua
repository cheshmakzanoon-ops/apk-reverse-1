local UICookingRewardGet = {
  Name = UIWindowNames.UICookingRewardGet,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICookingRewardGet.Controller.UICookingRewardGetCtrl"),
  View = require("UI.UICookingRewardGet.View.UICookingFinishRewardGetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ThanksGiving/ThanksGivingCookingRewardGetView.prefab"
}
return {UICookingRewardGet = UICookingRewardGet}
