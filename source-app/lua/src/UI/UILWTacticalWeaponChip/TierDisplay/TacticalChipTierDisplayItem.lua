local TacticalChipTierDisplayItem = BaseClass("TacticalChipTierDisplayItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function TacticalChipTierDisplayItem:OnCreate()
  base.OnCreate(self)
  self.imgBgTitle = self:AddComponent(UIImage, "bgTitle")
  self.imgBg1 = self:AddComponent(UIImage, "bg1")
  self.textTitle = self:AddComponent(UIText, "title")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.textDesc:OnPointerClick(function(eventData)
    DataCenter.TacticalChipManager.UITextClickTips(eventData, self.textDesc)
  end)
  self.compCurTierFlag = self:AddComponent(UIBaseContainer, "curTierFlag")
  self.compCurTierFlag:SetActive(false)
end

function TacticalChipTierDisplayItem:OnDestroy()
  self.imgBgTitle = nil
  self.imgBg1 = nil
  self.textTitle = nil
  self.textDesc = nil
  self.compCurTierFlag = nil
  base.OnDestroy(self)
end

function TacticalChipTierDisplayItem:SetData(template)
  self.textTitle:SetLocalText(template.tierDisplayTitle)
  self.textDesc:SetLocalText(template.tierDisplayDesc)
  self.imgBg1:LoadSprite(DataCenter.TacticalChipManager:GetTierDisplayDescBgPath(template.id))
  self.imgBgTitle:LoadSprite(DataCenter.TacticalChipManager:GetTierDisplayTitleBgPath(template.id))
  self.template = template
end

function TacticalChipTierDisplayItem:SetShowFlag(tier)
  self.compCurTierFlag:SetActive(tier == self.template.id)
end

return TacticalChipTierDisplayItem
