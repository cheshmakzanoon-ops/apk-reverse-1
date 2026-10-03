local PushGhostReconAllianceSingleMessage = BaseClass("PushGhostReconAllianceSingleMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ActGhostreconAllianceManager:PushGhostReconAllianceSingleHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

PushGhostReconAllianceSingleMessage.OnCreate = OnCreate
PushGhostReconAllianceSingleMessage.HandleMessage = HandleMessage
return PushGhostReconAllianceSingleMessage
