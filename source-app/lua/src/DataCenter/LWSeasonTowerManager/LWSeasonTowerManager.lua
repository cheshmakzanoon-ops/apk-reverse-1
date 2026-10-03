local LWSeasonTowerManager = BaseClass("LWSeasonTowerManager")
local LWSeasonTowerStage = require("DataCenter/LWSeasonTowerManager/LWSeasonTowerStage")
local LWSeasonTowerGroupTemplate = require("DataCenter/LWSeasonTowerManager/LWSeasonTowerGroupTemplate")
local AlertTowerSwitchInterval = 3
local Localization = CS.GameEntry.Localization
local OpenSweepNeedFloor = 3

function LWSeasonTowerManager:__init()
  self.startTime = 0
  self.endTime = 0
  self.group = 0
  self.score = 0
  self.scoreRewardList = {}
  self.effectIndex = -1
  self.lastRefreshTime = 0
  self.stageList = {}
  self.effectIndex = -1
  self.lastRefreshTime = 0
  self.groupTemplate = nil
  self.rankDataByStage = {}
  self.rankRewardShowList = nil
  self.selectStageIndex = 1
  self.formationList = {}
  self.isEntranceShow = false
  self.battleCardTotalLevel = 0
  self.seasonTowerEndTimer = nil
  self.showSeasonTower = false
  self.alertTowerSwitchTimer = 0
  self.alertTowerBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ALERTTOWER)
  self.lastAlertTowerBubbleType = AlertTowerBubbleType.None
  self.sweepBtnUnlock = false
  self.seasonTowerMaxTotalFloor = 0
end

function LWSeasonTowerManager:__delete()
  self:ClearEndTimer()
  self.startTime = 0
  self.endTime = 0
  self.group = 0
  self.score = 0
  self.scoreRewardList = {}
  self.effectIndex = -1
  self.lastRefreshTime = 0
  self.stageList = {}
  self.effectIndex = -1
  self.lastRefreshTime = 0
  self.groupTemplate = nil
  self.rankDataByStage = nil
  self.rankRewardShowList = nil
  self.selectStageIndex = 1
  self.formationList = {}
  self.isEntranceShow = false
  self.battleCardTotalLevel = 0
  self.seasonTowerEndTimer = nil
  self.showSeasonTower = nil
  self.alertTowerSwitchTimer = 0
  self.alertTowerBuild = nil
  self.lastAlertTowerBubbleType = nil
  self.sweepBtnUnlock = false
  self.seasonTowerMaxTotalFloor = 0
end

function LWSeasonTowerManager:InitData(msg)
  if msg.maxBattleCardTotalLevel then
    self.battleCardTotalLevel = msg.maxBattleCardTotalLevel
  end
  if msg.seasonTowerMaxTotalFloor then
    self.seasonTowerMaxTotalFloor = msg.seasonTowerMaxTotalFloor
  end
  self:RequestSeasonInfo()
end

function LWSeasonTowerManager:RequestSeasonInfo()
  SFSNetwork.SendMessage(MsgDefines.SeasonTowerInfo)
end

function LWSeasonTowerManager:OnSeasonTowerInfoResp(msg)
  if not (msg.startTime and msg.endTime and msg.group and msg.score) or not msg.stageList then
    self.isEntranceShow = false
    self.stageList = {}
    return
  end
  self.isEntranceShow = true
  self.startTime = msg.startTime or 0
  if self.endTime > 0 and msg.endTime and msg.endTime > self.endTime then
    self:CloseSeasonTower()
  end
  self.endTime = msg.endTime or 0
  self:SetEndTimer()
  self.group = msg.group or 0
  self.score = msg.score or 0
  if string.IsNullOrEmpty(msg.scoreRewardList) then
    self.scoreRewardList = {}
  else
    self.scoreRewardList = string.split(msg.scoreRewardList, ";")
  end
  self.effectIndex = msg.effectIndex or -1
  self.lastRefreshTime = msg.lastRefreshTime or 0
  local stageList = msg.stageList or {}
  self.stageList = {}
  for _, stage in ipairs(stageList) do
    local stageData = LWSeasonTowerStage.New()
    stageData:InitData(stage)
    table.insert(self.stageList, stageData)
  end
  table.sort(self.stageList, function(a, b)
    return a.stageId < b.stageId
  end)
  self.formationList = {}
  self.groupTemplate = LWSeasonTowerGroupTemplate.New()
  self.groupTemplate:InitData(self.group)
  self:RefreshSelectStageIndex()
  EventManager:GetInstance():Broadcast(EventId.SeasonTower_RefreshBubble)
  self.sweepBtnUnlock = self:IsShowSweepBtn()
