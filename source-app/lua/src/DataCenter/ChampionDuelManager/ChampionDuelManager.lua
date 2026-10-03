local ChampionDuelManager = BaseClass("ChampionDuelManager")
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local ChampionDuelInfoData = require("DataCenter.ChampionDuelManager.ChampionDuelInfoData")
local ChampionDuelTeamInfoData = require("DataCenter.ChampionDuelManager.ChampionDuelTeamInfoData")
local ChampionDuelGroupListData = require("DataCenter.ChampionDuelManager.ChampionDuelGroupListData")
local ChampionDuelBattleLogData = require("DataCenter.ChampionDuelManager.ChampionDuelBattleLogData")
local ChampionDuelBetInfoData = require("DataCenter.ChampionDuelManager.ChampionDuelBetInfoData")
local ChampionDuelFinalShowCtrl = require("DataCenter.ChampionDuelManager.ChampionDuelFinalShowCtrl")
local ChampionDuelDonateMsgData = require("DataCenter.ChampionDuelManager.ChampionDuelDonateMsgData")
local MyToNum = tonumber
local MySplit = string.split
local MyStrNull = string.IsNullOrEmpty
local MyInsert = table.insert
local MyTbNull = table.IsNullOrEmpty
local MyStr2Array = string.string2array_i_oneSep
local BET_REMAIN_KEY = "dayRemainingBets"

function ChampionDuelManager:__init()
  self.actInfo = nil
  self.teamInfo = nil
  self.groupList = nil
  self.templateOpenId = nil
  self.templateAwards = nil
  self.templateGuideList = nil
  self.templateGuides = nil
  self.stageTimes = nil
  self.logs = nil
  self.logPops = nil
  self.donateActInfo = {
    progress = 0,
    haveGet = {}
  }
  self.donateActWords = {}
  self.donateActWordsExpiredTime = 0
  self.bInit = true
  self.donateActProgressListCache = nil
  self.donateActProgressList = {}
  self.betInfo = nil
  self.betGuessList = {}
  self.finalMatchDay = 1
  self.finalMatchList = {}
  self.betCosts = nil
  self.betOdds = nil
  self.betOddsK17 = nil
  self.formationSyncFlag = 0
  self.finalRankEndTime = 0
  self.championSpRewards = nil
  self.logPopInit = false
  self.bubbleTipsTimeCountDown = true
  self.lastStageAwardTime = {}
  self:AddListener()
end

function ChampionDuelManager:__delete()
  if self.reqFinalRankDelay then
    self.reqFinalRankDelay:Stop()
    self.reqFinalRankDelay = nil
  end
  self.needClean = false
  self.actInfo = nil
  self.teamInfo = nil
  self.groupList = nil
  self.templateOpenId = nil
  self.templateAwards = nil
  self.templateGuideList = nil
  self.templateGuides = nil
  self.stageTimes = nil
  self.logs = nil
  self.logPops = nil
  self.donateActInfo = nil
  self.donateActWords = nil
  self.donateActWordsExpiredTime = nil
  self.bInit = true
  self.donateActProgressListCache = nil
  self.donateActProgressList = nil
  self.betInfo = nil
  self.betGuessList = {}
  self.finalMatchDay = 1
  self.finalMatchList = {}
  self.betCosts = nil
  self.betOdds = nil
  self.betOddsK17 = nil
  self.formationSyncFlag = 0
  self.finalRankEndTime = 0
  self.championSpRewards = nil
  self.logPopInit = false
  self.rewardInfos = nil
  self.bubbleTipsTimeCountDown = nil
  self.lastStageAwardTime = {}
  ChampionDuelFinalShowCtrl:GetInstance():CleanData()
  self:RemoveListener()
end

local function OnPassDay()
  DataCenter.ChampionDuelManager:SendActInfo(true)
end

local function RefreshCameraPoint()
  ChampionDuelFinalShowCtrl:GetInstance():CheckWorldShow()
end

local function OnCrossServerChange()
  if not BattleFieldUtil.InBattleField() then
    DataCenter.ChampionDuelManager:ReqBattleFinalRank(true)
  end
end

function ChampionDuelManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.OnPassDay, OnPassDay)
  EventManager:GetInstance():AddListener(EventId.WORLD_CAMERA_CHANGE_POINT, RefreshCameraPoint)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, RefreshCameraPoint)
  EventManager:GetInstance():AddListener(EventId.OnSetCrossID, OnCrossServerChange)
end

function ChampionDuelManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, OnPassDay)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_CAMERA_CHANGE_POINT, RefreshCameraPoint)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, RefreshCameraPoint)
  EventManager:GetInstance():RemoveListener(EventId.OnSetCrossID, OnCrossServerChange)
end

