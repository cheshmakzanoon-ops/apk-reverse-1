local UISelectDigFinalReward = {
  Name = UIWindowNames.UISelectDigFinalReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISelectDigFinalReward.Controller.UISelectDigFinalRewardCtrl"),
  View = require("UI.UISelectDigFinalReward.View.UISelectDigFinalRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISelectDigFinalReward/UISelectDigFinalReward.prefab"
}
return {UISelectDigFinalReward = UISelectDigFinalReward}
