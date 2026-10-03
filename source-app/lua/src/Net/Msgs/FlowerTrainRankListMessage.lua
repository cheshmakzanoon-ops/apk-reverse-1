local FlowerTrainRankListMessage = BaseClass("FlowerTrainRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FlowerTrainRankListMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function FlowerTrainRankListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.UIFlowerTrain_RankList, t)
  end
end

return FlowerTrainRankListMessage
