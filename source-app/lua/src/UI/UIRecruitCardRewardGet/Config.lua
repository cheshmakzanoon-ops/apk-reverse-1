local UIRecruitCardRewardGet = {
  Name = UIWindowNames.UIRecruitCardRewardGet,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIRecruitCardRewardGet.Controller.UIRecruitCardRewardGetCtrl"),
  View = require("UI.UIRecruitCardRewardGet.View.UIRecruitCardRewardGetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/GiftPackage/UIRecruitCardRewardGet.prefab",
  HideInBattle = true
}
return {UIRecruitCardRewardGet = UIRecruitCardRewardGet}
