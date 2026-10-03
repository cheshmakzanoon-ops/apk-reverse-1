local GhostreconGetTaskListMessage = BaseClass("GhostreconGetTaskListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ActGhostreconManager:GhostreconGetTaskListHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GhostreconGetTaskListMessage.OnCreate = OnCreate
GhostreconGetTaskListMessage.HandleMessage = HandleMessage
return GhostreconGetTaskListMessage
