local LWRefundFaqData = BaseClass("LWRefundFaqData")
local LWRefundFaqTemplate = require("DataCenter.LWRefund.LWRefundFaqTemplate")

function LWRefundFaqData:__init()
  self.faqMap = {}
  self:InitFaqMap()
end

function LWRefundFaqData:__delete()
  self.faqMap = nil
end

function LWRefundFaqData:InitFaqMap()
  LocalController:instance():visitTable(TableName.REFUND_FAQ, function(id, lineData)
    if lineData ~= nil then
      local template = LWRefundFaqTemplate.New()
      template:InitData(lineData)
      table.insert(self.faqMap, template)
    end
  end)
end

function LWRefundFaqData:GetFAQMap()
  return self.faqMap
end

return LWRefundFaqData
