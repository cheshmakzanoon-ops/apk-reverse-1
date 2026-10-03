local UICraftEquipPage = BaseClass("UICraftEquipPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local EquipTemplate = require("DataCenter.EquipData.EquipTemplate")
local UIEquipDetailPropertyLineItem = require("UI.UIEquipMainPanel.Component.UIEquipDetailPropertyLineItem")
local UIEquipItem = require("UI.UIEquipMainPanel.Component.UIEquipItem")
local UICostItem = require("UI.UIEquipMainPanel.Component.UICostItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function CloseWindow(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEquipMainPanel)
end

local function SetCraftingEffectState(self, state)
  if self.craftingEffect and self.craftingEffectState ~= state then
    self.craftingEffect:SetActive(state)
    self.craftingEffectState = state
  end
end

local function UpdateCostResource(self)
  if not self.showCraftBtn then
    return
  end
  local costType = self.equipTemplateData.config:GetCostResourceType()
  self.costGoldIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(costType))
  local haveGoldCount = CommonUtil.GetResOrItemCount(costType)
  local costGoldCount = self.equipTemplateData.config:GetCostResourceNum()
  local gold = self.buildData:GetBuildEffect(EffectDefine.LW_PARTS_GOLD_REDUCE)
  gold = gold or 0
  costGoldCount = math.ceil(costGoldCount * (1 - gold))
  if haveGoldCount >= costGoldCount then
    self.costGoldCountText:SetColorRGBA(1, 1, 1, 1)
  else
    self.costGoldCountText:SetColorRGBA(0.937, 0, 0, 1)
  end
  self.costGoldCountText:SetText(string.GetFormattedStr(costGoldCount))
  if self.isCrafting then
    UIGray.SetGray(self.craftBtn.transform, true, true)
  else
    UIGray.SetGray(self.craftBtn.transform, false, true)
  end
end

local function UpdateCostItems(self)
  if self.costItems ~= nil then
    for _, item in pairs(self.costItems) do
      item:RefreshShowState()
    end
  end
end

local function OnResOrItemUpdate(self)
  UpdateCostItems(self)
  UpdateCostResource(self)
end

local function ClearEquipScroll(self)
  self.equipScroll:RemoveComponents(UIEquipItem)
  self.equipList:DestroyChildNode()
end

local function ClearCostItemScroll(self)
  self.costItems = {}
  self.costItemScroll:ClearCells()
  self.costItemScroll:RemoveComponents(UICostItem)
end

local function StopUpdateCraftingState(self)
  if self.updateTimer ~= nil then
    self.updateTimer:Stop()
    self.updateTimer = nil
  end
end

local function RefreshItemByConfigId(self, id)
  local equipItem = self.equipItems[id]
  if equipItem ~= nil then
    equipItem:SetData(id, self.buildingLv, BindCallback(self, self.OnSelectEquip))
    equipItem:SetSelected(self.selectedEquipId == id)
    equipItem:SetIsCrafting(self.curCraftingEquipId == id, self.isFinishCrafting)
  end
end

local function UpdateCraftingState(self)
  if self.buildData == nil then
    StopUpdateCraftingState(self)
    SetCraftingEffectState(self, false)
    return
  end
  self.isCrafting = BuildingUtils.IsBuildingFunctioning(self.buildData)
  self.isFinishCrafting = BuildingUtils.IsBuildingFinishFunctioning(self.buildData)
  if not self.isCrafting then
    StopUpdateCraftingState(self)
    SetCraftingEffectState(self, false)
    return
  end
  if self.isFinishCrafting then
    self.craftingStateText:SetLocalText(430749)
    self.craftingStateText:SetColorRGBA(1, 1, 1, 1)
    self.collectBtn:SetActive(true)
    self.accelerateBtn:SetActive(false)
    self.craftingStateSlider:SetValue(1)
    RefreshItemByConfigId(self, self.selectedEquipId)
    StopUpdateCraftingState(self)
    SetCraftingEffectState(self, false)
  else
    self.craftingStateText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(BuildingUtils.GetBuildingFunctioningRemainTime(self.buildData)))
    self.craftingStateSlider:SetValue(BuildingUtils.GetBuildilngFunctioningProgress(self.buildData))
    SetCraftingEffectState(self, true)
  end