end

function LWSeasonTowerManager:ClearEndTimer()
  if self.seasonTowerEndTimer then
    self.seasonTowerEndTimer:Stop()
    self.seasonTowerEndTimer = nil
  end
end

function LWSeasonTowerManager:SetEndTimer()
  self:ClearEndTimer()
  local time = self.endTime - UITimeManager:GetInstance():GetServerTime()
  if time < 0 then
    return
  end
  self.seasonTowerEndTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.stageList = {}
    self.isEntranceShow = false
    self:CloseSeasonTower()
  end, time / 1000)
end

function LWSeasonTowerManager:CloseSeasonTower()
  EventManager:GetInstance():Broadcast(EventId.SeasonTower_RefreshBubble)
  if DataCenter.LWSeasonTowerSceneManager.inSeasonTowerScene then
    GoToUtil.CloseAllWindows()
    DataCenter.LWSeasonTowerSceneManager:Exit()
  end
end

function LWSeasonTowerManager:OpenIntroduction()
  UIUtil.ShowInfoPop(Localization:GetString("t11_idle_game_title_76"), Localization:GetString("t11_idle_game_desc_77"))
end

function LWSeasonTowerManager:OpenRule()
  local param = {}
  param.activityRulesStr = Localization:GetString("season_tower_info")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function LWSeasonTowerManager:SaveFormation(stageId, curChipSetId, heroes)
  local param = {}
  param.stageId = stageId
  param.chipSetId = curChipSetId
  param.heroes = heroes
  SFSNetwork.SendMessage(MsgDefines.SeasonTowerSaveFormation, param)
end

function LWSeasonTowerManager:Battle(stageId, battleType, heroes)
  if not heroes then
    local formation = DataCenter.LWSeasonTowerManager:GetFormation(stageId)
    heroes = formation:GenerateServerHeroArray()
  end
  local param = {}
  param.stageId = stageId
  param.type = battleType
  param.heroes = heroes
  if battleType == SeasonTowerConfig.BattleType.Sweep then
    DataCenter.LWSeasonTowerSceneManager:ShowReadyEffect()
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonTowerBattle, param)
end

function LWSeasonTowerManager:UpdateServerRewardList(stageId, rewardListStr)
  if stageId == -1 then
    if string.IsNullOrEmpty(rewardListStr) then
      self.scoreRewardList = {}
    else
      self.scoreRewardList = string.split(rewardListStr, ";")
    end
  else
    local stageData = self:GetStageDataById(stageId)
    if stageData then
      stageData:SetStageRewardList(rewardListStr)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonTowerRewardRefresh)
end

function LWSeasonTowerManager:GetPreviewRewardList()
  return self.groupTemplate:GetPreviewRewardList()
end

function LWSeasonTowerManager:GetFirstStageOpenTime()
  local time
  for _, stage in ipairs(self.stageList) do
    if time then
      time = math.min(time, stage.openTime)
    else
      time = stage.openTime
    end
  end
  return time
end

function LWSeasonTowerManager:GetEndTime()
  return self.endTime
end

