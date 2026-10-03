local PushGhostReconDayRefreshMessage = BaseClass("PushGhostReconDayRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ActGhostreconManager:PushGhostReconDayRefreshHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

PushGhostReconDayRefreshMessage.OnCreate = OnCreate
PushGhostReconDayRefreshMessage.HandleMessage = HandleMessage
return PushGhostReconDayRefreshMessage
