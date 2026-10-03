local UIDetectSlotBoxOpen = {
  Name = UIWindowNames.UIDetectSlotBoxOpen,
  Layer = UILayer.Info,
  Ctrl = require("UI.UILWRadarCenter.UIDetectSlotBoxOpen.Controller.UIDetectSlotBoxOpenCtrl"),
  View = require("UI.UILWRadarCenter.UIDetectSlotBoxOpen.View.UIDetectSlotBoxOpenView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/CaveExploration/UIDetectSlotMachineChooseBoxReward.prefab",
  HideBack = true
}
return {UIDetectSlotBoxOpen = UIDetectSlotBoxOpen}
