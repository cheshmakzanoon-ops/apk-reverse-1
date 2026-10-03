local LWTrailTowerManager = BaseClass("LWTrailTowerManager")
local LWTrailTowerInfo = require("DataCenter.LWTrailTowerManager.LWTrailTowerInfo")

function LWTrailTowerManager:__init()
  self.trailTowerInfoDic = {}
  self.trailTowerFormationDic = {}
  self.curSelectTrailTowerId = 0
  self.curSelectTrailTowerDifficultyGroupId = 0
  self.jumpToTargetTrailTowerId = -1
  self.autoOpenTrailTowerPanelWhenBackToCity = false
  self.trailTowerId2AutoNextDic = {}
  self.showTrailTowerBubble = false
  self.isBattleSweep = false
  self.winNum = 0
  self.battleEndDisplayHeroDic = {}
  self.battleEndReward = {}
  self.battleIsWin = false
  self.cacheNeedShowBattleSweepResultStageId = -1
  self.battleSweepInterrupt = false
  self.content = nil
  self.contentsArr = nil
  EventManager:GetInstance():AddListener(EventId.GF_enter_city, self.OnEnterCity)
end

function LWTrailTowerManager:__delete()
  self.trailTowerInfoDic = nil
  self.trailTowerFormationDic = nil
  self.battleEndReward = nil
  self.battleEndDisplayHeroDic = nil
  self.battleIsWin = nil
  self.curSelectTrailTowerId = nil
  self.curSelectTrailTowerDifficultyGroupId = nil
  self.jumpToTargetTrailTowerId = nil
  self.autoOpenTrailTowerPanelWhenBackToCity = nil
  self.trailTowerId2AutoNextDic = nil
  self.showTrailTowerBubble = nil
  self.isBattleSweep = nil
  self.winNum = nil
  self.cacheNeedShowBattleSweepResultStageId = nil
  self.battleSweepInterrupt = nil
  self.content = nil
  self.contentsArr = nil
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_city, self.OnEnterCity)
end

function LWTrailTowerManager:Startup()
end

function LWTrailTowerManager:InitData(msg)
  local list = msg.towers
  if list ~= nil then
    for k, v in pairs(list) do
      local trailTowerInfo = LWTrailTowerInfo.New()
      trailTowerInfo:InitData(v)
      self.trailTowerInfoDic[trailTowerInfo.trailTowerId] = trailTowerInfo
      if trailTowerInfo.curGroup == 0 or trailTowerInfo:HasStageProgress() then
        self:SetDifficultyGroupChange(trailTowerInfo.trailTowerId, false)
      end
    end
  end
  self:RefreshShowTrailTowerBubbleData()
end

function LWTrailTowerManager:RefreshTrailTowerLevelData(message)
  if message.id then
    local trailTowerId = message.id
    local trailTowerInfo = self:GetTrailTowerInfoById(trailTowerId)
    if trailTowerInfo ~= nil then
      trailTowerInfo:RefreshGroupAndLv(message)
    end
  end
end

function LWTrailTowerManager:TrailTowerBattleDataGet(message, isSweep)
  self.isBattleSweep = isSweep
  if message.tower then
    local tower = message.tower
    if tower.id then
      local trailTowerId = tower.id
      local curGroup = tower.currGroup
      local trailTowerInfo = self:GetTrailTowerInfoById(trailTowerId)
      local difficultyGroupChange = curGroup > trailTowerInfo.curGroup
      self:SetDifficultyGroupChange(trailTowerId, difficultyGroupChange)
      trailTowerInfo:InitData(tower)
      self.battleEndDisplayHeroDic = {}
      for index, heroUuid in pairs(trailTowerInfo.heroInfosDic) do
        if not (index >= ArmyFormationSlot.Dominator) then
          local displayHeroData = {}
          displayHeroData.heroUuid = heroUuid
          self.battleEndDisplayHeroDic[heroUuid] = displayHeroData
        end
      end
      if message.lvUpHeroes then
        local lvUpHeroes = message.lvUpHeroes
        for k, heroUuid in ipairs(lvUpHeroes) do
          if self.battleEndDisplayHeroDic[heroUuid] ~= nil then
            self.battleEndDisplayHeroDic[heroUuid].lvUp = true
          end
        end
      end
    end
  end
  self.battleEndReward = {}
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    self.battleEndReward = message.reward
  end
  self.battleIsWin = false
  if message.isWin then
    self.battleIsWin = message.isWin
  end
  self.winNum = 0
  if message.winNum then
    self.winNum = message.winNum
  end
  if isSweep then
    self.contentsArr = nil
    self.content = nil
    if message.contentsArr then
      self.contentsArr = message.contentsArr
    end
    if message.content then
      self.content = message.content
    end
  end
