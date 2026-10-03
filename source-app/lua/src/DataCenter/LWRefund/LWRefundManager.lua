local LWRefundManager = BaseClass("LWRefundManager")
local LWRefundFaqData = require("DataCenter.LWRefund.LWRefundFaqData")
local LWRefundPayData = require("DataCenter.LWRefund.LWRefundPayData")
local defaultAreaIndex = "-1"

function LWRefundManager:__init()
  self.CurRefundListPfType = RefundListPfType.Google
  self.refundBlackStatus = false
  self.faqData = nil
  self.payDataList = {}
  self.refundLimitDays = {}
end

function LWRefundManager:__delete()
  self.CurRefundListPfType = nil
  self.refundBlackStatus = nil
  self.faqData = nil
  self.payDataList = nil
  self.refundLimitDays = nil
end

function LWRefundManager:InitData(message)
  if message and message.refundBlackStatus ~= nil then
    self.refundBlackStatus = message.refundBlackStatus
  else
  end
end

function LWRefundManager:GetFAQMap()
  if not self.faqData then
    self.faqData = LWRefundFaqData.New()
  end
  return self.faqData:GetFAQMap()
end

function LWRefundManager:RequestPayRefundList()
  SFSNetwork.SendMessage(MsgDefines.PayRefundList, self.CurRefundListPfType)
end

function LWRefundManager:OnReceivePayRefundList(message)
  if message == nil then
    return
  end
  local payDataList = {}
  local refundList = message.payLogs
  for k, v in pairs(refundList) do
    local payData = LWRefundPayData.New()
    payData:ParsePayData(v)
    table.insert(payDataList, payData)
  end
  local canRefundOrderList = {}
  local cannotRefundOrderList = {}
  for k, v in pairs(payDataList) do
    if v and v.cannotReasonType == CannotRefundReason.NONE then
      table.insert(canRefundOrderList, v)
    else
      table.insert(cannotRefundOrderList, v)
    end
  end
  self.payDataList = {}
  table.sort(canRefundOrderList, function(a, b)
    return tonumber(a.time) > tonumber(b.time)
  end)
  table.sort(cannotRefundOrderList, function(a, b)
    return tonumber(a.time) > tonumber(b.time)
  end)
  self.payDataList = table.mergeArray(canRefundOrderList, cannotRefundOrderList)
  EventManager:GetInstance():Broadcast(EventId.LWRefundRecPayList)
end

function LWRefundManager:GetPayDataList()
  return self.payDataList
end

function LWRefundManager:GetPayDataByOrderId(orderId)
  for k, v in pairs(self.payDataList) do
    if v.orderId == orderId then
      return v
    end
  end
  return nil
end

function LWRefundManager:GetRefundLimitDays()
  local days = 0
  if table.count(self.refundLimitDays) == 0 then
    local configStr = LuaEntry.DataConfig:TryGetStr("refund_params", "k1")
    if string.IsNullOrEmpty(configStr) then
      return days
    end
    local configArr = string.split(configStr, "|")
    for k, v in pairs(configArr) do
      local arr = string.split(v, ";")
      if 2 <= #arr then
        local area = tostring(arr[1])
        local limitDays = arr[2]
        if area and limitDays then
          self.refundLimitDays[area] = limitDays
        end
      end
    end
  end
  local area = LuaEntry.Player.regCountry
  if self.refundLimitDays[area] == nil then
    days = self.refundLimitDays[defaultAreaIndex]
  else
    days = self.refundLimitDays[area]
  end
  return days
end

return LWRefundManager
