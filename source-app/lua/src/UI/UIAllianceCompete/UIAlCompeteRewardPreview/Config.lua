local UIAlCompeteRewardPreview = {
  Name = UIWindowNames.UIAlCompeteRewardPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceCompete.UIAlCompeteRewardPreview.Controller.UIAlCompeteRewardPreviewCtrl"),
  View = require("UI.UIAllianceCompete.UIAlCompeteRewardPreview.View.UIAlCompeteRewardPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/UIAllianceCompeteReward.prefab"
}
return {UIAlCompeteRewardPreview = UIAlCompeteRewardPreview}
