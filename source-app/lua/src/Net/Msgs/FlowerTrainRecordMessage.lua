local FlowerTrainRecordMessage = BaseClass("FlowerTrainRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FlowerTrainRecordMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", param.type)
  self.sfsObj:PutInt("start", param.start)
  self.sfsObj:PutInt("end", param["end"])
  self.sfsObj:PutUtfString("trainUuid", tostring(param.trainUuid))
end

function FlowerTrainRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.UIFlowerTrain_RecordList, t)
  end
end

return FlowerTrainRecordMessage