function ChampionDuelManager:GetStageTime(stageId, beginTime)
  local actInfo = self:GetActInfo()
  local sTime = beginTime == nil and (actInfo ~= nil and actInfo.beginTime or 0) or beginTime
  if MyTbNull(self.stageTimes) then
    local key = sTime < 1742954400 and "k2" or "k20"
    local values = MySplit(LuaEntry.DataConfig:TryGetStr("lw_champion_duel", key), ",")
    local hourToSec = 3600
    self.stageTimes = {}
    local time
    for _, v in ipairs(values) do
      time = MyToNum(v)
      if time then
        MyInsert(self.stageTimes, time * hourToSec)
      end
    end
  end
  local eTime = sTime
  local min = math.min(stageId, #self.stageTimes)
  for i = 1, min do
    sTime = eTime
    eTime = eTime + self.stageTimes[i]
  end
  return sTime, eTime
end

function ChampionDuelManager:GetTemplateOpen()
  local actInfo = self:GetActInfo()
  if actInfo == nil or actInfo.serverList ~= nil then
    return
  end
  local openId = actInfo.tableId or -1
  if openId == self.templateOpenId then
    return
  end
  self.templateOpenId = openId
  local cfgLine = LocalController:instance():tryGetLine(TableName.LW_Champion_Duel_Open, openId)
  if cfgLine then
    actInfo.season = cfgLine:getIntValue("season")
    actInfo.auditionUpperNums = cfgLine:getIntValue("audition_player_upper_nums")
    actInfo.semiFinalUpperNums = cfgLine:getIntValue("semiFinal_player_upper_nums")
    local server_list = cfgLine:getValue("server_list")
    server_list = MyStr2Array(server_list, ";")
  end
end

function ChampionDuelManager:GetRewardsById(rewardId, bSortReversal)
  return RewardUtil.GetRewardsById(rewardId, bSortReversal)
end

function ChampionDuelManager:InitTemplateAward()
  if self.templateAwards then
    return self.templateAwards
  end
  local awards = {}
  local actInfo = self:GetActInfo()
  local curSeason = actInfo ~= nil and actInfo.season or 0
  LocalController:instance():visitTable(TableName.LW_Champion_Duel_Reward, function(_, lineData)
    local season = lineData:getIntValue("season")
    if season ~= curSeason then
      return
    end
    local stage = lineData:getIntValue("stage")
    local stages = awards[stage]
    if stages == nil then
      stages = {}
      awards[stage] = stages
    end
    local type = lineData:getIntValue("type")
    local types = stages[type]
    if types == nil then
      types = {}
      stages[type] = types
    end
    local keyId = lineData:getIntValue("id")
    local activity_reward = MySplit(lineData:getValue("activity_reward"), ",")
    local aRewards = {}
    for _, v in pairs(activity_reward) do
      MyInsert(aRewards, self:GetRewardsById(MyToNum(v)))
    end
    local config = {
      id = keyId,
      stage = stage,
      type = type,
      para = lineData:getValue("para"),
      task_desc = lineData:getValue("task_desc"),
      task_reward = self:GetRewardsById(lineData:getIntValue("task_reward")),
      rank_person = self:GetRewardsById(lineData:getIntValue("rank_person")),
      rank_alliance = self:GetRewardsById(lineData:getIntValue("rank_alliance")),
      activity_reward = aRewards
    }
    config.paraList = string.split(config.para, ",")
    MyInsert(types, config)
  end)
  self.templateAwards = awards
  return self.templateAwards
end

function ChampionDuelManager:GetTemplateAwardByStageAndType(stage, type)
  local awards = self:InitTemplateAward()
  local stages = awards[stage]
  if stages then
    return stages[type]
  end
  return {}
end

function ChampionDuelManager:GetChampionSpRewardsCfgId()
  if self.championSpRewards then
    return self.championSpRewards
  end
  local templates = DataCenter.ChampionDuelManager:GetTemplateAwardByStageAndType(ChampionDuelState.KnockOut, 2)
  local template = 0 < #templates and templates[1] or {}
  local rank_person = template.rank_person or {}
  local rewards = {}
  for _, v in ipairs(rank_person) do
    local type = LocalController:instance():getIntValue(TableName.GoodsTab, v.itemId, "type")
    if type == GOODS_TYPE.GOODS_TYPE_149 then
      rewards.emojiId = LocalController:instance():getIntValue(TableName.GoodsTab, v.itemId, "para1")
    elseif type == GOODS_TYPE.GOODS_TYPE_113 then
      local decorationId = LocalController:instance():getIntValue(TableName.GoodsTab, v.itemId, "para1")
      local cfg = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
      if cfg then
        if cfg.type == DecorationType.DecorationType_Chat_Bubble then
          rewards.bubbleImg = cfg.img
        elseif cfg.type == DecorationType.DecorationType_Head_Frame then
          rewards.frameImg = cfg.img
        end
      end
    end
  end
  self.championSpRewards = rewards
  return self.championSpRewards
end

function ChampionDuelManager:InitTemplateGuide()
  if self.templateGuideList then
    return
  end
  local guides = {}
  local guideList = {}
  LocalController:instance():visitTable(TableName.LW_Champion_Duel_Guide, function(_, lineData)
    local id = lineData:getIntValue("id")
    local page = lineData:getIntValue("page")
    local order = lineData:getIntValue("order")
    local desc = lineData:getValue("desc")
    local data = {
      id = id,
      page = page,
      order = order,
      desc = desc
    }
    if page == 0 then
      MyInsert(guideList, data)
    else
      local group = guides[page]
      if not group then
        group = {}
        guides[page] = group
      end
      data.type = lineData:getIntValue("type")
      data.pic = lineData:getValue("pic")
      data.tittle = lineData:getValue("tittle")
      MyInsert(group, data)
    end
  end)
  
  local function _sortGuides(a, b)
    if a.order ~= b.order then
      return a.order < b.order
    end
    return false
  end
  
  table.sort(guideList, _sortGuides)
  self.templateGuideList = guideList
  for _, tb in pairs(guides) do
    table.sort(tb, _sortGuides)
  end
  self.templateGuides = guides
end

function ChampionDuelManager:GetTemplateGuideList()
  self:InitTemplateGuide()
  return self.templateGuideList
end

function ChampionDuelManager:GetTemplateGuideByPage(page)
  self:InitTemplateGuide()
  return self.templateGuides[page]
end

function ChampionDuelManager:GetGroupLetter(idx)
  if 26 < idx or idx < 1 then
    return ""
  end
  return ("").char(idx + 96):upper()
end

function ChampionDuelManager:GetActInfo()
  return self.actInfo
end

function ChampionDuelManager:SetActInfoKV(key, value)
  if self.actInfo then
    local oldValue = self.actInfo[key]
    self.actInfo[key] = value
    if key == BET_REMAIN_KEY and oldValue ~= value then
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    elseif key == "redDot" then
      EventManager:GetInstance():Broadcast(EventId.ChampionDuelHeroInoUpdate)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
end

function ChampionDuelManager:GetCurStageId()
  local actInfo = self:GetActInfo()
  return actInfo ~= nil and actInfo.stageId or 0
end

function ChampionDuelManager:GetStageStrKey(stageId, withDay)
  local key = ""
  if withDay then
    if stageId == ChampionDuelState.SignIn then
      key = "champion_duel_phase_name1009"
    elseif stageId == ChampionDuelState.SignInAnnouncement then
      key = "champion_duel_phase_name1010"
    elseif stageId == ChampionDuelState.PreStage then
      key = "champion_duel_phase_name1011"
    elseif stageId == ChampionDuelState.PreStageAnnouncement then
      key = "champion_duel_phase_name1012"
    elseif stageId == ChampionDuelState.Rematch then
      key = "champion_duel_phase_name1013"
    elseif stageId == ChampionDuelState.RematchAnnouncement then
      key = "champion_duel_phase_name1014"
    elseif stageId == ChampionDuelState.KnockOut then
      key = "champion_duel_phase_name1015"
    elseif stageId == ChampionDuelState.FinalShow then
      key = "champion_duel_phase_name1016"
    end
  elseif stageId >= ChampionDuelState.SignIn or stageId <= ChampionDuelState.FinalShow then
    key = "champion_duel_phase_name100" .. stageId
  end
  return key
end

function ChampionDuelManager:GetFinalStrKey(index)
  if index == 1 then
    return "champion_duel_tips1140"
  elseif index == 2 then
    return "champion_duel_tips1141"
  elseif index == 3 then
    return "champion_duel_tips1142"
  elseif index == 4 then
    return "champion_duel_tips1143"
  elseif 5 <= index then
    return "champion_duel_tips1144"
  end
  return ""
end

function ChampionDuelManager:SendActInfo(bInit)
  if bInit then
    self.bInit = true
    self:ReqBattleFinalRank()
  end
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelActivityInfo)
end

