local ChatRoomData = BaseClass("ChatRoomData")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local estimateTableSize = require("Common.Debug.EstimateTableSize")
local MAX_AT_SEQ_ID_NUM = 10

function ChatRoomData:__init(roomId, group)
  self.roomId = roomId or ""
  self.group = group or ""
  self.category = ""
  self.owner = ""
  self.firstSeqId = 0
  self.lastSeqId = 0
  self.readSeqId = CS.GameEntry.Setting:GetInt(self.roomId .. "_readSeqId_" .. LuaEntry.Player.uid, 0)
  self.delSeqIds = nil
  self.firstMsgTime = 0
  self.lastMsgTime = 0
  self.appId = ""
  self.name = ""
  self.msgs = {}
  self.memberList = {}
  self.memberDic = {}
  self.seqIds = {}
  self.seqIdSet = {}
  self.lastNotMsgUpdateTime = 0
  self.filterLastTime = 0
  self.historyState = {}
  self.historyCount = {}
  self.isPin = 0
  self.info_ok = false
  self.getLastMsg = false
  self.commentNum = 0
  self.voiceRoomSwitch = false
  self.speakingPlayersMap = {}
  self.readMessagePlayerSpeakCount = {}
  self.friendsCircleLikeUids = {}
  self.atAllCount = nil
  self.temp = {
    text = "",
    replyMsg = nil,
    imagePath = ""
  }
  self.isReachFirstMessage = false
  self.redDotType = 0
  self.atSeqIds = {}
  self.atSeqIdMap = {}
  self.atInitRead = false
  self.inputAtPlayers = {}
  self.atUsedTimes = 0
  self:Setcategory()
  self.__estimateSize = 0
  self.__estimateSize = estimateTableSize(self)
  self.__todo__inited = false
end

function ChatRoomData:__ClearMsgs()
  self.firstSeqId = 0
  self.lastSeqId = 0
  self.readSeqId = CS.GameEntry.Setting:GetInt(self.roomId .. "_readSeqId_" .. LuaEntry.Player.uid, 0)
  self.delSeqIds = nil
  self.firstMsgTime = 0
  self.lastMsgTime = 0
  self.appId = ""
  self.name = ""
  self.msgs = {}
  self.memberList = {}
  self.memberDic = {}
  self.seqIds = {}
  self.lastNotMsgUpdateTime = 0
  self.atAllCount = nil
  self.voiceRoomSwitch = false
  self.__todo__inited = false
end

function ChatRoomData:Setcategory()
  if ChatInterface.GetMomentIsOpen() then
    self.template = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(self.group)
    if self.template and self.template.group then
      self.category = self.template.group
      return
    elseif self.group == ChatGroupType.GROUP_CUSTOM_GROUP then
      self.category = ChatRoomCategory.PRIVATE
    elseif self.group == ChatGroupType.GROUP_ALLIANCE or self.group == ChatGroupType.GROUP_ALLIANCE_NOTICE or self.group == ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM or self.group == ChatGroupType.GROUP_ALLIANCE_MANAGER then
      self.category = ChatRoomCategory.ALLIANCE
    elseif self.group == ChatGroupType.GROUP_COUNTRY or self.group == ChatGroupType.GROUP_LANGUAGE then
      self.category = ChatRoomCategory.WORLD
    elseif self.group == ChatGroupType.GROUP_CROSS_SERVER or self.group == ChatGroupType.GROUP_DRAGON_ALL_SERVER or self.group == ChatGroupType.GROUP_DRAGON_SELF_SERVER or self.group == ChatGroupType.GROUP_SEASON_ROOM or self.group == ChatGroupType.GROUP_SEASON_FACTION_WAR_ROOM or self.group == ChatGroupType.GROUP_EPIDEMIC_FARMER or self.group == ChatGroupType.GROUP_LANDLORD_FARMER or self.group == ChatGroupType.GROUP_LANDLORD_LORD then
      self.category = ChatRoomCategory.ACTIVITY
    elseif self.group == ChatGroupType.GROUP_TMPRoom then
      self.category = ChatRoomCategory.PRIVATE
    elseif self.group == ChatGroupType.GROUP_CUSTOM_GROUP then
      self.category = ChatRoomCategory.PRIVATE
    end
  end
  if self.group == ChatGroupType.GROUP_TMPRoom then
    self.category = ChatRoomCategory.PRIVATE
  end
end

function ChatRoomData:setGroup(group)
  self.group = group
  self:Setcategory()
end

function ChatRoomData:isCustomRoom()
  return self.group == ChatGroupType.GROUP_CUSTOM
end

function ChatRoomData:setAppId(appId)
  self.appId = appId
end

function ChatRoomData:isMyCreateRoom()
  return self.owner == ChatInterface.getPlayerUid()
end

function ChatRoomData:setName(name)
  self.name = name
end

function ChatRoomData:GetCategory()
  return self.category
end

