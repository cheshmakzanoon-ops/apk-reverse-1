local UIJungleTrialTaskCtrl = BaseClass("UIJungleTrialTaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIJungleTrialTask)
end

UIJungleTrialTaskCtrl.CloseSelf = CloseSelf
return UIJungleTrialTaskCtrl
