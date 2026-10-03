local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetRoomLikeLogMessage = BaseClass("GetRoomLikeLogMessage", WebSocketBaseMessage)

local function OnCreate(self, roomId)
  local param = {roomId = roomId}
  self.tableData = param
end

local function HandleMessage(self, serverData)
  if serverData ~= nil then
    local infos = serverData.result.logInfo
    EventManager:GetInstance():Broadcast(EventId.GetRoomLikeLogUpdate, serverData.result)
  end
end

GetRoomLikeLogMessage.OnCreate = OnCreate
GetRoomLikeLogMessage.HandleMessage = HandleMessage
return GetRoomLikeLogMessage
