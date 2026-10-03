local AllianceBaseDataManager = BaseClass("AllianceBaseDataManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.autoRallyInfo = nil
  self.allianceBaseData = nil
  self.showMoveTipTimes = 0
  self.alMoveCenterPointId = nil
  self.moveInviteInfo = nil
  DataCenter.AllianceScienceDataManager:InitData()
  self.joinAllianceCdTime = 0
  self.isFirstTimeJoin_NewbeeMoveCityOnline = false
  self.noticeEditCDCfg = nil
end

local function __delete(self)
  self.allianceBaseData = nil
  self.autoRallyInfo = nil
  self.showMoveTipTimes = nil
  self.alMoveCenterPointId = nil
  self.translateMsg = nil
  self.isTranslating = nil
  self.tanslateFinish = nil
  self.joinAllianceCdTime = nil
  self.isFirstTimeJoin_NewbeeMoveCityOnline = nil
  self.noticeEditCDCfg = nil
end

local function OnEnterGame(self)
  if self.allianceBaseData == nil then
    SFSNetwork.SendMessage(MsgDefines.LoginOther, "alliance")
  else
    SFSNetwork.SendMessage(MsgDefines.GetAllianceAutoJoinRallyInfo)
  end
end

local function GetAllianceChatRoomId()
  local chatRoomManager = ChatInterface.getRoomMgr()
  local roomList = chatRoomManager:GetSortRoomDatas()
  for i, roomdata in ipairs(roomList) do
    if roomdata.group == "alliance" then
      return roomdata.roomId
    end
  end
end

local function OpenAllinceChatRoom()
  local roomId = GetAllianceChatRoomId()
  if roomId then
    GoToUtil.OpenChatView(false, {anim = false, immediately = true}, {roomId = roomId})
  end
end

local lastHighFiveTime = -1

local function SendHighFiveToAlliance()
  if CoppaUtil.IsCoppaLimit() then
    return
  end
  OpenAllinceChatRoom()
  
  local function sendMsgFunc()
    local roomId = GetAllianceChatRoomId()
    if roomId then
      local gender = LuaEntry.Player.gender or 1
      local sendData = gender == 1 and LuaEntry.DataConfig:TryGetStr("first_join_alliance_reward", "k2") or LuaEntry.DataConfig:TryGetStr("first_join_alliance_reward", "k3")
      if not string.IsNullOrEmpty(sendData) then
        local sendDataArray = string.split(sendData, ";")
        if sendDataArray ~= nil and 0 < #sendDataArray then
          local randomIndex = math.random(1, #sendDataArray)
          local key = sendDataArray[randomIndex]
          local sendMsg = Localization:GetString(key)
          local now = UITimeManager:GetInstance():GetServerTime()
          if now - lastHighFiveTime < 500 then
            return
          end
          lastHighFiveTime = now
          if not string.IsNullOrEmpty(sendMsg) then
            SFSNetwork.SendMessage(MsgDefines.AlJoinmsg, {
              msg = sendMsg,
              allianceId = LuaEntry.Player.allianceId
            })
          end
        end
      end
    end
  end
  
  UIUtil.ShowMessage(Localization:GetString("455126"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    sendMsgFunc()
  end, function()
  end, nil, 455125)
end

local function GotoAssemblyPoint()
  SFSNetwork.SendMessage(MsgDefines.GoToWorld)
  TimerManager:GetInstance():DelayInvoke(function()
    SendHighFiveToAlliance()
  end, 6)
end

local function MoveToAssemblyPoint()
  local gotoPointIndex = LuaEntry.Player:GetMainWorldPos()
  local markInfo = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint()
  if markInfo then
    gotoPointIndex = markInfo:GetPointIndex()
  end
  if gotoPointIndex == nil or gotoPointIndex == 0 or gotoPointIndex < 0 then
    gotoPointIndex = 200200
  end
  local position = SceneUtils.TileIndexToWorld(gotoPointIndex, ForceChangeScene.World)
  GoToUtil.GotoPos(position, MoveCityCameraHeight, nil, function()
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = 2814,
      hideMainUI = false,
      callback = GotoAssemblyPoint
    })
  end, LuaEntry.Player:GetSelfServerId())
end

local function Coalize()
  if ChatInterface.IsJoinAlHighFiveOpen() then
    if LuaEntry.Player.isFirstJoin == 1 then
      SceneUtils.ChangeToWorld(function()
        MoveToAssemblyPoint()
      end, nil, true)
    else
      SendHighFiveToAlliance()
    end
  else
    SendHighFiveToAlliance()
  end
end

local function UpdateAllianceBaseData(self, message, requestFlag, isLoginMessage)
  local allianceChanged = false
  if message.alliance ~= nil then
    local cacheAlId = self.allianceBaseData and self.allianceBaseData.uid or ""
    self.allianceBaseData = self.allianceBaseData and self.allianceBaseData or AllianceBaseInfo.New()
    self.allianceBaseData:ParseData(message.alliance, true)
    local allianceId = self.allianceBaseData.uid
    CS.GameEntry.Data.Player:SetAllianceLeaderID(self.allianceBaseData and self.allianceBaseData.leaderUid or "")
    if message.alliance and next(message.alliance) == nil then
      DataCenter.AllianceBaseDataManager:ResetAllianceData()
    end
    if LuaEntry.Player ~= nil then
      LuaEntry.Player:SetAllianceUid(allianceId)
    end
    if cacheAlId ~= allianceId then
      allianceChanged = true
      if not isLoginMessage then
        self.isFirstTimeJoin_NewbeeMoveCityOnline = true
      end
      if allianceId ~= nil and allianceId ~= "" and DataCenter.SeasonAllyFriendManager:CanMakeFriends() then
        SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyInfo, allianceId)
        DataCenter.SeasonAllyFriendManager:GetAllyCombinedList(true, false)
      end
    end
    if message.alliance and next(message.alliance) then
      DataCenter.AllianceMemberDataManager:SetCurMembers(message.alliance.curMember)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceBaseDataUpdated)
  if allianceChanged then
    SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceMark)
    DataCenter.AllianceMemberDataManager:TryInitMemberList(true)
    if LuaEntry.Player:IsInAlliance() then
      DataCenter.AllianceAutoInviteManager:ClearAllInvite()
      if SeasonUtil.IsInSeason() then
        SFSNetwork.SendMessage(MsgDefines.FetchCityAttachmentList)
      end
      local leagueMatchStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
      if leagueMatchStage ~= LeagueMatchStage.None then
        DataCenter.LeagueMatchManager:GetMyMatchInfoReq()
      end
    else
      DataCenter.LeagueMatchManager:ResetMyDuelInfo()
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshAllianceArmsUI)
    local allianceCompete = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if allianceCompete and allianceCompete.activityId then
      DataCenter.ActivityController:SendActivitySingleScoreGetCommand(allianceCompete.activityId)
    end
    SFSNetwork.SendMessage(MsgDefines.GetAllianceWarList, LuaEntry.Player:GetCurServerId())
    SFSNetwork.SendMessage(MsgDefines.AlGetjoinmsg)
    DataCenter.AllianceAlertDataManager:InitData()
    DataCenter.AllianceDeclareWarManager:InitSend()
    local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("alliancescience_entrance")
    local unlock = self:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceScience)
    if isSwitchOn and unlock then
      DataCenter.AllianceScienceDataManager:InitData()
      SFSNetwork.SendMessage(MsgDefines.AllScienceRefresh)
    end
    DataCenter.AllianceTaskManager:RequestTaskInfo()
    DataCenter.AllianceSeasonTaskManager:RequestTaskInfo()
    SFSNetwork.SendMessage(MsgDefines.GetAllianceAutoJoinRallyInfo)
    DataCenter.ActDispatchTaskDataManager:GetAllAllianceTasksFromServer()
    DataCenter.ActDispatchTaskDataManager:SendGetMarkList(true)
    DataCenter.LWActivityAlarmClockManager:TrySendGetActivityAlarmClockDataMsg()
    DataCenter.DailyTaskManager:TryReqUpdateData()
    self:OnAllianceStateChanged()
    EventManager:GetInstance():Broadcast(EventId.Al_LockHartActivityTip)
  elseif requestFlag then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceWarList, LuaEntry.Player:GetCurServerId())
    local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("alliancescience_entrance")
    local unlock = self:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceScience)
    if isSwitchOn and unlock then
      DataCenter.AllianceScienceDataManager:InitData()
      SFSNetwork.SendMessage(MsgDefines.AllScienceRefresh)
    end
    DataCenter.LWActivityAlarmClockManager:TrySendGetActivityAlarmClockDataMsg()
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
end

