local UIChooseSwitchAccountCtrl = BaseClass("UIChooseSwitchAccountCtrl", UIBaseCtrl)
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChooseSwitchAccount)
end

UIChooseSwitchAccountCtrl.CloseSelf = CloseSelf
return UIChooseSwitchAccountCtrl
