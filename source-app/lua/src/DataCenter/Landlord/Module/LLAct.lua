local _CLASS = {}
local RewardUtil = require("Util.RewardUtil")
local LLActInfoData = require("DataCenter.Landlord.Data.LLActInfoData")
local LLServerData = require("DataCenter.Landlord.Data.LLServerData")
local LLRankPlayerData = require("DataCenter.Landlord.Data.LLRankPlayerData")
local LLRankAllianceData = require("DataCenter.Landlord.Data.LLRankAllianceData")
local LLTargetActInfoData = require("DataCenter.Landlord.Data.LLTargetActInfoData")

function _CLASS:InitAct()
  self.actData = nil
  self.actBuildInfo = nil
  self.rankPlayerList = {}
  self.rankAllianceList = {}
  self.haveBoxCanGet = nil
  self.oldIdx = LLConst.LandlordStage.UN_INIT
  self.targetActInfoDataMap = {}
  self.targetActInfoReqState = {}
end

function _CLASS:DeleteAct()
  self.haveBoxCanGet = nil
  if self.actData then
    self.actData:Delete()
    self.actData = nil
  end
  self.actBuildInfo = nil
  self.oldIdx = nil
  self:CleanRankData()
  self:ClearTargetActInfoCache()
end

function _CLASS:ReqActInfo(bRandomDelay)
  if bRandomDelay then
    TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.LandlordActInfo)
    end, math.random(0, 3))
  else
    SFSNetwork.SendMessage(MsgDefines.LandlordActInfo)
  end
end

function _CLASS:HandleActInfo(msg)
  if self.actData == nil then
    self.actData = LLActInfoData.New()
  end
  self.actData:ParseData(msg)
  self:InitBaseConfig()
  self.serverGroupCheckDirty = true
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  self.forcePartLastCheckSec = curSec
  self.forcePartHandledIdx = 0
  local list = self.actData.forcePartTime
  if list ~= nil then
    local maxIdx = #list
    for i = maxIdx, 1, -1 do
      local t = list[i] or 0
      if 0 < t and curSec >= t then
        self.forcePartHandledIdx = i
        break
      end
    end
  end
  self:StartStageTimer()
  self.haveBoxCanGet = self:CheckHaveBoxCanGet()
  EventManager:GetInstance():Broadcast(EventId.LandlordActInfoRefresh)
  local curStage = self.actData:GetCurStageInfo()
  local newIdx = curStage ~= nil and curStage.idx or 0
  if self.oldIdx ~= newIdx then
    EventManager:GetInstance():Broadcast(EventId.LandlordActStageChange)
    self:OnActStageChange(self.oldIdx)
    self:RefreshPlayerTypeCache()
  end
  self.oldIdx = newIdx
end

function _CLASS:GetActData()
  if self:IsInMyServerGroup() then
    return self.actData
  else
    return self:GetUsingTargetActData()
  end
end

function _CLASS:IsBigKing(ignoreKing)
  local sInfo = self:GetMyServerInfo()
  local isBigLord = sInfo ~= nil and sInfo.isBigLord
  local isKing = sInfo ~= nil and sInfo.king ~= nil and sInfo.king.uid == LuaEntry.Player:GetUid()
  if ignoreKing then
    isKing = true
  end
  return isBigLord and isKing
end

function _CLASS:IsBigFarmerKing(ignoreKing)
  local sInfo = self:GetMyServerInfo()
  local isBigFarmer = sInfo ~= nil and sInfo.isBigFarmer
  local king = sInfo ~= nil and sInfo.king or nil
  local isKing = king ~= nil and king.uid == LuaEntry.Player:GetUid()
  if ignoreKing then
    isKing = true
  end
  return isBigFarmer and isKing
end

function _CLASS:CheckBuffActive(id, camp)
  if self.actData ~= nil then
    local ids
    if camp == LLConst.LandLordGroup.LORD then
      ids = self.actData.landlordBuffIds
    elseif camp == LLConst.LandLordGroup.FARMER then
      ids = self.actData.farmerBuffIds
    end
    if ids ~= nil then
      for _, v in ipairs(ids) do
        if v == id then
          return true
        end
      end
    end
  end
  return false
end

function _CLASS:ReqActAllyMsg(msg)
  self._preAllyMsg = msg
  SFSNetwork.SendMessage(MsgDefines.LandlordActAllyMsg, msg)
