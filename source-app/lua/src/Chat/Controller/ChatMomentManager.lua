local ChatMomentManager = BaseClass("ChatMomentManager")
local getMomentCd = 10
local ChatMomentData = require("Chat.Model.ChatMomentData")
local SaveLocalMoentKey = "SelectMomentGroup"
local momentGroup = {
  [ChatGroupType.GROUP_ALLIANCE_MOMENT] = true,
  [ChatGroupType.GROUP_FOLLOW_MOMENT] = true,
  [ChatGroupType.GROUP_SERVER_COMMENT] = true,
  [ChatGroupType.GROUP_ALL_MOMENT] = true,
  [ChatGroupType.GROUP_SUGGEST_MOMENT] = true
}
local VisbilityConfig = {
  {
    visibilityRange = MomentVisibilityRange.All,
    lanKay = "moment_range_set_all",
    sort = 1
  },
  {
    visibilityRange = MomentVisibilityRange.Alliance,
    lanKay = "moment_range_set_alliance",
    sort = 2
  },
  {
    visibilityRange = MomentVisibilityRange.Only,
    lanKay = "moment_range_set_me",
    sort = 3
  }
}

function ChatMomentManager:__init()
  self.momentFollowDic = {}
  self.momentFollowList = {}
  self.allianceMomentDataList = {}
  self.followMomentDataList = {}
  self.momentRoom = {}
  self.followList = {}
  self.allianceMomentTime = 0
  self.followMomentTime = 0
  self.followDic = {}
  self.redDotDic = {}
  self.msgRedDot = 0
  self.GetDataTimeDic = {}
  self.chatSelectMoment = nil
  self.momentIsOpen = false
  self.isFirst = true
  self.exposureDic = {}
  self.sendMomentExposureDic = {}
  self.clickExposureDic = {}
end

function ChatMomentManager:GetMomentIsOpen()
  return self.momentIsOpen
end

function ChatMomentManager:SetMomentIsOpen(isOpen)
  self.momentIsOpen = isOpen
end

function ChatMomentManager:InitMomentRedDot()
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentUnReadTipsCount, 0)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentUnReadTipsCount, 1)
  UIUtil.GetPlayerInfoShowByUid(LuaEntry.Player.uid)
end

function ChatMomentManager:AddFollow(info)
  if not info then
    return
  end
  self.momentFollowDic[info.followeeId] = {
    isFollow = info.isFollow
  }
  if self.firstFoolwDic and self.firstFoolwDic[info.followeeId] and info.isFollow then
    self.firstFoolwDic[info.followeeId].isFirst = false
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MOMENT_RESF_FOLLOW_STATE, {
    uid = info.followeeId,
    isFollow = info.isFollow
  })
end

function ChatMomentManager:RemoveFollow(uid)
  if not uid then
    return
  end
  if self.momentFollowDic[uid] then
    self.momentFollowDic[uid] = nil
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MOMENT_RESF_FOLLOW_STATE, {uid = uid, isFollow = false})
  end
end

function ChatMomentManager:GetMomentFollowInfo(uid)
  return self.momentFollowDic[uid]
end

function ChatMomentManager:AddFollowList(infoList)
  for i = #infoList, 1, -1 do
    self:AddFollow(infoList[i])
  end
end

function ChatMomentManager:RemoveFollowList(infoList)
  if not infoList then
    return
  end
  local isOne = #infoList == 1
  for i = #infoList, 1, -1 do
    self:RemoveFollow(infoList[i], isOne)
  end
  if not isOne then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MOMENT_RESF_FOLLOW_STATE_LIST)
  end
end

function ChatMomentManager:GetNewMoments(momentPushType)
  local lastTime = 0
  if momentPushType == MomentPushType.Alliance then
    lastTime = self.allianceMomentTime
  elseif momentPushType == MomentPushType.Follow then
    lastTime = self.followMomentTime
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - lastTime > getMomentCd * 1000 then
    if momentPushType == MomentPushType.Alliance then
      self.allianceMomentTime = curTime
    elseif momentPushType == MomentPushType.Follow then
      self.followMomentTime = curTime
    end
  end
end

local CHAT_GROUP_MOMENT_TYPES = {
  [MomentPushType.Alliance] = ChatGroupType.GROUP_ALLIANCE_MOMENT,
  [MomentPushType.Follow] = ChatGroupType.GROUP_FOLLOW_MOMENT
}