end

function LWTrailTowerManager:SetAutoNextStage(trailTowerId, state)
  self.trailTowerId2AutoNextDic[trailTowerId] = state
end

function LWTrailTowerManager:IsAutoNextStage(trailTowerId)
  if self.trailTowerId2AutoNextDic[trailTowerId] == nil then
    return false
  end
  local result = self.trailTowerId2AutoNextDic[trailTowerId]
  return result
end

function LWTrailTowerManager:ClearAutoNextData(trailTowerId)
  if self.trailTowerId2AutoNextDic[trailTowerId] then
    self.trailTowerId2AutoNextDic[trailTowerId] = false
  end
end

function LWTrailTowerManager:SetDifficultyGroupChange(trailTowerId, state)
  if trailTowerId == TrailTowerType.Tank then
    CommonUtil.PlayerPrefsSetBool(SettingKeys.TRAIL_TOWER_TANK_DIFFICULTY_GROUP_CHANGE, state)
  elseif trailTowerId == TrailTowerType.AirPlane then
    CommonUtil.PlayerPrefsSetBool(SettingKeys.TRAIL_TOWER_AIRPLANE_DIFFICULTY_GROUP_CHANGE, state)
  else
    CommonUtil.PlayerPrefsSetBool(SettingKeys.TRAIL_TOWER_MISSILE_DIFFICULTY_GROUP_CHANGE, state)
  end
end

function LWTrailTowerManager:IsDifficultyGroupChange(trailTowerId)
  local result = false
  if trailTowerId == TrailTowerType.Tank then
    result = CommonUtil.PlayerPrefsGetBool(SettingKeys.TRAIL_TOWER_TANK_DIFFICULTY_GROUP_CHANGE, false)
  elseif trailTowerId == TrailTowerType.AirPlane then
    result = CommonUtil.PlayerPrefsGetBool(SettingKeys.TRAIL_TOWER_AIRPLANE_DIFFICULTY_GROUP_CHANGE, false)
  else
    result = CommonUtil.PlayerPrefsGetBool(SettingKeys.TRAIL_TOWER_MISSILE_DIFFICULTY_GROUP_CHANGE, false)
  end
  return result
end

function LWTrailTowerManager:OnEnterCity()
  local self = DataCenter.LWTrailTowerManager
  if self.autoOpenTrailTowerPanelWhenBackToCity then
    self.autoOpenTrailTowerPanelWhenBackToCity = false
    local difficultyGroupChange = self:IsDifficultyGroupChange(self.curSelectTrailTowerId)
    local trailTowerInfo = self:GetTrailTowerInfoById(self.curSelectTrailTowerId)
    if trailTowerInfo and trailTowerInfo:IsEnd() then
      Logger.LogInfo(string.format("\232\175\149\231\130\188\229\161\148ID\228\184\186: %s\231\154\132\230\140\145\230\136\152\229\145\168\230\156\159\229\183\178\231\187\143\231\187\147\230\157\159\239\188\140\232\183\179\232\189\172\229\136\176\228\184\187\231\149\140\233\157\162", self.curSelectTrailTowerId))
      return
    end
    local isFinish = trailTowerInfo ~= nil and trailTowerInfo.isFinish or false
    if self.isBattleSweep then
      self:OpenTrailTowerStagePanel(self.curSelectTrailTowerId, self.curSelectTrailTowerDifficultyGroupId, false, true)
      self.isBattleSweep = false
    elseif difficultyGroupChange or isFinish then
      self:SetJumpToTrailTowerIdData(self.curSelectTrailTowerId)
      self:OpenTrailTowerMainPanel(TrailTowerTabType.TrailTower)
    else
      self:OpenTrailTowerStagePanel(self.curSelectTrailTowerId, self.curSelectTrailTowerDifficultyGroupId, false, false)
    end
  end
end