function LWSeasonTowerManager:EnterScene(midAction, action)
  if self:IsPreview() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonTowerPreview, {anim = true})
    return
  end
  UIUtil.PlayCutSceneAnim(function()
    if midAction then
      midAction()
    end
    DataCenter.LWSeasonTowerSceneManager:Enter(action)
  end, function()
    return DataCenter.LWSeasonTowerSceneManager:CheckLoadingState()
  end)
end

function LWSeasonTowerManager:OnAlertTowerBubbleClick(midAction, action)
  self:EnterScene(midAction, action)
end

function LWSeasonTowerManager:OnCityEntranceButtonClick(midAction, action)
  self:EnterScene(midAction, action)
end

local DEFAULT_SHOW_AREA_KEY = "DEFAULT_SHOW_AREA_KEY"

function LWSeasonTowerManager:GetDefaultShowAreaKey(stageId)
  return DEFAULT_SHOW_AREA_KEY .. "_" .. stageId
end

function LWSeasonTowerManager:IsDefaultShowArea(stageId)
  local count = 0
  for _, v in ipairs(self.stageList) do
    count = count + v.floor
  end
  if count <= OpenSweepNeedFloor then
    return false
  end
  local isShow = CommonUtil.PlayerPrefsGetBool(self:GetDefaultShowAreaKey(stageId), true)
  return isShow
end

function LWSeasonTowerManager:SetDefaultShowAreaState(stageId, state)
  CommonUtil.PlayerPrefsSetBool(self:GetDefaultShowAreaKey(stageId), state)
end

function LWSeasonTowerManager:GetSelectStageIndex()
  return self.selectStageIndex
end

function LWSeasonTowerManager:RefreshSelectStageIndex()
  local function compare(a, b)
    local aOpen = a:IsStageOpen()
    
    local bOpen = b:IsStageOpen()
    if aOpen ~= bOpen then
      return aOpen
    end
    local aUnChallenge = a:IsStageUnChallenge()
    local bUnChallenge = b:IsStageUnChallenge()
    if aUnChallenge ~= bUnChallenge then
      return aUnChallenge
    end
    local aFinish = a:IsStageFinish()
    local bFinish = b:IsStageFinish()
    if aFinish ~= bFinish then
      return not aFinish
    end
    if a.openTime ~= b.openTime then
      return a.openTime < b.openTime
    end
    return a.stageId > b.stageId
  end
  
  local bestIndex = 1
  local best = self.stageList[1]
  for i = 2, #self.stageList do
    if compare(self.stageList[i], best) then
      best = self.stageList[i]
      bestIndex = i
    end
  end
  self.selectStageIndex = bestIndex
end

function LWSeasonTowerManager:GetCurSelectStageData()
  return self.stageList[self:GetSelectStageIndex()]
end

function LWSeasonTowerManager:GetStageDataByIndex(index)
  return self.stageList[index]
end

function LWSeasonTowerManager:GetStageDataById(id)
  for _, v in ipairs(self.stageList) do
    if v.stageId == id then
      return v
    end
  end
end

function LWSeasonTowerManager:SetSelectStageIndex(selectStageIndex)
  if type(selectStageIndex) ~= "number" then
    return
  end
  if selectStageIndex < 1 or selectStageIndex > #self.stageList then
    return
  end
  self.selectStageIndex = selectStageIndex
end

function LWSeasonTowerManager:GetSelectStage()
  return self.stageList[self.selectStageIndex]
end

function LWSeasonTowerManager:HasAnyStageUnChallenge()
  local state = false
  for _, v in ipairs(self.stageList) do
    if v:IsStageUnChallenge() then
      state = true
      break
    end
  end
  return state
end

function LWSeasonTowerManager:HasAnyStageChallenged()
  for _, v in ipairs(self.stageList) do
    if not v:IsStageUnChallenge() then
      return true
    end
  end
  return false
end

