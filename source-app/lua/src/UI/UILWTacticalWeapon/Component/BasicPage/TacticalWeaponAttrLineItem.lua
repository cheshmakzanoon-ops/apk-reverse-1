local TacticalWeaponAttrLineItem = BaseClass("TacticalWeaponAttrLineItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local ResourceManager = CS.GameEntry.Resource
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local level_up_effect_path = "levelUpEffect"

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
  self.icon = self:AddComponent(UIImage, "AttriIcon")
  self.curValueText = self:AddComponent(UIText, "AttriValue/CurValueText")
  self.arrowIcon = self:AddComponent(UIImage, "AttriValue/ArrowIcon")
  self.nextValueText = self:AddComponent(UIText, "AttriValue/NextValueText")
  self.nextValueText:SetText("0")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClickPropertyItem()
  end)
  self.level_up_effect = self:TryAddComponent(UIBaseContainer, level_up_effect_path)
  if self.level_up_effect then
    self.effectCpts = self.level_up_effect.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  end
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.curValueText = nil
  self.arrowIcon = nil
  self.nextValueText = nil
  self.animSeq = nil
  self.btn = nil
  self.level_up_effect = nil
  self.effectCpts = nil
end

local function DataDestroy(self)
  self.curValue = nil
  self.nextValue = nil
  self.master = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function StopAnim(self)
  if self.animSeq then
    self.animSeq:Kill()
    self.animSeq = nil
  end
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  StopAnim(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetValue(self, effectId, value, newValue)
  StopAnim(self)
  if not effectId or not value then
    return
  end
  local effectIcon = DataCenter.EffectNumberTemplateManager:GetEffectNumberIcon(effectId)
  self.icon:LoadSprite(effectIcon)
  local formattedValue = HeroUtils.GetFormattedPropertyValue(effectId, value)
  self.curValueText:SetText(formattedValue)
  self.curValue = value
  self.effectId = effectId
  if newValue then
    self.nextValueText:SetActive(true)
    self.arrowIcon:SetActive(true)
    local formattedNextValue = HeroUtils.GetFormattedPropertyValue(effectId, newValue)
    self.nextValueText:SetText(formattedNextValue)
    self.nextValue = newValue
  else
    self.nextValueText:SetActive(false)
    self.arrowIcon:SetActive(false)
  end
end

local function AnimValue(self, effectId, value, newValue, time)
  StopAnim(self)
  if not effectId or not value then
    return
  end
  local animTime = time or 0.15
  if self.curValue ~= nil and self.curValue ~= value then
    self.animSeq = CS.DG.Tweening.DOTween.Sequence()
    self.animSeq:Append(DOTween.To(function(x)
      local formattedValue = HeroUtils.GetFormattedPropertyValue(effectId, x)
      self.curValueText:SetText(formattedValue)
    end, self.curValue, value, animTime):SetEase(CS.DG.Tweening.Ease.OutCubic))
  else
    local formattedValue = HeroUtils.GetFormattedPropertyValue(effectId, value)
    self.curValueText:SetText(formattedValue)
  end
  if newValue and self.nextValue and self.nextValue ~= newValue then
    if self.animSeq == nil then
      self.animSeq = CS.DG.Tweening.DOTween.Sequence()
    end
    self.animSeq:Insert(0, DOTween.To(function(x)
      local formattedNextValue = HeroUtils.GetFormattedPropertyValue(effectId, x)
      self.nextValueText:SetText(formattedNextValue)
    end, self.nextValue, newValue, animTime):SetEase(CS.DG.Tweening.Ease.OutCubic))
  elseif newValue then
    self.nextValueText:SetActive(true)
    self.arrowIcon:SetActive(true)
    local formattedNextValue = HeroUtils.GetFormattedPropertyValue(effectId, newValue)
    self.nextValueText:SetText(formattedNextValue)
  elseif newValue == nil then
    self.nextValueText:SetActive(false)
    self.arrowIcon:SetActive(false)
  else
    self.nextValueText:SetActive(true)
    self.arrowIcon:SetActive(true)
  end
  if self.animSeq then
    self.animSeq:AppendCallback(function()
      self.animSeq = nil
    end)
    self.animSeq:OnKill(function()
      if self.curValueText then
        local formattedValue = HeroUtils.GetFormattedPropertyValue(effectId, value)
        self.curValueText:SetText(formattedValue)
      end
      if self.nextValueText and newValue then
        local formattedNextValue = HeroUtils.GetFormattedPropertyValue(effectId, newValue)
        self.nextValueText:SetText(formattedNextValue)
      end
    end)
  end
  if self.nextValue ~= nil and self.nextValue ~= newValue and not IsNull(self.effectCpts) then
    for i = 0, self.effectCpts.Length - 1 do
      self.effectCpts[i]:Play()
    end
  end
  self.curValue = value
  self.nextValue = newValue
  self.effectId = effectId
end

local function OnClickPropertyItem(self, effectId)
  if not self.master then
    return
  end
  if not self.effectId then
    return
  end
  local propertyDesc = TacticalWeaponUtils.GetEffectTips(self.master, self.effectId, false)
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.title = nil
  param.content = propertyDesc
  param.alignObject = self
  param.width = 300
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

local function SetMaster(self, master)
  self.master = master
end

TacticalWeaponAttrLineItem.OnCreate = OnCreate
TacticalWeaponAttrLineItem.OnDestroy = OnDestroy
TacticalWeaponAttrLineItem.OnEnable = OnEnable
TacticalWeaponAttrLineItem.OnDisable = OnDisable
TacticalWeaponAttrLineItem.OnAddListener = OnAddListener
TacticalWeaponAttrLineItem.OnRemoveListener = OnRemoveListener
TacticalWeaponAttrLineItem.ComponentDefine = ComponentDefine
TacticalWeaponAttrLineItem.DataDefine = DataDefine
TacticalWeaponAttrLineItem.ComponentDestroy = ComponentDestroy
TacticalWeaponAttrLineItem.DataDestroy = DataDestroy
TacticalWeaponAttrLineItem.SetValue = SetValue
TacticalWeaponAttrLineItem.AnimValue = AnimValue
TacticalWeaponAttrLineItem.OnClickPropertyItem = OnClickPropertyItem
TacticalWeaponAttrLineItem.SetMaster = SetMaster
return TacticalWeaponAttrLineItem
