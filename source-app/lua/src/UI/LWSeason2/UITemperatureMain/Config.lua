local UITemperatureMain = {
  Name = UIWindowNames.UITemperatureMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.UITemperatureMain.Controller.UITemperatureMainCtrl"),
  View = require("UI.LWSeason2.UITemperatureMain.View.UITemperatureMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/UITemperatureMain.prefab"
}
return {UITemperatureMain = UITemperatureMain}
