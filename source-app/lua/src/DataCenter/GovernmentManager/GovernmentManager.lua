local GovernmentManager = BaseClass("GovernmentManager")
local KingdomPositionInfo = require("DataCenter.GovernmentManager.KingdomPositionInfo")
local PresidentInfo = require("DataCenter.GovernmentManager.PresidentInfo")
local FakePresidentInfo = require("DataCenter.GovernmentManager.FakePresidentInfo")
local PresidentHistoryInfo = require("DataCenter.GovernmentManager.PresidentHistoryInfo")
local PresidentPresentInfo = require("DataCenter.GovernmentManager.PresidentPresentInfo")
local PresentRecordInfo = require("DataCenter.GovernmentManager.PresentRecordInfo")
local GovernmentConst = require("DataCenter.GovernmentManager.GovernmentConst")
local Localization = CS.GameEntry.Localization

function GovernmentManager:__init()
  self.curDataServerId = nil
  self.presidentInfo = nil
  self.presentRecord = {
    [ThroneType.Native] = PresentRecordInfo.New(),
    [ThroneType.Cross] = PresentRecordInfo.New()
  }
  self.kingHistoryList = nil
  self.presidentPresentInfo = {
    [ThroneType.Native] = PresidentPresentInfo.New(),
    [ThroneType.Cross] = PresidentPresentInfo.New()
  }
  self.self_positionId = 0
  self.activityServerData = {}
  self.CrossKingdomPositions = {}
  self.CrossKingdomPositionsDummy = {}
  self.KingOccupyPlayerDict = {}
  self.KingOccupyDict = {}
  self.ConquerData = {}
  self.CrossKingdomKing = {}
  self.kingdomPositionStartTime = 0
  self.kingdomPositionCountDown = 0
  self.receivedBattleEnd = false
  self:AddListener()
end

function GovernmentManager:__delete()
  self.presidentInfo = nil
  self.presentRecord = nil
  self.kingHistoryList = nil
  self.presidentPresentInfo = {}
  self.self_positionId = 0
  self.activityServerData = nil
  self.agreeInfo = nil
  self.kingdomPositionStartTime = nil
  self.kingdomPositionCountDown = nil
  self.receivedBattleEnd = nil
  self:RemoveListener()
end

function GovernmentManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
end

function GovernmentManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
end

function GovernmentManager:OnEnterWorld(data)
  local flag = false
  if LuaEntry.Player:IsInSourceServer() then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.KingActivity.Type)
    if actList and 0 < #actList then
      flag = true
    end
  end
  if flag then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local fightInfo = DataCenter.GovernmentManager:GetKingOccupyList(loginServerId)
    if fightInfo == nil then
      SFSNetwork.SendMessage(MsgDefines.GetKingOccupyProgress, loginServerId)
    end
  end
end

function GovernmentManager:OnEnterCity(data)
  local curPresident = DataCenter.GovernmentManager:GetCurPresident()
  if curPresident ~= nil then
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.KingActivity.Type)
    if 0 < #dataList then
      local hasOpened = CS.GameEntry.Setting:GetPrivateBool("OpenedKingOccupyPopup", false)
      if not hasOpened then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentActivityPopup, {
          anim = false,
          UIMainAnim = UIMainAnimType.AllHide
        }, true)
      end
    end
  end
end

function GovernmentManager:GetKingdomPositionsHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    end
    return
  end
  if not message.serverId then
    return
  end
  local serverId = message.serverId
  self.CrossKingdomPositions[serverId] = {}
  local ownPostionId = ""
  if message.positions then
    for _, v in ipairs(message.positions) do
      local position = KingdomPositionInfo.New()
      position:ParseData(v)
      if position.uid == LuaEntry.Player.uid and serverId == LuaEntry.Player:GetSourceServerId() then
        ownPostionId = v.positionId
      end
      self.CrossKingdomPositions[serverId][tonumber(v.positionId)] = position
    end
  end
  if serverId == LuaEntry.Player:GetSourceServerId() then
    DataCenter.OfficialApplyManager:SaveOwnPositionId(ownPostionId)
    if string.IsNullOrEmpty(ownPostionId) then
      ownPostionId = 0
    end
    if toInt(ownPostionId) ~= self.self_positionId then
      Logger.LogInfo(string.format("self_positionId diff old:%s ,new %s", self.self_positionId, ownPostionId))
      self:SetSelfPosition(ownPostionId)
    end
  end
  self.CrossKingdomPositionsDummy[serverId] = {}
  if message.conquerors then
    for _, v in ipairs(message.conquerors) do
      local position
      if tonumber(v.positionId) == GovernmentConst.King_Position_id then
        position = FakePresidentInfo.New()
      else
        position = KingdomPositionInfo.New()
      end
      position:ParseData(v)
      self.CrossKingdomPositionsDummy[serverId][tonumber(v.positionId)] = position
    end
  end
  if message.conquerorInfo then
    self.ConquerData[message.conquerorInfo.serverId] = message.conquerorInfo
  end
  EventManager:GetInstance():Broadcast(EventId.CrossKingdomPositionsRefresh)
  if serverId == LuaEntry.Player:GetSourceServerId() then
    EventManager:GetInstance():Broadcast(EventId.KingdomPositionInfoUpdate, false)
  end
  self:CheckAndSendKingdomPositionAutoAgree(LuaEntry.Player:GetSourceServerId())
