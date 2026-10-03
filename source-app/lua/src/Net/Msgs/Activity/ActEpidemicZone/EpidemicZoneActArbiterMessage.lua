local EpidemicZoneActArbiterMessage = BaseClass("EpidemicZoneActArbiterMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
  self.sfsObj:PutUtfString("targetUid", targetUid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleActivityArbiterMessage(t)
end

EpidemicZoneActArbiterMessage.OnCreate = OnCreate
EpidemicZoneActArbiterMessage.HandleMessage = HandleMessage
return EpidemicZoneActArbiterMessage