end

function _CLASS:HandleActAllyMsg()
  if self.actData ~= nil then
    self.actData.allyMsg = self._preAllyMsg
  end
end

function _CLASS:CheckBeInvited()
  local stageInfo = self:GetActCurStageInfo()
  if stageInfo == nil or stageInfo.stage ~= LLConst.LandlordStage.GROUP then
    return false
  end
  if self:IsBigKing(true) or self:IsBigFarmerKing(true) then
    return false
  end
  local sInfo = self:GetMyServerInfo()
  if sInfo == nil or sInfo.group == LLConst.LandLordGroup.NONE then
    return false
  end
  local time = CommonUtil.PlayerPrefsGetInt(LLConst.SIGN_INVITATION_GROUP, 0)
  if time == 0 then
    return true, stageInfo.eTime
  end
  local actData = self:GetActData()
  local startTime = actData ~= nil and actData.startTime or 0
  return time < startTime, stageInfo.eTime
end

function _CLASS:SignBeInvited(isClean)
  if isClean then
    CommonUtil.PlayerPrefsSetInt(LLConst.SIGN_INVITATION_GROUP, 0)
  else
    local actData = self:GetActData()
    local startTime = actData ~= nil and actData.startTime or 0
    CommonUtil.PlayerPrefsSetInt(LLConst.SIGN_INVITATION_GROUP, startTime)
  end
  EventManager:GetInstance():Broadcast(EventId.LandlordActInfoRefresh)
end

function _CLASS:GetServerInfo(sId)
  local serverDic = self.actData ~= nil and self.actData.serverDic or nil
  return serverDic ~= nil and serverDic[sId] or nil
end

function _CLASS:IsSameGroupServer(sId)
  local myGroupId = self:GetMyGroup()
  local serverGroupId
  if self:IsInMyServerGroup() then
    local serverDic = self.actData ~= nil and self.actData.serverDic or nil
    local serverData = serverDic ~= nil and serverDic[sId] or nil
    if not serverData then
      return false
    end
    serverGroupId = serverData.group
  else
    local targetActData = self:GetUsingTargetActData()
    if targetActData == nil then
      return false
    end
    serverGroupId = targetActData:GetServerGroup(sId)
  end
  return serverGroupId == myGroupId
end

function _CLASS:GetMyServerInfo()
  return self:GetServerInfo(LuaEntry.Player:GetSourceServerId())
end

function _CLASS:GetMyGroup()
  if self:IsInMyServerGroup() then
    local sInfo = self:GetMyServerInfo()
    return sInfo ~= nil and sInfo.group or LLConst.LandLordGroup.NONE
  else
    return LLConst.LandLordGroup.LORD
  end
end

function _CLASS:GetServersByGroup(group)
  local list = {}
  local serverDic = self.actData ~= nil and self.actData.serverDic or nil
  if serverDic ~= nil then
    for _, v in pairs(serverDic) do
      if v.group == group then
        if v.isBigLord or v.isBigFarmer then
          table.insert(list, 1, v)
        else
          table.insert(list, v)
        end
      end
    end
  end
  table.sort(list, function(a, b)
    local aIsBig = a.isBigLord or a.isBigFarmer
    local bIsBig = b.isBigLord or b.isBigFarmer
    if aIsBig and not bIsBig then
      return true
    end
    if bIsBig and not aIsBig then
      return false
    end
    if a.rank ~= b.rank then
      return a.rank < b.rank
    end
    return a.serverId < b.serverId
  end)
  return list
end

function _CLASS:HandleServerJoined(msg)
  local sInfo = self:GetServerInfo(msg.serverId)
  if sInfo ~= nil and msg.type ~= nil then
    sInfo:SetGroup(msg.type)
    EventManager:GetInstance():Broadcast(EventId.LandlordActInfoRefresh)
  end
end

function _CLASS:ReqServerInvite(param)
  SFSNetwork.SendMessage(MsgDefines.LandlordServerInvite, param)
end