end

function GovernmentManager:GetConquerorPositionByServerId(serverId)
  return self.CrossKingdomPositionsDummy[serverId]
end

function GovernmentManager:GetKingdomPositionByServerId(serverId)
  return self.CrossKingdomPositions[serverId]
end

function GovernmentManager:KingdomPositionAppoint(targetUid, positionId, type)
  SFSNetwork.SendMessage(MsgDefines.KingdomPositionAppoint, targetUid, positionId, type)
end

function GovernmentManager:KingdomPositionAppointHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    end
    return
  end
  self:UpdateOnePositionInSourceServer(message)
  local positionId = message.positionId
  if positionId then
    local data = self:GetPositionInfoByPositionId(toInt(positionId))
    if data == nil or string.IsNullOrEmpty(data.uid) then
      UIUtil.ShowTipsId(457063)
    else
      UIUtil.ShowTipsId(457064)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.KingdomPositionInfoUpdate, true)
  SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, LuaEntry.Player.serverId)
end

function GovernmentManager:kingdomPositionResignHandle(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    end
    return
  end
  self:UpdateOnePositionInSourceServer(message)
  EventManager:GetInstance():Broadcast(EventId.KingdomPositionInfoUpdate, true)
  SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, LuaEntry.Player.serverId)
end

function GovernmentManager:ChooseKing(targetUid)
  SFSNetwork.SendMessage(MsgDefines.ChooseKing, targetUid)
end

function GovernmentManager:ChooseKingHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    end
    return
  end
  self:UpdatePresidentInfo(message)
  EventManager:GetInstance():Broadcast(EventId.KingdomPresidentInfoUpdate)
  UIUtil.ShowTipsId(250127)
end

function GovernmentManager:InitData(msg)
  local serverId = LuaEntry.Player:GetSelfServerId()
  if self.curDataServerId ~= nil and self.curDataServerId ~= serverId then
    self.curDataServerId = serverId
    self.activityServerData = {}
    self.KingdomBadges = nil
    self.CrossKingOccupyList = nil
    DataCenter.GovernmentManager:GetKingInfo(serverId)
  elseif 0 < serverId then
    self.curDataServerId = serverId
    DataCenter.GovernmentManager:GetKingdomBadges()
    SFSNetwork.SendMessage(MsgDefines.GetKingInfo, serverId)
    SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, serverId)
    local sourceServerId = LuaEntry.Player:GetSourceServerId()
    if 0 < toInt(sourceServerId) and sourceServerId ~= serverId then
      SFSNetwork.SendMessage(MsgDefines.GetKingInfo, sourceServerId)
      SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, sourceServerId)
    end
    SFSNetwork.SendMessage(MsgDefines.GetKingdomPresentInfo, sourceServerId, ThroneType.Native)
    SFSNetwork.SendMessage(MsgDefines.GetKingdomPresentInfo, sourceServerId, ThroneType.Cross)
  end
  if msg.conquerorSendRedPack and msg.conquerorSendRedPack.popup and msg.conquerorSendRedPack.popup == 1 then
    DataCenter.UIPopWindowManager:Push(UIWindowNames.UICrossThroneSuccess, {anim = true}, msg.conquerorSendRedPack)
    self.conquerorSendRedPack = msg.conquerorSendRedPack
  end
  self:initSelfPosition(msg)
end

function GovernmentManager:UICrossThroneSuccessPop()
  DataCenter.UIPopWindowManager:Push(UIWindowNames.UICrossThroneSuccess, {anim = true}, self.conquerorSendRedPack)
end

