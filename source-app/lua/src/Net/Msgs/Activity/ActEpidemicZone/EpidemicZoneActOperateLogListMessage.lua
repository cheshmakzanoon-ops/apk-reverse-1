local EpidemicZoneActOperateLogListMessage = BaseClass("EpidemicZoneActOperateLogListMessage", SFSBaseMessage)
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
  DataCenter.ActEpidemicZoneManager:HandleActivityOperateLogListMessage(t)
end

EpidemicZoneActOperateLogListMessage.OnCreate = OnCreate
EpidemicZoneActOperateLogListMessage.HandleMessage = HandleMessage
return EpidemicZoneActOperateLogListMessage