function _CLASS:HandleServerInvite(msg)
  local sId = msg.serverId
  local sInfo = self:GetServerInfo(sId)
  if sInfo ~= nil then
    sInfo:SetGroup(self:GetMyGroup())
    EventManager:GetInstance():Broadcast(EventId.LandlordActInfoRefresh)
    EventManager:GetInstance():Broadcast(EventId.LandlordServerInviteSuccess, sId)
    UIUtil.ShowTipsId("zonewar_landlord_tips_1004")
  end
end

function _CLASS:ReqServerGetInvitedInfo()
  SFSNetwork.SendMessage(MsgDefines.LandlordServerGetInvitedInfo)
end

function _CLASS:HandleServerGetInvitedInfo(msg)
  local sInfo = LLServerData.New()
  sInfo:ParseData(msg)
  local info = {sInfo = sInfo, isInvite = false}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLGroupInvitation, {anim = true}, info)
end

function _CLASS:GetCurGroupPartIndex()
  local actData = self:GetActData()
  if actData == nil or actData.forcePartTime == nil then
    return 0
  end
  local list = actData.forcePartTime
  local t1 = list[1] or 0
  local t2 = list[2] or 0
  local t3 = list[3] or 0
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  if 0 < t1 and t1 > curSec then
    return 1, t1
  end
  if 0 < t2 and t2 > curSec then
    return 2, t2
  end
  if 0 < t3 and t3 > curSec then
    return 3, t3
  end
  return 0
end

function _CLASS:GetCurGroupPartInfo()
  local actData = self:GetActData()
  if actData == nil then
    return nil
  end
  local idx, eTime = self:GetCurGroupPartIndex()
  if idx == 0 then
    return nil
  end
  local camp = LLConst.LandLordGroup.NONE
  if idx == 1 or idx == 3 then
    camp = LLConst.LandLordGroup.LORD
  elseif idx == 2 then
    camp = LLConst.LandLordGroup.FARMER
  end
  local bpNumber = actData.bpNumber or {}
  local totalLimit = self:GetCampCurLimit(camp)
  return {
    partIdx = idx,
    camp = camp,
    eTime = eTime or 0,
    curBp = bpNumber[idx] or 0,
    totalLimit = totalLimit
  }
end

function _CLASS:GetCampMaxTeammateCount(camp, includeBig)
  local maxMate = 0
  if camp == LLConst.LandLordGroup.LORD then
    local actData = self:GetActData()
    maxMate = actData ~= nil and actData.landlordNumber or 0
    if includeBig then
      local bigLordCnt = LLConst.INIT_BIG_LORD_COUNT
      maxMate = maxMate + bigLordCnt
    end
  elseif camp == LLConst.LandLordGroup.FARMER then
    local cntLord = self:GetCampMaxTeammateCount(LLConst.LandLordGroup.LORD, true)
    local totalMax = LLConst.MAX_GROUP_SERVER or 8
    maxMate = totalMax - cntLord
    if not includeBig then
      local bigFarmerCnt = LLConst.INIT_BIG_FARMER_COUNT
      maxMate = maxMate - bigFarmerCnt
    end
  end
  return math.max(maxMate, 0)
end

function _CLASS:GetCampCurLimit(camp)
  local actData = self:GetActData()
  if actData == nil then
    return 0
  end
  local bpNumber = actData.bpNumber or {}
  local total = 0
  local idx = self:GetCurGroupPartIndex()
  for i = 1, idx do
    local partCamp = LLConst.LandLordGroup.NONE
    if i == 1 or i == 3 then
      partCamp = LLConst.LandLordGroup.LORD
    elseif i == 2 then
      partCamp = LLConst.LandLordGroup.FARMER
    end
    if partCamp == camp then
      total = total + (bpNumber[i] or 0)
    end
  end
  local maxMate = self:GetCampMaxTeammateCount(camp)
  return math.min(total, maxMate)
end

function _CLASS:CleanRankData()
  self.rankPlayerList = nil
  self.rankAllianceList = nil
end

function _CLASS:TryGetRank(week, tabIdx, sType)
  if tabIdx == 1 then
    local weekDic = self.rankPlayerList ~= nil and self.rankPlayerList[week] or nil
    local stList = weekDic ~= nil and weekDic[sType] or nil
    if stList then
      return stList
    end
    self:ReqRankPersonal(week, sType - 1)
  elseif tabIdx == 2 then
    local weekDic = self.rankAllianceList ~= nil and self.rankAllianceList[week] or nil
    local stList = weekDic ~= nil and weekDic[sType] or nil
    if stList then
      return stList
    end
    self:ReqRankAlliance(week, sType - 1)
  end
