local UIParkourBattleStatisticHeroList = BaseClass("UIParkourBattleStatisticHeroList", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIStatisticEntry = require("UI.UIParkour.WinUI.Component.UIParkourBattleStatisticHeroEntry")
local UIStatisticWeaponEntry = require("UI.UIZombieBattleLose.Component.UIZombieBattleStatisticWeaponEntry")

function UIParkourBattleStatisticHeroList:OnCreate(statisticalFieldName)
  base.OnCreate(self)
  self:ComponentDefine()
  self.statisticalFieldName = statisticalFieldName
end

function UIParkourBattleStatisticHeroList:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIParkourBattleStatisticHeroList:OnEnable()
  base.OnEnable(self)
  self.active = true
end

function UIParkourBattleStatisticHeroList:OnDisable()
  base.OnDisable(self)
  self.active = false
end

function UIParkourBattleStatisticHeroList:ComponentDefine()
  self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.heroEntries = {}
  for i = 1, 5 do
    self.heroEntries[i] = self:AddComponent(UIStatisticEntry, "Viewport/Content/HeroEntry_" .. i)
  end
  self.weaponEntry = self:AddComponent(UIStatisticWeaponEntry, "Viewport/Content/WeaponEntry")
end

function UIParkourBattleStatisticHeroList:ComponentDestroy()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
end

function UIParkourBattleStatisticHeroList:FadeIn()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.canvasGroup.alpha = 0
  self.fadeTween = CS.DG.Tweening.DOTween.To(function()
    return self.canvasGroup.alpha
  end, function(value)
    self.canvasGroup.alpha = value
  end, 1, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
end

function UIParkourBattleStatisticHeroList:RefreshView()
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local team = battleLogic.team.teamInitUnits
  local statisticalData = battleLogic.heroStatisticalData[self.statisticalFieldName]
  local heroDeathData = battleLogic.heroStatisticalData.death
  local maxValue = 0
  local heroDatas = {}
  local heroDeaths = {}
  for i = 1, 5 do
    local hero = team[i]
    if hero then
      local heroData = hero.hero
      table.insert(heroDatas, heroData)
      local value = statisticalData[heroData.uuid] or 0
      if maxValue < value then
        maxValue = value
      end
      table.insert(heroDeaths, heroDeathData[heroData.uuid] or false)
    end
  end
  local weaponStatisticalData = battleLogic.weaponStatisticalData[self.statisticalFieldName]
  if maxValue < weaponStatisticalData then
    maxValue = weaponStatisticalData
  end
  for i, entry in ipairs(self.heroEntries) do
    local heroData = heroDatas[i]
    if heroData then
      local statisticalValue = statisticalData[heroData.uuid]
      if statisticalValue then
        entry:SetActive(true)
        entry:RefreshView(heroData, statisticalValue, maxValue, heroDeaths[i])
      else
        entry:SetActive(false)
      end
    else
      entry:SetActive(false)
    end
  end
  local weaponData = battleLogic.team.weaponData
  local weaponAppearanceId = battleLogic.team.weaponAppearanceId
  if self.statisticalFieldName == "makeDmg" and 0 < weaponStatisticalData and weaponData ~= nil then
    self.weaponEntry:SetActive(true)
    self.weaponEntry:RefreshView(weaponData, weaponAppearanceId, weaponStatisticalData, maxValue)
  else
    self.weaponEntry:SetActive(false)
  end
end

return UIParkourBattleStatisticHeroList
