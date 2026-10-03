local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRoomSendMsgCommand = BaseClass("ChatRoomSendMsgCommand", WebSocketBaseMessage)
local Localization = CS.GameEntry.Localization

local function getMsgExtra(post, media, senderLevel, extra)
  if post == nil and media == nil and senderLevel == nil then
    return nil
  end
  local tbl = {}
  tbl.post = post
  if not string.IsNullOrEmpty(media) then
    tbl.media = media
  end
  if senderLevel ~= nil then
    tbl.senderLevel = senderLevel
  end
  if extra then
    if extra.smallHeight then
      tbl.smallHeight = extra.smallHeight
    end
    if extra.smallWidth then
      tbl.smallWidth = extra.smallWidth
    end
    if extra.bigHeight then
      tbl.bigHeight = extra.bigHeight
    end
    if extra.bigWidth then
      tbl.bigWidth = extra.bigWidth
    end
    if extra.picVer then
      tbl.picVer = extra.picVer
    end
    if extra.isNormalMsg then
      tbl.isNormalMsg = extra.isNormalMsg
    end
    if extra.noticeUid then
      tbl.noticeUid = extra.noticeUid
    end
    if extra.atUids and not table.IsNullOrEmpty(extra.atUids) then
      tbl.atUids = extra.atUids
    end
    if extra.atType then
      tbl.atType = extra.atType
    end
    if extra.atPlayers and not table.IsNullOrEmpty(extra.atPlayers) then
      tbl.atPlayers = extra.atPlayers
    end
    if extra.atAll then
      tbl.atAll = extra.atAll
    end
    if extra.srcLang then
      tbl.srcLang = extra.srcLang
    end
  end
  return tbl
end

local function getChatData(chatData)
  local extraMsg = getMsgExtra(chatData.post, chatData.media, chatData.senderLevel, chatData.extra)
  local param = {
    roomId = chatData.roomId,
    msg = chatData.msg,
    sendTime = chatData.sendLocalTime,
    extra = extraMsg,
    reply = chatData.replyMsg,
    isProxy = chatData.isProxy or 1,
    group = chatData.group,
    timeline = chatData.timeline
  }
  return param
end

local function OnCreate(self, chatData)
  local t = getChatData(chatData)
  self.tableData = t
end

local function HandleMessage(self, serverData)
  if serverData ~= nil and serverData.result and serverData.result.code then
    local code = serverData.result.code
    if code == "at_notice_limit_times" then
      UIUtil.ShowTips(Localization:GetString("at_notice_limit_times", AtMaxTimes))
    elseif code == "at_notice_limit_number" then
      UIUtil.ShowTips(Localization:GetString("at_notice_limit_number", MAX_AT_PLAYERS))
    else
      local expireTime = 0
      if serverData.result.expireTime then
        expireTime = serverData.result.expireTime
      end
      local strExpireTime = UITimeManager:GetInstance():SecondToFmtString(expireTime)
      local strTips = Localization:GetString(serverData.result.code, strExpireTime)
      UIUtil.ShowTips(strTips)
      if serverData.result.roomId and serverData.result.extra and serverData.result.extra.picVer and serverData.result.extra.post then
        local roomId = serverData.result.roomId
        local post = serverData.result.extra.post
        if post == PostType.Chat_SendPhoto then
          local picVer = serverData.result.extra.picVer
          DataCenter.ChatSendPhotoManager:RemoveFakePhotoChatData(roomId, picVer, false)
        end
      end
    end
  end
  if serverData and serverData.result then
    local sender = serverData.result.sender
    local group = serverData.result.group
    local extra = serverData.result.extra
    if group == "notice" and sender == LuaEntry.Player.uid and extra.noticeUid then
      SFSNetwork.SendMessage(MsgDefines.AllianceNoticeCommentRecord, extra.noticeUid)
    end
    if sender == LuaEntry.Player.uid and extra and not table.IsNullOrEmpty(extra.atUids) and extra.atType then
      local rooms = ChatInterface.getAllRoomData()
      for _, v in pairs(rooms) do
        if v.group == extra.atType then
          v.atUsedTimes = v.atUsedTimes + 1
          Logger.LogInfo(string.format("Send At Message roomId = %s seqId = %s atUsedTimes = %s", tostring(v.roomId), tostring(serverData.result.seqId), tostring(v.atUsedTimes)))
          PostEventLog.Track("player_send_at", {
            chatemoji_emojiid = toInt(serverData.result.seqId),
            count = toInt(v.atUsedTimes),
            chat_channel = tostring(v.roomId)
          })
        end
      end
    end
  end
end

ChatRoomSendMsgCommand.OnCreate = OnCreate
ChatRoomSendMsgCommand.HandleMessage = HandleMessage
return ChatRoomSendMsgCommand
