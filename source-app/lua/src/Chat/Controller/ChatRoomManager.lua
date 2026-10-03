local ChatMessage = require("Chat.Model.ChatMessage")
local ChatRoomData = require("Chat.Model.ChatRoomData")
local rapidjson = require("rapidjson")
local logger = require("Framework.Logger.Logger")
local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local privateStartMaxCount = 60
local msgCount = 3
local RoomShowBubbleAllianceHelp = _ENV.RoomShowBubbleAllianceHelp
local ChatRoomManager = BaseClass("ChatRoomManager", CEventable)
local refreshCount = 20
local maxStickerPoolCount = 30

function ChatRoomManager:__init()
  self:resetData()
  self.gameServerRoomList = nil
  self.photoUploadStateDic = {}
  self.photoTempSaveFlagDic = {}
  self.momentPicVer = -1
  self.momentPhotoData = {}
  self:RegisterEvent(EventId.OnPassDay, self.OnPassDay)
end

function ChatRoomManager:resetData()
  self.roomDatas = {}
  self.requestRoomMsg = {}
  self.diffServerTime = 0
  self.roomInfoDic = {}
  self.groupRoomIdDic = {}
  self.privateRoomDic = {}
  self.localTopRoomDic = {}
  self.groupRoomDic = {}
  self.redpacks = {}
  self.personTempMsgTab = {}
  self.emojiChatGPT = {}
  self.countryRoomId = ""
  self.languageRoomId = ""
  self.allianceRoomId = ""
  self.allianceNoticeRoomId = ""
  self.allianceManagerRoomId = ""
  self.allianceFriendRoomId = ""
  self.crossServerRoomId = ""
  self.seasonRoomId = ""
  self.seasonFactionWarRoomId = ""
  self.landlordRoomId = ""
  self.sendingDataArr = {}
  self.sendingIndex = 0
  self.epidemicRoom = nil
  self.cacheRoomInfos = nil
  self:ClearAllRoomStickerNode()
  self.stickerNodeList = {}
  self.stickerMatOfNodeDic = {}
  self.stickerNodeDic = {}
  self.stickerMatPoolList = {}
  self.stickerMatAssetDic = {}
  self:ClearAllStickerDiceData()
  self.stickerDiceDataDic = {}
  self.jumpMsgRoom = nil
  self.timestampAnchorDic = {}
  self.roomLastDatas = {}
  if self.delayRoomLastAction then
    self.delayRoomLastAction:Stop()
    self.delayRoomLastAction = nil
  end
  self.chatSpeakUidDict = {}
  self.chatSpeakUidReqState = {}
end

function ChatRoomManager:StartMemoryReport()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(300, self.ReportChatDataMem, self, false, false, true)
    self.timer:Start()
  end
end

function ChatRoomManager:GetGameServerRoomList()
  return self.gameServerRoomList
end

function ChatRoomManager:SetGameServerRoomList(roomList)
  self.gameServerRoomList = roomList
end

function ChatRoomManager:RequestGameServerRoomIds()
  local isGameServerRoomIdEnabled = ChatInterface.isGameServerRoomIdEnabled()
  if not isGameServerRoomIdEnabled then
    return
  end
  self:SetGameServerRoomList(nil)
  SFSNetwork.SendMessage(MsgDefines.ChatCommonRoomId)
end

function ChatRoomManager:UpdateGroupRoomId(group, roomId)
  self.groupRoomIdDic[group] = roomId
end

function ChatRoomManager:HandleServerRoomUpdate(message)
  local roomList = message.allRooms
  if message.errorCode or not roomList then
    roomList = {
      {
        group = ChatGroupType.GROUP_COUNTRY,
        roomId = self:GenRoomIdByGroup(ChatGroupType.GROUP_COUNTRY)
      },
      {
        group = ChatGroupType.GROUP_LANGUAGE,
        roomId = self:GenRoomIdByGroup(ChatGroupType.GROUP_LANGUAGE)
      }
    }
    if message.errorCode then
      logger.LogError("ChatGameServerUpdateError - >   errorCode  : " .. message.errorCode)
    elseif not message.allRooms then
      logger.LogError("ChatGameServerUpdateError - >   notRoom  ")
    end
  end
  local net = ChatManager2:GetInstance().Net
  self:SetGameServerRoomList(roomList)
  if not net:IsRunning() then
    return
  end
  local wait = ChatManager2:GetInstance():TryInitRoomAfterGameServerReady()
  if not wait then
    self:SyncRoomsWithServer(roomList, false)
  end
end

function ChatRoomManager:SyncRoomsWithServer(roomList, isInit)
  if not roomList or #roomList == 0 then
    Logger.LogWarning("[chatServerRoomId][SyncRoomsWithServer] not roomList")
    return
  end
  local joinRoomList = {}
  local chatMgr = ChatManager2:GetInstance()
  local net = chatMgr.Net
  for _, roomData in pairs(roomList) do
    local group = roomData.group
    local newRoomId = roomData.roomId
    local curRoom = self:GetRoomDataByGroup(group)
    local oldRoomId = curRoom and curRoom.roomId or nil
    self:UpdateGroupRoomId(group, newRoomId)
    local needJoin = false
    if curRoom then
      if oldRoomId ~= newRoomId then
        self:RemoveRoomData(oldRoomId)
        self:CreateChatRoom(newRoomId, group)
        net:SendMessage(ChatMsgDefines.RoomLeave, oldRoomId)
        needJoin = true
      end
    else
      self:CreateChatRoom(newRoomId, group)
      needJoin = true
    end
    if needJoin and not isInit then
      net:SendMessage(ChatMsgDefines.RoomJoinMulti, group, newRoomId)
      table.insert(joinRoomList, newRoomId)
    end
  end
  if not isInit and 0 < #joinRoomList then
    net:SendMessage(ChatMsgDefines.HistoryRoomsV2, joinRoomList)
  end
end

function ChatRoomManager:StopMemoryReport()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatRoomManager:ReportChatDataMem()
  local roomList = self:GetRoomDatas()
  local roomCount = 0
  local msgCount = 0
  local size = 0
  for _, room in pairs(roomList) do
    roomCount = roomCount + 1
    msgCount = msgCount + #room.msgs
    size = size + room.__estimateSize
  end
  print("ChatRoomManager:ReportChatDataMem", size, roomCount, msgCount)
  PostEventLog.Track("IM_CHAT_DATA_MEM", {
    pd_mem = size,
    count = roomCount,
    capacity_count = msgCount
  })
  PostEventLog.Track("IM_MAIL_DATA_MEM", {
    pd_mem = DataCenter.MailDataManager.__estimateSize,
    pd_mem_nrsv = DataCenter.MailDataManager.__estimateSizeShare
  })
end

function ChatRoomManager:CreateChatRoomData(roomId, group)
  return ChatRoomData.New(roomId, group)
end

function ChatRoomManager:CreateChatMessage()
  return ChatMessage.New()
end

function ChatRoomManager:UpdateChatServerTime(time)
  self.diffServerTime = time - SafeLocalOsTime()
  ChatPrint("\232\129\138\229\164\169\230\156\141\229\138\161\229\153\168\230\151\182\233\151\180\229\183\174\229\128\188\239\188\154%d", self.diffServerTime)
end

function ChatRoomManager:getChatServerTime()
  return self.diffServerTime + SafeLocalOsTime()
end

function ChatRoomManager:UpdateCountryRoomId()
  self:UpdateGroupRoomId(ChatGroupType.GROUP_COUNTRY, self:GenCountryRoomId())
end

function ChatRoomManager:UpdateLanguageRoomId()
  self:UpdateGroupRoomId(ChatGroupType.GROUP_LANGUAGE, self:GenLanguageRoomId())
end

function ChatRoomManager:UpdateSeasonRoomId()
  self.seasonRoomId = self:GenSeasonRoomId()
end

function ChatRoomManager:Init()
  if tonumber(ChatInterface.getPlayerServerId()) == 0 then
    return
  end
  ChatPrint("-------------\229\136\157\229\167\139\229\140\150\232\129\138\229\164\169\230\137\128\230\156\137\230\136\191\233\151\180----------")
  local isGameServerRoomIdEnabled = ChatInterface.isGameServerRoomIdEnabled()
  if isGameServerRoomIdEnabled then
    self:SyncRoomsWithServer(self:GetGameServerRoomList(), true)
  else
    self:AddRoomByGroup(ChatGroupType.GROUP_COUNTRY)
    self:AddRoomByGroup(ChatGroupType.GROUP_LANGUAGE)
  end
  self:AddAllianceRoom()
  self:AddAllianceNoticeRoom()
  self:AddCrossServerRoom()
  self:AddDragonSelfRoom()
  self:AddDragonAllRoom()
  self:AddAllianceManagerRoom()
  self:AddSeasonRoom()
  self:AddSeasonFactionWarRoom()
  self:AddAllianceFriendRoom()
  self:AddActLandlordRoom()
  self.epidemicRoom = {}
  self:RefreshEpidemicRoom()
end

function ChatRoomManager:GetIsNewPrivateList()
  return self.isNewPrivateList
end

function ChatRoomManager:SetIsNewPrivateList(isOn)
  self.isNewPrivateList = isOn
end

function ChatRoomManager:GetCountryRoomId()
  return self.groupRoomIdDic[ChatGroupType.GROUP_COUNTRY]
end

function ChatRoomManager:GetLanguageRoomId()
  return self.groupRoomIdDic[ChatGroupType.GROUP_LANGUAGE]
end

function ChatRoomManager:GetAllianceRoomId()
  return self.allianceRoomId
end

function ChatRoomManager:GetAllianceMangaerRoomId()
  return self.allianceManagerRoomId
end

function ChatRoomManager:GetSeasonFactionWarRoomId()
  return self.seasonFactionWarRoomId
end

function ChatRoomManager:GetActLandlordRoomId()
  return self.landlordRoomId
end

function ChatRoomManager:GetAllianceNoticeRoomId()
  return self.allianceNoticeRoomId
end

function ChatRoomManager:GetCrossServerRoomId()
  return self.crossServerRoomId
end

function ChatRoomManager:GetDragonServerSelfRoomId()
  return self.dragonSelfRoomId
end

function ChatRoomManager:GetDragonServerAllRoomId()
  return self.dragonAllRoomId
end

function ChatRoomManager:GetSendingIndex()
  self.sendingIndex = self.sendingIndex - 1
  return self.sendingIndex
end

function ChatRoomManager:GenRoomIdByGroup(group)
  if group == ChatGroupType.GROUP_COUNTRY then
    return self:GenCountryRoomId()
  elseif group == ChatGroupType.GROUP_LANGUAGE then
    return self:GenLanguageRoomId()
  end
end

function ChatRoomManager:AddRoomByGroup(group)
  local cacheRoomId = self.groupRoomIdDic[group]
  local clientRoomId = self:GenRoomIdByGroup(group)
  if cacheRoomId ~= clientRoomId then
    self:UpdateGroupRoomId(group, clientRoomId)
    if cacheRoomId then
      Logger.LogWarning("[chatServerRoomId] mismatch detected. " .. "group: " .. tostring(group) .. ", oldRoomId: " .. tostring(cacheRoomId) .. ", newRoomId: " .. tostring(clientRoomId))
    else
      Logger.LogWarning("[chatServerRoomId] initialized. " .. "group: " .. tostring(group) .. ", roomId: " .. tostring(clientRoomId))
    end
  end
  local roomId = self.groupRoomIdDic[group]
  local room = self:GetRoomData(roomId)
  if not room then
    self:CreateChatRoom(roomId, group)
  end
end

function ChatRoomManager:AddAllianceRoom()
  if ChatInterface.isInAlliance() then
    self.allianceRoomId = self:GenAllianceRoomId()
    return self:CreateChatRoom(self.allianceRoomId, ChatGroupType.GROUP_ALLIANCE)
  end
  return nil
end

function ChatRoomManager:AddAllianceNoticeRoom()
  if ChatInterface.isInAlliance() then
    self.allianceNoticeRoomId = self:GenAllianceNoticeRoom()
    return self:CreateChatRoom(self.allianceNoticeRoomId, ChatGroupType.GROUP_ALLIANCE_NOTICE)
  end
  return nil
