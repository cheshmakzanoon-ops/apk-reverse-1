local BiuBiuPVPJoinKickMessage = BaseClass("BiuBiuPVPJoinKickMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, sid, uid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("sid", sid)
  self.sfsObj:PutUtfString("uid", uid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local room = DataCenter.LWBiuBiuDataManager:GetRoom()
    room:RespJoinKick(t)
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc44")
  end
end

BiuBiuPVPJoinKickMessage.OnCreate = OnCreate
BiuBiuPVPJoinKickMessage.HandleMessage = HandleMessage
return BiuBiuPVPJoinKickMessage
