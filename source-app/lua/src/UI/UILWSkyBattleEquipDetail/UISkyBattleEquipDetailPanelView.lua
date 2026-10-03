local UISkyBattleEquipDetailPanelView = BaseClass("UISkyBattleEquipDetailPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local EquipSlotItemComponent = require("UI.UILWStageSkyBattleChapter.Components.EquipSlotItemComponent")
local SkyBattleDetailEquipPropertyItemComponent = require("UI.UILWSkyBattleEquipDetail.Components.SkyBattleDetailEquipPropertyItemComponent")

function UISkyBattleEquipDetailPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshEquip()
end

function UISkyBattleEquipDetailPanelView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISkyBattleEquipDetailPanelView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compEquipSlotItem = self.viewSkin:AddComponent(self, EquipSlotItemComponent, 3)
  self.textEquipName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textEquipLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnReplace = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnReplace:SetOnClick(function()
    self:OnBtnReplaceClick()
  end)
  self.btnTakeOff = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnTakeOff:SetOnClick(function()
    self:OnBtnTakeOffClick()
  end)
  self.btnUpgrade = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.textGoldCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compPropertyItem1 = self.viewSkin:AddComponent(self, SkyBattleDetailEquipPropertyItemComponent, 11)
  self.compPropertyItem4 = self.viewSkin:AddComponent(self, SkyBattleDetailEquipPropertyItemComponent, 12)
  self.compPropertyItem3 = self.viewSkin:AddComponent(self, SkyBattleDetailEquipPropertyItemComponent, 13)
  self.compPropertyItem2 = self.viewSkin:AddComponent(self, SkyBattleDetailEquipPropertyItemComponent, 14)
  self.textTipEquipMaxLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.compUpgradeCostGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.textEquipLevel:SetActive(false)
  self.textTitle:SetLocalText(151126)
  self.textTipEquipMaxLevel:SetLocalText("NoKey-MaxLevel")
end

function UISkyBattleEquipDetailPanelView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compEquipSlotItem = nil
  self.textEquipName = nil
  self.textEquipLevel = nil
  self.textPower = nil
  self.btnReplace = nil
  self.btnTakeOff = nil
  self.btnUpgrade = nil
  self.textGoldCount = nil
  self.compPropertyItem1 = nil
  self.compPropertyItem4 = nil
  self.compPropertyItem3 = nil
  self.compPropertyItem2 = nil
  self.textTipEquipMaxLevel = nil
  self.compUpgradeCostGroup = nil
end

function UISkyBattleEquipDetailPanelView:DataDefine()
  self.slotData = self:GetUserData()
  self.propertiesItems = {}
  self.slotTakeOffArray = {}
  table.insert(self.propertiesItems, self.compPropertyItem1)
  table.insert(self.propertiesItems, self.compPropertyItem2)
  table.insert(self.propertiesItems, self.compPropertyItem3)
  table.insert(self.propertiesItems, self.compPropertyItem4)
end

function UISkyBattleEquipDetailPanelView:DataDestroy()
  self.slotData = nil
  self.propertiesItems = nil
  self.slotTakeOffArray = nil
  self.levelUPEnough = nil
end

function UISkyBattleEquipDetailPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkyBattleEquipUnInstall, self.OnBtnCloseClick)
  self:AddUIListener(EventId.SkyBattleEquipInstall, self.OnBtnCloseClick)
  self:AddUIListener(EventId.SkyBattleEquipSlotUpgrade, self.OnSlotUpgrade)
end

function UISkyBattleEquipDetailPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.SkyBattleEquipUnInstall, self.OnBtnCloseClick)
  self:RemoveUIListener(EventId.SkyBattleEquipInstall, self.OnBtnCloseClick)
  self:RemoveUIListener(EventId.SkyBattleEquipSlotUpgrade, self.OnSlotUpgrade)
  base.OnRemoveListener(self)
end

