local EpidemicZoneActSignUpMessage = BaseClass("EpidemicZoneActSignUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group, role, battlePeriod)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutInt("role", role)
  self.sfsObj:PutInt("battlePeriod", battlePeriod)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleActivitySignUpMessage(t)
end

EpidemicZoneActSignUpMessage.OnCreate = OnCreate
EpidemicZoneActSignUpMessage.HandleMessage = HandleMessage
return EpidemicZoneActSignUpMessage
