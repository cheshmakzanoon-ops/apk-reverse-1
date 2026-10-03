local UIDecomposeEquipPage = BaseClass("UIDecomposeEquipPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local UIEquipItem = require("UI.UIEquipMainPanel.Component.UIDecomposeEquipItem")
local UIEquipMaterialGroup = require("UI.UIEquipMainPanel.Component.UIEquipMaterialGroup")
local UIQuickSelectBtn = require("UI.UIEquipMainPanel.Component.UIQuickSelectBtn")
local decomposeBtnTextPath = "BottomInfo/DecomposeBtn/DecomposeBtnText"
local descTextPath = "CenterInfo/EquipArea/DescText"
local quickSelectBarTextPath = "CenterInfo/EquipArea/QuickSelectBar/BtnText"
local quickSelectBarBtnPath = "CenterInfo/EquipArea/QuickSelectBar"
local quickSelectBarIconPath = "CenterInfo/EquipArea/QuickSelectBar/MenuBtn/Icon"
local quickSelectMenuPath = "QuickSelectMenu"
local quickSelectMenuBgPanelPath = "QuickSelectMenu/Panel"
local quickSelectMenuGreenBtnPath = "QuickSelectMenu/Root/GreenQualityBtn"
local quickSelectMenuBlueBtnPath = "QuickSelectMenu/Root/BlueQualityBtn"
local quickSelectMenuPurpleBtnPath = "QuickSelectMenu/Root/PurpleQualityBtn"
local emptyMaterialContentPath = "CenterInfo/MaterialArea/EmptyMaterialContent"
local emptyEquipContentPath = "CenterInfo/EquipArea/EmptyEquipContent"
local QuickSelectState = {
  Green = 1,
  Blue = 2,
  Purple = 3
}
local DefaultQuickSelectStateKey = "DefaultQuickSelectState"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ProcessDataToViewData(self)
  self.materialsViewData = {}
  if not table.IsNullOrEmpty(self.returnMaterials) then
    for category, materials in pairs(self.returnMaterials) do
      local materialsData = {}
      for materialId, count in pairs(materials) do
        local materialData = {}
        materialData.id = materialId
        materialData.count = count
        table.insert(materialsData, materialData)
      end
      table.sort(materialsData, function(a, b)
        local aData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(a.id)
        local bData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(b.id)
        return aData.quality > bData.quality
      end)
      local materialGroupData = {}
      materialGroupData.category = category
      materialGroupData.materials = materialsData
      if self.returnStoneCount and self.returnStoneCount > 0 then
        table.insert(materialGroupData.materials, {
          count = self.returnStoneCount,
          id = ResourceItemId.EquipStrengtheningStone
        })
      end
      table.insert(self.materialsViewData, materialGroupData)
    end
    table.sort(self.materialsViewData, function(a, b)
      return a.category < b.category
    end)
  end
  local count = #self.materialsViewData
  if 0 < count then
    self.emptyMaterialContent:SetActive(false)
    self.materialList:SetActive(true)
    self.materialList:SetListItemCount(#self.materialsViewData, false, false)
    self.materialList:RefreshAllShownItem()
  else
    self.emptyMaterialContent:SetActive(true)
    self.materialList:SetActive(false)
  end
end

local function ClearAllSelectedEquip(self)
  self.selectedEquipList = {}
  self.returnMaterials = {}
  self.returnStoneCount = 0
end

local function OnSelectEquip(self, equipData, RefershView)
  local material, stoneCount = {}, 0
  if self.cacheEquipReturn[equipData.uuid] == nil then
    material, stoneCount = equipData:GetBreakReturnMaterialAndItems()
    self.cacheEquipReturn[equipData.uuid] = {material = material, stoneCount = stoneCount}
  else
    material = self.cacheEquipReturn[equipData.uuid].material
    stoneCount = self.cacheEquipReturn[equipData.uuid].stoneCount
  end
  for materialId, count in pairs(material) do
    local category = DataCenter.EquipMaterialDataManager:GetMaterialCategory(materialId)
    if self.returnMaterials[category] == nil then
      self.returnMaterials[category] = {}
    end
    if self.returnMaterials[category][materialId] == nil then
      self.returnMaterials[category][materialId] = 0
    end
    self.returnMaterials[category][materialId] = self.returnMaterials[category][materialId] + count
  end
  self.returnStoneCount = self.returnStoneCount + stoneCount
  if RefershView then
    ProcessDataToViewData(self)
  end
end

local function OnDeselectEquip(self, equipData)
  local material, stoneCount = {}, 0
  if self.cacheEquipReturn[equipData.uuid] == nil then
    material, stoneCount = equipData:GetBreakReturnMaterialAndItems()
    self.cacheEquipReturn[equipData.uuid] = {material = material, stoneCount = stoneCount}
  else
    material = self.cacheEquipReturn[equipData.uuid].material
    stoneCount = self.cacheEquipReturn[equipData.uuid].stoneCount
  end
  for materialId, count in pairs(material) do
    local category = DataCenter.EquipMaterialDataManager:GetMaterialCategory(materialId)
    if self.returnMaterials[category] ~= nil then
      if self.returnMaterials[category][materialId] ~= nil then
        self.returnMaterials[category][materialId] = self.returnMaterials[category][materialId] - count
      end
      if 0 >= self.returnMaterials[category][materialId] then
        self.returnMaterials[category][materialId] = nil
      end
      if 0 >= table.count(self.returnMaterials[category]) then
        self.returnMaterials[category] = nil
      end
    end
  end
  self.returnStoneCount = self.returnStoneCount - stoneCount
  if 0 > self.returnStoneCount then
    self.returnStoneCount = 0
  end
  ProcessDataToViewData(self)
end

local function OnInitEquipScroll(self, go, index)
  local item = self.equipScroll:AddComponent(UIEquipItem, go)
  self.equipListGO[go] = item
end

local function OnClickEquipItem(self, equipData, item)
  local selectedState = self.selectedEquipList[equipData.uuid]
  if selectedState == nil then
    selectedState = false
  end
  selectedState = not selectedState
  self.selectedEquipList[equipData.uuid] = selectedState
  item:SetSelected(selectedState)
  if equipData then
    if selectedState then
      OnSelectEquip(self, equipData, true)
    else
      OnDeselectEquip(self, equipData)
    end
  end
end

local function OnUpdateEquipScroll(self, go, index)
  local item = self.equipListGO[go]
  local equipUuid = self.equipDataList[index + 1]
  item:SetActive(equipUuid ~= nil)
  if equipUuid ~= nil then
    item:SetData(equipUuid, BindCallback(self, OnClickEquipItem))
    item:SetSelected(self.selectedEquipList[equipUuid] == true)
    self.equipItems[equipUuid] = item
  end
end

local function OnDestroyEquipScrollItem(self, go, index)
  local equipUuid = self.equipDataList[index + 1]
  if equipUuid ~= nil then
    self.equipItems[equipUuid] = nil
  end
end

local function RefreshEquipDataList(self)
  local unsedEquipTable = DataCenter.EquipDataManager:GetAllUnusedEquipList(true)
  self.equipDataList = {}
  for _, v in pairs(unsedEquipTable) do
    table.insert(self.equipDataList, v.uuid)
  end
  table.sort(self.equipDataList, function(a, b)
    local aEquip = DataCenter.EquipDataManager:GetEquipByUuid(a)
    local bEquip = DataCenter.EquipDataManager:GetEquipByUuid(b)
    if aEquip.config.quality ~= bEquip.config.quality then
      return aEquip.config.quality < bEquip.config.quality
    end
    if aEquip.level ~= bEquip.level then
      return aEquip.level < bEquip.level
    end
    if aEquip.config.slot ~= bEquip.config.slot then
      return aEquip.config.slot < bEquip.config.slot
    end
    if aEquip.config.heroType ~= bEquip.config.heroType then
      return aEquip.config.heroType < bEquip.config.heroType
    end
    return aEquip.config.id < bEquip.config.id
  end)
  local count = #self.equipDataList
  if self.equipDataList == nil or count <= 0 then
    self.equipList:SetActive(false)
    self.emptyEquipContent:SetActive(true)
  else
    self.equipList:SetActive(true)
    self.emptyEquipContent:SetActive(false)
    if not self.hasInitEquipList then
      local bindFunc1 = BindCallback(self, OnInitEquipScroll)
      local bindFunc2 = BindCallback(self, OnUpdateEquipScroll)
      local bindFunc3 = BindCallback(self, OnDestroyEquipScrollItem)
      self.equipList:Init(bindFunc1, bindFunc2, bindFunc3)
    end
    self.hasInitEquipList = true
    self.equipList:SetItemCount(count)
    self.equipList:ForceUpdate()
  end
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.materialsViewData then
    return nil
  end
  local materialGroup = self.materialsViewData[index]
  local item = loopScroll:NewListViewItem("EquipMaterialGroup")
  local script = self.materialContent:GetComponent(item.gameObject.name, UIEquipMaterialGroup)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.materialContent:AddComponent(UIEquipMaterialGroup, objectName)
  end
  script:SetActive(true)
  script:SetData(materialGroup, nil)
  self.materialGroupItems[materialGroup.category] = script
  return item
end

local function ClearMaterialList(self)
  self.materialContent:RemoveComponents(UIEquipMaterialGroup)
  self.materialList:ClearAllItems()
  self.materialsViewData = {}
end

local function ClearEquipList(self)
  self.equipScroll:RemoveComponents(UIEquipItem)
  self.equipList:DestroyChildNode()
end

local function UpdateData(self)
  self.returnMaterials = {}
  self.returnStoneCount = 0
  self.selectedEquipList = {}
  ClearMaterialList(self)
  RefreshEquipDataList(self)
  ProcessDataToViewData(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.EquipDecompose, UpdateData)
  self:AddUIListener(EventId.OnFinishHandleInitMsg, UpdateData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.EquipDecompose, UpdateData)
  self:RemoveUIListener(EventId.OnFinishHandleInitMsg, UpdateData)
  base.OnRemoveListener(self)
end

local function OnDestroy(self)
  ClearMaterialList(self)
  ClearEquipList(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDestroy(self)
  self.hasInitEquipList = nil
  self.equipItems = nil
  self.equipListGO = nil
  self.selectedEquipList = nil
  self.returnMaterials = nil
  self.materialsViewData = nil
  self.returnStoneCount = nil
  self.cacheEquipReturn = nil
  self.materialGroupItems = nil
  self.itemIndex = nil
  self.quickSelectState = nil
  self.quickSelectMenuActive = nil
  self.hasInitQuickSelect = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function GetAllSelectedEquipUuids(self)
  local uuids = {}
  for id, state in pairs(self.selectedEquipList) do
    if state then
      table.insert(uuids, id)
    end
  end
  return uuids
end

local function OnDecomposeBtn(self)
  local uuids = GetAllSelectedEquipUuids(self)
  if not table.IsNullOrEmpty(uuids) then
    local hasPurpleEquip = false
    for _, uuid in ipairs(uuids) do
      local equip = DataCenter.EquipDataManager:GetEquipByUuid(uuid)
      if equip and equip.config.quality >= 5 then
        hasPurpleEquip = true
        break
      end
    end
    
    local function DecomposeEquip()
      SFSNetwork.SendMessage(MsgDefines.HeroEquipDecompose, uuids)
    end
    
    if hasPurpleEquip then
      UIUtil.ShowMessage(Localization:GetString("430761"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, DecomposeEquip)
    else
      DecomposeEquip()
    end
  end
end

local function ShowQuickSelectMenu(self)
  self.quickSelectMenu:SetActive(true)
  self.quickSelectBarIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2")
  self.quickSelectMenuActive = true
end

local function HideQuickSelectMenu(self)
  self.quickSelectMenu:SetActive(false)
  self.quickSelectBarIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1")
  self.quickSelectMenuActive = false
end

local function QuickSelectEquipByQuality(self, quality, SetDefaultState)
  for id, btn in pairs(self.quickSelectMenuBtns) do
    if id == quality then
      btn:SetSelected(true)
    else
      btn:SetSelected(false)
    end
  end
  HideQuickSelectMenu(self)
  if SetDefaultState then
    CS.GameEntry.Setting:SetInt(DefaultQuickSelectStateKey, quality)
  end
  if not self.hasInitEquipList then
    return
  end
  ClearAllSelectedEquip(self)
  if table.IsNullOrEmpty(self.equipDataList) then
    return
  end
  for _, equipUuid in pairs(self.equipDataList) do
    local equipData = DataCenter.EquipDataManager:GetEquipByUuid(equipUuid)
    if not table.IsNullOrEmpty(equipData) and equipData.config.quality <= quality + 1 then
      self.selectedEquipList[equipUuid] = true
      OnSelectEquip(self, equipData, false)
    end
  end
  ProcessDataToViewData(self)
  self.equipList:ForceUpdate()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Click_Action, false)
end

local function DataDefine(self)
  self.hasInitEquipList = false
  self.equipItems = {}
  self.equipListGO = {}
  self.selectedEquipList = {}
  self.returnMaterials = {}
  self.materialsViewData = {}
  self.returnStoneCount = 0
  self.cacheEquipReturn = {}
  self.materialGroupItems = {}
  self.itemIndex = 0
  self.quickSelectState = nil
  self.quickSelectMenuActive = false
  self.hasInitQuickSelect = false
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.equipScroll = self:AddComponent(UIBaseContainer, "CenterInfo/EquipArea/EquipScroll")
  self.equipList = self:AddComponent(GridInfinityScrollView, "CenterInfo/EquipArea/EquipScroll/EquipContent")
  self.materialContent = self:AddComponent(UIBaseContainer, "CenterInfo/MaterialArea/MaterialGroupScroll/Viewport/MaterialGroupScrollContent")
  self.materialList = self:AddComponent(UILoopListView2, "CenterInfo/MaterialArea/MaterialGroupScroll")
  self.materialList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.decomposeBtn = self:AddComponent(UIButton, "BottomInfo/DecomposeBtn")
  self.decomposeBtn:SetOnClick(function()
    OnDecomposeBtn(self)
  end)
  self.decomposeBtnText = self:AddComponent(UIText, decomposeBtnTextPath)
  self.descText = self:AddComponent(UIText, descTextPath)
  self.quickSelectBarBtn = self:AddComponent(UIButton, quickSelectBarBtnPath)
  self.quickSelectBarBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Click_Action, false)
    if self.quickSelectMenu.activeSelf then
      HideQuickSelectMenu(self)
    else
      ShowQuickSelectMenu(self)
    end
  end)
  self.quickSelectBarText = self:AddComponent(UIText, quickSelectBarTextPath)
  self.quickSelectBarIcon = self:AddComponent(UIImage, quickSelectBarIconPath)
  self.quickSelectBarText:SetLocalText(430721)
  self.quickSelectMenu = self:AddComponent(UIBaseContainer, quickSelectMenuPath)
  self.qcuickSelectMenuBgPanelBtn = self:AddComponent(UIButton, quickSelectMenuBgPanelPath)
  self.qcuickSelectMenuBgPanelBtn:SetOnClick(function()
    HideQuickSelectMenu(self)
  end)
  self.quickSelectMenuGreenBtn = self:AddComponent(UIQuickSelectBtn, quickSelectMenuGreenBtnPath)
  self.quickSelectMenuGreenBtn:SetClickCallBack(function()
    QuickSelectEquipByQuality(self, QuickSelectState.Green, true)
  end)
  self.quickSelectMenuGreenBtn:SetLanguageText(430722)
  self.quickSelectMenuGreenBtn:SetSelected(false)
  self.quickSelectMenuBlueBtn = self:AddComponent(UIQuickSelectBtn, quickSelectMenuBlueBtnPath)
  self.quickSelectMenuBlueBtn:SetClickCallBack(function()
    QuickSelectEquipByQuality(self, QuickSelectState.Blue, true)
  end)
  self.quickSelectMenuBlueBtn:SetLanguageText(430723)
  self.quickSelectMenuBlueBtn:SetSelected(false)
  self.quickSelectMenuPurpleBtn = self:AddComponent(UIQuickSelectBtn, quickSelectMenuPurpleBtnPath)
  self.quickSelectMenuPurpleBtn:SetClickCallBack(function()
    QuickSelectEquipByQuality(self, QuickSelectState.Purple, true)
  end)
  self.quickSelectMenuPurpleBtn:SetLanguageText(430724)
  self.quickSelectMenuPurpleBtn:SetSelected(false)
  self.quickSelectMenuBtns = {
    [QuickSelectState.Green] = self.quickSelectMenuGreenBtn,
    [QuickSelectState.Blue] = self.quickSelectMenuBlueBtn,
    [QuickSelectState.Purple] = self.quickSelectMenuPurpleBtn
  }
  self.emptyMaterialContent = self:AddComponent(UIBaseContainer, emptyMaterialContentPath)
  self.emptyEquipContent = self:AddComponent(UIBaseContainer, emptyEquipContentPath)
  self.decomposeBtnText:SetLocalText(430703)
  self.descText:SetLocalText(430755)
end

local function ComponentDestroy(self)
  self.root = nil
  self.equipScroll = nil
  self.equipList = nil
  self.materialContent = nil
  self.materialList = nil
  self.decomposeBtn = nil
  self.decomposeBtnText = nil
  self.descText = nil
  self.quickSelectBarBtn = nil
  self.quickSelectBarText = nil
  self.quickSelectBarIcon = nil
  self.quickSelectMenu = nil
  self.qcuickSelectMenuBgPanelBtn = nil
  self.quickSelectMenuGreenBtn = nil
  self.quickSelectMenuBlueBtn = nil
  self.quickSelectMenuPurpleBtn = nil
  self.quickSelectMenuBtns = nil
  self.emptyMaterialContent = nil
  self.emptyEquipContent = nil
end

local function SetData(self)
  RefreshEquipDataList(self)
  ProcessDataToViewData(self)
  if not self.hasInitQuickSelect then
    self.hasInitQuickSelect = true
    local defaultQuality = CS.GameEntry.Setting:GetInt(DefaultQuickSelectStateKey, QuickSelectState.Green)
    self:QuickSelectEquipByQuality(defaultQuality, false)
  end
end

UIDecomposeEquipPage.OnCreate = OnCreate
UIDecomposeEquipPage.OnDestroy = OnDestroy
UIDecomposeEquipPage.OnEnable = OnEnable
UIDecomposeEquipPage.OnDisable = OnDisable
UIDecomposeEquipPage.DataDefine = DataDefine
UIDecomposeEquipPage.DataDestroy = DataDestroy
UIDecomposeEquipPage.ComponentDefine = ComponentDefine
UIDecomposeEquipPage.ComponentDestroy = ComponentDestroy
UIDecomposeEquipPage.SetData = SetData
UIDecomposeEquipPage.OnAddListener = OnAddListener
UIDecomposeEquipPage.OnRemoveListener = OnRemoveListener
UIDecomposeEquipPage.QuickSelectEquipByQuality = QuickSelectEquipByQuality
return UIDecomposeEquipPage