function GovernmentManager:GetKingInfo(serverId)
  if serverId == nil or toInt(serverId) <= 0 then
    return
  end
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local curServerId = LuaEntry.Player:GetCurServerId()
  DataCenter.GovernmentManager:GetKingdomBadges()
  SFSNetwork.SendMessage(MsgDefines.GetKingInfo, serverId)
  SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, serverId)
  SFSNetwork.SendMessage(MsgDefines.GetKingdomActivityInfo)
  SFSNetwork.SendMessage(MsgDefines.GetKingOccupyProgress, serverId)
  if serverId ~= mySourceServerId then
    SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, mySourceServerId)
    SFSNetwork.SendMessage(MsgDefines.GetKingInfo, mySourceServerId)
    SFSNetwork.SendMessage(MsgDefines.GetKingOccupyProgress, mySourceServerId)
  end
  if serverId ~= loginServerId and mySourceServerId ~= loginServerId then
    SFSNetwork.SendMessage(MsgDefines.GetKingOccupyProgress, loginServerId)
  end
  if serverId ~= curServerId and mySourceServerId ~= curServerId and loginServerId ~= curServerId then
    SFSNetwork.SendMessage(MsgDefines.GetKingOccupyProgress, curServerId)
  end
  SFSNetwork.SendMessage(MsgDefines.GetKingdomPresentInfo, mySourceServerId, ThroneType.Native)
  SFSNetwork.SendMessage(MsgDefines.GetKingdomPresentInfo, mySourceServerId, ThroneType.Cross)
end

function GovernmentManager:OnKingdomActivityInfo(message)
  if message.errorCode ~= nil then
    return
  end
  self.activityServerData = message
  self.receivedBattleEnd = false
  EventManager:GetInstance():Broadcast(EventId.KingdomActivityUpdate)
end

function GovernmentManager:GetKingInfoHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    end
    return
  end
  self:UpdatePresidentInfo(message)
  EventManager:GetInstance():Broadcast(EventId.KingdomPresidentInfoUpdate)
end

function GovernmentManager:OnCrossServerKingInfo(t)
  if self.CrossServerKingInfo == nil then
    self.CrossServerKingInfo = {}
  end
  if t and t.serverInfo then
    for serverId, info in pairs(t.serverInfo) do
      local data = self.CrossServerKingInfo[serverId] or {}
      data.badges = info
      self.CrossServerKingInfo[serverId] = data
    end
  end
  if t and t.serverKing then
    for serverId, info in pairs(t.serverKing) do
      local data = self.CrossServerKingInfo[serverId] or {}
      local king = PresidentInfo.New()
      king:ParseData({kingInfo = info})
      if king.serverId and king.uid and king.uid ~= 0 and king.uid ~= "" then
        data.king = king
        self.CrossServerKingInfo[serverId] = data
      end
    end
  end
end

function GovernmentManager:GetCrossServerKingInfo(serverId)
  if self.CrossServerKingInfo == nil or serverId == nil then
    if serverId then
      local king = self.CrossKingdomKing[serverId]
      if king ~= nil and king.uid ~= nil and king.uid ~= "" then
        return {
          king = king,
          badges = {cfgId = 511001}
        }
      end
    end
    return nil
  end
  local info = self.CrossServerKingInfo[tostring(serverId)]
  if info ~= nil and (info.king == nil or info.king.uid == nil or info.king.uid == "") and self.CrossKingdomKing ~= nil then
    info.king = self.CrossKingdomKing[serverId]
  end
  return info
end

function GovernmentManager:ModifyKingDeclaration(str)
  if self:SwitchOpenOrAtHomeNow() then
    SFSNetwork.SendMessage(MsgDefines.ModifyKingDeclaration, str)
  else
    UIUtil.ShowTipsId(500019)
  end
end

function GovernmentManager:ModifyKingDeclarationHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    end
    return
  end
  UIUtil.ShowTipsId(120094)
  self:UpdatePresidentDeclarationInfo(message)
end

function GovernmentManager:GetKingdomPresentInfoHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    end
    return
  end
  self:UpdatePresentInfo(message)
end

function GovernmentManager:GetKingdomPresentRecordHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    end
    return
  end
  self:UpdatePresentRecord(message)
end

function GovernmentManager:KingSendPresent(uidArr, presentId)
  SFSNetwork.SendMessage(MsgDefines.KingSendPresent, uidArr, presentId)
end

function GovernmentManager:OnHandleKingBattleEnd(t)
  self.receivedBattleEnd = true
end

function GovernmentManager:KingOccupyPlayerHandler(message)
  if not message then
    return
  end
  local battleType = message.type
  local sendMsg = not battleType or battleType <= 1
  local serverId = toInt(message.serverId)
  if 0 < serverId then
    local fightInfo = DataCenter.GovernmentManager:GetKingOccupyList(serverId)
    if fightInfo ~= nil then
      for _, v in ipairs(fightInfo) do
        if v.aId == message.aId and message.startTime and message.isBuilding then
          v.startTime = message.startTime
          v.isBuilding = message.isBuilding
          break
        end
      end
    end
    message.campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(serverId)
    if self.KingOccupyPlayerDict == nil then
      self.KingOccupyPlayerDict = {}
    end
    self.KingOccupyPlayerDict[serverId] = message
    if sendMsg then
      SFSNetwork.SendMessage(MsgDefines.GetKingOccupyProgress, serverId)
    end
  elseif sendMsg then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    SFSNetwork.SendMessage(MsgDefines.GetKingOccupyProgress, mySourceServerId)
    if mySourceServerId ~= loginServerId then
      SFSNetwork.SendMessage(MsgDefines.GetKingOccupyProgress, loginServerId)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.KingOccupyProgressRefresh)