end

local function StartUpdateCraftingState(self)
  if self.updateTimer == nil then
    self.updateTimer = TimerManager:GetInstance():GetTimer(1, UpdateCraftingState, self, false, false, false)
    self.updateTimer:Start()
    UpdateCraftingState(self)
  end
end

local function RefreshEquipCraftingState(self)
  local isSelectingCraftingEquip = self.curCraftingEquipId == self.equipTemplateData.configId
  if isSelectingCraftingEquip then
    self.craftBtn:SetActive(false)
    self.showCraftBtn = false
    self.lockCraftBtn:SetActive(false)
    self.accelerateBtn:SetActive(true)
    self.costItemScroll:SetActive(false)
    self.showCostItemScroll = false
    self.craftingEquipState:SetActive(true)
    if self.isFinishCrafting then
      self.accelerateBtn:SetActive(false)
      self.collectBtn:SetActive(true)
    else
      self.accelerateBtn:SetActive(true)
      self.collectBtn:SetActive(false)
    end
    if self.hasWorker then
      self.craftingStateText:SetColorRGBA(1, 1, 1, 1)
      StartUpdateCraftingState(self)
    else
      self.craftingStateText:SetColorRGBA(0.937, 0, 0, 1)
      UpdateCraftingState(self)
    end
    return true
  else
    self.accelerateBtn:SetActive(false)
    self.craftingEquipState:SetActive(false)
    self.collectBtn:SetActive(false)
    self.costItemScroll:SetActive(true)
    self.showCostItemScroll = true
    StopUpdateCraftingState(self)
    local isEquipUnlocked = self.equipTemplateData.config.unlock_Level <= self.buildingLv
    if isEquipUnlocked then
      self.lockCraftBtn:SetActive(false)
      self.craftBtn:SetActive(true)
      self.showCraftBtn = true
      local speedUpTime = self.buildData:GetBuildEffect(EffectDefine.LW_PARTS_MAKE_SPEED)
      speedUpTime = speedUpTime or 0
      local time = self.equipTemplateData.config.cost_Time / (1 + speedUpTime)
      self.costTimeCountText:SetText(UITimeManager:GetInstance():SecondToFmtString(time))
      UpdateCostResource(self)
    else
      self.lockCraftBtn:SetActive(true)
      self.craftBtn:SetActive(false)
      self.showCraftBtn = false
      self.unlockLevelText:SetLocalText(430710, self.equipTemplateData.config.unlock_Level)
    end
    SetCraftingEffectState(self, false)
    return false
  end
end

