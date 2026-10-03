local FlowerTrainRankPraiseMessage = BaseClass("FlowerTrainRankPraiseMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FlowerTrainRankPraiseMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutLong("otherUid", param.otherUid)
end

function FlowerTrainRankPraiseMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.UIFlowerTrain_RankPraise, t)
  end
end

return FlowerTrainRankPraiseMessage
