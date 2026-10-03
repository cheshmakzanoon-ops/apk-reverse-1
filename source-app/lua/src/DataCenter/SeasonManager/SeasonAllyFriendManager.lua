local SeasonAllyFriendManager = BaseClass("SeasonAllyFriendManager")

function SeasonAllyFriendManager:__init()
  self.allyLogPermission = {}
  self.friendMarkDirty = false
  self.logDict = {}
  self.isAllied = false
  self.allyAllianceId = nil
  self.isFunOpen = SeasonUtil.CanAllianceMakeFriends(LuaEntry.Player:GetSourceServerId())
  if self.isFunOpen then
    EventManager:GetInstance():AddListener(EventId.AllianceBaseDataUpdated, SeasonAllyFriendManager.TryRefreshChatRoom)
    EventManager:GetInstance():AddListener(EventId.PushAllianceFriendsLeaveUpdate, SeasonAllyFriendManager.TryRefreshChatRoom)
    EventManager:GetInstance():AddListener(EventId.PushAllianceHaveFriendsUpdate, SeasonAllyFriendManager.TryRefreshChatRoom)
  end
end

function SeasonAllyFriendManager:__delete()
  if self.isFunOpen then
    EventManager:GetInstance():RemoveListener(EventId.AllianceBaseDataUpdated, SeasonAllyFriendManager.TryRefreshChatRoom)
    EventManager:GetInstance():RemoveListener(EventId.PushAllianceFriendsLeaveUpdate, SeasonAllyFriendManager.TryRefreshChatRoom)
    EventManager:GetInstance():RemoveListener(EventId.PushAllianceHaveFriendsUpdate, SeasonAllyFriendManager.TryRefreshChatRoom)
  end
end

function SeasonAllyFriendManager:TryGetChatRoomId()
  local Player = LuaEntry.Player
  if self:HasFriend() and Player:IsInAlliance() then
    local roomIdPrefix = ChatInterface.GetRoomIdPrefix()
    local tmp = {
      self.allyAllianceId,
      Player.allianceId
    }
    table.sort(tmp)
    return string.format("%s%s_%s_%s", roomIdPrefix, ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM, tmp[1], tmp[2])
  end
  return nil
end

function SeasonAllyFriendManager:TryRefreshChatRoom()
  local chatInst = ChatManager2:GetInstance()
  if chatInst == nil or chatInst:IsInitOK() == false then
    return
  end
  local allyFriendManager = DataCenter.SeasonAllyFriendManager
  local roomMgr = chatInst.Room
  local Net = chatInst.Net
  local Ctrl = chatInst.Ctrl
  if roomMgr == nil or Net == nil or Ctrl == nil or allyFriendManager == nil then
    return
  end
  local Player = LuaEntry.Player
  local isNeedJoinRoom = allyFriendManager:HasFriend() and Player:IsInAlliance() and SeasonUtil.IsInSeason()
  local roomData = roomMgr:GetRoomDataByGroup(ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM)
  if isNeedJoinRoom then
    if roomData == nil then
      roomMgr.allianceFriendRoomId = allyFriendManager:TryGetChatRoomId()
      if roomMgr.allianceFriendRoomId == nil or roomMgr.allianceFriendRoomId == "" then
        return
      end
      roomData = roomMgr:CreateChatRoom(roomMgr.allianceFriendRoomId, ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM)
      if roomData then
        Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM, roomMgr.allianceFriendRoomId)
        Net:SendMessage(ChatMsgDefines.HistoryRoomV2, roomMgr.allianceFriendRoomId)
      end
    end
  else
    local roomId = roomMgr.allianceFriendRoomId
    if roomId ~= nil and roomId ~= "" then
      roomMgr:RemoveRoomData(roomId)
      roomMgr.allianceFriendRoomId = ""
      if roomData then
        Net:SendMessage(ChatMsgDefines.RoomLeave, roomId)
      end
    end
  end
end

function SeasonAllyFriendManager:IsMyAllianceFriend(allianceId)
  return self.isAllied and allianceId == self.allyAllianceId
end

function SeasonAllyFriendManager:CanMakeFriends()
  return self.isFunOpen
end