local function SelectEquip(self, equipId)
  if self.equipTemplateData ~= nil and self.equipTemplateData.configId == equipId then
    return
  end
  if self.equipTemplateData == nil then
    self.equipTemplateData = EquipInfo.New()
  end
  self.equipTemplateData:CreateFromTemplate(equipId)
  if self.equipTemplateData.config == nil then
    Logger.LogError("\232\163\133\229\164\135\232\161\168\228\184\173\230\178\161\230\156\137id\228\184\186" .. equipId .. "\231\154\132\232\163\133\229\164\135")
    return
  end
  self.equipNameText:SetLocalText(self.equipTemplateData.config.name)
  self.equipNameText:SetColor(UIUtil.GetColorByQuality(self.equipTemplateData.config.quality))
  self.equipIcon:LoadSprite(string.format(LoadPath.ItemPath, self.equipTemplateData.config.icon))
  self.equipIcon:SetNativeSize()
  local heroTypeIcon = HeroUtils.GetHeroTypeIcon(self.equipTemplateData.config.heroType)
  if string.IsNullOrEmpty(heroTypeIcon) then
    self.equipHeroTypeIcon:SetActive(false)
  else
    self.equipHeroTypeIcon:SetActive(true)
    self.equipHeroTypeIcon:LoadSprite(heroTypeIcon)
  end
  local heroTypeText = HeroUtils.GetHeroTypeText(self.equipTemplateData.config.heroType)
  if string.IsNullOrEmpty(heroTypeText) then
    self.equipHeroTypeText:SetActive(false)
  else
    self.equipHeroTypeText:SetActive(true)
    self.equipHeroTypeText:SetLocalText(heroTypeText)
  end
  self.equipPowerText:SetText(math.floor(self.equipTemplateData.power))
  self.allEquipWords = self.equipTemplateData:GetAllWordProperties()
  if self.allEquipWords == nil or #self.allEquipWords == 0 then
    self.propertyList:SetActive(false)
  else
    self.propertyList:SetActive(true)
    self.propertyList:SetListItemCount(#self.allEquipWords, false, false)
    self.propertyList:RefreshAllShownItem()
  end
  local costMaterials = self.equipTemplateData.config.cost_Items
  local costItemDataList = {}
  for materialId, materialCount in pairs(costMaterials) do
    local reosurceItemId = DataCenter.EquipMaterialDataManager:GetMaterialResourceItemId(materialId)
    table.insert(costItemDataList, {id = reosurceItemId, count = materialCount})
  end
  local count = #costItemDataList
  if count == 0 then
    self.costItemScroll:SetActive(false)
    self.showCostItemScroll = false
    self.costItems = {}
  else
    ClearCostItemScroll(self)
    self.costItemScroll:SetActive(true)
    self.showCostItemScroll = true
    self.costItemDataList = costItemDataList
    self.costItemScroll:SetTotalCount(count)
    self.costItemScroll:RefillCells()
  end
  local isCrafting = RefreshEquipCraftingState(self)
end

local function RefreshCurrentEquipShowData(self)
  self:UpdateCostItems()
  self:UpdateCostResource()
  self:RefreshEquipCraftingState()
end

local function OnSelectEquip(self, equipId, equipItem)
  if self.selectedEquipId == equipId then
    self:RefreshCurrentEquipShowData()
    return
  end
  local prevEquipId = self.selectedEquipId
  if prevEquipId ~= nil then
    local prevEquipItem = self.equipItems[prevEquipId]
    if prevEquipItem ~= nil then
      prevEquipItem:SetSelected(false)
    end
  end
  self.selectedEquipId = equipId
  equipItem:SetSelected(true)
  SelectEquip(self, equipId)
  self.selectedEquipId = equipId
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Select_Accessories, false)
end

local function OnInitEquipScroll(self, go, index)
  local item = self.equipScroll:AddComponent(UIEquipItem, go)
  self.equipListGO[go] = item
end

local function RefreshAllEquipItemInsight(self)
  for _, equipItem in pairs(self.equipItems) do
    local equipConfigId
    if equipItem.equipTemplate ~= nil then
      equipConfigId = equipItem.equipTemplate.id
      goto lbl_13
      goto lbl_36
      ::lbl_13::
      equipItem:SetData(equipConfigId, self.buildingLv, BindCallback(self, OnSelectEquip))
      equipItem:SetSelected(self.selectedEquipId == equipConfigId)
      equipItem:SetIsCrafting(self.curCraftingEquipId == equipConfigId, self.isFinishCrafting)
    end
    ::lbl_36::
  end
end

local function OnUpdateEquipScroll(self, go, index)
  local item = self.equipListGO[go]
  local equipConfigId = self.equipDataList[index + 1]
  item:SetActive(equipConfigId ~= nil)
  if equipConfigId ~= nil then
    item:SetData(equipConfigId, self.buildingLv, BindCallback(self, OnSelectEquip))
    item:SetSelected(self.selectedEquipId == equipConfigId)
    item:SetIsCrafting(self.curCraftingEquipId == equipConfigId, self.isFinishCrafting)
    self.equipItems[equipConfigId] = item
  end
end

local function OnDestroyEquipScrollItem(self, go, index)
  local equipConfigId = self.equipDataList[index + 1]
  if equipConfigId ~= nil then
    self.equipItems[equipConfigId] = nil
  end
end

local function OnCreateCostItem(self, itemObj, index)
  local data = self.costItemDataList[index]
  local id = data.id
  local costCount = data.count
  itemObj.name = id
  local cellItem = self.costItemScroll:AddComponent(UICostItem, itemObj)
  cellItem:SetData(id, costCount)
  self.costItems[id] = cellItem
