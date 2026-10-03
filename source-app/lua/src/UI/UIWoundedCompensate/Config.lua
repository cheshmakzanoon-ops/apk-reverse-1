local UIMainTask = {
  Name = UIWindowNames.UIMainTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWoundedCompensate.Controller.UIWoundedCompensateCtrl"),
  View = require("UI.UIWoundedCompensate.View.UIWoundedCompensateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIWoundedCompensate/UIWoundedCompensate.prefab"
}
return {UIMainTask = UIMainTask}
