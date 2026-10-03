local UIBindSuccessCtrl = BaseClass("UIBindSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBindSuccess)
end

UIBindSuccessCtrl.CloseSelf = CloseSelf
return UIBindSuccessCtrl
