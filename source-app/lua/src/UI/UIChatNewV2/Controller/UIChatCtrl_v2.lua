local UIChatCtrl = BaseClass("UIChatCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIChatCtrl:__init()
  self:ClearUnreadCountAndJumpSeqId()
end

function UIChatCtrl:__delete()
  self:ClearUnreadCountAndJumpSeqId()
end

function UIChatCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatNew_v2, {anim = true, playEffect = false})
end

local function GetRoomSetUnreadNumber(roomSet)
  if not roomSet or not roomSet.rooms then
    return UnreadNotificationType.NoNotification, 0
  end
  if roomSet.category == ChatRoomCategory.MOMENT then
    local commentCount = ChatInterface.getMoment():GetRedDot(MomentPushType.NoticeComment) or 0
    return UnreadNotificationType.ShowUnreadCount, commentCount
  end
  local showUnreadCount = 0
  local showUnreadDot = 0
  for _, room in ipairs(roomSet.rooms) do
    if not room:GetNotDisturbing() then
      local type = ChatManager2:GetInstance().Room:GetRoomRedDotType(room.group)
      if type == UnreadNotificationType.ShowUnreadCount then
        showUnreadCount = showUnreadCount + (room and room:getNewMsgNum() or 0)
      end
      if type == UnreadNotificationType.ShowUnreadDot then
        showUnreadDot = showUnreadDot + (room and room:getNewMsgNum() or 0)
      end
    end
  end
  if 0 < showUnreadCount then
    return UnreadNotificationType.ShowUnreadCount, showUnreadCount
  elseif 0 < showUnreadDot then
    return UnreadNotificationType.ShowUnreadDot, showUnreadDot
  else
    return UnreadNotificationType.NoNotification, 0
  end
end

local MomentGroup2Type = {FeedSuggest = 1, FeedMy = 2}
local MomentLang = {
  [MomentGroup2Type.FeedSuggest] = {
    langKey = "moment_feed_suggest"
  },
  [MomentGroup2Type.FeedMy] = {
    langKey = "moment_feed_my",
    defSelect = true
  }
}
local chatShowRoom = {
  {
    category = ChatRoomCategory.WORLD,
    textKey = "100171",
    GetUnreadNumber = GetRoomSetUnreadNumber
  },
  {
    category = ChatRoomCategory.ALLIANCE,
    textKey = "393081",
    GetUnreadNumber = GetRoomSetUnreadNumber
  },
  {
    category = ChatRoomCategory.MOMENT,
    textKey = "moment_title",
    GetUnreadNumber = GetRoomSetUnreadNumber
  },
  {
    category = ChatRoomCategory.PRIVATE,
    textKey = "290038",
    GetUnreadNumber = GetRoomSetUnreadNumber
  }
}

function UIChatCtrl:GetMomentConfig(groupConfig)
  local roomsGroupType = DataCenter.GroupChatSetTemplateManager:GetGroupAllRoom(groupConfig.category)
  local configDict = {}
  local group2Keys = {}
  local isOn = ChatInterface.getMoment():GetSuggestIsOn()
  for j = 1, #roomsGroupType do
    local template = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(roomsGroupType[j])
    if template then
      local group2 = toInt(template.group2)
      if group2 ~= MomentGroup2Type.FeedSuggest or isOn then
        if not configDict[group2] then
          configDict[group2] = {
            secondGroups = {},
            langKey = MomentLang[group2] and MomentLang[group2].langKey or "",
            secondGroupType = group2,
            defSelect = MomentLang[group2] and MomentLang[group2].defSelect or false
          }
          table.insert(group2Keys, group2)
        end
        table.insert(configDict[group2].secondGroups, roomsGroupType[j])
      end
    end
  end
  table.sort(group2Keys, function(a, b)
    return a < b
  end)
  local sortedGroups = {}
  for _, g2 in ipairs(group2Keys) do
    table.insert(sortedGroups, configDict[g2])
  end
  return sortedGroups
end

function UIChatCtrl:GetRoomGroup()
  local dic = {}
  local config = DeepCopy(chatShowRoom)
  for i = 1, #config do
    local groupConfig = config[i]
    if groupConfig.category == ChatRoomCategory.MOMENT then
      if ChatInterface.getMoment():GetMomentIsOpen() then
        groupConfig.groups = self:GetMomentConfig(groupConfig)
        dic[groupConfig.category] = groupConfig
      else
        groupConfig.groups = {}
      end
    else
      local roomsGroupType = DataCenter.GroupChatSetTemplateManager:GetGroupAllRoom(groupConfig.category)
      groupConfig.groups = roomsGroupType or {}
      dic[groupConfig.category] = groupConfig
    end
  end
  return config, dic
end

function UIChatCtrl:GetNoticeDataList(isPinned)
  if isPinned then
    return DataCenter.AllianceNoticeManager:GetNoticePinnedListInfo()
  else
    return DataCenter.AllianceNoticeManager:GetNoticeListInfo()
  end
end

function UIChatCtrl:FilterMessage(chatMsgs)
  local msgs = DeepCopy(chatMsgs)
  for i = #chatMsgs, 1, -1 do
    if chatMsgs[i].postType == PostType.Activity_BargainShop then
      table.remove(msgs, i)
    end
  end
end

