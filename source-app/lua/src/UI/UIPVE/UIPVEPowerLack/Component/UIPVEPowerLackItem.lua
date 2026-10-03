local UIPVEPowerLackItem = BaseClass("UIPVEPowerLackItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "Bg"
local recommend_path = "Recommend"
local glow_path = "Glow"
local icon_path = "Icon"
local name_path = "Name"
local btn_path = "Btn"
local btn_text_path = "Btn/BtnText"
local NAME_Y_TOP = 98.5
local NAME_Y_BOTTOM = -92.5

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg_go = self:AddComponent(UIBaseContainer, bg_path)
  self.recommend_go = self:AddComponent(UIBaseContainer, recommend_path)
  self.glow_go = self:AddComponent(UIBaseComponent, glow_path)
  self.icon_btn = self:AddComponent(UIButton, icon_path)
  self.icon_btn:SetOnClick(function()
    self:OnClick()
  end)
  self.name_text = self:AddComponent(UIText, name_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
end

local function ComponentDestroy(self)
  self.bg_go = nil
  self.recommend_go = nil
  self.glow_go = nil
  self.icon_btn = nil
  self.name_text = nil
  self.btn = nil
  self.btn_text = nil
end

local function DataDefine(self)
  self.data = nil
end

local function DataDestroy(self)
  self.data = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data)
  self.data = data
  self.icon_btn:LoadSprite(string.format(LoadPath.ResLackIcons, data.template.pic))
  self.name_text:SetLocalText(data.template.name)
  self.btn_text:SetLocalText(data.template.btnName)
  if data.tip == PvePowerLackTipType.FirstPay then
    self.glow_go:SetActive(true)
  else
    self.glow_go:SetActive(false)
  end
  if data.showBg then
    self.name_text.rectTransform.localPosition = Vector2.New(0, NAME_Y_TOP)
    self.bg_go:SetActive(true)
    self.recommend_go:SetActive(data.recommended)
    self.btn:SetActive(true)
  else
    self.name_text.rectTransform.localPosition = Vector2.New(0, NAME_Y_BOTTOM)
    self.bg_go:SetActive(false)
    self.recommend_go:SetActive(false)
    self.btn:SetActive(false)
  end
end

local function OnClick(self)
  if self.data and self.data.onClick then
    self.data.onClick()
  end
end

UIPVEPowerLackItem.OnCreate = OnCreate
UIPVEPowerLackItem.OnDestroy = OnDestroy
UIPVEPowerLackItem.ComponentDefine = ComponentDefine
UIPVEPowerLackItem.ComponentDestroy = ComponentDestroy
UIPVEPowerLackItem.DataDefine = DataDefine
UIPVEPowerLackItem.DataDestroy = DataDestroy
UIPVEPowerLackItem.OnEnable = OnEnable
UIPVEPowerLackItem.OnDisable = OnDisable
UIPVEPowerLackItem.OnAddListener = OnAddListener
UIPVEPowerLackItem.OnRemoveListener = OnRemoveListener
UIPVEPowerLackItem.SetData = SetData
UIPVEPowerLackItem.OnClick = OnClick
return UIPVEPowerLackItem