end

function _CLASS:ReqRankPersonal(week, scoreType, startIdx, endIdx)
  SFSNetwork.SendMessage(MsgDefines.LandlordRankPersonal, week, scoreType, startIdx, endIdx)
end

function _CLASS:HandleRankPersonal(msg)
  local rankInfos = msg.rankInfo
  self.rankPlayerList = self.rankPlayerList or {}
  local week = msg.week or 1
  local sType = (msg.scoreType or 0) + 1
  local weekDic = self.rankPlayerList[week] or {}
  self.rankPlayerList[week] = weekDic
  local dic = weekDic[sType] or {}
  weekDic[sType] = dic
  dic.time = UITimeManager:GetInstance():GetServerTime()
  dic.week = week
  dic.scoreType = sType
  dic.myRank = msg.myRank or 0
  dic.myScore = msg.myScore or 0
  dic.totalCount = msg.totalCount or 0
  local list = dic.list or {}
  dic.list = list
  if rankInfos then
    for i, v in ipairs(rankInfos) do
      local data = list[i]
      if data == nil then
        data = LLRankPlayerData.New()
        list[i] = data
      end
      data:ParseData(v)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.LandlordRankRefresh, {
    week = week,
    tab = 1,
    sType = sType
  })
end

function _CLASS:ReqRankAlliance(week, scoreType)
  SFSNetwork.SendMessage(MsgDefines.LandlordRankAlliance, week, scoreType)
end

function _CLASS:HandleRankAlliance(msg)
  self.rankAllianceList = self.rankAllianceList or {}
  local week = msg.week or 1
  local sType = (msg.scoreType or 0) + 1
  local weekDic = self.rankAllianceList[week] or {}
  self.rankAllianceList[week] = weekDic
  local dic = weekDic[sType] or {}
  weekDic[sType] = dic
  dic.time = UITimeManager:GetInstance():GetServerTime()
  dic.week = week
  dic.scoreType = sType
  dic.myRank = msg.myAllianceRank or 0
  dic.myScore = msg.myAllianceScore or 0
  local list = dic.list or {}
  dic.list = list
  local rankInfos = msg.rankInfo
  if rankInfos then
    for i, v in ipairs(rankInfos) do
      local data = list[i]
      if data == nil then
        data = LLRankAllianceData.New()
        list[i] = data
      end
      data:ParseData(v)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.LandlordRankRefresh, {
    week = week,
    tab = 2,
    sType = sType
  })
end

function _CLASS:ReqActBattleInfo()
  SFSNetwork.SendMessage(MsgDefines.LandlordActBattleInfo)
end

function _CLASS:HandleActBattleInfo(msg)
  local dic = self.actBuildInfo or {}
  if self.actData ~= nil then
    self.actData.destroyScore = msg.destroyScore or 0
  end
  local builds = msg.builds
  if builds ~= nil then
    for _, v in ipairs(builds) do
      dic[v.configId] = v.percent or 0
    end
  end
  self.actBuildInfo = dic
  EventManager:GetInstance():Broadcast(EventId.LandlordActBattleInfo)
end

function _CLASS:GetDestroyScore()
  local actData = self:GetActData()
  return actData ~= nil and actData.destroyScore or 0
end

function _CLASS:GetActBattleBuildValue(configId)
  return self.actBuildInfo ~= nil and self.actBuildInfo[configId] or 0
end

function _CLASS:InBattleTime()
  return self:GetActCurStage() == LLConst.LandlordStage.BATTLE
end

function _CLASS:GetActCurStage()
  local info = self:GetActCurStageInfo()
  if info then
    return info.stage
  end
  return LLConst.LandlordStage.NONE
end

function _CLASS:IsInBattle()
  return self:GetActCurStage() == LLConst.LandlordStage.BATTLE
end

function _CLASS:GetActCurStageInfo()
  local actData = self:GetActData()
  local info = actData ~= nil and actData:GetCurStageInfo() or nil
  return info
end

function _CLASS:GetNextBattleStartTime(ignoreActEnd)
  local actData = self:GetActData()
  local time = actData ~= nil and actData:GetNextBattleStartTime(ignoreActEnd) or 0
  return time
