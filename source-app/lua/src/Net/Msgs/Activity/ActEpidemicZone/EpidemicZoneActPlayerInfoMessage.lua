local EpidemicZoneActPlayerInfoMessage = BaseClass("EpidemicZoneActPlayerInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, group)
  base.OnCreate(self)
  self.sfsObj:PutInt("group", group)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleActivityPlayerInfoMessage(t)
end

EpidemicZoneActPlayerInfoMessage.OnCreate = OnCreate
EpidemicZoneActPlayerInfoMessage.HandleMessage = HandleMessage
return EpidemicZoneActPlayerInfoMessage
