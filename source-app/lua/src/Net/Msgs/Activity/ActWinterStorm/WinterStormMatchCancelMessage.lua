local WinterStormMatchCancelMessage = BaseClass("WinterStormMatchCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, reason)
  base.OnCreate(self)
  self.sfsObj:PutInt("reason", reason)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActWinterStormManager:HandleMatchCancel(t)
  end
end

WinterStormMatchCancelMessage.OnCreate = OnCreate
WinterStormMatchCancelMessage.HandleMessage = HandleMessage
return WinterStormMatchCancelMessage