end

function ChatRoomManager:AddSeasonRoom()
  if SeasonUtil.GetSeason() ~= 0 then
    self.seasonRoomId = self:GenSeasonRoomId()
    return self:CreateChatRoom(self.seasonRoomId, ChatGroupType.GROUP_SEASON_ROOM)
  end
end

function ChatRoomManager:AddAllianceManagerRoom()
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if ChatInterface.isInAlliance() and isR4orR5 then
    self.allianceManagerRoomId = self:GenAllianceManagerRoomId()
    return self:CreateChatRoom(self.allianceManagerRoomId, ChatGroupType.GROUP_ALLIANCE_MANAGER)
  end
  return nil
end

function ChatRoomManager:GetSeasonFactionWarOpen()
  local seasonType = SeasonUtil.GetSeasonType(false, true)
  if SeasonUtil.SeasonHasFactionWar(seasonType) and SeasonUtil.IsInSeason() then
    local campInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingData()
    if campInfo ~= nil and DataCenter.SeasonFactionWarDataManager:IsGroupingShownMode() then
      local sourceServerId = ChatInterface.getSelfServerId()
      local compId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(sourceServerId)
      if compId == 0 then
        return false
      end
      return true
    end
  end
end

function ChatRoomManager:AddAllianceFriendRoom()
  local mgr = DataCenter.SeasonAllyFriendManager
  if mgr:HasFriend() and SeasonUtil.IsInSeason() then
    self.allianceFriendRoomId = mgr:TryGetChatRoomId()
    if self.allianceFriendRoomId ~= nil and self.allianceFriendRoomId ~= "" then
      return self:CreateChatRoom(self.allianceFriendRoomId, ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM)
    end
  end
  return nil
end

function ChatRoomManager:GetActLandlordOpenAndGrouped()
  if DataCenter.LandlordMgr:GetActData() and DataCenter.LandlordMgr:GetActCurStage() > LLConst.LandlordStage.GROUP then
    if not DataCenter.LandlordMgr:IsInMyServerGroup() then
      return false
    end
    local compId = DataCenter.LandlordMgr:GetMyGroup()
    return compId ~= LLConst.LandLordGroup.NONE
  end
  return false
end

function ChatRoomManager:AddSeasonFactionWarRoom()
  if self:GetSeasonFactionWarOpen() then
    self.seasonFactionWarRoomId = self:GenSeasonFactionWarRoomId()
    if self.seasonFactionWarRoomId == "" then
      return nil
    end
    return self:CreateChatRoom(self.seasonFactionWarRoomId, ChatGroupType.GROUP_SEASON_FACTION_WAR_ROOM)
  end
  return nil
end

function ChatRoomManager:AddActLandlordRoom()
  if self:GetActLandlordOpenAndGrouped() then
    self.landlordRoomId = DataCenter.LandlordMgr:TryGetCampRoom()
    if not self.landlordRoomId then
      return
    end
    local compId = DataCenter.LandlordMgr:GetMyGroup()
    return self:CreateChatRoom(self.landlordRoomId, compId == LLConst.LandLordGroup.FARMER and ChatGroupType.GROUP_LANDLORD_FARMER or ChatGroupType.GROUP_LANDLORD_LORD)
  end
  return nil
end

function ChatRoomManager:AddLanguageRoom()
  self.languageRoomId = self:GenLanguageRoomId()
  return self:CreateChatRoom(self.languageRoomId, ChatGroupType.GROUP_LANGUAGE)
end

function ChatRoomManager:AddCrossServerRoom()
  if ChatInterface.isCrossServerOpen() then
    self.crossServerRoomId = self:GenCrossServerRoomId()
    return self:CreateChatRoom(self.crossServerRoomId, ChatGroupType.GROUP_CROSS_SERVER)
  end
  return nil
end

function ChatRoomManager:AddDragonSelfRoom()
  if ChatInterface.isDragonServerOpen() then
    self.dragonSelfRoomId = self:GenDragonSelfRoomId()
    if not self.dragonSelfRoomId then
      return
    end
    return self:CreateChatRoom(self.dragonSelfRoomId, ChatInterface.getDragonGroupType(true))
  end
  return nil
end

function ChatRoomManager:AddDragonAllRoom()
  if ChatInterface.isDragonServerOpen() then
    self.dragonAllRoomId = self:GenDragonAllRoomId()
    return self:CreateChatRoom(self.dragonAllRoomId, ChatInterface.getDragonGroupType(false))
  end
  return nil
end

function ChatRoomManager:RefreshEpidemicRoom()
  if not self.epidemicRoom then
    return
  end
  local roomId = ActEpidemicUtils.TryGetFarmerRoom()
  if roomId == self.epidemicRoom.id then
    return
  end
  if roomId then
    if self.epidemicRoom.id then
      self:RemoveRoomData(self.epidemicRoom.id)
    end
    self.epidemicRoom.id = roomId
    self:CreateChatRoom(self.epidemicRoom.id, ChatGroupType.GROUP_EPIDEMIC_FARMER)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_EPIDEMIC_FARMER, roomId)
  else
    if self.epidemicRoom.id then
      self:RemoveRoomData(self.epidemicRoom.id)
    end
    self.epidemicRoom.id = nil
  end
end

function ChatRoomManager:RemoveAllianceRoom()
  local roomId = self:GetAllianceRoomId()
  self:RemoveRoomData(roomId)
  roomId = self:GetAllianceNoticeRoomId()
  self:RemoveRoomData(roomId)
  self.allianceRoomId = ""
  self.allianceNoticeRoomId = ""
  self:RemoveAllianceManangerRoom()
end

function ChatRoomManager:RemoveAllianceManangerRoom()
  local roomId = self:GetAllianceMangaerRoomId()
  self:RemoveRoomData(roomId)
  self.allianceManagerRoomId = ""
end

function ChatRoomManager:RemoveSeasonFactionWarRoom()
  if not self:GetSeasonFactionWarOpen() then
    local roomId = self:GetSeasonFactionWarRoomId()
    self:RemoveRoomData(roomId)
    self.seasonFactionWarRoomId = ""
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomLeave, roomId)
  end
end

function ChatRoomManager:RemoveActLandlordRoom()
  local roomId = self:GetActLandlordRoomId()
  if string.IsNullOrEmpty(roomId) then
    return
  end
  self:RemoveRoomData(roomId)
  self.landlordRoomId = ""
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomLeave, roomId)
end

function ChatRoomManager:RemoveCrossServerRoom()
  local roomId = self:GetCrossServerRoomId()
  self:RemoveRoomData(roomId)
  self.crossServerRoomId = ""
end

function ChatRoomManager:RemoveDragonSeverSelfRoom()
  local roomId = self:GetDragonServerSelfRoomId()
  self:RemoveRoomData(roomId)
  self.dragonSelfRoomId = ""
end

function ChatRoomManager:RemoveDragonSeverAllRoom()
  local roomId = self:GetDragonServerAllRoomId()
  self:RemoveRoomData(roomId)
  self.dragonAllRoomId = ""
end

function ChatRoomManager:HasAllianceRoom()
  local roomId = self:GetAllianceRoomId()
  local room = self:GetRoomData(roomId)
  if room then
    return true
  end
  return false
end

function ChatRoomManager:HasCrossServerRoom()
  local roomId = self:GetCrossServerRoomId()
  local room = self:GetRoomData(roomId)
  if room then
    return true
  end
  return false
end

function ChatRoomManager:addTempPersonMsg(uid, msg, extra)
  local t = self.personTempMsgTab[uid] or {}
  t.extra = extra
  t.msgList = t.msgList or {}
  table.insert(t.msgList, msg)
  self.personTempMsgTab[uid] = t
  return
end

function ChatRoomManager:getTempPersonMsg(uid)
  return self.personTempMsgTab[uid]
end

function ChatRoomManager:clearTempPersonMsg(uid)
  self.personTempMsgTab[uid] = nil
end

function ChatRoomManager:releaseData()
  self:resetData()
end

function ChatRoomManager:ClearRooms()
  self.roomDatas = {}
  self.emojiChatGPT = {}
  self:RemoveAllFakePhotoChatData()
  EventManager:GetInstance():Broadcast(EventId.ChatRoomClear)
end

function ChatRoomManager:GetRoomIdPrefix()
  return ChatInterface.GetRoomIdPrefix()
end

function ChatRoomManager:GetSeasonConfigId()
  local isCentralServer = SeasonUtil.GetIsCentralServer()
  if isCentralServer then
    local sourceServerId = LuaEntry.Player:GetSelfServerId()
    local info = SeasonUtil.GetSeasonInfo(sourceServerId)
    if info then
      if info.seasonId > 5 then
        return info.seasonConfigId
      elseif info.seasonId == 5 and info.seasonStartTime >= 1776391200000 then
        return info.seasonConfigId
      end
    end
  end
  return nil
end

function ChatRoomManager:GenCountryRoomId()
  local serverId = LuaEntry.Player:GetSelfServerId()
  local seasonConfigId = self:GetSeasonConfigId()
  local roomId
  if seasonConfigId then
    roomId = string.format("%scountry_%d_%s", self:GetRoomIdPrefix(), serverId, seasonConfigId)
  else
    roomId = string.format("%scountry_%d", self:GetRoomIdPrefix(), serverId)
  end
  return roomId
end

function ChatRoomManager:GenAllianceRoomId()
  local sid = ChatInterface.getSelfServerId()
  local aid = ChatInterface.getAllianceId()
  return string.format("%salliance_%d_%s", self:GetRoomIdPrefix(), sid, aid)
end

function ChatRoomManager:GetBattlefieldRoomId()
  local curBattleFieldType = BattleFieldUtil.GetCurBattleFieldType()
  if curBattleFieldType == BattleFieldType.Desert then
    return DataCenter.ActDragonManager:TryGetDesertBattleRoomId()
  elseif curBattleFieldType == BattleFieldType.DsbDuel then
    return BattlefieldDsbDuelUtils.TryGetSelfBattleRoomId()
  elseif curBattleFieldType == BattleFieldType.EpidemicZone then
    return ActEpidemicUtils.TryGetFarmerRoom() or ActEpidemicUtils.TryGetCommonBattleRoom()
  end
end

function ChatRoomManager:GenAllianceManagerRoomId()
  local sid = ChatInterface.getSelfServerId()
  local aid = ChatInterface.getAllianceId()
  return string.format("%salliance_manager_%d_%s", self:GetRoomIdPrefix(), sid, aid)
end

function ChatRoomManager:GenSeasonFactionWarRoomId()
  local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
  local sourceServerId = ChatInterface.getSelfServerId()
  local compId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(sourceServerId)
  if compId == 0 then
    Logger.LogError("S2\233\152\181\232\144\165\229\175\185\229\134\179  \232\142\183\229\143\150\233\152\181\229\174\185\231\154\132Id\228\184\1860\239\188\140\229\186\148\232\175\165\229\156\168\232\175\165\229\135\189\230\149\176\229\164\150\233\131\168\229\181\140\229\165\151\229\135\189\230\149\176\229\136\164\230\150\173\230\152\175\229\144\166\229\164\132\228\186\142\232\175\165\232\181\155\229\173\163\233\152\182\230\174\181")
    return ""
  end
  return string.format("%sseason_faction_war_%d_%s", self:GetRoomIdPrefix(), seasonId, compId)
end

function ChatRoomManager:GenAllianceNoticeRoom()
  local id = self:GenAllianceRoomId()
  return id .. "_Notice"
end

function ChatRoomManager:GenLanguageRoomId()
  local lang = ChatInterface.getLanguageName()
  local serverId = ChatInterface.getPlayerServerId()
  local seasonConfigId = self:GetSeasonConfigId()
  local roomId
  if seasonConfigId then
    local langFormat = "custom_lang_%s_%s_%s"
    roomId = self:GetRoomIdPrefix() .. string.format(langFormat, lang, serverId, seasonConfigId)
  else
    local langFormat = "custom_lang_%s_%s"
    roomId = self:GetRoomIdPrefix() .. string.format(langFormat, lang, serverId)
  end
  return roomId
