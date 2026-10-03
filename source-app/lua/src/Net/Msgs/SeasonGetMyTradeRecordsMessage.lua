local SeasonGetMyTradeRecordsMessage = BaseClass("SeasonGetMyTradeRecordsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonGetMyTradeRecordsMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonGetMyTradeRecordsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HSRDataManager:HandleAllMyHistory(t)
  end
end

return SeasonGetMyTradeRecordsMessage
