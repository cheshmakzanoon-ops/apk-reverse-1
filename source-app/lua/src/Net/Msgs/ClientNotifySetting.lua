local ClientNotifySetting = BaseClass("ClientNotifySetting", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, isNotifyOpen)
  base.OnCreate(self)
  if isNotifyOpen then
    self.sfsObj:PutInt("notify", 0)
  else
    self.sfsObj:PutInt("notify", 1)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

ClientNotifySetting.OnCreate = OnCreate
ClientNotifySetting.HandleMessage = HandleMessage
return ClientNotifySetting
