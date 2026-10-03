local UICreateAccountCtrl = BaseClass("UICreateAccountCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICreateAccount)
end

local function CheckPwd(self, pwd1, pwd2)
  if pwd1 == nil or pwd1 == "" then
    UIUtil.ShowTipsId(280116)
    return false
  else
    local num = string.len(pwd1)
    if num < 8 or 15 < num then
      UIUtil.ShowTipsId(280119)
      return false
    elseif pwd1 ~= pwd2 then
      UIUtil.ShowTipsId(280126)
      return false
    end
  end
  return true
end

UICreateAccountCtrl.CloseSelf = CloseSelf
UICreateAccountCtrl.CheckPwd = CheckPwd
return UICreateAccountCtrl
