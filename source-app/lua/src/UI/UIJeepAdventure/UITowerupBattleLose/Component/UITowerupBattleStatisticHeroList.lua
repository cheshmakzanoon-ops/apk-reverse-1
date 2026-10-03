local UITowerupBattleStatisticHeroList = BaseClass("UITowerupBattleStatisticHeroList", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIStatisticEntry = require("UI.UIParkour.WinUI.Component.UIParkourBattleStatisticHeroEntry")
local UIStatisticWeaponEntry = require("UI.UIZombieBattleLose.Component.UIZombieBattleStatisticWeaponEntry")

function UITowerupBattleStatisticHeroList:OnCreate(statisticalFieldName, param)
  base.OnCreate(self)
  self:ComponentDefine()
  self.statisticalFieldName = statisticalFieldName
  self.param = param
end

function UITowerupBattleStatisticHeroList:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITowerupBattleStatisticHeroList:OnEnable()
  base.OnEnable(self)
  self.active = true
end

function UITowerupBattleStatisticHeroList:OnDisable()
  base.OnDisable(self)
  self.active = false
end

function UITowerupBattleStatisticHeroList:ComponentDefine()
  self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.heroEntries = {}
  for i = 1, 6 do
    self.heroEntries[i] = self:AddComponent(UIStatisticEntry, "Viewport/Content/HeroEntry_" .. i)
  end
  self.weaponEntry = self:AddComponent(UIStatisticWeaponEntry, "Viewport/Content/WeaponEntry")
  self.weaponEntry:SetActive(false)
end

function UITowerupBattleStatisticHeroList:ComponentDestroy()
  if not IsNull(self.fadeTween) then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
end

function UITowerupBattleStatisticHeroList:FadeIn()
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

function UITowerupBattleStatisticHeroList:RefreshView()
  if self.param.type == PVEType.Barrage then
    self:RefreshBarrageView()
  elseif self.param.type == PVEType.FakePVP then
    self:RefreshFakePVPView()
  elseif self.param.type == PVEType.Parkour then
    self:RefreshParkourView()
  end
end

function UITowerupBattleStatisticHeroList:RefreshBarrageView()
  local squad = DataCenter.ZombieBattleManager.squad
  local statisticalData = DataCenter.ZombieBattleManager.heroStatisticalData[self.statisticalFieldName]
  local heroDeathData = DataCenter.ZombieBattleManager.heroStatisticalData.death
  local maxValue = 0
  local heroDatas = {}
  local heroDeaths = {}
  for i = 1, 5 do
    local heroData = squad.heroes[i]
    if heroData then
      table.insert(heroDatas, heroData)
      local value = statisticalData[heroData.uuid] or 0
      if maxValue < value then
        maxValue = value
      end
      table.insert(heroDeaths, heroDeathData[heroData.uuid] or false)
    end
  end
  for i, entry in ipairs(self.heroEntries) do
    local heroData = heroDatas[i]
    if heroData then
      entry:SetActive(true)
      entry:RefreshView(heroData, statisticalData[heroData.uuid] or 0, maxValue, heroDeaths[i])
    else
      entry:SetActive(false)
    end
  end
end

function UITowerupBattleStatisticHeroList:RefreshFakePVPView()
  self.logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local data = self.logic.battleData.extData
  local maxValue = 0
  local heroDatas = {}
  local heroVal = {}
  local heroDeaths = {}
  
  local function HeroDataHandler(heroData)
    table.insert(heroDatas, heroData)
    local value = 0
    if self.statisticalFieldName == "makeDmg" then
      value = heroData.stat.damage
    else
      value = heroData.stat.injured
    end
    if value > maxValue then
      maxValue = value
    end
    table.insert(heroVal, value)
    table.insert(heroDeaths, 0 >= heroData.hp)
  end
  
  local startSlot = PVPBattleSlot.SelfHero1
  local endSlot = PVPBattleSlot.SelfHero5
  for i = startSlot, endSlot do
    local heroData = self.logic.battleData.heroData[i]
    if heroData then
      HeroDataHandler(heroData)
    end
  end
  local dominatorData = self.logic.battleData.heroData[PVPBattleSlot.SelfDominator]
  if dominatorData then
    HeroDataHandler(dominatorData)
  end
  for i, entry in ipairs(self.heroEntries) do
    local heroData = heroDatas[i]
    if heroData then
      entry:SetActive(true)
      local inData = heroData.heroInfo
      inData.uuid = heroData.heroUuid
      entry:RefreshView(inData, heroVal[i] or 0, maxValue, heroDeaths[i])
    else
      entry:SetActive(false)
    end
  end
end

function UITowerupBattleStatisticHeroList:RefreshParkourView()
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local team = battleLogic.team.teamInitUnits
  local statisticalData = battleLogic.heroStatisticalData[self.statisticalFieldName]
  local heroDeathData = battleLogic.heroStatisticalData.death
  local maxValue = 0
  local heroDatas = {}
  local heroDeaths = {}
  local startSlot = PVPBattleSlot.SelfHero1
  local endSlot = PVPBattleSlot.SelfHero5
  for i = startSlot, endSlot do
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

return UITowerupBattleStatisticHeroList
