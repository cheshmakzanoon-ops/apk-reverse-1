local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local VoiceUpdateRoomInfoMessage = BaseClass("VoiceUpdateRoomInfoMessage", WebSocketBaseMessage)

function VoiceUpdateRoomInfoMessage:OnCreate(roomId, voiceRoomId, currentPlayerInfo)
  self.tableData = {
    roomId = roomId,
    voiceRoomId = voiceRoomId,
    currentPlayerInfo = currentPlayerInfo
  }
end

function VoiceUpdateRoomInfoMessage:HandleMessage(serverData)
  if not serverData then
    return
  end
  local voiceMgr = ChatManager2:GetInstance().Voice
  if voiceMgr and voiceMgr.OnVoiceUpdateRoomInfoResult then
    voiceMgr:OnVoiceUpdateRoomInfoResult(serverData.result)
  end
end

return VoiceUpdateRoomInfoMessage