function ChatRoomData:onParseServerData(roomData, ignoreUnread)
  if type(roomData) ~= "table" then
    return
  end
  if roomData.roomId then
    self.roomId = roomData.roomId
  end
  if roomData.giftInfo then
    self.giftInfo = roomData.giftInfo
  end
  if roomData.group then
    local cacheGroup = self.group
    self:setGroup(roomData.group)
    if self.group == ChatGroupType.GROUP_CUSTOM then
      if string.contains(self.roomId, ChatGroupType.GROUP_SEASON_ROOM) then
        self:setGroup(ChatGroupType.GROUP_SEASON_ROOM)
      end
    elseif string.contains(self.roomId, ChatGroupType.GROUP_DRAGON_SELF_SERVER) then
      self:setGroup(ChatGroupType.GROUP_DRAGON_SELF_SERVER)
    elseif string.contains(self.roomId, ChatGroupType.GROUP_DRAGON_ALL_SERVER) then
      self:setGroup(ChatGroupType.GROUP_DRAGON_ALL_SERVER)
    elseif string.contains(self.roomId, ChatGroupType.GROUP_SEASON_FACTION_WAR_ROOM) then
      self:setGroup(ChatGroupType.GROUP_SEASON_FACTION_WAR_ROOM)
    elseif string.contains(self.roomId, ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM) then
      self:setGroup(ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM)
    elseif string.contains(self.roomId, ChatGroupType.GROUP_EPIDEMIC_FARMER) then
      self:setGroup(ChatGroupType.GROUP_EPIDEMIC_FARMER)
    elseif string.contains(self.roomId, ChatGroupType.GROUP_LANDLORD_LORD) then
      self:setGroup(ChatGroupType.GROUP_LANDLORD_LORD)
    elseif string.contains(self.roomId, ChatGroupType.GROUP_LANDLORD_FARMER) then
      self:setGroup(ChatGroupType.GROUP_LANDLORD_FARMER)
    end
    if cacheGroup == ChatGroupType.GROUP_LANGUAGE or cacheGroup == ChatGroupType.GROUP_ALLIANCE_NOTICE or cacheGroup == ChatGroupType.GROUP_ALLIANCE_MANAGER then
      self:setGroup(cacheGroup)
    end
  end
  if roomData.firstSeqId then
    self.firstSeqId = roomData.firstSeqId
  end
  if roomData.lastSeqId then
    self.lastSeqId = roomData.lastSeqId
  end
  if roomData.readSeqId then
    self.readSeqId = tonumber(roomData.readSeqId)
  end
  if roomData.delSeqIds then
    self.delSeqIds = roomData.delSeqIds
  end
  if roomData.firstMsgTime then
    self.firstMsgTime = roomData.firstMsgTime
  end
  if roomData.lastMsgTime then
    self.lastMsgTime = roomData.lastMsgTime
  end
  if roomData.appId then
    self.appId = roomData.appId
  end
  self.kickRoom = roomData.kickRoom
  if roomData.owner and roomData.owner ~= "CHAT_SYSTEM" then
    self.owner = roomData.owner
  end
  if roomData.leaderId then
    self.owner = roomData.leaderId
  end
  if self.group == "" and string.find(self.roomId, "custom") then
    self:setGroup(ChatGroupType.GROUP_CUSTOM)
  end
  if roomData.name and roomData.name ~= "CHAT_SYSTEM" then
    self.name = roomData.name
  end
  if roomData.lastNotMsgUpdateTime then
    self.lastNotMsgUpdateTime = roomData.lastNotMsgUpdateTime
  else
    self.lastNotMsgUpdateTime = self.lastMsgTime
  end
  if roomData.filterLastTime then
    self.filterLastTime = roomData.filterLastTime
  end
  if not string.IsNullOrEmpty(roomData.members) then
    local memberArr = rapidjson.decode(roomData.members)
    if memberArr == nil or type(memberArr) ~= "table" then
      memberArr = string.split(roomData.members, "|")
    end
    if memberArr then
      self:UpdateMemberList(memberArr)
    else
      ChatPrint("member string error??")
    end
  elseif self:isPrivateChat() then
    local tabName = string.split(self.name, "_")
    if table.count(tabName) == 4 then
      self.memberList[#self.memberList + 1] = tabName[2]
      self.memberDic[tabName[2]] = true
      self.memberList[#self.memberList + 1] = tabName[4]
      self.memberDic[tabName[4]] = true
    end
  end
  if self:isPrivateChat() then
    self.category = ChatRoomCategory.PRIVATE
    if roomData.seqIds and not string.IsNullOrEmpty(roomData.seqIds) then
      local seqList = string.split(roomData.seqIds, ",")
      for i = 1, #seqList do
        if not string.IsNullOrEmpty(seqList[i]) then
          self:AddUnreadList(toInt(seqList[i]))
        end
      end
    end
  end
  if roomData.commentNum then
    self.commentNum = roomData.commentNum
  end
  if roomData.friendsCircleLikeUids then
    self.friendsCircleLikeUids = roomData.friendsCircleLikeUids
  end
  if roomData.kickRoom == 1 then
    self:SetMsgSuccess()
    self.readSeqId = self.lastSeqId - 1
  end
  local hasVoiceRoomSwitchField = roomData.voiceRoomSwitch ~= nil
  if hasVoiceRoomSwitchField then
    self.voiceRoomSwitch = roomData.voiceRoomSwitch == true
  end
  local voiceServiceState = LuaEntry.DataConfig:CheckSwitch("voice_room")
  if not voiceServiceState then
    self.voiceRoomSwitch = false
  end
  local voiceMgr = ChatManager2:GetInstance().Voice or nil
  if self.voiceRoomSwitch == true and roomData.voiceRoomInfo ~= nil then
    local voiceRoomInfo = roomData.voiceRoomInfo
    if voiceMgr then
      voiceMgr:InitVoiceRoomData(self.roomId, voiceRoomInfo.voiceRoomId, voiceRoomInfo.playerSig, voiceRoomInfo.sdkAppId, voiceRoomInfo.voiceMemberList)
    end
  elseif voiceMgr then
    voiceMgr:ClearVoiceRoomData(self.roomId)
  end
  if voiceMgr then
    if self.voiceRoomSwitch == true then
      voiceMgr:AddVoiceRoom(self.roomId)
    else
      voiceMgr:RemoveVoiceRoom(self.roomId)
    end
  end
  if not ignoreUnread then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UNREAD_UPDATE, self)
  end
  self.isNotDisturbing = ChatInterface.getGroupChatMgr():GetIsNotDisturbingRoom(self.roomId)
end

function ChatRoomData:SetMsgSuccess()
  self.getLastMsg = true
end

function ChatRoomData:CheckIsReachFirstMessage(msgs)
  if msgs == nil or #msgs == 0 then
    return
  end
  self.isReachFirstMessage = false
  for i = 1, #msgs do
    if msgs[i].seqId == self.firstSeqId then
      self.isReachFirstMessage = true
      return
    end
  end
end

function ChatRoomData:GetMsgSuccess()
  return self.getLastMsg
end

function ChatRoomData:IsGmRoom()
  if table.count(self.memberList) == 0 then
    if self.roomId == ChatGMRoomId then
      return true
    end
    return false
  end
  for _, memberId in pairs(self.memberList) do
    if memberId == ChatGMUserId then
      return true
    end
  end
  return false
end

function ChatRoomData:HasUserByUid(userId)
  if userId then
    return self.memberDic[userId] and true or false
  end
  return false
end

function ChatRoomData:getMemberList()
  return self.memberList
end

function ChatRoomData:getPrivateOtherMember()
  local otherUid = ""
  for _, memUid in pairs(self.memberList) do
    if memUid ~= LuaEntry.Player.uid then
      otherUid = memUid
      break
    end
  end
  if string.IsNullOrEmpty(otherUid) then
    return
  end
  return ChatInterface.getUserData(otherUid)
end

function ChatRoomData:isPrivateChat()
  if not self:isCustomRoom() then
    return false
  end
  if not string.startswith(self.name, "PRIVATE") then
    return false
  end
  return true
end

function ChatRoomData:GetPrivateUser()
  if self:isPrivateChat() then
    local arr = string.split(self.name, "_")
    if #arr ~= 4 then
      return ""
    end
    if arr[1] == "PRIVATE" and (arr[3] == "to" or arr[3] == "STICKY") then
      if arr[2] == ChatInterface.getPlayerUid() then
        return arr[4]
      elseif arr[4] == ChatInterface.getPlayerUid() then
        return arr[2]
      end
    end
  end
  return ""
end

function ChatRoomData:getFirstSeqId()
  if not self.msgs or #self.msgs == 0 then
    return -1
  end
  return self.msgs[1].seqId
end

function ChatRoomData:GetOriginalFirstSeqId()
  if self.firstSeqId <= 0 then
    self.firstSeqId = 1
  end
  return self.firstSeqId
end

function ChatRoomData:GetFirstMsgServerTime()
  if #self.msgs == 0 then
    return 0
  end
  return self.msgs[1]:getServerTime()
end

function ChatRoomData:GetUnblockedFirstChatData()
  local datas = self:GetUnblockedChatDatas()
  if datas then
    return datas[1]
  end
end

function ChatRoomData:GetLastMsgSeqId()
  if #self.msgs == 0 then
    return -1
  end
  return self.msgs[#self.msgs].seqId
end

function ChatRoomData:GetLastMsgServerTime()
  if #self.msgs == 0 then
    return 0
  end
  return self.msgs[#self.msgs]:getServerTime()
end

function ChatRoomData:getToTalNum()
  return #self.msgs
end

function ChatRoomData:SetMsgs(msgs)
  self.msgs = msgs
end

function ChatRoomData:GetMsgs()
  return self.msgs
end

function ChatRoomData:GetIsReachFirstMessage()
  return self.isReachFirstMessage
end

function ChatRoomData:SetIsReachFirstMessage(isReachFirstMessage)
  self.isReachFirstMessage = isReachFirstMessage
end

function ChatRoomData:getLastChatData(noSYS)
  local restrict = ChatManager2:GetInstance().Restrict
  for i = #self.msgs, 1, -1 do
    local msg = self.msgs[i]
    if noSYS then
      if not msg:CheckSYS() and not restrict:isInRestrictList(msg.senderUid, RestrictType.BLOCK) then
        return msg
      end
    elseif not restrict:isInRestrictList(msg.senderUid, RestrictType.BLOCK) then
      return msg
    end
  end
end

function ChatRoomData:GetIsShowMsg(msg)
  local isDel
  local restrict = ChatManager2:GetInstance().Restrict
  if self.delSeqIds then
    for i, seqId in pairs(self.delSeqIds) do
      if msg.seqId == seqId then
        isDel = true
      end
    end
  end
  return ChatManager2:GetInstance().Restrict:GetMsgIsCanShow(msg) and not isDel
end

function ChatRoomData:GetLastChatDatas(noSYS, totalCnt)
  totalCnt = totalCnt or 1
  local msglist = {}
  for i = #self.msgs, 1, -1 do
    local msg = self.msgs[i]
    if noSYS then
      if not msg:CheckSYS() and self:GetIsShowMsg(msg) then
        msglist[#msglist + 1] = msg
        if totalCnt <= #msglist then
          return msglist
        end
      end
    elseif self:GetIsShowMsg(msg) then
      msglist[#msglist + 1] = msg
      if totalCnt <= #msglist then
        return msglist
      end
    end
  end
  return msglist
end

function ChatRoomData:GetLastChatTime()
  return self.lastMsgTime
end

function ChatRoomData:SetLastChatTime(time)
  self.lastMsgTime = time
end

function ChatRoomData:addMembers(memberUids)
  if type(memberUids) ~= "table" then
    ChatPrint("addMembers error")
    return
  end
  for _, memberUid in pairs(memberUids) do
    if table.hasvalue(self.memberList, memberUid) == false and not string.IsNullOrEmpty(memberUid) then
      table.insert(self.memberList, memberUid)
    end
    if not self.memberDic[memberUid] then
      self.memberDic[memberUid] = true
    end
    if memberUid == LuaEntry.Player.uid then
      self.kickRoom = nil
    end
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_MEMBER_CHANGE, self)
  ChatManager2:GetInstance().User:requestUserInfo(memberUids)
end

function ChatRoomData:removeMember(uid)
  if type(uid) ~= "string" then
    ChatPrint("removeMember error")
    return
  end
  table.removebyvalue(self.memberList, uid)
  if self.memberDic[uid] then
    self.memberDic[uid] = nil
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_MEMBER_CHANGE, self)
end

function ChatRoomData:removeMembers(memberUids)
  if type(memberUids) ~= "table" then
    ChatPrint("removeMembers error")
    return
  end
  for _, memberUid in pairs(memberUids) do
    table.removebyvalue(self.memberList, memberUid)
    if self.memberDic[memberUid] then
      self.memberDic[memberUid] = nil
    end
    if memberUid == LuaEntry.Player.uid then
      self.kickRoom = 1
      EventManager:GetInstance():Broadcast(ChatEventEnum.ROOM_BE_KICK_OUT, {
        roomId = self.roomId
      })
      return
    end
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_MEMBER_CHANGE, self)
end

function ChatRoomData:isExistChatData(chatData)
  for k, _chatData in ipairs(self.msgs) do
    if _chatData.seqId == chatData.seqId and _chatData.sendLocalTime == chatData.sendLocalTime and _chatData.senderUid == chatData.senderUid then
      self.msgs[k] = chatData
      return true
    end
  end
  return false
end

function ChatRoomData:SetNotDisturbing(isOn)
  if self.isNotDisturbing ~= isOn then
    self.isNotDisturbing = isOn
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_NOTDISTURD_UPDATE, self)
  end
end

function ChatRoomData:GetNotDisturbing()
  return self.isNotDisturbing or false
end

function ChatRoomData:isExistSeqId(seqId)
  for _, v in ipairs(self.msgs) do
    if v.seqId == seqId then
      return true
    end
  end
  return false
end

function ChatRoomData:__addChatDatas(chatDataArray)
  if chatDataArray == nil or #chatDataArray == 0 then
    return
  end
  for _, v in ipairs(chatDataArray) do
    self:__addChatData(v)
  end
  self:sort()
end

function ChatRoomData:AddChatDataOnly(chatData)
  local exist, k = self:__isExistChatData(chatData)
  if exist then
    self.msgs[k] = chatData
  else
    table.insert(self.msgs, chatData)
  end
end

function ChatRoomData:AddUnreadList(seqId)
  if not seqId then
    return
  end
  if not self.seqIds then
    self.seqIds = {}
  end
  if not self.seqIdSet then
    self.seqIdSet = {}
  end
  if self.seqIdSet[seqId] then
    return
  end
  table.insert(self.seqIds, seqId)
  self.seqIdSet[seqId] = true
end

function ChatRoomData:ClearUnReadList()
  self.seqIds = {}
  self.seqIdSet = {}
end

function ChatRoomData:__isExistChatData(chatData)
  for k, _chatData in ipairs(self.msgs) do
    if _chatData.seqId == chatData.seqId and _chatData.sendLocalTime == chatData.sendLocalTime and _chatData.senderUid == chatData.senderUid then
      return true, k
    end
  end
  return false, 0
end

function ChatRoomData:__addChatData(chatData, isPush)
  local chatDataSize = estimateTableSize(chatData)
  local exist, k = self:__isExistChatData(chatData)
  if exist then
    local prevSize = estimateTableSize(self.msgs[k])
    self.__estimateSize = self.__estimateSize + chatDataSize - prevSize
    self.msgs[k] = chatData
    return false
  end
  self.__estimateSize = self.__estimateSize + chatDataSize + 16
  local isUpdate
  if not exist then
    if chatData.seqId == 0 then
      local netSeq = 1.0001
      if #self.msgs > 0 then
        netSeq = chatData:NextSeqId(self.msgs[#self.msgs].seqId)
      end
      if netSeq then
        chatData:setSeqId(netSeq)
        table.insert(self.msgs, chatData)
      else
        return false
      end
    else
      table.insert(self.msgs, chatData)
    end
    if chatData.senderUid and chatData.seqId then
      local speakData = self.speakingPlayersMap[chatData.senderUid]
      if not speakData then
        self.speakingPlayersMap[chatData.senderUid] = {}
        self.speakingPlayersMap[chatData.senderUid].count = 1
      else
        speakData.count = speakData.count + 1
      end
      if chatData.seqId > self.readSeqId then
        local data = self.readMessagePlayerSpeakCount[chatData.senderUid]
        if data then
          data.count = data.count + 1
        else
          self.readMessagePlayerSpeakCount[chatData.senderUid] = {}
          self.readMessagePlayerSpeakCount[chatData.senderUid].count = 1
        end
      end
    end
    if self.lastMsgTime < chatData:getServerTime() then
      self.lastMsgTime = chatData:getServerTime()
    end
    local seqId = chatData.seqId and tonumber(chatData.seqId) or 0
    local readId = tonumber(self.readSeqId)
    local isBlock = ChatManager2:GetInstance().Restrict:isInRestrictList(chatData.senderUid, RestrictType.BLOCK)
    if self:isPrivateChat() and isPush then
      if chatData.senderUid ~= LuaEntry.Player.uid then
        isUpdate = true
        self:AddUnreadList(chatData.seqId)
        if chatData.post == PostType.GiftGiving and (not self.giftInfo or chatData.serverTime > self.giftInfo.timestamp) then
          local extraJson
          if type(chatData.extra.customJsonParam) == "string" then
            extraJson = rapidjson.decode(chatData.extra.customJsonParam)
          elseif type(chatData.extra.customJsonParam) == "table" then
            extraJson = chatData.extra.customJsonParam
          end
          local canShow = DataCenter.GiftSystemManager:CanShowGiftBubble(extraJson.itemId, extraJson.num)
          if extraJson and canShow then
            self.giftInfo = {
              itemId = extraJson.itemId,
              timestamp = chatData.serverTime,
              seqId = chatData.seqId,
              num = extraJson.num
            }
          end
        end
        self.filterLastTime = chatData:getServerTime()
      end
    elseif isPush and chatData.senderUid == LuaEntry.Player.uid and seqId > readId and chatData.post == PostType.Text_Normal then
      self.readSeqId = seqId
    else
      isUpdate = true
    end
    if self.lastSeqId < chatData.seqId then
      self.lastSeqId = seqId
      if isUpdate and not isBlock then
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UNREAD_UPDATE, self)
      end
    end
    if chatData:IsMessageAtMe() and seqId > readId and not isBlock then
      self:OnReceiveAtSeqIds({
        {
          seqId,
          chatData.senderUid,
          chatData.serverTime
        }
      })
    end
    return true
  end
  return false
end

function ChatRoomData:RemoveAllFakeChatData()
  for i = #self.msgs, 1, -1 do
    local chatData = self.msgs[i]
    if chatData and chatData:IsFakePhotoChatData() then
      table.remove(self.msgs, i)
    end
  end
end

function ChatRoomData:RemoveFackeChatDataByPicVer(picVer)
  for i = #self.msgs, 1, -1 do
    local chatData = self.msgs[i]
    if chatData and chatData:IsFakePhotoChatData() and chatData:getExtra().picVer == picVer then
      table.remove(self.msgs, i)
      return
    end
  end
end

function ChatRoomData:removeChatData(chatData)
  table.removebyvalue(self.msgs, chatData)
end

function ChatRoomData:RemoveChatDataBySeqId(seqId)
  for i = 1, #self.msgs do
    local chatData = self.msgs[i]
    if chatData and chatData:getSeqId() == seqId then
      table.remove(self.msgs, i)
      return
    end
  end
end

function ChatRoomData:updateChatData(chatData)
  for _, chatDataMsg in pairs(self.msgs) do
    if chatDataMsg.sendLocalTime == chatData.sendLocalTime then
      if chatData.appId then
        chatDataMsg.appId = chatData.appId
      end
      if chatData.roomId then
        chatDataMsg.roomId = chatData.roomId
      end
      if chatData.group then
        chatDataMsg.group = chatData.group
      end
      if chatData.type then
        chatDataMsg.type = chatData.type
      end
      if chatData.isTranslating then
        chatDataMsg.isTranslating = chatData.isTranslating
      end
      if chatData._id then
        chatDataMsg._id = chatData._id
      end
      if chatData.seqId then
        chatDataMsg.seqId = chatData.seqId
      end
      if chatData.senderUid then
        chatDataMsg.senderUid = chatData.senderUid
      end
      if chatData.senderName then
        chatDataMsg.senderName = chatData.senderName
      end
      if chatData.serverTime then
        chatDataMsg.serverTime = chatData.serverTime
      end
      if chatData.post then
        chatDataMsg.post = chatData.post
      end
      if chatData.msg then
        chatDataMsg.msg = chatData.msg
      end
      if chatData.translateMsg then
        chatDataMsg.translateMsg = chatData.translateMsg
      end
      if chatData.originalLang then
        chatDataMsg.originalLang = chatData.originalLang
      end
      if chatData.translatedLang then
        chatDataMsg.translatedLang = chatData.translatedLang
      end
      if chatData.sendState then
        chatDataMsg.sendState = chatData.sendState
      end
      if chatData.attachmentId then
        chatDataMsg.attachmentId = chatData.attachmentId
      end
      if chatData.media then
        chatDataMsg.media = chatData.media
      end
      if chatData.msgMask then
        chatDataMsg.msgMask = chatData.msgMask
      end
    end
  end
end

function ChatRoomData:getChatDataBySeqId(seqId)
  for _, chatData in ipairs(self.msgs) do
    if chatData.seqId == seqId then
      return chatData
    end
  end
  return nil
end

function ChatRoomData:sort()
  table.sort(self.msgs, function(chatData1, chatData2)
    return chatData1.seqId < chatData2.seqId
  end)
end

function ChatRoomData:getNewMsgNum()
  local seqDiff = 0
  local firstNotReadSeqId = self.readSeqId + 1
  if self.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
    seqDiff = DataCenter.AllianceNoticeManager:GetRedDotNumber()
  else
    if self:isPrivateChat() then
      local count = #self.seqIds
      if count ~= 0 then
        firstNotReadSeqId = self.seqIds[1]
      else
        firstNotReadSeqId = -1
      end
      return count, firstNotReadSeqId
    end
    local blackMsgCount = 0
    for uid, data in pairs(self.readMessagePlayerSpeakCount) do
      if ChatManager2:GetInstance().Restrict:isInRestrictList(uid, RestrictType.BLOCK) then
        blackMsgCount = blackMsgCount + data.count
      end
    end
    seqDiff = math.max(0, self.lastSeqId - self.readSeqId - blackMsgCount)
    firstNotReadSeqId = math.floor(self.readSeqId + 1)
    if self.delSeqIds then
      local minSeq = self.msgs and self.msgs[0] and self.msgs[0].seqId or self.readSeqId
      local maxSeq = self.lastSeqId
      for _, delSeqId in ipairs(self.delSeqIds) do
        if delSeqId <= maxSeq and delSeqId > minSeq then
          seqDiff = seqDiff - 1
        end
        if delSeqId == firstNotReadSeqId then
          firstNotReadSeqId = firstNotReadSeqId + 1
        end
      end
    end
  end
  return math.floor(seqDiff), firstNotReadSeqId
end

function ChatRoomData:readMsg(seqId)
  self.readSeqId = seqId
  if self.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
    DataCenter.AllianceNoticeManager:SaveReadTime()
  else
    local cmdTbl = {
      roomId = self.roomId,
      seqId = self.readSeqId
    }
    local atSeqId = self:GetAtSeqId()
    if ChatInterface.IsCanAtRoomGroup(self.group) and (not self.atInitRead or atSeqId) then
      self.atInitRead = true
      cmdTbl.atType = self.group
    end
    self.readMessagePlayerSpeakCount = {}
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatRead, cmdTbl)
    if self:isPrivateChat() then
      self:ClearUnReadList()
      self.giftInfo = nil
      self.lastNotMsgUpdateTime = 0
      self.filterLastTime = 0
    else
      CS.GameEntry.Setting:SetInt(self.roomId .. "_readSeqId_" .. LuaEntry.Player.uid, self.readSeqId)
    end
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UNREAD_UPDATE, self)
end

