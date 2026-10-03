local PushGhostReconBeKickedMessage = BaseClass("PushGhostReconBeKickedMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ActGhostreconManager:PushGhostReconBeKickedHandler(t)
      DataCenter.ActGhostreconAllianceManager:PushGhostReconBeKickedHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

PushGhostReconBeKickedMessage.OnCreate = OnCreate
PushGhostReconBeKickedMessage.HandleMessage = HandleMessage
return PushGhostReconBeKickedMessage
