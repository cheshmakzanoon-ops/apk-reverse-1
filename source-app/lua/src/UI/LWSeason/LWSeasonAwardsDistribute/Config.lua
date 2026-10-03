local UILWSeasonDistributeAward = {
  Name = UIWindowNames.UILWSeasonDistributeAward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonAwardsDistribute.Controller.UILWSeasonDistributeAwardCtrl"),
  View = require("UI.LWSeason.LWSeasonAwardsDistribute.View.UILWSeasonDistributeAwardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/SeasonAwards/UILWSeasonDistributeAward.prefab"
}
return {UILWSeasonDistributeAward = UILWSeasonDistributeAward}
