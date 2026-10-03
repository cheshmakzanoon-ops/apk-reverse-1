local BiuBiuPVPCancelMessage = BaseClass("BiuBiuPVPCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, sid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("sid", sid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local room = DataCenter.LWBiuBiuDataManager:GetRoom()
    room:RespCancel()
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc54")
  end
end

BiuBiuPVPCancelMessage.OnCreate = OnCreate
BiuBiuPVPCancelMessage.HandleMessage = HandleMessage
return BiuBiuPVPCancelMessage
