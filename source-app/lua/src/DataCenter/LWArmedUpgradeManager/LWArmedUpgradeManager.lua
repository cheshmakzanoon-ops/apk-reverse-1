local LWArmedUpgradeManager = BaseClass("LWArmedUpgradeManager", CEventable)
local Setting = CS.GameEntry.Setting
local Resource = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local ARMED_UPGRADE_CITY_MODEL_PATH = "Assets/Main/Prefabs/UI/UILWArmedUpgrade/MainView/ArmedUpgradeCityModel.prefab"
local END_TIMELINE_PATH = "Assets/Main/Prefabs/LWGuide/TimeLinePerfabs/transportcar_Timeline.prefab"
local LWArmedUpgradeCityModelView = require("UI.UILWArmedUpgrade.CityModelView.LWArmedUpgradeCityModelView")
local LWArmedUpgradeZeroLevelCityDirector = require("UI.UILWArmedUpgrade.CityModelView.LWArmedUpgradeZeroLevelCityDirector")
local LWArmedUpgradeOneLevelCityDirector = require("UI.UILWArmedUpgrade.CityModelView.LWArmedUpgradeOneLevelCityDirector")
local LWArmedUpgradeTwoLevelCityDirector = require("UI.UILWArmedUpgrade.CityModelView.LWArmedUpgradeTwoLevelCityDirector")
local LWArmedUpgradeThreeLevelCityDirector = require("UI.UILWArmedUpgrade.CityModelView.LWArmedUpgradeThreeLevelCityDirector")
local LWArmedUpgradeFourLevelCityDirector = require("UI.UILWArmedUpgrade.CityModelView.LWArmedUpgradeFourLevelCityDirector")

function LWArmedUpgradeManager:__init()
  self.armedUpgradeOpenCondition = nil
  self.armedUpgradePopCDTime = nil
  self.armedUpgradeLevel = 0
  self.playTimelineGuideId = 1056
  self.clickCityMonicaGuideId = 5432
  self.clickCityMonicaProtectGuidId = 5433
  self.UIMainPlotInterval = nil
  self.UIMainIdlePlotList = nil
  self.UIMainEncouragePlotList = nil
  self.UIMainComfortPlotList = nil
  self.UIMainHappyPlotList = nil
  self.HappyMonopolyIdMap = nil
  self.armedUpgradeCityModelPos = nil
  self.armedUpgradeCityModelNoLevelUpDialogueList = nil
  self.armedUpgradeCityModelLevelUpDialogueList = nil
  self.needFlyToArmedUpgradeEntranceGoodIdMap = nil
  self.monicaHeroId = LuaEntry.DataConfig:TryGetNum("armed_upgrade_config", "k6")
  self.forceCloseArmedUpgradeMonopolyStageId = DataCenter.LWCivilizationSparkExtend:LWArmedUpgradeManager_getForceCloseArmedUpgradeMonopolyStageId()
  self.monicaHeroSkillDict = {}
  self.canPlayDubLanguageNameList = nil
  self.blockExpireTime = 0.2
  self.blockerHandleID = nil
  self.active = nil
  self.cityDirectorMap = {}
  self.cityDirector = nil
  self.isInitModelAndCityDirector = nil
  self:AddListener()
end

function LWArmedUpgradeManager:OnEnterGame()
  self:TryCorrectPlayedTimeLineStatus()
  self:TryCorrectIsArmedUpgradeMaxLevelByMonopoly()
  self:TryCorrectFinishClickGuideStatus()
end

function LWArmedUpgradeManager:__delete()
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  self.armedUpgradeOpenCondition = nil
  self.armedUpgradePopCDTime = nil
  self.armedUpgradeLevel = nil
  self.playTimelineGuideId = nil
  self.clickCityMonicaGuideId = nil
  self.clickCityMonicaProtectGuidId = nil
  self.appearanceVisible = nil
  self.finishClickGuide = nil
  self.UIMainPlotInterval = nil
  self.UIMainIdlePlotList = nil
  self.UIMainEncouragePlotList = nil
  self.UIMainComfortPlotList = nil
  self.UIMainHappyPlotList = nil
  self.HappyMonopolyIdMap = nil
  self.armedUpgradeCityModelPos = nil
  self.armedUpgradeCityModelNoLevelUpDialogueList = nil
  self.armedUpgradeCityModelLevelUpDialogueList = nil
  self.needFlyToArmedUpgradeEntranceGoodIdMap = nil
  self.monicaHeroId = nil
  self.forceCloseArmedUpgradeMonopolyStageId = nil
  self.monicaHeroSkillDict = nil
  self.canPlayDubLanguageNameList = nil
  self.blockExpireTime = nil
  self:DisableInteractionBlocker()
  self.active = nil
  for cId, cityDirector in pairs(self.cityDirectorMap) do
    cityDirector:Delete()
  end
  self.cityDirectorMap = nil
  self.cityDirector = nil
  self.isInitModelAndCityDirector = nil
  self.jpReplaceTimelineResMap = nil
  self.jpReplaceMonopolyPawnBeforeResMap = nil
  self:RemoveArmedUpgradeCityModelView()
  self:DestroyEndTimeline()
  self:ClearDelay()
