local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRoomAcceptinviteMessage = BaseClass("ChatRoomAcceptinviteMessage", WebSocketBaseMessage)

function ChatRoomAcceptinviteMessage:OnCreate(roomId, group, fromRoom, seqId)
  self.tableData = {
    roomId = roomId,
    group = group,
    fromRoom = fromRoom,
    seqId = seqId,
    version = "v2"
  }
end

function ChatRoomAcceptinviteMessage:HandleMessage(serverData)
  if not serverData.errorCode then
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(serverData.data.fromRoom)
    if roomData then
      local chatData = roomData:getChatDataBySeqId(serverData.data.seqId)
      if chatData then
        chatData:ChangeInviteState(InviteState.InviteAgree)
      end
    end
  else
    UIUtil.ShowErrorCodeTips(serverData)
  end
end

return ChatRoomAcceptinviteMessage