end

local function OnDeleteCostItem(self, itemObj, index)
  self.costItemScroll:RemoveComponent(itemObj.name, UICostItem)
  self.costItems[itemObj.name] = nil
end

local function ClearPropertyScroll(self)
  self.propertyScroll:RemoveComponents(UIEquipDetailPropertyLineItem)
  self.propertyList:ClearAllItems()
end

local function OnGetPropertyItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.allEquipWords then
    return nil
  end
  local wordData = self.allEquipWords[index]
  local item = loopScroll:NewListViewItem("EquipPropertyLineItem")
  local script = self.propertyScroll:GetComponent(item.gameObject.name, UIEquipDetailPropertyLineItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.propertyScroll:AddComponent(UIEquipDetailPropertyLineItem, objectName)
  end
  script:SetActive(true)
  script:SetData(wordData, 1)
  self.propertyItems[index] = script
  return item
end

local function OnDestroy(self)
  StopUpdateCraftingState(self)
  ClearEquipScroll(self)
  ClearPropertyScroll(self)
  ClearCostItemScroll(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.curSelectedEquipType = nil
  self.equipTemplateData = nil
  self.allEquipWords = {}
  self.propertyItems = {}
  self.selectedEquipId = 0
  self.equipListGO = {}
  self.hasInitEquipList = false
  self.buildingLv = 0
  self.equipItems = {}
  self.itemIndex = 0
  self.updateTimer = nil
  self.showCostItemScroll = false
  self.costItems = {}
  self.craftingEffectState = false
end

local function DataDestroy(self)
  self.curSelectedEquipType = nil
  self.equipTemplateData = nil
  self.allEquipWords = nil
  self.propertyItems = nil
  self.selectedEquipId = 0
  self.equipListGO = nil
  self.hasInitEquipList = false
  self.costItemDataList = nil
  self.buildingLv = 0
  self.equipItems = nil
  self.itemIndex = 0
  self.updateTimer = nil
  self.showCostItemScroll = false
  self.costItems = nil
  self.craftingEffectState = false
end

local function RefreshEquipDataList(self, tabType)
  local typeEquipList = DataCenter.EquipTemplateManager:GetAllCanCraftTemplateBySlotType(tabType)
  local equipDataList = {}
  for k, v in pairs(typeEquipList) do
    table.insert(equipDataList, v.id)
  end
  
  local function sortFunc(a, b)
    local craftingEquipId = self.curCraftingEquipId
    if a == craftingEquipId then
      return true
    end
    if b == craftingEquipId then
      return false
    end
    local aEquipData = DataCenter.EquipTemplateManager:GetTemplate(a)
    local bEquipData = DataCenter.EquipTemplateManager:GetTemplate(b)
    if aEquipData == nil or bEquipData == nil then
      return false
    end
    local buildingLevel = self.buildingLv
    local aIsCanCraft = aEquipData:CanCraft(buildingLevel)
    local bIsCanCraft = bEquipData:CanCraft(buildingLevel)
    if aIsCanCraft and not bIsCanCraft then
      return true
    end
    if not aIsCanCraft and bIsCanCraft then
      return false
    end
    local aIsUnlock = buildingLevel >= aEquipData.unlock_Level
    local bIsUnlock = buildingLevel >= bEquipData.unlock_Level
    if aIsUnlock and not bIsUnlock then
      return true
    elseif not aIsUnlock and bIsUnlock then
      return false
    end
    if not aIsUnlock and not bIsUnlock and aEquipData.unlock_Level ~= bEquipData.unlock_Level then
      return aEquipData.unlock_Level < bEquipData.unlock_Level
    end
    if aEquipData.quality ~= bEquipData.quality then
      return aEquipData.quality > bEquipData.quality
    end
    if aEquipData.heroType ~= bEquipData.heroType then
      return aEquipData.heroType < bEquipData.heroType
    end
    return false
  end
  
  table.sort(equipDataList, sortFunc)
  self.equipDataList = equipDataList
end

local function selectTab(self, tabType)
  if self.curSelectedEquipType == tabType then
    self:RefreshCurrentEquipShowData()
    return
  end
  self.curSelectedEquipType = tabType
  for i = 1, #self.equipTypeTabs do
    local tab = self.equipTypeTabs[i]
    local icon = self.equipTypeIcons[i]
    if tabType == i then
      tab:SetEnable(true)
      icon:LoadSprite(string.format("Assets/Main/Sprites/UI/UIEquip/cfm_peijian_yeqian_tubiao_%d.png", i))
    else
      tab:SetEnable(false)
      icon:LoadSprite(string.format("Assets/Main/Sprites/UI/UIEquip/cfm_peijian_yeqian_tubiao_%d_1.png", i))
    end
  end
  RefreshEquipDataList(self, tabType)
  local count = #self.equipDataList
  if 0 < count then
    self.equipScroll:SetActive(true)
    if not self.hasInitEquipList then
      local bindFunc1 = BindCallback(self, OnInitEquipScroll)
      local bindFunc2 = BindCallback(self, OnUpdateEquipScroll)
      local bindFunc3 = BindCallback(self, OnDestroyEquipScrollItem)
      self.equipList:Init(bindFunc1, bindFunc2, bindFunc3)
    end
    self.hasInitEquipList = true
    self.equipList:SetItemCount(count)
    self.equipList:ForceUpdate()
    self.equipList:MoveItemByIndex(0)
    self.equipInfos:SetActive(true)
    local firstEquipItemId = self.equipDataList[1]
    local firstEquipItem = self.equipItems[firstEquipItemId]
    if firstEquipItem ~= nil then
      OnSelectEquip(self, firstEquipItemId, firstEquipItem)
    end
  else
    self.equipScroll:SetActive(false)
    self.equipInfos:SetActive(false)
  end
end

local function OnCraftBtnClick(self)
  if self.buildingUuid == nil or self.selectedEquipId == nil or self.selectedEquipId <= 0 then
    return
  end
  if self.isCrafting then
    UIUtil.ShowTipsId(430751)
    return
  end
  if self.equipTemplateData.config.unlock_Level > self.buildingLv then
    UIUtil.ShowTips(string.format("need building level %d", self.equipTemplateData.unlock_Level))
    return
  end
  local costType = self.equipTemplateData.config:GetCostResourceType()
  local haveGoldCount = CommonUtil.GetResOrItemCount(costType)
  local costGoldCount = self.equipTemplateData.config:GetCostResourceNum()
  if haveGoldCount < costGoldCount then
    local data = {}
    table.insert(data, {resType = costType, need = costGoldCount})
    LWResourceLackUtil:GotoResLack(data)
    return
  end
  local costItemDataList = self.costItemDataList
  for i = 1, #costItemDataList do
    local costItemData = costItemDataList[i]
    local itemDataCount = DataCenter.ResourceItemDataManager:GetCountByItemId(costItemData.id)
    if itemDataCount < costItemData.count then
      LWResourceLackUtil:GotoResourceItemLack(costItemData.id, costItemData.count)
      return
    end
  end
  SFSNetwork.SendMessage(MsgDefines.BuildingEquipMake, self.buildingUuid, self.selectedEquipId)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Craft_btn, false)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Crafting, false)