function ChatMomentManager:OnPushMsg(redType, senderUid)
  if senderUid == LuaEntry.Player.uid then
    if redType == "WRITE_TIMELINE_FINISHED" then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MOMENT_MYSEND)
    end
    return
  end
  if redType == "ALLIANCE_MOMENTS" then
    redType = MomentPushType.Alliance
  elseif redType == "FOLLOW_MOMENTS" then
    redType = MomentPushType.Follow
  elseif redType == "MOMENTS_LIKE" then
    redType = MomentPushType.NoticeLike
  elseif redType == "MOMENTS_COMMENT" then
    redType = MomentPushType.NoticeComment
  elseif redType == "WRITE_TIMELINE_FINISHED" then
    return
  else
    return
  end
  self:SetMomentMsgRedDot(redType, 1, true)
end

function ChatMomentManager:SetMomentMsgRedDot(redType, number, isAdd)
  if not redType or not number then
    return
  end
  local group = CHAT_GROUP_MOMENT_TYPES[redType]
  local key = group or redType
  local oldNumber = self.redDotDic[key] or 0
  local newNumber
  if isAdd then
    newNumber = oldNumber + number
  else
    newNumber = number
  end
  newNumber = math.max(0, newNumber)
  self.redDotDic[key] = newNumber
  if group then
    local moment = self:GetMomentData(group)
    if moment then
      moment.redDotCount = newNumber
    end
  end
  if oldNumber ~= newNumber then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MOMENT_NOTICE_REDDOT, redType)
  end
end

function ChatMomentManager:GetRoomId(group)
  return group .. "_" .. LuaEntry.Player.uid .. group
end

function ChatMomentManager:CreateMomentRoom(roomId, group)
  return ChatMomentData.New(roomId, group)
end

function ChatMomentManager:ClearMomentRoom(group)
  if self.momentRoom[group] then
    self.momentRoom[group].msgs = {}
    self.momentRoom[group].groupParams = nil
  end
end

function ChatMomentManager:GetMomentData(group)
  if not momentGroup[group] then
    return
  end
  if not self.momentRoom[group] then
    local room = self:CreateMomentRoom(self:GetRoomId(group), group)
    self.momentRoom[group] = room
    if self.redDotDic[group] then
      room.redDotCount = self.redDotDic[group]
    end
  end
  return self.momentRoom[group]
end

function ChatMomentManager:AddMomentDatas(group, msgsTable)
  local chatData
  local data = self:GetMomentData(group)
  local msgs = msgsTable[group]
  data.groupParams = msgsTable.groupParams
  if msgs then
    for i, v in pairs(msgs) do
      chatData = ChatInterface.getRoomMgr():CreateChatMessage()
      chatData:onParseServerData(msgs[i])
      if chatData.senderUid then
        ChatInterface.getUserData(chatData.senderUid)
      end
      if group == ChatGroupType.GROUP_SUGGEST_MOMENT then
        data:AddSuggestMomentData(chatData)
      else
        data:__addChatData(chatData)
      end
    end
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MOMENT_MSG_UPDATE, group)
end

function ChatMomentManager:GetMomentFollowList()
  return self.followList
end

function ChatMomentManager:AddMomentFollowList(list)
  if list then
    for i = 1, #list do
      if not self.followDic[list[i].id] then
        self.followDic[list[i].id] = true
        table.insert(self.followList, list[i])
      end
    end
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MOMENT_FOLLW_LIST)
end

function ChatMomentManager:ClearMomentList()
  self.followList = {}
  self.followDic = {}
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MOMENT_FOLLW_LIST)
end

function ChatMomentManager:GetMomentChatData(roomId, seqId)
  for i, room in pairs(self.momentRoom) do
    for i, chatData in pairs(room.msgs) do
      if chatData.roomId == roomId and chatData.seqId == seqId then
        return chatData
      end
    end
  end
end

function ChatMomentManager:DeleteMomentMessage(roomId, seqId)
  local chatData
  for k, room in pairs(self.momentRoom) do
    for i = #room.msgs, 1, -1 do
      chatData = room.msgs[i]
      if chatData.roomId == roomId and chatData.seqId == seqId then
        table.remove(room.msgs, i)
        EventManager:GetInstance():Broadcast(EventId.ChatDeleteMessage, room.group)
        return
      end
    end
  end
end

function ChatMomentManager:UpdateAuth(param)
  local chatData
  local roomData = ChatInterface.getRoomData(param.roomId)
  if roomData then
    chatData = roomData:getChatDataBySeqId(param.seqId)
    if chatData then
      chatData:UpdateMomentMessage(param)
    end
  end
end

function ChatMomentManager:UpdateCommentCount(param)
  local room = self.momentRoom[param.source]
  if room then
    local chatData
    for i = #room.msgs, 1, -1 do
      chatData = room.msgs[i]
      if chatData.roomId == param.roomId and chatData.seqId == param.seqId then
        chatData:UpdateMomentMessage(param)
      end
    end
  end
