local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local VoiceLeaveRoomMessage = BaseClass("VoiceLeaveRoomMessage", WebSocketBaseMessage)

function VoiceLeaveRoomMessage:OnCreate(roomId)
  self.tableData = {roomId = roomId}
end

function VoiceLeaveRoomMessage:HandleMessage(serverData)
  if not serverData then
    return
  end
  local voiceMgr = ChatManager2:GetInstance().Voice
  if voiceMgr and voiceMgr.OnVoiceLeaveRoomResult then
    voiceMgr:OnVoiceLeaveRoomResult(serverData.result)
  end
end

return VoiceLeaveRoomMessage