end

local function OnAccelerateBtnClick(self)
  if self.isCrafting then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, ItemSpdMenu.ItemSpdMenu_DuanZao, self.buildingUuid)
  end
end

local function UpdateProduceStatus(self)
  if self.buildingUuid ~= nil then
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildingUuid)
    self.buildingLv = self.buildData.level
    self.isCrafting = BuildingUtils.IsBuildingFunctioning(self.buildData)
    self.isFinishCrafting = BuildingUtils.IsBuildingFinishFunctioning(self.buildData)
    self.curCraftingEquipId = self.buildData.prodStatus
    self.hasWorker = true
  end
end

local function UpdateTabCraftingIcon(self)
  if self.isCrafting then
    local equipData = DataCenter.EquipTemplateManager:GetTemplate(self.curCraftingEquipId)
    if equipData ~= nil then
      self.curCraftingEquipType = equipData.slot
    end
    for i = 1, #self.equipTypeTabs do
      local tab = self.equipTypeTabs[i]
      local craftingIcon = self.equipCraftingIcon[i]
      if self.curCraftingEquipType == i then
        craftingIcon:SetActive(true)
      else
        craftingIcon:SetActive(false)
      end
    end
  else
    for i = 1, #self.equipTypeTabs do
      local craftingIcon = self.equipCraftingIcon[i]
      craftingIcon:SetActive(false)
    end
  end
