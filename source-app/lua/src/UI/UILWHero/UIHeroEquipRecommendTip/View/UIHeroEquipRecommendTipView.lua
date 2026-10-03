local Base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIHeroEquipRecommendTipView = BaseClass("UIHeroEquipRecommendTipView", Base)
local UIHeroEquipRecommendTipTagComponent = require("UI/UILWHero/UIHeroEquipRecommendTip/Component/UIHeroEquipRecommendTipTagComponent")
local Localization = CS.GameEntry.Localization

local function ComponentDefine(self)
  Base.ComponentDefine(self)
  self.textSwitch = self:AddComponent(UIText, "Root/ImgBg/Content/SwitchContent/SwitchText")
  self.textSwitch:SetText(Localization:GetString("equip_recommend_desc_2"))
  self.textSquad = self:AddComponent(UIText, "Root/ImgBg/Content/SquadContent/SquadText")
  self.textSquad:SetText(Localization:GetString("equip_recommend_desc_6"))
  self.btnSwitchToggle = self:AddComponent(UIButton, "Root/ImgBg/Content/SwitchContent/SwitchToggle")
  self.btnSwitchToggle:SetOnClick(function()
    self:OnBtnSwitchToggleClick()
  end)
  self.btnSwitchToggle:SetSafeClickMode(true)
  self.compSquad = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/SquadContent")
  self.compLeft = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/SwitchContent/SwitchToggle/Left")
  self.compIsOn = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/SwitchContent/SwitchToggle/IsOn")
  self.compRight = self:AddComponent(UIBaseContainer, "Root/ImgBg/Content/SwitchContent/SwitchToggle/Right")
  self.textDes = self:AddComponent(UIText, "Root/ImgBg/DesContent/Viewport/Content/DesText")
  self.textDes:SetText(Localization:GetString("equip_recommend_desc_3"))
  self.textSquadCur = self:AddComponent(UIText, "Root/ImgBg/Content/SquadContent/Cur/SquadCurText")
  self.btnDropdown = self:AddComponent(UIButton, "Root/ImgBg/Content/SquadContent/Cur/dropdownBtn")
  self.btnDropdown:SetOnClick(function()
    self:OnBtnDropdownClick()
  end)
  self.btnDropdown2 = self:AddComponent(UIButton, "Root/ImgBg/Content/SquadContent/Cur/dropdownBtn2")
  self.btnDropdown2:SetOnClick(function()
    self:OnBtnDropdownClick()
  end)
  self.compDropdown = self:AddComponent(UIBaseContainer, "Root/ImgBg/dropdown")
  self.btnDropClose = self:AddComponent(UIButton, "Root/ImgBg/dropdown/DropCloseBtn")
  self.btnDropClose:SetOnClick(function()
    self:OnBtnDropCloseClick()
  end)
  self.compSquad1 = self:AddComponent(UIHeroEquipRecommendTipTagComponent, "Root/ImgBg/dropdown/Squad1")
  self.compSquad2 = self:AddComponent(UIHeroEquipRecommendTipTagComponent, "Root/ImgBg/dropdown/Squad2")
  self.compSquad3 = self:AddComponent(UIHeroEquipRecommendTipTagComponent, "Root/ImgBg/dropdown/Squad3")
  self.compSquad4 = self:AddComponent(UIHeroEquipRecommendTipTagComponent, "Root/ImgBg/dropdown/Squad4")
end

local function ComponentDestroy(self)
  self.textSwitch = nil
  self.btnSwitchToggle = nil
  self.textSquad = nil
  self.compSquad = nil
  self.compLeft = nil
  self.compRight = nil
  self.compIsOn = nil
  self.textDes = nil
  self.textSquadCur = nil
  self.btnDropdown = nil
  self.compDropdown = nil
  self.btnDropClose = nil
  self.compSquad1 = nil
  self.compSquad2 = nil
  self.compSquad3 = nil
  self.compSquad4 = nil
  self.btnDropdown2 = nil
  Base.ComponentDestroy(self)
end

