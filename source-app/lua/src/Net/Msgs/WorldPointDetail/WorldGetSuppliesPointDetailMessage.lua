local WorldGetSuppliesPointDetailMessage = BaseClass("WorldGetSuppliesPointDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, serverId, pointId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("pointId", pointId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldPointDetailManager:UpdateWorldSuppliesPointDetail(t)
  end
end

WorldGetSuppliesPointDetailMessage.OnCreate = OnCreate
WorldGetSuppliesPointDetailMessage.HandleMessage = HandleMessage
return WorldGetSuppliesPointDetailMessage