function AllianceBaseDataManager:OnAllianceStateChanged()
  CrossServerUtil.TryGetCrossEnableServerList(true)
  SceneUtils.ClearALMemberPoints()
  SceneUtils.WorldSendGetALPointsRequest()
end

local function UpdateMoveInviteInfo(self, t)
  if t.moveInviteInfo then
    self.moveInviteInfo = t.moveInviteInfo
  end
  EventManager:GetInstance():Broadcast(EventId.OnGetAlMoveInvite)
end

local function CheckIfShowInviteBtn(self)
  if not self.allianceBaseData or not self.moveInviteInfo then
    self:ResetMoveCityInviteInfo()
    return false
  end
  if not self.moveInviteInfo.allianceId or self.moveInviteInfo.allianceId ~= self.allianceBaseData.uid then
    self:ResetMoveCityInviteInfo()
    return false
  end
  if self:CheckIfIsVirtualLeader() then
    self:ResetMoveCityInviteInfo()
    return false
  end
  local leaderInfo = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(self.allianceBaseData.leaderUid)
  local leaderPoint = leaderInfo and leaderInfo.pointId or 0
  if leaderPoint <= 0 then
    self:ResetMoveCityInviteInfo()
    return false
  end
  local distance = SceneUtils.TileDistanceToMyHome(leaderPoint)
  local confDistance = LuaEntry.DataConfig:TryGetNum("union_move", "k1")
  if distance <= confDistance then
    self:ResetMoveCityInviteInfo()
    return false
  end
  local strKey = "AllianceMoveInviteTime_" .. LuaEntry.Player.uid
  local lastInviteTime = CS.GameEntry.Setting:GetInt(strKey, 0)
  local tempInviteTime = math.modf(self.moveInviteInfo.inviteTime / 1000)
  if lastInviteTime ~= tempInviteTime then
    return true
  else
    return false
  end
