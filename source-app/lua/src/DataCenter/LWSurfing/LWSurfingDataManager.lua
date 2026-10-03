local LWSurfingDataManager = BaseClass("LWSurfingDataManager", CEventable)
local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject

function LWSurfingDataManager:__init()
  self.activityId = nil
  self.coinNum = 0
  self.todayBoxNum = 0
  self.todayPersonalProgress = 0
  self.personalResetTime = 0
  self.highestScore = 0
  self.buffList = {}
  self.personalBattlePassList = {}
  self.inviteUsers = {}
  self.allianceProgress = 0
  self.mvpPlayerInfo = nil
  self.allianceBattlePassList = {}
  self.buffConfigList = {}
  self.dailyBoxMaxNum = nil
  self.boxConfigId = nil
  self.coinId = nil
  self.configHelpTimes = nil
  self.rankMap = {}
  self.rankRewardMap = {}
  self.helpTimes = 0
  self.round = 0
  self.roundRankType = 0
  self.roundStartTime = 0
  self.roundEndTime = 0
  self.isLogin = nil
  self.laterTime = nil
  self.displayInfo = nil
  self.restart = nil
  self.remainTimes = 0
  self:InitData()
  self:AddListeners()
end

function LWSurfingDataManager:__delete()
  self.activityId = nil
  self.coinNum = nil
  self.todayBoxNum = nil
  self.todayPersonalProgress = nil
  self.personalResetTime = nil
  self.highestScore = nil
  self.buffList = nil
  self.personalBattlePassList = nil
  self.inviteUsers = nil
  self.allianceBattlePassList = nil
  self.allianceProgress = nil
  self.mvpPlayerInfo = nil
  self.buffConfigList = nil
  self.dailyBoxMaxNum = nil
  self.boxConfigId = nil
  self.coinId = nil
  self.configHelpTimes = nil
  self.rankMap = nil
  self.rankRewardMap = nil
  self.helpTimes = nil
  self.round = nil
  self.roundRankType = nil
  self.roundStartTime = nil
  self.roundEndTime = nil
  self.isLogin = nil
  self.laterTime = nil
  self.displayInfo = nil
  self.remainTimes = nil
  self.restart = nil
  self.resultTipKey = nil
  self.battlePassScoreCache = nil
  self:Clear()
end

local function AddListeners(self)
end

local function RemoveListeners(self)
end

local function InitData(self)
end

local function Clear(self)
end

function LWSurfingDataManager:RefreshActivityInfoByRound(msg)
  self.round = msg.round
  self.rankRewardMap = {}
  SFSNetwork.SendMessage(MsgDefines.GetParkourMainInfo)
  self:SendGetParkourAllianceBattlePassInfoMessage(self.round)
  EventManager:GetInstance():Broadcast(EventId.SurfingRefreshActInfoByRound)
end

function LWSurfingDataManager:GetRound()
  return self.round
end

function LWSurfingDataManager:SendGetAllParkourInfosMessage(type, isLogin)
  SFSNetwork.SendMessage(MsgDefines.GetParkourMainInfo, type)
  self.isLogin = isLogin
end

function LWSurfingDataManager:SendGetParkourAllianceBattlePassInfoMessage(round)
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.GetParkourAllianceBattlePass, round)
  end
end

function LWSurfingDataManager:ReceiveRewardParkourBattlePassMessage(round, type, id)
  SFSNetwork.SendMessage(MsgDefines.ReceiveRewardParkourBattlePass, round, type, id)
end

function LWSurfingDataManager:SendUpgradeParkourBuffMessage(id)
  SFSNetwork.SendMessage(MsgDefines.UpgradeParkourBuff, id)
end

function LWSurfingDataManager:SendUnlockParkourBuffMessage(id)
  SFSNetwork.SendMessage(MsgDefines.UnlockParkourBuff, id)
end

function LWSurfingDataManager:GetParkourRankInfo(round, type, startNum, endNum)
  SFSNetwork.SendMessage(MsgDefines.GetParkourRankInfo, round, type, startNum, endNum)
end

function LWSurfingDataManager:GetParkourRankRewardInfo(round, type)
  SFSNetwork.SendMessage(MsgDefines.GetParkourRankRewardInfo, round, type)
end

