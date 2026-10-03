local UIActGiftGivingRewardGet = {
  Name = UIWindowNames.UIActGiftGivingRewardGet,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActGiftGiving.UIActGiftGivingRewardGet.Controller.UIActGiftGivingRewardGetCtrl"),
  View = require("UI.UIActGiftGiving.UIActGiftGivingRewardGet.View.UIActGiftGivingRewardGetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActGiftGiving/UIActGiftGivingRewardGet.prefab"
}
return {UIActGiftGivingRewardGet = UIActGiftGivingRewardGet}
