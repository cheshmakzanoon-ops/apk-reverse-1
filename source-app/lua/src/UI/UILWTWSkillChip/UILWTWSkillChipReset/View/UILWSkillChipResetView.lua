local UILWSkillChipResetView = BaseClass("UILWSkillChipResetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local SkillChipResetItem = require("UI.UILWTWSkillChip.UILWTWSkillChipReset.Component.SkillChipResetItem")
local SkillChipResultSmallItem = require("UI.UILWTWSkillChip.UILWTWSkillChipUpgrade.Component.SkillChipSelectSmallItem")
local TacticalChipItem = require("UI.UILWTacticalWeaponChip.Component.TacticalChipItem")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local result_scroll_path = "PopUpTitle/Common_bg_orange2/Content/ResultArea/ResultScroll"
local result_content_path = "PopUpTitle/Common_bg_orange2/Content/ResultArea/ResultScroll/Viewport/ResultContent"
local chip_scroll_path = "PopUpTitle/Common_bg_orange2/Content/CenterInfo/ChipScroll"
local chip_content_path = "PopUpTitle/Common_bg_orange2/Content/CenterInfo/ChipScroll/Viewport/ChipContent"
local decompose_btn_path = "PopUpTitle/DecomposeBtn"
local empty_result_text_path = "PopUpTitle/Common_bg_orange2/Content/ResultArea/EmptyResultText"
local empty_equip_content_path = "PopUpTitle/Common_bg_orange2/Content/CenterInfo/EmptyEquipContent"
local ItemType = {Goods = 1, Chip = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function ClearScroll(self)
  if self.chips_scroll then
    self.chips_scroll_content:RemoveComponents(TacticalChipItem)
    self.chips_scroll:ClearAllItems()
  end
  if self.result_scroll then
    self.result_content:RemoveComponents(TacticalChipItem)
    self.result_scroll:ClearAllItems()
  end
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function GetSelectedState(self, uuid)
  local selectState = self.selectedChips[uuid]
  if selectState == nil then
    selectState = false
  end
  return selectState
end

local function OnGetItemByRowColumn(self, loopScroll, index, rowIndex, columnIndex)
  if self.chipsDataList ~= nil then
    local count = #self.chipsDataList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("TacticalChipItem")
    local script = self.chips_scroll_content:GetComponent(item.gameObject.name, TacticalChipItem)
    if script == nil then
      local objectName = GetItemNameSequence(self)
      item.gameObject.name = objectName
      script = self.chips_scroll_content:AddComponent(TacticalChipItem, objectName)
      script:SetOnClickChipItem(function(chipItem)
        self:OnSkillChipItemClick(chipItem)
      end)
      script:SetOnLongPress(function(item, chipData)
        self:OnSkillChipItemLongPress(item, chipData)
      end)
    end
    script:SetActive(true)
    local itemInfo = self.chipsDataList[index]
    script:SetData(itemInfo)
    script:SetLocalScaleXYZ(1, 1, 1)
    script:SetNormalSelectedVisible(GetSelectedState(self, itemInfo.uuid))
    return item
  end
end

local function OnGetResultItemByRowColumn(self, loopScroll, index, rowIndex, columnIndex)
  if self.totalReturnsArr ~= nil then
    local count = #self.totalReturnsArr
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("TacticalChipItem")
    local script = self.result_content:GetComponent(item.gameObject.name, TacticalChipItem)
    if script == nil then
      local objectName = GetItemNameSequence(self)
      item.gameObject.name = objectName
      script = self.result_content:AddComponent(TacticalChipItem, objectName)
    end
    script:SetActive(true)
    local info = self.totalReturnsArr[index]
    local type = info.type
    if type == ItemType.Goods then
      local itemInfo = {}
      itemInfo.useCount = info.count
      itemInfo.configId = info.itemId
      itemInfo.type = ItemType.Goods
      script:SetItemInfo(itemInfo)
    elseif type == ItemType.Chip then
      script:SetTemplate(info.itemId, 0)
      script:SetCount(info.count)
    end
    return item
  end
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.result_scroll = self:AddComponent(UILoopGridView, result_scroll_path)
  self.result_content = self:AddComponent(UIBaseContainer, result_content_path)
  self.chips_scroll = self:AddComponent(UILoopGridView, chip_scroll_path)
  self.chips_scroll_content = self:AddComponent(UIBaseContainer, chip_content_path)
  self.chips_scroll:InitGridView(0, function(loopScroll, index, item)
    return OnGetItemByRowColumn(self, loopScroll, index)
  end)
  self.result_scroll:InitGridView(0, function(loopScroll, index, item)
    return OnGetResultItemByRowColumn(self, loopScroll, index)
  end)
  self.decompose_btn = self:AddComponent(UIButton, decompose_btn_path)
  self.decompose_btn:SetOnClick(function()
    if not table.IsNullOrEmpty(self.selectedChips) then
      local uuidArr = {}
      for uuid, _ in pairs(self.selectedChips) do
        if _ then
          table.insert(uuidArr, uuid)
        end
      end
      if #uuidArr <= 0 then
        return
      end
      SFSNetwork.SendMessage(MsgDefines.TWSkillChipReset, uuidArr)
      self.ctrl:CloseSelf()
    end
  end)
  UIGray.SetGray(self.decompose_btn.transform, true, false)
  self.empty_result_text = self:AddComponent(UIText, empty_result_text_path)
  self.empty_result_text:SetActive(true)
  self.empty_equip_content = self:AddComponent(UIBaseContainer, empty_equip_content_path)
end

local function DataDefine(self)
  self.selectedChips = {}
  self.totalReturnsDict = {}
  self.totalReturnsArr = {}
end

local function ComponentDestroy(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnOpen(self)
  self.chipsDataList, self.chipsDataDict = self.ctrl.GetCanResetChipDataList()
  self:UpdateView()
end

local function UpdateView(self)
  if table.count(self.chipsDataList) <= 0 then
    self.chips_scroll:SetActive(false)
    self.empty_equip_content:SetActive(true)
  else
    self.chips_scroll:SetActive(true)
    self.empty_equip_content:SetActive(false)
    self.chips_scroll:SetListItemCount(table.count(self.chipsDataList))
  end
end

local function GetReturnItems(self, uuid)
  local chipInfo = self.chipsDataDict[uuid]
  if not chipInfo then
    return
  end
  local returnGoods, returnChips = chipInfo:GetReturnItem()
  return returnGoods, returnChips
end

local function OnSelectedItemChanged(self, uuid, selectState)
  local returnGoods, returnChips = GetReturnItems(self, uuid)
  local needResort = false
  local changes = {}
  local num = selectState == true and 1 or -1
  for id, count in pairs(returnGoods) do
    if self.totalReturnsDict[id] then
      local info = self.totalReturnsDict[id]
      info.count = info.count + count * num
      if not changes[ItemType.Goods] then
        changes[ItemType.Goods] = {}
      end
      changes[ItemType.Goods][id] = info.count
    else
      local info = {}
      info.type = ItemType.Goods
      info.itemId = id
      info.count = count * num
      self.totalReturnsDict[id] = info
      needResort = true
    end
    if self.totalReturnsDict[id].count <= 0 then
      self.totalReturnsDict[id] = nil
      needResort = true
    end
  end
  for id, count in pairs(returnChips) do
    if self.totalReturnsDict[id] then
      local info = self.totalReturnsDict[id]
      info.count = info.count + count * num
      if not changes[ItemType.Chip] then
        changes[ItemType.Chip] = {}
      end
      changes[ItemType.Chip][id] = info.count
    else
      local info = {}
      info.type = ItemType.Chip
      info.itemId = id
      info.count = count * num
      self.totalReturnsDict[id] = info
      needResort = true
    end
    if self.totalReturnsDict[id].count <= 0 then
      self.totalReturnsDict[id] = nil
      needResort = true
    end
  end
  if needResort then
    self.totalReturnsArr = {}
    for _, info in pairs(self.totalReturnsDict) do
      table.insert(self.totalReturnsArr, info)
    end
    table.sort(self.totalReturnsArr, function(a, b)
      if a.type ~= b.type then
        return a.type < b.type
      end
      if a.type == 2 and b.type == 2 then
        local aQuality = DataCenter.TWSkillChipTemplateManager:GetQualityById(a.itemId)
        local bQuality = DataCenter.TWSkillChipTemplateManager:GetQualityById(b.itemId)
        if aQuality ~= bQuality then
          return aQuality > bQuality
        end
        local aType = DataCenter.TWSkillChipTemplateManager:GetTypeById(a.itemId)
        local bType = DataCenter.TWSkillChipTemplateManager:GetTypeById(b.itemId)
        if aType ~= bType then
          return aType < bType
        end
      end
      return a.itemId < b.itemId
    end)
    self.result_scroll:SetListItemCount(table.count(self.totalReturnsArr))
  else
    for _, v in pairs(self.totalReturnsArr) do
      if changes[v.type] and changes[v.type][v.itemId] then
        v.count = changes[v.type][v.itemId]
      end
    end
  end
  if 0 >= table.count(self.totalReturnsArr) then
    self.empty_result_text:SetActive(true)
    self.result_scroll:SetActive(false)
  else
    self.empty_result_text:SetActive(false)
    self.result_scroll:SetActive(true)
    self.result_scroll:RefreshAllShownItem()
  end
end

local function ChangeSelectItem(self, uuid, selectState)
  local prevSelectedState = GetSelectedState(self, uuid)
  if prevSelectedState == selectState then
    return
  end
  self.selectedChips[uuid] = selectState
  self:OnSelectedItemChanged(uuid, selectState)
  local hasSelectChip = false
  for _, v in pairs(self.selectedChips) do
    if v == true then
      hasSelectChip = true
      break
    end
  end
  UIGray.SetGray(self.decompose_btn.transform, not hasSelectChip, true)
end

local function OnSkillChipItemClick(self, chipItem)
  if not chipItem or not chipItem.chipInfo then
    return
  end
  local uuid = chipItem.chipInfo:GetUUID()
  local selectState = GetSelectedState(self, uuid)
  local newSelectState = not selectState
  chipItem:SetNormalSelectedVisible(newSelectState)
  ChangeSelectItem(self, uuid, newSelectState)
end

local function OnSkillChipItemLongPress(self, item, chipInfo)
  if not chipInfo then
    return
  end
  local pivotItem = item.click_btn ~= nil and item.click_btn or item
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, chipInfo, false)
end

UILWSkillChipResetView.OnCreate = OnCreate
UILWSkillChipResetView.OnDestroy = OnDestroy
UILWSkillChipResetView.OnEnable = OnEnable
UILWSkillChipResetView.OnDisable = OnDisable
UILWSkillChipResetView.OnAddListener = OnAddListener
UILWSkillChipResetView.OnRemoveListener = OnRemoveListener
UILWSkillChipResetView.ComponentDefine = ComponentDefine
UILWSkillChipResetView.DataDefine = DataDefine
UILWSkillChipResetView.ComponentDestroy = ComponentDestroy
UILWSkillChipResetView.DataDestroy = DataDestroy
UILWSkillChipResetView.OnOpen = OnOpen
UILWSkillChipResetView.UpdateView = UpdateView
UILWSkillChipResetView.OnSkillChipItemClick = OnSkillChipItemClick
UILWSkillChipResetView.OnSkillChipItemLongPress = OnSkillChipItemLongPress
UILWSkillChipResetView.OnSelectedItemChanged = OnSelectedItemChanged
UILWSkillChipResetView.ChangeSelectItem = ChangeSelectItem
return UILWSkillChipResetView