function ChampionDuelManager:HandleActInfo(message)
  if message == nil then
    return
  end
  local info = ChampionDuelInfoData.New()
  info:ParseData(message)
  self.actInfo = info
  self:GetTemplateOpen()
  if self.bInit then
    self.bInit = false
    local stageId = self:GetCurStageId()
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local _, endTime = self:GetStageTime(ChampionDuelState.FinalShow)
    if stageId > ChampionDuelState.Default and curSec < endTime then
      if info.sign then
        DataCenter.ChampionDuelManager:SendQueryTeam()
        if stageId >= ChampionDuelState.PreStage and stageId < ChampionDuelState.FinalShow then
          self:ReqBattleLogPop(true)
        end
      end
      self:ReqRewardInfo(false)
      if stageId < ChampionDuelState.Rematch then
        self:ReqDonateActInfo()
      else
        self:ReqBetMoreGuessed()
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelUIRefresh)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ChampionDuelManager:SendSignUp()
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelSignUp)
end

function ChampionDuelManager:HandleSignUp(message)
  if message == nil then
    return
  end
  if message.ret == 1 then
    self:SetActInfoKV("sign", true)
    EventManager:GetInstance():Broadcast(EventId.ChampionDuelUpdateSigned)
  end
end

function ChampionDuelManager:FormationToSFS(teams)
  if not MyTbNull(teams) then
    local ret = SFSArray.New()
    for _, v in pairs(teams) do
      local teamInfo = SFSObject.New()
      teamInfo:PutInt("index", v.index)
      teamInfo:PutInt("squadNo", v.localSquadNo)
      local heroArray = v:GenerateServerHeroArray()
      teamInfo:PutSFSArray("heroInfos", heroArray)
      if v.localChipSetId and v.localChipSetId > 0 and v.localChipSetId <= 4 then
        teamInfo:PutInt("chipEquipGroup", v.localChipSetId)
      end
      ret:AddSFSObject(teamInfo)
    end
    return ret
  end
  return nil
end

function ChampionDuelManager:SendSaveTeam()
  local hasEmptyTeam = self:GetSelfEmptyTeam() ~= nil
  if hasEmptyTeam then
    return
  end
  local changedTeams = self:GetDirtySelfTeams()
  local sfsArray = self:FormationToSFS(changedTeams)
  if sfsArray == nil then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelSaveTeam, sfsArray)
end

function ChampionDuelManager:GetSyncTeamTime()
  local sec = CommonUtil.PlayerPrefsGetInt(SettingKeys.CHAMPION_DUEL_SYNC_TEAM, 0)
  if sec == 0 then
    return nil
  end
  return UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(sec * 1000)
end

function ChampionDuelManager:SetSyncTeamTime()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  CommonUtil.PlayerPrefsSetInt(SettingKeys.CHAMPION_DUEL_SYNC_TEAM, curSec)
  UIUtil.ShowTipsId("champion_duel_tips1048")
  DataCenter.ChampionDuelManager:SetActInfoKV("redDot", false)
end

function ChampionDuelManager:SendSyncTeam()
  local timeStr = self:GetSyncTeamTime()
  if MyStrNull(timeStr) then
    SFSNetwork.SendMessage(MsgDefines.ChampionDuelSyncTeam)
  else
    UIUtil.ShowMessage(Localization:GetString("champion_duel_tips1035", timeStr), 2, "393010", "110106", function()
      SFSNetwork.SendMessage(MsgDefines.ChampionDuelSyncTeam)
    end)
  end
end

function ChampionDuelManager:SendSaveTeamIndex(order, index, bUp)
  local myInfo = self:GetMyTeamInfo()
  local teamOrder = myInfo ~= nil and myInfo.teamOrder or nil
  if teamOrder == nil then
    return
  end
  local newTb = {}
  table.merge(newTb, teamOrder)
  local tmpIdx = order + (bUp and -1 or 1)
  local old = newTb[tmpIdx]
  newTb[order] = old
  newTb[tmpIdx] = index
  self.tempTeamOrder = newTb
  local newOrder = ""
  local sep = ";"
  for _, v in ipairs(newTb) do
    if newOrder == "" then
      newOrder = v
    else
      newOrder = newOrder .. sep .. v
    end
  end
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelSaveTeamIndex, newOrder)
end

function ChampionDuelManager:SaveFormationTime()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  CommonUtil.PlayerPrefsSetInt(SettingKeys.CHAMPION_DUEL_QUERY_TEAM, curSec)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ChampionDuelManager:SendQueryTeam()
  local uid = LuaEntry.Player:GetUid()
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelQueryTeam, uid)
end

function ChampionDuelManager:HandleTeamOperation(message, bSync)
  if message == nil then
    return
  end
  if message.ret == 1 then
    self:HandleTeam(message)
    if bSync then
      self:SetSyncTeamTime()
    else
      UIUtil.ShowTipsId(801154)
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function ChampionDuelManager:HandleTeamIndex(message)
  if message == nil then
    return
  end
  if message.ret == 1 and self.tempTeamOrder then
    local myInfo = self:GetMyTeamInfo()
    if myInfo then
      myInfo.teamOrder = self.tempTeamOrder
    end
    EventManager:GetInstance():Broadcast(EventId.ChampionDuelFormationRefresh, LuaEntry.Player:GetUid())
  end
  self.tempTeamOrder = nil
end

function ChampionDuelManager:HandleTeam(message)
  if message == nil then
    return
  end
  local info = ChampionDuelTeamInfoData.New()
  info:ParseData(message)
  self.teamInfo = info
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelFormationRefresh, info.uid)
end

function ChampionDuelManager:GetMyTeamInfo()
  return self.teamInfo
end

function ChampionDuelManager:CheckSelfTeamOrderUnlocked(order, showTips)
  local teamInfo = self:GetMyTeamInfo()
  return teamInfo ~= nil and teamInfo:CheckSelfTeamOrderUnlocked(order, showTips) or false
end

function ChampionDuelManager:GetSelfTeamByOrder(order)
  local teamInfo = self:GetMyTeamInfo()
  return teamInfo ~= nil and teamInfo:GetTeamDataByOrder(order) or nil
end

function ChampionDuelManager:GetSelfTeamOrderByIndex(index)
  local teamInfo = self:GetMyTeamInfo()
  return teamInfo ~= nil and teamInfo:GetSelfTeamOrderByIndex(index) or nil
end

function ChampionDuelManager:GetHeroInSelfTeamOrder(uuid)
  local teamInfo = self:GetMyTeamInfo()
  return teamInfo ~= nil and teamInfo:GetHeroInSelfTeamOrder(uuid) or nil
end

function ChampionDuelManager:GetDirtySelfTeams()
  local teamInfo = self:GetMyTeamInfo()
  return teamInfo ~= nil and teamInfo:GetDirtySelfTeams() or nil
end