function SeasonAllyFriendManager:CleanData()
  self.isAllied = false
  self.allyAllianceId = nil
  self.logDict = nil
  self.theRequestDetailDict = nil
  self.allyHandshakeInfo = nil
  self.allyCooldownEndTime = 0
  self.allyCombinedList = nil
  self.allyLogPermission = {}
  self.friendMarkDirty = false
  EventManager:GetInstance():Broadcast(EventId.MFAllyFriendAllianceUpdate)
  if SceneUtils.GetIsInWorld() then
    CS.SceneManager.World:CleanAllianceCacheData()
  end
  self:TryRefreshChatRoom()
end

function SeasonAllyFriendManager:GetFriendAllyMarkInfo()
  if self.isAllied then
    return DataCenter.WorldFavoDataManager:GetFriendBookMarkList()
  end
  return nil
end

function SeasonAllyFriendManager:IsMyFriendAlly(allianceId)
  return self.isAllied and allianceId == self.allyAllianceId
end

function SeasonAllyFriendManager:GetFriendAllyId()
  return self.allyAllianceId
end

function SeasonAllyFriendManager:HasFriend()
  return self.isAllied
end

function SeasonAllyFriendManager:SetHandshakeUnique(isUnique)
  self.isHandshakeUnique = isUnique
end

function SeasonAllyFriendManager:IsHandshakeUnique()
  return self.isHandshakeUnique == true
end

function SeasonAllyFriendManager:SetHandshakeInfo(data)
  self.allyHandshakeInfo = data
end

function SeasonAllyFriendManager:GetHandshakeInfo(fetchNew)
  if fetchNew then
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyHandshakeInfo)
  end
  return self.allyHandshakeInfo
end

function SeasonAllyFriendManager:SetFriendAllianceId(allyAllianceId, allyTime)
  self.isAllied = allyAllianceId ~= nil and allyAllianceId ~= ""
  if self.isAllied then
    local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(allyAllianceId)
    if data == nil then
      SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, allyAllianceId)
      SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceMark)
    end
    if allyTime then
      self.allyStartTime = allyTime
    end
    self.allyAllianceId = allyAllianceId
    EventManager:GetInstance():Broadcast(EventId.MFAllyFriendAllianceUpdate)
    EventManager:GetInstance():Broadcast(EventId.MakeWorldColorDirty, self.allyAllianceId)
  else
    self.allyAllianceId = nil
  end
  self:TryRefreshChatRoom()
end

function SeasonAllyFriendManager:GetRequestData(allianceId)
  local allyCombinedList = self.allyCombinedList
  if allyCombinedList ~= nil and allyCombinedList.sendList ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    for _, v in ipairs(allyCombinedList.sendList) do
      if v.applyBaseInfo ~= nil and v.allianceUid == allianceId and now < v.applyBaseInfo.expireTime then
        return v
      end
    end
  end
  return nil
end

function SeasonAllyFriendManager:UpdateRequestDetail(data)
  if self.theRequestDetailDict == nil then
    self.theRequestDetailDict = {}
  end
  self.theRequestDetailDict[data.applyId] = data
end

function SeasonAllyFriendManager:GetRequestDetail(applyId, requestWhenNotExist, forceFetchNew)
  local data
  if self.theRequestDetailDict ~= nil then
    data = self.theRequestDetailDict[applyId]
  end
  if forceFetchNew or data == nil and requestWhenNotExist then
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyApplyDetail, applyId)
  end
  return data
end

function SeasonAllyFriendManager:SetAllyCombinedList(data)
  self.allyCooldownEndTime = 0
  if data.allyInfo ~= nil then
    if data.allyInfo.allyAllianceId ~= nil and data.allyInfo.allyAllianceId ~= "" then
      self:SetFriendAllianceId(data.allyInfo.allyAllianceId)
    end
    self.allyCooldownEndTime = data.allyInfo.allyCooldownEndTime
  end
  self.allyCombinedList = data
  EventManager:GetInstance():Broadcast(EventId.MFAllyCombinedListUpdate)
  EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
end

function SeasonAllyFriendManager:GetAllyCombinedList(requestWhenNoData, forceRequest, delay)
  if (forceRequest or requestWhenNoData and self.allyCombinedList == nil) and self:CanMakeFriends() then
    local now = UITimeManager:GetInstance():GetServerTime()
    if delay == nil or self.requestCombinedListTime == nil or now >= self.requestCombinedListTime + toInt(delay) then
      SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyCombinedList)
      self.requestCombinedListTime = now
    end
  end
  return self.allyCombinedList
end

