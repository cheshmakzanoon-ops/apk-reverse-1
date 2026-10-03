local UIParkourBattleStatisticHeroEntry = BaseClass("UIParkourBattleStatisticHeroEntry", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")

function UIParkourBattleStatisticHeroEntry:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIParkourBattleStatisticHeroEntry:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIParkourBattleStatisticHeroEntry:OnEnable()
  base.OnEnable(self)
  self.active = true
end

function UIParkourBattleStatisticHeroEntry:OnDisable()
  base.OnDisable(self)
  self.active = false
end

function UIParkourBattleStatisticHeroEntry:ComponentDefine()
  self.txtName = self:AddComponent(UIText, "HeroName")
  self.txtDmg = self:AddComponent(UIText, "DmgTxt")
  self.barBg = self:AddComponent(UIBaseContainer, "ProgressBar")
  self.barInner = self:AddComponent(UIBaseContainer, "ProgressBar/Inner")
  self.heroCell = self:AddComponent(UIHeroCellSmall, "UIHeroCellSmall")
  self.heroDeath = self:AddComponent(UIBaseContainer, "deathState")
end

function UIParkourBattleStatisticHeroEntry:ComponentDestroy()
  if not IsNull(self.tween) then
    self.tween:Kill()
    self.tween = nil
  end
end

function UIParkourBattleStatisticHeroEntry:RefreshView(heroData, value, maxValue, heroDeath)
  if not IsNull(self.tween) then
    self.tween:Kill()
    self.tween = nil
  end
  if heroData.fromTemplate then
    local uniqueWeaponLv = 0
    if heroData.GetUniqueWeaponLv then
      uniqueWeaponLv = heroData:GetUniqueWeaponLv()
    end
    local awakenLv = 0
    if heroData.GetHeroAwakenRankLevel then
      awakenLv = heroData:GetHeroAwakenRankLevel()
    end
    local skinId = 0
    if heroData.GetSkinId then
      skinId = heroData:GetSkinId()
    end
    self.heroCell:InitWithConfigId(heroData.heroId, nil, heroData.level, heroData:GetRank(), uniqueWeaponLv, awakenLv, skinId)
  else
    self.heroCell:SetData(heroData.uuid)
  end
  self.txtName:SetText(Localization:GetString(heroData.firstName))
  self.txtDmg:SetText(0)
  local barSize = self.barBg:GetSizeDelta()
  self.barInner:SetSizeDelta(Vector2(0, barSize.y))
  self.progress = 0
  local percent = value / maxValue
  self.tween = CS.DG.Tweening.DOTween.To(function()
    return self.progress
  end, function(p)
    self.progress = value
    local pValue = value * p
    self.txtDmg:SetText(string.GetFormattedStr(pValue))
    self.barInner:SetSizeDelta(Vector2(p * percent * barSize.x, barSize.y))
  end, 1, percent * 1):SetEase(CS.DG.Tweening.Ease.OutCubic)
  if heroDeath then
    self.heroDeath:SetActive(true)
  else
    self.heroDeath:SetActive(false)
  end
end

return UIParkourBattleStatisticHeroEntry
