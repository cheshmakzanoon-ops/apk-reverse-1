local MailChannelItem = BaseClass("MailChannelItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local _cp_toggle = ""
local _txtTitle = "text"
local _cp_objRedPoint = "RedPointNum"
local _cp_txtRedPoint = "RedPointNum/Text"
local Color_UnSelect = Color32.New(0.6509803921568628, 0.4117647058823529, 0.27450980392156865, 1)
local Color_Select = Color32.New(0.9176470588235294, 0.5764705882352941, 0.37254901960784315, 1)

function MailChannelItem:OnCreate()
  base.OnCreate(self)
  self._txtTitle = self:AddComponent(UIText, _txtTitle)
  self._objRedPoint = self:AddComponent(UIBaseContainer, _cp_objRedPoint)
  self._txtRedPoint = self:AddComponent(UIText, _cp_txtRedPoint)
  self._toggle = self:AddComponent(UIToggle, _cp_toggle)
  self._toggle:SetOnValueChanged(BindCallback(self, self.ToggleCallback))
end

function MailChannelItem:InitData(mailChannelType, toggleCallback)
  self._mailChannelType = mailChannelType
  local eToggleDialog = {
    [MailInternalGroup.MAIL_IN_report] = "310101",
    [MailInternalGroup.MAIL_IN_alliance] = GameDialogDefine.ALLIANCE,
    [MailInternalGroup.MAIL_IN_system] = "310002",
    [MailInternalGroup.MAIL_IN_favor] = "310102"
  }
  self._txtTitle:SetLocalText(eToggleDialog[mailChannelType])
  self._toggle_callback = toggleCallback
  self:RefreshUnReadCnt()
end

function MailChannelItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MailPush, self.RefreshUnReadCnt)
end

function MailChannelItem:OnRemoveListener()
  self:RemoveUIListener(EventId.MailPush, self.RefreshUnReadCnt)
  base.OnRemoveListener(self)
end

function MailChannelItem:RefreshUnReadCnt()
  local cnt = DataCenter.MailDataManager:GetMailUnReadCountByGroup(self._mailChannelType)
  if 0 < cnt then
    self._objRedPoint:SetActive(true)
    self._txtRedPoint:SetText(cnt)
  else
    self._objRedPoint:SetActive(false)
  end
end

function MailChannelItem:IsChannelSelected()
  return self._toggle:GetIsOn()
end

function MailChannelItem:ToggleCallback(selected)
  if selected then
    self._txtTitle:SetColor(Color_Select)
    EventManager:GetInstance():Broadcast(EventId.Mail_Select_Channel, self._mailChannelType)
  else
    self._txtTitle:SetColor(Color_UnSelect)
  end
end

function MailChannelItem:SetSelected()
  self._toggle:SetIsOn(true)
  EventManager:GetInstance():Broadcast(EventId.Mail_Select_Channel, self._mailChannelType)
end

return MailChannelItem