function LWTrailTowerManager:SetJumpToTrailTowerIdData(jumpToTrailTowerId)
  self.jumpToTargetTrailTowerId = jumpToTrailTowerId
end

function LWTrailTowerManager:GetJumpToTrailTowerIdData()
  return self.jumpToTargetTrailTowerId
end

function LWTrailTowerManager:SetNeedShowBattleSweepResultStageId(targetStageId, isInterrupt)
  self.cacheNeedShowBattleSweepResultStageId = targetStageId
  self.battleSweepInterrupt = isInterrupt
end

function LWTrailTowerManager:OpenTrailTowerMainPanel(targetTabType, showGuide)
  if DataCenter.LWBattleManager:IsOpenReturnOpt() then
    local handler = TrailTowerContentHandler[targetTabType]
    local preLoadAssets = {}
    if handler and handler.assetPath then
      preLoadAssets = {
        [handler.assetPath] = true
      }
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrailTowerMain, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide,
      ultraHigh = true
    }, targetTabType, showGuide, preLoadAssets)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrailTowerMain, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, targetTabType, showGuide)
  end
end

function LWTrailTowerManager:OpenTrailTowerMainPanelWithScene(targetTabType, showGuide)
  local sceneManager = DataCenter.StageFeatureSceneManager
  if sceneManager:IsUseSceneMode() and not sceneManager:IsInScene() and sceneManager:IsSceneTab(targetTabType) then
    UIUtil.PlayCutSceneAnim(function()
      sceneManager:Enter(targetTabType, showGuide)
    end, function()
      return sceneManager:CheckLoadingState()
    end, nil, nil, nil, 2)
  else
    self:OpenTrailTowerMainPanel(targetTabType, showGuide)
  end
end

function LWTrailTowerManager:OpenTrailTowerStagePanel(trailTowerId, selectDifficultyGroup, clearDifficultyGroupChangeMark, isBattleSweep)
  self.curSelectTrailTowerId = trailTowerId
  self.curSelectTrailTowerDifficultyGroupId = selectDifficultyGroup
  local trailTowerInfo = self:GetTrailTowerInfoById(trailTowerId)
  if clearDifficultyGroupChangeMark and self:IsDifficultyGroupChange(trailTowerId) then
    self:SetDifficultyGroupChange(trailTowerInfo.trailTowerId, false)
    EventManager:GetInstance():Broadcast(EventId.RefreshTrailTowerDifficultyGroupNewMark)
  end
  if trailTowerInfo.curGroup <= 0 then
    SFSNetwork.SendMessage(MsgDefines.TrailTowerPickGroup, trailTowerId, selectDifficultyGroup)
  end
  local sweep = false
  if isBattleSweep then
    sweep = isBattleSweep
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrailTowerStage, {anim = true}, trailTowerId, selectDifficultyGroup, sweep)
end

function LWTrailTowerManager:ParseData(msg)
  if msg.trialTowerPop ~= nil then
    self.showTrailTowerBubble = msg.trialTowerPop
  end
end

function LWTrailTowerManager:RefreshShowTrailTowerBubbleData()
  local isOpenTrailTower = DataCenter.LWTrailTowerManager:TrailTowerEnoughBaseLevel()
  if isOpenTrailTower then
    local showBubble = false
    for i, trailTowerInfo in pairs(self.trailTowerInfoDic) do
      if not trailTowerInfo.isFinish and trailTowerInfo:IsOpen() and not trailTowerInfo:IsEnd() then
        local unlockCondition, conditionTips = DataCenter.LWTrailTowerTemplateManager:JudgeTrailTowerUnlockCondition(trailTowerInfo.trailTowerId)
        if unlockCondition then
          showBubble = true
          break
        end
      end
    end
    self.showTrailTowerBubble = showBubble
    EventManager:GetInstance():Broadcast(EventId.RefreshTrailTowerShowBubble)
  end
end

function LWTrailTowerManager:GetTrailTowerSwitchIsOpen()
  return LuaEntry.DataConfig:CheckSwitch("trialtower_open")
end

function LWTrailTowerManager:GetAllTrailTowerData()
  local trailTowerList = {}
  if self.trailTowerInfoDic ~= nil then
    for k, trailTowerInfo in pairs(self.trailTowerInfoDic) do
      table.insert(trailTowerList, trailTowerInfo)
    end
    return trailTowerList
  end
end