function ChatRoomData:getRoomId()
  return self.roomId
end

function ChatRoomData:HasVoiceRoomFeature()
  return self.voiceRoomSwitch == true
end

function ChatRoomData:getRoomName(isShare)
  local name = ""
  if self.group == ChatGroupType.GROUP_COUNTRY then
    name = ChatInterface.getString("100171")
  elseif self.group == ChatGroupType.GROUP_ALLIANCE then
    if isShare then
      local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      name = alData and "[" .. alData.abbr .. "] " .. alData.allianceName or ChatInterface.getString(GameDialogDefine.ALLIANCE)
    else
      name = ChatInterface.getString("110053")
    end
  elseif self.group == ChatGroupType.GROUP_AL_AUTO_INVITE then
    name = ChatInterface.getString("311025")
  elseif self.group == ChatGroupType.GROUP_CROSS_SERVER then
    name = ChatInterface.getString("104263")
  elseif self.group == ChatGroupType.GROUP_DRAGON_SELF_SERVER then
    name = ChatInterface.getString("458222")
  elseif self.group == ChatGroupType.GROUP_DRAGON_ALL_SERVER then
    name = ChatInterface.getString("458221")
  elseif self.group == ChatGroupType.GROUP_LANDLORD_FARMER then
    name = ChatInterface.getString("zonewar_landlord_limit_1075")
  elseif self.group == ChatGroupType.GROUP_LANDLORD_LORD then
    name = ChatInterface.getString("zonewar_landlord_limit_1076")
  elseif self.group == ChatGroupType.GROUP_CUSTOM then
    name = self.name
    if self:isPrivateChat() then
      local targetMemberId = self:GetPrivateUser()
      if targetMemberId == ChatGMUserId then
        return ChatInterface.getString("100619")
      end
      name = ChatInterface.GetShowRoomUserName(targetMemberId)
    elseif IsNumber(name) then
      name = ChatInterface.getString(name)
    end
  elseif self.group == ChatGroupType.GROUP_QUEST then
    name = ChatInterface.getString(GameDialogDefine.TASK)
  elseif self.group == ChatGroupType.GROUP_RADAR then
    name = ChatInterface.getString(GameDialogDefine.RADAR)
  elseif self.group == ChatGroupType.GROUP_TMPRoom then
    name = self.name
  elseif self.group == ChatGroupType.GROUP_LANGUAGE then
    name = SuportedLanguagesName[Localization:GetLanguage()]
  elseif self.group == ChatGroupType.GROUP_ALLIANCE_NOTICE then
    name = ChatInterface.getString("2900001")
  elseif self.group == ChatGroupType.GROUP_ALLIANCE_MANAGER then
    name = ChatInterface.getString("chat_alliance_channel_title")
  elseif self.group == ChatGroupType.GROUP_SEASON_ROOM then
    name = ChatInterface.getString(100356)
  elseif self.group == ChatGroupType.GROUP_SEASON_FACTION_WAR_ROOM then
    local sourceServerId = ChatInterface.getSelfServerId()
    local compId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(sourceServerId)
    name = DataCenter.SeasonFactionWarDataManager:GetCampName(compId)
  elseif self.group == ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM then
    name = Localization:GetString("s6_alliance_ally_tittle01")
  elseif self.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    return self.name
  else
    local temp = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(self.group)
    if temp then
      name = ChatInterface.getString(temp.name)
    end
  end
  return name
