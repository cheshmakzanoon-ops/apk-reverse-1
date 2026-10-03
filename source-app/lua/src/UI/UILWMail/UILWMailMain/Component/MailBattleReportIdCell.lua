local MailBattleReportIdCell = BaseClass("MailBattleReportIdCell", UIBaseContainer)
local base = UIBaseContainer
local MailSoloCell = require("UI.UILWMail.UILWMailMain.Component.MailSoloCell")
local Localization = CS.GameEntry.Localization

function MailBattleReportIdCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailBattleReportIdCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailBattleReportIdCell:ComponentDefine()
  self.reportIdText = self:AddComponent(UIText, "BattleReportIdText")
end

function MailBattleReportIdCell:ComponentDestroy()
  self.reportIdText = nil
end

function MailBattleReportIdCell:SetData(reportId)
  if reportId then
    self.reportIdText:SetActive(true)
    self.reportIdText:SetLocalText("copy_battlemailid_001", tostring(reportId))
  else
    self.reportIdText:SetActive(false)
  end
end

function MailBattleReportIdCell:DataDefine()
end

function MailBattleReportIdCell:DataDestroy()
end

function MailBattleReportIdCell:OnEnable()
  base.OnEnable(self)
end

function MailBattleReportIdCell:OnDisable()
  base.OnDisable(self)
end

function MailBattleReportIdCell:OnAddListener()
  base.OnAddListener(self)
end

function MailBattleReportIdCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailBattleReportIdCell
