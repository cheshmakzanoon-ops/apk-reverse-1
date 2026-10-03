local UIWorkerListContent = BaseClass("UIWorkerListContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local UIWorkerInfoCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerInfoCell")
local FilterQualityTypeIndexData = {
  [1] = {
    type = WorkerFilterQualityType.All,
    text = "worker_hall_title3"
  },
  [2] = {
    type = WorkerFilterQualityType.Legendary,
    text = "worker_hall_title4"
  },
  [3] = {
    type = WorkerFilterQualityType.Genius,
    text = "worker_hall_title5"
  },
  [4] = {
    type = WorkerFilterQualityType.Other,
    text = "worker_hall_title6"
  }
}
local FilterStateTypeIndexData = {
  [1] = {
    type = WorkerFilterStateType.All,
    text = ""
  },
  [2] = {
    type = WorkerFilterStateType.WORKER,
    text = ""
  },
  [3] = {
    type = WorkerFilterStateType.RESIDENTA,
    text = ""
  }
}
local FilterOwnedTypeIndexData = {
  [1] = {
    type = WorkerFilterOwnedType.All,
    text = ""
  },
  [2] = {
    type = WorkerFilterOwnedType.Owned,
    text = ""
  },
  [3] = {
    type = WorkerFilterOwnedType.UnOwned,
    text = ""
  }
}
local FilterCanUpTypeIndexData = {
  [1] = {
    type = WorkerFilterCanUpType.All,
    text = ""
  },
  [2] = {
    type = WorkerFilterCanUpType.CanUp,
    text = ""
  }
}
local quality_toggle_path = "QualityToggleGroup/QualityToggle"
local state_filter_toggle_path = "FilterContent/ToggleGroup/StateToggle/StateFilterToggle"
local owned_filter_toggle_path = "FilterContent/Toggle2Group/OwnedToggle/OwnedFilterToggle"
local can_up_filter_toggle_path = "FilterContent/Toggle3Group/CanUpToggle/CanUpFilterToggle"
local filter_content_path = "FilterContent"
local filter_btn_path = "FilterBtn"
local filter_content_panel_path = "FilterContent/FilterContentPanel"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  DataCenter.WorkerDataManager:ClearNewTags()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.workerList = self:AddComponent(GridInfinityScrollView, "WorkerList/Content")
  self.workerListScroll = self:AddComponent(UIBaseContainer, "WorkerList")
  self.recruitBtn = self:AddComponent(UIButton, "RecruitBtn")
  self.recruitBtn:SetOnClick(function()
    GoToUtil.GotoWorkerRecruitView(true)
  end)
  self.recruitBtnText = self:AddComponent(UIText, "RecruitBtn/RecruitText")
  self.recruitBtnText:SetLocalText("worker_ui004")
  self.recruitBtn:SetActive(false)
  self.qualityToggleList = {}
  for i = 1, #FilterQualityTypeIndexData do
    local toggle = self:AddComponent(UIButton, quality_toggle_path .. tostring(i))
    local index = i
    toggle:SetOnClick(function()
      self:SetFilterQualityType(index)
    end)
    self.qualityToggleList[i] = {}
    self.qualityToggleList[i].root = toggle
    self.qualityToggleList[i].unselect_text = toggle:AddComponent(UITextMeshProUGUIEx, "unselectText")
    self.qualityToggleList[i].select = toggle:AddComponent(UIBaseContainer, "select")
    self.qualityToggleList[i].select_text = toggle:AddComponent(UITextMeshProUGUIEx, "select/selectText")
    self.qualityToggleList[i].unselect_text:SetLocalText(FilterQualityTypeIndexData[i].text)
    self.qualityToggleList[i].select_text:SetLocalText(FilterQualityTypeIndexData[i].text)
    self.qualityToggleList[i].redDot = toggle:AddComponent(UIBaseContainer, "RedDot1")
  end
  self.stateFilterToggleList = {}
  for i = 1, #FilterStateTypeIndexData do
    local state_filter_toggle = self:AddComponent(UIToggle, state_filter_toggle_path .. tostring(i))
    local index = i
    state_filter_toggle:SetOnValueChanged(function(tf)
      if tf then
        self:SetFilterStateType(index)
      end
    end)
    self.stateFilterToggleList[i] = {}
    self.stateFilterToggleList[i].root = state_filter_toggle
  end
  self.ownedFilterToggleList = {}
  for i = 1, #FilterOwnedTypeIndexData do
    local owned_filter_toggle = self:AddComponent(UIToggle, owned_filter_toggle_path .. tostring(i))
    local index = i
    owned_filter_toggle:SetOnValueChanged(function(tf)
      if tf then
        self:SetFilterOwnedType(index)
      end
    end)
    self.ownedFilterToggleList[i] = {}
    self.ownedFilterToggleList[i].root = owned_filter_toggle
  end
  self.canUpFilterToggleList = {}
  for i = 1, #FilterCanUpTypeIndexData do
    local canUp_filter_toggle = self:AddComponent(UIToggle, can_up_filter_toggle_path .. tostring(i))
    local index = i
    canUp_filter_toggle:SetOnValueChanged(function(tf)
      if tf then
        self:SetFilterCanUpType(index)
      end
    end)
    self.canUpFilterToggleList[i] = {}
    self.canUpFilterToggleList[i].root = canUp_filter_toggle
  end
  self.filter_content = self:AddComponent(UIBaseContainer, filter_content_path)
  self.filter_btn = self:AddComponent(UIButton, filter_btn_path)
  self.filter_btn:SetOnClick(function()
    self:OnFilterBtnClick()
  end)
  self.filter_content_panel = self:AddComponent(UIButton, filter_content_panel_path)
  self.filter_content_panel:SetOnClick(function()
    self:OnFilterContentPanelClick()
  end)
  self.filter_content_panel:SetActive(true)
  self.filter_content_panel:SetPosition(self.view.transform.position)
  self.filter_content_panel:SetSizeDeltaXY(self.view.rectTransform.rect.width, self.view.rectTransform.rect.height)
