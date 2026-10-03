local UILWSingleMomentDetailCtrl = BaseClass("UILWSingleMomentDetailCtrl", UIBaseCtrl)
local rapidjson = require("rapidjson")

function UILWSingleMomentDetailCtrl:CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWSingleMomentDetailView)
end

function UILWSingleMomentDetailCtrl:CheckIsEmojiFormatMsg(msg)
  if string.IsNullOrEmpty(msg) then
    return false
  end
  if string.startswith(msg, "<lwEmoji:") and string.endswith(msg, ":>") then
    return true
  end
  return false
end

function UILWSingleMomentDetailCtrl:GetWindName()
  return UIWindowNames.UILWSingleMomentDetailView
end

function UILWSingleMomentDetailCtrl:SendMessage(msg, isProxy, postType, extraData)
  if not msg or string.IsNullOrEmpty(string.trim(msg)) then
    return
  end
  local currRoom = self.view:GetSelectedRoom()
  if not currRoom then
    UIUtil.ShowTipsId("335392")
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
    cmdTbl.extra.post = PostType.Chat_Moment
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
    cmdTbl.reply = rapidjson.encode(cmdTbl.reply)
  end
  ChatManager2:GetInstance():SyncMessageToServer(cmdTbl, cmdTbl.roomId)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, cmdTbl)
  EventManager:GetInstance():Broadcast(EventId.SetReplyChatMsg, nil)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD)
end

return UILWSingleMomentDetailCtrl
