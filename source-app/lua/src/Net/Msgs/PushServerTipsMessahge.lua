local PushServerTipsMessahge = BaseClass("PushServerTipsMessahge", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.tips then
    UIUtil.ShowTipsId(t.tips)
  end
end

PushServerTipsMessahge.OnCreate = OnCreate
PushServerTipsMessahge.HandleMessage = HandleMessage
return PushServerTipsMessahge
