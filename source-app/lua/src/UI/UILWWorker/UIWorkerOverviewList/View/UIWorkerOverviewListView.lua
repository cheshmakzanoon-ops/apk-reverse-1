local UIWorkerOverviewListView = BaseClass("UIWorkerOverviewListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Resource = CS.GameEntry.Resource
local UIWorkerListContent = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerListContent")
local BuildingGroupDispatchContent = require("UI.UILWWorker.UIWorkerOverviewList.Component.BuildingGroupDispatchContent")
local LWUIWorkerAttrOverview = require("UI.UILWWorker.UIWorkerOverviewList.Component.AttributeContent.LWUIWorkerAttrOverview")
local UISurvivorPackView = require("UI.UISurvivorPack.View.UISurvivorPackView")
local worker_attr_btn_path = "Root/MiddleContentContainer/ConditionBtns/WorkerAttrBtn"
local worker_attr_btn_text_path = "Root/MiddleContentContainer/ConditionBtns/WorkerAttrBtn/WorkerAttrBtnText"
local selected_arrow3_path = "Root/MiddleContentContainer/ConditionBtns/WorkerAttrBtn/SelectedArrow3"
local all_worker_btn_red_point_path = "Root/MiddleContentContainer/ConditionBtns/AllWorkerBtn/AllWorkerBtnRedPoint"
local BuildingGroupDispatchContentPath = "Assets/Main/Prefabs/UI/UIWorker/UIWorkerOverviewListPanel_BuildingGroupDispatchContent.prefab"
local BuildingGroupDispatchContent = require("UI.UILWWorker.UIWorkerOverviewList.Component.BuildingGroupDispatchContent")
local WorkerAttrOverviewPath = "Assets/Main/Prefabs/UI/UIWorker/UIWorkerOverviewListPanel_WorkerAttrOverview.prefab"
local LWUIWorkerAttrOverview = require("UI.UILWWorker.UIWorkerOverviewList.Component.AttributeContent.LWUIWorkerAttrOverview")
local WorkerListMaskPath = "Assets/Main/Prefabs/UI/UIWorker/UIWorkerOverviewListPanel_WorkerListMask.prefab"
local UIWorkerListContent = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerListContent")
local ViewShowType = {
  AllWorker = 1,
  BuildingWorker = 2,
  WorkerAttr = 3,
  SurvivorPack = 4
}

local function OnCreate(self)
  base.OnCreate(self)
  self.jumpData = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.titleText = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.titleText:SetLocalText("worker_ui001")
  self.allWorkerBtn = self:AddComponent(UIButton, "Root/MiddleContentContainer/ConditionBtns/AllWorkerBtn")
  self.allWorkerBtnImg = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/AllWorkerBtn")
  self.allWorkerBtnText = self:AddComponent(UIText, "Root/MiddleContentContainer/ConditionBtns/AllWorkerBtn/AllWorkerBtnText")
  self.selectedArrow1 = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/AllWorkerBtn/SelectedArrow1")
  self.allWorkerBtnText:SetLocalText("worker_ui002")
  self.all_worker_btn_red_point = self:AddComponent(UIImage, all_worker_btn_red_point_path)
  self.buildingWorkerBtn = self:AddComponent(UIButton, "Root/MiddleContentContainer/ConditionBtns/BuildingWorkerBtn")
  self.buildingWorkerBtnImg = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/BuildingWorkerBtn")
  self.buildingWorkerBtnText = self:AddComponent(UIText, "Root/MiddleContentContainer/ConditionBtns/BuildingWorkerBtn/BuildingWorkerBtnText")
  self.selectedArrow2 = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/BuildingWorkerBtn/SelectedArrow2")
  self.buildingWorkerBtnText:SetLocalText("worker_ui003")
  self.survivorPackBtn = self:AddComponent(UIButton, "Root/MiddleContentContainer/ConditionBtns/SurvivorPackBtn")
  self.survivorPackBtnImg = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/SurvivorPackBtn")
  self.survivorPackBtnText = self:AddComponent(UIText, "Root/MiddleContentContainer/ConditionBtns/SurvivorPackBtn/SurvivorPackBtnText")
  self.selectedArrow4 = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/SurvivorPackBtn/SelectedArrow4")
  self.survivorPackBtnRedPoint = self:AddComponent(UIImage, "Root/MiddleContentContainer/ConditionBtns/SurvivorPackBtn/SurvivorPackBtnRedPoint")
  self.viewList = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/ViewList")
  self.worker_attr_btn = self:AddComponent(UIButton, worker_attr_btn_path)
  self.worker_attr_btn_img = self:AddComponent(UIImage, worker_attr_btn_path)
  self.worker_attr_btn_text = self:AddComponent(UITextMeshProUGUIEx, worker_attr_btn_text_path)
  self.selected_arrow3 = self:AddComponent(UIImage, selected_arrow3_path)
  self.worker_attr_btn_text:SetLocalText("worker_hall_title7")
  self.allWorkerBtn:SetOnClick(function()
    self:SelectShowType(ViewShowType.AllWorker)
  end)
  self.buildingWorkerBtn:SetOnClick(function()
    self:SelectShowType(ViewShowType.BuildingWorker)
  end)
  self.worker_attr_btn:SetOnClick(function()
    self:SelectShowType(ViewShowType.WorkerAttr)
  end)
  self.survivorPackBtn:SetOnClick(function()
    self:SelectShowType(ViewShowType.SurvivorPack)
  end)
  self.selectedArrows = {}
  self.selectedArrows[ViewShowType.AllWorker] = self.selectedArrow1
  self.selectedArrows[ViewShowType.BuildingWorker] = self.selectedArrow2
  self.selectedArrows[ViewShowType.WorkerAttr] = self.selected_arrow3
  self.selectedArrows[ViewShowType.SurvivorPack] = self.selectedArrow4
  self.btnBgs = {}
  self.btnBgs[ViewShowType.AllWorker] = self.allWorkerBtnImg
  self.btnBgs[ViewShowType.BuildingWorker] = self.buildingWorkerBtnImg
  self.btnBgs[ViewShowType.WorkerAttr] = self.worker_attr_btn_img
  self.btnBgs[ViewShowType.SurvivorPack] = self.survivorPackBtnImg
  self.workerListParent = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/WorkerListMaskParent")
  self.buildingListParent = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/BuildingGroupDispatchContentParent")
  self.workerAttrOverviewParent = self:AddComponent(UIBaseContainer, "Root/MiddleContentContainer/WorkerAttrOverviewParent")
  self.subContentConfig = {
    [ViewShowType.AllWorker] = {
      Prefab = WorkerListMaskPath,
      Scripts = UIWorkerListContent,
      Parent = self.workerListParent
    },
    [ViewShowType.BuildingWorker] = {
      Prefab = BuildingGroupDispatchContentPath,
      Scripts = BuildingGroupDispatchContent,
      Parent = self.buildingListParent
    },
    [ViewShowType.WorkerAttr] = {
      Prefab = WorkerAttrOverviewPath,
      Scripts = LWUIWorkerAttrOverview,
      Parent = self.workerAttrOverviewParent
    }
  }
end

local function ComponentDestroy(self)
  self.viewList:RemoveComponents(UISurvivorPackView)
  if self.survivorPackReq then
    self:GameObjectDestroy(self.survivorPackReq)
    self.survivorPackReq = nil
  end
  self.survivorPackView = nil
  self:SetAllCellDestroy()
  self.all_worker_btn_red_point = nil
  self.workerListParent = nil
  self.buildingListParent = nil
  self.workerAttrOverviewParent = nil
end

local function DataDefine(self)
  self.viewShowType = ViewShowType.AllWorker
  self.jumpType = nil
  self.jumpParam = nil
  self.survivorPackReq = nil
  self.survivorPackView = nil
  self.componentReqList = {}
  self.componentDic = {}
end

local function DataDestroy(self)
  self.viewShowType = nil
  self.jumpType = nil
  self.jumpParam = nil
  self.survivorPackReq = nil
  self.survivorPackView = nil
  self.componentDic = {}
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.NeedRefreshWorkerUpBubble, self.UpdateRedView)
  self:AddUIListener(EventId.SurvivorPackInfoMsg, self.UpdateRedView)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.NeedRefreshWorkerUpBubble, self.UpdateRedView)
  self:RemoveUIListener(EventId.SurvivorPackInfoMsg, self.UpdateRedView)
