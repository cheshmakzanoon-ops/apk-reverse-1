local Base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIDecorationRecommendTipView = BaseClass("UIDecorationRecommendTipView", Base)
local Localization = CS.GameEntry.Localization

local function ComponentDefine(self)
  Base.ComponentDefine(self)
  self.textSwitch = self:AddComponent(UIText, "Root/ImgBg/Content/SwitchContent/SwitchText")
  self.textSwitch:SetText(Localization:GetString("equip_recommend_desc_2"))
  self.btnSwitchToggle = self:AddComponent(UIButton, "Root/ImgBg/Content/SwitchContent/SwitchToggle")
  self.btnSwitchToggle:SetOnClick(function()
    self:OnBtnSwitchToggleClick()
  end)
  self.btnSwitchToggle:SetSafeClickMode(true)
  self.compLeft = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/SwitchContent/SwitchToggle/Left")
  self.compIsOn = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/SwitchContent/SwitchToggle/IsOn")
  self.compRight = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/SwitchContent/SwitchToggle/Right")
  self.textDes = self:AddComponent(UIText, "Root/ImgBg/DesContent/Viewport/Content/DesText")
  self.textDes:SetText(Localization:GetString("decoration_recommend_info"))
end

local function ComponentDestroy(self)
  self.textSwitch = nil
  self.btnSwitchToggle = nil
  self.compLeft = nil
  self.compRight = nil
  self.compIsOn = nil
  self.textDes = nil
  Base.ComponentDestroy(self)
end

local function RefreshShow(self)
  self:UpdateToggle()
end

local function UpdateToggle(self)
  local isOn = DataCenter.DecorationRecommendManager:GetIsOn()
  self.compIsOn:SetActive(isOn)
  self.compLeft:SetActive(not isOn)
  self.compRight:SetActive(isOn)
end

local function OnBtnSwitchToggleClick(self)
  local isOn = DataCenter.DecorationRecommendManager:GetIsOn()
  if isOn then
    UIUtil.ShowMessage(Localization:GetString("close_decoration_recommend_sure"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.DecorationRecommendManager:SendOpenMessage(false)
    end, nil, nil)
  else
    DataCenter.DecorationRecommendManager:SendOpenMessage(not isOn)
  end
end

local function OnAddListener(self)
  Base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationBookRecommendOpenChanged, self.OnSwitchSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.DecorationBookRecommendOpenChanged, self.OnSwitchSuccess)
  Base.OnRemoveListener(self)
end

local function OnSwitchSuccess(self)
  self:UpdateToggle()
end

UIDecorationRecommendTipView.ComponentDefine = ComponentDefine
UIDecorationRecommendTipView.ComponentDestroy = ComponentDestroy
UIDecorationRecommendTipView.RefreshShow = RefreshShow
UIDecorationRecommendTipView.OnBtnSwitchToggleClick = OnBtnSwitchToggleClick
UIDecorationRecommendTipView.UpdateToggle = UpdateToggle
UIDecorationRecommendTipView.OnAddListener = OnAddListener
UIDecorationRecommendTipView.OnRemoveListener = OnRemoveListener
UIDecorationRecommendTipView.OnSwitchSuccess = OnSwitchSuccess
return UIDecorationRecommendTipView
