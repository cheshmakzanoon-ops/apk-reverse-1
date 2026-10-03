local UIBindAccountCreateCtrl = BaseClass("UIBindAccountCreateCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBindAccountCreate)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function CheckPwd(self, pwd1, pwd2)
  if pwd1 == nil or pwd1 == "" then
    UIUtil.ShowTipsId(280121)
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

UIBindAccountCreateCtrl.CloseSelf = CloseSelf
UIBindAccountCreateCtrl.Close = Close
UIBindAccountCreateCtrl.CheckPwd = CheckPwd
return UIBindAccountCreateCtrl