function LWSeasonTowerManager:GetFormation(stageId)
  local stageData = self:GetStageDataById(stageId)
  if stageData == nil then
    return
  end
  if self.formationList[stageId] then
    return self.formationList[stageId]
  end
  local squadData = DeepCopy(DataCenter.ArmyFormationDataManager:GetFormationByType(EnterHeroSquadPanelWay.SeasonTower, 1))
  squadData:ParseData({
    heroes = stageData.heroes,
    chipEquipGroup = stageData.chipEquipGroup
  })
  self.formationList[stageId] = squadData
  return squadData
end

function LWSeasonTowerManager:HasAnyRewardToClaim()
  if self:HasRewardToClaim(-1) then
    return true
  end
  for i = 1, #self.stageList do
    if self:HasRewardToClaim(i) then
      return true
    end
  end
  return false
end

function LWSeasonTowerManager:GetGroupRewardSpecialItem()
  return self.groupTemplate.core_reward
end

function LWSeasonTowerManager:GetSpecialItemInfo()
  local current = 0
  local total = 0
  
  local function CalItemInfo(rewards)
    for _, v in ipairs(rewards) do
      local rewardList = DataCenter.RewardTemplateManager:GetList(v.template.rewardId) or {}
      local num = 0
      for _, reward in pairs(rewardList) do
        if tostring(reward.itemId) == tostring(self.groupTemplate.core_reward) then
          num = reward.count + num
        end
      end
      total = total + num
      if v.received == SeasonTowerConfig.RewardState.Received then
        current = current + num
      end
    end
  end
  
  CalItemInfo(DataCenter.LWSeasonTowerManager:GetGroupScoreRewards() or {})
  for i, _ in ipairs(self.stageList) do
    CalItemInfo(DataCenter.LWSeasonTowerManager:GetStageScoreRewards(i) or {})
  end
  return current, total
end

function LWSeasonTowerManager:HasRewardToClaim(stageIndex)
  local rewards = {}
  if stageIndex == -1 then
    rewards = DataCenter.LWSeasonTowerManager:GetGroupScoreRewards() or {}
  else
    rewards = DataCenter.LWSeasonTowerManager:GetStageScoreRewards(stageIndex) or {}
  end
  local hasReward = false
  for _, v in ipairs(rewards) do
    if v.received == SeasonTowerConfig.RewardState.CanReceive then
      hasReward = true
      break
    end
  end
  return hasReward
end

function LWSeasonTowerManager:GetGroupScoreRewards()
  local list = {}
  for i, v in ipairs(self.groupTemplate.scoreRewardList) do
    local data = {}
    data.template = v
    data.received = v.score <= self.score and SeasonTowerConfig.RewardState.CanReceive or SeasonTowerConfig.RewardState.NoComplete
    data.stageId = -1
    table.insert(list, data)
  end
  for _, v in pairs(self:GetServerRewardListByStageId(-1)) do
    local data = list[tonumber(v) + 1]
    if data then
      data.received = SeasonTowerConfig.RewardState.Received
    end
  end
  table.sort(list, function(a, b)
    if a.received == b.received then
      return a.template.score < b.template.score
    end
    return a.received < b.received
  end)
  return list
end

function LWSeasonTowerManager:GetStageScoreRewards(index)
  local stage = self.stageList[index]
  if stage == nil then
    return {}
  end
  local list = {}
  local map = {}
  for i, v in ipairs(stage:GetTemplate().stageReward) do
    local data = {}
    data.template = v
    data.received = v.floor <= stage.floor and SeasonTowerConfig.RewardState.CanReceive or SeasonTowerConfig.RewardState.NoComplete
    data.stageId = stage.stageId
    table.insert(list, data)
    map[tonumber(v.floor)] = data
  end
  for _, v in pairs(self:GetServerRewardListByStageId(stage.stageId)) do
    local data = map[tonumber(v)]
    if data then
      data.received = SeasonTowerConfig.RewardState.Received
    end
  end
  table.sort(list, function(a, b)
    if a.received == b.received then
      return a.template.floor < b.template.floor
    end
    return a.received < b.received
  end)
  return list
