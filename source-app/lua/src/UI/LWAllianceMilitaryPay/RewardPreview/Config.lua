local AllianceMilitaryRewardPreviewView = {
  Name = UIWindowNames.AllianceMilitaryRewardPreviewView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWAllianceMilitaryPay.RewardPreview.Ctrl.AllianceMilitaryRewardPreviewCtrl"),
  View = require("UI.LWAllianceMilitaryPay.RewardPreview.View.AllianceMilitaryRewardPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/AllianceMilitaryPay/AllianceMilitaryRewardPreview.prefab"
}
return {AllianceMilitaryRewardPreviewView = AllianceMilitaryRewardPreviewView}