end

function LWArmedUpgradeManager:AddListener()
  self:RegisterEvent(EventId.BuildLevelUp, self.OnBuildUpLevel)
  self:RegisterEvent(EventId.RefreshItems, self.OnRefreshItems)
  self:RegisterEvent(EventId.GF_enter_city, self.OnEnable)
  self:RegisterEvent(EventId.BeforeReleaseCity, self.OnDisable)
  self:RegisterEvent(EventId.MonopolyPlayerWin, self.OnMonopolyPlayerWin)
  self:RegisterEvent(EventId.GF_guide_step_done, self.OnGuideFlowStepDone)
  self:RegisterEvent(EventId.GF_guide_canceled, self.OnGuideCanceled)
  self:RegisterEvent(EventId.GF_guide_done, self.OnGuideDone)
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
end

function LWArmedUpgradeManager:OnEnable()
  self.active = CS.SceneManager:IsInCity()
  if self.active and not self.isInitModelAndCityDirector then
    self.isInitModelAndCityDirector = true
    self:CheckShowCityModelAndCityDirector()
  end
end

function LWArmedUpgradeManager:OnDisable()
  if not self.active then
    return
  end
  self.active = false
  if self.isInitModelAndCityDirector then
    self.isInitModelAndCityDirector = false
    self:StopCityDirector()
    self:RemoveArmedUpgradeCityModelView()
  end
end

function LWArmedUpgradeManager.OnUpdate()
  local self = DataCenter.LWArmedUpgradeManager
  local dt = Time.deltaTime
  if not self.active then
    return
  end
  if self.cityDirector and self.cityDirector.start then
    self.cityDirector:OnUpdate(dt)
  end
  if self.armedUpgradeCityModelView then
    self.armedUpgradeCityModelView:OnUpdate(dt)
  end
end

function LWArmedUpgradeManager:InitData(message)
  self.forceCloseArmedUpgradeMonopolyStageId = DataCenter.LWCivilizationSparkExtend:LWArmedUpgradeManager_getForceCloseArmedUpgradeMonopolyStageId()
  if message.armedUpgrade then
    self.armedUpgradeLevel = message.armedUpgrade
    local heroInfo = DataCenter.HeroDataManager:GetHeroByHeroId(self.monicaHeroId)
    if heroInfo ~= nil then
      self:UpdateArmedUpgradeSkillInfoData(heroInfo)
    end
    self:TryCorrectPlayedTimeLineStatus()
    self:TryCorrectIsArmedUpgradeMaxLevelByMonopoly()
    self:TryCorrectFinishClickGuideStatus()
  end
end

function LWArmedUpgradeManager:UpdateData(message)
  if message.armedUpgrade then
    self.armedUpgradeLevel = message.armedUpgrade
    local isMaxLevel = self:IsAchieveArmedUpgradeMaxLevel()
    local heroInfo = DataCenter.HeroDataManager:GetHeroByHeroId(self.monicaHeroId)
    if heroInfo ~= nil then
      self:UpdateArmedUpgradeSkillInfoData(heroInfo)
    end
    EventManager:GetInstance():Broadcast(EventId.ArmedUpgradeLevelChanged, isMaxLevel)
    if isMaxLevel then
      self:RemoveArmedUpgradeCityModelView()
      self:StopCityDirector()
    else
      self:SpawnArmedUpgradeCityModelView()
      self:RefreshCityDirector()
    end
  end
end

function LWArmedUpgradeManager:OnBuildUpLevel(info)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(info.uuid)
  if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN then
    self:CheckShowCityModelAndCityDirector()
  end
end

function LWArmedUpgradeManager:OnRefreshItems()
  self:RefreshArmedUpgradeCityModelBubble()
end

