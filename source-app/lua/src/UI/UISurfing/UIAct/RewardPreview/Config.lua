local UILWRewardPreviewView = {
  Name = UIWindowNames.UILWRewardPreviewView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISurfing.UIAct.RewardPreview.Ctrl.UILWRewardPreviewCtrl"),
  View = require("UI.UISurfing.UIAct.RewardPreview.View.UILWRewardPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SurfingBattle/UILWRewardPreview.prefab"
}
return {UILWRewardPreviewView = UILWRewardPreviewView}
