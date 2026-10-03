local PveActGetRankMessage = BaseClass("PveActGetRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PveActGetRankMessage:OnCreate(actId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", actId)
end

function PveActGetRankMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.PveActManager:HandleGetRank(message)
end

return PveActGetRankMessage