end

local function OnOpen(self)
  if self.jumpData then
    self.jumpType = self.jumpData.jumpType
    self.jumpParam = self.jumpData.jumpParam
    self.jumpData = nil
  end
  if self.jumpType then
    self.viewShowType = self.jumpType
    self.jumpType = nil
  end
  self:UpdateView()
end

local function SelectShowType(self, viewType)
  if self.viewShowType == viewType then
    return
  end
  self.viewShowType = viewType
  self:UpdateView()
end

local function RefreshSurvivorPackBtn(self)
  local actData = DataCenter and DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.actData or nil
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local startTime = actData and tonumber(actData.startTime) or 0
  local endTime = actData and tonumber(actData.endTime) or 0
  local isOpen = actData ~= nil and actData.activityId ~= nil and 0 < startTime and nowTime < endTime and nowTime >= startTime
  self.survivorPackBtn:SetActive(isOpen)
  if isOpen and self.survivorPackBtnText then
    self.survivorPackBtnText:SetText(Localization:GetString(actData.name))
  end
  if not isOpen and self.viewShowType == ViewShowType.SurvivorPack then
    self.viewShowType = ViewShowType.AllWorker
  end
end

local function ApplySurvivorPackViewLayout(self)
  if self.survivorPackView == nil then
    return
  end
  self.survivorPackView:SetLocalScaleXYZ(1, 1, 1)
  self.survivorPackView:SetLocalPositionXYZ(0, 0, 0)
  self.survivorPackView:SetAnchorMinXY(0, 0)
  self.survivorPackView:SetAnchorMaxXY(1, 1)
  self.survivorPackView:SetOffsetMinXY(0, 0)
  self.survivorPackView:SetOffsetMaxXY(0, 0)
