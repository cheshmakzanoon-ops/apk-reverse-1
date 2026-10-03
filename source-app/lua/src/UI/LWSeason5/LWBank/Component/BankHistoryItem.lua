local base = require("UI.LWSeason5.LWBank.Component.BankHelpHistoryItem")
local BankHistoryItem = BaseClass("BankHistoryItem", base)
local __StatusText = {
  [1] = "season5_deposit_status01",
  [2] = "season5_deposit_status02",
  [3] = "season5_deposit_status03",
  [4] = "season5_deposit_status04"
}
local bg_path = "bg"
local head_path = "head"
local name_path = "name"
local desc_path = "desc"
local time_path = "Txt_Time"
local btnMail_path = "btnMail"
local status_path = "status"
local icon_path = "icon"

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.head = self:AddComponent(UIBaseContainer, head_path)
  self.name = self:AddComponent(UIText, name_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.time = self:AddComponent(UIText, time_path)
  self.btnMail = self:AddComponent(UIButton, btnMail_path)
  self.status = self:AddComponent(UIText, status_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btnMail:SetOnClick(BindCallback(self, self.OnClickMail))
end

function BankHistoryItem:ReInit(data, index)
  self.mailUuid = data.mailUuid
  self:RefreshInfo(data.logTypeCode, data.logTime, data.amount, data.depositDays, data.finalAmount)
  self:RefreshName(LuaEntry.Player)
  self.status:SetLocalText(__StatusText[data.logTypeCode] or "")
  local reportInfo = DataCenter.SeasonBankTemplateManager.bankEmoji
  if reportInfo and reportInfo[data.logTypeCode] then
    self.icon:LoadSpriteAsync(reportInfo[data.logTypeCode])
  end
end

function BankHistoryItem:OnClickMail()
  if not self.mailUuid or not DataCenter.MailDataManager:GetMailInfoById(self.mailUuid) then
    UIUtil.ShowTipsId("s5_bank_tips16")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.mailUuid, "DetectReward")
end

BankHistoryItem.ComponentDefine = ComponentDefine
return BankHistoryItem