function LWSurfingDataManager:SetActId(id)
  self.activityId = id
end

function LWSurfingDataManager:InitSurfingBattleData(message)
  if message.coin then
    self.coinNum = message.coin
  end
  if message.todayBox then
    self.todayBoxNum = message.todayBox
  end
  if message.todayProgress then
    self.todayPersonalProgress = message.todayProgress
  end
  if message.tomorrow then
    self.personalResetTime = message.tomorrow
  end
  if message.highestScore then
    self.highestScore = message.highestScore
  end
  if message.buffList then
    self.buffList = message.buffList
    self:UpdateBuffDetailInfo()
  end
  if message.battlePassList then
    self.personalBattlePassList = message.battlePassList
  end
  self.inviteUsers = message.inviteUsers
  self.mvpPlayerInfo = message.mvp
  self.helpTimes = message.helpTimes
  self.round = message.round
  self.roundRankType = message.rankType
  self.roundStartTime = message.roundStart
  self.roundEndTime = message.roundEnd
  self.remainTimes = message.remainTimes
  self.guideReward = message.guideReward
  if self.isLogin then
    self.isLogin = nil
    self:SendGetParkourAllianceBattlePassInfoMessage(self.round)
  end
  EventManager:GetInstance():Broadcast(EventId.SurfingActMainUIRefresh)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LWSurfingDataManager:GetRemainTimes()
  return self.remainTimes
end

function LWSurfingDataManager:UpdateAllianceBattleInfo(message)
  if message.allianceProgress then
    self.allianceProgress = message.allianceProgress
  end
  if message.list then
    self.allianceBattlePassList.list = message.list
    self.allianceBattlePassList.round = message.round
  end
  self.mvpPlayerInfo = message.mvp
  EventManager:GetInstance():Broadcast(EventId.SurfingUpdateMvpInfo)
  EventManager:GetInstance():Broadcast(EventId.SurfingUpdateAllianceBattlePass)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LWSurfingDataManager:UpdateAllianceBattleList(message)
  if message.type == SurfingBattlePassType.Personal then
    if message.list then
      self.personalBattlePassList = message.list
    end
    EventManager:GetInstance():Broadcast(EventId.SurfingUpdatePersonalBattlePass)
  elseif message.type == SurfingBattlePassType.Alliance then
    if message.list then
      self.allianceBattlePassList.list = message.list
      self.allianceBattlePassList.round = message.round
    end
    EventManager:GetInstance():Broadcast(EventId.SurfingUpdateAllianceBattlePass)
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
end

function LWSurfingDataManager:UpdateBuffSkill(msg)
  if self.buffList and #self.buffList > 0 then
    if msg.coin then
      self.coinNum = msg.coin
      EventManager:GetInstance():Broadcast(EventId.SurfingCoinNumRefresh)
    end
    if msg.id and msg.newId then
      local param = {
        id = msg.id,
        newId = msg.newId
      }
      for _, v in pairs(self.buffList) do
        if v.id == param.id then
          v.id = param.newId
          EventManager:GetInstance():Broadcast(EventId.SurfingLevelUpBuffSkillInfo, param)
          break
        end
      end
    end
  end
end

function LWSurfingDataManager:UnlockBuffSkill(msg)
  if self.buffList and #self.buffList > 0 and msg.id then
    for _, v in pairs(self.buffList) do
      if v.id == msg.id and v.unlockTime then
        v.unlockTime = nil
        EventManager:GetInstance():Broadcast(EventId.SurfingUnlockBuffSkillInfo, msg.id)
        return
      end
    end
  end
end

function LWSurfingDataManager:UpdateSurfingBattleRankInfo(msg)
  local type = msg.type
  if type then
    self.rankMap[type] = {
      selfRank = msg.self,
      rankList = msg.ranks or {},
      round = msg.round,
      start = msg.start,
      endNum = msg["end"]
    }
    EventManager:GetInstance():Broadcast(EventId.SurfingRefreshRankInfo, type)
  end
end

function LWSurfingDataManager:UpdateSurfingBattleRankRewardInfo(msg)
  local type = msg.type
  if type then
    self.rankRewardMap[type] = msg.rewards
    self.rankRewardMap[type].round = msg.round
    EventManager:GetInstance():Broadcast(EventId.SurfingRefreshRewardInfo, type)
  end