end

local function ResetMoveCityInviteInfo(self)
  if self.moveInviteInfo and self.moveInviteInfo.inviteTime then
    local tempTime = math.modf(self.moveInviteInfo.inviteTime / 1000)
    local strKey = "AllianceMoveInviteTime_" .. LuaEntry.Player.uid
    CS.GameEntry.Setting:SetInt(strKey, tempTime)
  end
end

local function UpdateLeaderElectStatus(self, candidate)
  self.allianceBaseData.elected = candidate
end

local function UpdateLeaderVoteStatus(self, voted)
  self.allianceBaseData.voted = voted
end

local function UpdateAlSysState(self, tempState, stateEndTime)
  self.allianceBaseData.sysAlState = tempState
  self.allianceBaseData.stateEndTime = stateEndTime
end

local function GetAllianceBaseData(self)
  return self.allianceBaseData
end

local function CheckIfIsVirtualLeader(self)
  return self.allianceBaseData.leaderUid == ""
end

local function ResetAllianceData(self, t)
  self.allianceBaseData = AllianceBaseInfo.New()
  LuaEntry.Player:SetAllianceUid("")
  self:ResetMoveCityInviteInfo()
  DataCenter.WorldFavoDataManager:ClearAllianceMarks()
  DataCenter.AllianceRallyPointDataManager:ClearAll()
  DataCenter.AllianceRedPacketManager:ClearRedPacket()
  DataCenter.AllianceLogManager:ClearAllianceLog()
  DataCenter.AllianceCityLogManager:ClearAllianceLog()
  DataCenter.AllianceGiftDataManager:ResetData()
  DataCenter.AllianceAlertDataManager:ResetData()
  DataCenter.AllianceWarDataManager:ResetData()
  DataCenter.AllianceHelpDataManager:ResetData()
  DataCenter.AllianceNoticeManager:RemoveAllNoticen()
  DataCenter.LeagueMatchManager:ResetMyDuelInfo()
  DataCenter.LWAllyStationDataManager:RecMsgPushAllianceLeave()
  DataCenter.AllianceScienceDataManager:OnLeaveAlliance()
  DataCenter.WorldAllianceCityDataManager:OnLeaveAlliance()
  DataCenter.AllianceMineManager:OnLeaveAlliance()
  DataCenter.AllianceSeasonTaskManager:OnLeaveAlliance()
  DataCenter.AllianceTaskManager:OnLeaveAlliance()
  DataCenter.LWActivityAlarmClockManager:OnLeaveAlliance()
  DataCenter.SeasonFarmerManager:OnLeaveAlliance()
  DataCenter.AllianceStarManager:OnLeaveAlliance()
  DataCenter.ActDragonManager:OnLeaveAlliance()
  DataCenter.ActEpidemicZoneManager:OnLeaveAlliance()
  DataCenter.BattlefieldDsbDuelManager:OnLeaveAlliance()
  DataCenter.SeasonAllyFriendManager:CleanData()
  EventManager:GetInstance():Broadcast(EventId.OnGetAlMoveInvite)
  EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
  EventManager:GetInstance():Broadcast(EventId.AllianceBaseDataUpdated)
  EventManager:GetInstance():Broadcast(EventId.AllianceQuitOK)
  EventManager:GetInstance():Broadcast(EventId.Al_LockHartActivityTip)
  if CS.SceneManager.World then
    CS.SceneManager.World:CheckNeedRefreshRoad()
    if SceneUtils.GetIsInWorld() then
      CS.SceneManager.World:SetFirstViewRequestFlag(true)
      CS.SceneManager.World:UpdateViewRequest(true)
      CS.SceneManager.World:CleanAllianceCacheData()
    end
  end
  DataCenter.WorldMarchDataProxy:CleanAllianceMembersHomePos()
  self:ClearJoinAllianceCdTimeData()
  if t and t.lastUpdateTime then
    LuaEntry.Player:SetLastUpdateTime(t.lastUpdateTime)
  end
  DataCenter.DailyTaskManager:TryReqUpdateData()
  self:OnAllianceStateChanged()
