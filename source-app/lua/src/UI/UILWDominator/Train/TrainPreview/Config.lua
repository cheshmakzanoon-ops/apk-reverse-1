local UILWDominatorTrainPreview = {
  Name = UIWindowNames.UILWDominatorTrainPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWDominator.Train.TrainPreview.Ctrl.UILWDominatorTrainPreviewCtrl"),
  View = require("UI.UILWDominator.Train.TrainPreview.View.UILWDominatorTrainPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWDominator/Main/Train/UILWDominatorTrainPreview.prefab"
}
return {UILWDominatorTrainPreview = UILWDominatorTrainPreview}
