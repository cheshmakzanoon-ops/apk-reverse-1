local base = UIBaseContainer
local EquipSlotItemComponent = BaseClass("EquipSlotItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function EquipSlotItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function EquipSlotItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function EquipSlotItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.imgUnWear = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgQuality = self.viewSkin:AddComponent(self, UIImage, 3)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textEquipLevelTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgRedPoint = self.viewSkin:AddComponent(self, UIImage, 6)
  self.imgQuality:SetActive(false)
  self.imgIcon:SetActive(false)
  self.textEquipLevelTxt:SetActive(false)
end

function EquipSlotItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnClick = nil
  self.imgUnWear = nil
  self.imgQuality = nil
  self.imgIcon = nil
  self.textEquipLevelTxt = nil
  self.imgRedPoint = nil
end

function EquipSlotItemComponent:DataDefine()
end

function EquipSlotItemComponent:DataDestroy()
  self.slotIndex = 0
  self.slotData = nil
  self.clickAction = nil
end

function EquipSlotItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function EquipSlotItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function EquipSlotItemComponent:OnBtnClickClick()
  if self.clickAction then
    local slotIndex = self.slotIndex or 0
    self.clickAction(slotIndex)
  end
end

function EquipSlotItemComponent:Refresh(slotIndex, slotData, itemClickAction, showRed)
  self.slotIndex = slotIndex
  self.slotData = slotData
  self.clickAction = itemClickAction
  self.imgRedPoint:SetActive(showRed)
  if not (slotData and slotData.uuid) or slotData.uuid == 0 then
    self.imgUnWear:SetActive(true)
    self.imgQuality:SetActive(false)
    self.imgIcon:SetActive(false)
    self.textEquipLevelTxt:SetActive(false)
  else
    self.imgUnWear:SetActive(false)
    self.imgQuality:SetActive(true)
    self.imgQuality:LoadSprite(DataCenter.LWSkyBattleGrowthChapterManager:GetQualityIcon(tonumber(slotData.quality)))
    self.imgIcon:SetActive(true)
    self.imgIcon:LoadSprite(slotData.icon)
    self.textEquipLevelTxt:SetActive(true)
    self.textEquipLevelTxt:SetText(string.format("Lv.%d", slotData.level))
  end
end

return EquipSlotItemComponent