function SeasonAllyFriendManager:GetAllyDataByApplyUuid(applyUuid)
  if self.allyCombinedList == nil or self.allyCombinedList.recList == nil then
    return nil
  end
  for k, v in ipairs(self.allyCombinedList.recList) do
    if v and v.applyBaseInfo and v.applyBaseInfo.applyUuid == applyUuid then
      return v
    end
  end
  return nil
end

function SeasonAllyFriendManager:GetAllyCooldownEndTime()
  return toInt(self.allyCooldownEndTime)
end

function SeasonAllyFriendManager:SetAllyLogPermission(eventType, data)
  local lastData = self.allyLogPermission[eventType]
  self.allyLogPermission[eventType] = data
  if lastData == nil or lastData.lastLogOpTime ~= data.lastLogOpTime or lastData.logPublic ~= data.logPublic then
    EventManager:GetInstance():Broadcast(EventId.MFAllyLogPermissionUpdate)
  end
end

function SeasonAllyFriendManager:GetAllyLogPermission(eventType)
  if self.allyLogPermission == nil then
    return nil
  end
  return self.allyLogPermission[eventType]
end

function SeasonAllyFriendManager:IsLogPublic(eventType, fetchWhenNotExist)
  local data = self.allyLogPermission[eventType]
  if data == nil then
    if eventType == 1 then
      return false
    end
    if fetchWhenNotExist then
      SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyLogList, 1, eventType, 1, 3)
    end
  end
  return data ~= nil and data.logPublic == 1
end

function SeasonAllyFriendManager:UpdateOpLog(eventType, pageNum, pageSize, t)
  if self.logDict == nil then
    self.logDict = {}
  end
  if t.list and #t.list > 0 then
    local data = self.logDict[eventType]
    if data == nil then
      data = {
        keyList = {},
        dataList = {}
      }
      self.logDict[eventType] = data
    end
    local hasNew = false
    local hasOld = false
    local dataCount = #t.list
    for k, v in ipairs(t.list) do
      if v.uuid and data.keyList[v.uuid] == nil then
        hasNew = true
        data.keyList[v.uuid] = v
        if v.uuid and v.eventTime then
          table.insert(data.dataList, v)
        end
      elseif v.uuid and data.keyList[v.uuid] ~= nil then
        hasOld = true
      end
    end
    if hasNew and not hasOld and dataCount == t.pageSize then
      table.sort(data.dataList, function(a, b)
        return a.eventTime > b.eventTime
      end)
      if t.pageSize < 10 then
        SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyLogList, t.playType, t.eventType, 1, 36)
      else
        SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyLogList, t.playType, t.eventType, t.page + 1, 36)
      end
    end
  end
  if t.lastLogOpUser then
    self:SetAllyLogPermission(eventType, t)
  end
  EventManager:GetInstance():Broadcast(EventId.MFAllyLogUpdate)
end

function SeasonAllyFriendManager:GetOpLog(eventType)
  return self.logDict and self.logDict[eventType] or nil
end

function SeasonAllyFriendManager:UpdateOpLogDetail(uuid, data)
  if self.logDetail == nil then
    self.logDetail = {}
  end
  self.logDetail[uuid] = data
  EventManager:GetInstance():Broadcast(EventId.MFAllyLogDetailUpdate, uuid)
end

function SeasonAllyFriendManager:GetOpLogDetail(uuid)
  if self.logDetail then
    return self.logDetail[uuid]
  end
  return nil
end

function SeasonAllyFriendManager:GetNewLogCount(special_eventType)
  local newCount = 0
  if self.logDict ~= nil then
    if special_eventType ~= nil then
      local data = self.logDict[toInt(special_eventType)]
      if data ~= nil and data.dataList ~= nil then
        local theLastTime = toInt(Setting:GetPrivateString("AllyFriend_T" .. special_eventType))
        for _, log in ipairs(data.dataList) do
          if log ~= nil and log.eventTime ~= nil and theLastTime < log.eventTime then
            newCount = newCount + 1
          end
        end
      end
    elseif DataCenter.AllianceBaseDataManager:IsR4orR5() then
      for eventType = 1, 3 do
        local data = self.logDict[eventType]
        if data ~= nil and data.dataList ~= nil then
          local theLastTime = toInt(Setting:GetPrivateString("AllyFriend_T" .. eventType))
          for _, log in ipairs(data.dataList) do
            if log ~= nil and log.eventTime ~= nil and theLastTime < log.eventTime then
              newCount = newCount + 1
            end
          end
        end
      end
    else
      local data = self.logDict[1]
      if data ~= nil and data.dataList ~= nil then
        local theLastTime = toInt(Setting:GetPrivateString("AllyFriend_T1"))
        for _, log in ipairs(data.dataList) do
          if log ~= nil and log.eventTime ~= nil and theLastTime < log.eventTime then
            newCount = newCount + 1
          end
        end
      end
    end
  end
  return newCount