end

function LWSurfingDataManager:GetBuffDetailInfo(buffId)
  if self.buffConfigList == nil then
    self.buffConfigList = {}
  end
  if self.buffConfigList[buffId] then
    return self.buffConfigList[buffId]
  else
    self.buffConfigList[buffId] = DataCenter.LWSurfingBuffTemplateManager:GetTemplate(buffId)
    return self.buffConfigList[buffId]
  end
  return nil
end

function LWSurfingDataManager:UpdateBuffDetailInfo()
  if self.buffConfigList == nil then
    self.buffConfigList = {}
  end
  if self.buffList and #self.buffList > 0 then
    for _, v in pairs(self.buffList) do
      if self.buffConfigList[v.id] then
        v.type = self.buffConfigList[v.id].type
        v.view = self.buffConfigList[v.id].cultivated == 0
      else
        self:GetBuffDetailInfo(v.id)
        v.type = self.buffConfigList[v.id].type
        v.view = self.buffConfigList[v.id].cultivated == 0
      end
    end
  end
end

function LWSurfingDataManager:GetCurrentBuffTemplateByType(type)
  if self.buffList and #self.buffList > 0 then
    for _, v in pairs(self.buffList) do
      if v.type == type and v.unlockTime == nil then
        return self:GetBuffDetailInfo(v.id)
      end
    end
  end
  return nil
end

function LWSurfingDataManager:GetCurrentBuffTemplateByTypeWithoutLock(type)
  if self.buffList and #self.buffList > 0 then
    for _, v in pairs(self.buffList) do
      if v.type == type then
        return self:GetBuffDetailInfo(v.id)
      end
    end
  end
  return nil
end

function LWSurfingDataManager:GetSurfingBuffData()
  if self.buffList and #self.buffList > 0 then
    return self.buffList
  end
  return nil
end

function LWSurfingDataManager:GetSurfingCultivatedBuffData()
  if not self.buffList or #self.buffList == 0 then
    return nil
  end
  local result = {}
  for _, buff in ipairs(self.buffList) do
    if buff.view ~= false then
      table.insert(result, buff)
    end
  end
  return self:MoveUnlockToTail(result)
end