end

function ChatRoomData:getRoomImg()
  if self:isCustomRoom() then
    return ""
  else
    if self.group == ChatGroupType.GROUP_SEASON_FACTION_WAR_ROOM then
      local sourceServerId = ChatInterface.getSelfServerId()
      local compId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(sourceServerId)
      return DataCenter.SeasonFactionWarDataManager:GetCampIcon(compId)
    end
    local path = ChatGroupTypeImg[self.group]
    if path and not string.IsNullOrEmpty(path) then
      return string.format(LoadPath.LWChatFolder, path)
    else
      return ""
    end
  end
end

function ChatRoomData:getRoomGroup()
  return self.group
end

function ChatRoomData:getRoomLastSeqId()
  return self.lastSeqId
end

function ChatRoomData:setRoomLastSeqId(seqId)
  self.lastSeqId = seqId
end

function ChatRoomData:isWorldRoom()
  if self.group == ChatGroupType.GROUP_COUNTRY then
    return true
  end
  return false
end

function ChatRoomData:isAllianceRoom()
  if self.group == ChatGroupType.GROUP_ALLIANCE then
    return true
  end
  return false
end

function ChatRoomData:isLanguageRoom()
  if self.group == ChatGroupType.GROUP_LANGUAGE then
    return true
  end
  return false
