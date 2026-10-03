local Localization = CS.GameEntry.Localization
local UIAddAccountCtrl = BaseClass("UIAddAccountCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAddAccount)
end

local function CheckPwd(self, pwd1)
  if pwd1 == nil or pwd1 == "" then
    UIUtil.ShowTipsId(280121)
    return false
  else
    local num = string.len(pwd1)
    if num < 8 or 15 < num then
      UIUtil.ShowTipsId(280119)
      return false
    end
  end
  return true
end

UIAddAccountCtrl.CloseSelf = CloseSelf
UIAddAccountCtrl.CheckPwd = CheckPwd
return UIAddAccountCtrl