end

local function UpdateView(self)
  RefreshSurvivorPackBtn(self)
  for k, v in pairs(self.selectedArrows) do
    v:SetActive(k == self.viewShowType)
  end
  for k, v in pairs(self.btnBgs) do
    local bgPath = ""
    local btnPosY = 0
    local sizeX = 0
    local sizeY = 0
    if k == self.viewShowType then
      bgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_yiji_1.png"
      btnPosY = -9.2
      sizeX = 194
      sizeY = 82
    else
      bgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_yiji_2.png"
      btnPosY = -4
      sizeX = 198
      sizeY = 64
    end
    local anchoredPosX = v:GetAnchoredPositionX()
    v:LoadSprite(bgPath)
    v:SetAnchoredPositionXY(anchoredPosX, btnPosY)
    v.rectTransform:Set_sizeDelta(sizeX, sizeY)
  end
  self.viewList:SetActive(false)
  self.workerListParent:SetActive(false)
  self.buildingListParent:SetActive(false)
  self.workerAttrOverviewParent:SetActive(false)
  if self.viewShowType == ViewShowType.AllWorker then
    self.workerListParent:SetActive(true)
  elseif self.viewShowType == ViewShowType.BuildingWorker then
    self.buildingListParent:SetActive(true)
  elseif self.viewShowType == ViewShowType.WorkerAttr then
    self.workerAttrOverviewParent:SetActive(true)
  else
    if self.survivorPackView then
      self.survivorPackView:SetActive(false)
    end
    if self.viewShowType == ViewShowType.SurvivorPack then
      self.viewList:SetActive(true)
      if self.survivorPackView then
        ApplySurvivorPackViewLayout(self)
        self.survivorPackView:SetActive(true)
      elseif not self.survivorPackReq then
        local prefabPath = "Assets/Main/Prefabs/UI/UISurvivorPack/UISurvivorPack.prefab"
        self.survivorPackReq = self:GameObjectInstantiateAsync(prefabPath, function(req)
          if req == nil or IsNull(req.gameObject) then
            return
          end
          local go = req.gameObject
          go.name = "UISurvivorPackView"
          go:SetActive(true)
          go.transform:SetParent(self.viewList.transform, false)
          self.survivorPackView = self.viewList:AddComponent(UISurvivorPackView, go.name)
          if self.survivorPackView then
            ApplySurvivorPackViewLayout(self)
            self.survivorPackView:SetActive(true)
          end
        end)
      end
    end
  end
  if self.viewShowType ~= ViewShowType.SurvivorPack then
    self:ShowPanel(self.viewShowType, self.jumpParam)
  end
  self.jumpParam = nil
  self:UpdateRedView()
