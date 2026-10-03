local EpidemicZoneActModifyTeamStateMessage = BaseClass("EpidemicZoneActModifyTeamStateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, open)
  base.OnCreate(self)
  self.sfsObj:PutBool("open", open)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleActivityModifyTeamStateMessage(t)
end

EpidemicZoneActModifyTeamStateMessage.OnCreate = OnCreate
EpidemicZoneActModifyTeamStateMessage.HandleMessage = HandleMessage
return EpidemicZoneActModifyTeamStateMessage
