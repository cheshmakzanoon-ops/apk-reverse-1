local UIActValentineBoxProbabilityCtrl = BaseClass("UIActValentineBoxProbabilityCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ValentineBoxProbability)
end

UIActValentineBoxProbabilityCtrl.CloseSelf = CloseSelf
return UIActValentineBoxProbabilityCtrl
