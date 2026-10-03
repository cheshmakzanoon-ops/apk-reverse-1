local UIGMVibratorPanelView = BaseClass("UIGMVibratorPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Vibrator = CS.Vibrator

function UIGMVibratorPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMVibratorPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMVibratorPanelView:ComponentDefine()
  self.sliderIntensity = self:AddComponent(UISlider, "ViewRect/SheetRoot/IntensityPanel/IntensitySlider")
  self.sliderSharpness = self:AddComponent(UISlider, "ViewRect/SheetRoot/SharpnessPanel/SharpnessSlider")
  self.btnGo = self:AddComponent(UIButton, "ViewRect/SheetRoot/GoBtn")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.btnStop = self:AddComponent(UIButton, "ViewRect/SheetRoot/StopBtn")
  self.btnStop:SetOnClick(function()
    self:OnBtnStopClick()
  end)
  self.btnCloseBg = self:AddComponent(UIButton, "CloseBg")
  self.btnCloseBg:SetOnClick(function()
    self:OnBtnCloseBgClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "ViewRect/SheetRoot/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textIntensityNum = self:AddComponent(UITextMeshProUGUIEx, "ViewRect/SheetRoot/IntensityPanel/IntensityNumText")
  self.textSharpnessNum = self:AddComponent(UITextMeshProUGUIEx, "ViewRect/SheetRoot/SharpnessPanel/SharpnessNumText")
  self.durationInput = self:AddComponent(UIInput, "ViewRect/SheetRoot/DurationPanel/DurationInput")
  self.typeInput = self:AddComponent(UIInput, "ViewRect/SheetRoot/TypePanel/TypeInput")
  self.sliderIntensity:SetOnValueChanged(function(value)
    self.textIntensityNum:SetText(string.formatDecimal(value, 2))
  end)
  self.sliderSharpness:SetOnValueChanged(function(value)
    self.textSharpnessNum:SetText(string.formatDecimal(value, 2))
  end)
end

function UIGMVibratorPanelView:ComponentDestroy()
  self.sliderIntensity = nil
  self.sliderSharpness = nil
  self.btnGo = nil
  self.btnStop = nil
  self.btnCloseBg = nil
  self.btnClose = nil
  self.textIntensityNum = nil
  self.textSharpnessNum = nil
  self.durationInput = nil
  self.typeInput = nil
end

function UIGMVibratorPanelView:DataDefine()
end

function UIGMVibratorPanelView:DataDestroy()
end

function UIGMVibratorPanelView:OnAddListener()
  base.OnAddListener(self)
end

function UIGMVibratorPanelView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGMVibratorPanelView:OnBtnGoClick()
  local a = toInt(self.typeInput:GetText())
  Vibrator.ContinuousHaptic(self.sliderIntensity:GetValue(), self.sliderSharpness:GetValue(), tonumber(self.durationInput:GetText()), toInt(self.typeInput:GetText()) or 9)
end

function UIGMVibratorPanelView:OnBtnStopClick()
  Vibrator.StopContinuousHaptic()
end

function UIGMVibratorPanelView:OnBtnCloseBgClick()
  self.ctrl:CloseSelf()
end

function UIGMVibratorPanelView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UIGMVibratorPanelView
