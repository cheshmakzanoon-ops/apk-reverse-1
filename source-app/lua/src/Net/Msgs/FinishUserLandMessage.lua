local FinishUserLandMessage = BaseClass("FinishUserLandMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("landId", id)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode == nil then
    DataCenter.LandLockManager:FinishHandle(t)
  end
end

FinishUserLandMessage.OnCreate = OnCreate
FinishUserLandMessage.HandleMessage = HandleMessage
return FinishUserLandMessage