function ChampionDuelManager:GetSelfEmptyTeam()
  local teamInfo = self:GetMyTeamInfo()
  return teamInfo ~= nil and teamInfo:GetSelfEmptyTeam() or nil
end

function ChampionDuelManager:GetTeamIndexUsingBuff(buffIndex)
  local teamInfo = self:GetMyTeamInfo()
  return teamInfo ~= nil and teamInfo:GetTeamIndexUsingBuff(buffIndex) or nil
end

function ChampionDuelManager:SetTeamUsingBuff(order, buffIndex)
  local team = self:GetSelfTeamByOrder(order)
  if not team then
    return
  end
  team.localSquadNo = buffIndex
  EventManager:GetInstance():Broadcast(EventId.Arena3V3BuffChange)
end

function ChampionDuelManager:SaveGroupTime()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  CommonUtil.PlayerPrefsSetString(SettingKeys.CHAMPION_DUEL_GROUP_CHECK, curSec .. ";" .. self:GetCurStageId())
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ChampionDuelManager:SendGroupList(group, startRank, pageSize, stageId)
  local tmpGroup = group < 1 and 1 or group
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelGroupList, tmpGroup, startRank, pageSize, stageId)
end

function ChampionDuelManager:HandleGroupList(message)
  if message == nil then
    return
  end
  local info = ChampionDuelGroupListData.New()
  info:ParseData(message)
  self.groupList = info
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelGroupRefresh)
end

function ChampionDuelManager:GetGroupList()
  return self.groupList
end

function ChampionDuelManager:SendBattleWord(msg)
  self.tmpBattleWord = msg
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelBattleWord, msg)
end

function ChampionDuelManager:HandleBattleWorld(message)
  if message == nil then
    return
  end
  if message.ret == 1 and self.tmpBattleWord then
    local actInfo = self:GetActInfo()
    if actInfo then
      actInfo.battleWord = self.tmpBattleWord
    end
    local myInfo = self:GetMyTeamInfo()
    if myInfo then
      myInfo.battleWord = self.tmpBattleWord
      if message.expireTime then
        myInfo.battleWordExpireTime = message.expireTime
      end
    end
    EventManager:GetInstance():Broadcast(EventId.ChampionDuelFormationBattleWordRefresh, self.tmpBattleWord)
  end
  self.tmpBattleWord = nil
end

function ChampionDuelManager:ReqStageInfo()
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelStageInfo)
end

function ChampionDuelManager:HandleAuditionInfo(message)
  if message == nil then
    return
  end
  local remainTime = message.remainTime or 0
  local selfInfo = ChampionDuelTeamInfoData.New()
  selfInfo:ParseData(message.self)
  local targetInfo = ChampionDuelTeamInfoData.New()
  targetInfo:ParseData(message.target)
  local dayMatchTimes = message.dayMatchTimes or 0
  local dayMatchMaxTimes = message.dayMatchMaxTimes or 0
  local matchDay = message.matchDay or 0
  local matchMaxDay = message.matchMaxDay or 0
  local selfScore = message.selfScore or 0
  local targetScore = message.targetScore or 0
  local info = {
    remainTime = remainTime,
    selfInfo = selfInfo,
    targetInfo = targetInfo,
    dayMatchTimes = dayMatchTimes,
    dayMatchMaxTimes = dayMatchMaxTimes,
    matchDay = matchDay,
    matchMaxDay = matchMaxDay,
    selfScore = selfScore,
    targetScore = targetScore
  }
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelAuditionInfoRefresh, info)
end

function ChampionDuelManager:HandleAuditionShowInfo(message)
  if message == nil then
    return
  end
  local info = {
    keepWinCount = message.keepWinCount or 0,
    fightCount = message.fightCount or 0,
    winCount = message.winCount or 0,
    rank = message.rank or 0,
    score = message.score or 0,
    upgrade = message.upgrade or false,
    evolution = message.evolution or 1
  }
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelAuditionShowInfoRefresh, info)
end

function ChampionDuelManager:ReqFinalMatchList()
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelKnockoutMatchList)
end

function ChampionDuelManager:HandleFinalMatchList(message)
  if message == nil then
    return
  end
  local list = {}
  local dataList = message.data
  if dataList then
    for _, matchData in ipairs(dataList) do
      local groupId = matchData.groupId or 0
      local matchList = list[groupId]
      if matchList == nil then
        matchList = {}
        list[groupId] = matchList
      end
      local match = matchData.match
      if match then
        for _, v in ipairs(match) do
          local winner = v.winner or ""
          local point = v.point or 0
          local targetPoint = v.targetPoint or 0
          local teamA = ChampionDuelTeamInfoData.New()
          teamA:ParseData(v.teamA)
          local teamB = ChampionDuelTeamInfoData.New()
          teamB:ParseData(v.teamB)
          MyInsert(matchList, {
            winner = winner,
            point = point,
            targetPoint = targetPoint,
            teamA = teamA,
            teamB = teamB
          })
        end
      end
    end
  end
  self.finalMatchDay = message.matchDay or 0
  self.finalMatchList = list
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelFinalMatchListRefresh)
end

function ChampionDuelManager:GetFinalMatchListByGroup(group)
  return self.finalMatchList ~= nil and self.finalMatchList[group] or {}
end

function ChampionDuelManager:GetFinalMatchMaxDay()
  if self.finalMatchDay > 0 then
    return self.finalMatchDay > 5 and 5 or self.finalMatchDay
  end
  local curDay = 1
  for i = 1, 5 do
    local group = self:GetFinalMatchListByGroup(i)
    if not MyTbNull(group) then
      curDay = i
    end
  end
  return curDay
end

function ChampionDuelManager:DoFinalRankRefresh()
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelFinalRankListRefresh)
  ChampionDuelFinalShowCtrl:GetInstance():UpdateBaseXZ()
  ChampionDuelFinalShowCtrl:GetInstance():UpdateFTAnim()
end

function ChampionDuelManager:ReqBattleFinalRank(needClean)
  if self.reqFinalRankDelay then
    self.reqFinalRankDelay:Stop()
    self.reqFinalRankDelay = nil
  end
  if needClean then
    self.needClean = true
  end
  self.reqFinalRankDelay = TimerManager:GetInstance():DelayInvoke(function()
    self.reqFinalRankDelay = nil
    if self.needClean then
      self.needClean = false
      self.finalRankEndTime = 0
      self.finalRankList = {}
      self:DoFinalRankRefresh()
    end
    local serverId = LuaEntry.Player:GetCurServerId()
    SFSNetwork.SendMessage(MsgDefines.ChampionDuelFinalRankShow, 32, serverId)
  end, 0.5)
end

function ChampionDuelManager:HandleFinalRankList(message)
  if message == nil then
    return
  end
  local list = {}
  local ranks = message.rank
  if ranks then
    for _, v in ipairs(ranks) do
      local team = ChampionDuelTeamInfoData.New()
      team:ParseData(v)
      MyInsert(list, team)
    end
  end
  table.sort(list, function(a, b)
    return a.rank < b.rank
  end)
  self.finalRankEndTime = message.endTime or 0
  self.finalRankList = list
  self:DoFinalRankRefresh()