function LWArmedUpgradeManager:OnMonopolyPlayerWin()
  local monopolyStageId = 0
  if DataCenter.MonopolyManager.player then
    monopolyStageId = DataCenter.MonopolyManager.player.curId
  end
  if monopolyStageId >= self.forceCloseArmedUpgradeMonopolyStageId then
    local isMaxLevel = self:IsAchieveArmedUpgradeMaxLevel()
    if not isMaxLevel then
      local maxLevel = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeMaxLevel()
      self.armedUpgradeLevel = maxLevel
      local heroInfo = DataCenter.HeroDataManager:GetHeroByHeroId(self.monicaHeroId)
      if heroInfo ~= nil then
        self:UpdateArmedUpgradeSkillInfoData(heroInfo)
      end
      EventManager:GetInstance():Broadcast(EventId.ArmedUpgradeLevelChanged, true)
      self:RemoveArmedUpgradeCityModelView()
      self:StopCityDirector()
      SFSNetwork.SendMessage(MsgDefines.ArmedUpgradeLevelUp, maxLevel)
    end
  end
end

function LWArmedUpgradeManager:OnGuideFlowStepDone(behaviour)
  local name = behaviour.name
  if name == "play_timeline" and behaviour.flowId == self.playTimelineGuideId then
    self.appearanceVisible = true
    CommonUtil.PlayerPrefsSetBool(SettingKeys.ARMED_UPGRADE_PLAYED_TIMELINE, true)
    self:RefreshArmedUpgradeCityModelViewActive()
    self:RefreshCityDirector()
    if LuaEntry.Player.armed_upgrade_repair > 0 then
      local posStr = LuaEntry.DataConfig:TryGetStr("armed_upgrade_config", "k13")
      if not string.IsNullOrEmpty(posStr) then
        local posArr = string.split(posStr, ",")
        if #posArr == 3 then
          local worldPos = Vector3.New(tonumber(posArr[1]), tonumber(posArr[2]), tonumber(posArr[3]))
          self:DisableInteractionBlocker()
          self.blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.blockExpireTime)
          local UIMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
          if UIMain then
            UIMain.View:PlayAnim(UIMainAnimType.AllShow, true)
          end
          GoToUtil.GotoCityPos(worldPos, CS.SceneManager.World.InitZoom, self.blockExpireTime, function()
            self:DisableInteractionBlocker()
            local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_RADAR)
            if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
              GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_RADAR)
            end
          end)
        end
      end
    end
  end
end

function LWArmedUpgradeManager:OnGuideCanceled(flowId)
  if flowId == self.clickCityMonicaGuideId or flowId == self.clickCityMonicaProtectGuidId then
    DataCenter.LWGuideFlowManager:WriteDone(flowId)
    self.finishClickGuide = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArmedUpgradeMain)
  end
end

function LWArmedUpgradeManager:OnGuideDone(flowId)
  if flowId == self.clickCityMonicaGuideId or flowId == self.clickCityMonicaProtectGuidId then
    self.finishClickGuide = true
  end
end

function LWArmedUpgradeManager:TryCorrectIsArmedUpgradeMaxLevelByMonopoly()
  local monopolyStageId = 0
  if DataCenter.MonopolyManager.player then
    monopolyStageId = DataCenter.MonopolyManager.player.curId
  end
  if monopolyStageId > self.forceCloseArmedUpgradeMonopolyStageId then
    local isMaxLevel = self:IsAchieveArmedUpgradeMaxLevel()
    if not isMaxLevel then
      local maxLevel = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeMaxLevel()
      self.armedUpgradeLevel = maxLevel
      local heroInfo = DataCenter.HeroDataManager:GetHeroByHeroId(self.monicaHeroId)
      if heroInfo ~= nil then
        self:UpdateArmedUpgradeSkillInfoData(heroInfo)
      end
      EventManager:GetInstance():Broadcast(EventId.ArmedUpgradeLevelChanged, true)
      SFSNetwork.SendMessage(MsgDefines.ArmedUpgradeLevelUp, maxLevel)
    end
  end
end

function LWArmedUpgradeManager:TryCorrectPlayedTimeLineStatus()
  local guideDone = DataCenter.LWGuideFlowManager:ReadDone(self.playTimelineGuideId)
  local isPlayed = CommonUtil.PlayerPrefsGetBool(SettingKeys.ARMED_UPGRADE_PLAYED_TIMELINE, false)
  if guideDone and not isPlayed then
    isPlayed = guideDone
    CommonUtil.PlayerPrefsSetBool(SettingKeys.ARMED_UPGRADE_PLAYED_TIMELINE, true)
  end
  self.appearanceVisible = isPlayed
end

function LWArmedUpgradeManager:TryCorrectFinishClickGuideStatus()
  local clickCityMonicaGuideDone = DataCenter.LWGuideFlowManager:ReadDone(self.clickCityMonicaGuideId)
  local clickCityMonicaProtectGuideDone = DataCenter.LWGuideFlowManager:ReadDone(self.clickCityMonicaProtectGuidId)
  self.finishClickGuide = clickCityMonicaGuideDone or clickCityMonicaProtectGuideDone
