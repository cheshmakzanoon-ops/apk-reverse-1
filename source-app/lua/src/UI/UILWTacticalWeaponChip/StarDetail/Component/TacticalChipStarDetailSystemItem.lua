local TacticalChipStarDetailSystemItem = BaseClass("TacticalChipStarDetailSystemItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.imgBg = self:AddComponent(UIImage, "bg")
  self.compProgressBg = self:AddComponent(UIBaseContainer, "progressBg")
  self.compProgress = self:AddComponent(UIBaseContainer, "progressBg/progress")
  self.compCurProFlag = self:AddComponent(UIBaseContainer, "curProFlag")
  self.compUnlockFlag = self:AddComponent(UIBaseContainer, "unlockFlag")
  self.compLockFlag = self:AddComponent(UIBaseContainer, "lockFlag")
  self.textCurProFlagNum = self:AddComponent(UIText, "curProFlag/curProFlagNum")
  self.textUnlockFlagNum = self:AddComponent(UIText, "unlockFlag/unlockFlagNum")
  self.textLockFlagNum = self:AddComponent(UIText, "lockFlag/lockFlagNum")
  self.textDesc = self:AddComponent(UIText, "desc")
end

local function ComponentDestroy(self)
  self.imgBg = nil
  self.compProgressBg = nil
  self.compProgress = nil
  self.compCurProFlag = nil
  self.compUnlockFlag = nil
  self.compLockFlag = nil
  self.textCurProFlagNum = nil
  self.textUnlockFlagNum = nil
  self.textLockFlagNum = nil
  self.textDesc = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TacticalChipStarDetailSystemItem:SetData(index, systemTierEffectValue, chipId, totalNum)
  local systemTierValue = DataCenter.TacticalChipManager:GetSystemTierEffectValue()
  local chipTemplate = DataCenter.TWSkillChipTemplateManager:GetTemplate(chipId)
  self.compCurProFlag:SetActive(false)
  self.compUnlockFlag:SetActive(false)
  self.compLockFlag:SetActive(false)
  self.compProgress:SetActive(false)
  self.textDesc:SetText(chipTemplate:GetTacticalChipDesc(systemTierEffectValue))
  self.compProgress:SetOffsetMinXY(1, 0)
  self.compProgress:SetOffsetMaxXY(-1, 0)
  self.compProgressBg:SetSizeDeltaXY(9.8, 130)
  self.compProgressBg:SetAnchoredPositionXY(-324, 0)
  if index == 1 then
    local sizeDelta = self.compProgressBg:GetSizeDelta()
    local anchorPos = self.compProgressBg:GetAnchoredPosition()
    sizeDelta.y = sizeDelta.y - 10
    anchorPos.y = anchorPos.y - 10
    self.compProgressBg:SetSizeDelta(sizeDelta)
    self.compProgressBg:SetAnchoredPosition(anchorPos)
  elseif index == totalNum then
    local sizeDelta = self.compProgressBg:GetSizeDelta()
    sizeDelta.y = sizeDelta.y - 10
    self.compProgressBg:SetSizeDelta(sizeDelta)
  end
  local statusValueStr = string.format("+%s", systemTierEffectValue)
  if systemTierValue == systemTierEffectValue then
    self.compCurProFlag:SetActive(true)
    self.textCurProFlagNum:SetText(statusValueStr)
    self.imgBg:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_xiangqiang_lv.png")
    self.compProgress:SetOffsetMinXY(1, 10)
    self.compProgress:SetOffsetMaxXY(-1, 0)
    self.textDesc:SetColorRGBA255(210, 227, 255, 255)
    self.compProgress:SetActive(true)
  elseif systemTierEffectValue < systemTierValue then
    self.compUnlockFlag:SetActive(true)
    self.textUnlockFlagNum:SetText(statusValueStr)
    self.imgBg:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_xiangqiang_hui.png")
    self.compProgress:SetActive(true)
    self.textDesc:SetColorRGBA255(130, 141, 191, 255)
  else
    self.compLockFlag:SetActive(true)
    self.textLockFlagNum:SetText(statusValueStr)
    self.imgBg:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_xiangqiang_hui.png")
    self.textDesc:SetColorRGBA255(130, 141, 191, 255)
  end
end

TacticalChipStarDetailSystemItem.OnCreate = OnCreate
TacticalChipStarDetailSystemItem.OnDestroy = OnDestroy
TacticalChipStarDetailSystemItem.OnEnable = OnEnable
TacticalChipStarDetailSystemItem.OnDisable = OnDisable
TacticalChipStarDetailSystemItem.ComponentDefine = ComponentDefine
TacticalChipStarDetailSystemItem.ComponentDestroy = ComponentDestroy
TacticalChipStarDetailSystemItem.DataDefine = DataDefine
TacticalChipStarDetailSystemItem.DataDestroy = DataDestroy
TacticalChipStarDetailSystemItem.OnAddListener = OnAddListener
TacticalChipStarDetailSystemItem.OnRemoveListener = OnRemoveListener
return TacticalChipStarDetailSystemItem
