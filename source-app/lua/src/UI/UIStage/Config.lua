local UIStage = {
  Name = UIWindowNames.UIStage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStage.Controller.UIStageCtrl"),
  View = require("UI.UIStage.View.UIStageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWStage/StagePanel.prefab"
}
return {UIStage = UIStage}
