local SeasonTowerStageRecordMessage = BaseClass("SeasonTowerStageRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonTowerStageRecordMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("stageId", param.stageId)
  self.sfsObj:PutUtfString("uid", param.uid)
end

function SeasonTowerStageRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.SeasonTowerStageRecord, t)
  end
end

return SeasonTowerStageRecordMessage