end

function SeasonAllyFriendManager:CheckCondition(allianceAllyInfo)
  local status1, status2, status3, status4
  local mgr = DataCenter.WorldAllianceCityDataManager
  local now = UITimeManager:GetInstance():GetServerTime()
  local allyInfo = allianceAllyInfo.allyInfo
  local allyCooldownEndTimeMine = DataCenter.SeasonAllyFriendManager:GetAllyCooldownEndTime()
  local allyCooldownEndTimeOther = 0
  local allianceIdOther = allianceAllyInfo.allianceUid or allianceAllyInfo.uid
  local allianceIdMine = LuaEntry.Player.allianceId
  if allyInfo then
    allyCooldownEndTimeOther = toInt(allyInfo.allyCooldownEndTime)
  end
  status1 = now > allyCooldownEndTimeMine and now > allyCooldownEndTimeOther
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local allianceCityList1, strongholdList1 = mgr:GetAllianceCityByAlId(allianceIdMine, mySourceServerId)
  local allianceCityList2, strongholdList2 = mgr:GetAllianceCityByAlId(allianceIdOther, mySourceServerId)
  local citiesCount1 = (allianceCityList1 ~= nil and #allianceCityList1 or 0) + (strongholdList1 ~= nil and #strongholdList1 or 0)
  local citiesCount2 = (allianceCityList2 ~= nil and #allianceCityList2 or 0) + (strongholdList2 ~= nil and #strongholdList2 or 0)
  local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
  local KingCityList, OutpostList
  if seasonType == SeasonMapType.NineNationRainforest then
    KingCityList = {
      321,
      332,
      343,
      1059,
      1103,
      1088,
      1823,
      1834,
      1845
    }
    OutpostList = {
      290,
      291,
      353,
      354,
      300,
      301,
      363,
      364,
      310,
      311,
      373,
      374,
      1038,
      1039,
      1117,
      1118,
      1048,
      1049,
      1127,
      1128,
      1792,
      1793,
      1855,
      1856,
      1802,
      1803,
      1865,
      1866,
      1812,
      1813,
      1875,
      1876
    }
  elseif seasonType == SeasonMapType.NineNation then
    KingCityList = {
      321,
      332,
      343,
      984,
      995,
      1006,
      1647,
      1658,
      1669
    }
    OutpostList = {
      707,
      711,
      716,
      1022,
      0,
      968,
      1274,
      1279,
      1283
    }
  end
  local allCityList = mgr:GetAllianceCityList(mySourceServerId) or {}
  local KingAndOutpost = table.mergeArray(KingCityList, OutpostList)
  if KingAndOutpost then
    for _, cityId in ipairs(KingAndOutpost) do
      local cityInfo = allCityList[cityId]
      if cityInfo ~= nil and cityInfo:IsNotRuins() then
        if cityInfo.allianceId == allianceIdMine then
          citiesCount1 = citiesCount1 + 1
        end
        if cityInfo.allianceId == allianceIdOther then
          citiesCount2 = citiesCount2 + 1
        end
      end
    end
  end
  status2 = 0 < citiesCount1 and 0 < citiesCount2
  if status2 then
    local cityData
    local cityMgr = DataCenter.AllianceCityTemplateManager
    local list = table.mergeArray(allianceCityList1, strongholdList1)
    if list then
      for _, cityId in pairs(list) do
        local cityInfo = allCityList[cityId]
        if cityInfo ~= nil and cityInfo:IsNotRuins() then
          local cityTemplate = cityMgr:GetTemplate(cityId, mySourceServerId)
          if cityTemplate and type(cityTemplate.nearBy) == "table" and table.isarray(cityTemplate.nearBy) then
            for k, neighbourCityId in ipairs(cityTemplate.nearBy) do
              local theCityId = toInt(neighbourCityId)
              cityData = allCityList[theCityId]
              if 0 < theCityId and cityData ~= nil and cityData:IsNotRuins() and cityData.allianceId == allianceIdOther then
                status3 = true
                break
              end
            end
            if status3 then
              break
            end
          end
        end
      end
    end
    if not status3 and KingAndOutpost then
      for _, cityId in ipairs(KingAndOutpost) do
        local cityInfo = allCityList[cityId]
        if cityInfo ~= nil and cityInfo:IsNotRuins() and cityInfo.allianceId == allianceIdMine then
          local cityTemplate = cityMgr:GetTemplate(cityId, mySourceServerId)
          if cityTemplate and type(cityTemplate.nearBy) == "table" and table.isarray(cityTemplate.nearBy) then
            for k, neighbourCityId in ipairs(cityTemplate.nearBy) do
              local theCityId = toInt(neighbourCityId)
              cityData = allCityList[theCityId]
              if 0 < theCityId and cityData ~= nil and cityData:IsNotRuins() and cityData.allianceId == allianceIdOther then
                status3 = true
                break
              end
            end
            if status3 then
              break
            end
          end
        end
      end
    end
  else
    status3 = false
  end
  status4 = not self:HasFriend() and (allyInfo == nil or allyInfo.allyAllianceId == nil or allyInfo.allyAllianceId == "")
  return status1, status2, status3, status4
end

function SeasonAllyFriendManager:GetLinkCityList()
  if not self:HasFriend() then
    return nil
  end
  local myAlId = LuaEntry.Player.allianceId
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local cityMgr = DataCenter.WorldAllianceCityDataManager
  local allyAllianceId = DataCenter.SeasonAllyFriendManager:GetFriendAllyId()
  local allianceCityList1, strongholdList1 = cityMgr:GetAllianceCityByAlId(myAlId, mySourceServerId)
  local allianceCityList2, strongholdList2 = cityMgr:GetAllianceCityByAlId(allyAllianceId, mySourceServerId)
  if (allianceCityList1 ~= nil or strongholdList1 ~= nil) and (allianceCityList2 ~= nil or strongholdList2 ~= nil) then
    local linkList = {}
    local mgr = DataCenter.AllianceCityTemplateManager
    local allyCityDict = {}
    if allianceCityList2 then
      for _, cityId in ipairs(allianceCityList2) do
        allyCityDict[cityId] = true
      end
    end
    if strongholdList2 then
      for _, cityId in ipairs(strongholdList2) do
        allyCityDict[cityId] = true
      end
    end
    if allianceCityList1 then
      for _, myCityId in ipairs(allianceCityList1) do
        local cityTemplate = mgr:GetTemplate(myCityId, mySourceServerId)
        if cityTemplate and type(cityTemplate.nearBy) == "table" and table.isarray(cityTemplate.nearBy) then
          for k, neighbourCityId in ipairs(cityTemplate.nearBy) do
            local cityId = toInt(neighbourCityId)
            if allyCityDict[cityId] then
              linkList[myCityId] = true
              break
            end
          end
        end
      end
    end
    if strongholdList1 then
      for _, myCityId in ipairs(strongholdList1) do
        local cityTemplate = mgr:GetTemplate(myCityId, mySourceServerId)
        if cityTemplate and type(cityTemplate.nearBy) == "table" and table.isarray(cityTemplate.nearBy) then
          for k, neighbourCityId in ipairs(cityTemplate.nearBy) do
            local cityId = toInt(neighbourCityId)
            if allyCityDict[cityId] then
              linkList[myCityId] = true
              break
            end
          end
        end
      end
    end
    return linkList
  end
  return nil
end

function SeasonAllyFriendManager:CheckLink(cityId)
  if not self:HasFriend() then
    return false
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, mySourceServerId)
  if cityTemplate and type(cityTemplate.nearBy) == "table" and table.isarray(cityTemplate.nearBy) then
    local mgr = DataCenter.WorldAllianceCityDataManager
    local myAllianceId = LuaEntry.Player.allianceId
    local cityData = mgr:GetAllianceCityDataByCityId(cityId, mySourceServerId)
    if cityData == nil or cityData.allianceId ~= myAllianceId then
      return false
    end
    for k, neighbourCityId in ipairs(cityTemplate.nearBy) do
      local theCityId = toInt(neighbourCityId)
      cityData = mgr:GetAllianceCityDataByCityId(theCityId, mySourceServerId)
      if 0 < theCityId and cityData ~= nil and cityData.allianceId == self.allyAllianceId then
        return true
      end
    end
  end
  return false
end

return SeasonAllyFriendManager
