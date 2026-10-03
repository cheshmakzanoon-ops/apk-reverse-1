local base = UIBaseContainer
local AllianceUseSkillItemView = BaseClass("AllianceUseSkillItemView", base)
local AllianceSkillConditionItem = require("UI.LWSeasonShared.UIAllianceCommonSkill.Component.AllianceSkillConditionItem")
local img_icon_path = "info/img_kuang/img_icon"
local txt_desc_path = "info/sv/Content/txt_desc"
local txt_name_path = "go_name/txt_name"
local go_condition_path = "condition"
local btn_use_path = "bottom/btn_use"
local go_item_condition_path = "condition/item_condition"
local img_line2_path = "condition/img_line2"
local img_line1_path = "condition/img_line1"
local btn_info_path = "go_name/btn_info"

function AllianceUseSkillItemView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.conditionView = {}
end

function AllianceUseSkillItemView:OnDestroy()
  self.conditionView = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceUseSkillItemView:ComponentDefine()
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_desc = self:AddComponent(UIText, txt_desc_path)
  self.txt_name = self:AddComponent(UIText, txt_name_path)
  self.go_condition = self:AddComponent(UIBaseContainer, go_condition_path)
  self.btn_use = self:AddComponent(UIButton, btn_use_path)
  self.go_item_condition = self:AddComponent(UIBaseContainer, go_item_condition_path)
  self.img_line2 = self:AddComponent(UIImage, img_line2_path)
  self.img_line1 = self:AddComponent(UIImage, img_line1_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.pool_condition = self.go_item_condition.gameObject
  self.pool_condition:GameObjectCreatePool()
  self.btn_use:SetOnClick(BindCallback(self, self.ClickUse))
  self.btn_info:SetOnClick(BindCallback(self, self.ClickInfo))
end

function AllianceUseSkillItemView:ComponentDestroy()
  self.pool_condition:GameObjectRecycleAll()
  self.pool_condition = nil
  self.img_icon = nil
  self.txt_desc = nil
  self.txt_name = nil
  self.go_condition = nil
  self.btn_use = nil
  self.go_item_condition = nil
  self.img_line2 = nil
  self.img_line1 = nil
  self.btn_info = nil
end

function AllianceUseSkillItemView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAllianceGovernmentCommonSkillList, self.RefreshCondition)
  self:AddUIListener(EventId.UpdateAllianceGovernmentCommonEnergyList, self.RefreshCondition)
end

function AllianceUseSkillItemView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateAllianceGovernmentCommonSkillList, self.RefreshCondition)
  self:RemoveUIListener(EventId.UpdateAllianceGovernmentCommonEnergyList, self.RefreshCondition)
  base.OnRemoveListener(self)
end

function AllianceUseSkillItemView:ClickUse()
  self.data:ToUse()
end

function AllianceUseSkillItemView:ClickInfo()
  if not self.data then
    return
  end
  local config = self.data.config
  local param = {}
  param.activityRulesStr = CS.GameEntry.Localization:GetString(config.rule)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function AllianceUseSkillItemView:ReInit(data)
  self.data = data
  local config = data.config
  self.img_icon:LoadSpriteAsync(config.skill_icon)
  self.txt_desc:SetLocalText(config.desc)
  self.txt_name:SetLocalText(config.name)
  self.pool_condition:GameObjectRecycleAll()
  local hasLock = (data.config.prerequisites_effect or 0) ~= 0
  if hasLock then
    local conditionItem = self:AddCondition()
    conditionItem:ReEffectLock(data)
    self.conditionView[1] = conditionItem
  end
  local conditionItem = self:AddCondition()
  conditionItem:ReEnergyCost(data)
  self.conditionView[2] = conditionItem
  conditionItem = self:AddCondition()
  conditionItem:RefreshCD(data)
  self.conditionView[3] = conditionItem
  self.img_line1:SetAsLastSibling()
  self.img_line2:SetAsLastSibling()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txt_desc.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txt_desc.transform.parent)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txt_desc.transform.parent.parent)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txt_desc.transform.parent.parent.parent)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.conditionView[1].transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.conditionView[2].transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.conditionView[3].transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.go_condition.transform.parent)
end

function AllianceUseSkillItemView:AddCondition()
  local goItem = self.pool_condition:GameObjectSpawn(self.go_condition.transform)
  local name = UIUtil.GetLoopListItemIndex()
  goItem.gameObject.name = name
  return self.go_condition:AddComponent(AllianceSkillConditionItem, name)
end

function AllianceUseSkillItemView:RefreshCondition()
  if self.conditionView then
    if self.conditionView[1] then
      self.conditionView[1]:ReEffectLock(self.data)
    end
    if self.conditionView[2] then
      self.conditionView[2]:ReEnergyCost(self.data)
    end
    if self.conditionView[3] then
      self.conditionView[3]:RefreshCD(self.data)
    end
  end
end

return AllianceUseSkillItemView
