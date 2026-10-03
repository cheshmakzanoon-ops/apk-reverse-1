local PushGhostReconBroadcastRewardMessage = BaseClass("PushGhostReconBroadcastRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ActGhostreconManager:PushGhostReconBroadcastRewardHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

PushGhostReconBroadcastRewardMessage.OnCreate = OnCreate
PushGhostReconBroadcastRewardMessage.HandleMessage = HandleMessage
return PushGhostReconBroadcastRewardMessage
