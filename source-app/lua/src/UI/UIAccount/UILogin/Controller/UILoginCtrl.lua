local UILoginCtrl = BaseClass("UILoginCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILogin)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
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

UILoginCtrl.CloseSelf = CloseSelf
UILoginCtrl.Close = Close
UILoginCtrl.CheckPwd = CheckPwd
return UILoginCtrl