end

function ChatRoomManager:GenSeasonRoomId()
  local id = DataCenter.SeasonDataManager:GetSeasonId(true)
  return string.format("%s" .. ChatGroupType.GROUP_SEASON_ROOM .. "%s", self:GetRoomIdPrefix(), id)
end

function ChatRoomManager:GenCrossServerRoomId()
  local cid = ChatInterface.getCrossServerIdFlag()
  return string.format("%s" .. ChatGroupType.GROUP_CROSS_SERVER .. "%s", self:GetRoomIdPrefix(), cid)
end

function ChatRoomManager:GenDragonSelfRoomId()
  local type = LuaEntry.Player:GetCurWorldType()
  if type == BattleFieldType.Desert then
    return DataCenter.ActDragonManager:TryGetDesertBattleRoomId()
  elseif type == BattleFieldType.EpidemicZone then
    return ActEpidemicUtils.TryGetCommonBattleRoom()
  elseif type == BattleFieldType.DsbDuel then
    return BattlefieldDsbDuelUtils.TryGetSelfBattleRoomId()
  end
end

function ChatRoomManager:GenDragonAllRoomId()
  local serverId = LuaEntry.Player:GetCurServerId()
  local worldId = LuaEntry.Player:GetCurWorldId()
  local worldType = LuaEntry.Player:GetCurWorldType()
  return string.format("%s%s%s_%s_%s", self:GetRoomIdPrefix(), ChatInterface.getDragonGroupType(false), serverId, worldId, worldType)
end

function ChatRoomManager:GetAllianceRoomData()
  local allianceID = self:GenAllianceRoomId()
  local allianceRoom = self:GetRoomData(allianceID)
  return allianceRoom
end

function ChatRoomManager:GetRoomDatas()
  return table.values(self.roomDatas)
end

function ChatRoomManager:GetPrivateRoomByUserId(userId)
  local temp = self:GetRoomDatas()
  for k, roomData in pairs(temp) do
    if roomData:isPrivateChat() then
      local memlist = roomData:getMemberList()
      for _, memId in pairs(memlist) do
        if memId == userId then
          return roomData.roomId
        end
      end
    end
  end
  return ""
end

function ChatRoomManager:GetShareRoom()
  local shareRooms = self:GetSortRoomDatas()
  local tabArray = {}
  for _, room in pairs(shareRooms) do
    tabArray[#tabArray + 1] = room
  end
  return tabArray
end

function ChatRoomManager:CheckGroupCountry()
  local rooms = self:GetSortRoomDatas()
  for _, room in pairs(rooms) do
    if room:getRoomGroup() == ChatGroupType.GROUP_COUNTRY then
      return true
    end
  end
  return false
end

function ChatRoomManager:GetSortRoomDatas()
  local temp = self:GetRoomDatas()
  local mainLv = DataCenter.BuildManager.MainLv
  local roomArray = {}
  local template
  for k, v in pairs(temp) do
    template = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(v.group)
    if template and template.isShare then
      if v:getRoomGroup() == ChatGroupType.GROUP_COUNTRY then
        if mainLv >= ChatChannelShowMinLevel then
          table.insert(roomArray, v)
        end
      else
        table.insert(roomArray, v)
      end
    elseif v:isPrivateChat() then
      table.insert(roomArray, v)
    end
  end
  table.sort(roomArray, function(ldata, rdata)
    if ldata.roomId == QuestRoomId then
      return true
    end
    if rdata.roomId == QuestRoomId then
      return false
    end
    local ldataGroupId = DataCenter.GroupChatSetTemplateManager:GetShareSort(ldata.group)
    local rdataGroupId = DataCenter.GroupChatSetTemplateManager:GetShareSort(rdata.group)
    if ldataGroupId < rdataGroupId then
      return true
    elseif ldataGroupId > rdataGroupId then
      return false
    elseif ldataGroupId == DataCenter.GroupChatSetTemplateManager:GetShareSort(ChatGroupType.GROUP_CUSTOM) and rdataGroupId == DataCenter.GroupChatSetTemplateManager:GetShareSort(ChatGroupType.GROUP_CUSTOM) then
      local l_IsGMRoom = ldata:IsGmRoom()
      local r_IsGMRoom = rdata:IsGmRoom()
      if l_IsGMRoom == true and r_IsGMRoom then
        return false
      elseif l_IsGMRoom then
        return true
      elseif r_IsGMRoom then
        return false
      end
    end
    return ldata:GetLastChatTime() > rdata:GetLastChatTime()
  end)
  return roomArray
end

function ChatRoomManager:NewPriveRoomListCreate(data)
  local room, roomData
  for roomId, json in pairs(data.result.rooms) do
    roomData = rapidjson.decode(json)
    if not roomData or not roomData.roomId then
      return
    end
    room = ChatManager2:GetInstance().Room:CreateChatRoom(roomData.roomId, roomData.group)
    if room then
      room:onParseServerData(roomData, true)
      ChatManager2:GetInstance().Room:onParseServerChatData(roomData.roomId, roomData.msgs.msgs, RequestType.InitFetch)
      self:AddClassifyRoomDic(room)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.Chat_GetFriendList)
end

function ChatRoomManager:GetAllUnblockedPrivateRoomDatas(hasGroupChat)
  local results = {}
  for roomId, _ in pairs(self.localTopRoomDic) do
    local room = self:GetRoomData(roomId)
    if room then
      if room:isPrivateChat() then
        local otherUser = room:getPrivateOtherMember()
        if otherUser then
          local notBlocked = not ChatManager2:GetInstance().Restrict:isInRestrictList(otherUser.uid, RestrictType.BLOCK)
          if notBlocked then
            table.insert(results, room)
          end
        end
      elseif hasGroupChat and room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
        table.insert(results, room)
      end
    end
  end
  for privateRoomId, _ in pairs(self.privateRoomDic) do
    local room = self:GetRoomData(privateRoomId)
    if room and room:isPrivateChat() and self.localTopRoomDic[room.roomId] == nil and self:isValidPrivateRoom(room) then
      table.insert(results, room)
    end
  end
  for groupRoomId, _ in pairs(self.groupRoomDic) do
    local room = self:GetRoomData(groupRoomId)
    if room and self.localTopRoomDic[room.roomId] == nil and hasGroupChat then
      table.insert(results, room)
    end
  end
  return results
end

function ChatRoomManager:GetP2PListCountParam()
  local room
  local kickedRoomCount, groupRoomCount = 0, 0
  for roomId, v in pairs(self.groupRoomDic) do
    room = self:GetRoomData(roomId)
    if room then
      if room:IsKickedRoom() then
        kickedRoomCount = kickedRoomCount + 1
      else
        groupRoomCount = groupRoomCount + 1
      end
    end
  end
  local result = {
    privateCount = table.count(self.privateRoomDic),
    groupChatCount = groupRoomCount,
    kickedChatCount = kickedRoomCount
  }
  return result
end

function ChatRoomManager:GetAllPrivateRoomDatas()
  local results = {}
  for _, room in pairs(self.roomDatas) do
    if room:isPrivateChat() then
      table.insert(results, room)
    end
  end
  return results
end

function ChatRoomManager:IsExistRoomId(roomId)
  if not roomId then
    return false
  end
  return self.roomDatas[roomId] ~= nil
end

function ChatRoomManager:IsExistGmChannel()
  local temp = self:GetRoomDatas()
  for k, roomData in pairs(temp) do
    if roomData:IsGmRoom() then
      return true
    end
  end
  return false
end

function ChatRoomManager:onJoinRoomOK()
  self:__syncFromCache()
  self:SaveRoomDatas()
end

function ChatRoomManager:OnGetCustomRoomList(rooms)
  for roomId, jsonStr in pairs(rooms) do
    local roomInfo = rapidjson.decode(jsonStr)
    if roomInfo then
      if roomInfo.group == ChatGroupType.GROUP_SEASON_ROOM then
        if SeasonUtil.IsInSeason() then
          local room = self:CreateChatRoom(roomInfo.roomId, roomInfo.group)
          room:onParseServerData(roomInfo, true)
        end
        goto lbl_76
      elseif (roomInfo.group == ChatGroupType.GROUP_DRAGON_ALL_SERVER or roomInfo.group == ChatGroupType.GROUP_DRAGON_SELF_SERVER) and not BattleFieldUtil.InBattleField() then
        local Net = ChatManager2:GetInstance().Net
        Net:SendMessage(ChatMsgDefines.RoomLeave, roomInfo.roomId)
        if roomInfo.group == ChatGroupType.GROUP_DRAGON_ALL_SERVER then
          self:RemoveDragonSeverAllRoom()
          goto lbl_76
        end
        self:RemoveDragonSeverSelfRoom()
        goto lbl_76
      end
      local room = self:CreateChatRoom(roomInfo.roomId, roomInfo.group)
      room:onParseServerData(roomInfo, true)
      self:AddClassifyRoomDic(room)
    end
    ::lbl_76::
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UNREAD_UPDATE)
end

function ChatRoomManager:AddClassifyRoomDic(room, localTop)
  if localTop then
    self.localTopRoomDic[room.roomId] = true
    return
  end
  if room:isPrivateChat() then
    self.privateRoomDic[room.roomId] = true
  end
  if room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    self.groupRoomDic[room.roomId] = true
  end
end

function ChatRoomManager:RemoveTopRoomDic(roomId)
  self.localTopRoomDic[roomId] = nil
end

function ChatRoomManager:CreateChatRoom(roomId, group)
  local isNew = false
  local room = self:GetRoomData(roomId)
  if room == nil then
    room = self:CreateChatRoomData(roomId, group)
    self.roomDatas[roomId] = room
    isNew = true
    ChatPrint("createChatRoom: " .. roomId)
  else
    ChatPrint("createChatRoom but exist!!! : " .. roomId)
  end
  return room, isNew
end

function ChatRoomManager:onDBLatestChat(roomId, results)
  ChatPrint("onDBLatestChat: " .. roomId .. ", results: " .. #results)
  if #results == 0 then
    return
  end
  local room = self:GetRoomData(roomId)
  if room == nil then
    ChatPrint("no room???!!!")
    return
  end
  room:__addChatDatas(results)
end

function ChatRoomManager:GetRecentlyPrivateRoomList()
  local list = {}
  for _, room in pairs(self.roomDatas) do
    if room:isPrivateChat() then
      table.insert(list, room)
    end
  end
  table.sort(list, function(a, b)
    return a.lastMsgTime > b.lastMsgTime
  end)
  local count = #list > refreshCount and refreshCount or #list
  local ids = {}
  for i = 1, count do
    table.insert(ids, list[i].roomId)
  end
  return ids
end

function ChatRoomManager:requestMultiRoomLatestMsg(roomIds)
  if roomIds == nil then
    ChatPrint("requestMultiRoomLatestMsg param error!")
    return
  end
  table.removebyfunc(roomIds, function(roomId)
    if table.hasvalue(self.requestRoomMsg, roomId) then
      return true
    end
    if roomId == QuestRoomId then
      return true
    end
  end)
  if 0 < #roomIds then
    ChatPrint("requestMultiRoomLatestMsg")
    table.insertto(self.requestRoomMsg, roomIds)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, roomIds)
  end
  return true
end

function ChatRoomManager:requestLatestMsg(roomId)
  if table.hasvalue(self.requestRoomMsg, roomId) then
    return false
  end
  table.insert(self.requestRoomMsg, roomId)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, {roomId})
  return true
end

function ChatRoomManager:onRequestLatestMsg(serverData)
  ChatPrint("onRequestLatestMsg")
  local roomDatas = serverData.result.rooms
  if roomDatas == nil or roomDatas[1] == nil then
    ChatPrint("request error!")
    return
  end
  for _, data in pairs(serverData.result.rooms) do
    local roomData = self:GetRoomData(data.roomId)
    if roomData ~= nil then
      roomData:onParseServerData(data, true)
      self:onParseServerChatData(data.roomId, data.msgs, RequestType.InitFetch)
    else
    end
    table.removebyvalue(self.requestRoomMsg, data.roomId)
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UNREAD_UPDATE)
  if #self.requestRoomMsg == 0 then
    local User = ChatManager2:GetInstance().User
    User:SetRequestUserInfo(true)
  end
  if roomDatas[1].group == ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM or roomDatas[1].group == ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM then
    return
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UPDATE_ROOM_HISTORY_MSG)
end