function LWTrailTowerManager:TrailTowerEnoughBaseLevel()
  for k, v in pairs(self.trailTowerInfoDic) do
    local trailTowerTemplate = DataCenter.LWTrailTowerTemplateManager:GetTrailTowerTemplateById(k)
    if trailTowerTemplate ~= nil and DataCenter.BuildManager.MainLv >= trailTowerTemplate.baseLevel then
      return true
    end
  end
  return false
end

function LWTrailTowerManager:GetTrailTowerInfoById(trailTowerId)
  if self.trailTowerInfoDic[trailTowerId] ~= nil then
    return self.trailTowerInfoDic[trailTowerId]
  end
  return nil
end

function LWTrailTowerManager:GetTrailTowerFormation(trailTowerId)
  local trailTowerInfo = self:GetTrailTowerInfoById(trailTowerId)
  if trailTowerInfo ~= nil then
    local heroMap = {}
    local heroTotalCount = 0
    if not table.IsNullOrEmpty(trailTowerInfo.heroInfosDic) then
      for index, heroUuid in pairs(trailTowerInfo.heroInfosDic) do
        if index == 6 or self:HeroIsCanUse(trailTowerId, heroUuid) then
          heroMap[index] = heroUuid
          if index <= ArmyFormationSlot.Dominator then
            heroTotalCount = heroTotalCount + 1
          end
        end
      end
    end
    if heroTotalCount < 5 then
      self:ReplenishFormation(trailTowerId, heroMap, heroTotalCount)
    end
    if self.trailTowerFormationDic[trailTowerId] == nil then
      local formation = ArenaArmyFormationInfo.New()
      formation:SetLocalHeroes(heroMap)
      self.trailTowerFormationDic[trailTowerId] = formation
    else
      self.trailTowerFormationDic[trailTowerId]:ClearLocalHeroes()
      self.trailTowerFormationDic[trailTowerId]:SetLocalHeroes(heroMap)
    end
    self.trailTowerFormationDic[trailTowerId]:SetLocalTWSkillChipSetId(trailTowerInfo.chipSetId)
    local maxLevelSoldier = DataCenter.SoldierDataManager:GetCanTrainHighestLevelSoldier()
    if maxLevelSoldier ~= nil then
      self.trailTowerFormationDic[trailTowerId]:SetHighestSolderData(maxLevelSoldier.id)
    end
    return self.trailTowerFormationDic[trailTowerId]
  end
  return nil
end

function LWTrailTowerManager:ReplenishFormation(targetTrailTowerId, heroMap, heroTotalCount)
  local heroList = {}
  local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
  for uuid, heroData in pairs(heroDataList) do
    if self:HeroIsCanUse(targetTrailTowerId, uuid) and not self:HasIncludeHero(heroMap, uuid) then
      table.insert(heroList, heroData)
    end
  end
  if 0 < #heroList then
    table.sort(heroList, function(a, b)
      return a.power > b.power
    end)
  end
  local listLen = #heroList
  if heroTotalCount < 5 then
    for i = 1, listLen do
      if heroList[i].meta.job == 1 then
        if not heroMap[1] then
          heroMap[1] = heroList[i].uuid
          heroList[i] = nil
          heroTotalCount = heroTotalCount + 1
        elseif not heroMap[2] then
          heroMap[2] = heroList[i].uuid
          heroList[i] = nil
          heroTotalCount = heroTotalCount + 1
        else
          break
        end
      end
    end
  end
  if heroTotalCount < 5 then
    for i = 1, listLen do
      if heroList[i] and heroTotalCount < 5 then
        for j = 1, 5 do
          if not heroMap[j] then
            heroMap[j] = heroList[i].uuid
            heroTotalCount = heroTotalCount + 1
            break
          end
        end
      end
      if 5 <= heroTotalCount then
        break
      end
    end
  end
end

function LWTrailTowerManager:HasIncludeHero(heroMap, heroUuid)
  for i, v in pairs(heroMap) do
    if v == heroUuid then
      return true
    end
  end
  return false
end

function LWTrailTowerManager:HeroIsCanUse(targetTrailTowerId, heroUuid)
  for trailTowerId, trailTowerInfo in pairs(self.trailTowerInfoDic) do
    if trailTowerId ~= targetTrailTowerId then
      local containsHero = trailTowerInfo:IsContainsHero(heroUuid)
      if containsHero then
        return false
      end
    end
  end
  return true
