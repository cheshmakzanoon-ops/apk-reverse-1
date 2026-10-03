local SearchChatRoomV3Message = BaseClass("SearchChatRoomV3Message", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, name, page)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("name", name)
  self.sfsObj:PutInt("page", page)
end

local function HandleMessage(self, msg)
  base.HandleMessage(self, msg)
  local errCode = msg.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(msg)
    EventManager:GetInstance():Broadcast(EventId.ChatPrivateSearchResultMsgBack)
    return
  end
  local cdTime = msg.cdTime
  if cdTime ~= nil then
    DataCenter.ChatPrivateSearchDataManager:SetNextCanSearchTime(cdTime)
  end
end

SearchChatRoomV3Message.OnCreate = OnCreate
SearchChatRoomV3Message.HandleMessage = HandleMessage
return SearchChatRoomV3Message
