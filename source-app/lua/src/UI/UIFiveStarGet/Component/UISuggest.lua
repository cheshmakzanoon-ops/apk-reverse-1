local UISuggest = BaseClass("UISuggest", UIBaseContainer)
local base = UIBaseContainer
local maxNumber = 200

function UISuggest:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UISuggest:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISuggest:ComponentDefine()
  self.desText = self:AddComponent(UIText, "desText")
  self.numText = self:AddComponent(UIText, "numText")
  self.suggestBtn = self:AddComponent(UIButton, "suggestBtn")
  self.suggestBtn:SetOnClick(function()
    UIUtil.ShowTipsId(129279)
    self.view.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, "closeBtn")
  self.closeBtn:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self.input = self:AddComponent(UIInput, "InputField")
  self.input:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.input:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.input:SetText("")
end

function UISuggest:IptOnValueChange(value)
  self.inputValue = value
  if self.inputValue == "" then
    self.desText:SetActive(true)
    self.numText:SetText(0 .. "/" .. maxNumber)
  else
    self.desText:SetActive(false)
    local len = #self.inputValue
    self.numText:SetText(len .. "/" .. maxNumber)
  end
end

function UISuggest:ComponentDestroy()
  self.desText = nil
  self.numText = nil
  self.input = nil
  self.closeBtn = nil
  self.suggestBtn = nil
end

return UISuggest
