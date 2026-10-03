local UICareerEffect = BaseClass("UICareerEffect", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local good_bg_path = "GoodBg"
local bad_bg_path = "BadBg"
local icon_path = "Icon"
local MISSING = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_wenhao"
local ICON_WIDTH = 65

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
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.good_bg_go = self:AddComponent(UIBaseContainer, good_bg_path)
  self.bad_bg_go = self:AddComponent(UIBaseContainer, bad_bg_path)
  self.icon_image = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.good_bg_go = nil
  self.bad_bg_go = nil
  self.icon_image = nil
end

local function DataDefine(self)
  self.onClick = nil
end

local function DataDestroy(self)
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, id)
  local template = DataCenter.PlayerCareerManager:GetCareerEffectTemplate(id)
  self.icon_image:LoadSprite(template:GetIconPath(), MISSING)
  self.icon_image:SetNativeSize()
  local size = self.icon_image.rectTransform.sizeDelta
  size.y = size.y / size.x * ICON_WIDTH
  size.x = ICON_WIDTH
  self.icon_image.rectTransform.sizeDelta = size
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function OnClick(self)
  if self.onClick then
    self.onClick()
  end
end

UICareerEffect.OnCreate = OnCreate
UICareerEffect.OnDestroy = OnDestroy
UICareerEffect.ComponentDefine = ComponentDefine
UICareerEffect.ComponentDestroy = ComponentDestroy
UICareerEffect.DataDefine = DataDefine
UICareerEffect.DataDestroy = DataDestroy
UICareerEffect.OnAddListener = OnAddListener
UICareerEffect.OnRemoveListener = OnRemoveListener
UICareerEffect.OnEnable = OnEnable
UICareerEffect.OnDisable = OnDisable
UICareerEffect.SetData = SetData
UICareerEffect.SetOnClick = SetOnClick
UICareerEffect.OnClick = OnClick
return UICareerEffect
