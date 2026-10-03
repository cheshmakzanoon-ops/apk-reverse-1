local base = UIBaseContainer
local LWUIWorkerAttrOverview = BaseClass("LWUIWorkerAttrOverview", base)
local WorkerAttrOverviewItem = require("UI.UILWWorker.UIWorkerOverviewList.Component.AttributeContent.WorkerAttrOverviewItem")
local tip1_text_path = "TopContent/Tip1Text"
local ur_slider_path = "TopContent/ProgressContent/URSliderContent/Slider1"
local ssr_slider_path = "TopContent/ProgressContent/SSRSliderContent/Slider2"
local sr_slider_path = "TopContent/ProgressContent/SRSliderContent/Slider3"
local ur_progress_path = "TopContent/ProgressContent/URSliderContent/Progress1"
local ssr_progress_path = "TopContent/ProgressContent/SSRSliderContent/Progress2"
local sr_progress_path = "TopContent/ProgressContent/SRSliderContent/Progress3"
local power_value_path = "TopContent/PowerBGContent/PowerValue"
local scroll_view_path = "MiddleContent/Scroll View"
local content_path = "MiddleContent/Scroll View/Viewport/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self.itemIndex = 0
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self.itemIndex = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.buildingAttrShowData then
    return nil
  end
  local packData = self.buildingAttrShowData[index]
  local item = loopScroll:NewListViewItem("UIWorkerAttrOverviewItem")
  local script = self.content:GetComponent(item.gameObject.name, WorkerAttrOverviewItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(WorkerAttrOverviewItem, objectName)
  end
  script:SetActive(true)
  script:Refresh(packData, self.scroll_view, index - 1)
  return item
end

local function ComponentDefine(self)
  self.tip1_text = self:AddComponent(UIText, tip1_text_path)
  self.power_value = self:AddComponent(UIText, power_value_path)
  self.urSlider = self:AddComponent(UISlider, ur_slider_path)
  self.ssrSlider = self:AddComponent(UISlider, ssr_slider_path)
  self.srSlider = self:AddComponent(UISlider, sr_slider_path)
  self.urProgress = self:AddComponent(UIText, ur_progress_path)
  self.ssrProgress = self:AddComponent(UIText, ssr_progress_path)
  self.srProgress = self:AddComponent(UIText, sr_progress_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.recruitBtn = self:AddComponent(UIButton, "RecruitBtn")
  self.recruitBtn:SetOnClick(function()
    GoToUtil.GotoWorkerRecruitView(true)
  end)
  self.recruitBtnText = self:AddComponent(UIText, "RecruitBtn/RecruitText")
  self.recruitBtnText:SetLocalText("worker_ui004")
end

local function ComponentDestroy(self)
  self.content = nil
end

local function OnOpen(self)
  self:InitShowData()
  self:ShowPanel()
end

local function InitShowData(self)
  self:InitWorkerNumData()
  self:InitBuildingShowData()
end

local function InitWorkerNumData(self)
  self.totalWorkingWorkerPower = 0
  self.workerNumData = {}
  local allShowTemp = DataCenter.WorkerTemplateManager:GetAllShowTemplate()
  local allWorkerData = DataCenter.WorkerDataManager:GetAllWorkerData()
  self.workerNumData[WorkerFilterQualityType.All] = {total = 0, have = 0}
  self.workerNumData[WorkerFilterQualityType.Legendary] = {total = 0, have = 0}
  self.workerNumData[WorkerFilterQualityType.Genius] = {total = 0, have = 0}
  for id, temp in pairs(allShowTemp) do
    local quality = temp.quality
    self.workerNumData[WorkerFilterQualityType.All].total = self.workerNumData[WorkerFilterQualityType.All].total + 1
    if quality == WorkerQualityType.Legendary then
      local filterQuality = WorkerFilterQualityType.Legendary
      self.workerNumData[filterQuality].total = self.workerNumData[filterQuality].total + 1
    elseif quality == WorkerQualityType.Genius then
      local filterQuality = WorkerFilterQualityType.Genius
      self.workerNumData[filterQuality].total = self.workerNumData[filterQuality].total + 1
    end
  end
  for __, v in pairs(allWorkerData) do
    local cfgId = v.cfgId
    if allShowTemp[cfgId] then
      local quality = allShowTemp[cfgId].quality
      self.workerNumData[WorkerFilterQualityType.All].have = self.workerNumData[WorkerFilterQualityType.All].have + 1
      if quality == WorkerQualityType.Legendary then
        local filterQuality = WorkerFilterQualityType.Legendary
        self.workerNumData[filterQuality].have = self.workerNumData[filterQuality].have + 1
      elseif quality == WorkerQualityType.Genius then
        local filterQuality = WorkerFilterQualityType.Genius
        self.workerNumData[filterQuality].have = self.workerNumData[filterQuality].have + 1
      end
      self.totalWorkingWorkerPower = self.totalWorkingWorkerPower + v.rankPower
    end
  end
end

local function InitBuildingShowData(self)
  self.buildingShowData = {}
  self.buildingAttrShowData = {}
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
          order = data.itemId
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
    table.insert(self.buildingShowData, v)
  end
  table.sort(self.buildingShowData, function(a, b)
    return a.order < b.order
  end)
  for k, v in pairs(self.buildingShowData) do
    table.sort(v.dataList, function(a, b)
      if a.data.level ~= b.data.level then
        return a.data.level > b.data.level
      end
      return a.data.uuid < b.data.uuid
    end)
  end
  for _, buildingData in pairs(self.buildingShowData) do
    local typeBuildingHaveWorker = 0
    local typebuildingAttrData = {}
    typebuildingAttrData.buildindData = buildingData
    typebuildingAttrData.attrData = {}
    for _, building in pairs(buildingData.dataList) do
      local curBuildingHaveWorker = 0
      local curBuildingAttrData = {}
      local curBuildingAttrDict = {}
      local baseEffectId = 0
      for _, trenchData in pairs(building.trenchDataList) do
        if trenchData.type == BuildDisPatchingHeroTrenchState.HERO then
          local workerData = trenchData.workerData
          if workerData then
            typeBuildingHaveWorker = typeBuildingHaveWorker + 1
            curBuildingHaveWorker = curBuildingHaveWorker + 1
            baseEffectId = workerData.peculiarity
            for effectId, effectValue in pairs(workerData.effectDict) do
              if 0 < effectValue then
                if curBuildingAttrDict[effectId] == nil then
                  curBuildingAttrDict[effectId] = 0
                end
                curBuildingAttrDict[effectId] = curBuildingAttrDict[effectId] + effectValue
              end
            end
          end
        end
      end
      if 0 < curBuildingHaveWorker then
        curBuildingAttrData.buildindData = building
        curBuildingAttrData.attrData = {}
        for effectId, effectValue in pairs(curBuildingAttrDict) do
          if effectId ~= baseEffectId then
            table.insert(curBuildingAttrData.attrData, {effectId = effectId, effectValue = effectValue})
          end
        end
        table.sort(curBuildingAttrData.attrData, function(a, b)
          return a.effectId > b.effectId
        end)
        if curBuildingAttrDict[baseEffectId] ~= nil then
          table.insert(curBuildingAttrData.attrData, 1, {
            effectId = baseEffectId,
            effectValue = curBuildingAttrDict[baseEffectId]
          })
        end
        table.insert(typebuildingAttrData.attrData, curBuildingAttrData)
      end
    end
    if 0 < typeBuildingHaveWorker then
      table.insert(self.buildingAttrShowData, typebuildingAttrData)
    end
  end
end

local function ShowPanel(self)
  self.power_value:SetText(string.GetFormattedSeparatorNum(self.totalWorkingWorkerPower))
  self:ShowProgress()
  self:ClearScroll()
  self:ShowEffectList()
end

local function ShowProgress(self)
  local urMaxCount = self.workerNumData[WorkerFilterQualityType.Legendary].total
  local ssrMaxCount = self.workerNumData[WorkerFilterQualityType.Genius].total
  local srMaxCount = self.workerNumData[WorkerFilterQualityType.All].total
  local urHaveCount = self.workerNumData[WorkerFilterQualityType.Legendary].have
  local ssrHaveCount = self.workerNumData[WorkerFilterQualityType.Genius].have
  local srHaveCount = self.workerNumData[WorkerFilterQualityType.All].have
  self.urSlider:SetValue(urHaveCount / urMaxCount)
  self.ssrSlider:SetValue(ssrHaveCount / ssrMaxCount)
  self.srSlider:SetValue(srHaveCount / srMaxCount)
  self.urProgress:SetText(urHaveCount .. "/" .. urMaxCount)
  self.ssrProgress:SetText(ssrHaveCount .. "/" .. ssrMaxCount)
  self.srProgress:SetText(srHaveCount .. "/" .. srMaxCount)
end

local function ShowEffectList(self)
  if table.count(self.buildingAttrShowData) > 0 then
    self.scroll_view:SetListItemCount(#self.buildingAttrShowData, false, false)
    self.scroll_view:RefreshAllShownItem()
  end
end

local function ClearScroll(self)
  self.content:RemoveComponents(WorkerAttrOverviewItem)
  self.scroll_view:ClearAllItems()
end

LWUIWorkerAttrOverview.OnCreate = OnCreate
LWUIWorkerAttrOverview.OnDestroy = OnDestroy
LWUIWorkerAttrOverview.OnCreate = OnCreate
LWUIWorkerAttrOverview.ComponentDefine = ComponentDefine
LWUIWorkerAttrOverview.ComponentDestroy = ComponentDestroy
LWUIWorkerAttrOverview.OnAddListener = OnAddListener
LWUIWorkerAttrOverview.OnRemoveListener = OnRemoveListener
LWUIWorkerAttrOverview.OnOpen = OnOpen
LWUIWorkerAttrOverview.ShowPanel = ShowPanel
LWUIWorkerAttrOverview.ShowProgress = ShowProgress
LWUIWorkerAttrOverview.OnItemMoveIn = OnItemMoveIn
LWUIWorkerAttrOverview.OnItemMoveOut = OnItemMoveOut
LWUIWorkerAttrOverview.ShowEffectList = ShowEffectList
LWUIWorkerAttrOverview.ClearScroll = ClearScroll
LWUIWorkerAttrOverview.InitShowData = InitShowData
LWUIWorkerAttrOverview.InitWorkerNumData = InitWorkerNumData
LWUIWorkerAttrOverview.InitBuildingShowData = InitBuildingShowData
return LWUIWorkerAttrOverview