end

function LWTrailTowerManager:GetHeroBelongToTrailTower(targetTrailTowerId, heroUuid)
  for trailTowerId, trailTowerInfo in pairs(self.trailTowerInfoDic) do
    if trailTowerId ~= targetTrailTowerId then
      local containsHero = trailTowerInfo:IsContainsHero(heroUuid)
      if containsHero then
        return DataCenter.LWTrailTowerTemplateManager:GetTrailTowerTemplateById(trailTowerInfo.trailTowerId)
      end
    end
  end
  return nil
end

function LWTrailTowerManager:GetTrailTowerFormationTargetCampType()
  local tankTotalPower, missileTotalPower, aircraftTotalPower = 0, 0, 0
  local trailTowerInfo = self:GetTrailTowerInfoById(self.curSelectTrailTowerId)
  if trailTowerInfo ~= nil then
    for index, heroUuid in pairs(trailTowerInfo.heroInfosDic) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData then
        if heroData.heroType == HeroType.Tank then
          tankTotalPower = tankTotalPower + heroData.power
        elseif heroData.heroType == HeroType.Missile then
          missileTotalPower = missileTotalPower + heroData.power
        else
          aircraftTotalPower = aircraftTotalPower + heroData.power
        end
      end
    end
    local maxPower = math.max(tankTotalPower, missileTotalPower)
    maxPower = math.max(maxPower, aircraftTotalPower)
    if maxPower == tankTotalPower then
      return HeroType.Tank
    elseif maxPower == missileTotalPower then
      return HeroType.Missile
    else
      return HeroType.Aircraft
    end
  end
  return HeroType.Tank
end

function LWTrailTowerManager:ExitTrailTowerPlay()
  local curBattleType = DataCenter.LWBattleManager:GetCurBattleType()
  local curEnterType = DataCenter.LWBattleManager:GetPVEEnterType()
  if curBattleType == PVEType.FakePVP and curEnterType == PVEEnterType.TrailTower then
    DataCenter.LWBattleManager:Exit(function()
    end)
  end
end

function LWTrailTowerManager:GetTrailTowerShowBubbleData()
  return self.showTrailTowerBubble
end

function LWTrailTowerManager:ShowAlertTowerEntrance()
  return true
end

function LWTrailTowerManager:ShowCivilizationSparkEntrance()
  return DataCenter.LWCivilizationSparkExtend:UseCivilizationSparkGuide()
end

function LWTrailTowerManager:UpLvGetTrailTowerInfo()
  if self:ShowAlertTowerEntrance() and not self.showTrailTowerBubble and not DataCenter.LWTrailTowerManager:TrailTowerEnoughBaseLevel() and DataCenter.BuildManager.MainLv == self:GetCfgTrailTowerBaseLevel() then
    SFSNetwork.SendMessage(MsgDefines.TrailTowerInfo)
  end
end

function LWTrailTowerManager:GetCfgTrailTowerBaseLevel()
  if self.trailTowerBaseLevel == nil then
    LocalController:instance():visitTable(TableName.LW_Trail_Tower, function(id, lineData)
      if lineData ~= nil then
        local baselevel = lineData:getValue("baselevel")
        if self.trailTowerBaseLevel == nil then
          self.trailTowerBaseLevel = baselevel
        else
          self.trailTowerBaseLevel = math.min(self.trailTowerBaseLevel, baselevel)
        end
      end
    end)
  end
  return self.trailTowerBaseLevel
end

