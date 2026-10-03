local TacticalEquipMergePanel = BaseClass("TacticalEquipMergePanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RED_NUM_FORMAT = "<color=#E70015>%s</color>/%s"
local GREEN_NUM_FORMAT = "<color=#68F37F>%s</color>/%s"
local TacticalEquipAttriItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipAttriItem")
local TacticalEquipItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textPropsNeedNum = self:AddComponent(UITextMeshProUGUIEx, "costPropsNode/propsNeedNum")
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, "ItemHolder")
  self.compItemContent = self:AddComponent(UIBaseContainer, "ItemHolder/Viewport/ItemContent")
  self.compTacticalEquipAttributeNode = self:AddComponent(UIBaseContainer, "TacticalEquipAttributeNode")
  self.textCostPropsDesc = self:AddComponent(UITextMeshProUGUIEx, "costPropsNode/costPropsDesc")
  self.textNoneCostTips = self:AddComponent(UITextMeshProUGUIEx, "costPropsNode/noneCostTips")
  self.compCostEquipItem = self:AddComponent(TacticalEquipItem, "costPropsNode/propsNode/costEquipItem")
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
end

local function ComponentDestroy(self)
  self.compItemContent:RemoveComponents(TacticalEquipItem)
  self.compTacticalEquipAttributeNode:RemoveComponents(TacticalEquipAttriItem)
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  self.textPropsNeedNum = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.compTacticalEquipAttributeNode = nil
  self.textCostPropsDesc = nil
  self.textNoneCostTips = nil
end

local function DataDefine(self)
  self.attributeItemReqs = {}
  self.attributeCellList = {}
end

local function DataDestroy(self)
  self.equipData = nil
  self.slot = nil
  self.freeEquips, self.freeEquipsCount = nil, nil
  for i, v in ipairs(self.attributeItemReqs) do
    if v then
      self:GameObjectDestroy(v)
    end
  end
  self.attributeItemReqs = nil
  self.attributeCellList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TacticalEquipMergePanel:SetData(equipData, slot, isFromShortcutKey)
  self.equipData = equipData
  self.slot = slot
  self:RefreshAttributes(isFromShortcutKey)
  self:RefreshOwnList()
  self:RefreshCost()
  self:RefreshStatus()
end

function TacticalEquipMergePanel:RefreshAttributes(isFromShortcutKey)
  if self.holder == nil then
    return
  end
  local curEquip = self.holder:GetCurEquipData()
  local nextEquip = curEquip:GetNextLvEquipInfo()
  local nextEffects = nextEquip:GetEffects()
  local effects = curEquip:GetEffects()
  for i = #self.attributeItemReqs, 1, -1 do
    local req = self.attributeItemReqs[i]
    if req and not req.isDone then
      self:GameObjectDestroy(req)
      table.remove(self.attributeItemReqs, i)
    end
  end
  local dataList = DataCenter.CommonEquipDataManager:GetAttributePairsDataList(effects, nextEffects)
  local countDelta = #dataList - #self.attributeCellList
  if 0 <= countDelta then
    if 0 < countDelta then
      for i = 1, countDelta do
        local index = #self.attributeCellList + i
        if self.attributeItemReqs[index] == nil then
          table.insert(self.attributeItemReqs, self:CreateAttributeItem(dataList[index], index))
        end
      end
    end
    for i, v in ipairs(self.attributeCellList) do
      if v and dataList[i] then
        dataList[i].index = i
        dataList[i].isFromShortcutKey = isFromShortcutKey
        v:SetData(dataList[i])
      end
    end
  else
    self.compTacticalEquipAttributeNode:RemoveComponents(TacticalEquipAttriItem)
    for i, v in ipairs(self.attributeItemReqs) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
    self.attributeItemReqs = {}
    self.attributeCellList = {}
    for index, v in ipairs(dataList) do
      table.insert(self.attributeItemReqs, self:CreateAttributeItem(v, index))
    end
  end
end

function TacticalEquipMergePanel:CreateAttributeItem(data, index)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalEquipAttriItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.compTacticalEquipAttributeNode.transform)
    go.transform:Set_localScale(1, 1, 1)
    go:SetActive(true)
    go.name = "attribute_" .. tostring(index)
    local cell = self.compTacticalEquipAttributeNode:AddComponent(TacticalEquipAttriItem, go)
    data.index = index
    cell:SetData(data)
    self.attributeCellList[index] = cell
  end)
end

function TacticalEquipMergePanel:RefreshOwnList()
  self.freeEquips, self.freeEquipsCount = DataCenter.CommonEquipDataManager:GetAllFreeEquipBagData(self.slot)
  if self.freeEquipsCount > 0 then
    self.loopGridViewItemHolder:SetListItemCount(self.freeEquipsCount)
    self.loopGridViewItemHolder:RefreshAllShownItem()
    self.holder:SetShowBtn({
      TacticalEquipBtnStatus.Use
    })
  end
  self.loopGridViewItemHolder:SetActive(self.freeEquipsCount > 0)
