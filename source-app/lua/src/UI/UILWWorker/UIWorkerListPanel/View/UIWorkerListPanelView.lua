local UILWWorkerListPanelView = BaseClass("UILWWorkerListPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Resource = CS.GameEntry.Resource
local UIWorkerCell = require("UI.UILWWorker.UIWorkerListPanel.Component.UIWorkerCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function SelectWorker(self, workerUUid)
  local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(workerUUid)
  if workerData == nil then
    self.workPlaceGroup:SetActive(false)
    self.expertGroup:SetActive(false)
    UIGray.SetGray(self.gotoBtn.transform, true, false)
    return
  end
  self.workPlaceGroup:SetActive(true)
  self.expertGroup:SetActive(true)
  UIGray.SetGray(self.gotoBtn.transform, false, true)
  local workPlaceStr = ""
  if workerData.workingBuildList ~= nil then
    self.workingBuildList = workerData.workingBuildList
    for __, v in pairs(workerData.workingBuildList) do
      local buildTempalte = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(v)
      if buildTempalte ~= nil then
        workPlaceStr = workPlaceStr .. Localization:GetString(buildTempalte.name) .. " "
      end
    end
  end
  self.workPlaceValueText:SetText(workPlaceStr)
  local expertStr = ""
  expertStr = WorkerUtil.GetEffectText(tonumber(workerData.peculiarity), tonumber(workerData.peculiarityVlue))
  self.expertValueText:SetText(expertStr)
end

local function GotoBuliding(self)
  if self.workingBuildList == nil or table.count(self.workingBuildList) == 0 then
    return
  end
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(self.workingBuildList[1])
  if 0 < #buildList then
    table.sort(buildList, function(a, b)
      if a.level ~= b.level then
        return a.level > b.level
      end
      local aBuildingPower = 0
      local bBuildingPower = 0
      for __, v in pairs(a.assignedHeroList) do
        local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(v)
        if workerData ~= nil then
          aBuildingPower = aBuildingPower + workerData.power
        end
      end
      for __, v in pairs(b.assignedHeroList) do
        local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(v)
        if workerData ~= nil then
          bBuildingPower = bBuildingPower + workerData.power
        end
      end
      if aBuildingPower ~= bBuildingPower then
        return aBuildingPower < bBuildingPower
      end
      return a.uuid < b.uuid
    end)
    local buildingData = buildList[1]
    self.ctrl.CloseSelf()
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildingData.pointId, ForceChangeScene.City), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      TimerManager:GetInstance():DelayInvoke(function()
        UIUtil.OpenLWUIBuildDetailsView(tostring(buildingData.pointId))
      end, 0.15)
    end)
  else
    UIUtil.ShowTipsId(135208)
  end
end

local function ClickWorkerCell(self, workerUUid, item)
  if self.selectedWorkerUuid ~= nil then
    local lastItem = self.workerItems[self.selectedWorkerUuid]
    if lastItem ~= nil then
      lastItem:SetSelected(false)
    end
  end
  self.selectedWorkerUuid = workerUUid
  item:SetSelected(true)
  SelectWorker(self, workerUUid)
end

local function ClearScroll(self)
  self.workerListScroll:RemoveComponents(UIWorkerCell)
  self.workerList:DestroyChildNode()
end