end

function LWArmedUpgradeManager:IsAchieveArmedUpgradeOpenCondition()
  if self.armedUpgradeOpenCondition == nil then
    local conditionStr = LuaEntry.DataConfig:TryGetStr("armed_upgrade_config", "k3")
    if not string.IsNullOrEmpty(conditionStr) then
      local conditionList = string.split(conditionStr, ";")
      if table.count(conditionList) == 2 then
        self.armedUpgradeOpenCondition = {}
        self.armedUpgradeOpenCondition.buildingId = tonumber(conditionList[1]) or 0
        self.armedUpgradeOpenCondition.needLevel = tonumber(conditionList[2]) or 0
      end
    end
  end
  if self.armedUpgradeOpenCondition ~= nil then
    local level = DataCenter.BuildManager:GetMaxBuildingLevel(self.armedUpgradeOpenCondition.buildingId)
    if level >= self.armedUpgradeOpenCondition.needLevel then
      return true
    end
  end
  return false
end

function LWArmedUpgradeManager:IsAchieveArmedUpgradeMaxLevel()
  local maxLevel = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeMaxLevel()
  return maxLevel <= self.armedUpgradeLevel
end

function LWArmedUpgradeManager:IsArmedUpgradeOpen(withCheckAB)
  local isAchieveOpenCondition = self:IsAchieveArmedUpgradeOpenCondition()
  if not isAchieveOpenCondition then
    return false
  end
  local isMaxLevel = self:IsAchieveArmedUpgradeMaxLevel()
  if isMaxLevel then
    return false
  end
  return true
end

function LWArmedUpgradeManager:CheckShowArmedUpgradePop()
  local isOpen = self:IsArmedUpgradeOpen()
  if not isOpen then
    return false, false
  end
  if not self.appearanceVisible then
    return false, false
  end
  if not self.finishClickGuide then
    return false, false
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local lastTime = CommonUtil.PlayerPrefsGetString(SettingKeys.ARMED_UPGRADE_SHOW_BANNER_POP_LAST_TIME, "")
  if string.IsNullOrEmpty(lastTime) then
    CommonUtil.PlayerPrefsSetString(SettingKeys.ARMED_UPGRADE_SHOW_BANNER_POP_LAST_TIME, tostring(curTime))
    return true, true
  end
  local tempTime = curTime - tonumber(lastTime)
  if self.armedUpgradePopCDTime == nil then
    self.armedUpgradePopCDTime = LuaEntry.DataConfig:TryGetNum("armed_upgrade_config", "k1")
  end
  if tempTime < self.armedUpgradePopCDTime then
    return false, false
  end
  CommonUtil.PlayerPrefsSetString(SettingKeys.ARMED_UPGRADE_SHOW_BANNER_POP_LAST_TIME, tostring(curTime))
  return true, false
end

function LWArmedUpgradeManager:GetArmedUpgradeCanLevelUpData()
  local template = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeTemplateByLevel(self.armedUpgradeLevel)
  if template == nil or table.count(template.upgrade_need) ~= 2 then
    return nil, false
  end
  local needItemId = template.upgrade_need[1]
  local needItemCount = template.upgrade_need[2]
  local curItemCount = DataCenter.ItemData:GetItemCount(needItemId)
  local canLevelUp = needItemCount <= curItemCount
  return template.upgrade_need, canLevelUp
end

function LWArmedUpgradeManager:CheckShowCityModelAndCityDirector()
  local isOpen = self:IsArmedUpgradeOpen()
  if not isOpen then
    return false
  end
  self:SpawnArmedUpgradeCityModelView()
  self:RefreshCityDirector()
end

function LWArmedUpgradeManager:CheckFlyRewardToArmedUpgradeEntrance(goodId)
  local isOpen = self:IsArmedUpgradeOpen()
  if not isOpen then
    return false
  end
  if self.needFlyToArmedUpgradeEntranceGoodIdMap == nil then
    self.needFlyToArmedUpgradeEntranceGoodIdMap = {}
    local str = LuaEntry.DataConfig:TryGetStr("armed_upgrade_config", "k5")
    if not string.IsNullOrEmpty(str) then
      local strArr = string.split(str, "|")
      for _, v in ipairs(strArr) do
        local vNumber = tonumber(v) or 0
        if 0 < vNumber then
          self.needFlyToArmedUpgradeEntranceGoodIdMap[vNumber] = true
        end
      end
    end
  end
  return self.needFlyToArmedUpgradeEntranceGoodIdMap[goodId] or false
end