end

function LWSeasonTowerManager:ClaimReward(stageId)
  SFSNetwork.SendMessage(MsgDefines.SeasonTowerReward, {stageId = stageId})
end

function LWSeasonTowerManager:GetScore()
  return self.score
end

function LWSeasonTowerManager:GetServerRewardListByStageId(stageId)
  if stageId == -1 then
    return self.scoreRewardList
  end
  local stageData = self:GetStageDataById(stageId)
  if stageData == nil then
    return {}
  end
  return stageData:GetStageRewardList()
end

function LWSeasonTowerManager:ParseRankingData(message)
  if not message then
    return
  end
  local stageId = tonumber(message.stageId or -1) or -1
  local rankingInfo = self.rankDataByStage[stageId]
  if rankingInfo == nil then
    rankingInfo = {}
  end
  local playerRankingInfoMsg = message.self
  if playerRankingInfoMsg then
    local selfPlayerData = BasePlayerInfo.New()
    selfPlayerData:ParseData(playerRankingInfoMsg)
    selfPlayerData.score = playerRankingInfoMsg.score
    selfPlayerData.ranking = playerRankingInfoMsg.rank
    rankingInfo.selfRankData = selfPlayerData
  else
    rankingInfo.selfRankData = nil
  end
  rankingInfo.rankList = {}
  local rankingList = message.list
  if rankingList then
    for _, v in pairs(rankingList) do
      local playerData = BasePlayerInfo.New()
      playerData:ParseData(v)
      playerData.score = v.score
      playerData.ranking = v.rank
      table.insert(rankingInfo.rankList, playerData)
    end
  end
  self.rankDataByStage[stageId] = rankingInfo
  EventManager:GetInstance():Broadcast(EventId.SeasonTowerRankRefresh, stageId)
end

function LWSeasonTowerManager:GetRankData(stageId)
  return self.rankDataByStage[stageId or -1]
end

function LWSeasonTowerManager:GetRankRewardShowList(stageId)
  stageId = tonumber(stageId)
  if self.rankRewardShowList ~= nil then
    return self.rankRewardShowList[stageId]
  end
  local showList = {}
  LocalController:instance():visitTable(TableName.SEASON_TOWER_RANK_REWARD, function(_, rowData)
    local minRank = rowData:getValue("rank_low") or 0
    local maxRank = rowData:getValue("rank_high") or 0
    local reward = rowData:getValue("reward") or 0
    local rank_id = rowData:getValue("rank_id") or 0
    local title_reward = rowData:getValue("title_reward") or 0
    local rewards = DataCenter.RewardTemplateManager:GetList(reward) or {}
    if not showList[rank_id] then
      showList[rank_id] = {}
    end
    table.insert(showList[rank_id], {
      minRank = minRank,
      maxRank = maxRank,
      rewards = rewards,
      title_reward = title_reward
    })
  end)
  for _, list in pairs(showList) do
    table.sort(list, function(a, b)
      return (a.minRank or 0) < (b.minRank or 0)
    end)
  end
  self.rankRewardShowList = showList
  return self.rankRewardShowList[stageId]
end

function LWSeasonTowerManager:GetCurrentRankRewardShowList()
  return self:GetRankRewardShowList(self.groupTemplate and self.groupTemplate.rank_id or 60010)
end

function LWSeasonTowerManager:GetBgm()
  if self.groupTemplate == nil then
    return 0
  end
  return self.groupTemplate.season_tower_bgm
end

function LWSeasonTowerManager:PlaySound(soundId, loop)
  self.soundId = DataCenter.LWSoundManager:PlaySound(soundId, loop)
end

