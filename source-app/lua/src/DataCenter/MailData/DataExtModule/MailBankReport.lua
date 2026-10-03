local repaidJson = require("rapidjson")
local MailBankReport = BaseClass("MailBankReport")

function MailBankReport:__init()
  self.bankReport = {}
end

function MailBankReport:ParseContent(mailContent)
  if table.IsNullOrEmpty(mailContent) then
    return
  end
  self.bankReport = mailContent
  if not mailContent.logTypeCode then
    return
  end
  if (not mailContent.settleAmount or mailContent.settleAmount <= 0) and mailContent.logTypeCode ~= SeasonBankReportType.BE_ROBBED then
    mailContent.settleAmount = DataCenter.SeasonBankManager:GetSettleAmount(mailContent.depositAmount, mailContent.rate)
  end
  if mailContent.logTypeCode == SeasonBankReportType.DEPOSIT_TO or mailContent.logTypeCode == SeasonBankReportType.DEPOSIT_DUE then
    local depositDays = mailContent.depositDays or 0
    local depositTime = mailContent.depositTime or 0
    if 0 < depositDays and 0 < depositTime then
      local endTime = depositTime + depositDays * 24 * 3600 * 1000
      if not mailContent.settleTime or endTime > mailContent.settleTime then
        mailContent.settleTime = endTime
      end
    end
  end
end

function MailBankReport:GetExtData()
  return self.bankReport
end

return MailBankReport
