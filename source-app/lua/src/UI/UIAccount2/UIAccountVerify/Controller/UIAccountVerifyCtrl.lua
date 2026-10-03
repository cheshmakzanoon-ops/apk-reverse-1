local Localization = CS.GameEntry.Localization
local UIAccountVerifyCtrl = BaseClass("UIAccountVerifyCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountVerify)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountVerify)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAddAccount)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICreateAccount)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIModifyPassword)
end

UIAccountVerifyCtrl.CloseSelf = CloseSelf
UIAccountVerifyCtrl.Close = Close
return UIAccountVerifyCtrl
