local UITrainPrepareSceneCtrl = BaseClass("UITrainPrepareSceneCtrl", UIBaseCtrl)

function UITrainPrepareSceneCtrl:CloseSelf()
  RailwayUtil.CloseUITrainPrepare()
end

function UITrainPrepareSceneCtrl:OnCustomKeyCodeEscape()
  RailwayUtil.CloseUITrainPrepare()
end

return UITrainPrepareSceneCtrl
