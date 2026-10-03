local UIFirstPayDayToggle = BaseClass("UIFirstPayDayToggle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function RefreshShowState(self)
  self.selectedBg:SetActive(self.selected)
  self.selectedArrow:SetActive(self.selected)
  if self.selected then
    self.btnText:SetActive(true)
    self.btnInactiveText:SetActive(false)
  else
    self.btnText:SetActive(false)
    self.btnInactiveText:SetActive(true)
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self.toggle = self:AddComponent(UIButton, "")
  self.toggle:SetOnClick(function(isOn)
    if self.selected then
      return
    end
    self.view:RefreshPackage(self.dayId)
  end)
  self.selectedBg = self:AddComponent(UIImage, "SelectedBg")
  self.btnText = self:AddComponent(UIText, "BtnText")
  self.selectedArrow = self:AddComponent(UIImage, "SelectedArrow")
  self.btnInactiveText = self:AddComponent(UIText, "BtnInactiveText")
end

local function OnDestroy(self)
  self.toggle = nil
  self.selectedBg = nil
  self.btnText = nil
  self.selectedArrow = nil
  self.btnInactiveText = nil
  base.OnDestroy(self)
end

local function SetDay(self, dayId)
  self.dayId = dayId
end

local function SetSelected(self, state)
  self.selected = state
  RefreshShowState(self)
end

UIFirstPayDayToggle.OnCreate = OnCreate
UIFirstPayDayToggle.OnDestroy = OnDestroy
UIFirstPayDayToggle.SetDay = SetDay
UIFirstPayDayToggle.SetSelected = SetSelected
return UIFirstPayDayToggle