local ENTRANCE_CONFIG = {
  AlertTowerEntrance = {
    checkFunc = function()
      return DataCenter.LWTrailTowerManager:ShowAlertTowerEntrance()
    end,
    tabTypes = {
      TrailTowerTabType.TrailTower
    },
    titleKey = "801196"
  },
  CivilizationSparkEntrance = {
    checkFunc = function()
      return DataCenter.LWTrailTowerManager:ShowCivilizationSparkEntrance()
    end,
    tabTypes = {
      TrailTowerTabType.EasyStageFeatureChapter,
      TrailTowerTabType.StageFeatureChapter,
      TrailTowerTabType.IntegratedStageFeatureChapter
    },
    titleKey = "civilization_spark_building_name"
  }
}
local OPEN_CONFIG = {
  [TrailTowerTabType.TrailTower] = {
    checkFunc = function()
      return DataCenter.LWTrailTowerManager:GetTrailTowerSwitchIsOpen() and DataCenter.LWTrailTowerManager:TrailTowerEnoughBaseLevel() and not DataCenter.T11IdleGameManager:IsT11IdleGameFunctionOn()
    end,
    checkBubbleFunc = function()
      return DataCenter.LWTrailTowerManager:GetTrailTowerShowBubbleData()
    end
  },
  [TrailTowerTabType.Common] = {
    checkFunc = function()
      return DataCenter.LWCountStageManager:IsOpen()
    end,
    checkBubbleFunc = function()
      return not DataCenter.LWCountStageManager:IsAllDone() and DataCenter.LWCountStageManager:IsOpen()
    end
  },
  [TrailTowerTabType.StageFeatureChapter] = {
    checkFunc = function()
      local dependEasyStageFeatureComplete = not DataCenter.LWEasyStageFeatureChapterManager:IsOpen() or DataCenter.LWEasyStageFeatureChapterManager:IsAllDone()
      return dependEasyStageFeatureComplete and DataCenter.LWStageFeatureChapterManager:IsOpen()
    end,
    checkBubbleFunc = function()
      local dependEasyStageFeatureComplete = not DataCenter.LWEasyStageFeatureChapterManager:IsOpen() or DataCenter.LWEasyStageFeatureChapterManager:IsAllDone()
      return not DataCenter.LWStageFeatureChapterManager:IsAllDone() and DataCenter.LWStageFeatureChapterManager:IsOpen() and dependEasyStageFeatureComplete
    end
  },
  [TrailTowerTabType.EasyStageFeatureChapter] = {
    checkFunc = function()
      return DataCenter.LWEasyStageFeatureChapterManager:IsOpen()
    end,
    checkBubbleFunc = function()
      return not DataCenter.LWEasyStageFeatureChapterManager:IsAllDone() and DataCenter.LWEasyStageFeatureChapterManager:IsOpen()
    end
  },
  [TrailTowerTabType.IntegratedStageFeatureChapter] = {
    checkFunc = function()
      return DataCenter.LWIntegratedStageFeatureChapterManager:IsOpen()
    end,
    checkBubbleFunc = function()
      return not DataCenter.LWIntegratedStageFeatureChapterManager:IsAllDone() and DataCenter.LWIntegratedStageFeatureChapterManager:IsOpen()
    end
  }
}

function LWTrailTowerManager:GetEntranceByTabType(tabType)
  for entranceName, config in pairs(ENTRANCE_CONFIG) do
    for _, t in ipairs(config.tabTypes) do
      if t == tabType then
        return config
      end
    end
  end
  return nil
end

function LWTrailTowerManager:IsTabInEntrance(tabType, config)
  for _, t in ipairs(config.tabTypes) do
    if t == tabType then
      return true
    end
  end
  return false
end

function LWTrailTowerManager:CheckTabShowByTargetType(tabType, targetTabType)
  if targetTabType == nil then
    targetTabType = TrailTowerTabType.None
  end
  local targetEntrance = self:GetEntranceByTabType(targetTabType)
  if targetEntrance and targetEntrance.checkFunc() then
    return self:IsTabInEntrance(tabType, targetEntrance)
  end
  for entranceName, config in pairs(ENTRANCE_CONFIG) do
    if self:IsTabInEntrance(tabType, config) then
      return not config.checkFunc()
    end
  end
  return true
end

function LWTrailTowerManager:CheckTabOpenByTargetType(tabType, targetTabType)
  if targetTabType == nil then
    targetTabType = TrailTowerTabType.None
  end
  local open = OPEN_CONFIG[tabType].checkFunc()
  if open then
    return self:CheckTabShowByTargetType(tabType, targetTabType)
  end
  return false
end

function LWTrailTowerManager:CheckBubbleShowByTargetType(tabType, targetTabType)
  if targetTabType == nil then
    targetTabType = TrailTowerTabType.None
  end
  local show = OPEN_CONFIG[tabType].checkBubbleFunc()
  if show then
    return self:CheckTabShowByTargetType(tabType, targetTabType)
  end
  return false
end

function LWTrailTowerManager:CheckTabOpen(tabType)
  return OPEN_CONFIG[tabType].checkFunc()
end

return LWTrailTowerManager