function ChatRoomManager:onRequestLatestMsg_EasterEggChat(serverData)
  local roomServerData = serverData.result.rooms
  if roomServerData == nil or table.count(roomServerData) ~= 1 then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\232\142\183\229\143\150\229\189\147\229\137\141\229\189\169\232\155\139\230\136\191\233\151\180\230\149\176\230\141\174\228\184\141\230\173\162\228\184\128\228\184\170\239\188\129\230\156\137\233\151\174\233\162\152")
    return
  end
  local data = roomServerData[1]
  local roomData = self:GetRoomData(data.roomId)
  if roomData ~= nil then
    roomData:onParseServerData(data, true)
  end
end

function ChatRoomManager:onParseServerChatDataByRoom(room, msgs)
  if not room then
    return
  end
  if room then
    room:SetMsgSuccess()
    room:CheckIsReachFirstMessage(msgs)
  end
  local addChats = {}
  for i = 1, #msgs do
    local newchatData = self:CreateChatMessage()
    newchatData:onParseServerData(msgs[i])
    if not newchatData:canSkip() and self:AddRoomChat(room, newchatData) then
      table.insert(addChats, newchatData)
    end
  end
  room:sort()
  room:PrintRoomMsgTime()
  if room.isJump then
    local roomData = ChatInterface.getRoomData(room.roomId)
    if room:GetLastMsgSeqId() > roomData:getFirstSeqId() then
      roomData:__addChatDatas(room.msgs)
      self:ClearJumpMsgRoom()
    end
  end
end

function ChatRoomManager:onParseServerChatData(roomId, msgs, requestType)
  if not msgs then
    return
  end
  ChatPrint("onParseServerChatData : roomId = " .. roomId .. ", count = " .. #msgs)
  local room = self:GetRoomData(roomId)
  self:onParseServerChatDataByRoom(room, msgs)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_HISTORYMSG_UPDATA, {
    roomId = room.roomId,
    requestType = requestType
  })
end

function ChatRoomManager:OnParseServerChatDataByOneRoom(roomId, msgs)
  local room = self:GetRoomData(roomId)
  if room then
    self:onParseServerChatDataByRoom(room, msgs)
  else
    Logger.LogWarning("[\232\173\166\229\145\138] \232\191\148\229\155\158\230\156\172\229\156\176\230\151\160\231\188\147\229\173\152\230\136\191\233\151\180 \230\163\128\230\159\165\230\149\176\230\141\174 roomid\239\188\154" .. tostring(roomId))
  end
end

function ChatRoomManager:OnServerPassRoom(roomId, requestType)
  local roomData = self:GetEffectiveRoomData(roomId)
  if not roomData or not roomData.isAutoFetchMissingData then
    return
  end
  local seqId = roomData.historyState[requestType]
  local msgs = roomData:GetUnblockedChatDatas()
  local index
  index = ChatInterface.GetUtil().BinarySearchBySeqId(msgs, seqId)
  if not index and 0 < #msgs then
    seqId = msgs[#msgs].seqId
  end
  if not seqId then
    return
  end
  roomData.historyState[requestType] = seqId
  local roomMsgs = self:GetRoomMsg(roomId, requestType, seqId, ChatHistoryFetchSize)
  self:RemoveRoomHistoryState(roomId, requestType)
  if roomMsgs and #roomMsgs >= ChatHistoryFetchSize or roomData:GetIsChatHistoryEnd(requestType) or roomData:IsMaxFetchCount(requestType) then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_HISTORYMSG_UPDATA, {
      roomId = roomId,
      requestType = requestType,
      seqId = seqId
    })
  else
    local startSeqId = self:HandleMsgNotFound(roomData, roomId, seqId, requestType)
    if startSeqId then
      roomData:UpdateHistoryCount(requestType, startSeqId)
    end
  end
end

function ChatRoomManager:GetAllUserInRoom(roomId, tbl)
  if type(tbl) ~= "table" then
    return
  end
  local roomData = self:GetRoomData(roomId)
  if roomData == nil then
    return
  end
  for _, msg in ipairs(roomData.msgs) do
    if not table.hasvalue(tbl, msg.senderUid) then
      table.insert(tbl, msg.senderUid)
    end
  end
end

function ChatRoomManager:GetAllUserInRooms(tbl)
  for _, room in pairs(self.roomDatas) do
    self:GetAllUserInRoom(room.roomId, tbl)
  end
  return tbl
end

function ChatRoomManager:GetNoticeId(noticeId)
  if LuaEntry.Player:IsInAlliance() and noticeId then
    return LuaEntry.Player:GetAllianceUid() .. noticeId .. "_notice"
  end
end

function ChatRoomManager:GetNoticeMsgs(noticeId)
  local notRoomId = self:GetNoticeId(noticeId)
  local room = self:GetRoomData(notRoomId)
  room = room or self:CreateChatRoom(notRoomId, ChatGroupType.GROUP_ALLIANCE_NOTICE_COMMENTS)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_ALLIANCE_NOTICE, notRoomId)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomV2, notRoomId, 1)
  return room
end

function ChatRoomManager:GetRoomData(roomId)
  if type(roomId) ~= "string" then
    if roomId then
      printError("ChatRoomManager:GetRoomData error !!!!!!!!!!!" .. roomId)
    else
      printError("ChatRoomManager:GetRoomData error !!!!!!!!!!! roomId is Nil")
    end
    return nil
  end
  local t = self.roomDatas[roomId]
  return t
end

function ChatRoomManager:CheckRoomTop(roomId)
  local roomData = self:GetRoomData(roomId)
  if roomData and roomData.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    self:RoomTop(roomData.roomId, roomData.group, false)
  end
end

function ChatRoomManager:RemoveClassifyRoomDic(roomId)
  self.privateRoomDic[roomId] = nil
  self.localTopRoomDic[roomId] = nil
  self.groupRoomDic[roomId] = nil
end

function ChatRoomManager:RemoveRoomData(roomId)
  if roomId ~= nil then
    ChatPrint("RemoveRoomData:" .. roomId)
    self:CheckRoomTop(roomId)
    self:RemoveClassifyRoomDic(roomId)
    local voiceMgr = ChatManager2:GetInstance().Voice
    if voiceMgr and voiceMgr.RemoveVoiceRoom then
      voiceMgr:RemoveVoiceRoom(roomId)
    end
    self.roomDatas[roomId] = nil
  end
end

function ChatRoomManager:__addSendingData(chatData)
  table.insert(self.sendingDataArr, chatData)
end

function ChatRoomManager:__removeSendingChat(chatData)
  table.removebyvalue(self.sendingDataArr, chatData)
end

function ChatRoomManager:__findSendingData(chatData)
  local findChatData
  for k, v in pairs(self.sendingDataArr) do
    if v.sendLocalTime == chatData.sendLocalTime and v.senderUid == chatData.senderUid then
      findChatData = v
      break
    end
  end
  return findChatData
end

function ChatRoomManager:SetCacheRoomInfos(roomInfos)
  local t = {}
  table.walk(roomInfos, function(k, v)
    t[v.roomId] = v
  end)
  self.cacheRoomInfos = t
end

function ChatRoomManager:__syncFromCache()
  if table.IsNullOrEmpty(self.roomDatas) or table.IsNullOrEmpty(self.cacheRoomInfos) then
    ChatPrint("__syncFromCache nil")
    return
  end
  table.walk(self.roomDatas, function(k, v)
    local cache = self.cacheRoomInfos[k]
    if cache then
      v:SetPin(cache.isPin)
    end
  end)
end

function ChatRoomManager:__syncToCache()
  if table.IsNullOrEmpty(self.roomDatas) or table.IsNullOrEmpty(self.cacheRoomInfos) then
    ChatPrint("__syncFromCache nil")
    return
  end
  table.walk(self.roomDatas, function(k, v)
    local cache = self.cacheRoomInfos[k]
    if cache then
      cache.isPin = v.isPin
    end
  end)
end

function ChatRoomManager:GetChatDataByMessage(data)
  local roomData = self:GetRoomData(data.roomId)
  if roomData then
    local chatData = roomData:getChatDataBySeqId(data.seqId)
    if not chatData or chatData:GetIsBlockMessages() then
      chatData = self:CreateChatMessage()
    end
    chatData:onParseServerData(data)
    return chatData
  else
  end
end

function ChatRoomManager:AddRoomChat(roomData, chatData, isPush)
  if chatData == nil or roomData == nil then
    return false
  end
  if roomData.roomId ~= chatData.roomId then
    return false
  end
  local ret = roomData:__addChatData(chatData, isPush)
  local userMgr = ChatManager2:GetInstance().User
  local chatUserInfo = userMgr:getChatUserInfo(chatData.senderUid)
  if not chatUserInfo then
    userMgr:requestSingleUserInfo(chatData.senderUid)
  end
  return ret
end

function ChatRoomManager:RemoveFakePhotoChatData(roomId, picVer)
  local roomData = self:GetRoomData(roomId)
  if not roomData then
    return
  end
  roomData:RemoveFackeChatDataByPicVer(picVer)
end

function ChatRoomManager:RemoveAllFakePhotoChatData()
  local roomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
  local roomData = self:GetRoomData(roomId)
  if not roomData then
    return
  end
  roomData:RemoveAllFakeChatData()
end

function ChatRoomManager:AddChat(chatData, inDB, isPush)
  local roomData = self:GetRoomData(chatData.roomId)
  if not roomData then
    return false
  end
  return self:AddRoomChat(roomData, chatData, isPush)
end

function ChatRoomManager:GetRoomDataByGroup(group)
  for roomId, roomData in pairs(self.roomDatas) do
    if roomData.group == group then
      return roomData
    end
  end
  return nil
end

function ChatRoomManager:GetOwnerRoomCount()
  local playerUid = ChatInterface.getPlayerUid()
  local ownerRoomNum = 0
  for roomId, roomData in pairs(self.roomDatas) do
    if roomData.owner == playerUid then
      ownerRoomNum = ownerRoomNum + 1
    end
  end
  return ownerRoomNum
end

function ChatRoomManager:UserBanTime(uid)
  local chatUserInfo = ChatInterface.getUserManagerInst():getChatUserInfo(uid)
  if chatUserInfo then
    return chatUserInfo.chatBantime
  end
  return 0
end

function ChatRoomManager:GetChat(roomId, seqId)
  local roomData = self:GetRoomData(roomId)
  if roomData ~= nil then
    return roomData:getChatDataBySeqId(seqId)
  end
  return nil
end

function ChatRoomManager:UpdateChatData(chatData)
  if not chatData then
    ChatPrint("\230\156\141\229\138\161\229\153\168\232\191\148\229\155\158\229\143\145\233\128\129\229\164\177\232\180\165\231\154\132result\239\188\140\231\155\174\229\137\141\230\178\161\230\156\137")
    return
  end
  ChatPrint("\230\156\141\229\138\161\229\153\168\232\191\148\229\155\158\230\182\136\230\129\175")
  local findChatData = self:GetChat(chatData.roomId, chatData.seqId)
  if findChatData then
    local oldSeqId = findChatData.seqId
    findChatData.seqId = chatData.seqId
    findChatData.serverTime = chatData.serverTime
    findChatData.interactLike = chatData.interactLike
    findChatData.interactDisLike = chatData.interactDisLike
    findChatData.emoji_info = chatData.emoji_info
    self:UpdateChatEmojiData(findChatData, chatData)
    findChatData:setSendState(SendStateType.OK)
  else
    ChatPrint("UpdateSendingChat but not found ?!!!")
  end
end