function LWSurfingDataManager:MoveUnlockToTail(buffList)
  if not buffList or #buffList == 0 then
    return buffList
  end
  local front, tail = {}, {}
  for i, buff in ipairs(buffList) do
    if buff.unlockTime == nil then
      front[#front + 1] = buff
    else
      tail[#tail + 1] = buff
    end
  end
  for i = 1, #tail do
    front[#front + 1] = tail[i]
  end
  return front
end

function LWSurfingDataManager:GetBuffIdByBuffType(type, level)
  if self.buffIdDic == nil then
    self:InitBuffIdDic()
  end
  if self.buffIdDic[type] then
    return self.buffIdDic[type][level]
  end
end

function LWSurfingDataManager:InitBuffIdDic()
  local dic = {}
  LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.lw_parkour_buff), function(id, line)
    if line ~= nil then
      local type = line.type
      if dic[type] == nil then
        dic[type] = {
          [line.level] = line.buff_id
        }
      else
        dic[type][line.level] = line.buff_id
      end
    end
  end)
  self.buffIdDic = dic
end

local function GetResurgenceLimit(self)
  local skillInfo = self:GetCurrentBuffTemplateByType(SurfingBuffSkillType.Resurrection)
  if skillInfo and skillInfo.para1 then
    local count = skillInfo.para1
    return tonumber(count)
  end
  return 0
end

local function GetResurgenceCost(self, times)
  local skillInfo = self:GetCurrentBuffTemplateByType(SurfingBuffSkillType.Resurrection)
  if skillInfo and skillInfo.para2 and times <= #skillInfo.para2 then
    local cost = skillInfo.para2[times]
    return cost
  end
  return 0
end

function LWSurfingDataManager:GetAllianceHelpParam()
  local skillInfo = self:GetCurrentBuffTemplateByType(SurfingBuffSkillType.AllianceHelp)
  if skillInfo and skillInfo.para2 and #skillInfo.para2 >= 1 then
    return skillInfo.para2[1], tonumber(skillInfo.para1)
  end
  return 0, 0
end

function LWSurfingDataManager:GetTheBattleEndTime()
  return self.roundEndTime
end

function LWSurfingDataManager:GetSelectRoundRankType()
  return self.roundRankType
end

function LWSurfingDataManager:GetRankRewardInfos(type)
  if self.rankRewardMap and self.rankRewardMap[type] then
    return self.rankRewardMap[type]
  end
  return nil
end

function LWSurfingDataManager:GetTodayHelpTimes()
  return self.helpTimes
end

function LWSurfingDataManager:GetActId()
  return self.activityId
end

function LWSurfingDataManager:GetSurfingRankInfo(type)
  return self.rankMap[type]
end

function LWSurfingDataManager:GetAllianceBattleEndTime()
  return self.roundEndTime
end

function LWSurfingDataManager:GetAllianceScore()
  return self.allianceProgress
end

function LWSurfingDataManager:GetPersonalHightestScoreData()
  return self.highestScore
end

function LWSurfingDataManager:GetCoinNum()
  return self.coinNum
end

function LWSurfingDataManager:GetMvpPlayer()
  return self.mvpPlayerInfo
end

function LWSurfingDataManager:GetPersonalBattlePassList()
  if self.personalBattlePassList and #self.personalBattlePassList > 0 then
    return self.personalBattlePassList
  end
  return nil
end

function LWSurfingDataManager:GetTodayPersonalProgressScore()
  return self.todayPersonalProgress
end

function LWSurfingDataManager:GetBuffRedPoint()
  if self.buffConfigList then
    for _, v in pairs(self.buffConfigList) do
      if not string.IsNullOrEmpty(v.cost) and tonumber(v.cost) <= self.coinNum then
        return true
      end
    end
  end
  return false
end

function LWSurfingDataManager:GetRedCount(actId)
  local rewardNum = 0
  if self.allianceBattlePassList and self.allianceBattlePassList.list and 0 < #self.allianceBattlePassList.list then
    for _, value in pairs(self.allianceBattlePassList.list) do
      if value.state == TaskState.CanReceive then
        rewardNum = rewardNum + 1
      end
    end
  end
  if self.personalBattlePassList and 0 < #self.personalBattlePassList then
    for _, value in pairs(self.personalBattlePassList) do
      if value.state == TaskState.CanReceive then
        rewardNum = rewardNum + 1
      end
    end
  end
  if self:IsShowDigGameEntry() then
    local digGameRedNum = DataCenter.OffSeasonDiggingDataManager:GetRedCount()
    rewardNum = rewardNum + digGameRedNum
  end
  return rewardNum
end

function LWSurfingDataManager:GetAllianceBattlePassRedPointInfo()
  if self.allianceBattlePassList and self.allianceBattlePassList.list and #self.allianceBattlePassList.list > 0 then
    for _, value in pairs(self.allianceBattlePassList.list) do
      if value.state == TaskState.CanReceive then
        return true
      end
    end
  end
  return false
end

function LWSurfingDataManager:GetAllianceBattlePassInfo()
  if self.allianceBattlePassList and self.allianceBattlePassList.list and #self.allianceBattlePassList.list > 0 then
    return self.allianceBattlePassList.list
  end
  return nil
end

function LWSurfingDataManager:GetBattlePassScoreById(id)
  if not self.battlePassScoreCache then
    self.battlePassScoreCache = {}
  end
  local score = self.battlePassScoreCache[id]
  if score == nil then
    score = GetTableData(TableName.lw_parkour_battle_pass, id, "score")
    self.battlePassScoreCache[id] = score
  end
  return score
end

function LWSurfingDataManager:GetAllianceBattlePassRound()
  if self.allianceBattlePassList and self.allianceBattlePassList.round then
    return self.allianceBattlePassList.round
  end
  return nil
end

function LWSurfingDataManager:GetDelayTime()
  if self.laterTime == nil then
    self.laterTime = LuaEntry.DataConfig:TryGetNum("surfing_config", "k9", "")
    self.laterTime = self.laterTime * 3600000
  end
  return self.laterTime
end

function LWSurfingDataManager:ReadConfigToBoxInfo()
  local str = LuaEntry.DataConfig:TryGetStr("surfing_config", "k1", "")
  local num = LuaEntry.DataConfig:TryGetNum("surfing_config", "k8", 0)
  self.boxConfigId = str
  self.dailyBoxMaxNum = num
end

function LWSurfingDataManager:GetDailyBoxNum()
  local max = 0
  if self.dailyBoxMaxNum then
    max = self.dailyBoxMaxNum
  else
    self:ReadConfigToBoxInfo()
    max = self.dailyBoxMaxNum
  end
  return self.todayBoxNum, max
end

function LWSurfingDataManager:CheckBoxOpen(id)
  if tostring(id) == self.boxConfigId then
    return self.dailyBoxMaxNum > 0
  end
  return true
end

function LWSurfingDataManager:GetDailyBoxId()
  if self.boxConfigId then
    return self.boxConfigId
  else
    self:ReadConfigToBoxInfo()
    return self.boxConfigId
  end
  return nil
end

function LWSurfingDataManager:GetCoinId()
  if self.coinId then
    return self.coinId
  else
    self.coinId = LuaEntry.DataConfig:TryGetNum("surfing_config", "k3", 0)
    return self.coinId
  end
end

function LWSurfingDataManager:GetHelpTimes()
  if self.configHelpTimes == nil then
    self.configHelpTimes = LuaEntry.DataConfig:TryGetNum("surfing_config", "k4", 3)
  end
  if self.configHelpTimes > 10 then
    self.configHelpTimes = 5
  end
  return self.configHelpTimes
end

function LWSurfingDataManager:GetInvitePlayers()
  if self.inviteUsers and #self.inviteUsers > 0 then
    return self.inviteUsers
  end
  return nil
end

function LWSurfingDataManager:GetStartMsgCD()
  if self.startMsgCD == nil then
    self.startMsgCD = LuaEntry.DataConfig:TryGetNum("surfing_config", "k12") or 0
  end
  return self.startMsgCD * 1000
end

function LWSurfingDataManager:ShowInteractionPanel(playerInfo)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISurfingInteraction) then
    EventManager:GetInstance():Broadcast(EventId.SurfingGotAllyBuff, playerInfo)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISurfingInteraction, {anim = false}, playerInfo)
  end
