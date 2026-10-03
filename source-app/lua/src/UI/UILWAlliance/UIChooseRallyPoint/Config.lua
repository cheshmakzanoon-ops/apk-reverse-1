local UIChooseRallyPoint = {
  Name = UIWindowNames.UIChooseRallyPoint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UIChooseRallyPoint.UIChooseRallyPointCtrl"),
  View = require("UI.UILWAlliance.UIChooseRallyPoint.UIChooseRallyPointView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UIChooseRallyPoint/UIChooseRallyPoint.prefab"
}
return {UIChooseRallyPoint = UIChooseRallyPoint}
