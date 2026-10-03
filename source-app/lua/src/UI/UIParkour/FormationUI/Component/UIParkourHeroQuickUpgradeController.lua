local base = UIBaseContainer
local UIParkourHeroQuickUpgradeController = BaseClass("UIParkourHeroQuickUpgradeController", UIBaseContainer)
local UIParkourHeroQuickUpgradeContentComponent = require("UI.UIParkour.FormationUI.Component.UIParkourHeroQuickUpgradeContentComponent")
local HeroParamData = {
  heroData = nil,
  levelType = HeroLevelType.None,
  canArmedUpgrade = false
}
local ParamDataClass = DataClass("ParamDataClass", HeroParamData)
local QUICK_UPGRADE_HERO_MODEL_PATH = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourHeroQuickUpgradeContent.prefab"

function UIParkourHeroQuickUpgradeController:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
end

function UIParkourHeroQuickUpgradeController:OnDestroy()
  self:DataDestroy()
  self:DestroyQuickUpgradeHeroView()
  base.OnDestroy(self)
end

function UIParkourHeroQuickUpgradeController:DataDefine()
end

function UIParkourHeroQuickUpgradeController:DataDestroy()
  self.cityLimitLevel = nil
  self.heroAtLeastLevelNum = nil
  self.heroId2LanguageKeyDict = nil
end

local function SortHero(a, b)
  local aCanArmedUpgrade = a.canArmedUpgrade and 1 or 0
  local bCanArmedUpgrade = b.canArmedUpgrade and 1 or 0
  if aCanArmedUpgrade ~= bCanArmedUpgrade then
    return aCanArmedUpgrade > bCanArmedUpgrade
  end
  if a.heroData.quality ~= b.heroData.quality then
    return a.heroData.quality > b.heroData.quality
  end
  local aPriority = a.levelType == HeroLevelType.All and 1 or 0
  local bPriority = b.levelType == HeroLevelType.All and 1 or 0
  if aPriority ~= bPriority then
    return aPriority > bPriority
  end
  if a.heroData.power ~= b.heroData.power then
    return a.heroData.power > b.heroData.power
  end
  return a.heroData.heroId < b.heroData.heroId
end

function UIParkourHeroQuickUpgradeController:RefreshCheckHeroQuickUpgradeShowState(index2HeroDataDict)
  self.quickUpgradeHeroData = nil
  self.totalHeroDataList = {}
  self.heroIndex = 0
  self.heroUuid2IndexDict = {}
  self:GetEnoughUpgradeLevelConditionHeroList(index2HeroDataDict)
  self:GetEnoughStarLevelConditionHeroList(index2HeroDataDict)
  local heroCount = #self.totalHeroDataList
  if 0 < heroCount then
    if 1 < heroCount then
      table.sort(self.totalHeroDataList, SortHero)
    end
    self.quickUpgradeHeroData = self.totalHeroDataList[1]
  else
    self.quickUpgradeHeroData = nil
  end
  self:ShowQuickUpgradeHeroView()
end

function UIParkourHeroQuickUpgradeController:GetHeroLanguageKey()
  if self.quickUpgradeHeroData then
    if self.heroId2LanguageKeyDict == nil then
      self.heroId2LanguageKeyDict = {}
      local str = LuaEntry.DataConfig:TryGetStr("quick_upgrade_hero_plot", "k1")
      if not string.IsNullOrEmpty(str) then
        local strArr = string.split(str, "|")
        for i = 1, #strArr do
          local valueStr = string.split(strArr[i], ";")
          if valueStr and #valueStr == 2 then
            local heroId = tonumber(valueStr[1])
            local languageKey = valueStr[2]
            if heroId and languageKey then
              self.heroId2LanguageKeyDict[heroId] = languageKey
            end
          end
        end
      end
    end
    local targetHeroId = self.quickUpgradeHeroData.heroData.heroId
    return self.heroId2LanguageKeyDict[targetHeroId] or ""
  end
  return ""
end

function UIParkourHeroQuickUpgradeController:CreateOrRefreshHeroParamData(heroData, heroLevelType)
  local heroIndex = self.heroUuid2IndexDict[heroData.uuid]
  local paramData
  if heroIndex == nil then
    self.heroIndex = self.heroIndex + 1
    self.heroUuid2IndexDict[heroData.uuid] = self.heroIndex
    paramData = ParamDataClass.New()
    paramData.heroData = heroData
    paramData.levelType = heroLevelType
    paramData.canArmedUpgrade = false
    table.insert(self.totalHeroDataList, paramData)
  else
    paramData = self.totalHeroDataList[heroIndex]
    if paramData and paramData.levelType ~= heroLevelType then
      paramData.levelType = HeroLevelType.All
    end
  end
  return paramData