end

local function OnUpdateBuildingData(self, buildingUuid)
  if self.buildingUuid == buildingUuid then
    UpdateProduceStatus(self)
    self:RefreshCurrentEquipShowData()
    RefreshEquipDataList(self, self.curSelectedEquipType)
    local index = table.indexof(self.equipDataList, self.selectedEquipId)
    self.equipList:ForceUpdate()
    self.equipList:MoveItemByIndex(index - 1)
    UpdateTabCraftingIcon(self)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function SetData(self)
  local defaultTab = EquipmentSlotType.Weapon
  self.curCraftingEquipId = nil
  SetCraftingEffectState(self, false)
  UpdateProduceStatus(self)
  UpdateTabCraftingIcon(self)
  selectTab(self, defaultTab)
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  StopUpdateCraftingState(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.OnUpdateBuildingData)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.OnUpdateBuildingData)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnResOrItemUpdate)
  self:RemoveUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
end

local function OnCollectBtnClick(self)
  if self.buildingUuid ~= nil then
    SFSNetwork.SendMessage(MsgDefines.BuildingCampCollect, self.buildingUuid)
  end
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.equipInfos = self:AddComponent(UIBaseContainer, "CenterInfo/EquipInfos")
  self.equipIcon = self:AddComponent(UIImage, "CenterInfo/EquipInfos/EquipIcon")
  self.equipNameText = self:AddComponent(UIText, "CenterInfo/EquipInfos/EquipNameText")
  self.equipHeroTypeIcon = self:AddComponent(UIImage, "CenterInfo/EquipInfos/EquipHeroTypeIcon")
  self.equipHeroTypeText = self:AddComponent(UIText, "CenterInfo/EquipInfos/EquipHeroTypeText")
  self.equipPowerText = self:AddComponent(UIText, "CenterInfo/EquipInfos/EquipPowerGroup/PowerText")
  self.propertyScroll = self:AddComponent(UIBaseContainer, "CenterInfo/EquipInfos/PropertyScroll/Viewport/PropertyContent")
  self.propertyList = self:AddComponent(UILoopListView2, "CenterInfo/EquipInfos/PropertyScroll")
  self.propertyList:InitListView(0, function(loopView, index)
    return OnGetPropertyItemByIndex(self, loopView, index)
  end)
  self.costItemScroll = self:AddComponent(UIScrollView, "CenterInfo/EquipInfos/ItemScrollView")
  self.costItemList = self:AddComponent(UIBaseContainer, "CenterInfo/EquipInfos/ItemScrollView/Viewport/ItemContent")
  self.costItemScroll:SetOnItemMoveIn(function(itemObj, index)
    OnCreateCostItem(self, itemObj, index)
  end)
  self.costItemScroll:SetOnItemMoveOut(function(itemObj, index)
    OnDeleteCostItem(self, itemObj, index)
  end)
  self.weaponEquipTabBtn = self:AddComponent(UIButton, "CenterInfo/EquipTemplateArea/EquipTabs/WeaponTab")
  self.weaponEquipTabIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/WeaponTab/WeaponSelectedBg")
  self.weaponCraftingIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/WeaponTab/WeaponCraftingIcon")
  self.weaponEquipTabBtn:SetOnClick(function()
    selectTab(self, EquipmentSlotType.Weapon)
  end)
  self.armorEquipTabBtn = self:AddComponent(UIButton, "CenterInfo/EquipTemplateArea/EquipTabs/ArmorTab")
  self.armorEquipTabIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/ArmorTab/ArmorSelectedBg")
  self.aromorCraftingIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/ArmorTab/ArmorCraftingIcon")
  self.armorEquipTabBtn:SetOnClick(function()
    selectTab(self, EquipmentSlotType.Armor)
  end)
  self.coreEquipTabBtn = self:AddComponent(UIButton, "CenterInfo/EquipTemplateArea/EquipTabs/CoreTab")
  self.coreEquipTabIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/CoreTab/CoreSelectedBg")
  self.coreCraftingIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/CoreTab/CoreCraftingIcon")
  self.coreEquipTabBtn:SetOnClick(function()
    selectTab(self, EquipmentSlotType.Core)
  end)
  self.radarEquipTabBtn = self:AddComponent(UIButton, "CenterInfo/EquipTemplateArea/EquipTabs/RadarTab")
  self.radarEquipTabIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/RadarTab/RadarSelectedBg")
  self.radarCraftingIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/RadarTab/RadarCraftingIcon")
  self.radarEquipTabBtn:SetOnClick(function()
    selectTab(self, EquipmentSlotType.Radar)
  end)
  self.equipTypeTabs = {
    self.weaponEquipTabIcon,
    self.armorEquipTabIcon,
    self.coreEquipTabIcon,
    self.radarEquipTabIcon
  }
  self.equipCraftingIcon = {
    self.weaponCraftingIcon,
    self.aromorCraftingIcon,
    self.coreCraftingIcon,
    self.radarCraftingIcon
  }
  self.weaponIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/WeaponTab/WeaponIcon")
  self.armorIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/ArmorTab/ArmorIcon")
  self.coreIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/CoreTab/CoreIcon")
  self.radarIcon = self:AddComponent(UIImage, "CenterInfo/EquipTemplateArea/EquipTabs/RadarTab/RadarIcon")
  self.equipTypeIcons = {
    self.weaponIcon,
    self.armorIcon,
    self.coreIcon,
    self.radarIcon
  }
  self.equipScroll = self:AddComponent(UIBaseContainer, "CenterInfo/EquipTemplateArea/EquipScroll")
  self.equipList = self:AddComponent(GridInfinityScrollView, "CenterInfo/EquipTemplateArea/EquipScroll/EquipContent")
  self.craftBtn = self:AddComponent(UIButton, "BottomInfo/CraftBtn")
  self.craftBtnText = self:AddComponent(UIText, "BottomInfo/CraftBtn/CraftBtnText")
  self.craftBtn:SetOnClick(function()
    OnCraftBtnClick(self)
  end)
  self.costGoldCountText = self:AddComponent(UIText, "BottomInfo/CraftBtn/CostGold/CostGoldCountText")
  self.costGoldIcon = self:AddComponent(UIImage, "BottomInfo/CraftBtn/CostGold/GoldIcon")
  self.costTimeCountText = self:AddComponent(UIText, "BottomInfo/CraftBtn/CostTime/CostTimeCountText")
  self.lockCraftBtn = self:AddComponent(UIBaseContainer, "BottomInfo/LockCraftBtn")
  self.lockCraftRealBtn = self:AddComponent(UIButton, "BottomInfo/LockCraftBtn")
  self.lockCraftBtnText = self:AddComponent(UIText, "BottomInfo/LockCraftBtn/LockCraftBtnText")
  self.unlockLevelText = self:AddComponent(UIText, "BottomInfo/LockCraftBtn/UnlockLevelText")
  self.accelerateBtn = self:AddComponent(UIButton, "BottomInfo/AccelerateBtn")
  self.accelerateBtnText = self:AddComponent(UIText, "BottomInfo/AccelerateBtn/AccelerateBtnText")
  self.accelerateBtn:SetOnClick(function()
    OnAccelerateBtnClick(self)
  end)
  self.craftingEquipState = self:AddComponent(UIBaseContainer, "CenterInfo/EquipInfos/CraftingState")
  self.craftingStateText = self:AddComponent(UIText, "CenterInfo/EquipInfos/CraftingState/CraftingStateText")
  self.craftingStateSlider = self:AddComponent(UISlider, "CenterInfo/EquipInfos/CraftingState/craftingSlider")
  self.collectBtn = self:AddComponent(UIButton, "BottomInfo/CollectBtn")
  self.collectBtnText = self:AddComponent(UIText, "BottomInfo/CollectBtn/CollectBtnText")
  self.collectBtn:SetOnClick(function()
    OnCollectBtnClick(self)
  end)
  self.craftingEffect = self:AddComponent(UIBaseContainer, "CenterInfo/EquipInfos/CraftingEffect")
  if CommonUtil.IsArabicAutoMirrorOpen() then
    if not IsNull(self.craftingEffect.transform) then
      self.craftingEffect.transform:Set_localScale(-1, 1, 1)
    end
  elseif not IsNull(self.craftingEffect.transform) then
    self.craftingEffect.transform:Set_localScale(1, 1, 1)
  end
  UIGray.SetGray(self.lockCraftRealBtn.transform, true, false)
  self.craftBtnText:SetLocalText(430709)
  self.lockCraftBtnText:SetLocalText(430709)
  self.accelerateBtnText:SetLocalText(430711)
  self.collectBtnText:SetLocalText(430753)