function ChatRoomManager:UpdateChatEmojiData(findChatData, chatData)
  if #findChatData.cacheEmojis > 0 then
    local cacheEmojis = table.remove(findChatData.cacheEmojis, 1)
    local removes = {}
    for k, v in pairs(chatData.emojis) do
      if cacheEmojis[k] and cacheEmojis[k].key == v.emoji then
        v.self = cacheEmojis[k].data.self
      end
    end
    for k, v in pairs(findChatData.emojis) do
      if cacheEmojis[k] and cacheEmojis[k].key == v.emoji then
        local newEmojiData = chatData.emojis[k]
        if newEmojiData then
          if v.self == 1 == (newEmojiData.self == 1) then
            v.count = newEmojiData.count
          elseif newEmojiData.self == 1 then
            v.count = newEmojiData.count - 1
          else
            v.count = newEmojiData.count + 1
          end
        end
      end
      if 0 >= v.count then
        table.insert(removes, k)
      end
    end
    for _, v in pairs(removes) do
      findChatData.emojis[v] = nil
    end
  else
    local oldEmojisDict = {}
    for index, v in pairs(findChatData.emojis) do
      oldEmojisDict[v.emoji] = index
    end
    for k, v in pairs(chatData.emojis) do
      if oldEmojisDict[v.emoji] then
        local oldPos = oldEmojisDict[v.emoji]
        findChatData.emojis[oldPos].count = v.count
        oldEmojisDict[v.emoji] = nil
      else
        table.insert(findChatData.emojis, v)
      end
    end
    local removeEmojiList = {}
    for emoji, index in pairs(oldEmojisDict) do
      table.insert(removeEmojiList, {index = index, emoji = emoji})
    end
    table.sort(removeEmojiList, function(a, b)
      return a.index > b.index
    end)
    for _, v in pairs(removeEmojiList) do
      table.remove(findChatData.emojis, v.index)
    end
  end
end

function ChatRoomManager:GetLastChatByRoom(roomId)
  local roomData = self:GetRoomData(roomId)
  if roomData then
    return roomData:getLastChatData()
  end
  return nil
end

function ChatRoomManager:GetLastChatMsgs(roomId, count)
  local roomData = self:GetRoomData(roomId)
  local msglist = {}
  if roomData then
    msglist = roomData:GetLastChatDatas(true, count)
  end
  return msglist
end

function ChatRoomManager:GetLastUnblockedChat()
  local lastChatData = self:GetLastChat()
  return lastChatData
end

function ChatRoomManager:HasCustomRoom()
  for _, roomData in pairs(self.roomDatas) do
    if roomData.group == ChatGroupType.GROUP_CUSTOM then
      return true
    end
  end
  return false
end

function ChatRoomManager:UpdateSendingChat(chatData)
  if not chatData then
    ChatPrint("\230\156\141\229\138\161\229\153\168\232\191\148\229\155\158\229\143\145\233\128\129\229\164\177\232\180\165\231\154\132result\239\188\140\231\155\174\229\137\141\230\178\161\230\156\137")
    return false
  end
  ChatPrint("\230\156\141\229\138\161\229\153\168\232\191\148\229\155\158\230\182\136\230\129\175")
  local findChatData = self:__findSendingData(chatData)
  if findChatData then
    if findChatData.sendState ~= SendStateType.PENDING then
      return false
    end
    local oldSeqId = findChatData.seqId
    findChatData.seqId = chatData.seqId
    findChatData.serverTime = chatData.serverTime
    findChatData.interactLike = chatData.interactLike
    findChatData.interactDisLike = chatData.interactDisLike
    findChatData.emoji_info = chatData.emoji_info
    findChatData.msg = chatData.msg
    findChatData:setSendState(SendStateType.OK)
    local room = self:GetRoomData(findChatData.roomId)
    if room then
      room:readMsg(findChatData.seqId)
    end
    self:__removeSendingChat(findChatData)
    return true
  else
    ChatPrint("UpdateSendingChat but not found ?!!!")
    return false
  end
end

function ChatRoomManager:GetIsShowPrivateRoom(roomId)
  if self.privateRoomDic[roomId] or self.groupRoomDic[roomId] or self.localTopRoomDic[roomId] then
    return true
  end
end

function ChatRoomManager:isValidPrivateRoom(room)
  local otherUser = room:getPrivateOtherMember()
  if not otherUser or not room then
    return false
  end
  local notBlocked = not ChatManager2:GetInstance().Restrict:isInRestrictList(otherUser.uid, RestrictType.BLOCK)
  local hasMessages = room.msgs and room.lastSeqId >= 1
  return notBlocked and hasMessages
end

function ChatRoomManager:GetAllRoomNewMsgCount()
  local result = {
    total = 0,
    private = 0,
    latestPrivateMsg = nil
  }
  local showUnreadCount = 0
  local showUnreadDot = 0
  local latestPrivateMsgTime = 0
  local roomDatas = self:GetRoomDatas()
  local template, isCanShow, redCount
  for _, roomData in ipairs(roomDatas) do
    template = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(roomData.group)
    if template then
      redCount = 0
      if not roomData:GetNotDisturbing() then
        if template.dots_type <= UnreadNotificationType.NoNotification then
          redCount = roomData:getNewMsgNum()
          showUnreadCount, showUnreadDot = self:GetRoomShowTypeAndNumber(roomData, showUnreadCount, showUnreadDot)
          result[roomData.roomId] = redCount
        elseif self:GetIsShowPrivateRoom(roomData.roomId) then
          isCanShow = true
          redCount = roomData:getNewMsgNum()
          if roomData:isPrivateChat() then
            isCanShow = self:isValidPrivateRoom(roomData)
          end
          if isCanShow then
            showUnreadCount, showUnreadDot = self:GetRoomShowTypeAndNumber(roomData, showUnreadCount, showUnreadDot)
            result.private = result.private + redCount
            if latestPrivateMsgTime < roomData.lastMsgTime then
              latestPrivateMsgTime = roomData.lastMsgTime
              result.latestPrivateMsg = roomData:getLastChatData()
              result.lastPrivateRoom = roomData
            end
            result[roomData.roomId] = redCount
          end
        end
      end
    end
  end
  if 0 < showUnreadCount then
    result.redType = UnreadNotificationType.ShowUnreadCount
    result.showNumber = showUnreadCount
  elseif 0 < showUnreadDot then
    result.redType = UnreadNotificationType.ShowUnreadDot
    result.showNumber = showUnreadDot
  else
    result.redType = UnreadNotificationType.NoNotification
    result.showNumber = 0
  end
  return result
end

function ChatRoomManager:GetRoomShowTypeAndNumber(roomData, showUnreadCount, showUnreadDot)
  local type = self:GetRoomRedDotType(roomData.group)
  if type == UnreadNotificationType.ShowUnreadCount then
    showUnreadCount = showUnreadCount + (roomData and roomData:getNewMsgNum() or 0)
  end
  if type == UnreadNotificationType.ShowUnreadDot then
    showUnreadDot = showUnreadDot + (roomData and roomData:getNewMsgNum() or 0)
  end
  return showUnreadCount, showUnreadDot
end

function ChatRoomManager:GetPrivateRoomNewMsgCount()
  local count = 0
  local roomDatas = self:GetRoomDatas()
  for _, roomData in ipairs(roomDatas) do
    if roomData:isCustomRoom() then
      count = count + roomData:getNewMsgNum()
    end
  end
  return count
end

function ChatRoomManager:InitPrivateLastMsg()
  if ChatManager2:GetInstance():GetConnectionError() then
    ChatManager2:GetInstance():SetConnectionError(false)
    local chatView = UIManager:GetInstance():GetWindow(UIWindowNames.UIChatNew_v2)
    if chatView then
      local ids = self:GetRecentlyPrivateRoomList()
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.Roomlast, ids)
    end
  end
end

function ChatRoomManager:AddRedpack(pack)
  if not self.redpacks[pack.uuid] then
    self.redpacks[pack.uuid] = pack
  end
end

function ChatRoomManager:GetRedpack(uuid)
  return self.redpacks[uuid]
end

function ChatRoomManager:refreshRedPacketStatus(redPacketAttachmentIdStr)
  ChatPrint("redPacketAttachmentIdStr = %s", redPacketAttachmentIdStr)
  
  local function updateRedPaketAttachId(roomData, attachmentId, where)
    local dbChatDatas = roomData:searchByWhere(where)
    if dbChatDatas ~= nil then
      for i = 1, #dbChatDatas do
        local chatData = roomData:getChatDataBySeqId(dbChatDatas[i].seqId)
        chatData = chatData or self:CreateChatMessage()
        local tArr = string.split(chatData.attachmentId, "|")
        chatData.attachmentId = attachmentId
        if #tArr == 3 then
          chatData.attachmentId = string.format("%s|%s", chatData.attachmentId, tArr[3])
        end
      end
    end
  end
  
  local attachmentArr = string.split(redPacketAttachmentIdStr, ",")
  for _, attachmentId in pairs(attachmentArr) do
    local attachArr = string.split(attachmentId, "|")
    local attachMentIDString = "%" .. attachArr[1] .. "%"
    local where = string.format("((post ='%s' AND ( attachmentId LIKE '%s')))", PostType.RedPackge, attachMentIDString)
    local countryRoomData = self:GetRoomDataByGroup(ChatGroupType.GROUP_COUNTRY)
    if countryRoomData then
      updateRedPaketAttachId(countryRoomData, attachmentId, where)
    end
    local allianceRoomData = self:GetRoomDataByGroup(ChatGroupType.GROUP_ALLIANCE)
    if allianceRoomData then
      updateRedPaketAttachId(allianceRoomData, attachmentId, where)
    end
  end
end

function ChatRoomManager:getPrivateRoomData(toUid)
  if string.IsNullOrEmpty(toUid) or ChatInterface.getPlayerUid() == toUid then
    return nil
  end
  local roomDatas = self:GetRoomDatas()
  for _, roomData in ipairs(roomDatas) do
    if roomData:isPrivateChat() and string.find(roomData.roomId, toUid) then
      return roomData
    end
  end
  return nil
end

function ChatRoomManager:GetCanShareChannel()
  local values = {}
  for k, v in pairs(self.roomDatas) do
    values[#values + 1] = v
  end
  return values
end

function ChatRoomManager:SaveRoomDatas()
  self:__syncToCache()
end

function ChatRoomManager:SetMineChatEmojiData(roomId, msgSeqId, emoji_data)
  local roomData = self.emojiChatGPT[roomId]
  if roomData == nil then
    roomData = {}
    self.emojiChatGPT[roomId] = roomData
  end
  roomData[msgSeqId] = emoji_data
end

function ChatRoomManager:GetMineChatEmojiData(roomId, msgSeqId)
  local roomData = self.emojiChatGPT[roomId]
  if roomData ~= nil then
    return roomData[msgSeqId]
  end
  return nil
end

function ChatRoomManager:ResetRoomFlag()
  self.__initRoomOKFlag = 0
  self.__initPullOKFlag = nil
end

function ChatRoomManager:OnInitRoomCmdBack()
  if not self.__initRoomOKFlag then
    self.__initRoomOKFlag = 0
  end
  self.__initRoomOKFlag = self.__initRoomOKFlag + 1
  if self.__initRoomOKFlag == 2 then
    local allRoomIds = {}
    self:InitRoomTop()
    for _, roomData in pairs(self.roomDatas) do
      if roomData.group ~= ChatGroupType.GROUP_ALLIANCE_NOTICE and roomData.group ~= ChatGroupType.GROUP_EASTER_EGG_ROOM and not roomData:IsKickedRoom() then
        table.insert(allRoomIds, roomData.roomId)
      end
    end
    self:requestMultiRoomLatestMsg(allRoomIds)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
  end
end

function ChatRoomManager:IsInitRoomDone()
  return self.__initRoomOKFlag and self.__initRoomOKFlag >= 2
end

function ChatRoomManager:OnInitPullCmdBack()
  if not self.__initPullOKFlag then
    self.__initPullOKFlag = 0
  end
  self.__initPullOKFlag = self.__initPullOKFlag + 1
end

function ChatRoomManager:GetAllPrivateRoomList()
  local roomDatas = self:GetRoomDatas()
  local roomList = {}
  for _, roomData in ipairs(roomDatas) do
    if roomData:isPrivateChat() then
      table.insert(roomList, roomData)
    end
  end
  return roomList
end

function ChatRoomManager:GetAllPrivateAndGroupRoomList()
  local roomDatas = self:GetRoomDatas()
  local roomList = {}
  for _, roomData in ipairs(roomDatas) do
    if roomData:isPrivateChat() or roomData.group == ChatGroupType.GROUP_CUSTOM_GROUP then
      table.insert(roomList, roomData)
    end
  end
  return roomList
end

function ChatRoomManager:GetPrivateRoomLastMsg()
  local roomList = self:GetAllPrivateRoomList()
  table.sort(roomList, function(a, b)
    return a.lastMsgTime > b.lastMsgTime
  end)
  local getList = {}
  for i = 1, refreshCount do
    if roomList[i] and table.count(roomList[i].msgs) == 0 then
      table.insert(getList, roomList[i].roomId)
    end
  end
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.Roomlast, getList)
end