end

function LWSurfingDataManager:GetMainUIDisplayInfo(actId, round)
  if self.displayInfo and round <= #self.displayInfo then
    return self.displayInfo[round]
  else
    self.displayInfo = {}
    local iconsStr = LocalController:instance():getValue(TableName.Activity, actId, "para_4")
    local subTitleStr = LocalController:instance():getValue(TableName.Activity, actId, "para_5")
    local rankStr = LocalController:instance():getValue(TableName.Activity, actId, "para_6")
    if not string.IsNullOrEmpty(iconsStr) then
      local iconsSplit = string.split(iconsStr, "|")
      for k, v in pairs(iconsSplit) do
        if self.displayInfo[k] then
          self.displayInfo[k].icon = v
        else
          self.displayInfo[k] = {}
          self.displayInfo[k].icon = v
        end
      end
    end
    if not string.IsNullOrEmpty(subTitleStr) then
      local subTitleSplit = string.split(subTitleStr, "|")
      for k, v in pairs(subTitleSplit) do
        if self.displayInfo[k] then
          self.displayInfo[k].subTitle = v
        else
          self.displayInfo[k] = {}
          self.displayInfo[k].subTitle = v
        end
      end
    end
    if not string.IsNullOrEmpty(rankStr) then
      local rankSplit = string.split(rankStr, "|")
      for k, v in pairs(rankSplit) do
        if self.displayInfo[k] then
          self.displayInfo[k].rankTitle = v
        else
          self.displayInfo[k] = {}
          self.displayInfo[k].rankTitle = v
        end
      end
    end
    return self.displayInfo[round]
  end
end

function LWSurfingDataManager:FightStartCheck(message)
  if message == nil then
    return
  end
  if self:CheckStageVersion(message.stageId, message.version) then
    self:ReqStartGame()
  end
end

function LWSurfingDataManager:CheckStageVersion(stageId, version)
  if stageId == nil then
    return false
  end
  local stageMeta = DataCenter.SurfingStageTemplateManager:GetTemplate(stageId)
  if stageMeta then
    local ver = stageMeta.version
    if ver ~= version then
      local param = {
        contentText = CS.GameEntry.Localization:GetString("parkour_activity_data_exception"),
        btnNum = 2,
        showToggle = false,
        confirmBtnParam = {
          action = function()
            CS.ApplicationLaunch.Instance:ReloadGame()
          end
        }
      }
      UIUtil.ShowConfirmNew(param)
      return false
    end
  end
  return true
