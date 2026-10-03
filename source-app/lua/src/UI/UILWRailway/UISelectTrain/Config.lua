local UISelectTrain = {
  Name = UIWindowNames.UISelectTrain,
  Layer = UILayer.TopMost,
  Ctrl = require("UI.UILWRailway.UISelectTrain.Controller.UISelectTrainCtrl"),
  View = require("UI.UILWRailway.UISelectTrain.View.UISelectTrainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UISelectTrain.prefab"
}
return {UISelectTrain = UISelectTrain}