function LWArmedUpgradeManager:GetArmedUpgradeAnimationName(level, isIdleAni)
  local finalLevel = level and level or self.armedUpgradeLevel
  local showIdleAni = true
  if isIdleAni ~= nil then
    showIdleAni = isIdleAni
  end
  if showIdleAni then
    return string.format("idle%d", finalLevel)
  else
    return string.format("show%d", finalLevel)
  end
end

function LWArmedUpgradeManager:IsCanPlayDubByLanguageName(targetLanguageName)
  if self.canPlayDubLanguageNameList == nil then
    local languageNameStr = LuaEntry.DataConfig:TryGetStr("armed_upgrade_config", "k9") or ""
    if not string.IsNullOrEmpty(languageNameStr) then
      local strArr = string.split(languageNameStr, "|")
      local count = table.count(strArr)
      if 0 < count then
        self.canPlayDubLanguageNameList = {}
        for i = 1, count do
          local languageName = strArr[i]
          table.insert(self.canPlayDubLanguageNameList, languageName)
        end
      end
    end
  end
  if self.canPlayDubLanguageNameList then
    local isCan = table.hasvalue(self.canPlayDubLanguageNameList, targetLanguageName)
    return isCan
  end
  return true
end

function LWArmedUpgradeManager:DisableInteractionBlocker()
  if self.blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.blockerHandleID)
  end
  self.blockerHandleID = nil
end

function LWArmedUpgradeManager:CheckIsSatisfyReplaceDataCondition(heroId, checkMaxLevel)
  if self.monicaHeroId ~= heroId then
    return false
  end
  local isCheckMaxLevel = checkMaxLevel == nil and true or checkMaxLevel
  if isCheckMaxLevel then
    local isMaxLevel = self:IsAchieveArmedUpgradeMaxLevel()
    if isMaxLevel then
      return false
    end
  end
  return true
end

function LWArmedUpgradeManager:GetArmedUpgradeAppearanceId(heroId, appearanceId, checkMaxLevel)
  local isSatisfyCondition = self:CheckIsSatisfyReplaceDataCondition(heroId, checkMaxLevel)
  if not isSatisfyCondition then
    return appearanceId, false
  end
  local template = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeTemplateByLevel(self.armedUpgradeLevel)
  if template == nil then
    return appearanceId, false
  end
  return template.appearance, true
end

function LWArmedUpgradeManager:GetArmedUpgradeEnergyLevelUpData(heroId, energyCount, energyEffect, checkMaxLevel)
  local isSatisfyCondition = self:CheckIsSatisfyReplaceDataCondition(heroId, checkMaxLevel)
  if not isSatisfyCondition then
    return energyEffect
  end
  local template = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeTemplateByLevel(self.armedUpgradeLevel)
  if template == nil then
    return energyEffect
  end
  return template:GetArmedUpgradeEnergyEffect(energyCount)
end

function LWArmedUpgradeManager:UpdateArmedUpgradeSkillInfoData(heroInfo)
  if heroInfo.heroId ~= self.monicaHeroId then
    return
  end
  local template = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeTemplateByLevel(self.armedUpgradeLevel)
  if template then
    local realSkillInfoList = heroInfo:GetSkillList()
    for slot, skillInfo in pairs(realSkillInfoList) do
      if slot == 1 or slot == 2 then
        local targetSkillId = template:GetArmedUpgradeSkillIdBySlot(slot)
        if 0 < targetSkillId then
          local newSkillInfo = heroInfo:CreateNewSkillInfoFormRealSkillInfo(targetSkillId, skillInfo)
          self.monicaHeroSkillDict[slot] = newSkillInfo
        end
      end
    end
  end
end

function LWArmedUpgradeManager:GetArmedUpgradeSkillInfoData(heroInfo, realSkillInfo, checkMaxLevel)
  local isSatisfyCondition = self:CheckIsSatisfyReplaceDataCondition(heroInfo.heroId, checkMaxLevel)
  if not isSatisfyCondition then
    return realSkillInfo
  end
  local slot = realSkillInfo:GetSlotIndex()
  if slot ~= 1 and slot ~= 2 then
    return realSkillInfo
  end
  local newSkillInfo = self.monicaHeroSkillDict[slot]
  if newSkillInfo == nil then
    return realSkillInfo
  end
  return newSkillInfo
end

function LWArmedUpgradeManager:GetUIMainPlotInterval()
  if self.UIMainPlotInterval == nil then
    self.UIMainPlotInterval = LuaEntry.DataConfig:TryGetNum("armed_upgrade_performance", "k1", 2.67)
  end
  return self.UIMainPlotInterval
end

