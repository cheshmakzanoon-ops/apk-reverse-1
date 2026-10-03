local GhostReconSetAutoStart = BaseClass("GhostReconSetAutoStart", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, autoStart)
  base.OnCreate(self)
  self.sfsObj:PutInt("autoStart", autoStart)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.ActGhostreconManager:GhostReconSetAutoStartHandler(t.autoStart)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GhostReconSetAutoStart.OnCreate = OnCreate
GhostReconSetAutoStart.HandleMessage = HandleMessage
return GhostReconSetAutoStart
