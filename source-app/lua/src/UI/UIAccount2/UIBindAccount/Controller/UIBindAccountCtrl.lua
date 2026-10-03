local UIBindAccountCtrl = BaseClass("UIBindAccountCtrl", UIBaseCtrl)
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBindAccount)
end

UIBindAccountCtrl.CloseSelf = CloseSelf
return UIBindAccountCtrl
