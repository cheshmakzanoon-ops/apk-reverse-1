local UIActMonsterTowerTask = {
  Name = UIWindowNames.UIActMonsterTowerTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonsterTowerTask.Controller.UIActMonsterTowerTaskCtrl"),
  View = require("UI.UIActMonsterTowerTask.View.UIActMonsterTowerTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterTower/UIActMonsterTowerTask.prefab"
}
return {UIActMonsterTowerTask = UIActMonsterTowerTask}