end

function TacticalEquipMergePanel:RefreshCost()
  if not self.holder then
    return
  end
  local curEquipData = self.holder:GetCurEquipData()
  if curEquipData and curEquipData.config then
    local data = CommonEquipInfo.CreateByTemplate(curEquipData.config)
    self.compCostEquipItem:SetData(data, self.slot)
    self.compCostEquipItem:SetItemCountActive(false)
    local costMap = curEquipData.config:GetUpgradeCost()
    local costNum = costMap[curEquipData.cfgId] - 1
    local sameEquips = DataCenter.CommonEquipDataManager:GetAllFreeEqiupsByCfgId(curEquipData.cfgId)
    local ownNum = 0
    if sameEquips and 0 < #sameEquips then
      ownNum = sameEquips[1].num
    end
    self.textPropsNeedNum:SetActive(true)
    if costNum <= ownNum then
      self.textPropsNeedNum:SetText(string.format(GREEN_NUM_FORMAT, ownNum, costNum))
    else
      self.textPropsNeedNum:SetText(string.format(RED_NUM_FORMAT, ownNum, costNum))
    end
  end
end

function TacticalEquipMergePanel:RefreshStatus()
  if self.holder == nil then
    return
  end
  local statusList = {}
  local CanMerge = DataCenter.CommonEquipDataManager:CanAutoMerge(self.slot)
  if CanMerge then
    table.insert(statusList, TacticalEquipBtnStatus.Merge)
  else
    table.insert(statusList, TacticalEquipBtnStatus.MergeBan)
  end
  local canReplace = DataCenter.CommonEquipDataManager:HasReplaceBatterEquip(self.equipData, self.slot)
  if canReplace then
    table.insert(statusList, TacticalEquipBtnStatus.Replace)
    self.textCostPropsDesc:SetLocalText("squad_equip_merge_desc_8")
    self.textPropsNeedNum:SetActive(false)
    local equip = DataCenter.CommonEquipDataManager:GetOwnMaxLvFreeEquip(self.slot)
    self.compCostEquipItem:SetData(equip, self.slot)
    self.compCostEquipItem:SetItemCountActive(false)
  else
    local canUpgrade = DataCenter.CommonEquipDataManager:IsCommonEquipCanUpgrade(self.equipData.cfgId, 1)
    if canUpgrade then
      table.insert(statusList, TacticalEquipBtnStatus.Upgrade)
      self.textCostPropsDesc:SetLocalText("squad_equip_merge_desc_4")
    else
      table.insert(statusList, TacticalEquipBtnStatus.GetMore)
      self.textCostPropsDesc:SetLocalText("squad_equip_merge_desc_3")
    end
  end
  self.holder:SetShowBtn(statusList)
end

function TacticalEquipMergePanel:OnGetItemByRowColumn(loopScroll, index)
  if self.freeEquips ~= nil then
    local count = #self.freeEquips
    index = index + 1
    if index < 1 or index > self.freeEquipsCount then
      return nil
    end
    local item = loopScroll:NewListViewItem("TacticalEquipItem")
    local script = self.compItemContent:GetComponent(item.gameObject.name, TacticalEquipItem)
    if script == nil then
      local name = "equip_" .. index
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(TacticalEquipItem, name)
    end
    local data = self.freeEquips[index]
    script:SetLocalScaleXYZ(0.7, 0.7, 0.7)
    script:SetData(data, self.slot)
    script:SetActive(true)
    return item
  end
end

local function OnBtnGetMoreClick(self)
end

local function OnBtnMergeClick(self)
end

local function OnBtnUpgradeClick(self)
end

TacticalEquipMergePanel.OnCreate = OnCreate
TacticalEquipMergePanel.OnDestroy = OnDestroy
TacticalEquipMergePanel.OnEnable = OnEnable
TacticalEquipMergePanel.OnDisable = OnDisable
TacticalEquipMergePanel.ComponentDefine = ComponentDefine
TacticalEquipMergePanel.ComponentDestroy = ComponentDestroy
TacticalEquipMergePanel.DataDefine = DataDefine
TacticalEquipMergePanel.DataDestroy = DataDestroy
TacticalEquipMergePanel.OnAddListener = OnAddListener
TacticalEquipMergePanel.OnRemoveListener = OnRemoveListener
TacticalEquipMergePanel.OnBtnGetMoreClick = OnBtnGetMoreClick
TacticalEquipMergePanel.OnBtnMergeClick = OnBtnMergeClick
TacticalEquipMergePanel.OnBtnUpgradeClick = OnBtnUpgradeClick
return TacticalEquipMergePanel