end

function ChatRoomData:isSeasonRoom()
  if self.group == ChatGroupType.GROUP_SEASON_ROOM then
    return true
  end
  return false
end

function ChatRoomData:isAliFriendRoom()
  if self.group == ChatGroupType.GROUP_ALLIANCE_FRIEND_ROOM then
    return true
  end
  return false
end

function ChatRoomData:IsPin()
  return IntToBool(self.isPin)
end

function ChatRoomData:SetPin(p)
  self.isPin = BoolToInt(p)
end

function ChatRoomData:PrintRoomMsgTime()
  for k, v in pairs(self.msgs) do
    ChatPrint("--- msg id(%d), time: %f", v.seqId, v:getServerTime())
  end
end

function ChatRoomData:GetUnblockedChatDatas()
  local msgs = {}
  if not self.msgs then
    return msgs
  end
  for i = 1, #self.msgs do
    if ChatManager2:GetInstance().Restrict:GetMsgIsCanShow(self.msgs[i]) and (not self:isPrivateChat() or self.msgs[i].post ~= PostType.Text_ChatRoomSystemMsg) then
      table.insert(msgs, self.msgs[i])
    end
  end
  return msgs
end

function ChatRoomData:SetTempText(text)
  self:GetCacheData()
  self.cacheData.text = text