function ChatRoomManager:IsInitPullDone()
  return self.__initPullOKFlag and self.__initRoomOKFlag >= 2
end

function ChatRoomManager:GetPrivateUserIdByRoomId(roomId)
  local arr = string.split(roomId, "_")
  if #arr ~= 4 then
    return ""
  end
  if arr[1] == "PRIVATE" and arr[3] == "to" then
    if arr[2] == ChatInterface.getPlayerUid() then
      return arr[4]
    elseif arr[4] == ChatInterface.getPlayerUid() then
      return arr[2]
    end
  end
  return ""
end

function ChatRoomManager:GetChannelFromRoomId(roomId)
  local chatData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
  if chatData then
    if chatData:isWorldRoom() then
      return ChatShareChannel.TO_COUNTRY
    elseif chatData:isAllianceRoom() then
      return ChatShareChannel.TO_ALLIANCE
    elseif chatData:isLanguageRoom() then
      return ChatShareChannel.TO_LANGUAGE
    else
      return ChatShareChannel.TO_PERSON
    end
  end
end

function ChatRoomManager:ShowNewYearGift(message)
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
  end
end

function ChatRoomManager:ClearAllRoomStickerNode()
  self.stickerNodeDic = {}
  self.stickerNodeList = {}
  if self.stickerMatPoolList then
    for _, v in pairs(self.stickerMatPoolList) do
      local materialList = v
      for i = 1, #materialList do
        GameObject.Destroy(materialList[i])
        materialList[i] = nil
      end
    end
    self.stickerMatPoolList = {}
  end
  if self.stickerMatOfNodeDic then
    for k, v in pairs(self.stickerMatOfNodeDic) do
      GameObject.Destroy(v)
    end
    self.stickerMatOfNodeDic = {}
  end
  EventManager:GetInstance():Broadcast(EventId.CLEAR_CHAT_DYNAMIC_STICKER_GO)
end

function ChatRoomManager:ClearAllStickerDiceData()
  self.stickerDiceDataDic = self.stickerDiceDataDic or {}
  for k, v in pairs(self.stickerDiceDataDic) do
    self:ClearStickerDiceData(k)
  end
end

function ChatRoomManager:SetStickerDiceDataDic(key, diceTimer, chatData)
  self.stickerDiceDataDic = self.stickerDiceDataDic or {}
  if self.stickerDiceDataDic[key] then
    logger.LogError("\233\170\176\229\173\144\231\155\184\229\133\179\231\154\132timer\229\146\140chatData\228\184\141\229\186\148\229\173\152\229\156\168\232\162\171\233\135\141\231\189\174\228\184\164\230\172\161\231\154\132\230\131\133\229\134\181\239\188\140\232\175\183\230\163\128\230\159\165\239\188\129")
    self:ClearStickerDiceData(key)
  end
  self.stickerDiceDataDic[key] = {diceTimer, chatData}
end

function ChatRoomManager:ClearStickerDiceData(key)
  self.stickerDiceDataDic = self.stickerDiceDataDic or {}
  if self.stickerDiceDataDic[key] == nil then
    return
  end
  local tmpTimer = self.stickerDiceDataDic[key][1]
  if tmpTimer then
    tmpTimer:Stop()
  end
  local tmpChatData = self.stickerDiceDataDic[key][2]
  if tmpChatData then
    tmpChatData:SetDiceRollState(true)
  end
  self.stickerDiceDataDic[key] = nil
end

function ChatRoomManager:SetStickerNodeDic(key, Node, mat)
  local stickerNodeLength = #self.stickerNodeList
  if self.stickerNodeDic[key] ~= nil then
    for i = 1, stickerNodeLength do
      if self.stickerNodeList[i][1] == key then
        table.remove(self.stickerNodeList, i)
        self:RecycleUnusedMat(key, self.stickerMatOfNodeDic[key])
        break
      end
    end
  elseif stickerNodeLength >= maxStickerPoolCount then
    local lastNode = self.stickerNodeList[stickerNodeLength]
    local key = lastNode[1]
    self.stickerNodeDic[key] = nil
    table.remove(self.stickerNodeList, stickerNodeLength)
    if not IsNull(lastNode[2]) then
      lastNode[2]:GameObjectRecycle()
    else
      logger.LogError("\230\173\164\230\151\182\231\154\132StickerNodeGO\228\184\186\231\169\186\239\188\140\229\183\178\231\187\143\232\162\171\229\155\158\230\148\182\229\155\158\229\142\187\228\186\134\239\188\129 ")
    end
    self:RecycleUnusedMat(key, self.stickerMatOfNodeDic[key])
  end
  table.insert(self.stickerNodeList, 1, {
    key,
    Node,
    mat
  })
  self.stickerNodeDic[key] = self.stickerNodeList[1]
end

function ChatRoomManager:GetStickerNodeDic(key)
  if self.stickerNodeDic[key] == nil then
    return nil
  end
  local tmpNode = self.stickerNodeDic[key]
  local stickerNodeLength = #self.stickerNodeList
  for i = 1, stickerNodeLength do
    if self.stickerNodeList[i][1] == key then
      table.remove(self.stickerNodeList, i)
      break
    end
  end
  table.insert(self.stickerNodeList, 1, tmpNode)
  self.stickerNodeDic[key] = self.stickerNodeList[1]
  return self.stickerNodeDic[key][2]
end

function ChatRoomManager:SetStickerMatOfNodeDic(key, mat)
  local curMat = self.stickerMatOfNodeDic[key]
  if curMat ~= nil then
    self:PushStickerMaterial(curMat)
  end
  self.stickerMatOfNodeDic[key] = mat
end

function ChatRoomManager:GetStickerMat(key)
  return self.stickerMatOfNodeDic[key]
end

function ChatRoomManager:RecycleUnusedMat(key, mat)
  if key and not IsNull(mat) then
    self:PushStickerMaterial(mat)
    self.stickerMatOfNodeDic[key] = nil
  end
  self:ClearStickerDiceData(key)
end

function ChatRoomManager:PushStickerMaterial(mat)
  self.stickerMatPoolList = self.stickerMatPoolList or {}
  self.stickerMatPoolList[mat.name] = self.stickerMatPoolList[mat.name] or {}
  table.insert(self.stickerMatPoolList[mat.name], mat)
end

function ChatRoomManager:PopStickerMaterial(matName)
  self.stickerMatPoolList = self.stickerMatPoolList or {}
  self.stickerMatPoolList[matName] = self.stickerMatPoolList[matName] or {}
  local mat
  local matListLength = #self.stickerMatPoolList[matName]
  if 0 < matListLength then
    mat = self.stickerMatPoolList[matName][matListLength]
    table.remove(self.stickerMatPoolList[matName], matListLength)
  elseif self.stickerMatAssetDic[matName] and self.stickerMatAssetDic[matName].asset ~= nil then
    mat = CS.UnityEngine.Material.Instantiate(self.stickerMatAssetDic[matName].asset)
    mat.name = matName
  end
  return mat
end

function ChatRoomManager:LoadStickerMatAssetAsyn(matName, callback)
  self.stickerMatPoolList = self.stickerMatPoolList or {}
  self.stickerMatPoolList[matName] = self.stickerMatPoolList[matName] or {}
  if #self.stickerMatPoolList[matName] > 0 then
    logger.LogError("\230\157\144\232\180\168\231\154\132Load\232\191\148\229\155\158\231\154\132Asset\228\184\186\231\169\186\239\188\140\228\189\134\230\152\175\229\141\180\230\156\137\230\157\144\232\180\168\229\174\158\228\190\139\239\188\140\229\188\130\229\184\184\239\188\129" .. matName)
    return
  end
  self.stickerMatAssetDic[matName] = Resource:LoadAssetAsync(string.format(ChatstickerMaterialPath, matName), typeof(CS.UnityEngine.Material))
  
  local function Onloaded(asset)
    if asset == nil then
      logger.LogError("Sticker\229\175\185\229\186\148\231\154\132\230\157\144\232\180\168\229\138\160\232\189\189\229\164\177\232\180\165\239\188\154" .. matName)
      return
    end
    if self.stickerMatAssetDic == nil or self.stickerMatAssetDic[matName] == nil or self.stickerMatAssetDic[matName].asset == nil then
      return
    end
    local mat = CS.UnityEngine.Material.Instantiate(self.stickerMatAssetDic[matName].asset)
    mat.name = matName
    callback(mat)
  end
  
  if self.stickerMatAssetDic[matName].completed then
    self.stickerMatAssetDic[matName].completed = self.stickerMatAssetDic[matName].completed + Onloaded
  else
    self.stickerMatAssetDic[matName].completed = Onloaded
  end
end

function ChatRoomManager:CreateFakePhotoChatData(fakeChatData)
  local roomMgr = ChatManager2:GetInstance().Room
  local chatData = roomMgr:CreateChatMessage()
  chatData:onParseFakeData(fakeChatData)
  roomMgr:AddChat(chatData)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_HISTORYMSG_UPDATA, {
    roomId = chatData.roomId,
    requestType = RequestType.ReceivePush,
    seqId = chatData.seqId
  })
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, chatData)
  return chatData
end

function ChatRoomManager:IsShowBubbleAllianceHelp(curChatGroupType)
  return DataCenter.GroupChatSetTemplateManager:GetCanShowHelpBubble(curChatGroupType)
end

function ChatRoomManager:CreateJumpMsgRoom(roomId)
  self.jumpMsgRoom = self:CreateChatRoomData(roomId)
  self.jumpMsgRoom.isJump = true
end

function ChatRoomManager:ClearJumpMsgRoom()
  self.jumpMsgRoom = nil
end

function ChatRoomManager:IsShowingJumpMsg()
  return self.jumpMsgRoom ~= nil
end

function ChatRoomManager:GetJumpMsgRoom()
  return self.jumpMsgRoom
end

function ChatRoomManager:JumpMsgPullLast(roomId, seqId)
  if self.jumpMsgRoom == nil then
    self:CreateJumpMsgRoom(roomId)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomGoto2, roomId, seqId)
    return seqId
  else
    local room = self.jumpMsgRoom
    if room:CanFetchMore(RequestType.PullLast) then
      self:UpdateSortState(roomId, RequestType.PullLast, seqId)
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomGoto, room.roomId, room:GetLastMsgSeqId(), 1)
      return seqId
    end
  end
end

function ChatRoomManager:JumpMsgPullPrevious(startSeqId)
  if self.jumpMsgRoom == nil then
    return
  end
  local room = self.jumpMsgRoom
  if room:CanFetchMore(RequestType.PullPrev) then
    self:UpdateSortState(room.roomId, RequestType.PullPrev, startSeqId)
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomGoto, room.roomId, room:getFirstSeqId(), 0)
    return startSeqId
  end
  return
end

function ChatRoomManager:GetTimestampAnchorSeqId(roomId)
  if self.timestampAnchorDic == nil then
    logger.LogError("\232\142\183\229\143\150\233\148\154\231\130\185\230\151\182\233\151\180\230\136\179\230\151\182\239\188\140\230\151\182\233\151\180\230\136\179\229\173\151\229\133\184\228\184\186\231\169\186\239\188\129")
    return nil
  end
  return self.timestampAnchorDic[roomId]
end

function ChatRoomManager:SetTimestampAnchorSeqId(roomId, seqId)
  self.timestampAnchorDic = self.timestampAnchorDic or {}
  self.timestampAnchorDic[roomId] = seqId