function UISkyBattleEquipDetailPanelView:RefreshEquip()
  self.compPropertyItem1:SetActive(false)
  self.compPropertyItem2:SetActive(false)
  self.compPropertyItem4:SetActive(false)
  self.compPropertyItem3:SetActive(false)
  self.btnUpgrade:SetActive(false)
  self.btnReplace:SetActive(false)
  self.btnTakeOff:SetActive(false)
  if not self.slotData or not self.slotData.equipInfo then
    self.compEquipSlotItem:SetActive(false)
  else
    self.compEquipSlotItem:SetActive(true)
    local hasRed = false
    local slotHighPowerData = DataCenter.LWSkyBattleGrowthChapterManager:GetLocationTopPowerData(self.slotData.slot)
    if not (not slotHighPowerData or self.slotData.equipInfo) or slotHighPowerData and self.slotData.equipInfo and slotHighPowerData.power > self.slotData.equipInfo.power then
      hasRed = true
    end
    self.compEquipSlotItem:Refresh(self.slotData.slot, self.slotData, nil, hasRed)
    self.textEquipName:SetLocalText(self.slotData.name)
    self.textPower:SetText(string.GetFormattedStr(self.slotData.power))
    local properties = self.slotData.properties
    local propertyItemIndex = 1
    if properties then
      for type, propertyData in pairs(properties) do
        self.propertiesItems[propertyItemIndex]:Refresh(propertyData)
        self.propertiesItems[propertyItemIndex]:SetActive(true)
        propertyItemIndex = propertyItemIndex + 1
      end
    end
    local notEnough = self.slotData.upgradeChip > DataCenter.LWSkyBattleGrowthChapterManager.userInfo.coin
    local textColor = notEnough and "<color=#f26a67>" or "<color=#ffffff>"
    self.textGoldCount:SetText(string.format("%s%s</color>", textColor, string.GetFormattedStr(self.slotData.upgradeChip)))
    local maxLevel = DataCenter.LWSkyBattleGrowthChapterManager:GetEquipGroupMaxLevel(self.slotData.equipInfo.group)
    local hasNextLevel = maxLevel > self.slotData.level
    self.levelUPEnough = not notEnough
    self.textTipEquipMaxLevel:SetActive(not hasNextLevel)
    self.compUpgradeCostGroup:SetActive(hasNextLevel)
    self.btnUpgrade:SetActive(hasNextLevel)
    self.btnReplace:SetActive(true)
    self.btnTakeOff:SetActive(true)
  end
end

function UISkyBattleEquipDetailPanelView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UISkyBattleEquipDetailPanelView:OnSlotUpgrade(slots)
  if not self.slotData then
    return
  end
  if not slots then
    return
  end
  for i, slot in ipairs(slots) do
    if self.slotData.slot and self.slotData.slot == slot then
      self:RefreshEquip()
      break
    end
  end
end

function UISkyBattleEquipDetailPanelView:OnBtnReplaceClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.SkyBattleEquipReplaceListPanel, {anim = true}, self.slotData)
end

function UISkyBattleEquipDetailPanelView:OnBtnTakeOffClick()
  if not self.slotData then
    return
  end
  if not self.slotData.slot or self.slotData.slot == 0 then
    return
  end
  self.slotTakeOffArray[1] = self.slotData.slot
  SFSNetwork.SendMessage(MsgDefines.UserSkyBattleEquipUninstall, self.slotTakeOffArray)
end

function UISkyBattleEquipDetailPanelView:OnBtnUpgradeClick()
  if not self.slotData then
    return
  end
  if not self.slotData.slot or self.slotData.slot == 0 then
    return
  end
  if self.levelUPEnough then
    SFSNetwork.SendMessage(MsgDefines.UserSkyBattleSlotUpgrade, self.slotData.slot)
  else
    local param = {}
    param.resType = ResourceType.SkyBattleGold
    param.need = self.slotData.upgradeChip
    UIManager:GetInstance():OpenWindow(UIWindowNames.SkyBattleResourceLackView, {anim = true}, param)
  end
end

return UISkyBattleEquipDetailPanelView