end

function ChampionDuelManager:GetFinalRankEndTime()
  return self.finalRankEndTime
end

function ChampionDuelManager:GetFinalRankList()
  return self.finalRankList or {}
end

function ChampionDuelManager:ReqBattleLogInfo(uuid)
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelBattleLogInfo, uuid)
end

function ChampionDuelManager:ReqBattleLog(uid, time, num)
  local tmpTime = time or 0
  local tmpNum = num or 100
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelBattleLog, uid, tmpTime, tmpNum)
end

function ChampionDuelManager:HandleBattleLog(message)
  if message == nil then
    return
  end
  local data = message.data
  local uid
  if not MyTbNull(data) then
    if self.logs == nil then
      self.logs = {}
    end
    local logs = {}
    for _, v in ipairs(data) do
      local logData = ChampionDuelBattleLogData.New()
      logData:ParseData(v)
      MyInsert(logs, logData)
      if uid == nil and logData.my and not MyStrNull(logData.my.uid) then
        uid = logData.my.uid
      end
    end
    if uid then
      table.sort(logs, function(a, b)
        return a.time > b.time
      end)
      self.logs[uid] = logs
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelLogRefresh, uid)
end

function ChampionDuelManager:GetLogsByUid(uid)
  return self.logs ~= nil and self.logs[uid] or nil
end

function ChampionDuelManager:ReqBattleLogPop(bInit)
  self.logPopInit = bInit
  local time = CommonUtil.PlayerPrefsGetInt(SettingKeys.CHAMPION_DUEL_LOG_POP_TIME, 0)
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelBattleLogPop, time)
end

function ChampionDuelManager:HandleBattleLogPop(message)
  if message == nil then
    return
  end
  local data = message.data
  if data == nil then
    return
  end
  if self.logPops == nil then
    self.logPops = {}
  end
  local logTimes = {}
  for _, v in ipairs(self.logPops) do
    logTimes[v.time] = true
  end
  for _, v in ipairs(data) do
    local time = v.time
    if not logTimes[time] then
      local logData = ChampionDuelBattleLogData.New()
      logData:ParseData(v)
      MyInsert(self.logPops, logData)
    end
  end
  if not MyTbNull(self.logPops) then
    table.sort(self.logPops, function(a, b)
      return a.time < b.time
    end)
    local time = self.logPops[#self.logPops].time
    if self.logPopInit then
      local signTime = CommonUtil.PlayerPrefsGetInt(SettingKeys.CHAMPION_DUEL_LOG_POP_TIME, 0)
      self:UpdateLogPopSign(time > signTime)
    else
      CommonUtil.PlayerPrefsSetInt(SettingKeys.CHAMPION_DUEL_LOG_POP_TIME, time)
    end
  elseif self.logPopInit then
    self:UpdateLogPopSign(false)
  end
  self.logPopInit = false
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelLogPopRefresh)
end

function ChampionDuelManager:PopOnLogPop()
  if MyTbNull(self.logPops) then
    return nil
  end
  local logData = table.remove(self.logPops, 1)
  return logData
end

function ChampionDuelManager:ReqRewardInfo(openCb)
  self.openAwardViewCb = openCb
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelRewardInfo)
end

function ChampionDuelManager:HandleRewardInfo(message)
  if message == nil then
    return
  end
  local rewardInfos = {}
  local rewards = message.data
  if rewards then
    for _, v in pairs(rewards) do
      local id = v.id
      local info = {
        id = id,
        status = v.status,
        value = v.value,
        srCount = v.srCount,
        srStatus = v.srStatus
      }
      rewardInfos[id] = info
    end
  end
  local info = self:GetActInfo()
  if info ~= nil then
    info.auditionStageGroupCount = message.auditionStageGroupCount or 0
    info.semiFinalGroupCount = message.semiFinalGroupCount or 0
  end
  self.rewardInfos = rewardInfos
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelRewardRefresh)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  if self.openAwardViewCb then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelAward, {anim = true}, self.openAwardViewCb)
  end
end

function ChampionDuelManager:GetRewardInfo(id)
  return self.rewardInfos ~= nil and self.rewardInfos[id] or nil
end

function ChampionDuelManager:ReqRewardGet(id, type)
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelRewardGet, id, type)
end

function ChampionDuelManager:HandleRewardGet(message)
  if message == nil then
    return
  end
  if message.ret ~= 1 then
    return
  end
  local id = message.id
  local type = message.type
  local count = message.srCount
  local data = self:GetRewardInfo(id)
  if data ~= nil then
    if type == 1 then
      data.srCount = count
      data.srStatus = 2
    else
      data.status = 2
    end
  end
  local info = {
    id = id,
    type = type,
    count = count
  }
  local reward = message.reward
  if reward ~= nil then
    DataCenter.RewardManager:AddRewards(reward)
    info.reward = DataCenter.RewardManager:ReturnRewardParamForView(reward) or {}
  end
  local helpUser = message.helpUser
  if helpUser ~= nil then
    local userInfos = {}
    for i, v in ipairs(helpUser) do
      if 20 < i then
        break
      end
      local infoData = ChampionDuelTeamInfoData.New()
      infoData:ParseData(v)
      MyInsert(userInfos, infoData)
    end
    info.helpUser = userInfos
  end
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelRewardRefresh, id)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelReward, {anim = true}, info)
end

function ChampionDuelManager:ReqAllRewardGet(stage)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastStageAwardTime ~= nil then
    if self.lastStageAwardTime[stage] ~= nil and curTime - self.lastStageAwardTime[stage] <= 1000 then
      return
    end
  else
    self.lastStageAwardTime = {}
  end
  self.lastStageAwardTime[stage] = curTime
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelRewardBatchGet, stage)
end

function ChampionDuelManager:HandleAllRewardGet(message)
  if message == nil then
    return
  end
  local ids = message.rewardIds
  if ids == nil then
    return
  end
  local defaultId = 0
  for i, id in pairs(ids) do
    local data = self:GetRewardInfo(id)
    if data ~= nil then
      data.status = 2
      defaultId = id
    end
  end
  local info = {}
  local reward = message.reward
  if reward ~= nil then
    DataCenter.RewardManager:AddRewards(reward)
    info.reward = DataCenter.RewardManager:ReturnRewardParamForView(reward) or {}
  end
  if table.count(ids) == 1 and 0 < defaultId then
    EventManager:GetInstance():Broadcast(EventId.ChampionDuelRewardRefresh, defaultId)
    info.id = defaultId
  else
    EventManager:GetInstance():Broadcast(EventId.ChampionDuelRewardRefresh)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelReward, {anim = true}, info)