end

local function SetAnnounce(self, announce)
  if self.allianceBaseData and self.allianceBaseData.announce ~= announce then
    self.allianceBaseData:SetTranslationMsg("")
    self.allianceBaseData:SetIsTranslating(false)
    self.allianceBaseData:SetTranslateFinishState(0)
    self.allianceBaseData.announce = announce
  end
end

local function SetIntro(self, intro)
  if self.intro and self.allianceBaseData.intro ~= intro then
    self.allianceBaseData.intro = intro
  end
end

local function IsSelfLeader(self)
  local myUid = LuaEntry.Player.uid
  local isLeader = false
  if self.allianceBaseData ~= nil and myUid == self.allianceBaseData.leaderUid then
    isLeader = true
  end
  return isLeader
end

local function IsR5(self)
  local isR5 = false
  if self.allianceBaseData ~= nil and self.allianceBaseData.rank >= 5 then
    isR5 = true
  end
  return isR5
end

local function IsR4orR5(self)
  local isR4orR5 = false
  if self.allianceBaseData ~= nil and self.allianceBaseData.rank >= 4 then
    isR4orR5 = true
  end
  return isR4orR5
end

local function OnRecvAlPoints(self, nearestP, centerPointId, forCalc)
  self.alMoveCenterPointId = centerPointId
  nearestP = centerPointId
  if forCalc == 1 then
    if nearestP ~= 0 then
      if DataCenter.GuideManager:InGuide() then
        self:ResetShowMoveTipTimes()
      else
        if self.checkRallyParams then
          local recommendPos = SceneUtils.IndexToTilePos(nearestP)
          local selfWorldId = LuaEntry.Player:GetMainWorldPos()
          local rallyTargetPos = SceneUtils.IndexToTilePos(selfWorldId)
          local distance = math.ceil(SceneUtils.TileDistance(recommendPos, rallyTargetPos))
          local confDist = LuaEntry.DataConfig:TryGetNum("union_move", "k1")
          local mainLv = DataCenter.BuildManager.MainLv
          local showTiplv = LuaEntry.DataConfig:TryGetNum("teleport_tips_max_HQ_level", "k1")
          if distance > confDist and mainLv <= showTiplv then
            local isFree = UIUtil.IsFreeMoveCityInOpenServerTime()
            if isFree then
              UIUtil.OpenFreeMoveCityInOpenServerTimeConfirmPanel()
            else
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIMoveCityTip, {anim = true}, {
                openType = 1,
                isInviteMove = false,
                strTip = Localization:GetString("391098")
              })
            end
          elseif self.checkRallyParams.callback then
            self.checkRallyParams.callback()
          end
          self.checkRallyParams = nil
        end
        EventManager:GetInstance():Broadcast(EventId.OnGetRecommendAlPoint, nearestP)
      end
    end
  elseif nearestP == 0 then
    UIUtil.ShowTipsId(390849)
  else
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    MoveCityUtil.TryShowMoveCityModel(PlaceBuildType.MoveCity_Al, mySourceServerId, nearestP)
  end
