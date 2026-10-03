local ChatCacheMsgManager = BaseClass("ChatCacheMsgManager")
local rapidjson = require("rapidjson")

function ChatCacheMsgManager:__init()
  self.cacheDelMsgDic = {}
end

function ChatCacheMsgManager:Startup()
end

function ChatCacheMsgManager:GetDelMsgsByRoomId(roomId)
  return self.cacheDelMsgDic[roomId]
end

function ChatCacheMsgManager:GetEmojiSpriteAsset()
  if DataCenter.CacheData.emojiAsset then
    return DataCenter.CacheData.emojiAsset.asset
  end
end

function ChatCacheMsgManager:RemoveMsgByCache()
  if table.count(self.cacheDelMsgDic) == 0 then
    return
  end
  local room, chatData
  for roomid, seqIds in pairs(self.cacheDelMsgDic) do
    room = ChatInterface.getRoomData(roomid)
    if room then
      for i, seqId in pairs(seqIds) do
        chatData = room:getChatDataBySeqId(seqId)
        if chatData then
          room:removeChatData(chatData)
        end
      end
    end
  end
end

function ChatCacheMsgManager:AddDelMsg(serverData)
  if not (serverData and serverData.roomid) or not serverData.seqId then
    return
  end
  if self.cacheDelMsgDic[serverData.roomid] then
    table.insert(self.cacheDelMsgDic[serverData.roomid], serverData.seqId)
  else
    self.cacheDelMsgDic[serverData.roomid] = {}
    table.insert(self.cacheDelMsgDic[serverData.roomid], serverData.seqId)
  end
  local room = ChatInterface.getRoomData(serverData.roomid)
  if room then
    room:SetCacheDelSeqId(serverData.seqId)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UNREAD_UPDATE)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_DEL_MSG, serverData)
  elseif serverData.roomid and serverData.seqId then
    Logger.LogInfo("room is nil roomId : " .. serverData.roomid .. "seqId : " .. serverData.seqId)
  else
    Logger.LogError("AddDelMsg server data error !!")
  end
end

function ChatCacheMsgManager:AddBatchDelMsg(serverData)
  if not serverData or not serverData.roomid then
    return
  end
  if self.cacheDelMsgDic[serverData.roomid] == nil then
    self.cacheDelMsgDic[serverData.roomid] = {}
  end
  local delSeqIdsStr = serverData.seqIds
  local delSeqIds = rapidjson.decode(delSeqIdsStr)
  if delSeqIds == nil or #delSeqIds == 0 then
    return
  end
  for i, seqId in ipairs(delSeqIds) do
    table.insert(self.cacheDelMsgDic[serverData.roomid], seqId)
  end
  local room = ChatInterface.getRoomData(serverData.roomid)
  if room then
    for i, seqId in ipairs(delSeqIds) do
      room:SetCacheDelSeqId(seqId)
    end
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UNREAD_UPDATE)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_DEL_MSG, serverData)
  elseif serverData.roomid then
    Logger.LogInfo("AddBatchDelMsg room is nil roomId : " .. serverData.roomid)
  else
    Logger.LogError("AddBatchDelMsg server data error !!")
  end
end

function ChatCacheMsgManager:__delete()
  self.cacheDelMsgList = nil
end

return ChatCacheMsgManager
