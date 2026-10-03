local UIBuildUpgradeSuccessLine = BaseClass("UIBuildUpgradeSuccessLine", UIBaseContainer)
local base = UIBaseContainer
local desc_path = "Desc"
local desc1_path = "Desc1"
local RightGo_path = "RightGo"
local left_val_path = "RightGo/LeftVal"
local right_val_path = "RightGo/RightVal"
local right_val1_path = "RightVal1"
local arrow_path = "RightGo/Arrow"
local specialIcon_path = "SpecialIcon"

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
  self.rightGo = self:AddComponent(UIBaseContainer, RightGo_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.desc1_text = self:AddComponent(UIText, desc1_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.left_val_text = self:AddComponent(UIText, left_val_path)
  self.right_val_text = self:AddComponent(UIText, right_val_path)
  self.right_val1_text = self:AddComponent(UIText, right_val1_path)
  self.specialIcon = self:AddComponent(UIImage, specialIcon_path)
  self.anim = self:AddComponent(UIAnimator, self.gameObject)
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
end

local function ComponentDestroy(self)
  self.rightGo = nil
  self.desc_text = nil
  self.left_val_text = nil
  self.right_val_text = nil
  self.anim = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self:ClearDelayPlayShowAnimTimer()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

function UIBuildUpgradeSuccessLine:ClearDelayPlayShowAnimTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIBuildUpgradeSuccessLine:SetAlpha(value)
  if not self.anim then
    self.anim = self:AddComponent(UIAnimator, self.gameObject)
  end
  if self.anim then
    self.anim:Enable(false)
  end
  if self.canvasGroup then
    self.canvasGroup:SetAlpha(value)
  end
end

function UIBuildUpgradeSuccessLine:DelayPlayShowAnim(delay)
  if not self.anim then
    self.anim = self:AddComponent(UIAnimator, self.gameObject)
  end
  self:SetAlpha(0)
  self:ClearDelayPlayShowAnimTimer()
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.anim then
      self.anim:Enable(true)
      self.anim:Play("UIEquipPromoteSuccessCell_movein", 0, 0)
    end
  end, delay)
end

local function SetData(self, id, leftVal, rightVal, isAddition)
  self.desc_text:SetActive(false)
  self.desc1_text:SetActive(false)
  self.arrow:SetActive(false)
  self.left_val_text:SetActive(false)
  self.right_val_text:SetActive(false)
  self.right_val1_text:SetActive(false)
  self.specialIcon:SetActive(true)
  if isAddition then
    self.specialIcon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWUIEquipPromote/zyf_zhuangbeiyouhua_shuijing_da.png")
  else
    self.specialIcon:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_tongyong_dian_icon.png")
  end
  if leftVal == nil then
    self.desc1_text:SetLocalText(HeroUtils.GetHeroPropertyNameId(id))
    self.right_val1_text:SetText(HeroUtils.GetFormattedPropertyValue(id, rightVal))
    self.desc1_text:SetActive(true)
    if self.rightGo then
      self.rightGo.gameObject:SetActive(false)
    end
    self.right_val1_text:SetActive(true)
    if not isAddition then
      self.desc1_text.transform:Set_anchoredPosition(0, 0)
    else
      self.desc1_text.transform:Set_anchoredPosition(30 * CommonUtil.ArabicAutoMirrorFactor(), 0)
    end
  else
    if self.rightGo then
      self.rightGo.gameObject:SetActive(true)
    end
    self.desc_text:SetActive(true)
    self.arrow:SetActive(true)
    self.left_val_text:SetActive(true)
    self.right_val_text:SetActive(true)
    self.desc_text:SetLocalText(HeroUtils.GetHeroPropertyNameId(id))
    self.left_val_text:SetText(HeroUtils.GetFormattedPropertyValue(id, leftVal))
    self.right_val_text:SetText(HeroUtils.GetFormattedPropertyValue(id, rightVal))
    self.right_val_text:SetColor(leftVal == rightVal and WhiteColor or NewAttributeGreen)
    if not isAddition then
      self.desc_text.transform:Set_anchoredPosition(0, 0)
    else
      self.desc_text.transform:Set_anchoredPosition(30 * CommonUtil.ArabicAutoMirrorFactor(), 0)
    end
  end
end

UIBuildUpgradeSuccessLine.OnCreate = OnCreate
UIBuildUpgradeSuccessLine.OnDestroy = OnDestroy
UIBuildUpgradeSuccessLine.ComponentDefine = ComponentDefine
UIBuildUpgradeSuccessLine.ComponentDestroy = ComponentDestroy
UIBuildUpgradeSuccessLine.DataDefine = DataDefine
UIBuildUpgradeSuccessLine.DataDestroy = DataDestroy
UIBuildUpgradeSuccessLine.OnEnable = OnEnable
UIBuildUpgradeSuccessLine.OnDisable = OnDisable
UIBuildUpgradeSuccessLine.SetData = SetData
return UIBuildUpgradeSuccessLine