function LWArmedUpgradeManager:GetUIMainIdlePlot()
  if self.UIMainIdlePlotList == nil then
    self.UIMainIdlePlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("armed_upgrade_performance", "k2")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.UIMainIdlePlotList, tonumber(v) or 0)
      end
    end
    self.UIMainIdlePlotCount = #self.UIMainIdlePlotList
  end
  if 0 < self.UIMainIdlePlotCount then
    if self.UIMainIdlePlotCount == 1 then
      return self.UIMainIdlePlotList[1]
    end
    local random = math.random(1, self.UIMainIdlePlotCount)
    return self.UIMainIdlePlotList[random]
  end
  return 0
end

function LWArmedUpgradeManager:GetUIMainEncouragePlot()
  if self.UIMainEncouragePlotList == nil then
    self.UIMainEncouragePlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("armed_upgrade_performance", "k3")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.UIMainEncouragePlotList, tonumber(v) or 0)
      end
    end
    self.UIMainEncouragePlotCount = #self.UIMainEncouragePlotList
  end
  if 0 < self.UIMainEncouragePlotCount then
    if self.UIMainEncouragePlotCount == 1 then
      return self.UIMainEncouragePlotList[1]
    end
    local random = math.random(1, self.UIMainEncouragePlotCount)
    return self.UIMainEncouragePlotList[random]
  end
  return 0
end

function LWArmedUpgradeManager:GetUIMainComfortPlot()
  if self.UIMainComfortPlotList == nil then
    self.UIMainComfortPlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("armed_upgrade_performance", "k4")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.UIMainComfortPlotList, tonumber(v) or 0)
      end
    end
    self.UIMainComfortPlotCount = #self.UIMainComfortPlotList
  end
  if 0 < self.UIMainComfortPlotCount then
    if self.UIMainComfortPlotCount == 1 then
      return self.UIMainComfortPlotList[1]
    end
    local random = math.random(1, self.UIMainComfortPlotCount)
    return self.UIMainComfortPlotList[random]
  end
  return 0
end

function LWArmedUpgradeManager:GetUIMainHappyPlot()
  if self.UIMainHappyPlotList == nil then
    self.UIMainHappyPlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("armed_upgrade_performance", "k5")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.UIMainHappyPlotList, tonumber(v) or 0)
      end
    end
    self.UIMainHappyPlotCount = #self.UIMainHappyPlotList
  end
  if 0 < self.UIMainHappyPlotCount then
    if self.UIMainHappyPlotCount == 1 then
      return self.UIMainHappyPlotList[1]
    end
    local random = math.random(1, self.UIMainHappyPlotCount)
    return self.UIMainHappyPlotList[random]
  end
  return 0
end

function LWArmedUpgradeManager:GetHappyMonopolyIdMap()
  if self.HappyMonopolyIdMap == nil then
    self.HappyMonopolyIdMap = {}
    local str = LuaEntry.DataConfig:TryGetStr("armed_upgrade_performance", "k6")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        local id = tonumber(v) or 0
        if 0 < id then
          self.HappyMonopolyIdMap[id] = true
        end
      end
    end
  end
  return self.HappyMonopolyIdMap
end

function LWArmedUpgradeManager:GetArmedUpgradeCityModelPos()
  if self.armedUpgradeCityModelPos == nil then
    local str = LuaEntry.DataConfig:TryGetStr("armed_upgrade_config", "k4")
    if not string.IsNullOrEmpty(str) then
      local strArr = string.split(str, ",")
      if table.count(strArr) == 3 then
        self.armedUpgradeCityModelPos = Vector3.New(tonumber(strArr[1]), tonumber(strArr[2]), tonumber(strArr[3]))
      end
    end
  end
  return self.armedUpgradeCityModelPos
end

function LWArmedUpgradeManager:GetArmedUpgradeCityModelNoLevelUpDialogue()
  if self.armedUpgradeCityModelNoLevelUpDialogueList == nil then
    self.armedUpgradeCityModelNoLevelUpDialogueList = {}
    local str = LuaEntry.DataConfig:TryGetStr("armed_upgrade_dialogues", "k2")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, "|")
      for _, v in ipairs(list) do
        table.insert(self.armedUpgradeCityModelNoLevelUpDialogueList, tonumber(v) or 0)
      end
    end
    self.armedUpgradeCityModelNoLevelUpDialogueListCount = table.count(self.armedUpgradeCityModelNoLevelUpDialogueList)
  end
  if 0 < self.armedUpgradeCityModelNoLevelUpDialogueListCount then
    if self.armedUpgradeCityModelNoLevelUpDialogueListCount == 1 then
      return self.armedUpgradeCityModelNoLevelUpDialogueList[1]
    end
    local random = math.random(1, self.armedUpgradeCityModelNoLevelUpDialogueListCount)
    return self.armedUpgradeCityModelNoLevelUpDialogueList[random]
  end
  return 0
