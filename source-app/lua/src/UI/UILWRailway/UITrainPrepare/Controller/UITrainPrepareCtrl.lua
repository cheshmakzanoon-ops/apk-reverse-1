local UITrainPrepareCtrl = BaseClass("UITrainPrepareCtrl", UIBaseCtrl)

local function CloseSelf(self)
  RailwayUtil.CloseUITrainPrepare()
end

UITrainPrepareCtrl.CloseSelf = CloseSelf
return UITrainPrepareCtrl