local function OnInitScroll(self, go, index)
  local item = self.workerListScroll:AddComponent(UIWorkerCell, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local item = self.listGO[go]
  local uuid = self.workerDataList[index + 1]
  item:SetData(uuid, BindCallback(self, ClickWorkerCell))
  item:SetSelected(self.selectedWorkerUuid == uuid)
  self.workerItems[uuid] = item
end

local function OnDestroyScrollItem(self, go, index)
  local uuid = self.workerDataList[index + 1]
  self.workerItems[uuid] = nil
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.closeBtn:SetOnClick(BindCallback(self, self.ClosePanel))
  self.bgCloseBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.bgCloseBtn:SetOnClick(BindCallback(self, self.ClosePanel))
  self.emptyWorkerContent = self:AddComponent(UIBaseContainer, "Root/EmptyWorkerContent")
  self.emptyWorkerText = self:AddComponent(UIText, "Root/EmptyWorkerContent/EmptyWorkerText")
  self.workerContent = self:AddComponent(UIBaseContainer, "Root/WorkerContent")
  self.workerList = self:AddComponent(GridInfinityScrollView, "Root/WorkerContent/WorkerList/Content")
  self.workerListScroll = self:AddComponent(UIBaseContainer, "Root/WorkerContent/WorkerList")
  self.workPlaceGroup = self:AddComponent(UIBaseContainer, "Root/WorkerContent/WorkPlaceGroup")
  self.workPlaceGroupTitleText = self:AddComponent(UIText, "Root/WorkerContent/WorkPlaceGroup/WorkPlaceTitleText")
  self.workPlaceValueText = self:AddComponent(UIText, "Root/WorkerContent/WorkPlaceGroup/WorkPlaceValueText")
  self.expertGroup = self:AddComponent(UIBaseContainer, "Root/WorkerContent/ExpertGroup")
  self.expertGroupTitleText = self:AddComponent(UIText, "Root/WorkerContent/ExpertGroup/ExpertTitleText")
  self.expertValueText = self:AddComponent(UIText, "Root/WorkerContent/ExpertGroup/ExpertValueText")
  self.gotoBtn = self:AddComponent(UIButton, "Root/GotoBtn")
  self.gotoBtnText = self:AddComponent(UIText, "Root/GotoBtn/GotoBtnText")
  self.gotoBtn:SetOnClick(BindCallback(self, GotoBuliding))
  self.titleText:SetLocalText(135187)
  self.workPlaceGroupTitleText:SetLocalText(100038)
  self.expertGroupTitleText:SetLocalText(135201)
  self.gotoBtnText:SetLocalText(110003)
  self.emptyWorkerText:SetLocalText(135207)
end

local function DataDefine(self)
  self.hasInitWorkerList = false
  self.listGO = {}
  self.workerItems = {}
  self.selectedWorkerUuId = nil
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.closeBtn = nil
  self.bgCloseBtn = nil
  self.emptyWorkerContent = nil
  self.emptyWorkerText = nil
  self.workerContent = nil
  self.workerList = nil
  self.workerListScroll = nil
  self.workPlaceGroup = nil
  self.workPlaceGroupTitleText = nil
  self.workPlaceValueText = nil
  self.expertGroup = nil
  self.expertGroupTitleText = nil
  self.expertValueText = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
end

local function DataDestroy(self)
  self.hasInitWorkerList = false
  self.listGo = nil
  self.workerItems = nil
  self.selectedWorkerUuId = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnOpen(self)
  self:UpdateView()
  SelectWorker(self, nil)
end

local function UpdateView(self)
  self.workerDataList = self.ctrl:GetResidentWorkerList()
  local count = #self.workerDataList
  if count <= 0 then
    self.workerContent:SetActive(false)
    self.emptyWorkerContent:SetActive(true)
    UIGray.SetGray(self.gotoBtn.transform, true, false)
  else
    self.workerContent:SetActive(true)
    self.emptyWorkerContent:SetActive(false)
    if not self.hasInitWorkerList then
      local bindFunc1 = BindCallback(self, OnInitScroll)
      local bindFunc2 = BindCallback(self, OnUpdateScroll)
      local bindFunc3 = BindCallback(self, OnDestroyScrollItem)
      self.workerList:Init(bindFunc1, bindFunc2, bindFunc3)
    end
    self.hasInitWorkerList = true
    self.workerList:SetItemCount(count)
    self.workerList:ForceUpdate()
  end
end

local function ClosePanel(self)
  self.ctrl:CloseSelf()
end

UILWWorkerListPanelView.OnCreate = OnCreate
UILWWorkerListPanelView.OnDestroy = OnDestroy
UILWWorkerListPanelView.OnEnable = OnEnable
UILWWorkerListPanelView.OnDisable = OnDisable
UILWWorkerListPanelView.UpdateView = UpdateView
UILWWorkerListPanelView.OnAddListener = OnAddListener
UILWWorkerListPanelView.OnRemoveListener = OnRemoveListener
UILWWorkerListPanelView.ComponentDefine = ComponentDefine
UILWWorkerListPanelView.DataDefine = DataDefine
UILWWorkerListPanelView.ComponentDestroy = ComponentDestroy
UILWWorkerListPanelView.DataDestroy = DataDestroy
UILWWorkerListPanelView.OnOpen = OnOpen
UILWWorkerListPanelView.ClosePanel = ClosePanel
return UILWWorkerListPanelView
