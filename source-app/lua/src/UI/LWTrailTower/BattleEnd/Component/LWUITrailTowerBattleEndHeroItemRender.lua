local LWUITrailTowerBattleEndHeroItemRender = BaseClass("LWUITrailTowerBattleEndHeroItemRender", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local heroCell_path = "UIHeroCellSmall"
local lvUpContent_path = "LevelUpContent"
local lvUpEffect_path = "LevelUpContent/lvUpEffect"

function LWUITrailTowerBattleEndHeroItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUITrailTowerBattleEndHeroItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUITrailTowerBattleEndHeroItemRender:ComponentDefine()
  self.heroCell = self:AddComponent(UIHeroCellSmall, heroCell_path)
  self.lvUpContent = self.transform:Find(lvUpContent_path).gameObject
  self.lvUpEffect = self.transform:Find(lvUpEffect_path).gameObject
end

function LWUITrailTowerBattleEndHeroItemRender:ComponentDestroy()
  self.heroCell = nil
  self.lvUpContent = nil
  self.lvUpEffect = nil
end

function LWUITrailTowerBattleEndHeroItemRender:SetData(heroDisplayData)
  if heroDisplayData == nil then
    self:SetActive(false)
    return
  end
  self.heroDisplayData = heroDisplayData
  self:SetActive(true)
  local heroUuid = heroDisplayData.heroUuid
  self.heroCell:SetData(heroUuid, nil, false, false, HeroIconType.small_icon)
  self:RefreshLvUpEffect()
end

function LWUITrailTowerBattleEndHeroItemRender:RefreshLvUpEffect()
  if self.heroDisplayData ~= nil then
    local lvUp = self.heroDisplayData.lvUp
    self.lvUpContent:SetActive(lvUp)
    if lvUp then
      self.lvUpEffect:SetActive(false)
      self.lvUpEffect:SetActive(true)
    else
      self.lvUpEffect:SetActive(false)
    end
  end
end

return LWUITrailTowerBattleEndHeroItemRender
