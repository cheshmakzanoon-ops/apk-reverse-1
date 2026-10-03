local UIActSnowStormWorldInfoCtrl = BaseClass("UIActSnowStormWorldInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActSnowStormWorldInfo)
end

UIActSnowStormWorldInfoCtrl.CloseSelf = CloseSelf
return UIActSnowStormWorldInfoCtrl
