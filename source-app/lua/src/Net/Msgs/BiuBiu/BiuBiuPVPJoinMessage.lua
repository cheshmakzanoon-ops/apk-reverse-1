local BiuBiuPVPJoinMessage = BaseClass("BiuBiuPVPJoinMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, sid, version)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("sid", sid)
  self.sfsObj:PutUtfString("version", version)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local room = DataCenter.LWBiuBiuDataManager:GetRoom()
    room:Join(t)
  end
end

BiuBiuPVPJoinMessage.OnCreate = OnCreate
BiuBiuPVPJoinMessage.HandleMessage = HandleMessage
return BiuBiuPVPJoinMessage
