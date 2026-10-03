local HeroLackTipsItemBase = require("DataCenter.HeroLackTipManager.HeroLackTipsItemBase")
local HeroLackTipsItemDebrisExchange = BaseClass("HeroLackTipsItemDebrisExchange", HeroLackTipsItemBase)

local function CheckIsOk(self, needNum)
  self.needNum = needNum
  local template = DataCenter.HeroLackTipTemplateManager:GetTemplate(self.configId)
  if template == nil then
    return false
  end
  local hasHero = DataCenter.HeroDataManager:GetHeroUuidByHeroId(template.heroId)
  if string.IsNullOrEmpty(hasHero) then
    return false
  end
  local fromId = HeroUtils.GetCommonExchangeItemId(template.heroId)
  local itemCount = DataCenter.ItemData:GetItemCount(fromId)
  return 0 < itemCount
end

local function TodoAction(self)
  local template = DataCenter.HeroLackTipTemplateManager:GetTemplate(self.configId)
  local fromId = HeroUtils.GetCommonExchangeItemId(template.heroId)
  local toId = template.fragmentid
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDebrisExchange, fromId, toId, template.heroId, self.needNum, true)
end

HeroLackTipsItemDebrisExchange.CheckIsOk = CheckIsOk
HeroLackTipsItemDebrisExchange.TodoAction = TodoAction
return HeroLackTipsItemDebrisExchange