end

function LWArmedUpgradeManager:GetArmedUpgradeCityModelLevelUpDialogue()
  if self.armedUpgradeCityModelLevelUpDialogueList == nil then
    self.armedUpgradeCityModelLevelUpDialogueList = {}
    local str = LuaEntry.DataConfig:TryGetStr("armed_upgrade_dialogues", "k1")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, "|")
      for _, v in ipairs(list) do
        table.insert(self.armedUpgradeCityModelLevelUpDialogueList, tonumber(v) or 0)
      end
    end
    self.armedUpgradeCityModelLevelUpDialogueListCount = table.count(self.armedUpgradeCityModelLevelUpDialogueList)
  end
  if 0 < self.armedUpgradeCityModelLevelUpDialogueListCount then
    if self.armedUpgradeCityModelLevelUpDialogueListCount == 1 then
      return self.armedUpgradeCityModelLevelUpDialogueList[1]
    end
    local random = math.random(1, self.armedUpgradeCityModelLevelUpDialogueListCount)
    return self.armedUpgradeCityModelLevelUpDialogueList[random]
  end
  return 0
end

function LWArmedUpgradeManager:SpawnArmedUpgradeCityModelView()
  if self.armedUpgradeCityModelViewReq == nil then
    self.armedUpgradeCityModelViewReq = Resource:InstantiateAsync(ARMED_UPGRADE_CITY_MODEL_PATH)
    self.armedUpgradeCityModelViewReq:completed("+", function(req)
      if req.isError then
        return
      end
      local go = req.gameObject
      local transform = go.transform
      transform:SetParent(nil)
      transform:Set_localScale(1, 1, 1)
      transform:Set_localRotation(0, 0, 0)
      local pos = self:GetArmedUpgradeCityModelPos()
      transform:Set_localPosition(pos.x, pos.y, pos.z)
      if self.armedUpgradeCityModelView == nil then
        self.armedUpgradeCityModelView = LWArmedUpgradeCityModelView.New()
      end
      self.armedUpgradeCityModelView:OnCreate(go)
      self.armedUpgradeCityModelView:ReInit(self.armedUpgradeLevel)
      self:RefreshArmedUpgradeCityModelViewActive()
    end)
  elseif self.armedUpgradeCityModelView ~= nil then
    self:RefreshArmedUpgradeCityModelViewActive()
    self.armedUpgradeCityModelView:ReInit(self.armedUpgradeLevel)
  end
end

function LWArmedUpgradeManager:RefreshArmedUpgradeCityModelViewActive()
  if self.armedUpgradeCityModelView then
    self.armedUpgradeCityModelView:SetActive(self.appearanceVisible)
  end
end

function LWArmedUpgradeManager:RemoveArmedUpgradeCityModelView()
  if self.armedUpgradeCityModelViewReq then
    self.armedUpgradeCityModelViewReq:Destroy()
    self.armedUpgradeCityModelViewReq = nil
  end
  if self.armedUpgradeCityModelView then
    self.armedUpgradeCityModelView:OnDestroy()
    self.armedUpgradeCityModelView = nil
  end
end

function LWArmedUpgradeManager:RefreshArmedUpgradeCityModelBubble()
  if self.armedUpgradeCityModelView then
    self.armedUpgradeCityModelView:RefreshModelBubbleShowState()
  end
end

function LWArmedUpgradeManager:AfterCloseArmedUpgradePanelExcuteLogic(isLevelUp)
  if CS.SceneManager:IsInCity() then
    local isMaxLevel = self:IsAchieveArmedUpgradeMaxLevel()
    if isMaxLevel then
      DataCenter.LWGuideFlowManager:TryTriggerFlexibly(5411)
    elseif self.armedUpgradeCityModelView then
      self.armedUpgradeCityModelView:AfterCloseArmedUpgradePanelExcuteLogic(isLevelUp)
    end
  end
end

function LWArmedUpgradeManager:JumpToArmedUpgradeCityModel(closeAllWindows)
  local isOpen = self:IsArmedUpgradeOpen()
  if not isOpen then
    UIUtil.ShowTipsId("new_armed_upgrade_tip_1")
    return
  end
  local modelPos = self:GetArmedUpgradeCityModelPos()
  if closeAllWindows then
    GoToUtil.CloseAllWindows()
  end
  SceneUtils.ChangeToCity(function()
    GoToUtil.GotoCityPos(modelPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      if self.delayOpenPanel == nil then
        self.delayOpenPanel = TimerManager:GetInstance():DelayInvoke(function()
          self:ClearDelay()
          if CS.SceneManager:IsInCity() then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArmedUpgradeMain)
          end
        end, 0.3)
      end
    end)
  end)