end

local function ComponentDestroy(self)
  self.workerList = nil
  self.workerListScroll = nil
end

local function DataDefine(self)
  self.allShowData = nil
  self.showData = nil
  self.listGO = {}
  self.hasInitWorkerList = nil
  self.filterQualityType = WorkerFilterQualityType.All
  self.filterStateType = WorkerFilterStateType.All
  self.filterOwnedType = WorkerFilterOwnedType.All
  self.filterCanUpType = WorkerFilterCanUpType.All
  self.isFiltContentOpen = false
end

local function DataDestroy(self)
  self.allShowData = nil
  self.showData = nil
  self.listGO = nil
  self.hasInitWorkerList = nil
  self.filterQualityType = nil
  self.filterStateType = nil
  self.filterOwnedType = nil
  self.filterCanUpType = nil
  self.isFiltContentOpen = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorkerInfoUpdate, self.GetWorkerInfoUpdateMsg)
  self:AddUIListener(EventId.WorkerFragUnlock, self.GetWorkerFragUnlockMsg)
  self:AddUIListener(EventId.NeedRefreshWorkerUpBubble, self.UpdateRedView)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WorkerInfoUpdate, self.GetWorkerInfoUpdateMsg)
  self:RemoveUIListener(EventId.WorkerFragUnlock, self.GetWorkerFragUnlockMsg)
  self:RemoveUIListener(EventId.NeedRefreshWorkerUpBubble, self.UpdateRedView)
end

local function ClearScroll(self)
  self.workerListScroll:RemoveComponents(UIWorkerInfoCell)
  self.workerList:DestroyChildNode()
end