end

local function CheckIfCanAlMove(self, pointId)
  if not self.alMoveCenterPointId or self.alMoveCenterPointId == 0 then
    return false
  else
    local radius = LuaEntry.DataConfig:TryGetNum("Alliance_relocation_scope", "k1")
    local centerPointPos = SceneUtils.IndexToTilePos(self.alMoveCenterPointId)
    local targetPos = SceneUtils.IndexToTilePos(pointId)
    local distance = math.ceil(SceneUtils.TileDistance(centerPointPos, targetPos))
    return radius >= distance
  end
end

local function GetSelfRank(self)
  return self.allianceBaseData and self.allianceBaseData.rank or 0
end

local function GetSelfComprehensiveScore(self)
  return self.allianceBaseData and self.allianceBaseData.comprehensiveScore or 0
end

local function SetSelfRank(self, value)
  if self.allianceBaseData and self.allianceBaseData.rank ~= value then
    self.allianceBaseData.rank = value
    EventManager:GetInstance():Broadcast(EventId.Al_UpdateSelfRank)
  end
end

local function SetSelfRankInfo(self, info)
  if self.allianceBaseData and info.rankTime and self.allianceBaseData.rankTime ~= info.rankTime then
    self.allianceBaseData.rankTime = info.rankTime
  end
  if self.allianceBaseData and self.allianceBaseData.rank ~= info.rank then
    self.allianceBaseData.rank = info.rank
    EventManager:GetInstance():Broadcast(EventId.Al_UpdateSelfRank)
  end
end

local function CheckIfCanPayAsLeader(self)
  if string.IsNullOrEmpty(self.allianceBaseData.leaderUid) then
    return true
  end
  return false
end

local function CheckIfIsAlWaitMerge(self)
  return self.allianceBaseData and self.allianceBaseData.waitMerge == 1
end

local function CheckIfNeedSettingTip(self)
  local allianceData = self.allianceBaseData
  if allianceData and allianceData.createdByPlayer then
    return
  end
  local showTip = self:IsR4orR5()
  if showTip and (allianceData.rename == 0 or allianceData.abbrRename == 0 or string.IsNullOrEmpty(allianceData.intro)) then
    return true
  end
end

local function UpdateAlWaitMergeStatus(self, waitMerge)
  if self.allianceBaseData then
    self.allianceBaseData.waitMerge = waitMerge
    if waitMerge == 1 then
      self.allianceBaseData.leaderUid = nil
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AlWaitMergeStatusChange)
end

local function UpdateAllianceSetting(self, message)
  if self.allianceBaseData ~= nil then
    self.allianceBaseData:RefreshAllianceSetting(message)
  end
end