end

function UIParkourHeroQuickUpgradeController:GetEnoughUpgradeLevelConditionHeroList(index2HeroDataDict)
  if not index2HeroDataDict or table.count(index2HeroDataDict) == 0 then
    return nil
  end
  local cityLimitLevel = self:GetCityLimitLevel()
  local targetLevel = self:HeroUpgradeLevelConditionAtLeastNum()
  for index, heroData in pairs(index2HeroDataDict) do
    if heroData and heroData.quality ~= HeroQualityType.Outstanding then
      local canUpGradeLevels = HeroUtils.CanHeroUpgradeMultipleLevels(heroData, targetLevel, false, cityLimitLevel)
      if canUpGradeLevels then
        self:CreateOrRefreshHeroParamData(heroData, HeroLevelType.CanUpgradeLevel)
      end
      if heroData.heroId == DataCenter.LWArmedUpgradeManager.monicaHeroId then
        local levelUpCondition, canLevelUp = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeCanLevelUpData()
        if canLevelUp then
          local paramData = self:CreateOrRefreshHeroParamData(heroData, HeroLevelType.CanUpgradeLevel)
          if paramData then
            paramData.canArmedUpgrade = true
          end
        end
      end
    end
  end
end

function UIParkourHeroQuickUpgradeController:GetEnoughStarLevelConditionHeroList(index2HeroDataDict)
  if not index2HeroDataDict or table.count(index2HeroDataDict) == 0 then
    return nil
  end
  for index, heroData in pairs(index2HeroDataDict) do
    if heroData and (heroData.quality == HeroQualityType.Genius or heroData.quality == HeroQualityType.Outstanding) and heroData:CanUpgradeToNextStar() then
      self:CreateOrRefreshHeroParamData(heroData, HeroLevelType.CanStarLevel)
    end
  end
end

function UIParkourHeroQuickUpgradeController:GetCityLimitLevel()
  if self.cityLimitLevel == nil then
    self.cityLimitLevel = LuaEntry.DataConfig:TryGetNum("settlement_upgrade_goto", "k2")
    if self.cityLimitLevel == nil then
      self.cityLimitLevel = 1
    end
  end
  return self.cityLimitLevel
end

function UIParkourHeroQuickUpgradeController:HeroUpgradeLevelConditionAtLeastNum()
  if self.heroAtLeastLevelNum == nil then
    self.heroAtLeastLevelNum = LuaEntry.DataConfig:TryGetNum("settlement_upgrade_goto", "k3")
    if self.heroAtLeastLevelNum == nil then
      self.heroAtLeastLevelNum = 5
    end
  end
  return self.heroAtLeastLevelNum
end

function UIParkourHeroQuickUpgradeController:ShowQuickUpgradeHeroView()
  if self.quickUpgradeHeroData == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  if self.quickUpgradeHeroViewReq == nil then
    self.quickUpgradeHeroViewReq = self:GameObjectInstantiateAsync(QUICK_UPGRADE_HERO_MODEL_PATH, function(request)
      if request.isError then
        self:DestroyQuickUpgradeHeroView()
        return
      end
      local go = request.gameObject
      if IsNull(go) then
        self:DestroyQuickUpgradeHeroView()
        return
      end
      local transform = go.transform
      transform:SetParent(self.transform)
      transform:Set_localScale(1, 1, 1)
      transform:Set_localRotation(0, 0, 0)
      transform:Set_localPosition(-299 * CommonUtil.ArabicAutoMirrorFactor(), 300, 0)
      go.name = "ParkourHeroQuickUpgradeObj"
      self.heroQuickUpgradeViewComponent = self:AddComponent(UIParkourHeroQuickUpgradeContentComponent, go.name)
      local heroLanguageKey = self:GetHeroLanguageKey()
      self.heroQuickUpgradeViewComponent:ReInit(self.quickUpgradeHeroData, heroLanguageKey)
    end)
  elseif self.heroQuickUpgradeViewComponent ~= nil then
    local heroLanguageKey = self:GetHeroLanguageKey()
    self.heroQuickUpgradeViewComponent:ReInit(self.quickUpgradeHeroData, heroLanguageKey)
  end
end

function UIParkourHeroQuickUpgradeController:DestroyQuickUpgradeHeroView()
  if self.quickUpgradeHeroViewReq ~= nil then
    self:GameObjectDestroy(self.quickUpgradeHeroViewReq)
    self.quickUpgradeHeroViewReq = nil
  end
  self.heroQuickUpgradeViewComponent = nil
end

return UIParkourHeroQuickUpgradeController
