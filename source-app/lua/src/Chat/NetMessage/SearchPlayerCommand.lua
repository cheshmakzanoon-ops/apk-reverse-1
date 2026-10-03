local SearchPlayerCommand = BaseClass("SearchPlayerCommand", SFSBaseMessage)

local function OnCreate(self, param)
  self.sfsObj:PutUtfString("key", param.searchKey)
  self.sfsObj:PutInt("page", param.page)
end

local function HandleMessage(self, msg)
  local list = msg.list
  if list and 0 < #list then
    ChatManager2:GetInstance().User:__onSearchUserInfos(list)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_INVITE_SEARCH_PLAYER_RESULT, list)
  else
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_INVITE_SEARCH_PLAYER_RESULT, nil)
  end
end

SearchPlayerCommand.OnCreate = OnCreate
SearchPlayerCommand.HandleMessage = HandleMessage
return SearchPlayerCommand
