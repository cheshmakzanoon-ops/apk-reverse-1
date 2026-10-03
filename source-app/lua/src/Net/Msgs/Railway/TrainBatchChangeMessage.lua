local TrainBatchChangeMessage = BaseClass("TrainBatchChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TrainBatchChangeMessage:OnCreate(truckUuidList, refreshType)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", refreshType)
  local sendArray = SFSArray.New()
  for i, v in ipairs(truckUuidList) do
    sendArray:AddLong(v)
  end
  self.sfsObj:PutSFSArray("uuidList", sendArray)
end

function TrainBatchChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.BatchChangeTrainCallback)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.gold then
      LuaEntry.Player.gold = t.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if t.myTrainList then
      DataCenter.LWMyStationDataManager:OnTrainChangedList(t.myTrainList)
    end
  end
end

return TrainBatchChangeMessage
