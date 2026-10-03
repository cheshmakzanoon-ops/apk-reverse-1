local BiuBiuPVPReadyMessage = BaseClass("BiuBiuPVPReadyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, sid, latencies)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("sid", sid)
  self.sfsObj:PutUtfString("latencies", latencies)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  room:RespReady(t, errCode)
end

BiuBiuPVPReadyMessage.OnCreate = OnCreate
BiuBiuPVPReadyMessage.HandleMessage = HandleMessage
return BiuBiuPVPReadyMessage
