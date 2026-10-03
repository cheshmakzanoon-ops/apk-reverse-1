local TCCommonDropDownItemComponent = BaseClass("TCCommonDropDownItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")
local selected_bg_path = "SelectedBg"
local select_btn_text_path = "SelectedBg/Select_BtnText"
local un_select_btn_text_path = "UnSelect_BtnText"
local un_select_horse_lamp_t_m_p_path = "UnSelect_HorseLampTmp"
local select_horse_lamp_tmp_path = "Select_HorseLampTmp"
local textWidth = 340

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.selectRootObj = self:AddComponent(UIBaseContainer, selected_bg_path)
  self.selectText = self:AddComponent(UIText, select_btn_text_path)
  self.unSelectText = self:AddComponent(UIText, un_select_btn_text_path)
  self.clickBtn = self:AddComponent(UIButton, "")
  self.clickBtn:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.unSelect_HorseLampTMP = self:AddComponent(UICommonHorseLampTMP, un_select_horse_lamp_t_m_p_path)
  self.select_HorseLampTMP = self:AddComponent(UICommonHorseLampTMP, select_horse_lamp_tmp_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.isHorseLamp = false
end

local function DataDestroy(self)
  self.isHorseLamp = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TCCommonDropDownItemComponent:SetData(index, textLoc, isHorseLamp)
  self.index = index
  self.isHorseLamp = isHorseLamp
  if isHorseLamp then
    self.unSelect_HorseLampTMP:SetTextWithLength(textLoc, textWidth)
    self.select_HorseLampTMP:SetTextWithLength(textLoc, textWidth)
  else
    self.unSelectText:SetText(textLoc)
    self.selectText:SetText(textLoc)
  end
end

function TCCommonDropDownItemComponent:SetSelectState(isSelect)
  self.selectRootObj:SetActive(isSelect)
  if self.isHorseLamp then
    self.unSelectText:SetActive(false)
    self.selectText:SetActive(false)
    self.unSelect_HorseLampTMP:SetActive(not isSelect)
    self.select_HorseLampTMP:SetActive(isSelect)
  else
    self.unSelectText:SetActive(not isSelect)
    self.selectText:SetActive(isSelect)
    self.unSelect_HorseLampTMP:SetActive(false)
    self.select_HorseLampTMP:SetActive(false)
  end
end

function TCCommonDropDownItemComponent:BlindClickCallback(clickCallback)
  self.clickCallback = clickCallback
end

function TCCommonDropDownItemComponent:OnClickBtn()
  if self.clickCallback then
    self.clickCallback(self.index)
  end
end

TCCommonDropDownItemComponent.OnCreate = OnCreate
TCCommonDropDownItemComponent.OnDestroy = OnDestroy
TCCommonDropDownItemComponent.OnEnable = OnEnable
TCCommonDropDownItemComponent.OnDisable = OnDisable
TCCommonDropDownItemComponent.ComponentDefine = ComponentDefine
TCCommonDropDownItemComponent.ComponentDestroy = ComponentDestroy
TCCommonDropDownItemComponent.DataDefine = DataDefine
TCCommonDropDownItemComponent.DataDestroy = DataDestroy
TCCommonDropDownItemComponent.OnAddListener = OnAddListener
TCCommonDropDownItemComponent.OnRemoveListener = OnRemoveListener
return TCCommonDropDownItemComponent