end

function _CLASS:GetNextBattleEndTime(ignoreActEnd)
  local actData = self:GetActData()
  local time = actData ~= nil and actData:GetNextBattleEndTime(ignoreActEnd) or 0
  return time
end

function _CLASS:GetWeekBattleStartTime(week)
  local actData = self:GetActData()
  local time = actData ~= nil and actData:GetWeekBattleStartTime(week) or 0
  return time
end

function _CLASS:GetWeekBattleEndTime(week)
  local actData = self:GetActData()
  local time = actData ~= nil and actData:GetWeekBattleEndTime(week) or 0
  return time
end

function _CLASS:GetActStartTime()
  local actData = self:GetActData()
  local time = actData ~= nil and actData:GetActStartTime() or 0
  return time
end

function _CLASS:GetActStageInfo(stageIdx)
  local actData = self:GetActData()
  local info = actData ~= nil and actData:GetStageInfo(stageIdx) or nil
  return info
end

function _CLASS:GetCurWeek()
  local actData = self:GetActData()
  return actData ~= nil and actData.currentWeekNum or 0
end

function _CLASS:GetBattleWeek()
  local actData = self:GetActData()
  return actData ~= nil and actData.battleWeek or 3
end

function _CLASS:GetWeekCampScore(week, camp)
  local actData = self:GetActData()
  return actData ~= nil and actData:GetWeekCampScore(week, camp) or 0
end

function _CLASS:CheckShowGroupNews()
  local actData = self:GetActData()
  if actData == nil then
    return false
  end
  local signTime = CommonUtil.PlayerPrefsGetInt(LLConst.SIGN_ACT_GROUP_NEWS, 0)
  return signTime < actData.startTime
end

function _CLASS:SignGroupNewsFlag()
  CommonUtil.PlayerPrefsSetInt(LLConst.SIGN_ACT_GROUP_NEWS, UITimeManager:GetInstance():GetServerSeconds())
end

function _CLASS:GetCurBattleUuid()
  if self.actData ~= nil then
    return self.actData:GetCurBattleUuid()
  end
  return 0
end

function _CLASS:GetCurNineBoxInfo()
  local uuid = self:GetCurBattleUuid()
  if 0 < uuid then
    return RewardUtil.FetchHeroEventData(uuid)
  end
  return nil
end

function _CLASS:GetNineBoxScore()
  local info = self:GetCurNineBoxInfo()
  return info ~= nil and info.score or 0
end

function _CLASS:GetNineBoxState(idx)
  local boxes = self:GetNieBoxConfig()
  local boxConfig = boxes[idx]
  if boxConfig == nil then
    return 1
  end
  local curScore = self:GetNineBoxScore()
  if curScore < boxConfig.target then
    return 1
  end
  local info = self:GetCurNineBoxInfo()
  if info ~= nil and info.scoreRewardIndex ~= nil then
    for _, v in ipairs(info.scoreRewardIndex) do
      if v == idx - 1 then
        return 3
      end
    end
  end
  return 2
end

function _CLASS:CheckHaveBoxCanGet()
  local boxes = self:GetNieBoxConfig()
  for i, v in ipairs(boxes) do
    if self:GetNineBoxState(i) == 2 then
      return true
    end
  end
  return false
end

function _CLASS:ReqGetNineBox(idx)
  local bUuid = self:GetCurBattleUuid()
  if bUuid == 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.HeroEventClaimBoxReward, bUuid, idx - 1)
end

function _CLASS:HandleGetNineBox(uuid)
  local bUuid = self:GetCurBattleUuid()
  if bUuid == nil or bUuid ~= tonumber(uuid) then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.LandlordNineBoxRefresh)
  if self.haveBoxCanGet ~= self:CheckHaveBoxCanGet() then
    EventManager:GetInstance():Broadcast(EventId.LandlordRedRefresh)
  end
end

function _CLASS:HandleNineBoxUpdate(uuid)
  local bUuid = self:GetCurBattleUuid()
  if bUuid == nil or bUuid ~= tonumber(uuid) then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.LandlordNineBoxRefresh)
  if self.haveBoxCanGet ~= self:CheckHaveBoxCanGet() then
    EventManager:GetInstance():Broadcast(EventId.LandlordRedRefresh)
  end
end

