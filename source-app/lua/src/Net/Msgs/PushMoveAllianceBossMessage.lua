local PushMoveAllianceBossMessage = BaseClass("PushMoveAllianceBossMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t == nil or t.errorCode == nil then
  else
    UIUtil.ShowTipsId(t.errorCode)
  end
end

PushMoveAllianceBossMessage.OnCreate = OnCreate
PushMoveAllianceBossMessage.HandleMessage = HandleMessage
return PushMoveAllianceBossMessage
