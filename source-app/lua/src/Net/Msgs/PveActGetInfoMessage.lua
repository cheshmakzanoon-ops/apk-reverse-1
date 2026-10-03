local PveActGetInfoMessage = BaseClass("PveActGetInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PveActGetInfoMessage:OnCreate(actId, pve)
  base.OnCreate(self)
  if actId then
    self.sfsObj:PutInt("activityId", actId)
  end
  if pve then
    self.sfsObj:PutInt("level", pve)
  end
end

function PveActGetInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.PveActManager:HandleGetInfo(message)
end

return PveActGetInfoMessage