end

function GovernmentManager:GetKingOccupyPlayer(serverId)
  if self.KingOccupyPlayerDict == nil then
    return nil
  end
  return self.KingOccupyPlayerDict[toInt(serverId)]
end

function GovernmentManager:CrossKingOccupyProgressHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    end
  elseif message.serverBuildPoint ~= nil and message.allianceBuildPoint ~= nil then
    self.CrossKingOccupyList = message
    EventManager:GetInstance():Broadcast(EventId.CrossKingOccupyProgressRefresh)
  end
end

function GovernmentManager:KingOccupyProgressHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    end
  elseif message.fightInfo ~= nil then
    local serverId = message.serverId
    if self.KingOccupyDict == nil then
      self.KingOccupyDict = {}
    end
    self.KingOccupyDict[toInt(serverId)] = message.fightInfo
    CS.GameEntry.Setting:SetPrivateBool("OpenedKingOccupyPopup", false)
    EventManager:GetInstance():Broadcast(EventId.KingOccupyProgressRefresh)
  end
end

function GovernmentManager:GetKingOccupyList(serverId)
  if self.KingOccupyDict == nil then
    return nil
  end
  return self.KingOccupyDict[toInt(serverId)]
end

function GovernmentManager:KingSendPresentHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    else
      UIUtil.ShowTipsId(457087)
    end
  else
    local template = DataCenter.WonderGiftTemplateManager:GetTemplate(message.presentId)
    self.presidentPresentInfo[template.act_type]:AddUidArr(message)
    UIUtil.ShowTipsId(457089)
    EventManager:GetInstance():Broadcast(EventId.GovernmentPresentRefresh)
    SFSNetwork.SendMessage(MsgDefines.GetKingdomPresentInfo, LuaEntry.Player:GetSourceServerId(), template.act_type)
  end
end

function GovernmentManager:GetKingHistoryHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(message.errorCode)
    end
    return
  end
  self:UpdateKingHistory(message)
  EventManager:GetInstance():Broadcast(EventId.GovernmentHistoryRecordRefresh)
end

function GovernmentManager:TransferKingHandler(message)
  if message.success then
    self:GetKingInfo(LuaEntry.Player:GetSelfServerId())
  end
end

function GovernmentManager:UpdateOnePositionInSourceServer(para)
  local positionId = para.positionId
  local serverId = LuaEntry.Player:GetSourceServerId()
  local positions = self.CrossKingdomPositions[serverId] or {}
  local info = positions[toInt(positionId)]
  if not info then
    info = KingdomPositionInfo.New()
    positions[toInt(positionId)] = info
  end
  info:ParseData(para)
  self.CrossKingdomPositions[serverId] = positions
end

function GovernmentManager:GetPresetInfoByServerId(serverId)
  local presidentInfo = self.CrossKingdomKing[serverId]
  if presidentInfo ~= nil and presidentInfo:HavePresident() then
    return presidentInfo
  end
  return nil
end

function GovernmentManager:UpdatePresidentInfo(message)
  local presidentInfo, theFakePresidentInfo
  if message.kingInfo then
    presidentInfo = PresidentInfo.New()
    presidentInfo:ParseData(message)
    if presidentInfo.serverId and presidentInfo.uid and presidentInfo.uid ~= 0 and presidentInfo.uid ~= "" then
      if presidentInfo.serverId == LuaEntry.Player:GetSelfServerId() then
        self.presidentInfo = presidentInfo
      end
      self.CrossKingdomKing[message.serverId] = presidentInfo
    else
      presidentInfo = nil
    end
  else
    if message.serverId == LuaEntry.Player:GetSelfServerId() then
      self.presidentInfo = nil
    end
    self.CrossKingdomKing[message.serverId] = nil
  end
  if message.centerThroneKingInfo then
    local occupyServerId = message.centerThroneKingInfo.occupyServerId
    local centerPresidentInfo = PresidentInfo.New()
    centerPresidentInfo:ParseData(message, message.centerThroneKingInfo)
    if centerPresidentInfo.serverId and centerPresidentInfo.uid and centerPresidentInfo.uid ~= 0 and centerPresidentInfo.uid ~= "" then
      if occupyServerId == nil then
        local seasonInfo = SeasonUtil.GetSeasonInfo(centerPresidentInfo.serverId)
        if seasonInfo ~= nil then
          occupyServerId = seasonInfo:GetNinePalacesServer(5)
        end
      end
      if occupyServerId ~= nil and occupyServerId ~= 0 then
        self.CrossKingdomKing[occupyServerId] = centerPresidentInfo
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.GovernmentPresidentRefresh, presidentInfo, theFakePresidentInfo, message.serverId)
  self:CheckAndSendKingdomPositionAutoAgree(LuaEntry.Player:GetSourceServerId())