function LWSeasonTowerManager:PlayBgm()
  local soundId = self:GetBgm()
  DataCenter.LWSoundManager:PlaySound(soundId, false, true)
end

function LWSeasonTowerManager:IsShowSweepBtn()
  if self.seasonTowerMaxTotalFloor > 0 then
    return true
  end
  local count = 0
  for _, v in ipairs(self.stageList) do
    count = count + v.floor
  end
  return count >= OpenSweepNeedFloor
end

function LWSeasonTowerManager:CheckSweepBtnUnlock()
  local state = false
  if self.sweepBtnUnlock ~= self:IsShowSweepBtn() then
    self.sweepBtnUnlock = self:IsShowSweepBtn()
    state = true
  end
  return state
end

function LWSeasonTowerManager:IsUserBuffActive()
  if self.groupTemplate == nil then
    return false
  end
  return false
end

function LWSeasonTowerManager:IsAllBuffActive()
  if self.groupTemplate == nil then
    return false
  end
  return self.groupTemplate.all_buff == 1
end

function LWSeasonTowerManager:GetUserBuffIcon()
  if self.groupTemplate == nil then
    return ""
  end
  return self.groupTemplate.user_buff_icon
end

function LWSeasonTowerManager:GetAllBuffIcon()
  local stage = self:GetSelectStage()
  if stage == nil then
    return ""
  end
  local template = stage:GetTemplate()
  return template.all_buff_icon
end

function LWSeasonTowerManager:GetUserBuffInfo()
  return ""
end

function LWSeasonTowerManager:GetAllBuffInfo()
  local stage = self:GetSelectStage()
  if stage == nil then
    return ""
  end
  local template = stage:GetTemplate()
  return template.all_buff_info
end

function LWSeasonTowerManager:GetAllBuffInfoParam()
  local stage = self:GetSelectStage()
  if stage == nil then
    return {}
  end
  local template = stage:GetTemplate()
  return template.allBuffInfoNumList
end

function LWSeasonTowerManager:GetCardBuffs()
  if self.groupTemplate == nil then
    return {}
  end
  return self.groupTemplate.cardBuffs
end

function LWSeasonTowerManager:GetCardEffectPath()
  if self.groupTemplate == nil then
    return
  end
  local list = self.groupTemplate.cardBuffEffectPathList
  for i = #list, 1, -1 do
    local buff = list[i]
    if buff.start <= self.battleCardTotalLevel and buff.finish >= self.battleCardTotalLevel then
      return buff.path
    end
  end
end

local ENV_BUFF_SHOW_TIP_KEY = "ENV_BUFF_SHOW_TIP_KEY"

function LWSeasonTowerManager:GetEnvBuffTipKey(stageId)
  return ENV_BUFF_SHOW_TIP_KEY .. "_" .. stageId
end

function LWSeasonTowerManager:IsShowEnvBuffTip(stageId)
  local isShow = CommonUtil.PlayerPrefsGetBool(self:GetEnvBuffTipKey(stageId), true)
  return isShow
end

function LWSeasonTowerManager:SetEnvBuffShowState(stageId, state)
  CommonUtil.PlayerPrefsSetBool(self:GetEnvBuffTipKey(stageId), state)
end

function LWSeasonTowerManager:IsShowEntrance()
  if table.IsNullOrEmpty(self.stageList) and not self.isEntranceShow then
    return false
  end
  return true
end

function LWSeasonTowerManager:IsPreview()
  if not self:IsShowEntrance() then
    return false
  end
  for _, stage in ipairs(self.stageList) do
    if stage:IsStageOpen() then
      return false
    end
  end
  return true
end

function LWSeasonTowerManager:IsShowSeasonTowerBubble()
  return self:IsShowEntrance() or self:IsPreview()
end

function LWSeasonTowerManager:IsAlertTowerBubbleShowRed()
  if not self:IsShowEntrance() then
    return false
  end
  if self:IsPreview() then
    return false
  end
  return self:HasAnyRewardToClaim() or self:HasAnyStageUnChallenge()
