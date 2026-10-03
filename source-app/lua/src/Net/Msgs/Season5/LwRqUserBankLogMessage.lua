local LwRqUserBankLogMessage = BaseClass("LwRqUserBankLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwRqUserBankLogMessage:OnCreate(pageId, logTypeCode, pageSize)
  base.OnCreate(self)
  self.sfsObj:PutInt("pageId", pageId)
  self.sfsObj:PutInt("pageSize", pageSize or 20)
  self.sfsObj:PutInt("logTypeCode", logTypeCode)
end

function LwRqUserBankLogMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.typeCountInfo then
    for i, v in pairs(t.typeCountInfo) do
      t.typeCountInfo[tonumber(i) or 0] = v
    end
  end
  EventManager:GetInstance():Broadcast(EventId.BankHistoryAdd, t)
end

function LwRqUserBankLogMessage:GetTestData(pageId, logTypeCode, pageSize)
  pageSize = pageSize or 20
  local list = {}
  local max = math.random(0, 100) < 10 and math.random(0, pageSize) or pageSize
  for i = 1, max do
    local data = {
      logTime = UITimeManager:GetInstance():GetServerTime() - math.random(1, 360000),
      logTypeCode = logTypeCode or math.random(1, 4),
      amount = math.random(100, 100000),
      depositDays = math.random(1, 7),
      finalAmount = math.random(1000, 10000)
    }
    list[i] = data
  end
  local t = {
    list = list,
    pageId = pageId or 1,
    pageSize = pageSize,
    logTypeCode = logTypeCode or 0
  }
  return t
end

return LwRqUserBankLogMessage
