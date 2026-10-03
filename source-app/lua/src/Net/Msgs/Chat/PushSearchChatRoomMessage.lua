local PushSearchChatRoomMessage = BaseClass("PushSearchChatRoomMessage", SFSBaseMessage)
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
  DataCenter.ChatPrivateSearchDataManager:TrySetSearchResult(data.name, data.page, data.roomIds)
  EventManager:GetInstance():Broadcast(EventId.ChatPrivateSearchResultMsgBack)
end

PushSearchChatRoomMessage.OnCreate = OnCreate
PushSearchChatRoomMessage.HandleMessage = HandleMessage
return PushSearchChatRoomMessage
