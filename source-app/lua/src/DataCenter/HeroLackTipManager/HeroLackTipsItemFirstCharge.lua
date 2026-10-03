local HeroLackTipsItemBase = require("DataCenter.HeroLackTipManager.HeroLackTipsItemBase")
local HeroLackTipsItemFirstCharge = BaseClass("HeroLackTipsItemFirstCharge", HeroLackTipsItemBase)

local function CheckIsOk(self)
  return DataCenter.PayManager:CheckIfFirstPayOpen()
end

local function TodoAction(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroList)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroInfo)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroAdvanceSuccess)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPay, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

HeroLackTipsItemFirstCharge.CheckIsOk = CheckIsOk
HeroLackTipsItemFirstCharge.TodoAction = TodoAction
return HeroLackTipsItemFirstCharge
