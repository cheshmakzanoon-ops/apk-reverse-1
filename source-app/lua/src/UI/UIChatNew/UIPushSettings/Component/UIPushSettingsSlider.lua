local UIPushSettingsSlider = BaseClass("UIPushSettingsSlider", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "green",
    name = "green",
    type = UIGameObjectWrap
  },
  {
    path = "handle",
    name = "handle",
    type = nil
  },
  {
    path = "interact",
    name = "interact",
    type = UIButton,
    onClick = function(self)
      self:OnClick()
    end
  }
}

function UIPushSettingsSlider:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.isOn = false
  self.switchPos = 25
end

function UIPushSettingsSlider:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.onSwitch = nil
  self.switchPos = nil
end

function UIPushSettingsSlider:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIPushSettingsSlider:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIPushSettingsSlider:OnClick()
  self:Switch(not self.isOn)
end

function UIPushSettingsSlider:Switch(isOn)
  self.isOn = isOn
  self.green:SetActive(isOn)
  self.handle.transform.anchoredPosition = Vector2.New(isOn and self.switchPos or -1 * self.switchPos, 0)
  if self.onSwitch then
    self.onSwitch(isOn)
  end
end

function UIPushSettingsSlider:SetSwitchPos(val)
  self.switchPos = val
end

return UIPushSettingsSlider
