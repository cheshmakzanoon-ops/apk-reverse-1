local T11SoldierResearchPlan = {
  Name = UIWindowNames.T11SoldierResearchPlan,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11SoldierResearchPlan.Ctrl.T11SoldierResearchPlanCtrl"),
  View = require("UI.T11SoldierResearchPlan.View.T11SoldierResearchPlanView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11/T11SoldierResearchPlan/T11SoldierResearchPlan.prefab"
}
return {T11SoldierResearchPlan = T11SoldierResearchPlan}
