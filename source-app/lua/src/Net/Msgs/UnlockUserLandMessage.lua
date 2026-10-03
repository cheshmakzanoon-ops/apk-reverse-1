local UnlockUserLandMessage = BaseClass("UnlockUserLandMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("landId", id)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTips(Localization:GetString(t.errorCode))
  else
    DataCenter.LandLockManager:UnlockHandle(t)
  end
end

UnlockUserLandMessage.OnCreate = OnCreate
UnlockUserLandMessage.HandleMessage = HandleMessage
return UnlockUserLandMessage