local function CheckIfAllianceFuncOpen(self, funcType)
  local allianceTaskOpen = LuaEntry.DataConfig:CheckSwitch("alliance_task")
  if not allianceTaskOpen then
    return true
  end
  if funcType == AllianceTaskFuncType.AllianceScience then
    return true
  end
  if self.allianceBaseData then
    return self.allianceBaseData:CheckIfAllianceFuncOpen(funcType)
  end
end

local function UpdateAutoRallyInfo(self, msg, needBroadcast)
  if needBroadcast == nil then
    needBroadcast = true
  end
  if not self.autoRallyInfo then
    self.autoRallyInfo = {}
  end
  if msg.endTime then
    self.autoRallyInfo.endTime = msg.endTime
  else
    self.autoRallyInfo.endTime = 0
  end
  if msg.index then
    self.autoRallyInfo.curPos = msg.index
  end
  if needBroadcast then
    EventManager:GetInstance():Broadcast(EventId.UpdateAllianceAutoRallyInfo)
  end
end

local function GetAutoRallyInfo(self)
  return self.autoRallyInfo
end

local function CheckIfShowAutoRallyRed(self)
  if not LuaEntry.Player:IsInAlliance() then
    return 0
  end
  local autoRallyOpen = LuaEntry.DataConfig:CheckSwitch("world_auto_join")
  if autoRallyOpen then
    local killedNum = DataCenter.MonsterManager:GetKillBossNum()
    local maxNum = DataCenter.MonsterManager:GetMaxKillBossNum()
    if killedNum < maxNum then
      local serverTime = UITimeManager:GetInstance():GetServerTime()
      local autoInfo = DataCenter.AllianceBaseDataManager:GetAutoRallyInfo()
      if autoInfo and serverTime > autoInfo.endTime then
        return 1
      else
        return 0
      end
    else
      return 0
    end
  end
  return 0
end

local function CheckIfNeedMoveTipOnOpen(self)
  if not self.allianceBaseData then
    return false
  end
  if LuaEntry.Player:GetMainWorldPos() <= 0 then
    return false
  end
  local days = LuaEntry.DataConfig:TryGetNum("union_move", "k2")
  local edgeTime = self.allianceBaseData.createTime + days * 86400000
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if edgeTime > curTime and self.showMoveTipTimes == 0 then
    return true
  end
  local strKey = "AlMoveRecommendTip_" .. LuaEntry.Player.uid
  local curAlId = LuaEntry.Player.allianceId
  local lastAlId = CS.GameEntry.Setting:GetString(strKey, "")
  local isSelfLeader = DataCenter.AllianceBaseDataManager:IsSelfLeader()
  if curAlId ~= lastAlId and not isSelfLeader then
    return true
  end
  return false
end

local function UpdateShowMoveTipTimes(self, times)
  self.showMoveTipTimes = times
  local strKey = "AlMoveRecommendTip_" .. LuaEntry.Player.uid
  local curAlId = LuaEntry.Player.allianceId
  CS.GameEntry.Setting:SetString(strKey, curAlId)
end

local function CheckIfNeedCheckRallyDistance(self)
  return not self.checkedRallyDist
end

local function TryCheckRallyDist(self, params)
  self.checkRallyParams = params
  SFSNetwork.SendMessage(MsgDefines.WorldAlMove, 1)
  self.checkedRallyDist = true
end

local function ResetShowMoveTipTimes(self)
  self.showMoveTipTimes = 0
  local strKey = "AlMoveRecommendTip_" .. LuaEntry.Player.uid
  CS.GameEntry.Setting:SetString(strKey, "")
end

local function UpdateAccPoint(self, accPointNew, flyFromPos, flyToPos, isOnlyDisperse, isOnlyShowDiff)
  if self.allianceBaseData ~= nil then
    local isDiff = self.allianceBaseData.accPoint ~= accPointNew
    if isDiff then
      self.allianceBaseData.accPoint = accPointNew
      DataCenter.AllianceShopDataManager:SetAccPoint(accPointNew)
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
    end
    if (isDiff or not isOnlyShowDiff) and flyFromPos ~= nil then
      local iconPath2 = DataCenter.ItemTemplateManager:GetAllianceItemIconPath(RewardType.ALLIANCE_DONATE)
      if flyToPos == nil then
        flyToPos = UIUtil.GetAllianceItemPos(RewardType.ALLIANCE_DONATE)
      end
      UIUtil.DoFly(RewardType.GOODS, 3, iconPath2, flyFromPos, flyToPos, nil, nil, nil, nil, nil, nil, nil, isOnlyDisperse)
      DataCenter.LWSoundManager:PlaySound(62305, false)
    end
  end
