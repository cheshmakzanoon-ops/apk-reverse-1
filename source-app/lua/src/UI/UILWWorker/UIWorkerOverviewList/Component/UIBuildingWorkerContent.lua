local UIBuildingWorkerContent = BaseClass("UIBuildingWorkerContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local UIBuildingWorkerInfoCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIBuildingWorkerInfoCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.buildingList = self:AddComponent(GridInfinityScrollView, "Content")
  self.buildingListScroll = self:AddComponent(UIBaseContainer, "")
end

local function ComponentDestroy(self)
  self.buildingList = nil
  self.buildingListScroll = nil
end

local function DataDefine(self)
  self.showData = nil
  self.listGO = {}
  self.hasInitView = nil
end

local function DataDestroy(self)
  self.showData = nil
  self.listGO = nil
  self.hasInitView = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorkerInfoUpdate, self.GetWorkerInfoUpdateMsg)
  self:AddUIListener(EventId.BuildingHeroDispatching, self.GetBuildingHeroDispatchingMsg)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WorkerInfoUpdate, self.GetWorkerInfoUpdateMsg)
  self:RemoveUIListener(EventId.BuildingHeroDispatching, self.GetBuildingHeroDispatchingMsg)
end

local function ClearScroll(self)
  self.buildingListScroll:RemoveComponents(UIBuildingWorkerInfoCell)
  self.buildingList:DestroyChildNode()
end

local function OnInitScroll(self, go, index)
  local item = self.buildingListScroll:AddComponent(UIBuildingWorkerInfoCell, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local item = self.listGO[go]
  local data = self.showData[index + 1]
  item:SetActive(true)
  item:SetData(data)
end

local function OnDestroyScrollItem(self, go, index)
end

local function OnOpen(self)
  self.buildingList:SetAnchoredPositionXY(0, 0)
  self:InitShowData()
end

local function InitShowData(self)
  self.showData = {}
  local allBuildingData = DataCenter.BuildManager:GetAllBuildData()
  for i, data in pairs(allBuildingData) do
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(data.itemId)
    local maxLevel = buildTemplate.max_level
    local buildingLvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
    if data.level > 0 and 0 < buildingLvTemplate.hero_slots and buildTemplate.tab_type ~= UIBuildListTabType.Decorate and buildTemplate.tab_type ~= UIBuildListTabType.SeasonBuild and data.itemId ~= BuildingTypes.LW_BUILD_LIBRARY and data.itemId ~= BuildingTypes.LW_BUILD_SHOP then
      local buildingMaxLvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, maxLevel)
      local lastSlots = buildingMaxLvTemplate.hero_slots
      local buildingData = {
        oneTemp = buildTemplate,
        curTemp = buildingLvTemplate,
        maxLvTemp = buildingMaxLvTemplate,
        data = data,
        trenchDataList = {}
      }
      for i = 1, lastSlots do
        local trenchData = {}
        trenchData.type = BuildDisPatchingHeroTrenchState.LOCK
        if i <= buildingLvTemplate.hero_slots then
          trenchData.type = BuildDisPatchingHeroTrenchState.ADD
          if data.assignedHeroList[i] ~= nil and data.assignedHeroList[i] ~= "" then
            local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(tonumber(data.assignedHeroList[i]))
            trenchData.workerData = workerData
            trenchData.type = BuildDisPatchingHeroTrenchState.HERO
          else
          end
        end
        table.insert(buildingData.trenchDataList, trenchData)
      end
      table.insert(self.showData, buildingData)
    end
  end
  table.sort(self.showData, function(a, b)
    if a.curTemp.hero_sort ~= b.curTemp.hero_sort then
      return a.curTemp.hero_sort > b.curTemp.hero_sort
    end
    return a.data.uuid < b.data.uuid
  end)
  if not self.hasInitView then
    local bindFunc1 = BindCallback(self, OnInitScroll)
    local bindFunc2 = BindCallback(self, OnUpdateScroll)
    local bindFunc3 = BindCallback(self, OnDestroyScrollItem)
    self.buildingList:Init(bindFunc1, bindFunc2, bindFunc3)
  end
  self.hasInitView = true
  self.buildingList:SetItemCount(#self.showData)
  self.buildingList:ForceUpdate()
end

local function GetWorkerInfoUpdateMsg(self)
  self.buildingList:SetItemCount(#self.showData)
  self.buildingList:ForceUpdate()
end

local function GetBuildingHeroDispatchingMsg(self)
  self:InitShowData()
end

UIBuildingWorkerContent.OnCreate = OnCreate
UIBuildingWorkerContent.OnDestroy = OnDestroy
UIBuildingWorkerContent.DataDefine = DataDefine
UIBuildingWorkerContent.DataDestroy = DataDestroy
UIBuildingWorkerContent.ComponentDefine = ComponentDefine
UIBuildingWorkerContent.ComponentDestroy = ComponentDestroy
UIBuildingWorkerContent.OnAddListener = OnAddListener
UIBuildingWorkerContent.OnRemoveListener = OnRemoveListener
UIBuildingWorkerContent.OnOpen = OnOpen
UIBuildingWorkerContent.InitShowData = InitShowData
UIBuildingWorkerContent.ClearScroll = ClearScroll
UIBuildingWorkerContent.GetWorkerInfoUpdateMsg = GetWorkerInfoUpdateMsg
UIBuildingWorkerContent.GetBuildingHeroDispatchingMsg = GetBuildingHeroDispatchingMsg
return UIBuildingWorkerContent