end

local function ComponentDestroy(self)
  self.root = nil
  self.equipInfos = nil
  self.equipIcon = nil
  self.equipNameText = nil
  self.equipHeroTypeIcon = nil
  self.equipHeroTypeText = nil
  self.equipPowerText = nil
  self.propertyScroll = nil
  self.propertyList = nil
  self.costItemScroll = nil
  self.costItemList = nil
  self.weaponEquipTabBtn = nil
  self.weaponEquipTabIcon = nil
  self.weaponCraftingIcon = nil
  self.armorEquipTabBtn = nil
  self.armorEquipTabIcon = nil
  self.aromorCraftingIcon = nil
  self.coreEquipTabBtn = nil
  self.coreEquipTabIcon = nil
  self.coreCraftingIcon = nil
  self.radarEquipTabBtn = nil
  self.radarEquipTabIcon = nil
  self.radarCraftingIcon = nil
  self.equipTypeTabs = nil
  self.equipCraftingIcon = nil
  self.weaponIcon = nil
  self.armorIcon = nil
  self.coreIcon = nil
  self.radarIcon = nil
  self.equipTypeIcons = nil
  self.equipScroll = nil
  self.equipList = nil
  self.craftBtn = nil
  self.craftBtnText = nil
  self.costGoldCountText = nil
  self.costGoldIcon = nil
  self.costTimeCountText = nil
  self.lockCraftBtn = nil
  self.lockCraftRealBtn = nil
  self.lockCraftBtnText = nil
  self.unlockLevelText = nil
  self.accelerateBtn = nil
  self.accelerateBtnText = nil
  self.craftingEquipState = nil
  self.craftingStateText = nil
  self.craftingStateSlider = nil
  self.collectBtn = nil
  self.collectBtnText = nil
  self.craftingEffect = nil
end

UICraftEquipPage.OnCreate = OnCreate
UICraftEquipPage.OnDestroy = OnDestroy
UICraftEquipPage.OnEnable = OnEnable
UICraftEquipPage.OnDisable = OnDisable
UICraftEquipPage.DataDefine = DataDefine
UICraftEquipPage.DataDestroy = DataDestroy
UICraftEquipPage.ComponentDefine = ComponentDefine
UICraftEquipPage.ComponentDestroy = ComponentDestroy
UICraftEquipPage.OnAddListener = OnAddListener
UICraftEquipPage.OnRemoveListener = OnRemoveListener
UICraftEquipPage.OnSelectEquip = OnSelectEquip
UICraftEquipPage.OnUpdateBuildingData = OnUpdateBuildingData
UICraftEquipPage.OnResOrItemUpdate = OnResOrItemUpdate
UICraftEquipPage.UpdateCostItems = UpdateCostItems
UICraftEquipPage.UpdateCostResource = UpdateCostResource
UICraftEquipPage.RefreshEquipCraftingState = RefreshEquipCraftingState
UICraftEquipPage.RefreshCurrentEquipShowData = RefreshCurrentEquipShowData
UICraftEquipPage.SetData = SetData
return UICraftEquipPage
