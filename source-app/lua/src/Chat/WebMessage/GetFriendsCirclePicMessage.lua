local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetFriendsCirclePicMessage = BaseClass("GetFriendsCirclePicMessage", WebSocketBaseMessage)

local function OnCreate(self, friendsUid)
  local param = {friendsUid = friendsUid}
  self.tableData = param
end

local function HandleMessage(self, serverData)
  local chatData
  if serverData ~= nil and serverData.result then
    local uid = serverData.result.friendsUid
    local picInfo = serverData.result.picVerInfo
    local param = {}
    param.uid = uid
    param.picInfo = picInfo
    EventManager:GetInstance():Broadcast(EventId.GetPlayFriendsCirclePicData, param)
  end
end

GetFriendsCirclePicMessage.OnCreate = OnCreate
GetFriendsCirclePicMessage.HandleMessage = HandleMessage
return GetFriendsCirclePicMessage
