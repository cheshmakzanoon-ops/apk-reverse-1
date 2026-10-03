local LWUIActEasterEggChatCtrl = BaseClass("LWUIActEasterEggChatCtrl", UIBaseCtrl)
local M = LWUIActEasterEggChatCtrl
local Localization = CS.GameEntry.Localization

function M:__init()
end

function M:__delete()
end

function M:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActEasterEggChat, {anim = true, playEffect = false})
end

function M:SendMessage(msg, isProxy, postType, extraData)
  if not msg or string.IsNullOrEmpty(string.trim(msg)) then
    return
  end
  local currRoom = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  if not currRoom then
    UIUtil.ShowTipsId("335392")
    return
  end
  msg = ChatInterface.CheckMessage(msg)
  local cmdTbl = {
    roomId = currRoom.roomId,
    msg = msg,
    isProxy = isProxy
  }
  cmdTbl.extra = cmdTbl.extra or {}
  cmdTbl.extra.post = postType
  cmdTbl.extra.isNormalMsg = true
  cmdTbl.extra.eggUuid = extraData.eggUuid
  if extraData.answer then
    cmdTbl.extra.answer = extraData.answer
  end
  cmdTbl.extra.anonymousHead = extraData.anonymousHead
  local finalName = ""
  local replyMsg = currRoom:GetCacheData().replyMsg or nil
  if replyMsg then
    local replySender = ChatInterface.getUserData(replyMsg.senderUid)
    local anonymousData = replyMsg.extra
    if anonymousData == nil then
      Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148chatData\230\178\161\230\156\137extra")
      return
    end
    if anonymousData.anonymousHead == nil then
      Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148chatData\231\154\132extra \228\184\173\230\178\161\230\156\137 anonymousHead")
      return
    end
    local curAnonymousInfo = string.split(anonymousData.anonymousHead, ";")
    local isAnonymous = tonumber(curAnonymousInfo[3]) == 0
    if isAnonymous then
      local lastestAnonymousHead = replySender.curAnonymousHead or anonymousData.anonymousHead
      curAnonymousInfo = string.split(lastestAnonymousHead, ";")
      finalName = curAnonymousInfo[1]
    else
      finalName = replySender.userName
    end
    cmdTbl.reply = {
      seqId = replyMsg.seqId,
      uid = replyMsg.senderUid,
      userName = finalName,
      abbr = replySender and replySender.abbr or "",
      msg = replyMsg.msg,
      isAnonymous = isAnonymous
    }
    cmdTbl.extra.opType = ActEasterEggChatOpType.ReplayComment
    cmdTbl.extra.otherUid = replyMsg.senderUid
  else
    cmdTbl.extra.opType = ActEasterEggChatOpType.ReplayPost
    cmdTbl.extra.otherUid = extraData.posterUuid
  end
  ChatManager2:GetInstance():SendEasterChatMsg(cmdTbl)
end

function M:CheckIsEmojiFormatMsg(msg)
  if string.IsNullOrEmpty(msg) then
    return false
  end
  if string.startswith(msg, "<lwEmoji:") and string.endswith(msg, ":>") then
    return true
  end
  return false
end

return M
