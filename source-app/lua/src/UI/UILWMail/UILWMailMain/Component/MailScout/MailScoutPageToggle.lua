local MailScoutPageToggle = BaseClass("MailScoutPageToggle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function MailScoutPageToggle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailScoutPageToggle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailScoutPageToggle:DataDefine()
end

function MailScoutPageToggle:DataDestroy()
  self.type = nil
  self.callback = nil
end

function MailScoutPageToggle:OnEnable()
  base.OnEnable(self)
end

function MailScoutPageToggle:OnDisable()
  base.OnDisable(self)
end

function MailScoutPageToggle:OnAddListener()
  base.OnAddListener(self)
end

function MailScoutPageToggle:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailScoutPageToggle:ComponentDefine()
  self.active = self:AddComponent(UIImage, "Background/Checkmark")
  self.inactve_txt = self:AddComponent(UIText, "inactiveTxt")
  self.active_txt = self:AddComponent(UIText, "activeTxt")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if self.callback then
      self.callback(self.type)
    end
  end)
end

function MailScoutPageToggle:ComponentDestroy()
  self.inactive = nil
  self.active = nil
  self.inactve_txt = nil
  self.active_txt = nil
  self.btn = nil
end

function MailScoutPageToggle:SetSelected(isSelected)
  self.active:SetActive(isSelected)
  self.inactve_txt:SetActive(not isSelected)
  self.active_txt:SetActive(isSelected)
end

function MailScoutPageToggle:SetData(name, type, callback)
  self.inactve_txt:SetLocalText(name)
  self.active_txt:SetLocalText(name)
  self.type = type
  self.callback = callback
end

return MailScoutPageToggle
