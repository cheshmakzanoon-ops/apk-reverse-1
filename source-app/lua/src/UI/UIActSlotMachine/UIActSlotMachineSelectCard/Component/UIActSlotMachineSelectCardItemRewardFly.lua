local UIActSlotMachineSelectCardItemRewardFly = BaseClass("UIActSlotMachineSelectCardItemRewardFly", UIBaseContainer)
local M = UIActSlotMachineSelectCardItemRewardFly
local base = UIBaseContainer
local CardQualityType = ActSlotMachineSelectCardQualityType

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function M:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:ComponentDefine()
  self.simAnimTrailRoot = self:AddComponent(UISimpleAnimation, "")
  self.imgIconTrailIcon = self:AddComponent(UIImage, "icon_root/ItemIcon")
  self.compEffectTrailPurple = self:AddComponent(UIBaseContainer, "icon_root/Eff_ui_trail_purple")
  self.compEffectTrailOrange = self:AddComponent(UIBaseContainer, "icon_root/Eff_ui_trail_gold")
  self.compEffectCardOrange = self:AddComponent(UIBaseContainer, "icon_root/Eff_ui_valentine_boxopen_explode_Variant")
end

function M:ComponentDestroy()
  self.simAnimTrailRoot = nil
  self.imgIconTrailIcon = nil
  self.compEffectTrailPurple = nil
  self.compEffectTrailOrange = nil
  self.compEffectCardOrange = nil
end

function M:SetData(cardShowData)
  local curQualityType = cardShowData.qualityType
  self.compEffectTrailPurple:SetActive(curQualityType == CardQualityType.PurpleType)
  self.compEffectTrailOrange:SetActive(curQualityType == CardQualityType.OrangeType)
  self.compEffectCardOrange:SetActive(curQualityType == CardQualityType.OrangeType)
  self.simAnimTrailRoot:SampleAnimationAtTime("Default", 0)
  self.simAnimTrailRoot:Play("Default")
  local iconPath = DataCenter.RewardManager:GetPicByType(tonumber(cardShowData.rewardType), tonumber(cardShowData.itemId))
  self.imgIconTrailIcon:LoadSprite(iconPath)
end

function M:PlayOutAnim()
  self.simAnimTrailRoot:SampleAnimationAtTime("Out", 0)
  self.simAnimTrailRoot:Play("Out")
end

return M
