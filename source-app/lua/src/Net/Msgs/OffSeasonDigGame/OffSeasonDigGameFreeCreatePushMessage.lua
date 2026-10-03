local OffSeasonDigGameFreeCreatePushMessage = BaseClass("OffSeasonDigGameFreeCreatePushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.OffSeasonDigActivityInfo)
end

OffSeasonDigGameFreeCreatePushMessage.OnCreate = OnCreate
OffSeasonDigGameFreeCreatePushMessage.HandleMessage = HandleMessage
return OffSeasonDigGameFreeCreatePushMessage
