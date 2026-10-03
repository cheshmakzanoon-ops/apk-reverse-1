local UIOffSeason1Task = {
  Name = UIWindowNames.UIOffSeason1Task,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWOffSeason1.Task.Ctrl.UIOffSeason1TaskCtrl"),
  View = require("UI.LWOffSeason1.Task.View.UIOffSeason1TaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWOffSeason1/Task/UIOffSeason1Task.prefab"
}
return {UIOffSeason1Task = UIOffSeason1Task}
