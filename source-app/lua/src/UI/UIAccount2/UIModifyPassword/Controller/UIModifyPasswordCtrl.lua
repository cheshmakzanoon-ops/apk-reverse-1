local Localization = CS.GameEntry.Localization
local UIModifyPasswordCtrl = BaseClass("UIModifyPasswordCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIModifyPassword)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIModifyPassword)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountVerify)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAddAccount)
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

UIModifyPasswordCtrl.CloseSelf = CloseSelf
UIModifyPasswordCtrl.Close = Close
UIModifyPasswordCtrl.CheckPwd = CheckPwd
return UIModifyPasswordCtrl