end

function ChampionDuelManager:RefreshRankShow(textTip, tipKey, imgRank, textRank, rank)
  local tipStr
  if 0 < rank and rank <= 3 then
    imgRank:LoadSpriteAsyncWithCallback(string.format("Assets/Main/Sprites/UI/UIChampionDuel/Sprites/lrb_zhengduosai_paiming0%s.png", rank), function()
      if imgRank then
        imgRank:SetNativeSize()
      end
    end)
    textRank:SetText(rank)
    imgRank:SetActive(true)
    textTip:SetLocalText(tipKey, "")
  else
    tipStr = Localization:GetString(tipKey, "")
    imgRank:SetActive(false)
    if 100 < rank then
      tipStr = tipStr .. "100+"
    else
      tipStr = tipStr .. rank
    end
    textTip:SetText(tipStr)
  end
end

function ChampionDuelManager:ReqDonateActInfo()
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelHotActInfo)
end

function ChampionDuelManager:GetDonateActInfo()
  return self.donateActInfo
end

function ChampionDuelManager:GetDonateActWord()
  return self.donateActWords
end

function ChampionDuelManager:GetDonateActWordsExpiredTime()
  return self.donateActWordsExpiredTime
end

function ChampionDuelManager:HandleDonateActInfo(message)
  if message.progress then
    self.donateActInfo.progress = message.progress
  end
  self.donateActInfo.haveGet = {}
  if message.hadReward then
    for k, v in pairs(message.hadReward) do
      self.donateActInfo.haveGet[v] = true
    end
  end
end

function ChampionDuelManager:HandleDonateActDonate(message)
  if message.progress then
    self.donateActInfo.progress = message.progress
  end
end

function ChampionDuelManager:HandleDonateActRewardGet(message)
  if message.rewardIdx then
    self.donateActInfo.haveGet[message.rewardIdx] = true
  end
end

function ChampionDuelManager:HandleDonateActWord(message)
  local datas = message.data
  if datas then
    self.donateActWords = {}
    for _, v in ipairs(datas) do
      local info = ChampionDuelDonateMsgData.New()
      info:ParseData(v)
      table.insert(self.donateActWords, info)
    end
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local waitMine = 1
  if self.donateActWords and #self.donateActWords > 10 then
    waitMine = 5
  end
  self.donateActWordsExpiredTime = curTime + waitMine * 60 * 1000
end

function ChampionDuelManager:ReqBetMain()
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelBetMain)
end

function ChampionDuelManager:ReqBetRefresh()
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelBetRefresh)
end

function ChampionDuelManager:HandleBetMain(message)
  if message == nil then
    return
  end
  if message.betMatchId then
    local info = ChampionDuelBetInfoData.New()
    info:ParseData(message)
    self.betInfo = info
    self:SetActInfoKV(BET_REMAIN_KEY, info.dayRemainingBets)
  else
    self.betInfo = nil
  end
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelBetInfoRefresh)
end

function ChampionDuelManager:GetBetInfo()
  return self.betInfo
end

function ChampionDuelManager:UpdateBet(betInfo, betMatchId, betUid, betCountId)
  if betInfo == nil or betInfo.betMatchId ~= betMatchId then
    return
  end
  betInfo.hasBet = betUid ~= nil
  if betUid ~= nil then
    betInfo.betCountId = betCountId
    local cost = self:GetBetCost(betInfo.betCountId)
    local rivalAUid = betInfo.betMatchRivalA ~= nil and betInfo.betMatchRivalA.uid or nil
    if rivalAUid == betUid then
      betInfo.betMatchRivalA.isChooseBet = true
      betInfo.betMatchRivalA.totalBets = betInfo.betMatchRivalA.totalBets + cost
    end
    local rivalBUid = betInfo.betMatchRivalB ~= nil and betInfo.betMatchRivalB.uid or nil
    if rivalBUid == betUid then
      betInfo.betMatchRivalB.isChooseBet = true
      betInfo.betMatchRivalB.totalBets = betInfo.betMatchRivalB.totalBets + cost
    end
  else
    local cost = self:GetBetCost(betInfo.betCountId)
    if betInfo.betMatchRivalA and betInfo.betMatchRivalA.isChooseBet then
      betInfo.betMatchRivalA.isChooseBet = false
      betInfo.betMatchRivalA.totalBets = betInfo.betMatchRivalA.totalBets - cost
    end
    if betInfo.betMatchRivalB and betInfo.betMatchRivalB.isChooseBet then
      betInfo.betMatchRivalB.isChooseBet = false
      betInfo.betMatchRivalB.totalBets = betInfo.betMatchRivalB.totalBets - cost
    end
  end
end

function ChampionDuelManager:CheckUpdateBet(betMatchId, betUid, betCountId)
  self:UpdateBet(self:GetBetInfo(), betMatchId, betUid, betCountId)
  for i = 1, 2 do
    local list = self:GetGuessList(i)
    for _, v in pairs(list) do
      self:UpdateBet(v, betMatchId, betUid, betCountId)
    end
  end
end

function ChampionDuelManager:GetBetCost(idx)
  if self.betCosts == nil then
    local str = LuaEntry.DataConfig:TryGetStr("lw_champion_duel", "k7", "100,150,200")
    self.betCosts = MyStr2Array(str, ",")
  end
  local tmpNum = self.betCosts ~= nil and self.betCosts[idx] or 0
  return tmpNum or 0
end

function ChampionDuelManager:GetBetOddsList(keyStr)
  local str = LuaEntry.DataConfig:TryGetStr("lw_champion_duel", keyStr, "2,3,4")
  local odds = MyStr2Array(str, ",")
  table.sort(odds, function(a, b)
    return a < b
  end)
  return odds
end

function ChampionDuelManager:GetBetOdds(stageId)
  local odds
  if stageId >= ChampionDuelState.KnockOut then
    if self.betOddsK17 == nil then
      self.betOddsK17 = self:GetBetOddsList("k17")
    end
    odds = self.betOddsK17
  else
    if self.betOdds == nil then
      self.betOdds = self:GetBetOddsList("k9")
    end
    odds = self.betOdds
  end
  return odds or {}
end

function ChampionDuelManager:ReqBetStart(betMatchId, betUid, betCountId)
  self.tmpBetStartMatchId = betMatchId
  self.tmpBetUid = betUid
  self.tmpBetCountId = betCountId
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelBetStart, betMatchId, betUid, betCountId)
end

function ChampionDuelManager:ReqBetCancel(betMatchId)
  self.tmpBetCancelMatchId = betMatchId
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelBetCancel, betMatchId)
end

