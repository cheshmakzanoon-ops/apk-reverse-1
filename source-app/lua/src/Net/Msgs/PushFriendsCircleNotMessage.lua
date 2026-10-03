local PushFriendsCircleNotMessage = BaseClass("PushFriendsCircleNotMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowErrorCodeTips(t)
  end
end

PushFriendsCircleNotMessage.OnCreate = OnCreate
PushFriendsCircleNotMessage.HandleMessage = HandleMessage
return PushFriendsCircleNotMessage
