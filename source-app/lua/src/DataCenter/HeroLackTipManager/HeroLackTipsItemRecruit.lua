local HeroLackTipsItemBase = require("DataCenter.HeroLackTipManager.HeroLackTipsItemBase")
local HeroLackTipsItemRecruit = BaseClass("HeroLackTipsItemRecruit", HeroLackTipsItemBase)

local function CheckIsOk(self)
  local num = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(BuildingTypes.APS_BUILD_PUB)
  if num <= 0 then
    return false
  end
  return true
end

local function TodoAction(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroList)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroInfo)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroAdvanceSuccess)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroQualityRecruit, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, false, false, 2)
end

HeroLackTipsItemRecruit.CheckIsOk = CheckIsOk
HeroLackTipsItemRecruit.TodoAction = TodoAction
return HeroLackTipsItemRecruit
