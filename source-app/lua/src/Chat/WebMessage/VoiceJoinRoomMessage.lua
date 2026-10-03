local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local VoiceJoinRoomMessage = BaseClass("VoiceJoinRoomMessage", WebSocketBaseMessage)

function VoiceJoinRoomMessage:OnCreate(roomId, agreeVoiceProtocol)
  self.tableData = {roomId = roomId}
  if agreeVoiceProtocol ~= nil and agreeVoiceProtocol == true then
    self.tableData.agreeVoiceProtocol = agreeVoiceProtocol
  end
end

function VoiceJoinRoomMessage:HandleMessage(serverData)
  if not serverData then
    return
  end
  local voiceMgr = ChatManager2:GetInstance().Voice
  if voiceMgr and voiceMgr.OnVoiceJoinRoomResult then
    voiceMgr:OnVoiceJoinRoomResult(serverData.result)
  end
end

return VoiceJoinRoomMessage