end

function GovernmentManager:CheckAndSendKingdomPositionAutoAgree(serverId)
  if DataCenter.OfficialApplyManager:IsManager(serverId) then
    self:SendKingdomPositionAutoAgreeGet()
  end
end

function GovernmentManager:SendKingdomPositionAutoAgreeGet()
  if DataCenter.GovernmentManager:GetAutoAgreeShow() and DataCenter.GovernmentManager:SwitchOpenOrIsLoginSourceServer() then
    SFSNetwork.SendMessage(MsgDefines.KingdomPositionAutoAgreeGet)
  end
end

function GovernmentManager:GetDummyPresident(serverId)
  if self.CrossKingdomPositionsDummy[serverId] then
    return self.CrossKingdomPositionsDummy[serverId][GovernmentConst.King_Position_id]
  end
end

function GovernmentManager:CheckIsEnd()
  if self.presidentInfo then
    return self.presidentInfo:CheckIsEnd()
  end
  return false
end

function GovernmentManager:UpdatePresidentDeclarationInfo(message)
  local presidentInfo = self.presidentInfo
  if self:OfficerCrossOpen() and not LuaEntry.Player:IsLoginSourceServer() then
    presidentInfo = self:GetCurPresident(LuaEntry.Player:GetSourceServerId())
  end
  if presidentInfo == nil then
    return
  end
  presidentInfo:SetDeclaration(message.declaration or "")
  EventManager:GetInstance():Broadcast(EventId.GovernmentPresidentRefresh, nil, nil, LuaEntry.Player:GetSourceServerId())
end

function GovernmentManager:UpdatePresentRecord(message)
  if message.actType and self.presentRecord[message.actType] then
    self.presentRecord[message.actType]:ParseData(message)
    EventManager:GetInstance():Broadcast(EventId.GovernmentPresentRecordRefresh)
  end
end

function GovernmentManager:UpdateKingHistory(message)
  if self.kingHistoryList == nil then
    self.kingHistoryList = PresidentHistoryInfo.New()
  end
  self.kingHistoryList:ParseData(message)
end

function GovernmentManager:GetCurPresident(serverId)
  if serverId then
    return self.CrossKingdomKing[serverId]
  end
  if self.presidentInfo ~= nil and self.presidentInfo:HavePresident() then
    return self.presidentInfo
  end
  return nil
end

function GovernmentManager:UpdatePresentInfo(message)
  if message.actType then
    self.presidentPresentInfo[message.actType]:ParseData(message)
    EventManager:GetInstance():Broadcast(EventId.GovernmentPresentRefresh)
  end
end

function GovernmentManager:GetPresentByRewardType(rewardType, throneType)
  return self.presidentPresentInfo[throneType]:GetPresentByRewardType(rewardType)
end

function GovernmentManager:IsGetReward(uid, throneType)
  return self.presidentPresentInfo[throneType]:IsGetReward(uid)
end

function GovernmentManager:GetPositionInfoByPositionId(positionId, serverId)
  if positionId == nil then
    return
  end
  serverId = serverId or LuaEntry.Player:GetSourceServerId()
  if self.CrossKingdomPositions[serverId] then
    return self.CrossKingdomPositions[serverId][toInt(positionId)]
  end
end

function GovernmentManager:GetPositionInfoByUID(uid)
  local serverId = LuaEntry.Player:GetSourceServerId()
  if self.CrossKingdomPositions[serverId] then
    for k, v in pairs(self.CrossKingdomPositions[serverId]) do
      if v ~= nil and v.uid == uid then
        return v
      end
    end
  end
  return nil
end

function GovernmentManager:GetRewardRecord(throneType)
  return self.presentRecord[throneType]
end

function GovernmentManager:GetKingsHistoryRecord()
  return self.kingHistoryList
end

function GovernmentManager:initSelfPosition(message)
  self.self_positionId = 0
  if message.positionInfo and message.positionInfo.positionId then
    self.self_positionId = toInt(message.positionInfo.positionId)
  end
end

function GovernmentManager:SetSelfPosition(positionId)
  local oldId = self.self_positionId
  self.self_positionId = toInt(positionId)
  if oldId ~= self.self_positionId then
    EventManager:GetInstance():Broadcast(EventId.SelfOfficialPositionChange)
  end
end

function GovernmentManager:SetSelfPositionFromPositions(positions)
  if string.IsNullOrEmpty(positions) then
    return
  end
  local positionIds = string.split(positions, ";")
  for _, v in pairs(positionIds) do
    local config = DataCenter.GovernmentTemplateManager:GetTemplate(v)
    if config and config.group == GovOfficialGroup.Common then
      local oldId = self.self_positionId
      self.self_positionId = config.id
      if oldId ~= self.self_positionId then
        EventManager:GetInstance():Broadcast(EventId.SelfOfficialPositionChange)
      end
    end
  end
