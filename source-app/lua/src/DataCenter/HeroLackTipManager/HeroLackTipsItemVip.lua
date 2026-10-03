local HeroLackTipsItemBase = require("DataCenter.HeroLackTipManager.HeroLackTipsItemBase")
local HeroLackTipsItemVip = BaseClass("HeroLackTipsItemVip", HeroLackTipsItemBase)

local function CheckIsOk(self)
  local mgr = DataCenter.LWFunctionUnlockManager
  local unlock = mgr:CheckCanShow(LWFunctionUnlockType.MainUI_VIP)
  return unlock
end

local function TodoAction(self)
  local mgr = DataCenter.LWFunctionUnlockManager
  local unlock = mgr:CheckCanShow(LWFunctionUnlockType.MainUI_VIP)
  if unlock then
    UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroList)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroInfo)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroAdvanceSuccess)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip, {anim = true, hideTop = true})
  else
    UIUtil.ShowTips(Localization:GetString("320269", k3))
  end
end

HeroLackTipsItemVip.CheckIsOk = CheckIsOk
HeroLackTipsItemVip.TodoAction = TodoAction
return HeroLackTipsItemVip
