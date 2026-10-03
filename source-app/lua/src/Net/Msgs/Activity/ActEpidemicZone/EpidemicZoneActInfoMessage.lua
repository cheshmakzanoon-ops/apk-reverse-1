local EpidemicZoneActInfoMessage = BaseClass("EpidemicZoneActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleActivityInfoMessage(t)
end

EpidemicZoneActInfoMessage.OnCreate = OnCreate
EpidemicZoneActInfoMessage.HandleMessage = HandleMessage
return EpidemicZoneActInfoMessage
