local MailPropertyCell = BaseClass("MailPropertyCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function MailPropertyCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailPropertyCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailPropertyCell:ComponentDefine()
  self.PropertyNum1 = self:AddComponent(UIText, "PropertyNum1")
  self.PropertyName = self:AddComponent(UIText, "PropertyName")
  self.PropertyNum2 = self:AddComponent(UIText, "PropertyNum2")
end

function MailPropertyCell:ComponentDestroy()
  self.PropertyNum1 = nil
  self.PropertyName = nil
  self.PropertyNum2 = nil
end

function MailPropertyCell:SetData(data)
  self.PropertyNum1:SetText(tostring(data[1] or 0))
  self.PropertyNum2:SetText(tostring(data[2] or 0))
  local meta = DataCenter.EffectNumberTemplateManager:GetTemplate(data.id)
  self.PropertyName:SetLocalText(meta.name)
end

function MailPropertyCell:DataDefine()
end

function MailPropertyCell:DataDestroy()
end

function MailPropertyCell:OnEnable()
  base.OnEnable(self)
end

function MailPropertyCell:OnDisable()
  base.OnDisable(self)
end

function MailPropertyCell:OnAddListener()
  base.OnAddListener(self)
end

function MailPropertyCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailPropertyCell
