local EpidemicZoneActPlayerListMessage = BaseClass("EpidemicZoneActPlayerListMessage", SFSBaseMessage)
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
  DataCenter.ActEpidemicZoneManager:HandleActivityPlayerListMessage(t)
end

EpidemicZoneActPlayerListMessage.OnCreate = OnCreate
EpidemicZoneActPlayerListMessage.HandleMessage = HandleMessage
return EpidemicZoneActPlayerListMessage
