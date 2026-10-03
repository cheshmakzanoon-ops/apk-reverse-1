local PushStrongholdBankPointInfoMessage = BaseClass("PushStrongholdBankPointInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushStrongholdBankPointInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushStrongholdBankPointInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if not t or not t.strongholdId then
    return
  end
  t.timeStamp = UITimeManager:GetInstance():GetServerTime()
  local detail = DataCenter.WorldPointDetailManager:GetAllianceCityData(t.strongholdId)
  if detail and detail.bankDetail then
    detail.bankDetail.totalAmount = t.totalAmount
    detail.bankDetail.robAmount = t.robAmount
    detail.bankDetail.robEndTime = t.robEndTime
    detail.bankDetail.robStage = t.robStage
  end
  local pointInfo
  if SceneUtils.GetIsInWorld() then
    if t.pointId and t.serverId then
      pointInfo = CS.SceneManager.World:GetPointInfo(t.pointId, t.serverId)
    else
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(t.strongholdId, t.serverId)
      pointInfo = cityTemplate and CS.SceneManager.World:GetPointInfo(cityTemplate:GetPointId())
    end
  end
  if pointInfo then
    local cityInfo = pointInfo.StrongholdInfo
    if not IsNull(cityInfo) and not IsNull(cityInfo.BankRobInfo) then
      cityInfo.BankRobInfo.TotalAmount = t.totalAmount
      cityInfo.BankRobInfo.RobAmount = t.robAmount
      cityInfo.BankRobInfo.RobEndTime = t.robEndTime
      cityInfo.BankRobInfo.RobStage = t.robStage
    end
  end
  EventManager:GetInstance():Broadcast(EventId.PushStrongholdBankPointInfo, t)
end

function PushStrongholdBankPointInfoMessage:GetTestData()
  local t = {}
  t.errorCode = 0
  t.strongholdId = 1001
  t.totalAmount = 1000000
  t.robAmount = 50000
  t.robEndTime = UITimeManager:GetInstance():GetServerTime() + 3600
  t.robStage = 1
  return t
end

return PushStrongholdBankPointInfoMessage
