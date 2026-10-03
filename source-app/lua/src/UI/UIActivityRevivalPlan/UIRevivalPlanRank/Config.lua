local UIRevivalPlanRank = {
  Name = UIWindowNames.UIRevivalPlanRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityRevivalPlan.UIRevivalPlanRank.Controller.UIRevivalPlanRankCtrl"),
  View = require("UI.UIActivityRevivalPlan.UIRevivalPlanRank.View.UIRevivalPlanRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/RevivalPlan/UIRevivalPlanRankPanel.prefab"
}
return {UIRevivalPlanRank = UIRevivalPlanRank}