end

function ChatRoomData:GetCacheData()
  if not self.cacheData then
    self.cacheData = DataCenter.CacheData:GetInputData(self.roomId)
  end
  return self.cacheData
end

function ChatRoomData:GetInputAtPlayers()
  self:GetCacheData()
  return self.cacheData.inputAtPlayers or {}
end

function ChatRoomData:SetInputAtPlayers(players)
  self:GetCacheData()
  self.cacheData.inputAtPlayers = players
end

function ChatRoomData:SetTempReply(replyMsg)
  self:GetCacheData()
  self.cacheData.replyMsg = replyMsg
end

function ChatRoomData:ClearTemp()
  self.cacheData = nil
  DataCenter.CacheData:ClearChatInputDataByRoomId(self.roomId)
end

function ChatRoomData:SetCacheDelSeqId(seqId)
  if not self.delSeqIds then
    self.delSeqIds = {}
  end
  table.insert(self.delSeqIds, seqId)
end

function ChatRoomData:DeleteMessage(seqId)
  local index
  for i = #self.msgs, 1, -1 do
    if self.msgs[i].seqId == seqId then
      index = i
    end
  end
  if index then
    table.remove(self.msgs, index)
    EventManager:GetInstance():Broadcast(EventId.ChatDeleteMessage, self.roomId)
  end