end

function GovernmentManager:PushPositionUpdate(message)
  ChatManager2:GetInstance().User:ForcePullMyUserInfoFromNet()
  if message.positionInfo and message.positionInfo.positionId then
    self.self_positionId = toInt(message.positionInfo.positionId)
  else
    self.self_positionId = 0
  end
  Logger.LogInfo("self_positionId:" .. self.self_positionId)
  EventManager:GetInstance():Broadcast(EventId.SelfOfficialPositionChange)
  if message.lastUpdateTime ~= nil then
    LuaEntry.Player:SetLastUpdateTime(message.lastUpdateTime)
  end
  self.kingHistoryList = nil
  self:GetKingInfo(LuaEntry.Player:GetSelfServerId())
end

function GovernmentManager:GetKingdomBadgesIconPath(serverId)
  local cfgId = 0
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local server = serverId or mySourceServerId
  if server == mySourceServerId then
    local dataList = self.KingdomBadges
    if dataList ~= nil then
      for i, v in ipairs(dataList) do
        if v and v.curUse == 1 then
          cfgId = v.cfgId
          break
        end
      end
    end
  end
  if cfgId == 0 then
    local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(server)
    if kingInfo and kingInfo.badges then
      cfgId = kingInfo.badges.cfgId or 511001
    end
  end
  if cfgId ~= 0 then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(cfgId)
    if itemCfg then
      return string.format(LoadPath.ItemPath, itemCfg.icon)
    end
  end
  return "Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi02.png"
end

function GovernmentManager:GetKingdomBadges()
  SFSNetwork.SendMessage(MsgDefines.GetKingdomBadges)
end

function GovernmentManager:GetKingdomBadgesHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(errorCode)
    end
    return
  end
  self.KingdomBadges = message.ls
  EventManager:GetInstance():Broadcast(EventId.KingdomBadgesInfoRefresh)
end

function GovernmentManager:SetKingdomBadges(cfgId)
  SFSNetwork.SendMessage(MsgDefines.SetKingdomBadges, cfgId)
end

function GovernmentManager:SetKingdomBadgesHandler(message)
  if message.errorCode ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTipsId(errorCode)
    end
    return
  end
  if message.updateArr then
    local KingdomBadges = self.KingdomBadges
    for _, newData in ipairs(message.updateArr) do
      for _, oldData in ipairs(KingdomBadges) do
        if oldData.createTime == newData.createTime then
          oldData.curUse = newData.curUse
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.KingdomBadgesInfoUpdate)
  end
end

function GovernmentManager:GetPresidentBg(havePresident)
  if havePresident then
    return "Assets/Main/Sprites/UI/UIMain/UIMainNew/Common_bg_player.png"
  end
  return "Assets/Main/Sprites/UI/UIGovernment/UIpresident_bg_president04.png"
end

function GovernmentManager:GetPositionId()
  return self.self_positionId
end

