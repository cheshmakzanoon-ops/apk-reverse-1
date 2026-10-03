local LWUIDesertBattleSoldierTreatmentInfoItem = BaseClass("LWUIDesertBattleSoldierTreatmentInfoItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local soldier_quality_image_path = "SoldierQualityImage"
local soldier_icon_image_path = "SoldierQualityImage/SoldierIconImage"
local soldier_level_text_path = "SoldierQualityImage/SoldierLevelText"
local treatment_num_text_path = "TreatmentNumText"
local awaiting_treatment_num_text_path = "AwaitingTreatmentNumText"
local total_injuries_num_text_path = "TotalInjuriesNumText"

function LWUIDesertBattleSoldierTreatmentInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIDesertBattleSoldierTreatmentInfoItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIDesertBattleSoldierTreatmentInfoItem:ComponentDefine()
  self.soldier_quality_image = self:AddComponent(UIImage, soldier_quality_image_path)
  self.soldier_icon_image = self:AddComponent(UIImage, soldier_icon_image_path)
  self.soldier_level_text = self:AddComponent(UIText, soldier_level_text_path)
  self.treatment_num_text = self:AddComponent(UIText, treatment_num_text_path)
  self.awaiting_treatment_num_text = self:AddComponent(UIText, awaiting_treatment_num_text_path)
  self.total_injuries_num_text = self:AddComponent(UIText, total_injuries_num_text_path)
end

function LWUIDesertBattleSoldierTreatmentInfoItem:ComponentDestroy()
  self.soldier_quality_image = nil
  self.soldier_icon_image = nil
  self.soldier_level_text = nil
  self.treatment_num_text = nil
  self.awaiting_treatment_num_text = nil
  self.total_injuries_num_text = nil
end

function LWUIDesertBattleSoldierTreatmentInfoItem:ReInit(data)
  self.data = data
  local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(self.data.armyId)
  if soldierTemplate ~= nil then
    self.soldier_icon_image:LoadSpriteAuto(string.format(LoadPath.ItemPath, soldierTemplate.icon))
    self.soldier_quality_image:LoadSpriteAuto(UIUtil.GetItemQualityBg(soldierTemplate.quality))
    self.soldier_level_text:SetText("Lv." .. soldierTemplate.lv)
  end
  self.treatment_num_text:SetText(tostring(self.data.finishNum))
  self.awaiting_treatment_num_text:SetText(tostring(self.data.needCureNum))
  self.total_injuries_num_text:SetText(tostring(self.data.deadTotal))
end

return LWUIDesertBattleSoldierTreatmentInfoItem
