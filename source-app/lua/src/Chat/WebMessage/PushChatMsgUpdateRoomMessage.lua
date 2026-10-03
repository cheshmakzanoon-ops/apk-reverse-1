local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushChatMsgUpdateRoomMessage = BaseClass("PushChatMsgUpdateRoomMessage", WebSocketBaseMessage)

local function OnCreate(self, roomId, seqId, clientUpdateExtra)
end

local function HandleMessage(self, serverData)
  local chatData
  if serverData ~= nil and serverData.data then
    local room = ChatInterface.getRoomData(serverData.data.roomId)
    if room == nil then
      return
    end
    chatData = room:getChatDataBySeqId(serverData.data.seqId)
    if chatData then
      local redPackgeLikeNumChange = false
      if chatData.post == PostType.RedPackge_New then
        local oldReceiveCount = DataCenter.RedPacketManager:GetReceiveCountByChatData(chatData)
        local newReceiveCount = DataCenter.RedPacketManager:GetReceiveCountByChatData(serverData.data)
        if oldReceiveCount > newReceiveCount then
          return
        end
        local oldLikeNum = DataCenter.RedPacketManager:GetLikeNumByChatData(chatData)
        local newLikeNum = DataCenter.RedPacketManager:GetLikeNumByChatData(serverData.data)
        if oldLikeNum < newLikeNum then
          redPackgeLikeNumChange = true
        end
      end
      chatData:onParseServerData(serverData.data)
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_ONEMSG_UPDATA, chatData)
      if chatData.post == PostType.FIREWORK_GIFT_REWARD or chatData.post == PostType.S0_ALLIANCE_BOSS_GIFT_REWARD then
        EventManager:GetInstance():Broadcast(EventId.FireworkUpdateBubbleState)
      end
    end
  end
end

PushChatMsgUpdateRoomMessage.OnCreate = OnCreate
PushChatMsgUpdateRoomMessage.HandleMessage = HandleMessage
return PushChatMsgUpdateRoomMessage