end

function ChatRoomManager:ClearAllTimestampAnchor()
  self.timestampAnchorDic = {}
end

function ChatRoomManager:GetFriendsCircleRoomId(uid)
  return ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM .. "_" .. uid .. "_friends_circle"
end

function ChatRoomManager:GetFriendsCirclePlayerUid(roomId, group)
  if string.IsNullOrEmpty(roomId) then
    return
  end
  local roomIdData = string.split(roomId, "_")
  if group == ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM then
    return roomIdData[3]
  elseif group == ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM then
    return roomIdData[4]
  end
end

function ChatRoomManager:GetFriendsCircleCommentRoomId(uid, seqId)
  return ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM .. "_" .. uid .. "_" .. seqId .. "_friends_circle_comment"
end

function ChatRoomManager:GetMomentRoomCache()
  local circleRoomId = self:GetFriendsCircleRoomId(LuaEntry.Player.uid)
  local roomData = ChatManager2:GetInstance().Room:GetRoomData(circleRoomId)
  if roomData == nil then
    return nil
  end
  return roomData:GetCacheData()
end

function ChatRoomManager:SetPhotoUploadState(picVer, state)
  self.photoUploadStateDic = self.photoUploadStateDic or {}
  self.photoUploadStateDic[picVer] = state
end

function ChatRoomManager:GetPhotoUploadState(picVer)
  return self.photoUploadStateDic[picVer]
end

function ChatRoomManager:SetPhotoTmpSaveFlag(picVer, state)
  self.photoTempSaveFlagDic = self.photoTempSaveFlagDic or {}
  self.photoTempSaveFlagDic[picVer] = state
end

function ChatRoomManager:GetPhotoTmpSaveFlag(picVer)
  return self.photoTempSaveFlagDic[picVer]
end

function ChatRoomManager:ClearPhotoPicVerStateAndFlag(picVer)
  if self.photoUploadStateDic then
    self.photoUploadStateDic[picVer] = nil
  end
  if self.photoTempSaveFlagDic then
    self.photoTempSaveFlagDic[picVer] = nil
  end
end

function ChatRoomManager:ClearPhotoDataInMoment(picVer)
  self.momentPhotoData = self.momentPhotoData or {}
  self.momentPhotoData[picVer] = nil
  self.momentPicVer = -1
end

function ChatRoomManager:TryClearSamePicVerPhotoDataInMoment(uploadPicVer)
  if uploadPicVer ~= self.momentPicVer then
    return
  end
  self:ClearPhotoDataInMoment(uploadPicVer)
end

function ChatRoomManager:SetMomentCurUploadPicVer(picVer)
  self.momentPicVer = picVer
end

function ChatRoomManager:SetPhotoData(picVer, photoData)
  self.momentPhotoData = self.momentPhotoData or {}
  self.momentPhotoData[picVer] = photoData
end

function ChatRoomManager:GetPhotoData(picVer)
  return self.momentPhotoData[picVer]
end

function ChatRoomManager:GetUploadPicVerAndPhotoDataInPanel()
  self.momentPhotoData = self.momentPhotoData or {}
  if self.momentPicVer == -1 then
    return -1, {}
  end
  return self.momentPicVer, self.momentPhotoData[self.momentPicVer]
end

function ChatRoomManager:GetMomentCurPhotoUploadState()
  if self.momentPicVer == -1 then
    return PhotoUploadState.None
  end
  return self.photoUploadStateDic[self.momentPicVer]
end

function ChatRoomManager:DeleteRoomMessage(roomId, seqId)
  local room = self:GetRoomData(roomId)
  if not room then
    return
  end
  room:DeleteMessage(seqId)
end

function ChatRoomManager:RoomTop(roomId, group, isAdd)
  local key = group == ChatGroupType.GROUP_CUSTOM and "PRIVATE_CHAT_STICKY_LIST" or "PRIVATE_CHAT_GROUPCHAT_STICKY_LIST"
  local stickyRoomList = CommonUtil.PlayerPrefsGetTable(key, {})
  local isFull = self:GetRoomTopMax()
  if stickyRoomList[tostring(roomId)] == nil and isFull and isAdd then
    UIUtil.ShowTipsId("convo_top_set_notice")
    return
  end
  local roomKey = tostring(roomId)
  local getRoomId = roomKey
  if group == ChatGroupType.GROUP_CUSTOM then
    getRoomId = ChatInterface.GetUtil().GeneratePrivateRoomId(roomId)
  end
  if isAdd then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    stickyRoomList[roomKey] = curTime
    local room = self:GetRoomData(getRoomId)
    if room then
      self:AddClassifyRoomDic(room, true)
    end
  else
    stickyRoomList[roomKey] = nil
    self:RemoveTopRoomDic(getRoomId)
  end
  CommonUtil.PlayerPrefsSetTable(key, stickyRoomList)
  return true
end

function ChatRoomManager:GetRoomIsTop(roomId, group)
  local key = group == ChatGroupType.GROUP_CUSTOM and "PRIVATE_CHAT_STICKY_LIST" or "PRIVATE_CHAT_GROUPCHAT_STICKY_LIST"
  local stickyRoomList = CommonUtil.PlayerPrefsGetTable(key, {})
  return stickyRoomList[tostring(roomId)] and true or false
end

function ChatRoomManager:GetRoomTopMax()
  local stickyRoomList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_STICKY_LIST", {})
  local groupRoomList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_GROUPCHAT_STICKY_LIST", {})
  return table.count(stickyRoomList) + table.count(groupRoomList) >= STICKY_MAX_COUNT
end

function ChatRoomManager:GetSaveRedDotTypeStr(chatGroupType)
  return chatGroupType .. "chatRedDontType"
end

function ChatRoomManager:InitGroupRedDotTypeDic()
  self.chatRoomRedDotTypeDic = self:GetRoomGroupRedDotTypeDic()
end

function ChatRoomManager:GetRoomGroupRedDotTypeDic()
  return CommonUtil.PlayerPrefsGetTable("CHAT_ROOM_REDDOT_TYPE_DIC", {})
end

function ChatRoomManager:GetRoomRedDotType(group)
  if not self.chatRoomRedDotTypeDic then
    self:InitGroupRedDotTypeDic()
  end
  if self.chatRoomRedDotTypeDic[group] then
    return self.chatRoomRedDotTypeDic[group]
  else
    local template = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(group)
    if template and template.dots_type and template.dots_type <= UnreadNotificationType.NoNotification then
      return template.dots_type
    end
  end
  return UnreadNotificationType.ShowUnreadCount
end

function ChatRoomManager:SaveRoomGroupRedDotTypeDic(chatRoomRedDotTypeDic)
  CommonUtil.PlayerPrefsSetTable("CHAT_ROOM_REDDOT_TYPE_DIC", chatRoomRedDotTypeDic)
  self.chatRoomRedDotTypeDic = chatRoomRedDotTypeDic
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_REDDONT_UPDATE)
end

function ChatRoomManager:SetEasterEggRoomId(eggUuid)
  if eggUuid == nil then
    self.easterEggRoomId = ""
  else
    self.easterEggRoomId = ChatGroupType.GROUP_EASTER_EGG_ROOM .. "-" .. eggUuid
  end
  return self.easterEggRoomId
end

function ChatRoomManager:GetEasterEggRoomId()
  return self.easterEggRoomId
end

function ChatRoomManager:GetEasterEggRoom()
  if self.easterEggRoomId == nil then
    Logger.LogError("\232\142\183\229\143\150\229\189\169\232\155\139\230\136\191\233\151\180\230\149\176\230\141\174\230\151\182\239\188\140easterEggRoomId \228\184\186\231\169\186\239\188\129")
    return
  end
  return self:GetRoomData(self.easterEggRoomId)
end

function ChatRoomManager:IsCurJumpRoom(roomId)
  local jumpMsgRoom = self:GetJumpMsgRoom()
  if jumpMsgRoom and jumpMsgRoom.roomId == roomId then
    return true
  end
end

function ChatRoomManager:GetRoomMsg(roomId, requestType, startSeqId, count)
  local roomData = self:GetEffectiveRoomData(roomId)
  if not roomData then
    return
  end
  count = count or ChatHistoryFetchSize
  if requestType == RequestType.LoadRecentMessages and not startSeqId then
    local msgs = roomData:GetUnblockedChatDatas()
    startSeqId = msgs[1] and msgs[1].seqId or nil
  end
  if startSeqId then
    local msgList, anchorSeqId = roomData:GetMsgsBySeqId(startSeqId, count, requestType)
    if msgList then
      return msgList, anchorSeqId
    end
  end
  return nil
end

function ChatRoomManager:GetRoomMsgByServer(roomId, requestType, startSeqId, count)
  local roomData = self:GetEffectiveRoomData(roomId)
  if not roomData then
    return
  end
  count = count or ChatHistoryFetchSize
  startSeqId = startSeqId or roomData:GetCurLsatSeqId()
  if not startSeqId and #roomData.msgs > 0 then
    startSeqId = roomData.msgs[#roomData.msgs].seqId
  end
  local msgList, anchorSeqId = self:GetRoomMsg(roomId, requestType, startSeqId, count)
  if (not msgList or count > #msgList) and roomData:CanFetchMore(requestType) then
    local isGetServer = self:HandleMsgNotFound(roomData, roomId, startSeqId, requestType, true)
    if not isGetServer or requestType == RequestType.JumpTo then
      return msgList, anchorSeqId
    end
  else
    return msgList, anchorSeqId
  end
  return nil
end

function ChatRoomManager:GetEffectiveRoomData(roomId)
  local roomData = self:GetRoomData(roomId)
  if not roomData then
    return nil
  end
  local jumpMsgRoom = self:GetJumpMsgRoom()
  if jumpMsgRoom and jumpMsgRoom.roomId ~= roomId then
    self:ClearJumpMsgRoom()
  end
  if self:IsShowingJumpMsg() then
    return jumpMsgRoom or roomData
  end
  return roomData
end

function ChatRoomManager:HandleMsgNotFound(roomData, roomId, startSeqId, requestType)
  if not roomData then
    return false
  end
  local getServerSeqId
  if self:IsShowingJumpMsg() or requestType == RequestType.JumpTo then
    if not roomData:CanFetchMore(requestType) then
      return false
    end
    if requestType == RequestType.PullPrev then
      getServerSeqId = self:JumpMsgPullPrevious(startSeqId)
    elseif requestType == RequestType.PullLast or requestType == RequestType.JumpTo then
      getServerSeqId = self:JumpMsgPullLast(roomId, startSeqId)
    end
    return getServerSeqId
  end
  if requestType == RequestType.InitFetch then
    local lastMsg = roomData.msgs[#roomData.msgs]
    if lastMsg then
      startSeqId = lastMsg.seqId
    end
  end
  if (requestType == RequestType.PullPrev or requestType == RequestType.InitFetch) and roomData:CanFetchMore(RequestType.PullPrev) then
    self:UpdateSortState(roomId, RequestType.PullPrev, startSeqId)
    getServerSeqId = startSeqId
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_COMMAND, roomId)
    return getServerSeqId
  end
  return false
end

function ChatRoomManager:InitJumpRoomMessage(handle)
  local jumpMsgRoom = self:GetJumpMsgRoom()
  if jumpMsgRoom == nil then
    return
  end
  if handle.result and not table.IsNullOrEmpty(handle.result.msg) then
    local msg = handle.result.msg
    local room = self:GetRoomData(jumpMsgRoom.roomId)
    if room then
      jumpMsgRoom.fristSeqId = room.firstSeqId
      jumpMsgRoom.lastSeqId = room.lastSeqId
    end
    self:onParseServerChatDataByRoom(jumpMsgRoom, msg)
    local userMgr = ChatManager2:GetInstance().User
    userMgr:__processAllUserInfos()
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_HISTORYMSG_UPDATA, {
      roomId = jumpMsgRoom.roomId,
      requestType = RequestType.JumpTo,
      seqId = handle.result.seqId
    })
  end
end

function ChatRoomManager:UpdateJumpRoomMessage(handle)
  local jumpMsgRoom = self:GetJumpMsgRoom()
  if jumpMsgRoom == nil then
    return
  end
  if handle.result then
    local getType = handle.result.sort == 0 and RequestType.PullPrev or RequestType.PullLast
    local roomId = handle.result.roomId
    local requestType = RequestType.JumpTo
    local firstSeqId, lastSeqId
    if not table.IsNullOrEmpty(handle.result.msg) then
      local msg = handle.result.msg
      if 0 < jumpMsgRoom:getToTalNum() then
        firstSeqId = jumpMsgRoom:getFirstSeqId()
        lastSeqId = jumpMsgRoom:GetLastMsgSeqId()
      end
      self:onParseServerChatDataByRoom(jumpMsgRoom, msg)
      local room = self:GetJumpMsgRoom()
      if not room then
        local stateInfo = {
          roomId = jumpMsgRoom.roomId,
          state = getType,
          isOn = false
        }
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_FETCH_HISTORY_STATE_UPDATA, stateInfo)
      end
      local userMgr = ChatManager2:GetInstance().User
      userMgr:__processAllUserInfos()
      local newFirstSeqId = jumpMsgRoom:getFirstSeqId()
      local newLastSeqId = jumpMsgRoom:GetLastMsgSeqId()
      if firstSeqId and firstSeqId ~= newFirstSeqId then
        requestType = RequestType.PullPrev
      elseif lastSeqId and lastSeqId ~= newLastSeqId then
        requestType = RequestType.PullLast
      end
    end
    jumpMsgRoom:SetChatHistoryEnd(getType, handle.result.msgEnd)
    self:OnServerPassRoom(roomId, getType)
  end
