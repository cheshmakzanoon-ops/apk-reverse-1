local UILWHeroHonorLevelEffectLine = BaseClass("UILWHeroHonorLevelEffectLine", UIBaseContainer)
local base = UIBaseContainer
local icon_path = "Icon"
local unlockLevelBg_path = "UnlockLevelBg"
local unlockLevelText_path = "UnlockLevelBg/UnlockLevelText"
local nameText_path = "NameText"
local valueText_path = "ValueText"
local grayNameText_path = "GrayNameText"
local grayValueText_path = "GrayValueText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.unlockLevelBg = self:AddComponent(UIImage, unlockLevelBg_path)
  self.unlockLevelText = self:AddComponent(UIText, unlockLevelText_path)
  self.nameText = self:AddComponent(UITextMeshProUGUIEx, nameText_path)
  self.grayNameText = self:AddComponent(UITextMeshProUGUIEx, grayNameText_path)
  self.valueText = self:AddComponent(UITextMeshProUGUIEx, valueText_path)
  self.grayValueText = self:AddComponent(UITextMeshProUGUIEx, grayValueText_path)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.unlockLevelBg = nil
  self.unlockLevelText = nil
  self.nameText = nil
  self.valueText = nil
  self.grayNameText = nil
  self.grayValueText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self, data)
  self.data = data
  self.unlockLevelText:SetText(data.unlockLevel)
  self.nameText:SetLocalText(data.name)
  self.valueText:SetText(data.value)
  self.grayNameText:SetLocalText(data.name)
  self.grayValueText:SetText(data.value)
end

local function SetState(self, unlocked)
  if unlocked then
    self.nameText:SetActive(true)
    self.valueText:SetActive(true)
    self.nameText:SetColor(AttributeGreen)
    self.valueText:SetColor(AttributeGreen)
    self.grayNameText:SetActive(false)
    self.grayValueText:SetActive(false)
    self.icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_rongyuqiang_lvdian.png")
    self.unlockLevelBg:LoadSprite("Assets/Main/Sprites/UI/UILWHeroHonor/zyf_rongyuqiang_lvtiao.png")
  else
    self.nameText:SetActive(false)
    self.valueText:SetActive(false)
    self.grayNameText:SetActive(true)
    self.grayValueText:SetActive(true)
    self.grayNameText:SetColor(AttributeGray)
    self.grayValueText:SetColor(AttributeGray)
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroHonor/zyf_rongyuqiang_huidian2.png")
    self.unlockLevelBg:LoadSprite("Assets/Main/Sprites/UI/UILWHeroHonor/zyf_rongyuqiang_huitiao.png")
  end
end

UILWHeroHonorLevelEffectLine.OnCreate = OnCreate
UILWHeroHonorLevelEffectLine.OnDestroy = OnDestroy
UILWHeroHonorLevelEffectLine.OnEnable = OnEnable
UILWHeroHonorLevelEffectLine.OnDisable = OnDisable
UILWHeroHonorLevelEffectLine.ComponentDefine = ComponentDefine
UILWHeroHonorLevelEffectLine.ComponentDestroy = ComponentDestroy
UILWHeroHonorLevelEffectLine.DataDefine = DataDefine
UILWHeroHonorLevelEffectLine.DataDestroy = DataDestroy
UILWHeroHonorLevelEffectLine.ReInit = ReInit
UILWHeroHonorLevelEffectLine.SetState = SetState
return UILWHeroHonorLevelEffectLine