end

function AllianceBaseDataManager:UpdateResource(alResItem)
  if alResItem and self.allianceBaseData then
    local resStone = self.allianceBaseData.resStone or 0
    local resCoal = self.allianceBaseData.resCoal or 0
    local resFarmerExp = self.allianceBaseData.resFarmerExp or 0
    for k, v in pairs(alResItem) do
      if toInt(k) == ResourceType.AllianceStone then
        self.allianceBaseData.resStone = toInt(v)
      elseif toInt(k) == ResourceType.AllianceCoal then
        self.allianceBaseData.resCoal = toInt(v)
      elseif toInt(k) == ResourceType.AllianceFarmerExp then
        self.allianceBaseData.resFarmerExp = toInt(v)
      end
    end
    if resStone ~= self.allianceBaseData.resStone or resCoal ~= self.allianceBaseData.resCoal or resFarmerExp ~= self.allianceBaseData.resFarmerExp then
      EventManager:GetInstance():DelayBroadcast(1, EventId.AllianceResourceUpdate)
    end
  end
end

function AllianceBaseDataManager:IsFarmerInSeason()
  return DataCenter.SeasonFarmerManager:IsActive()
end

function AllianceBaseDataManager:UpdateJoinAllianceCdTimeData(cdTime)
  self.joinAllianceCdTime = cdTime
  EventManager:GetInstance():Broadcast(EventId.UpdateJoinAllianceCdTime)
end

function AllianceBaseDataManager:ClearJoinAllianceCdTimeData()
  self.joinAllianceCdTime = 0
end

function AllianceBaseDataManager:IsInJoinAllianceCdTime(showTips)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.joinAllianceCdTime > 0 and curTime < self.joinAllianceCdTime then
    if showTips then
      local surplusTime = self.joinAllianceCdTime - curTime
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime)
      local tips = Localization:GetString("alliance_tips_rejoin_cd", timeStr)
      UIUtil.ShowTips(tips)
    end
    return true
  end
  return false
end

function AllianceBaseDataManager:CanSetAllianceCityRallyBySiegePoint(data)
  local openStr = LuaEntry.DataConfig:TryGetStr("free_teleport_time", "k5")
  if not string.IsNullOrEmpty(openStr) then
    local openList = string.split(openStr, ";")
    if data and data.type and table.hasvalue(openList, tostring(data.type)) and UIUtil.CanPutAllianceRallyPoint(data.pointId, data.serverId) then
      return true
    end
  end
  return false
end

function AllianceBaseDataManager:CanSetAllianceCityRallyByAlliancePoint(data)
  local openStr = LuaEntry.DataConfig:TryGetStr("free_teleport_time", "k6")
  if not string.IsNullOrEmpty(openStr) then
    local openList = string.split(openStr, ";")
    if data and data.type and table.hasvalue(openList, tostring(data.type)) and UIUtil.CanPutAllianceRallyPoint(data.pointId, data.serverId) then
      return true
    end
  end
  return false
end

function AllianceBaseDataManager:TrySetRally(pointId, serverId)
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(393055)
    return
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId(143604)
    return
  end
  TileBubbleManager:GetInstance().TrySetRally(pointId, serverId)
end

function AllianceBaseDataManager:GetAveragePower()
  if self.allianceBaseData then
    return self.allianceBaseData.averagePower
  end
  return 0
end

function AllianceBaseDataManager:CheckEditCDPass()
  if self.allianceBaseData then
    return self.allianceBaseData:CheckEditCDPass()
  end
end