local function RefreshShow(self)
  self.showDropdown = false
  self.ctrl:ResetFakeSquad(true)
  self:UpdateToggle()
  self:UpdateDropdown()
  self:UpdateCurSelect()
end

local function UpdateToggle(self)
  local curSquad = DataCenter.EquipRecommendManager:GetCurSquadIndex()
  local isOn = curSquad ~= nil and 0 < curSquad
  self.compIsOn:SetActive(isOn)
  self.compLeft:SetActive(not isOn)
  self.compRight:SetActive(isOn)
end

local function UpdateCurSelect(self)
  local curSquad = self.ctrl:GetFakeSquad()
  self.textSquadCur:SetText(DataCenter.EquipRecommendManager:GetSquadText(curSquad))
end

local function UpdateDropdown(self)
  self.compDropdown:SetActive(self.showDropdown)
  if self.showDropdown then
    self.compSquad1:ReInit(1)
    self.compSquad2:ReInit(2)
    self.compSquad3:ReInit(3)
    self.compSquad4:ReInit(4)
  end
end

local function OnBtnSwitchToggleClick(self)
  local curSquad = DataCenter.EquipRecommendManager:GetCurSquadIndex()
  local isOn = curSquad ~= nil and 0 < curSquad
  if isOn then
    DataCenter.EquipRecommendManager:SendSetCurSquadIndexMessage(0)
  else
    local curFakeSquad = self.ctrl:GetFakeSquad()
    if curFakeSquad then
      DataCenter.EquipRecommendManager:SendSetCurSquadIndexMessage(curFakeSquad)
    end
  end
end

local function OnBtnDropdownClick(self)
  self.showDropdown = not self.showDropdown
  self:UpdateDropdown()
end

local function OnBtnDropCloseClick(self)
  self.showDropdown = not self.showDropdown
  self:UpdateDropdown()
end

local function OnAddListener(self)
  Base.OnAddListener(self)
  self:AddUIListener(EventId.HeroEquipRecommendSwitchSuccess, self.OnSwitchSuccess)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroEquipRecommendSwitchSuccess, self.OnSwitchSuccess)
  Base.OnRemoveListener(self)
end

local function OnSwitchSuccess(self)
  self.showDropdown = false
  self.ctrl:ResetFakeSquad(false)
  self:UpdateToggle()
  self:UpdateCurSelect()
  self:UpdateDropdown()
end

function UIHeroEquipRecommendTipView:OnTagClick(squadIndex)
  local curSquad = DataCenter.EquipRecommendManager:GetCurSquadIndex()
  if curSquad ~= nil and 0 < curSquad then
    DataCenter.EquipRecommendManager:SendSetCurSquadIndexMessage(squadIndex)
  else
    self.ctrl:SetFakeSquad(squadIndex)
  end
  self.showDropdown = false
  self:UpdateDropdown()
  self:UpdateCurSelect()
end

UIHeroEquipRecommendTipView.ComponentDefine = ComponentDefine
UIHeroEquipRecommendTipView.ComponentDestroy = ComponentDestroy
UIHeroEquipRecommendTipView.RefreshShow = RefreshShow
UIHeroEquipRecommendTipView.OnBtnSwitchToggleClick = OnBtnSwitchToggleClick
UIHeroEquipRecommendTipView.UpdateToggle = UpdateToggle
UIHeroEquipRecommendTipView.OnAddListener = OnAddListener
UIHeroEquipRecommendTipView.OnRemoveListener = OnRemoveListener
UIHeroEquipRecommendTipView.OnSwitchSuccess = OnSwitchSuccess
UIHeroEquipRecommendTipView.UpdateCurSelect = UpdateCurSelect
UIHeroEquipRecommendTipView.UpdateDropdown = UpdateDropdown
UIHeroEquipRecommendTipView.OnBtnDropdownClick = OnBtnDropdownClick
UIHeroEquipRecommendTipView.OnBtnDropCloseClick = OnBtnDropCloseClick
return UIHeroEquipRecommendTipView
