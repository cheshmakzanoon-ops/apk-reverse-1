local FlowerTrainAllianceMessage = BaseClass("FlowerTrainAllianceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FlowerTrainAllianceMessage:OnCreate(param)
  base.OnCreate(self)
end

function FlowerTrainAllianceMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.UIFlowerTrain_ShowAllianceTrainList, t.trainArr)
  end
end

return FlowerTrainAllianceMessage
