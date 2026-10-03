local SoldierElevenStageMessage = BaseClass("SoldierElevenStageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SoldierElevenStageMessage:OnCreate(param)
  base.OnCreate(self)
end

function SoldierElevenStageMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.queue ~= nil then
      DataCenter.QueueDataManager:UpdateQueueData(t.queue)
    end
    if t.soldierElevenInfo then
      DataCenter.T11DataManager:UpdateT11LvData(t.soldierElevenInfo)
      EventManager:GetInstance():Broadcast(EventId.T11EnterBreakState)
    end
  end
end

return SoldierElevenStageMessage