end

function ChatMomentManager:GetMomentRoomData(roomId)
  for i, room in pairs(self.momentRoom) do
    for i, chatData in pairs(room.msgs) do
      if chatData.roomId == roomId then
        return ChatInterface.getRoomMgr():CreateChatRoomData(roomId, ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM)
      end
    end
  end
end

function ChatMomentManager:GetRedDot(type)
  return self.redDotDic[type] or 0
end

function ChatMomentManager:SetFirstFollow(uid, isFirst)
  if not self.firstFoolwDic then
    self.firstFoolwDic = {}
  end
  self.firstFoolwDic[uid] = {
    isFirst = not isFirst
  }
end

function ChatMomentManager:IsCanGetNewData(group)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local template = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(group)
  local templateCd = getMomentCd
  if template then
    templateCd = toInt(template.param) or getMomentCd
  end
  local lastTime = self.GetDataTimeDic[group] or 0
  if curTime - lastTime >= templateCd * 1000 then
    return true
  end
  return false
end

function ChatMomentManager:GetMomentServerByGroup(chatGroup)
  local roomData = self:GetMomentData(chatGroup)
  if chatGroup == ChatGroupType.GROUP_SUGGEST_MOMENT then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentTimeLineRecommend)
  else
    local param = {
      groupParams = roomData and roomData.groupParams,
      idDesc = true,
      groupType = chatGroup
    }
    if chatGroup == ChatGroupType.GROUP_FOLLOW_MOMENT then
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentGetFollowCircle, param)
    else
      param.roomId = ChatInterface.getAllianceRoomId()
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentGetFollowCircle, param)
    end
  end
  self.GetDataTimeDic[chatGroup] = UITimeManager:GetInstance():GetServerTime()
end

function ChatMomentManager:GetFirstFollow(uid)
  if not self.firstFoolwDic then
    return
  end
  return self.firstFoolwDic[uid]
end

function ChatMomentManager:GetIsMomentBody(post)
  if post == PostType.FriendsCirleBody or post == PostType.FriendsCirleBodyHasIcon then
    return true
  end
end

function ChatMomentManager:GetIsMomentData(post)
  if self:GetIsMomentBody(post) or post == PostType.Chat_Moment then
    return true
  end
end

function ChatMomentManager:GetSelectMomentGroup()
  if not self.chatSelectMoment then
    self.chatSelectMoment = ChatGroupType.GROUP_ALL_MOMENT
  end
  return self.chatSelectMoment
end

function ChatMomentManager:SetSelectMomentGroup(group)
  self.chatSelectMoment = group
end

function ChatMomentManager:GetVisibilityConfig()
  return DeepCopy(VisbilityConfig)
end

function ChatMomentManager:AddExposure(data, scene)
  if not data then
    return
  end
  if not self.sendMomentExposureDic[data.msgId] and not self.exposureDic[data.msgId] then
    self.exposureDic[data.msgId] = {
      msgId = data.msgId,
      bucket = data.bucket,
      scene = scene
    }
  end
end

function ChatMomentManager:SendClickExposure(msgId)
  if msgId and not self.clickExposureDic[msgId] then
    self.clickExposureDic[msgId] = true
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentTimeLineClick, msgId)
  end
end

function ChatMomentManager:SendExposure()
  if table.count(self.exposureDic) == 0 then
    return
  end
  local sendMsgDataList = {}
  for key, data in pairs(self.exposureDic) do
    table.insert(sendMsgDataList, data)
    self.sendMomentExposureDic[data.msgId] = true
  end
  self.exposureDic = {}
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentTimeLineExposure, sendMsgDataList)
end

function ChatMomentManager:GetAuth()
  return {
    [MomentVisibilityRange.All] = 0,
    [MomentVisibilityRange.SameServer] = 0,
    [MomentVisibilityRange.Alliance] = 0,
    [MomentVisibilityRange.MyFollowers] = 0,
    [MomentVisibilityRange.Only] = 0
  }
end

function ChatMomentManager:IsMomentGroup(group)
  if momentGroup[group] then
    return true
  end
  return false
end

function ChatMomentManager:GetSuggestIsOn()
  if self.suggestIsOn == nil then
    self.suggestIsOn = LuaEntry.DataConfig:CheckSwitch("moment_suggest")
  end
  return self.suggestIsOn
end

function ChatMomentManager:MomentAuthCheck(message)
  if message and message.msgBody then
    local chatData = ChatInterface.getRoomMgr():CreateChatMessage()
    chatData:onParseServerData(message.msgBody)
    local param = {chatData = chatData}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleMomentDetailView, {anim = true}, param)
  end
end

return ChatMomentManager