end

function LWSurfingDataManager:OnStartGame(message)
  if message == nil then
    return
  end
  self.remainTimes = message.remainTimes
  local stageId = message.stageId
  local uuid = message.uuid
  if stageId and 0 < stageId then
    local param = {}
    param.type = PVEType.Surfing
    param.levelId = stageId
    param.uuid = uuid
    param.ids = message.ids
    param.inviteUsers = message.inviteUsers
    if message.restart then
      DataCenter.LWBattleManager:RestartParam(param)
    else
      DataCenter.LWBattleManager:Enter(param)
    end
  else
    Logger.LogError("stage id is nil")
  end
  PostEventLog.Track(PostEventLog.Defines.SURFING_GAMING_ON_START, {
    uuid = tostring(uuid)
  })
end

function LWSurfingDataManager:ReqFightStartCheck(restart)
  if DataCenter.ActWinterStormManager:CheckInMatchingViewState() then
    return
  end
  local curTs = UITimeManager:GetInstance():GetServerTime()
  if self.startMsgTs == nil then
    self.startMsgTs = curTs
  elseif curTs - self.startMsgTs <= self:GetStartMsgCD() then
    UIUtil.ShowTipsId("avatar_tips002")
    return
  end
  self.startMsgTs = curTs
  self.restart = restart
  SFSNetwork.SendMessage(MsgDefines.ParkourFightStartCheck)
end

function LWSurfingDataManager:ReqStartGame()
  local restart = self.restart
  self.restart = nil
  SFSNetwork.SendMessage(MsgDefines.ParkourFightStart, restart)
end

function LWSurfingDataManager:ReqEndGame(uuid, index, id, distance, score, box, inviteUsers, totalRunTime)
  if string.IsNullOrEmpty(uuid) then
    return false
  end
  local newInviteUsers = SFSArray.New()
  if inviteUsers then
    for i, v in pairs(inviteUsers) do
      local obj = SFSObject.New()
      obj:PutUtfString("uid", i)
      obj:PutInt("helpNum", v)
      newInviteUsers:AddSFSObject(obj)
    end
  end
  local param = {
    uuid = uuid,
    index = index,
    id = id,
    distance = distance,
    score = score,
    box = box,
    inviteUsers = newInviteUsers,
    totalRunTime = totalRunTime
  }
  SFSNetwork.SendMessage(MsgDefines.ParkourFightEnd, param)
  return true
end

function LWSurfingDataManager:ReqEndStage(uuid, index, id, distance, score, box, inviteUsers)
  if string.IsNullOrEmpty(uuid) then
    return
  end
  local newInviteUsers = SFSArray.New()
  if inviteUsers then
    for i, v in pairs(inviteUsers) do
      local obj = SFSObject.New()
      obj:PutUtfString("uid", i)
      obj:PutInt("helpNum", v)
      newInviteUsers:AddSFSObject(obj)
    end
  end
  SFSNetwork.SendMessage(MsgDefines.ParkourStageEnd, {
    uuid = uuid,
    index = index,
    id = id,
    distance = distance,
    score = score,
    box = box,
    inviteUsers = newInviteUsers
  })
end

function LWSurfingDataManager:ReqRebirthGame(uuid, distance, coin, box, times, curIndex)
  if string.IsNullOrEmpty(uuid) then
    return false
  end
  local param = {
    uuid = uuid,
    distance = distance,
    coin = coin,
    box = box,
    times = times,
    curIndex = curIndex
  }
  SFSNetwork.SendMessage(MsgDefines.ParkourFightRebirth, param)
  return true
end

function LWSurfingDataManager:ReqGetFollowupIds(uuid)
  if string.IsNullOrEmpty(uuid) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ParkourStageContinue, uuid)
end

function LWSurfingDataManager:ReqRebirthInfo(uuid, coin, distance)
  if string.IsNullOrEmpty(uuid) then
    return false
  end
  SFSNetwork.SendMessage(MsgDefines.ParkourRebirthInfo, uuid, coin, distance)
  return true
