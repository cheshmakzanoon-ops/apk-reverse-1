local UIHeroResetSuccessCtrl = BaseClass("UIHeroResetSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroResetSuccess)
end

UIHeroResetSuccessCtrl.CloseSelf = CloseSelf
return UIHeroResetSuccessCtrl