function GovernmentManager:TryKingdomPositionAppoint(governmentId, playerData, configData, succ)
  if governmentId == 10001 or governmentId == "10001" then
    UIUtil.ShowTipsId(120173)
    return
  end
  local positionInfo = DataCenter.GovernmentManager:GetPositionInfoByPositionId(governmentId)
  local theName = Localization:GetString(configData.name)
  local newUserId = playerData.uid
  local newUserName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(playerData.uid, playerData.name)
  local governmentInfo = DataCenter.GovernmentManager:GetPositionInfoByUID(newUserId)
  if governmentInfo ~= nil and (governmentInfo.positionId == 10001 or governmentInfo.positionId == "10001") then
    UIUtil.ShowTipsId(120173)
    return
  end
  if toInt(governmentId) == 10002 and LuaEntry.Player:IsFirstLady(playerData.serverId) and newUserId == LuaEntry.Player:GetUid() then
    UIUtil.ShowTipsId(457099)
    return
  end
  if not string.IsNullOrEmpty(playerData.alAbbr) then
    newUserName = "[" .. playerData.alAbbr .. "] " .. newUserName
  elseif not string.IsNullOrEmpty(playerData.abbr) then
    newUserName = "[" .. playerData.abbr .. "] " .. newUserName
  elseif not string.IsNullOrEmpty(playerData.allianceAbbr) then
    newUserName = "[" .. playerData.allianceAbbr .. "] " .. newUserName
  end
  if positionInfo ~= nil and positionInfo.uid ~= nil and positionInfo.uid ~= "" then
    local oldUserId = positionInfo.uid
    local oldUserName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(positionInfo.uid, positionInfo.name)
    if not string.IsNullOrEmpty(positionInfo.abbr) then
      oldUserName = "[" .. positionInfo.abbr .. "] " .. oldUserName
    end
    if playerData.uid == positionInfo.uid then
      local message = Localization:GetString(457032, oldUserName)
      UIUtil.ShowMessage(message, 2, "110106", "110006", function()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = true, playEffect = false})
      end, function()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = false, playEffect = false})
        DataCenter.GovernmentManager:KingdomPositionAppoint(oldUserId, governmentId, 2)
        if succ ~= nil and type(succ) == "function" then
          succ()
        end
      end, nil, "100378")
    else
      if positionInfo ~= nil and positionInfo:IsInAppointTimeCD() then
        UIUtil.ShowTipsId(457059)
        return
      end
      do
        local message = Localization:GetString(457030, newUserName, theName, oldUserName)
        UIUtil.ShowMessage(message, 2, "110106", "110006", function()
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = true, playEffect = false})
        end, function()
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = false, playEffect = false})
          DataCenter.GovernmentManager:KingdomPositionAppoint(newUserId, governmentId, 1)
          if succ ~= nil and type(succ) == "function" then
            succ()
          end
        end, nil, "100378")
      end
    end
  else
    if positionInfo ~= nil and positionInfo:IsInAppointTimeCD() then
      UIUtil.ShowTipsId(457059)
      return
    end
    local message = Localization:GetString(457031, newUserName, theName)
    UIUtil.ShowMessage(message, 2, "110106", "110006", function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = true, playEffect = false})
    end, function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = false, playEffect = false})
      DataCenter.GovernmentManager:KingdomPositionAppoint(newUserId, governmentId, 1)
      if succ ~= nil and type(succ) == "function" then
        succ()
      end
    end, nil, "100378")
  end
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UICommonMessageTip)
  if window ~= nil and window.View ~= nil then
    window.View.btn_1_spr = "tongyong_cfm_anniu_4"
    window.View.btn_2_spr = "tongyong_cfm_anniu_5"
    if window.View.btn_1 ~= nil then
      window.View.btn_1:LoadSprite(string.format(LoadPath.LWCommonPath, window.View.btn_1_spr))
    end
    if window.View.btn_2 ~= nil then
      window.View.btn_2:LoadSprite(string.format(LoadPath.LWCommonPath, window.View.btn_2_spr))
    end
  end
end

function GovernmentManager:GetKingInfoByServerId(serverId)
  if serverId == nil or toInt(serverId) <= 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GetKingInfo, serverId)
end

function GovernmentManager:GetCurRound()
  if not self.activityServerData or not self.activityServerData.round then
    return 0
  end
  return self.activityServerData.actFightStep == 0 and self.activityServerData.round + 1 or self.activityServerData.round
end

function GovernmentManager:OnPushCrossThroneWinnerPopup(t)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICrossThroneSuccess, {anim = true}, t)
end

function GovernmentManager:IsCrossActivityOpen()
  if DataCenter.ZoneWarManager.configSchedulePreview ~= nil then
    local startTime = DataCenter.ZoneWarManager.configSchedulePreview.startTime
    local endTime = DataCenter.ZoneWarManager.configSchedulePreview.endTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if startTime ~= nil and endTime ~= nil and endTime > curTime then
      return true
    else
      return false
    end
  end
  return DataCenter.ZoneWarManager:CheckShowMainUIBtn()
end

function GovernmentManager:IsConqueror(serverId)
  if self.ConquerData[serverId] then
    local endTime = self.ConquerData[serverId].endTime
    local now = UITimeManager:GetInstance():GetServerTime()
    return endTime > now
  end
  return false
end

function GovernmentManager:GetEffectBuffs(cfgId, serverId)
  local configData = DataCenter.GovernmentTemplateManager:GetTemplate(cfgId)
  local isConqueror = DataCenter.GovernmentManager:IsConqueror(serverId or LuaEntry.Player:GetSourceServerId())
  local effectList = isConqueror and configData.conqueror_effect or configData.effect
  local effectOrder = isConqueror and configData.conqueror_effectOrder or configData.effectOrder
  local effectBuffs = {}
  for index, effectId in ipairs(effectOrder) do
    if effectId then
      local effectValue = effectList[effectId]
      if effectValue ~= nil then
        local buffAddNum, effectName = UIUtil.GetEffectStr(nil, effectValue, effectId)
        if buffAddNum ~= nil then
          local buff = {}
          buff.effectId = effectId
          buff.buffAddNum = buffAddNum
          buff.effectName = effectName
          table.insert(effectBuffs, buff)
        end
      end
    end
  end
  if configData.supreme_president_power then
    table.insert(effectBuffs, {
      effectId = 93000,
      buffAddNum = 1,
      effectName = "supreme_president_ui_25_limit_12"
    })
  end
  return effectBuffs
