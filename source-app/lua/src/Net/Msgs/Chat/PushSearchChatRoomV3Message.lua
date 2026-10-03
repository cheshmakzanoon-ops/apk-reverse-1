local PushSearchChatRoomV3Message = BaseClass("PushSearchChatRoomV3Message", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, data)
  base.HandleMessage(self, data)
  local errCode = data.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(data)
    return
  end
  DataCenter.ChatPrivateSearchDataManager:TrySetSearchResultV3(data.name, data.page, data.roomInfos)
  EventManager:GetInstance():Broadcast(EventId.ChatPrivateSearchResultMsgBack)
end

PushSearchChatRoomV3Message.OnCreate = OnCreate
PushSearchChatRoomV3Message.HandleMessage = HandleMessage
return PushSearchChatRoomV3Message
