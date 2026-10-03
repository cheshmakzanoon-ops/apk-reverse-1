local LWUIPlayerPackageRewardChange = {
  Name = UIWindowNames.LWUIPlayerPackageRewardChange,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIPlayerLevelPackageRewardChange.Ctrl.LWUIPlayerPackageRewardChangeCtrl"),
  View = require("UI.LWUIPlayerLevelPackageRewardChange.View.LWUIPlayerPackageRewardChangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIPlayerLevelPackageRewardChange/LWUIPlayerPackageRewardChange.prefab"
}
return {LWUIPlayerPackageRewardChange = LWUIPlayerPackageRewardChange}
