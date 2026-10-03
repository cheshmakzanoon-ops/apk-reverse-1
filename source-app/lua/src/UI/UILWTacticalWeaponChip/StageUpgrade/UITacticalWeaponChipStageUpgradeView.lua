local UITacticalWeaponChipStageUpgradeView = BaseClass("UITacticalWeaponChipStageUpgradeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local unlock_plan_item_path = "Root/top/layout/unlockPlanItem"
local unlock_attribute_item_path = "Root/top/layout/unlockAttributeItem"
local bg_btn_path = "Root/BgBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnReInit()
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
  self.textUnlockPlanItemDesc = self:AddComponent(UITextMeshProUGUIEx, "Root/top/layout/unlockPlanItem/unlockPlanItemDesc")
  self.textUnlockAttributeItemDesc = self:AddComponent(UITextMeshProUGUIEx, "Root/top/layout/unlockAttributeItem/unlockAttributeItemDesc")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/top/title")
  self.textTitle:SetLocalText("battlesystem_tier_up1")
  self.textCurStageTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/top/curStageTitle")
  self.textNextStageTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/top/nextStageTitle")
  self.textClickTip = self:AddComponent(UITextMeshProUGUIEx, "Root/top/clickTip")
  self.textClickTip:SetLocalText("battlesystem_tier_up4")
  self.unlock_plan_item = self:AddComponent(UIBaseContainer, unlock_plan_item_path)
  self.unlock_attribute_item = self:AddComponent(UIBaseContainer, unlock_attribute_item_path)
  self.bg_btn = self:AddComponent(UIButton, bg_btn_path)
  self.bg_btn:SetOnClick(function()
    EventManager:GetInstance():Broadcast(EventId.TacticalChipStageUpgradeUIClose, {
      id = self.unlockNewPlanId
    })
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.textUnlockPlanItemDesc = nil
  self.textUnlockAttributeItemDesc = nil
  self.textTitle = nil
  self.textCurStageTitle = nil
  self.textNextStageTitle = nil
  self.textClickTip = nil
  self.unlock_plan_item = nil
  self.unlock_attribute_item = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.isUnlockNewPlan = nil
end

function UITacticalWeaponChipStageUpgradeView:OnReInit()
  local oldTier, newTier = self:GetUserData()
  local oldConfig = DataCenter.TacticalChipManager:GetTierTemplate(oldTier)
  local newConfig = DataCenter.TacticalChipManager:GetTierTemplate(newTier)
  local oldColorArray = oldConfig.tier_color
  local newColorArray = newConfig.tier_color
  self.textCurStageTitle:SetColorRGBA255(oldColorArray[1], oldColorArray[2], oldColorArray[3], oldColorArray[4])
  self.textCurStageTitle:SetLocalText(oldConfig.tier_name)
  self.textNextStageTitle:SetColorRGBA255(newColorArray[1], newColorArray[2], newColorArray[3], newColorArray[4])
  self.textNextStageTitle:SetLocalText(newConfig.tier_name)
  self.isUnlockNewPlan = newConfig.chip_set_unlock ~= oldConfig.chip_set_unlock
  self.unlock_plan_item:SetActive(self.isUnlockNewPlan)
  if self.isUnlockNewPlan then
    self.textUnlockPlanItemDesc:SetLocalText("battlesystem_tier_up2", newConfig.chip_set_unlock)
    self.unlockNewPlanId = newConfig.chip_set_unlock
  end
  local effectConfigOld = DataCenter.EffectNumberTemplateManager:GetTemplate(oldConfig.effectId)
  local title = Localization:GetString(effectConfigOld.name)
  self.textUnlockAttributeItemDesc:SetLocalText("battlesystem_tier_up3", title, oldConfig.effectValue, newConfig.effectValue)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

UITacticalWeaponChipStageUpgradeView.OnCreate = OnCreate
UITacticalWeaponChipStageUpgradeView.OnDestroy = OnDestroy
UITacticalWeaponChipStageUpgradeView.OnEnable = OnEnable
UITacticalWeaponChipStageUpgradeView.OnDisable = OnDisable
UITacticalWeaponChipStageUpgradeView.ComponentDefine = ComponentDefine
UITacticalWeaponChipStageUpgradeView.ComponentDestroy = ComponentDestroy
UITacticalWeaponChipStageUpgradeView.DataDefine = DataDefine
UITacticalWeaponChipStageUpgradeView.DataDestroy = DataDestroy
UITacticalWeaponChipStageUpgradeView.OnAddListener = OnAddListener
UITacticalWeaponChipStageUpgradeView.OnRemoveListener = OnRemoveListener
return UITacticalWeaponChipStageUpgradeView
