local BuildingGroupDispatchContent = BaseClass("BuildingGroupDispatchContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local WorkerOverviewBuildingGroupDispatchCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.WorkerOverviewBuildingGroupDispatchCell")
local content_path = "BuildingGroupList/viewPort/Content"
local all_dis_patch_btn_path = "AllDisPatchBtn"
local all_dis_patch_btn_red_path = "AllDisPatchBtn/AllDisPatchBtnRed"
local WaitSendMsgTime = 3000

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showData then
    return nil
  end
  local packData = self.showData[index]
  local item = loopScroll:NewListViewItem("WorkerOverviewBuildingGroupDispatchCell")
  local script = self.content:GetComponent(item.gameObject.name, WorkerOverviewBuildingGroupDispatchCell)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(WorkerOverviewBuildingGroupDispatchCell, objectName)
  end
  script:SetActive(true)
  script:SetData(packData, self.scroll_view, index - 1)
  return item
end

local function ComponentDefine(self)
  self.scroll_view = self:AddComponent(UILoopListView2, "BuildingGroupList")
  self.scroll_view:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.all_dis_patch_btn = self:AddComponent(UIButton, all_dis_patch_btn_path)
  self.all_dis_patch_btn:SetOnClick(function()
    self:OnAllDispatchBtnClick()
  end)
  self.all_dis_patch_btn_red = self:AddComponent(UIImage, all_dis_patch_btn_red_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
  self:ClearContent()
  self.all_dis_patch_btn = nil
  self.all_dis_patch_btn_red = nil
end

local function DataDefine(self)
  self.showData = nil
  self.canSendMsgTime = 0
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.showData = nil
  self.canSendMsgTime = nil
  self.itemIndex = nil
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

local function ClearContent(self)
  self.content:RemoveComponents(WorkerOverviewBuildingGroupDispatchCell)
  self.scroll_view:ClearAllItems()
end

local function RefreshItemView(self)
  if not table.IsNullOrEmpty(self.showData) then
    self.scroll_view:SetListItemCount(#self.showData, false, false)
    self.scroll_view:RefreshAllShownItem()
  end
  local isOn = false
  if self.showData then
    for i, groupData in pairs(self.showData) do
      for _, data in ipairs(groupData.dataList) do
        local curIsOn = data.data:CheckBuildingWorkerRedDot()
        if curIsOn then
          isOn = true
          break
        end
      end
      if isOn then
        break
      end
    end
  end
  self.all_dis_patch_btn_red:SetActive(isOn)
end

local function OnOpen(self)
  self:InitShowData()
  self:RefreshItemView()
end

local function InitShowData(self)
  self.showData = {}
  local showDataDict = {}
  local allBuildingData = DataCenter.BuildManager:GetAllBuildWithoutPickUp()
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
      if showDataDict[data.itemId] == nil then
        showDataDict[data.itemId] = {
          itemId = data.itemId,
          buildTemplate = buildTemplate,
          dataList = {},
          order = data.itemId,
          isOpenDetail = true
        }
      end
      table.insert(showDataDict[data.itemId].dataList, buildingData)
    end
  end
  local orderDict = DataCenter.WorkerDataManager:GetWorkerDispatchBuildingTypeOrderDict()
  for k, v in pairs(showDataDict) do
    if orderDict[v.itemId] ~= nil then
      v.order = orderDict[v.itemId]
    end
    table.insert(self.showData, v)
  end
  table.sort(self.showData, function(a, b)
    return a.order < b.order
  end)
  for k, v in pairs(self.showData) do
    table.sort(v.dataList, function(a, b)
      if a.data.level ~= b.data.level then
        return a.data.level > b.data.level
      end
      return a.data.uuid < b.data.uuid
    end)
  end
  if #self.showData > 0 then
    self.showData[1].isOpenDetail = true
  end
end

local function UpdateShowData(self)
  for _, groupData in ipairs(self.showData) do
    for _, buildingData in ipairs(groupData.dataList) do
      buildingData.trenchDataList = {}
      local lastSlots = buildingData.maxLvTemp.hero_slots
      for i = 1, lastSlots do
        local trenchData = {}
        trenchData.type = BuildDisPatchingHeroTrenchState.LOCK
        if i <= buildingData.curTemp.hero_slots then
          trenchData.type = BuildDisPatchingHeroTrenchState.ADD
          if buildingData.data.assignedHeroList[i] ~= nil and buildingData.data.assignedHeroList[i] ~= "" then
            local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(tonumber(buildingData.data.assignedHeroList[i]))
            trenchData.workerData = workerData
            trenchData.type = BuildDisPatchingHeroTrenchState.HERO
          else
          end
        end
        table.insert(buildingData.trenchDataList, trenchData)
      end
    end
  end
end

local function GetWorkerInfoUpdateMsg(self)
  self:RefreshItemView()
end

local function GetBuildingHeroDispatchingMsg(self)
  self:RecordCurVal()
  self:UpdateShowData()
  self:RefreshItemView()
  self:TryPlayAni()
end

local function OnAllDispatchBtnClick(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime <= self.canSendMsgTime then
    return
  end
  self.canSendMsgTime = curTime + WaitSendMsgTime
  SFSNetwork.SendMessage(MsgDefines.WorkerAssignAll)
end

local function RecordCurVal(self)
end

local function TryPlayAni(self)
end

BuildingGroupDispatchContent.OnCreate = OnCreate
BuildingGroupDispatchContent.OnDestroy = OnDestroy
BuildingGroupDispatchContent.DataDefine = DataDefine
BuildingGroupDispatchContent.DataDestroy = DataDestroy
BuildingGroupDispatchContent.ComponentDefine = ComponentDefine
BuildingGroupDispatchContent.ComponentDestroy = ComponentDestroy
BuildingGroupDispatchContent.OnAddListener = OnAddListener
BuildingGroupDispatchContent.OnRemoveListener = OnRemoveListener
BuildingGroupDispatchContent.OnOpen = OnOpen
BuildingGroupDispatchContent.InitShowData = InitShowData
BuildingGroupDispatchContent.UpdateShowData = UpdateShowData
BuildingGroupDispatchContent.GetWorkerInfoUpdateMsg = GetWorkerInfoUpdateMsg
BuildingGroupDispatchContent.GetBuildingHeroDispatchingMsg = GetBuildingHeroDispatchingMsg
BuildingGroupDispatchContent.OnAllDispatchBtnClick = OnAllDispatchBtnClick
BuildingGroupDispatchContent.ClearContent = ClearContent
BuildingGroupDispatchContent.RefreshItemView = RefreshItemView
BuildingGroupDispatchContent.RecordCurVal = RecordCurVal
BuildingGroupDispatchContent.TryPlayAni = TryPlayAni
return BuildingGroupDispatchContent
