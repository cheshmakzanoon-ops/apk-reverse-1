local UIEquipMaterialGroup = BaseClass("UIEquipMaterialGroup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local UIEquipMaterial = require("UI.UIEquipMainPanel.Component.UIEquipMaterial")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local itemSize = Vector2.New(150, 150)
local itemSpacing = Vector2.New(2, 2)

local function SetListHeight(self, dataSize)
  local height = 0
  if 0 < dataSize then
    height = math.ceil(dataSize / 5) * (itemSize.y + itemSpacing.y) - itemSpacing.y + 8
  end
  self.equipMaterialListLayoutElement:SetPreferredHeight(height)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.rectTransform)
end

local function ClearEquipScroll(self)
  self.equipMaterialScroll:RemoveComponents(UIEquipMaterial)
  self.equipMaterialList:DestroyChildNode()
end

local function OnInitScroll(self, go, index)
  local item = self.equipMaterialScroll:AddComponent(UIEquipMaterial, go)
  self.equipMaterialListGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local item = self.equipMaterialListGO[go]
  local materialData = self.groupData.materials[index + 1]
  item:SetActive(materialData ~= nil)
  if materialData ~= nil then
    item:SetData(materialData, self.clickCallBack)
    item:SetSelected(self.selectedMaterialId == materialData.id)
  end
end

local function OnDestroyScrollItem(self, go, index)
end

local function OnDestroy(self)
  ClearEquipScroll(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.itemId = 0
  self.equipMaterialListGO = {}
  self.hasInitScroll = false
  self.selectedMaterialId = 0
end

local function DataDestroy(self)
  self.itemId = nil
  self.equipMaterialListGO = nil
  self.hasInitScroll = false
  self.selectedMaterialId = 0
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.groupNameText = self:AddComponent(UIText, "GroupName/GroupNameText")
  self.equipMaterialScroll = self:AddComponent(UIBaseContainer, "EquipMaterialScroll")
  self.equipMaterialList = self:AddComponent(GridInfinityScrollView, "EquipMaterialScroll/EquipMaterialContent")
  self.equipMaterialListLayoutElement = self:AddComponent(UILayoutElement, "EquipMaterialScroll")
  self.emptyDescText = self:AddComponent(UIText, "EmptyDescText")
  self.emptyDescText:SetLocalText(430719)
end

local function ComponentDestroy(self)
  self.root = nil
  self.groupNameText = nil
  self.equipMaterialScroll = nil
  self.equipMaterialList = nil
  self.equipMaterialListLayoutElement = nil
  self.emptyDescText = nil
end

local function SetData(self, groupData, clickCallBack)
  if groupData == nil then
    self:SetActive(false)
  else
    self:SetActive(true)
  end
  self.clickCallBack = clickCallBack
  self.groupData = groupData
  self.groupNameText:SetLocalText(DataCenter.EquipMaterialDataManager.GetMaterialCategoryName(groupData.category))
  local count = table.count(self.groupData.materials)
  if 0 < count then
    self.equipMaterialScroll:SetActive(true)
    self.emptyDescText:SetActive(false)
    SetListHeight(self, count)
    self.materialList = self.groupData.materials
    if not self.hasInitScroll then
      local bindFunc1 = BindCallback(self, OnInitScroll)
      local bindFunc2 = BindCallback(self, OnUpdateScroll)
      local bindFunc3 = BindCallback(self, OnDestroyScrollItem)
      self.equipMaterialList:Init(bindFunc1, bindFunc2, bindFunc3)
    end
    self.hasInitScroll = true
    self.equipMaterialList:SetItemCount(count)
    self.equipMaterialList:ForceUpdate()
  else
    self.equipMaterialScroll:SetActive(false)
    self.emptyDescText:SetActive(true)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.rectTransform)
  end
end

local function SetSelected(self, materialId)
  self.selectedMaterialId = materialId
  for _, v in pairs(self.equipMaterialListGO) do
    local selected = self.selectedMaterialId == v.itemId
    v:SetSelected(selected)
  end
end

UIEquipMaterialGroup.OnCreate = OnCreate
UIEquipMaterialGroup.OnDestroy = OnDestroy
UIEquipMaterialGroup.OnEnable = OnEnable
UIEquipMaterialGroup.OnDisable = OnDisable
UIEquipMaterialGroup.DataDefine = DataDefine
UIEquipMaterialGroup.DataDestroy = DataDestroy
UIEquipMaterialGroup.ComponentDefine = ComponentDefine
UIEquipMaterialGroup.ComponentDestroy = ComponentDestroy
UIEquipMaterialGroup.SetData = SetData
UIEquipMaterialGroup.SetSelected = SetSelected
return UIEquipMaterialGroup
