local TacticalEquipMaxLevelPanel = BaseClass("TacticalEquipMaxLevelPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TacticalEquipAttriItem = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Component.TacticalEquipAttriItem")

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
  self.attributeNode = self:AddComponent(UIBaseContainer, "TacticalEquipAttributeNode")
end

local function ComponentDestroy(self)
  self.attributeNode:RemoveComponents(TacticalEquipAttriItem)
  self.attributeNode = nil
end

local function DataDefine(self)
  self.attributeItemReqs = {}
  self.attributeCellList = {}
end

local function DataDestroy(self)
  for i, v in ipairs(self.attributeItemReqs) do
    if v then
      self:GameObjectDestroy(v)
    end
  end
  self.attributeItemReqs = nil
  self.attributeCellList = nil
end

function TacticalEquipMaxLevelPanel:SetData(equipData, slot, isFromShortcutKey)
  self.equipData = equipData
  self.slot = slot
  self:RefreshAttributes(isFromShortcutKey)
  self:RefreshStatus()
end

function TacticalEquipMaxLevelPanel:RefreshAttributes(isFromShortcutKey)
  for i = #self.attributeItemReqs, 1, -1 do
    local req = self.attributeItemReqs[i]
    if req and not req.isDone then
      self:GameObjectDestroy(req)
      table.remove(self.attributeItemReqs, i)
    end
  end
  local effects = self.equipData:GetEffects()
  local dataList = DataCenter.CommonEquipDataManager:GetAttributePairsDataList(effects)
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
    self.attributeNode:RemoveComponents(TacticalEquipAttriItem)
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

function TacticalEquipMaxLevelPanel:CreateAttributeItem(data, index)
  return self:GameObjectInstantiateAsync(UIAssets.TacticalEquipAttriItemV, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.attributeNode.transform)
    go.transform:Set_localScale(1, 1, 1)
    go:SetActive(true)
    go.name = "attribute_" .. tostring(index)
    local cell = self.attributeNode:AddComponent(TacticalEquipAttriItem, go)
    data.index = index
    cell:SetData(data)
    self.attributeCellList[index] = cell
  end)
end

function TacticalEquipMaxLevelPanel:RefreshStatus()
  if self.holder == nil then
    return
  end
  self.holder:SetShowBtn({
    TacticalEquipBtnStatus.Confirm
  })
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

TacticalEquipMaxLevelPanel.OnCreate = OnCreate
TacticalEquipMaxLevelPanel.OnDestroy = OnDestroy
TacticalEquipMaxLevelPanel.OnEnable = OnEnable
TacticalEquipMaxLevelPanel.OnDisable = OnDisable
TacticalEquipMaxLevelPanel.ComponentDefine = ComponentDefine
TacticalEquipMaxLevelPanel.ComponentDestroy = ComponentDestroy
TacticalEquipMaxLevelPanel.DataDefine = DataDefine
TacticalEquipMaxLevelPanel.DataDestroy = DataDestroy
TacticalEquipMaxLevelPanel.OnAddListener = OnAddListener
TacticalEquipMaxLevelPanel.OnRemoveListener = OnRemoveListener
return TacticalEquipMaxLevelPanel