end

local function UpdateRedView(self)
  local isUR = DataCenter.WorkerUpBuildBubbleDataManager:CheckURWorkerCanRankUp()
  local isSSR = DataCenter.WorkerUpBuildBubbleDataManager:CheckSSRWorkerCanRankUp()
  self.all_worker_btn_red_point:SetActive(isUR or isSSR)
  if self.survivorPackBtnRedPoint ~= nil then
    local survivorPackMgr = DataCenter and DataCenter.SurvivorPackManager or nil
    local isActOpen = false
    if survivorPackMgr and survivorPackMgr.IsActOpen ~= nil then
      isActOpen = survivorPackMgr:IsActOpen()
    end
    local hasCanReceive = false
    if survivorPackMgr and survivorPackMgr.HasCanReceiveFreeOrProgressReward ~= nil then
      hasCanReceive = survivorPackMgr:HasCanReceiveFreeOrProgressReward()
    end
    self.survivorPackBtnRedPoint:SetActive(isActOpen and hasCanReceive)
  end
end

function UIWorkerOverviewListView:ShowPanel(viewShowType, jumpParam)
  if self.componentDic[viewShowType] then
    self.componentDic[viewShowType]:SetActive(true)
    self.componentDic[viewShowType]:OnOpen(jumpParam)
    return
  end
  if self.componentReqList[viewShowType] then
    return
  end
  local config = self.subContentConfig[viewShowType]
  self.componentReqList[viewShowType] = self:GameObjectInstantiateAsync(config.Prefab, function(request)
    if request.isError then
      self.componentReqList[viewShowType] = nil
      return
    end
    local go = request.gameObject
    go.transform:SetParent(config.Parent.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.transform:Set_anchorMin(0, 0)
    go.transform:Set_anchorMax(1, 1)
    go.transform:Set_offsetMin(0, 0)
    go.transform:Set_offsetMax(0, 0)
    go.name = viewShowType
    local cell = config.Parent:AddComponent(config.Scripts, go.name)
    cell:OnOpen(jumpParam)
    self.componentDic[viewShowType] = cell
  end)
end

function UIWorkerOverviewListView:SetAllCellDestroy()
  self.componentDic = {}
  for _, v in pairs(self.subContentConfig) do
    v.Parent:RemoveComponents(v.Scripts)
  end
  if self.componentReqList ~= nil then
    for k, v in pairs(self.componentReqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.componentReqList = {}
end

UIWorkerOverviewListView.OnCreate = OnCreate
UIWorkerOverviewListView.OnDestroy = OnDestroy
UIWorkerOverviewListView.OnAddListener = OnAddListener
UIWorkerOverviewListView.OnRemoveListener = OnRemoveListener
UIWorkerOverviewListView.ComponentDefine = ComponentDefine
UIWorkerOverviewListView.DataDefine = DataDefine
UIWorkerOverviewListView.ComponentDestroy = ComponentDestroy
UIWorkerOverviewListView.DataDestroy = DataDestroy
UIWorkerOverviewListView.OnOpen = OnOpen
UIWorkerOverviewListView.UpdateView = UpdateView
UIWorkerOverviewListView.SelectShowType = SelectShowType
UIWorkerOverviewListView.UpdateRedView = UpdateRedView
return UIWorkerOverviewListView