end

local function SendKingdomPositionAppointmentCd(self)
  if DataCenter.GovernmentManager:SwitchOpenOrIsLoginSourceServer() then
    SFSNetwork.SendMessage(MsgDefines.KingdomPositionAppointmentCd)
  end
end

local function SendKingdomPositionAppointmentCdUpdate(self, index)
  SFSNetwork.SendMessage(MsgDefines.KingdomPositionAppointmentCdUpdate, index)
end

GovernmentManager.SendKingdomPositionAppointmentCd = SendKingdomPositionAppointmentCd
GovernmentManager.SendKingdomPositionAppointmentCdUpdate = SendKingdomPositionAppointmentCdUpdate

function GovernmentManager:SetKingdomPositionAutoAgreeInfo(agreeInfo)
  self.agreeInfo = agreeInfo
  EventManager:GetInstance():Broadcast(EventId.OfficialGetAutoAgreeInfo)
  EventManager:GetInstance():Broadcast(EventId.OfficialApplyTipRefresh)
end

function GovernmentManager:GetKingdomPositionAutoAgreeInfo()
  return self.agreeInfo
end

function GovernmentManager:GetAutoAgreeShow()
  if self.autoAgreeSetting == nil then
    local autoAgreeSetting = LuaEntry.DataConfig:TryGetStr("auto_wonder_config", "k11")
    if not string.IsNullOrEmpty(autoAgreeSetting) then
      self.autoAgreeSetting = string.split(autoAgreeSetting, ";")
    end
  end
  local isShow = LuaEntry.DataConfig:CheckSwitch("auto_officer_config")
  if isShow and self.autoAgreeSetting then
    isShow = DataCenter.SeasonDataManager:CheckNowSeasonArrive(self.autoAgreeSetting[1], self.autoAgreeSetting[2])
  end
  return isShow
end

function GovernmentManager:CheckRequestKingdomPositionTimes()
  local isOpen = self:CheckKingdomPositionCountDownIsOpen()
  if self.self_positionId ~= 0 and self.self_positionId ~= 10001 and self.self_positionId ~= "10001" and isOpen then
    SFSNetwork.SendMessage(MsgDefines.KingdomPositionCountdownGet)
  end
end

function GovernmentManager:SetKingdomPositionTimes(data)
  if data.startTime and data.countdown then
    self.kingdomPositionStartTime = data.startTime
    self.kingdomPositionCountDown = data.countdown
    EventManager:GetInstance():Broadcast(EventId.GetKingdomPositionCountDown)
  end
end

function GovernmentManager:CheckKingdomPositionCountDownIsOpen()
  local isOpen = LuaEntry.DataConfig:CheckSwitch("officer_countdown")
  return isOpen
end

function GovernmentManager:GetKingdomPositionStartTime()
  return self.kingdomPositionStartTime
end

function GovernmentManager:IsInBattlePhase()
  if self.receivedBattleEnd then
    return false
  end
  if self.activityServerData then
    local actFightStep = toInt(self.activityServerData.actFightStep)
    if actFightStep == 1 then
      return true
    end
    if actFightStep ~= 2 then
      local occupyTime = toInt(self.activityServerData.occupyTime)
      if occupyTime == 0 then
        local now = UITimeManager:GetInstance():GetServerTime()
        local fightStartTime = toInt(self.activityServerData.fightStartTime)
        local fightEndTime = toInt(self.activityServerData.fightEndTime)
        if now > fightStartTime and now < fightEndTime then
          return true
        end
      end
    end
  end
  return false
end

function GovernmentManager:GetKingdomPositionCountDown()
  return self.kingdomPositionCountDown
end

function GovernmentManager:SwitchOpenOrAtHomeNow()
  return LuaEntry.Player:SwitchOpenOrAtHomeNow("officer_cross_open")
end

function GovernmentManager:SwitchOpenOrIsLoginSourceServer()
  return LuaEntry.Player:SwitchOpenOrIsLoginSourceServer("officer_cross_open")
end

function GovernmentManager:OfficerCrossOpen()
  return LuaEntry.DataConfig:CheckSwitch("officer_cross_open")
end

function GovernmentManager:Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("\230\180\187\229\138\168\230\149\176\230\141\174\230\156\137\230\149\136: %s", tostring(self.activityServerData ~= nil))
  sb:AppendFormatLine("\230\152\175\229\144\166\230\148\182\229\136\176\232\191\135\231\187\147\230\157\159\228\191\161\230\129\175: %s", tostring(self.receivedBattleEnd == true))
  sb:AppendFormatLine("IsInBattlePhase: %s", tostring(self:IsInBattlePhase()))
  sb:AppendFormatLine("battleState: %s", self.activityServerData and self.activityServerData.actFightStep)
  return sb:ToString()
end

return GovernmentManager
