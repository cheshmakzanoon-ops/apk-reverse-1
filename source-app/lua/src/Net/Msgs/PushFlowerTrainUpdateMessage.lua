local PushFlowerTrainUpdateMessage = BaseClass("PushFlowerTrainUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushFlowerTrainUpdateMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushFlowerTrainUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FlowerTrainDataManager:UpdateSelfFlowerTrainData(t)
    EventManager:GetInstance():Broadcast(EventId.FlowerTrainSelfDataUpdate)
  end
end

return PushFlowerTrainUpdateMessage