function AllianceBaseDataManager:GetNoticeEditCDCfg()
  if self.noticeEditCDCfg == nil then
    self.noticeEditCDCfg = {time = 0, num = 1}
    local configStr = LuaEntry.DataConfig:TryGetStr("alliance_announcement_edit", "k1")
    if not string.IsNullOrEmpty(configStr) then
      local data = string.string2array_num_oneSep(configStr, ";")
      if data and #data == 2 then
        self.noticeEditCDCfg.time = data[1]
        self.noticeEditCDCfg.num = data[2]
      end
    end
  end
  return self.noticeEditCDCfg
end

AllianceBaseDataManager.__init = __init
AllianceBaseDataManager.__delete = __delete
AllianceBaseDataManager.UpdateAllianceBaseData = UpdateAllianceBaseData
AllianceBaseDataManager.GetAllianceBaseData = GetAllianceBaseData
AllianceBaseDataManager.ResetAllianceData = ResetAllianceData
AllianceBaseDataManager.IsSelfLeader = IsSelfLeader
AllianceBaseDataManager.GetSelfRank = GetSelfRank
AllianceBaseDataManager.GetSelfComprehensiveScore = GetSelfComprehensiveScore
AllianceBaseDataManager.CheckIfCanAlMove = CheckIfCanAlMove
AllianceBaseDataManager.IsR5 = IsR5
AllianceBaseDataManager.IsR4orR5 = IsR4orR5
AllianceBaseDataManager.UpdateAllianceSetting = UpdateAllianceSetting
AllianceBaseDataManager.SetAnnounce = SetAnnounce
AllianceBaseDataManager.SetIntro = SetIntro
AllianceBaseDataManager.SetSelfRank = SetSelfRank
AllianceBaseDataManager.OnRecvAlPoints = OnRecvAlPoints
AllianceBaseDataManager.CheckIfIsVirtualLeader = CheckIfIsVirtualLeader
AllianceBaseDataManager.UpdateLeaderElectStatus = UpdateLeaderElectStatus
AllianceBaseDataManager.ResetMoveCityInviteInfo = ResetMoveCityInviteInfo
AllianceBaseDataManager.UpdateMoveInviteInfo = UpdateMoveInviteInfo
AllianceBaseDataManager.UpdateLeaderVoteStatus = UpdateLeaderVoteStatus
AllianceBaseDataManager.UpdateAlSysState = UpdateAlSysState
AllianceBaseDataManager.CheckIfIsAlWaitMerge = CheckIfIsAlWaitMerge
AllianceBaseDataManager.UpdateAlWaitMergeStatus = UpdateAlWaitMergeStatus
AllianceBaseDataManager.CheckIfNeedSettingTip = CheckIfNeedSettingTip
AllianceBaseDataManager.CheckIfCanPayAsLeader = CheckIfCanPayAsLeader
AllianceBaseDataManager.CheckIfAllianceFuncOpen = CheckIfAllianceFuncOpen
AllianceBaseDataManager.UpdateAutoRallyInfo = UpdateAutoRallyInfo
AllianceBaseDataManager.GetAutoRallyInfo = GetAutoRallyInfo
AllianceBaseDataManager.CheckIfShowAutoRallyRed = CheckIfShowAutoRallyRed
AllianceBaseDataManager.UpdateShowMoveTipTimes = UpdateShowMoveTipTimes
AllianceBaseDataManager.CheckIfNeedMoveTipOnOpen = CheckIfNeedMoveTipOnOpen
AllianceBaseDataManager.CheckIfShowInviteBtn = CheckIfShowInviteBtn
AllianceBaseDataManager.CheckIfNeedCheckRallyDistance = CheckIfNeedCheckRallyDistance
AllianceBaseDataManager.TryCheckRallyDist = TryCheckRallyDist
AllianceBaseDataManager.ResetShowMoveTipTimes = ResetShowMoveTipTimes
AllianceBaseDataManager.UpdateAccPoint = UpdateAccPoint
AllianceBaseDataManager.Coalize = Coalize
AllianceBaseDataManager.OnEnterGame = OnEnterGame
AllianceBaseDataManager.OpenAllinceChatRoom = OpenAllinceChatRoom
AllianceBaseDataManager.SetSelfRankInfo = SetSelfRankInfo
return AllianceBaseDataManager