end

function ChatRoomData:GetMsgsByCount(index, count, direction, includeCurrent)
  local msgList = {}
  local showMsgs = self:GetUnblockedChatDatas()
  local total = #showMsgs
  local offset = includeCurrent and 0 or 1
  local localFirstSeqId = self:getFirstSeqId()
  if direction == RequestType.PullPrev or direction == RequestType.InitFetch then
    local endIndex = math.max(index - offset, 1)
    local startIndex = math.max(endIndex - count + 1, 1)
    if not includeCurrent and startIndex == endIndex and endIndex == index then
      return
    end
    for i = startIndex, endIndex do
      local msg = showMsgs[i]
      if msg then
        table.insert(msgList, msg)
      end
    end
    if 0 < #msgList and localFirstSeqId == self.firstSeqId then
      local hasTime = msgList[1].seqId == showMsgs[1].seqId
      return 0 < #msgList and msgList or nil, hasTime
    end
  elseif direction == RequestType.PullLast then
    local startIndex = index + offset
    if total < startIndex then
      return
    end
    startIndex = math.min(startIndex, total)
    local endIndex = math.min(index + count - 1 + offset, total)
    for i = startIndex, endIndex do
      local msg = showMsgs[i]
      if msg then
        table.insert(msgList, msg)
      else
        break
      end
    end
  elseif direction == RequestType.JumpTo then
    for i = 1, #showMsgs do
      local msg = showMsgs[i]
      if msg then
        table.insert(msgList, msg)
      end
    end
  elseif direction == RequestType.LoadRecentMessages then
    for i = index, #showMsgs do
      local msg = showMsgs[i]
      if msg then
        table.insert(msgList, msg)
      end
    end
  end
  return 0 < #msgList and msgList or nil
end

function ChatRoomData:GetCurLsatSeqId()
  local msgs = self:GetUnblockedChatDatas()
  if 0 < #msgs then
    return msgs[#msgs].seqId
  end
end

function ChatRoomData:GetMsgsBySeqId(startSeqId, msgCount, requestType)
  local util = ChatInterface.GetUtil()
  local msgs = self:GetUnblockedChatDatas()
  startSeqId = startSeqId or self.lastSeqId
  local index = util.BinarySearchBySeqId(msgs, startSeqId)
  if self.msgs[1] and startSeqId > self.msgs[1].seqId and not index then
    index = util.BinarySearchBySeqId(msgs, startSeqId, true)
  end
  if not index then
    return nil
  end
  local msgDataList = self:GetMsgsByCount(index, msgCount, requestType, true)
  return msgDataList, msgs[index].seqId
end

function ChatRoomData:SetChatHistoryEnd(getType, isEnd)
  if getType == RequestType.PullPrev then
    self.isChatHistoryEnd = isEnd
  elseif getType == RequestType.PullLast then
    self.isLatestEnd = isEnd
  end
end

function ChatRoomData:GetLastIdLocalEnd()
  return #self.msgs > 0 and self.msgs[#self.msgs].seqId == self.lastSeqId
end

function ChatRoomData:GetIsChatHistoryEnd(getType)
  if getType == RequestType.PullPrev or getType == RequestType.InitFetch or getType == RequestType.JumpTo then
    return self.isChatHistoryEnd or self:GetFirstIdLocalEnd()
  elseif getType == RequestType.PullLast then
    return self.isLatestEnd or self:GetLastIdLocalEnd()
  end
end

function ChatRoomData:GetFirstIdLocalEnd()
  return #self.msgs > 0 and self.msgs[1].seqId == self.firstSeqId
end

function ChatRoomData:FindPrevId(seqId)
  if not seqId then
    return nil
  end
  local datas = self:GetUnblockedChatDatas()
  for i = #datas, 1, -1 do
    if datas[i].seqId == seqId and 1 < i then
      return datas[i - 1].seqId
    end
  end
  return nil
end

function ChatRoomData:CanFetchMore(requestType)
  return not self.historyState[requestType] and not self:GetIsChatHistoryEnd(requestType) and not self:IsMaxFetchCount(requestType)
end

function ChatRoomData:UpdateHistoryState(state, seqId, isAdding)
  self.isAutoFetchMissingData = isAdding
  self.historyState[state] = isAdding and seqId or nil
  if state == RequestType.PullPrev or state == RequestType.PullLast then
    local stateInfo = {
      roomId = self.roomId,
      state = state,
      isOn = isAdding
    }
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_FETCH_HISTORY_STATE_UPDATA, stateInfo)
  end
