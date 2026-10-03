local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRoomUpCommand = BaseClass("ChatRoomUpCommand", WebSocketBaseMessage)
local Localization = CS.GameEntry.Localization

local function getMsgExtra(post, media)
  if post == nil and media == nil then
    return nil
  end
  local tbl = {}
  tbl.post = post
  if not string.IsNullOrEmpty(media) then
    tbl.media = media
  end
  return tbl
end

local function getChatData(chatData)
  local extraMsg = getMsgExtra(chatData.post, chatData.media)
  local param = {
    roomId = chatData.roomId,
    msgSeq = chatData.msgSeq,
    sendTime = chatData.sendLocalTime,
    extra = extraMsg,
    interactLike = chatData.interactLike,
    interactDislike = chatData.interactDislike,
    emoji = chatData.emoji
  }
  return param
end

local function OnCreate(self, chatData)
  local t = getChatData(chatData)
  self.tableData = t
end

local function HandleMessage(self, serverData)
  if serverData ~= nil and serverData.result then
    local expireTime = 0
    if serverData.result.expireTime then
      expireTime = serverData.result.expireTime
    end
    if serverData.result and (not serverData.code or serverData.code ~= "E000000") then
      local chatData = ChatManager2:GetInstance().Room:CreateChatMessage()
      chatData:onParseServerData(serverData.result)
      ChatManager2:GetInstance().Room:UpdateChatData(chatData)
      chatData = ChatManager2:GetInstance().Room:GetChat(serverData.result.roomId, serverData.result.seqId)
      DataCenter.ChatFriendCirclePhotoChatDataSaveManager:OnGetNewChatData(serverData.result)
      EventManager:GetInstance():Broadcast(EventId.ChatUpSucceed, chatData)
      DataCenter.ActEasterEggManager:SendEggChatThumbsUp_Comment(chatData)
    end
    if serverData.result.code then
      local strExpireTime = UITimeManager:GetInstance():SecondToFmtString(expireTime)
      local strTips = Localization:GetString(serverData.result.code, strExpireTime)
      UIUtil.ShowTips(strTips)
    end
  end
end

ChatRoomUpCommand.OnCreate = OnCreate
ChatRoomUpCommand.HandleMessage = HandleMessage
return ChatRoomUpCommand
