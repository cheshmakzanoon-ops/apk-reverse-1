local LwRqStrongholdBankLogMessage = BaseClass("LwRqStrongholdBankLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwRqStrongholdBankLogMessage:OnCreate(pageId, logTypeCode, pageSize, strongholdId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("strongholdId", strongholdId)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("pageId", pageId)
  self.sfsObj:PutInt("pageSize", pageSize or 20)
  self.sfsObj:PutInt("logTypeCode", logTypeCode)
end

function LwRqStrongholdBankLogMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.StrongholdBankLogAdd, t)
end

function LwRqStrongholdBankLogMessage:GetTestData(pageId, logTypeCode, pageSize, strongholdId, serverId)
  pageSize = pageSize or 20
  local list = {}
  local max = math.random(0, 100) < 10 and math.random(0, pageSize) or pageSize
  for i = 1, max do
    local member = DataCenter.AllianceMemberDataManager:GetRandomMember()
    list[i] = {
      user = member,
      logTime = UITimeManager:GetInstance():GetServerTime() - math.random(1, 360000),
      logTypeCode = logTypeCode or math.random(1, 4),
      amount = math.random(100, 100000),
      depositDays = math.random(1, 7),
      finalAmount = math.random(1000, 10000)
    }
  end
  local t = {
    list = list,
    pageId = pageId or 1,
    pageSize = pageSize,
    strongholdId = strongholdId or 1,
    logTypeCode = logTypeCode or 0
  }
  return t
end

function LwRqStrongholdBankLogMessage:GetCityHistoryTestData(logTypeCode)
  local member = DataCenter.AllianceMemberDataManager:GetRandomMember()
  local data = {
    user = member,
    logTime = UITimeManager:GetInstance():GetServerTime() - math.random(1, 360000),
    logTypeCode = logTypeCode or math.random(1, 4),
    amount = math.random(100, 100000),
    depositDays = math.random(1, 7),
    finalAmount = math.random(1000, 10000)
  }
  return data
end

return LwRqStrongholdBankLogMessage
