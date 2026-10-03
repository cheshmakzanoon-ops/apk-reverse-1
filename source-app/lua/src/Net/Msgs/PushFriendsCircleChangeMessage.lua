local PushFriendsCircleChange = BaseClass("PushFriendsCircleChange", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.PlayerInfoDataManager:SetPlayerFriendsCircleSetting(t)
  end
end

PushFriendsCircleChange.OnCreate = OnCreate
PushFriendsCircleChange.HandleMessage = HandleMessage
return PushFriendsCircleChange
