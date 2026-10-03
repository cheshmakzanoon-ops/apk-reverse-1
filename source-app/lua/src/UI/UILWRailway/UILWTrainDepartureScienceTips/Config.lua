local UILWTrainDepartureScienceTips = {
  Name = UIWindowNames.UILWTrainDepartureScienceTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UILWTrainDepartureScienceTips.Controller.UILWTrainDepartureScienceTipsCtrl"),
  View = require("UI.UILWRailway.UILWTrainDepartureScienceTips.View.UILWTrainDepartureScienceTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UILWTrainDepartureScienceTips.prefab"
}
return {UILWTrainDepartureScienceTips = UILWTrainDepartureScienceTips}
