local UILWTrainSceneCtrl = BaseClass("UILWTrainSceneCtrl", UIBaseCtrl)

local function CloseSelf(self)
  RailwayUtil.CloseUITrainList()
end

UILWTrainSceneCtrl.CloseSelf = CloseSelf
return UILWTrainSceneCtrl