function _CLASS:GetFreeMoveInfoEndTime()
  if self.actData then
    return self.actData.freeMoveInfoEndTime or 0
  end
  return 0
end

function _CLASS:SetFreeMoveInfoEndTime(time)
  if self.actData then
    self.actData.freeMoveInfoEndTime = time
    EventManager:GetInstance():Broadcast(EventId.LandlordFreeMvEndTimeUpdate)
  end
end

function _CLASS:GetPreviewBoomTime()
  local actData = self:GetActData()
  return actData and actData.previewStageBoomStartRaw or 0
end

function _CLASS:ReqTargetServerActInfo(centerServerId)
  if self.targetActInfoReqState[centerServerId] then
    return
  end
  self.targetActInfoReqState[centerServerId] = true
  SFSNetwork.SendMessage(MsgDefines.LandlordGetTargetActInfo, centerServerId)
end

function _CLASS:HandleTargetActInfo(msg, centerServerId)
  self.targetActInfoReqState[centerServerId] = nil
  if msg == nil then
    return
  end
  local actData = LLTargetActInfoData.New()
  actData:ParseData(msg.zwlActInfo)
  self.targetActInfoDataMap[centerServerId] = actData
  if actData.configId > 0 then
    self:RefreshBaseConfigById(actData.configId)
  end
  self:RefreshCenterMapRandomFxSystem()
end

function _CLASS:ReqTargetServerDestroyScore(serverId)
  local sid = serverId
  if sid == nil or sid == 0 then
    sid = self:GetCenterServerId()
  end
  if sid ~= nil and 0 < sid then
    SFSNetwork.SendMessage(MsgDefines.LandlordCrossGetDestroyScore, sid)
  end
end

function _CLASS:HandleTargetServerDestroyScore(msg)
  local data = self:GetTargetServerActData(msg.serverId)
  if data ~= nil then
    data.destroyScore = msg.destroyScore
    EventManager:GetInstance():Broadcast(EventId.LandlordActBattleInfo)
  end
end

function _CLASS:GetTargetServerActData(centerServerId)
  if centerServerId == nil or centerServerId == 0 then
    return nil
  end
  return self.targetActInfoDataMap[centerServerId]
end

function _CLASS:GetUsingTargetActData()
  local centerServerId = self:GetCenterServerId()
  if 0 < centerServerId then
    return self.targetActInfoDataMap[centerServerId]
  end
  return nil
end

function _CLASS:ClearTargetActInfoCache()
  for _, data in pairs(self.targetActInfoDataMap) do
    if data then
      data:Delete()
    end
  end
  self.targetActInfoDataMap = {}
  self.targetActInfoReqState = {}
end

function _CLASS:CheckWeekRewardState(rewardConfig, camp)
  local t = rewardConfig ~= nil and rewardConfig.type or 0
  if t ~= LLConst.RewardType.Week then
    return 0
  end
  local curWeek = math.max(self:GetCurWeek(), 1)
  local week = rewardConfig.para[1]
  if curWeek < week then
    return 0
  end
  if week == curWeek and self:GetActCurStage() ~= LLConst.LandlordStage.REST then
    return 1
  end
  local score = rewardConfig.para[2]
  for i = 1, curWeek do
    local weekScore = self:GetWeekCampScore(i, camp)
    if score <= weekScore then
      return 2
    end
  end
  return 1
end

function _CLASS:DescriptionAct(sb)
  sb:AppendLine("-----\230\180\187\229\138\168\228\191\161\230\129\175\229\188\128\229\167\139-----")
  sb:AppendLine()
  local time = CommonUtil.PlayerPrefsGetInt(LLConst.SIGN_INVITATION_GROUP, 0)
  sb:AppendFormatLine("\230\156\172\229\156\176\229\173\152\229\130\168\232\162\171\233\130\128\232\175\183\230\159\165\231\156\139\231\154\132\232\174\176\229\189\149\230\151\182\233\151\180 = %s (%s)", UITimeManager:GetInstance():GetServerTimeByUTC(time * 1000), time)
  sb:AppendLine()
  if self.actData ~= nil then
    self.actData:Description(sb)
  end
  sb:AppendLine("-----\230\180\187\229\138\168\228\191\161\230\129\175\231\187\147\230\157\159-----")
end

return _CLASS