end

function ChatRoomManager:GotoJumpMessage(roomId, seqId)
  local room = self:GetEffectiveRoomData(roomId)
  local index = ChatInterface.GetUtil().BinarySearchBySeqId(room.msgs, seqId)
  if index then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_HISTORYMSG_UPDATA, {
      roomId = roomId,
      requestType = RequestType.JumpTo,
      seqId = seqId
    })
  else
    self:ClearJumpMsgRoom()
    self:JumpMsgPullLast(roomId, seqId)
  end
end

function ChatRoomManager:UpdateSortState(roomId, state, seqId)
  if not roomId or not state then
    return
  end
  local room = self:GetEffectiveRoomData(roomId)
  if room then
    room:SetHistoryState(state, seqId)
  end
end

function ChatRoomManager:RemoveRoomHistoryState(roomId, state)
  if not roomId or not state then
    return
  end
  local room = self:GetEffectiveRoomData(roomId)
  if room then
    room:RemoveHistoryState(state)
  end
end

function ChatRoomManager:OnPassDay()
  local rooms = self:GetRoomDatas()
  for _, v in pairs(rooms) do
    v:OnPassDay()
  end
end

function ChatRoomManager:isInMembers(room, members)
  if not room then
    return false
  end
  if room.group ~= ChatGroupType.GROUP_CUSTOM and room.group ~= ChatGroupType.GROUP_CUSTOM_GROUP then
    return true
  end
  if not members then
    return false
  end
  for _, memberId in pairs(members) do
    if memberId == LuaEntry.Player.uid then
      return true
    end
  end
  return false
end

function ChatRoomManager:UpDateRoomInfo(infoList)
  if not infoList or #infoList == 0 then
    return
  end
  self.roomInfoDic = self.roomInfoDic or {}
  for i = 1, #infoList do
    local info = infoList[i]
    if not info or not info.roomId then
      Logger.LogWarning("Invalid room info at index " .. i)
    elseif not info.name then
      info.isDissolve = true
      self.roomInfoDic[info.roomId] = info
      EventManager:GetInstance():Broadcast(EventId.CHAT_ROOMINFO_UPDATA, info)
    else
      local room = ChatInterface.getRoomData(info.roomId)
      local passRoom = true
      local members = {}
      if info.members and info.members ~= "" then
        local ok, result = pcall(rapidjson.decode, info.members)
        if ok and type(result) == "table" then
          members = result
          passRoom = self:isInMembers(room, members)
        else
          Logger.LogWarning("Failed to decode members for roomId: " .. tostring(info.roomId))
        end
      end
      if room then
        if passRoom and room.onParseServerData then
          room:onParseServerData(info)
        elseif not room:IsKickedRoom() then
          self:RemoveRoomData(room.roomId)
          EventManager:GetInstance():Broadcast(EventId.CHAT_REFRESH_CHANNEL)
        end
      end
      info.members = members
      self.roomInfoDic[info.roomId] = info
      EventManager:GetInstance():Broadcast(EventId.CHAT_ROOMINFO_UPDATA, info)
    end
  end
end

function ChatRoomManager:GetRoomInfo(roomId, group)
  if not roomId then
    return
  end
  local room = self:GetRoomData(roomId)
  local roomInfo = self.roomInfoDic[roomId]
  if not room and roomInfo and not roomInfo.isDissolve then
    return self.roomInfoDic[roomId]
  end
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatCustomRoomInfo, {roomId}, group)
end

function ChatRoomManager:GetNewRoomInfo(roomIdList, group)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatCustomRoomInfo, roomIdList, group)
end

function ChatRoomManager:GetCacheRoomId(roomId)
  for i = 1, #self.roomLastDatas do
    if self.roomLastDatas[i] == roomId then
      return true
    end
  end
end

function ChatRoomManager:GetRoomLast(roomId)
  if self:GetCacheRoomId(roomId) then
    return
  end
  local room = self:GetRoomData(roomId)
  if not room or table.count(room.msgs) >= msgCount then
    return
  end
  if not self.delayRoomLastAction then
    self.delayRoomLastAction = TimerManager:GetInstance():DelayInvoke(function()
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.Roomlast, self.roomLastDatas)
      self.roomLastDatas = {}
      self.delayRoomLastAction:Stop()
      self.delayRoomLastAction = nil
    end, 1)
  end
  table.insert(self.roomLastDatas, roomId)
end

function ChatRoomManager:_CreateTempTopRoom(roomInfo)
  local room = self:GetRoomData(roomInfo.roomId)
  if not room then
    room = self:CreateChatRoom(roomInfo.roomId, roomInfo.group)
    room:onParseServerData(roomInfo, true)
  end
  return room
end

function ChatRoomManager:InitRoomTop()
  local uid = LuaEntry.Player.uid
  local stickyPrivateList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_STICKY_LIST", {})
  local stickyGroupList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_GROUPCHAT_STICKY_LIST", {})
  local groupChatRoomIdList = {}
  local room
  for targetUid, _ in pairs(stickyPrivateList) do
    local roomInfo = {
      name = string.format("PRIVATE_%s_STICKY_%s", uid, targetUid),
      members = string.format("%s|%s", uid, targetUid),
      roomId = ChatInterface.GetUtil().GeneratePrivateRoomId(targetUid)
    }
    room = self:_CreateTempTopRoom(roomInfo)
    self:AddClassifyRoomDic(room, true)
  end
  for roomId, _ in pairs(stickyGroupList) do
    local roomInfo = {
      name = roomId,
      members = uid,
      roomId = roomId,
      group = ChatGroupType.GROUP_CUSTOM_GROUP
    }
    room = self:_CreateTempTopRoom(roomInfo)
    self:AddClassifyRoomDic(room, true)
    table.insert(groupChatRoomIdList, roomId)
  end
  if 0 < #groupChatRoomIdList then
    ChatInterface.getRoomMgr():GetNewRoomInfo(groupChatRoomIdList, ChatGroupType.GROUP_CUSTOM_GROUP)
  end
end

function ChatRoomManager:GetAllRoomTop()
  local stickyRoomList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_STICKY_LIST", {})
  local stickyGroupRoomList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_GROUPCHAT_STICKY_LIST", {})
  local roomDic = {}
  for uid, v in pairs(stickyRoomList) do
    roomDic[uid] = v
  end
  for roomId, v in pairs(stickyGroupRoomList) do
    roomDic[roomId] = v
  end
  return roomDic
end

function ChatRoomManager:ClearRoomFetchLimitForPlayer(playerUid)
  for i, roomData in pairs(self.roomDatas) do
    if self:HasPlayerSpokenInRoom(roomData.roomId, playerUid) then
      roomData:ResetRoomAllFetchTypeLimits()
    end
  end
end

function ChatRoomManager:HasPlayerSpokenInRoom(roomId, uid)
  local room = self:GetRoomData(roomId)
  if room then
    return room:HasPlayerSpokenInRoom(uid)
  end
  return false
end

function ChatRoomManager:GetNewPrivateList(itemCount)
  local rooms
  if ChatInterface.GetGroupChatIsOpen() then
    rooms = self:GetAllPrivateAndGroupRoomList()
  else
    rooms = self:GetAllPrivateRoomList()
  end
  local count = 0
  if rooms then
    count = #rooms < privateStartMaxCount and privateStartMaxCount or #rooms
  else
    count = itemCount
  end
  local page = math.floor(count / PrivateListPage)
  if ChatInterface.GetGroupChatIsOpen() then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.GetCustomP2PRoomListV2)
  else
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.GetCustomP2PRoomList, page + 1, PrivateListPage)
  end
end

function ChatRoomManager:UpdateAtAllCount(data)
  if not data.roomId then
    return
  end
  local room = self:GetRoomData(data.roomId)
  if room then
    room:UpdateAtAllCount(data)
  end
end

function ChatRoomManager:CreateTempPrivateRooom(userId)
  local selfUid = LuaEntry.Player.uid
  if not userId or selfUid == userId then
    return
  end
  local roomId = ChatInterface.GetUtil().GeneratePrivateRoomId(userId)
  if roomId then
    local room = ChatManager2:GetInstance().Room:CreateChatRoom(roomId, ChatGroupType.GROUP_CUSTOM)
    room.name = "PRIVATE_" .. userId .. "_to_" .. selfUid
    room:addMembers({userId, selfUid})
    return room
  end
end

function ChatRoomManager:TryReqChatSpeakUid(roomId)
  if self.chatSpeakUidReqState[roomId] == ChatMsgReqState.HaveData then
    return
  end
  self.chatSpeakUidReqState[roomId] = ChatMsgReqState.Request
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistortP2PSpeak, roomId)
end

function ChatRoomManager:UpdateChatSpeakUidByMsg(msg)
  local roomId = msg.result.roomId
  local speakInfo = msg.result.speakInfo
  if string.IsNullOrEmpty(roomId) then
    return
  end
  self.chatSpeakUidReqState[roomId] = ChatMsgReqState.HaveData
  self.chatSpeakUidDict[roomId] = {}
  if string.IsNullOrEmpty(speakInfo) then
    return
  end
  local speakInfoData = rapidjson.decode(speakInfo)
  for i = 1, #speakInfoData do
    local uuid = speakInfoData[i]
    self.chatSpeakUidDict[roomId][uuid] = true
  end
end

function ChatRoomManager:ClearAllChatSpeakUidRequestState()
  for k, v in pairs(self.chatSpeakUidReqState) do
    if v == ChatMsgReqState.Request then
      self.chatSpeakUidReqState[k] = nil
    end
  end
end

function ChatRoomManager:UpdateChatSpeakUidByChatData(chatData)
  if self:CheckNeedUpdateChatSpeakUid(chatData.group) then
    local roomId = chatData.roomId
    if self.chatSpeakUidReqState[roomId] == ChatMsgReqState.HaveData then
      local senderUid = chatData.senderUid
      self.chatSpeakUidDict[roomId][senderUid] = true
    end
  end
end

function ChatRoomManager:TryGetChatSpeakUid(roomId)
  local state = ChatMsgReqState.None
  local data
  if self.chatSpeakUidReqState[roomId] then
    state = self.chatSpeakUidReqState[roomId]
    if state == ChatMsgReqState.HaveData then
      data = self.chatSpeakUidDict[roomId]
    end
  end
  return state, data
end

function ChatRoomManager:CheckNeedUpdateChatSpeakUid(roomGroup)
  local isNeed = false
  if roomGroup == ChatGroupType.GROUP_CUSTOM then
    isNeed = true
  end
  return isNeed
end

return ChatRoomManager
