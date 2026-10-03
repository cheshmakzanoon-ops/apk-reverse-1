local base = UIBaseContainer
local SkyBattleDetailEquipPropertyItemComponent = BaseClass("SkyBattleDetailEquipPropertyItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SkyBattleDetailEquipPropertyItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SkyBattleDetailEquipPropertyItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkyBattleDetailEquipPropertyItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compEffUiUpgrade = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compEffUiUpgrade:SetActive(false)
end

function SkyBattleDetailEquipPropertyItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textName = nil
  self.textValue = nil
  self.compEffUiUpgrade = nil
end

function SkyBattleDetailEquipPropertyItemComponent:DataDefine()
end

function SkyBattleDetailEquipPropertyItemComponent:DataDestroy()
end

function SkyBattleDetailEquipPropertyItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function SkyBattleDetailEquipPropertyItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SkyBattleDetailEquipPropertyItemComponent:Refresh(propertyData)
  if not propertyData then
    return
  end
  self.compEffUiUpgrade:SetActive(false)
  self.compEffUiUpgrade:SetActive(true)
  self.textName:SetLocalText(DataCenter.LWSkyBattleGrowthChapterManager:GetEquipPropertyNameKey(propertyData.type))
  local value = propertyData.value
  if propertyData.type == SkyBattleEquipType.MemberPropPercent then
    self.textValue:SetText(string.format("%d%%", math.ceil(tonumber(value) * 0.01)))
  else
    self.textValue:SetText(string.GetFormattedStr(value))
  end
end

return SkyBattleDetailEquipPropertyItemComponent