end

function LWSurfingDataManager:ReqMonsterCheck(uuid, distance, totalRunTime, totalStopTime, monsterBorn, metaMonsterId, monsterId)
  if string.IsNullOrEmpty(uuid) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ParkourStageMonsterCheck, distance, totalRunTime, totalStopTime, monsterBorn, metaMonsterId, monsterId, uuid)
end

function LWSurfingDataManager:ReqTimeCheck(uuid, distance, totalRunTime, totalStopTime)
  if string.IsNullOrEmpty(uuid) then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ParkourStageTimeCheck, distance, totalRunTime, totalStopTime, uuid)
end

function LWSurfingDataManager:GetIsFirstEnterGame()
  return CS.GameEntry.Setting:GetBool(SettingKeys.SURFING_ON_FIRST_ENTER_GAME_NEW, true)
end

function LWSurfingDataManager:SetIsFirstEnterGame()
  CS.GameEntry.Setting:SetBool(SettingKeys.SURFING_ON_FIRST_ENTER_GAME_NEW, false)
end

function LWSurfingDataManager:GoBackToActivityPanel()
  if self.activityId then
    DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.Surfing)
    local preLoadAssets = {
      [UIAssets.ActivityTabGroupItem] = true,
      [UIAssets.UIActivityListItem] = true,
      [UIAssets.UISurfingBattleActMain] = true
    }
    GoToUtil.GotoOpenView_BattleReturnOpt(UIWindowNames.UIActivityCenterTable, preLoadAssets, self.activityId, preLoadAssets)
  end
  DataCenter.LWBattleManager:Exit()
end

function LWSurfingDataManager:GetNowSelectBoxSliderValue(index)
  local maxNum = self:GetBattlePassScoreById(self.personalBattlePassList[index].id)
  if maxNum < self.todayPersonalProgress then
    return 1
  else
    local lastNum = 0
    if 1 < index then
      lastNum = self:GetBattlePassScoreById(self.personalBattlePassList[index - 1].id)
    end
    local singleProgress = self.todayPersonalProgress - lastNum
    return singleProgress / maxNum
  end
  return 0
end

function LWSurfingDataManager:ReqGuideReward()
  SFSNetwork.SendMessage(MsgDefines.ParkourActivityGuideReward)
  DataCenter.LWSurfingDataManager:SetGuideReward()
end

function LWSurfingDataManager:SetGuideReward()
  if not self.activityId then
    return
  end
  self.guideReward = true
end

function LWSurfingDataManager:IsGuideReward()
  return self.guideReward
end

function LWSurfingDataManager:GetResultTipKey()
  if self.resultTipKey == nil then
    self.resultTipKey = StringPool.New("parkour_loading_rule_9;parkour_loading_rule_10;parkour_loading_rule_11;parkour_loading_rule_12;parkour_loading_rule_13", ";")
  end
  return self.resultTipKey:GetRandom()
end

function LWSurfingDataManager:GetPlaybackSwitchOn()
  if self.playbackSW == nil then
    self.playbackSW = LuaEntry.DataConfig:CheckSwitch("parkour_playback")
  end
  return self.playbackSW
end

function LWSurfingDataManager:CheckTodayFirstEnterAct()
  if DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.SURFING_FIRST_ENTER_ACTIVITY) then
    local path = CS.UnityEngine.Application.persistentDataPath .. SURFING_DOWNLOAD_LOG_PATH
    CS.FileUtils.DeleteDirectoryIfExists(path)
    DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.SURFING_FIRST_ENTER_ACTIVITY, false)
  end
end

function LWSurfingDataManager:IsShowDigGameEntry()
  local activityId = self:GetActId()
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if not activityInfo then
    return false
  end
  if not string.IsNullOrEmpty(activityInfo.para_7) and tonumber(activityInfo.para_7) == 1 then
    return false
  end
  return true
end

LWSurfingDataManager.AddListeners = AddListeners
LWSurfingDataManager.InitData = InitData
LWSurfingDataManager.Clear = Clear
LWSurfingDataManager.GetResurgenceLimit = GetResurgenceLimit
LWSurfingDataManager.GetResurgenceCost = GetResurgenceCost
return LWSurfingDataManager