function ChampionDuelManager:HandleBetOperate(message, bStart)
  if message == nil then
    return
  end
  if message.ret == 1 then
    local tmpId
    if bStart then
      tmpId = self.tmpBetStartMatchId
      self:CheckUpdateBet(self.tmpBetStartMatchId, self.tmpBetUid, self.tmpBetCountId)
    else
      self:ShowGuessAwardTip(message)
      tmpId = self.tmpBetCancelMatchId
      self:CheckUpdateBet(self.tmpBetCancelMatchId)
    end
    local num = message.dayRemainingBets
    local myBetInfo = self:GetBetInfo()
    if myBetInfo ~= nil then
      myBetInfo.dayRemainingBets = num
    end
    self:SetActInfoKV(BET_REMAIN_KEY, num)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionDuelGuessBet)
    EventManager:GetInstance():Broadcast(EventId.ChampionDuelBetInfoRefresh, tmpId)
  end
  if bStart then
    self.tmpBetStartMatchId = nil
    self.tmpBetUid = nil
    self.tmpBetCountId = nil
  else
    self.tmpBetCancelMatchId = nil
  end
end

function ChampionDuelManager:ReqBetMoreGuessable()
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelBetMoreGuessable)
end

function ChampionDuelManager:ReqBetMoreGuessed()
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelBetMoreGuessed)
end

function ChampionDuelManager:HandleBetRivalList(message, bGuessable)
  if message == nil then
    return
  end
  local array = {}
  if bGuessable then
    array = message.betMatchRivals
  else
    array = message.betResult
  end
  local list = {}
  if not MyTbNull(array) then
    for _, v in pairs(array) do
      local info = ChampionDuelBetInfoData.New()
      info:ParseData(v)
      MyInsert(list, info)
    end
  end
  if bGuessable then
    self.betGuessList[1] = list
  else
    self.betGuessList[2] = list
  end
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelBetListRefresh)
  if not bGuessable then
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function ChampionDuelManager:GetGuessList(idx)
  return self.betGuessList[idx] or {}
end

function ChampionDuelManager:ReqDrawAward(betMatchId)
  self.tmpDrawAwardMatchId = betMatchId
  SFSNetwork.SendMessage(MsgDefines.ChampionDuelBetDrawAward, betMatchId)
end

function ChampionDuelManager:HandleDrawReward(message)
  if message == nil then
    return
  end
  if message.ret == 1 then
    self:ShowGuessAwardTip(message)
    local tmpId = self.tmpDrawAwardMatchId
    if tmpId then
      local betInfo = self:GetBetInfo()
      if betInfo and betInfo.betMatchId == tmpId then
        betInfo.hasReward = true
      end
      for i = 1, 2 do
        local list = self:GetGuessList(i)
        for _, v in pairs(list) do
          if v and v.betMatchId == tmpId then
            v.hasReward = true
          end
        end
      end
      EventManager:GetInstance():Broadcast(EventId.ChampionDuelBetInfoRefresh, tmpId)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
  end
  self.tmpDrawAwardMatchId = nil
end

function ChampionDuelManager:ShowGuessAwardTip(message)
  if message == nil then
    return
  end
  if message.itemId and message.itemAddNum then
    local showNum = message.itemAddNum
    local showName = DataCenter.ItemTemplateManager:GetName(message.itemId)
    if not MyStrNull(showName) then
      showName = string.GetFormattedStr(showNum) .. " " .. showName
    end
    UIUtil.ShowTips(Localization:GetString("open_box_tips", showName))
  end
end

function ChampionDuelManager:GetGuessItemId()
  if self.guessItemId == nil then
    self.guessItemId = LuaEntry.DataConfig:TryGetNum("lw_champion_duel", "k16", 620102)
  end
  return self.guessItemId
end

function ChampionDuelManager:GetGuessItemIcon()
  local itemId = self:GetGuessItemId()
  return DataCenter.ItemTemplateManager:GetIconPath(itemId)
end

function ChampionDuelManager:GetGuessItemHave()
  local itemId = self:GetGuessItemId()
  return DataCenter.ItemData:GetItemCount(itemId)
end

function ChampionDuelManager:SaveSignFlag()
  local time = CommonUtil.PlayerPrefsGetInt(SettingKeys.CHAMPION_DUEL_SIGN_RED, 0)
  local sTime, endTime = self:GetStageTime(ChampionDuelState.SignIn)
  if time > sTime and time < endTime then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  CommonUtil.PlayerPrefsSetInt(SettingKeys.CHAMPION_DUEL_SIGN_RED, curSec)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ChampionDuelManager:GetSignPrefsKey()
  return "CHAMPION_DUEL_SIGN_POP"
end

function ChampionDuelManager:CheckShowSignPop()
  local redNum = self:GetSignRed()
  if redNum == 0 then
    return false
  end
  local todayZero = UITimeManager:GetInstance():GetTodayZero()
  local lastOpenTime = CommonUtil.PlayerPrefsGetLong(self:GetSignPrefsKey(), 0)
  return todayZero > lastOpenTime
end

function ChampionDuelManager:GetSignRed()
  local stageId = self:GetCurStageId()
  if stageId == ChampionDuelState.SignIn then
    local actInfo = self:GetActInfo()
    local sign = actInfo ~= nil and actInfo.sign or false
    if not sign then
      local time = CommonUtil.PlayerPrefsGetInt(SettingKeys.CHAMPION_DUEL_SIGN_RED, 0)
      local sTime = actInfo ~= nil and actInfo.stageBeginTime or 0
      if time < sTime then
        return 1
      end
    end
  end
  return 0
end

function ChampionDuelManager:GetAwardRed()
  local stageId = self:GetCurStageId()
  if stageId > ChampionDuelState.Default then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local _, endTime = self:GetStageTime(ChampionDuelState.FinalShow)
    if curSec >= endTime then
      return 0
    end
  end
  if MyTbNull(self.rewardInfos) then
    return 0
  end
  local cnt = 0
  for _, v in pairs(self.rewardInfos) do
    if v.status == 1 then
      cnt = cnt + 1
    end
    if v.srStatus == 1 then
      cnt = cnt + 1
    end
  end
  return cnt
end

function ChampionDuelManager:CheckGroupRed()
  local curStage = self:GetCurStageId()
  if curStage ~= ChampionDuelState.SignInAnnouncement and curStage ~= ChampionDuelState.PreStageAnnouncement and curStage ~= ChampionDuelState.RematchAnnouncement then
    return 0
  end
  local actInfo = self:GetActInfo()
  local sign = actInfo ~= nil and actInfo.sign or false
  if not sign then
    return 0
  end
  local str = CommonUtil.PlayerPrefsGetString(SettingKeys.CHAMPION_DUEL_GROUP_CHECK, "0;1")
  local infos = MySplit(str, ";")
  local time = MyToNum(infos[1]) or 0
  local stage = MyToNum(infos[2]) or 1
  local beginTime = actInfo ~= nil and actInfo.beginTime or 0
  if time == 0 or time < beginTime or stage ~= curStage then
    return 1
  end
  return 0
end