end

function LWArmedUpgradeManager:ClearDelay()
  if self.delayOpenPanel then
    self.delayOpenPanel:Stop()
    self.delayOpenPanel = nil
  end
end

function LWArmedUpgradeManager:PlayEndTimeline()
  if self.directorStopped == nil then
    function self.directorStopped(director)
      self:DestroyEndTimeline()
    end
  end
  self.endTimelineReq = Resource:InstantiateAsync(END_TIMELINE_PATH)
  self.endTimelineReq:completed("+", function(handle)
    if handle.isError then
      return
    end
    self.endDirector = handle.gameObject:GetComponent(typeof(PlayableDirector))
    self.endTimelineObj = handle.gameObject
    self.endDirector:stopped("+", self.directorStopped)
    self.endDirector:Play()
  end)
end

function LWArmedUpgradeManager:DestroyEndTimeline()
  if self.endDirector and self.directorStopped then
    self.endDirector:stopped("-", self.directorStopped)
  end
  if self.endTimelineReq then
    self.endTimelineReq:RealDestroy()
    self.endTimelineReq = nil
  end
  self.endTimelineObj = nil
  self.endDirector = nil
  self.directorStopped = nil
end

function LWArmedUpgradeManager:RefreshCityDirector()
  self:StopCityDirector()
  self.cityDirector = self:GetCityDirector(self.armedUpgradeLevel)
  if not self.cityDirector then
    return
  end
  if self.active and self.appearanceVisible then
    self.cityDirector:Start()
  end
end

function LWArmedUpgradeManager:StopCityDirector()
  if self.cityDirector then
    self.cityDirector:Stop()
    self.cityDirector = nil
  end
end

function LWArmedUpgradeManager:GetCityDirector(level)
  local cityDirector = self.cityDirectorMap[level]
  if cityDirector then
    return cityDirector
  end
  if level == 0 then
    cityDirector = LWArmedUpgradeZeroLevelCityDirector.New()
  elseif level == 1 then
    cityDirector = LWArmedUpgradeOneLevelCityDirector.New()
  elseif level == 2 then
    cityDirector = LWArmedUpgradeTwoLevelCityDirector.New()
  elseif level == 3 then
    cityDirector = LWArmedUpgradeThreeLevelCityDirector.New()
  elseif level == 4 then
    cityDirector = LWArmedUpgradeFourLevelCityDirector.New()
  end
  if self.cityDirectorMap then
    self.cityDirectorMap[level] = cityDirector
  end
  return cityDirector
end

function LWArmedUpgradeManager:TryGetJPMonicaTimelineResPath(oriResPath)
  if not LuaEntry.Player.JPUser then
    return oriResPath
  end
  if self.jpReplaceTimelineResMap == nil then
    self.jpReplaceTimelineResMap = {}
    local str = LuaEntry.DataConfig:TryGetStr("Monica_JP", "k8")
    if not string.IsNullOrEmpty(str) then
      local array = string.split(str, "|")
      if #array == 2 then
        self.jpReplaceTimelineResMap[array[1]] = array[2]
      end
    end
  end
  local targetResPath = self.jpReplaceTimelineResMap[oriResPath]
  if not string.IsNullOrEmpty(targetResPath) then
    return targetResPath
  end
  return oriResPath
end

function LWArmedUpgradeManager:TryGetJPMonopolyPawnBeforeResPath(oriResPath)
  if not LuaEntry.Player.JPUser then
    return oriResPath
  end
  if self.jpReplaceMonopolyPawnBeforeResMap == nil then
    self.jpReplaceMonopolyPawnBeforeResMap = {}
    local str = LuaEntry.DataConfig:TryGetStr("Monica_JP", "k9")
    if not string.IsNullOrEmpty(str) then
      local array = string.split(str, "|")
      for _, arr in ipairs(array) do
        local list = string.split(arr, ";")
        if #list == 2 then
          local oriRes = list[1] or ""
          local newRes = list[2] or ""
          if not string.IsNullOrEmpty(oriRes) and not string.IsNullOrEmpty(newRes) then
            self.jpReplaceMonopolyPawnBeforeResMap[oriRes] = newRes
          end
        end
      end
    end
  end
  local targetResPath = self.jpReplaceMonopolyPawnBeforeResMap[oriResPath]
  if not string.IsNullOrEmpty(targetResPath) then
    return targetResPath
  end
  return oriResPath
end

return LWArmedUpgradeManager
