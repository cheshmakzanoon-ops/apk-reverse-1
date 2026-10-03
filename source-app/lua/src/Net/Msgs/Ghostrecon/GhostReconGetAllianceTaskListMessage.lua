local GhostReconGetAllianceTaskListMessage = BaseClass("GhostReconGetAllianceTaskListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ActGhostreconAllianceManager:GhostReconGetAllianceTaskList(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GhostReconGetAllianceTaskListMessage.OnCreate = OnCreate
GhostReconGetAllianceTaskListMessage.HandleMessage = HandleMessage
return GhostReconGetAllianceTaskListMessage
