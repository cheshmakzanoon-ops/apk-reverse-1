local base = UIBaseContainer
local TacticalChipFactoryDecomposePage = BaseClass("TacticalChipFactoryDecomposePage", UIBaseContainer)
local TacticalChipItem = require("UI.UILWTacticalWeaponChip.Component.TacticalChipItem")
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local Localization = CS.GameEntry.Localization

function TacticalChipFactoryDecomposePage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitTab()
end

function TacticalChipFactoryDecomposePage:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalChipFactoryDecomposePage:ComponentDefine()
  self.textDecomposeTitle = self:AddComponent(UIText, "Top/decomposeTitle")
  self.textPreviewTips = self:AddComponent(UIText, "Top/previewTips")
  self.textSelectTips = self:AddComponent(UIText, "Top/selectTips")
  self.textDecomposeTips = self:AddComponent(UIText, "Top/decomposeTips")
  self.compPropsPreviewLayoutNode = self:AddComponent(UIBaseContainer, "Top/propsPreviewLayoutNode")
  self.compChipListNode = self:AddComponent(UIBaseContainer, "Middle/chipListNode")
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, "Middle/chipListNode/ItemHolder")
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  self.compItemContent = self:AddComponent(UIBaseContainer, "Middle/chipListNode/ItemHolder/Viewport/ItemContent")
  self.compTabTank = self:AddComponent(UICommonTab, "Middle/chipListNode/tabRoot/tabTank")
  self.compTabMissile = self:AddComponent(UICommonTab, "Middle/chipListNode/tabRoot/tabMissile")
  self.compTabAir = self:AddComponent(UICommonTab, "Middle/chipListNode/tabRoot/tabAir")
  self.textNoChipTip = self:AddComponent(UIText, "Middle/chipListNode/noChipTip")
  self.textNoChipTip:SetLocalText("battlesystem_factory_inventory_desc1")
  self.btnDecompose = self:AddComponent(UIButton, "Bottom/decomposeBtn")
  self.btnDecompose:SetOnClick(function()
    self:OnBtnDecomposeClick()
  end)
  self.textDecomposeBtn = self:AddComponent(UIText, "Bottom/decomposeBtn/Btn/decomposeBtnText")
end

function TacticalChipFactoryDecomposePage:ComponentDestroy()
  if self.compItemContent then
    self.compItemContent:RemoveComponents(TacticalChipItem)
  end
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  self.textDecomposeTitle = nil
  self.textPreviewTips = nil
  self.textSelectTips = nil
  self.textDecomposeTips = nil
  self.compPropsPreviewLayoutNode = nil
  self.compChipListNode = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.compTabTank = nil
  self.compTabMissile = nil
  self.compTabAir = nil
  self.textNoChipTip = nil
  self.btnDecompose = nil
  self.textDecomposeBtn = nil
end

function TacticalChipFactoryDecomposePage:DataDefine()
  self.previewPropsMap = {}
  self.curSelectChipIdMap = {}
end

function TacticalChipFactoryDecomposePage:DataDestroy()
  self.previewPropsMap = nil
  self.curSelectChipIdMap = nil
end

function TacticalChipFactoryDecomposePage:OnEnable()
  base.OnEnable(self)
end

function TacticalChipFactoryDecomposePage:OnDisable()
  self.curSelectChipId = nil
  self.curTab = nil
  base.OnDisable(self)
end

function TacticalChipFactoryDecomposePage:OnAddListener()
  base.OnAddListener(self)
end

function TacticalChipFactoryDecomposePage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TacticalChipFactoryDecomposePage:ReInit(buildingUuid)
  self:OnTabClick(self.compTabTank)
end

function TacticalChipFactoryDecomposePage:InitTab()
  local tabTankParam = {}
  tabTankParam.tabId = HeroType.Tank
  tabTankParam.clickHandler = self.OnTabClick
  self.compTabTank:ReInit(tabTankParam)
  self.compTabTank:SetSelect(false)
  local tabMissileParam = {}
  tabMissileParam.tabId = HeroType.Missile
  tabMissileParam.clickHandler = self.OnTabClick
  self.compTabMissile:ReInit(tabMissileParam)
  self.compTabMissile:SetSelect(false)
  local tabAirParam = {}
  tabAirParam.tabId = HeroType.Aircraft
  tabAirParam.clickHandler = self.OnTabClick
  self.compTabAir:ReInit(tabAirParam)
  self.compTabAir:SetSelect(false)
end

function TacticalChipFactoryDecomposePage:RefreshDataList()
  if self.curTab == nil then
    return
  end
  self.chipsDataList = DataCenter.TacticalChipFactoryManager:GetCanDecomposeChipDataList(self.curTab.tabId)
  local dataCount = #self.chipsDataList
  self.loopGridViewItemHolder:SetActive(0 < dataCount)
  self.textNoChipTip:SetActive(dataCount <= 0)
  self.loopGridViewItemHolder:SetListItemCount(dataCount)
  self.loopGridViewItemHolder:RefreshAllShownItem()
end

function TacticalChipFactoryDecomposePage:OnGetItemByRowColumn(loopScroll, index)
  if self.chipsDataList ~= nil then
    local count = #self.chipsDataList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("TacticalChipItem")
    local script = self.compItemContent:GetComponent(item.gameObject.name, TacticalChipItem)
    if script == nil then
      local name = "chips_" .. index
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(TacticalChipItem, name)
      script:SetOnClick(function(chipTemplateId)
        self:OnChipItemClick(chipTemplateId)
      end)
    end
    local data = self.chipsDataList[index]
    script:SetTemplate(data.id)
    script:SetActive(true)
    script:SetLockedVisible(data:IsLock(self.buildingLv))
    script:SetProductSelectedVisible(data.id == self.curSelectChipId)
    script:SetProductFlagVisible(data.id == self.craftingChipId and self.curStatus == TacticalChipFactoryStatus.Working)
    return item
  end
end

function TacticalChipFactoryDecomposePage:OnChipItemClick()
end

function TacticalChipFactoryDecomposePage:OnTabClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  self:RefreshDataList()
end

function TacticalChipFactoryDecomposePage:OnBtnDecomposeClick()
end

return TacticalChipFactoryDecomposePage
