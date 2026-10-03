local UIAllianceStarMainCtrl = BaseClass("UIAllianceStarMainCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceStarMain)
end

local function SendMessage(self, msg, isProxy, postType, extraData)
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
  local isSendEmoji = extraData and extraData.isSendEmoji or false
  msg = ChatInterface.CheckMessage(msg)
  local str = ChatInterface.GetOldEmojiStr(msg)
  if not string.IsNullOrEmpty(str) then
    isSendEmoji = true
  end
  local cmdTbl = {
    roomId = currRoom.roomId,
    msg = msg,
    isProxy = isProxy
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
      msg = replyMsg.msg
    }
  end
  local userInfo = currRoom:getPrivateOtherMember()
  if currRoom.group == ChatGroupType.GROUP_TMPRoom then
    if not userInfo then
      return
    end
    cmdTbl.toUid = userInfo.uid
  end
  ChatManager2:GetInstance():SyncMessageToServer(cmdTbl, cmdTbl.roomId)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, cmdTbl)
  EventManager:GetInstance():Broadcast(EventId.SetReplyChatMsg, nil)
  if cmdTbl.msg and ChatManager2:GetInstance():IsStrEmoji(cmdTbl.msg) or ChatManager2:GetInstance():IsSticker(postType) then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD)
  end
end

local function CheckIsEmojiFormatMsg(self, msg)
  if string.IsNullOrEmpty(msg) then
    return false
  end
  if string.startswith(msg, "<lwEmoji:") and string.endswith(msg, ":>") then
    return true
  end
  return false
end

UIAllianceStarMainCtrl.CloseSelf = CloseSelf
UIAllianceStarMainCtrl.SendMessage = SendMessage
UIAllianceStarMainCtrl.CheckIsEmojiFormatMsg = CheckIsEmojiFormatMsg
return UIAllianceStarMainCtrl