end

function ChatRoomData:SetHistoryState(state, seqId)
  self:UpdateHistoryState(state, seqId, true)
end

function ChatRoomData:RemoveHistoryState(state)
  self:UpdateHistoryState(state, nil, false)
end

function ChatRoomData:UpdateHistoryCount(state, seqId)
  if not state or not seqId then
    return
  end
  local record = self.historyCount[state]
  if not record or record.seqId ~= seqId then
    record = {seqId = seqId, count = 1}
    self.historyCount[state] = record
  else
    record.count = record.count + 1
    if record.count >= MaxChatHistoryLoops then
      record.isLimitReached = true
    end
  end
end

function ChatRoomData:ResetRoomAllFetchTypeLimits()
  self.historyCount = {}
end

function ChatRoomData:HasPlayerSpokenInRoom(uid)
  return self.speakingPlayersMap[uid] and true or false
end

function ChatRoomData:IsMaxFetchCount(requestType)
  local fetchType
  if requestType == RequestType.PullPrev or requestType == RequestType.InitFetch then
    fetchType = RequestType.PullPrev
  elseif requestType == RequestType.PullLast or requestType == RequestType.JumpTo then
    fetchType = RequestType.PullLast
  else
    fetchType = requestType
  end
  local record = self.historyCount[fetchType]
  return record and record.isLimitReached or false
end

function ChatRoomData:ClearState()
  self.historyState = {}
end

function ChatRoomData:InitAtInfo(data)
  self.atInitRead = false
  self:OnReceiveAtSeqIds(rapidjson.decode(data.info or {}))
end

function ChatRoomData:UpdateAtTimes(timesInfo)
  self.atUsedTimes = timesInfo and toInt(timesInfo.useTimes) or 0
end

function ChatRoomData:OnReceiveAtSeqIds(ids)
  for _, v in ipairs(ids) do
    if #v == 3 then
      local seqId = v[1]
      if not self.atSeqIdMap[seqId] then
        table.insert(self.atSeqIds, {
          seqId = seqId,
          uid = v[2],
          time = v[3]
        })
      end
      self.atSeqIdMap[seqId] = v
    end
    if #self.atSeqIds >= MAX_AT_SEQ_ID_NUM then
      self:ClearAtSeqId()
    end
  end
  table.sort(self.atSeqIds, function(a, b)
    if a.time and b.time and a.time ~= b.time then
      return a.time > b.time
    end
    return a.seqId > b.seqId
  end)
  if #self.atSeqIds > 0 then
    EventManager:GetInstance():Broadcast(EventId.CHAT_RECEIVE_AT_SEQ_ID, self.atSeqIds)
  end
end

function ChatRoomData:GetAtSeqInfo()
  return self.atSeqIds[1]
end

function ChatRoomData:GetAtSeqId()
  return self.atSeqIds[1] and self.atSeqIds[1].seqId
end

function ChatRoomData:ClearAtSeqId()
  if #self.atSeqIds > 0 then
    local info = table.remove(self.atSeqIds, 1)
    self.atSeqIdMap[info.seqId] = nil
  end
end

function ChatRoomData:OnPassDay()
  self.atUsedTimes = 0
end

function ChatRoomData:CanFetchMoreMessagesBySeqId(requestType, seqId)
  if not seqId then
    return true
  end
  if not self.historyState[requestType] then
    if requestType == RequestType.PullPrev then
      return seqId > self.firstSeqId
    elseif requestType == RequestType.PullLast then
      return seqId < self.lastSeqId
    end
  end
  return false
end

function ChatRoomData:UpdateAtAllCount(data)
  if not data.maxTimes or not data.useTimes then
    return
  end
  local count = data.maxTimes - data.useTimes
  if count ~= self.atAllCount then
    self.atAllCount = count
    local atInfo = {
      roomId = self.roomId,
      count = self.atAllCount
    }
    EventManager:GetInstance():Broadcast(EventId.CHAT_ATALL_COUNT, atInfo)
  end
end

function ChatRoomData:UpdateMemberList(memberList)
  if memberList then
    self.memberDic = {}
    self.memberList = memberList
    for i, uid in pairs(self.memberList) do
      self.memberDic[uid] = true
      if uid == LuaEntry.Player.uid then
        self.kickRoom = nil
      end
    end
  end
end

function ChatRoomData:IsKickedRoom()
  if self.group == ChatGroupType.GROUP_CUSTOM_GROUP and self.kickRoom == 1 then
    return true
  end
  return false
end

return ChatRoomData