function UIChatCtrl:SendMessage(msg, isProxy, postType, extraData)
  if not msg or string.IsNullOrEmpty(string.trim(msg)) then
    return
  end
  local currRoom = self.view:GetSelectedRoom()
  if not currRoom then
    UIUtil.ShowTipsId("335392")
    return
  end
  local levelLimit = LuaEntry.DataConfig:TryGetNum("chat_level", "k1")
  local mainLv = DataCenter.BuildManager.MainLv
  if levelLimit > mainLv then
    UIUtil.ShowTipsId(457538)
    return
  end
  local groupTemp = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(currRoom.group)
  if groupTemp and groupTemp.limit_lv > 0 and mainLv < groupTemp.limit_lv then
    local msg = Localization:GetString("channel_chat_limit_tips", groupTemp.limit_lv)
    UIUtil.ShowTips(msg)
    return
  end
  local isSendEmoji = extraData and extraData.isSendEmoji or false
  msg = ChatInterface.CheckMessage(msg)
  local str = ChatInterface.GetOldEmojiStr(msg)
  if not string.IsNullOrEmpty(str) then
    isSendEmoji = true
  end
  if extraData and extraData.atAll then
    local name = Localization:GetString("at_all_text1")
    msg = string.gsub(msg, "@" .. name, "@" .. ATTag.atAllTag)
  end
  local cmdTbl = {
    roomId = currRoom.roomId,
    msg = msg,
    isProxy = isProxy,
    extra = extraData,
    group = currRoom.group
  }
  if postType then
    cmdTbl.extra = cmdTbl.extra or {}
    cmdTbl.extra.post = postType
  end
  local isEmojiFormatMsg = self:CheckIsEmojiFormatMsg(msg)
  if isEmojiFormatMsg then
    cmdTbl.extra = cmdTbl.extra or {}
    cmdTbl.extra.isNormalMsg = not isSendEmoji
  end
  local replyMsg = currRoom:GetCacheData().replyMsg or nil
  if replyMsg then
    local replySender = ChatInterface.getUserData(replyMsg.senderUid)
    cmdTbl.reply = {
      seqId = replyMsg.seqId,
      uid = replyMsg.senderUid,
      userName = replySender and replySender.userName or "",
      abbr = replySender and replySender.abbr or "",
      msg = replyMsg.msg,
      post = replyMsg.post
    }
  end
  local userInfo = currRoom:getPrivateOtherMember()
  local canSend
  if currRoom.group == ChatGroupType.GROUP_TMPRoom then
    canSend = true
    if not userInfo then
      return
    end
    cmdTbl.toUid = userInfo.uid
  else
    local tempRoom = ChatInterface.getRoomData(cmdTbl.roomId)
    if tempRoom then
      canSend = true
    end
  end
  if canSend then
    ChatManager2:GetInstance():SyncMessageToServer(cmdTbl, cmdTbl.roomId)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, cmdTbl)
    EventManager:GetInstance():Broadcast(EventId.SetReplyChatMsg, nil)
    if cmdTbl.msg and ChatManager2:GetInstance():IsStrEmoji(cmdTbl.msg) or ChatManager2:GetInstance():IsSticker(postType) then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD)
    end
  else
    UIUtil.ShowTipsId("group_no_in_room")
  end
end

function UIChatCtrl:GetWindName()
  return UIWindowNames.UIChatNew_v2
end

function UIChatCtrl:CheckIsEmojiFormatMsg(msg)
  if string.IsNullOrEmpty(msg) then
    return false
  end
  if string.startswith(msg, "<lwEmoji:") and string.endswith(msg, ":>") then
    return true
  end
  return false
end

function UIChatCtrl:ClearUnreadCountAndJumpSeqId()
  self.cacheUnreadJump = false
  self.showUnreadJump = false
  self.roomId = nil
  self.unreadCount = nil
  self.unreadSeqId = nil
end

function UIChatCtrl:CacheUnreadCountAndJumpSeqId(room)
  if room.group == ChatGroupType.GROUP_ALLIANCE_MOMENT or room.group == ChatGroupType.GROUP_FOLLOW_MOMENT then
    return
  end
  local unreadCount, unreadSeqId = room:getNewMsgNum()
  self.roomId = room.roomId
  self.unreadCount = unreadCount
  self.unreadSeqId = unreadSeqId
  if self.unreadCount <= 0 or self.unreadSeqId <= 0 then
    self.cacheUnreadJump = false
  else
    self.cacheUnreadJump = true
  end
  self.showUnreadJump = false
  self.view.middle:DeactiveUnreadJumpBubbleTips()
end

function UIChatCtrl:OnCreateChatItem(chataData)
  local roomId = chataData:getRoomId()
  if roomId ~= self.roomId then
    return
  end
  local seqId = chataData:getSeqId()
  DataCenter.ChatViewTipBubbleDataManager:OnCreateChatItem(roomId, seqId, chataData)
  local room = self.view:GetSelectedRoom()
  while room:GetAtSeqId() and seqId < room:GetAtSeqId() do
    room:ClearAtSeqId()
  end
  if self.showUnreadJump then
    if seqId <= self.unreadSeqId and not room:GetAtSeqId() then
      self.showUnreadJump = false
      self.view.middle:DeactiveUnreadJumpBubbleTips()
    end
    return
  end
  if not self.cacheUnreadJump then
    return
  end
  if seqId == self.unreadSeqId then
    self.cacheUnreadJump = false
  end
end

function UIChatCtrl:ShowUnreadCountAndJump()
  if self.cacheUnreadJump == true then
    self.cacheUnreadJump = false
    self.showUnreadJump = true
    local room = self.view:GetSelectedRoom()
    if room:GetAtSeqId() then
      self.view.middle:ActiveAtJumpBubbleTips(self.roomId, room:GetAtSeqId(), self.unreadSeqId, ChatTipType.At)
    else
      self.view.middle:ActiveUnreadJumpBubbleTips(self.roomId, self.unreadSeqId, self.unreadCount)
    end
  end
end

function UIChatCtrl:OnCustomKeyCodeEscape()
  if self.view then
    self.view:BlackWebView()
  else
    self:CloseSelf()
  end
end

return UIChatCtrl