function ChampionDuelManager:CheckFormationSyncRed()
  local actInfo = self:GetActInfo()
  if actInfo ~= nil then
    return actInfo.redDot and 1 or 0
  end
  return 0
end

function ChampionDuelManager:CheckFormationRed()
  local actInfo = self:GetActInfo()
  local sign = actInfo ~= nil and actInfo.sign or false
  if not sign then
    return 0
  end
  local stageId = self:GetCurStageId()
  if stageId == ChampionDuelState.FinalShow or stageId == ChampionDuelState.Default then
    return 0
  end
  if stageId == ChampionDuelState.RematchAnnouncement then
    local group5 = actInfo ~= nil and actInfo.group5 or 0
    if group5 == 0 then
      return 0
    end
  elseif stageId > ChampionDuelState.SignIn then
    local group = actInfo ~= nil and actInfo.group or 0
    if group == 0 then
      return 0
    end
  end
  local cnt = self:CheckFormationSyncRed()
  local time = CommonUtil.PlayerPrefsGetInt(SettingKeys.CHAMPION_DUEL_QUERY_TEAM, 0)
  local beginTime = actInfo ~= nil and actInfo.beginTime or 0
  if time == 0 or time < beginTime then
    cnt = cnt + 1
  end
  return cnt
end

function ChampionDuelManager:SaveGuessTime()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local sce = CommonUtil.PlayerPrefsGetInt(SettingKeys.CHAMPION_DUEL_GUESS_TIME, 0)
  if UITimeManager:GetInstance():IsSameDayForServer(sce, now) then
    return
  end
  CommonUtil.PlayerPrefsSetInt(SettingKeys.CHAMPION_DUEL_GUESS_TIME, now)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ChampionDuelManager:CheckGuessRewardRed()
  local stageId = self:GetCurStageId()
  if stageId < ChampionDuelState.Rematch then
    return 0
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local _, endTime = self:GetStageTime(ChampionDuelState.FinalShow)
  if curSec >= endTime then
    return 0
  end
  local list = self:GetGuessList(2)
  local cnt = 0
  for _, v in pairs(list) do
    if v.hasBet and not v.hasReward then
      cnt = cnt + 1
    end
  end
  return cnt
end

function ChampionDuelManager:CheckGuessRed()
  local stageId = self:GetCurStageId()
  local sce = CommonUtil.PlayerPrefsGetInt(SettingKeys.CHAMPION_DUEL_GUESS_TIME, 0)
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if UITimeManager:GetInstance():IsSameDayForServer(sce, now) then
    return 0
  end
  if stageId == ChampionDuelState.Rematch or stageId == ChampionDuelState.KnockOut then
    local actInfo = self:GetActInfo()
    local num = actInfo ~= nil and actInfo.dayRemainingBets or 0
    return 0 < num and 1 or 0
  end
  return 0
end

function ChampionDuelManager:UpdateLogPopSign(bShow)
  local flag = CommonUtil.PlayerPrefsGetBool(SettingKeys.CHAMPION_DUEL_LOG_POP_RED, false)
  if flag == bShow then
    return
  end
  CommonUtil.PlayerPrefsSetBool(SettingKeys.CHAMPION_DUEL_LOG_POP_RED, bShow)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ChampionDuelManager:CheckLogPopRed()
  local stageId = self:GetCurStageId()
  if stageId < ChampionDuelState.PreStage and stageId >= ChampionDuelState.FinalShow then
    return 0
  end
  if stageId == ChampionDuelState.KnockOut then
    local actInfo = self:GetActInfo()
    local group = actInfo.group or 0
    if group == 0 then
      return 0
    end
  end
  local flag = CommonUtil.PlayerPrefsGetBool(SettingKeys.CHAMPION_DUEL_LOG_POP_RED, false)
  return flag and 1 or 0
end

function ChampionDuelManager:GetDonateActRedNum()
  local redNum = 0
  local rewardNum = 0
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  if 0 < stageId and stageId < ChampionDuelState.Rematch then
    local donateItemId = LuaEntry.DataConfig:TryGetNum("lw_champion_duel", "k5")
    local haveCount = DataCenter.ItemData:GetItemCount(donateItemId)
    redNum = redNum + haveCount
    local actInfo = DataCenter.ChampionDuelManager:GetDonateActInfo()
    if actInfo and 0 < actInfo.progress then
      local awardTempStageId = stageId
      if awardTempStageId == ChampionDuelState.SignInAnnouncement then
        awardTempStageId = ChampionDuelState.SignIn
      elseif awardTempStageId == ChampionDuelState.PreStageAnnouncement then
        awardTempStageId = ChampionDuelState.PreStage
      end
      local activityType = 3
      local awardTemp = DataCenter.ChampionDuelManager:GetTemplateAwardByStageAndType(awardTempStageId, activityType)
      if awardTemp and 0 < #awardTemp then
        local progressScoreList = self.donateActProgressList
        if not awardTemp[1].para == self.donateActProgressListCache then
          self.donateActProgressListCache = awardTemp[1].para
          self.donateActProgressList = MyStr2Array(awardTemp[1].para, ",")
          progressScoreList = self.donateActProgressList
        end
        local curProgress = actInfo.progress
        for i = 1, #progressScoreList do
          if curProgress >= progressScoreList[i] and not actInfo.haveGet[i - 1] == true then
            rewardNum = rewardNum + 1
          end
        end
      end
    end
  end
  return redNum + rewardNum, rewardNum, redNum
end

function ChampionDuelManager:GetTotalRedCount()
  if not LuaEntry.Player:AtHomeNow() then
    return 0
  end
  local cnt = self:GetSignRed()
  local rewardCnt = self:GetAwardRed()
  cnt = cnt + self:CheckGroupRed()
  cnt = cnt + self:CheckFormationRed()
  cnt = cnt + self:CheckGuessRed()
  rewardCnt = rewardCnt + self:CheckGuessRewardRed()
  cnt = cnt + self:CheckLogPopRed()
  local t, tipNum, rewardNum = self:GetDonateActRedNum()
  cnt = cnt + tipNum
  rewardCnt = rewardCnt + rewardNum
  return cnt + rewardCnt, rewardCnt, cnt
end

function ChampionDuelManager:GetChampionDuelPreviewRemainTime()
  if self.actInfo and self.actInfo.stageId == ChampionDuelState.Default then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local remainTime = self.actInfo.beginTime - curTime
    if remainTime < 0 then
      remainTime = 0
    end
    return remainTime
  end
  return 0
end

function ChampionDuelManager:GetChampionDuelBeginTime()
  if self.actInfo and self.actInfo.stageId == ChampionDuelState.Default then
    return self.actInfo.beginTime
  end
  return 0
end

function ChampionDuelManager:SetBubbleTipsTimeCountDownValue(value)
  self.bubbleTipsTimeCountDown = value
end

return ChampionDuelManager