local function OnInitScroll(self, go, index)
  local item = self.workerListScroll:AddComponent(UIWorkerInfoCell, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local item = self.listGO[go]
  item:SetActive(true)
  item:SetData(nil, self.showData, index + 1)
end

local function OnDestroyScrollItem(self, go, index)
end

local function OnOpen(self, param)
  self.jumpParam = param
  self.workerList:SetAnchoredPositionXY(0, 0)
  self.filterQualityType = WorkerFilterQualityType.All
  self.filterStateType = WorkerFilterStateType.All
  self.filterOwnedType = WorkerFilterOwnedType.All
  self.filterCanUpType = WorkerFilterCanUpType.All
  self.isFiltContentOpen = false
  self:InitShowData()
end

local function InitShowData(self)
  self.allShowData = {}
  self.showData = {}
  local workerData = {}
  local allShowTemp = DataCenter.WorkerTemplateManager:GetAllShowTemplate()
  for id, temp in pairs(allShowTemp) do
    workerData[id] = {temp = temp}
    workerData[id].slotData = {
      isRankEnough = false,
      isNew = false,
      isFragEnough = false
    }
    if temp.star > 0 then
      local rankBaseData = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(id, 1)
      workerData[id].rankBaseData = rankBaseData
    end
  end
  local allWorkerData = DataCenter.WorkerDataManager:GetAllWorkerData()
  for __, v in pairs(allWorkerData) do
    local cfgId = v.cfgId
    if workerData[cfgId] then
      workerData[cfgId].data = v
      if workerData[cfgId].rankBaseData then
        local rankTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(cfgId, v.rank)
        local maxRank = rankTemp.max_rank
        if maxRank > v.rank then
          local nextRankTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(cfgId, v.rank + 1)
          local goodsData = nextRankTemp.rank_goods_data
          local isRankEnough = true
          if #goodsData == 0 then
            isRankEnough = false
          else
            for _, data in ipairs(goodsData) do
              local goodsId = data[1]
              local goodsNum = data[2] or 0
              local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
              if goodsNum > curNum then
                isRankEnough = false
                break
              end
            end
          end
          workerData[cfgId].slotData.isRankEnough = isRankEnough
        end
      end
    end
  end
  for k, v in pairs(workerData) do
    if v.data then
      v.slotData.isNew = DataCenter.WorkerDataManager:IsHaveNewTag(v.data.uid)
    else
      local fragData = DataCenter.WorkerDataManager:GetFragDataById(v.temp.id)
      if fragData then
        local needNum = fragData.needNum
        local goodsId = fragData.itemCfg.id
        local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
        if needNum <= curNum then
          v.slotData.isFragEnough = true
        end
      end
    end
  end
  for k, v in pairs(workerData) do
    table.insert(self.allShowData, v)
  end
  if not self.hasInitWorkerList then
    local bindFunc1 = BindCallback(self, OnInitScroll)
    local bindFunc2 = BindCallback(self, OnUpdateScroll)
    local bindFunc3 = BindCallback(self, OnDestroyScrollItem)
    self.workerList:Init(bindFunc1, bindFunc2, bindFunc3)
  end
  self.hasInitWorkerList = true
  self:RefreshAllView()
  if self.jumpParam then
    local jumpWorkerId = self.jumpParam
    self.jumpParam = nil
    local targetIndex = -1
    for k, v in ipairs(self.showData) do
      if v.temp.id == jumpWorkerId then
        targetIndex = k
        break
      end
    end
    if 0 < targetIndex then
      self.workerList:MoveItemByIndex(targetIndex - 1)
    end
  end
end

local function GetWorkerInfoUpdateMsg(self)
  self.workerList:SetItemCount(#self.showData)
  self.workerList:ForceUpdate()
end

local function GetWorkerFragUnlockMsg(self, workerData)
  local workerId = workerData.workerId
  local workerUid = workerData.workerUid
  local targetData
  for k, v in pairs(self.allShowData) do
    if v.temp.id == workerId then
      v.data = DataCenter.WorkerDataManager:GetWorkerDataByUid(workerUid)
      targetData = v
      break
    end
  end
  if targetData then
    for i = 1, #self.listGO do
      local v = self.listGO[i]
      if v:GetActive() == true and v.showData and v.showData.temp.id == workerId then
        v:SetData(targetData, nil, nil)
        v:PlayOpenCardAni()
        break
      end
    end
  end
  self.workerList:ForceUpdate()
end

local function RefreshShowDataByFilter(self)
  self.showData = {}
  for k, v in pairs(self.allShowData) do
    if self:CheckDataPassByFilter(v) then
      table.insert(self.showData, v)
    end
  end
  table.sort(self.showData, function(a, b)
    local aIsHave = a.data ~= nil
    local bIsHave = b.data ~= nil
    if a.slotData.isFragEnough ~= b.slotData.isFragEnough then
      if a.slotData.isFragEnough then
        return true
      else
        return false
      end
    end
    if aIsHave ~= bIsHave then
      if aIsHave then
        return true
      else
        return false
      end
    end
    if a.temp.quality ~= b.temp.quality then
      return a.temp.quality > b.temp.quality
    end
    if aIsHave and a.slotData.isRankEnough ~= b.slotData.isRankEnough then
      if a.slotData.isRankEnough then
        return true
      elseif b.slotData.isRankEnough then
        return false
      end
    end
    if aIsHave and a.data.state ~= b.data.state then
      if a.data.state == WorkerState.WORKER then
        return true
      elseif b.data.state == WorkerState.WORKER then
        return false
      end
    end
    local aIsStar = a.rankBaseData ~= nil
    local bIsStar = b.rankBaseData ~= nil
    if aIsStar ~= bIsStar then
      if aIsStar then
        return true
      else
        return false
      end
    end
    if aIsHave and aIsStar then
      return a.data.rank > b.data.rank
    end
    return a.temp.id < b.temp.id
  end)
end

local function CheckDataPassByFilter(self, data)
  local isPass = true
  isPass = isPass and self:CheckDataPassByFilterQualityType(data)
  isPass = isPass and self:CheckDataPassByFilterStateType(data)
  isPass = isPass and self:CheckDataPassByFilterOwnedType(data)
  isPass = isPass and self:CheckDataPassByFilterCanUpType(data)
  return isPass
end

local function CheckDataPassByFilterQualityType(self, data)
  local isPass = false
  if self.filterQualityType == WorkerFilterQualityType.All then
    isPass = true
  elseif self.filterQualityType == WorkerFilterQualityType.Legendary then
    if data.temp.quality == WorkerQualityType.Legendary then
      isPass = true
    end
  elseif self.filterQualityType == WorkerFilterQualityType.Genius then
    if data.temp.quality == WorkerQualityType.Genius then
      isPass = true
    end
  elseif self.filterQualityType == WorkerFilterQualityType.Other and data.temp.quality < WorkerQualityType.Genius then
    isPass = true
  end
  return isPass
end

local function CheckDataPassByFilterStateType(self, data)
  local isPass = false
  if self.filterStateType == WorkerFilterStateType.All then
    isPass = true
  elseif self.filterStateType == WorkerFilterStateType.WORKER then
    if data.data and data.data.state == WorkerState.WORKER then
      isPass = true
    end
  elseif self.filterStateType == WorkerFilterStateType.RESIDENTA then
    if data.data then
      if data.data.state == WorkerState.RESIDENTA then
        isPass = true
      end
    else
      isPass = true
    end
  end
  return isPass
end

local function CheckDataPassByFilterOwnedType(self, data)
  local isPass = false
  if self.filterOwnedType == WorkerFilterOwnedType.All then
    isPass = true
  elseif self.filterOwnedType == WorkerFilterOwnedType.Owned then
    if data.data then
      isPass = true
    end
  elseif self.filterOwnedType == WorkerFilterOwnedType.UnOwned and not data.data then
    isPass = true
  end
  return isPass
end

local function CheckDataPassByFilterCanUpType(self, data)
  local isPass = false
  if self.filterCanUpType == WorkerFilterCanUpType.All then
    isPass = true
  elseif self.filterCanUpType == WorkerFilterCanUpType.CanUp and data.data and data.slotData.isRankEnough then
    isPass = true
  end
  return isPass
end

local function SetFilterQualityType(self, index)
  local setType = FilterQualityTypeIndexData[index].type
  if setType == self.filterQualityType then
    return
  end
  self.filterQualityType = setType
  self:RefreshAllView()
end

local function SetFilterStateType(self, index)
  local setType = FilterStateTypeIndexData[index].type
  if setType == self.filterStateType then
    return
  end
  self.filterStateType = setType
  self:RefreshAllView()
end

local function SetFilterOwnedType(self, index)
  local setType = FilterOwnedTypeIndexData[index].type
  if setType == self.filterOwnedType then
    return
  end
  self.filterOwnedType = setType
  self:RefreshAllView()
end

local function SetFilterCanUpType(self, index)
  local setType = FilterCanUpTypeIndexData[index].type
  if setType == self.filterCanUpType then
    return
  end
  self.filterCanUpType = setType
  self:RefreshAllView()
end

local function RefreshQualityFilterView(self)
  for i = 1, #FilterQualityTypeIndexData do
    self.qualityToggleList[i].select:SetActive(self.filterQualityType == FilterQualityTypeIndexData[i].type)
  end
end

local function RefreshFilterContentView(self)
  self.filter_content:SetActive(self.isFiltContentOpen)
  if self.isFiltContentOpen then
    local isOnIndex = 1
    for i = 1, #FilterStateTypeIndexData do
      if FilterStateTypeIndexData[i].type == self.filterStateType then
        isOnIndex = i
        break
      end
    end
    self.stateFilterToggleList[isOnIndex].root:SetIsOn(true)
    isOnIndex = 1
    for i = 1, #FilterOwnedTypeIndexData do
      if FilterOwnedTypeIndexData[i].type == self.filterOwnedType then
        isOnIndex = i
        break
      end
    end
    self.ownedFilterToggleList[isOnIndex].root:SetIsOn(true)
    isOnIndex = 1
    for i = 1, #FilterCanUpTypeIndexData do
      if FilterCanUpTypeIndexData[i].type == self.filterCanUpType then
        isOnIndex = i
        break
      end
    end
    self.canUpFilterToggleList[isOnIndex].root:SetIsOn(true)
  end
end

local function RefreshAllView(self)
  self.workerList:SetAnchoredPositionXY(0, 0)
  self:RefreshShowDataByFilter()
  self.workerList:SetItemCount(#self.showData)
  self.workerList:ForceUpdate()
  self:RefreshQualityFilterView()
  self:RefreshFilterContentView()
  self:UpdateRedView()
end

local function OnFilterBtnClick(self)
  self.isFiltContentOpen = not self.isFiltContentOpen
  self:RefreshFilterContentView()
end

local function OnFilterContentPanelClick(self)
  self.isFiltContentOpen = false
  self:RefreshFilterContentView()
end

local function UpdateRedView(self)
  local isUR = DataCenter.WorkerUpBuildBubbleDataManager:CheckURWorkerCanRankUp()
  local isSSR = DataCenter.WorkerUpBuildBubbleDataManager:CheckSSRWorkerCanRankUp()
  for i = 1, #FilterQualityTypeIndexData do
    if FilterQualityTypeIndexData[i].type == WorkerFilterQualityType.Legendary then
      self.qualityToggleList[i].redDot:SetActive(isUR)
    elseif FilterQualityTypeIndexData[i].type == WorkerFilterQualityType.Genius then
      self.qualityToggleList[i].redDot:SetActive(isSSR)
    else
      self.qualityToggleList[i].redDot:SetActive(false)
    end
  end
end

UIWorkerListContent.OnCreate = OnCreate
UIWorkerListContent.OnDestroy = OnDestroy
UIWorkerListContent.DataDefine = DataDefine
UIWorkerListContent.DataDestroy = DataDestroy
UIWorkerListContent.ComponentDefine = ComponentDefine
UIWorkerListContent.ComponentDestroy = ComponentDestroy
UIWorkerListContent.OnAddListener = OnAddListener
UIWorkerListContent.OnRemoveListener = OnRemoveListener
UIWorkerListContent.OnOpen = OnOpen
UIWorkerListContent.InitShowData = InitShowData
UIWorkerListContent.ClearScroll = ClearScroll
UIWorkerListContent.GetWorkerInfoUpdateMsg = GetWorkerInfoUpdateMsg
UIWorkerListContent.GetWorkerFragUnlockMsg = GetWorkerFragUnlockMsg
UIWorkerListContent.RefreshShowDataByFilter = RefreshShowDataByFilter
UIWorkerListContent.CheckDataPassByFilter = CheckDataPassByFilter
UIWorkerListContent.CheckDataPassByFilterQualityType = CheckDataPassByFilterQualityType
UIWorkerListContent.CheckDataPassByFilterStateType = CheckDataPassByFilterStateType
UIWorkerListContent.CheckDataPassByFilterOwnedType = CheckDataPassByFilterOwnedType
UIWorkerListContent.CheckDataPassByFilterCanUpType = CheckDataPassByFilterCanUpType
UIWorkerListContent.SetFilterQualityType = SetFilterQualityType
UIWorkerListContent.SetFilterStateType = SetFilterStateType
UIWorkerListContent.SetFilterOwnedType = SetFilterOwnedType
UIWorkerListContent.SetFilterCanUpType = SetFilterCanUpType
UIWorkerListContent.RefreshQualityFilterView = RefreshQualityFilterView
UIWorkerListContent.RefreshFilterContentView = RefreshFilterContentView
UIWorkerListContent.RefreshAllView = RefreshAllView
UIWorkerListContent.OnFilterBtnClick = OnFilterBtnClick
UIWorkerListContent.OnFilterContentPanelClick = OnFilterContentPanelClick
UIWorkerListContent.UpdateRedView = UpdateRedView
return UIWorkerListContent