end

function LWSeasonTowerManager:GetAlertTowerBaseBubbleType()
  local isT11IdleGameOn = DataCenter.T11IdleGameManager:IsT11IdleGameFunctionOn()
  if not isT11IdleGameOn then
    if DataCenter.LWTrailTowerManager:ShowAlertTowerEntrance() then
      return AlertTowerBubbleType.AlertTowerEntrance
    end
  elseif DataCenter.T11IdleGameManager:IsShowAlertTowerBubble() then
    return AlertTowerBubbleType.T11IdleGame
  end
  return AlertTowerBubbleType.None
end

function LWSeasonTowerManager:GetAlertTowerBubbleType()
  local baseType = self:GetAlertTowerBaseBubbleType()
  local showSeasonTower = DataCenter.LWSeasonTowerManager:IsShowSeasonTowerBubble()
  if not showSeasonTower then
    return baseType
  end
  local showTrailTowerBubble = DataCenter.LWTrailTowerManager:ShowAlertTowerEntrance() and DataCenter.LWTrailTowerManager:GetTrailTowerShowBubbleData() and not DataCenter.T11IdleGameManager:IsT11IdleGameFunctionOn()
  if baseType == AlertTowerBubbleType.AlertTowerEntrance and not showTrailTowerBubble then
    return AlertTowerBubbleType.SeasonTower
  end
  if baseType == AlertTowerBubbleType.T11IdleGame then
    local isShowSeasonTowerRed = self:IsAlertTowerBubbleShowRed()
    local isShowT11Red = DataCenter.T11IdleGameManager:IsAlertTowerBubbleShowRed()
    if isShowSeasonTowerRed == isShowT11Red then
      if self.showSeasonTower then
        return AlertTowerBubbleType.SeasonTower
      else
        return baseType
      end
    elseif isShowSeasonTowerRed then
      return AlertTowerBubbleType.SeasonTower
    elseif isShowT11Red then
      return AlertTowerBubbleType.T11IdleGame
    end
  elseif baseType == AlertTowerBubbleType.AlertTowerEntrance then
    local isShowSeasonTowerRed = self:IsAlertTowerBubbleShowRed()
    if isShowSeasonTowerRed then
      return AlertTowerBubbleType.SeasonTower
    elseif self.showSeasonTower then
      return AlertTowerBubbleType.SeasonTower
    else
      return baseType
    end
  else
    return AlertTowerBubbleType.SeasonTower
  end
end

function LWSeasonTowerManager:OnUpdateAlertTowerBubbleState()
  if self.alertTowerBuild == nil then
    self.alertTowerBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ALERTTOWER)
  end
  if self.alertTowerBuild == nil then
    return
  end
  local showSeasonTowerBubble = DataCenter.LWSeasonTowerManager:IsShowSeasonTowerBubble()
  if not showSeasonTowerBubble then
    if self.showSeasonTower and self.alertTowerBuild then
      self.showSeasonTower = false
      DataCenter.BuildBubbleManager:CheckShowBubble(self.alertTowerBuild.uuid)
    end
    return
  end
  self.alertTowerSwitchTimer = (self.alertTowerSwitchTimer or 0) + 1
  if self.alertTowerSwitchTimer >= AlertTowerSwitchInterval then
    self.alertTowerSwitchTimer = 0
    self.showSeasonTower = not self.showSeasonTower
  end
  local currentBubbleType = self:GetAlertTowerBubbleType()
  if self.lastAlertTowerBubbleType ~= currentBubbleType then
    self.lastAlertTowerBubbleType = currentBubbleType
    DataCenter.BuildBubbleManager:CheckShowBubble(self.alertTowerBuild.uuid)
  end
end

function LWSeasonTowerManager:GetCurrentGroupId()
  return self.group
end

return LWSeasonTowerManager
