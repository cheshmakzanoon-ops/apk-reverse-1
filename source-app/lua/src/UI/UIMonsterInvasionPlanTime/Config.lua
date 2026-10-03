local UIMonsterInvasionPlanTime = {
  Name = UIWindowNames.UIMonsterInvasionPlanTime,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMonsterInvasionPlanTime.Controller.UIMonsterInvasionPlanTimeCtrl"),
  View = require("UI.UIMonsterInvasionPlanTime.View.UIMonsterInvasionPlanTimeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterInvasion/UIMonsterInvasionPlanTime.prefab"
}
return {UIMonsterInvasionPlanTime = UIMonsterInvasionPlanTime}
