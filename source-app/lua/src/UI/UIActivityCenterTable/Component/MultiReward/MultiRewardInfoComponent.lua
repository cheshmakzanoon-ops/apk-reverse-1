local MultiRewardInfoComponent = BaseClass("MultiRewardInfoComponent", UIBaseContainer)
local MultiRewardCell = require("UI.UIActivityCenterTable.Component.MultiReward.MultiRewardCellComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local CARD_CELL_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/MultiReward"
local content_path = "Viewport/Content"
local bg_root_path = "Viewport/Content/BgRoot"

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
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.bgRoot = self:AddComponent(UIBaseContainer, bg_root_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.reqList = {}
end

local function DataDestroy(self)
  self:ClearAllPrefab()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function MultiRewardInfoComponent:SetData(activityId)
  self:ClearAllPrefab()
  local allMultiRewardDataList = DataCenter.MultiRewardDropManager:GetAllActivityMultiRewardData(activityId)
  table.sort(allMultiRewardDataList, function(a, b)
    return a:GetOrder() > b:GetOrder()
  end)
  self.cellList = {}
  self.loadCellCount = 0
  local index = 0
  for _, v in ipairs(allMultiRewardDataList) do
    local cell = {}
    local path = string.format("%s/%s", CARD_CELL_PATH, v.multiTemplate.prefab)
    cell.req = self:GameObjectInstantiateAsync(path, function(req)
      if req.isError then
        return
      end
      local obj = req.gameObject
      obj.transform:SetParent(self.content.transform)
      obj.transform:Set_localScale(1, 1, 1)
      obj.name = NameCount
      cell.inst = self:AddComponent(MultiRewardCell, string.format("%s/%s", content_path, NameCount))
      NameCount = NameCount + 1
      cell.inst:SetData(v, index)
      index = index + 1
      self.loadCellCount = self.loadCellCount + 1
      if self.loadCellCount == table.count(allMultiRewardDataList) then
        self:OnCellAllLoadFinish()
      end
    end)
    table.insert(self.cellList, cell)
  end
end

function MultiRewardInfoComponent:OnCellAllLoadFinish()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
  if self.cellList then
    table.sort(self.cellList, function(a, b)
      return a.inst:GetOrder() < b.inst:GetOrder()
    end)
    for index, v in ipairs(self.cellList) do
      if v.inst then
        v.inst.transform:SetAsFirstSibling()
      end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
    for index, v in ipairs(self.cellList) do
      if v.inst then
        v.inst:ResetParent()
      end
    end
    for index, v in ipairs(self.cellList) do
      if v.inst then
        v.inst:ResetCellBGOrder()
      end
    end
    self.bgRoot.transform:SetAsFirstSibling()
  end
end

function MultiRewardInfoComponent:ClearAllPrefab()
  if self.cellList then
    for _, v in ipairs(self.cellList) do
      if v.inst then
        v.inst:ResetCellOnDestroy()
      end
      if v.req then
        v.req:Destroy()
      end
    end
    self.cellList = nil
  end
end

MultiRewardInfoComponent.OnCreate = OnCreate
MultiRewardInfoComponent.OnDestroy = OnDestroy
MultiRewardInfoComponent.OnEnable = OnEnable
MultiRewardInfoComponent.OnDisable = OnDisable
MultiRewardInfoComponent.ComponentDefine = ComponentDefine
MultiRewardInfoComponent.ComponentDestroy = ComponentDestroy
MultiRewardInfoComponent.DataDefine = DataDefine
MultiRewardInfoComponent.DataDestroy = DataDestroy
MultiRewardInfoComponent.OnAddListener = OnAddListener
MultiRewardInfoComponent.OnRemoveListener = OnRemoveListener
return MultiRewardInfoComponent
