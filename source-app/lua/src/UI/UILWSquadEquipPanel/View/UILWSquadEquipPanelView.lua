local UILWSquadEquipPanelView = BaseClass("UILWSquadEquipPanelView", UIBaseView)
local base = UIBaseView
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UILWSquadEquipTabItem = require("UI.UILWSquadEquipPanel.Component.UILWSquadEquipTabItem")
local UILWSquadEquipItem = require("UI.UILWSquadEquipPanel.Component.UILWSquadEquipItem")
local Const = require("Scene.LWBattle.Const")
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local back_btn_path = "BottomBar/BtnBack"
local tab_scroll_path = "Root/TopBar/ConditionBtnScroll"
local tab_container_path = "Root/TopBar/ConditionBtnScroll/ConditionBtns"
local equip_path = "MiddleContentContainer/SquadDetail/Line%d/SquadEquipItem%d"
local line_path = "MiddleContentContainer/SquadDetail/Line%d"
local left_pointer_path = "Root/TopBar/LeftPointer"
local right_pointer_path = "Root/TopBar/RightPointer"
local effect_btn_path = "Root/TopBar/SquadDetailInfos/DetailInfoBtn"
local effect_desc_text_path = "Root/TopBar/SquadDetailInfos/DetailInfoText"
local middle_content_container_path = "MiddleContentContainer"
local quick_equip_btn_path = "BottomBar/QuickEquipBtn"

local function InitCamera(self)
  self.camera = CS.UnityEngine.Camera.main
  self.touchCamera = self.camera:GetComponent(typeof(MobileTouchCamera))
  if not IsNull(self.touchCamera) then
    local standardRatio = DefaultScreenWidth / DefaultScreenHeight
    local ratio = Screen.width / Screen.height
    local zoom = 60
    if standardRatio > ratio then
      zoom = 60 * (standardRatio / ratio)
    end
    self.CameraZoom = zoom
    self.touchCamera.CamZoomMin = self.CameraZoom
  end
end

local function UnInitCamera(self)
  if not IsNull(self.touchCamera) then
    self.touchCamera.CamZoomMin = self.touchCamera.CamZoomMinCity
    if self.touchCamera.CurrentState == MobileTouchCamera.State.Idle or self.isMovingCamera then
      local touchCam = self.touchCamera
      TimerManager:GetInstance():DelayFrameInvoke(function()
        if not IsNull(touchCam) and SceneUtils.GetIsInCity() then
          touchCam:AutoZoom(touchCam.CamZoomInit, 0.2)
        end
      end, 1)
    end
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.tabsData = self.view.ctrl:GetTabsData()
  local buildUuid = self:GetUserData()
  local defaultSelectedIndex = 1
  if buildUuid then
    for i, v in pairs(self.tabsData) do
      if tostring(v.buildUuid) == tostring(buildUuid) then
        defaultSelectedIndex = i
        break
      end
    end
  end
  InitCamera(self)
  self.selectedIndex = defaultSelectedIndex
  self:CreateTabs()
  self:RefreshSquadDetail()
end

local function OnDestroy(self)
  UnInitCamera(self)
  self:ClearTabs()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local TabWidth = 235

local function RefreshPointer(self)
  if not table.IsNullOrEmpty(self.tabItems) then
    local leftRedNum = 0
    local rightRedNum = 0
    local scrollPos = -self.tabContainer:GetAnchoredPositionX()
    local scrollSize = self.tabScroll.rectTransform.rect.width
    local scrollLeftPos = scrollPos
    local scrollRightPos = scrollPos + scrollSize
    for index, v in pairs(self.tabItems) do
      local leftBoundPos = (index - 1) * TabWidth
      local rightBoundPos = index * TabWidth
      if scrollLeftPos > rightBoundPos then
        leftRedNum = leftRedNum + v:GetRedNum()
      elseif scrollRightPos < leftBoundPos then
        rightRedNum = rightRedNum + v:GetRedNum()
      end
    end
    self.leftPointer:SetActive(0 < leftRedNum)
    self.rightPointer:SetActive(0 < rightRedNum)
  else
    self.leftPointer:SetActive(false)
    self.rightPointer:SetActive(false)
  end
end

local function OnEffectBtnClick(self)
  if table.IsNullOrEmpty(self.tabsData) then
    return
  end
  if not self.selectedIndex then
    return
  end
  local selectedTabData = self.tabsData[self.selectedIndex]
  local selectedBuildingUuid = selectedTabData.buildUuid
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSquadEquipEffect, {anim = true}, selectedBuildingUuid)
end

local function OnQuickEquipBtn(self)
  if table.IsNullOrEmpty(self.quickPutOnEquips) and self.selectedIndex then
    return
  end
  local msgData = {}
  for i, v in pairs(self.quickPutOnEquips) do
    msgData[i] = v.uuid
  end
  local selectedTabData = self.tabsData[self.selectedIndex]
  local selectedBuildingUuid = selectedTabData.buildUuid
  SFSNetwork.SendMessage(MsgDefines.CommonEquipPutOn, tostring(selectedBuildingUuid), msgData)
end

local function ComponentDefine(self)
  self.backBtn = self:AddComponent(UIButton, back_btn_path)
  self.backBtn:SetOnClick(function()
    self:ClosePanel()
  end)
  self.tabContainer = self:AddComponent(UIBaseContainer, tab_container_path)
  self.tabScroll = self:AddComponent(UIScrollRect, tab_scroll_path)
  self.tabScroll:AddValueChangeListener(function()
    self:RefreshPointer()
  end)
  self.equips = {}
  self.lines = {}
  for i = 1, 5 do
    local equip = self:AddComponent(UILWSquadEquipItem, string.format(equip_path, i, i))
    local line = self:AddComponent(UIImage, string.format(line_path, i))
    table.insert(self.equips, equip)
    table.insert(self.lines, line)
  end
  self.leftPointer = self:AddComponent(UIImage, left_pointer_path)
  self.rightPointer = self:AddComponent(UIImage, right_pointer_path)
  self.effectBtn = self:AddComponent(UIButton, effect_btn_path)
  self.effectBtn:SetOnClick(function()
    self:OnEffectBtnClick()
  end)
  self.effectDescText = self:AddComponent(UIText, effect_desc_text_path)
  self.middleContentContainer = self:AddComponent(UIBaseContainer, middle_content_container_path)
  self.quickEquipBtn = self:AddComponent(UIButton, quick_equip_btn_path)
  self.quickEquipBtn:SetOnClick(function()
    OnQuickEquipBtn(self)
  end)
end

local function ComponentDestroy(self)
  self.backBtn = nil
  self.tabContainer = nil
  self.tabScroll = nil
  self.equips = nil
  self.lines = nil
  self.leftPointer = nil
  self.rightPointer = nil
  self.effectBtn = nil
  self.effectDescText = nil
  self.middleContentContainer = nil
  self.quickEquipBtn = nil
end

local function DataDefine(self)
  self.CameraZoom = 60
  self.isMovingCamera = false
end

local function DataDestroy(self)
  self.isMovingCamera = false
end

local function OnEquipDataChange(self)
  self:RefreshSquadDetail()
  if self.tabsComps then
    for _, v in pairs(self.tabsComps) do
      v:RefreshRedPoint()
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PutonCommonEquip, self.OnEquipDataChange)
  self:AddUIListener(EventId.PutoffCommonEquip, self.OnEquipDataChange)
  self:AddUIListener(EventId.CommonEquipDataChanged, self.OnEquipDataChange)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PutonCommonEquip, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.PutoffCommonEquip, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.CommonEquipDataChanged, self.OnEquipDataChange)
end

local function ClearTabs(self)
  if not table.IsNullOrEmpty(self.tabs) then
    for i, v in pairs(self.tabs) do
      self:GameObjectDestroy(v)
    end
  end
  self.tabs = {}
  self.tabsComps = {}
end

local function OnFinishLoad(self)
  if not self.selectedIndex then
    return
  end
  local index = self.selectedIndex
  if not table.IsNullOrEmpty(self.tabs) then
    local posX = (index - 1) / (table.count(self.tabs) - 1)
    self.tabScroll:SetHorizontalNormalizedPosition(posX)
    self:RefreshPointer()
  end
end

local function CreateTabs(self)
  self:ClearTabs()
  for i, v in pairs(self.tabsData) do
    self.loadCount = 0
    self.tabs[i] = self:GameObjectInstantiateAsync(UIAssets.UILWSquadEquipPageToggle, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.tabContainer.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "SquadTab" .. i
      local cell = self.tabContainer:AddComponent(UILWSquadEquipTabItem, go.name)
      cell:Refresh(i, self.tabsData[i])
      cell:SetSelected(i == self.selectedIndex)
      self.tabsComps[i] = cell
      self.loadCount = self.loadCount + 1
      if self.loadCount == #self.tabsData then
        self:OnFinishLoad()
      end
    end)
  end
end

local function ReInit(self)
end

local CameraMoveTime = 0.2

local function LookAtBuilding(self, buildData)
  if not buildData then
    return
  end
  local worldPointPos = SceneUtils.TileIndexToWorld(buildData.pointId) + Vector3.New(-17.4, -1.6, 0)
  local world = CS.SceneManager.World
  if world ~= nil then
    pcall(function()
      world:StopCameraMove()
    end)
  end
  self.isMovingCamera = true
  GoToUtil.GotoPos(worldPointPos, self.CameraZoom, CameraMoveTime, function()
    if self then
      self.isMovingCamera = false
    end
  end)
end

local function RefreshSquadDetail(self)
  local selectedTabData = self.tabsData[self.selectedIndex]
  if selectedTabData then
    self.effectDescText:SetLocalText(2000531, selectedTabData.index)
  end
  local selectedBuildingUuid = selectedTabData.buildUuid
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(selectedBuildingUuid)
  if buildingData then
    if buildingData.level >= 1 then
      for i, v in pairs(self.equips) do
        v:SetActive(true)
        v:SetData(selectedBuildingUuid, i)
      end
      for i, v in pairs(self.lines) do
        v:SetActive(true)
      end
      self.effectBtn:SetActive(true)
    else
      for i, v in pairs(self.equips) do
        v:SetActive(false)
      end
      for i, v in pairs(self.lines) do
        v:SetActive(false)
      end
      self.effectBtn:SetActive(false)
    end
    self:LookAtBuilding(buildingData)
  end
  self.quickPutOnEquips = DataCenter.CommonEquipDataManager:IsHasBetterCommonEquip(CommonEquipType.SquadEquip, selectedBuildingUuid)
  self.quickEquipBtn:SetActive(not table.IsNullOrEmpty(self.quickPutOnEquips))
end

local function OnToggleItemClick(self, index)
  if self.selectedIndex == index then
    return
  end
  for i, v in pairs(self.tabsComps) do
    v:SetSelected(i == index)
  end
  self.selectedIndex = index
  self:RefreshSquadDetail()
end

local function ClosePanel(self)
  self.view.ctrl:CloseSelf()
end

UILWSquadEquipPanelView.OnCreate = OnCreate
UILWSquadEquipPanelView.OnDestroy = OnDestroy
UILWSquadEquipPanelView.OnEnable = OnEnable
UILWSquadEquipPanelView.OnDisable = OnDisable
UILWSquadEquipPanelView.ComponentDefine = ComponentDefine
UILWSquadEquipPanelView.ComponentDestroy = ComponentDestroy
UILWSquadEquipPanelView.DataDefine = DataDefine
UILWSquadEquipPanelView.DataDestroy = DataDestroy
UILWSquadEquipPanelView.OnAddListener = OnAddListener
UILWSquadEquipPanelView.OnRemoveListener = OnRemoveListener
UILWSquadEquipPanelView.ClearTabs = ClearTabs
UILWSquadEquipPanelView.CreateTabs = CreateTabs
UILWSquadEquipPanelView.LookAtBuilding = LookAtBuilding
UILWSquadEquipPanelView.RefreshSquadDetail = RefreshSquadDetail
UILWSquadEquipPanelView.OnToggleItemClick = OnToggleItemClick
UILWSquadEquipPanelView.OnFinishLoad = OnFinishLoad
UILWSquadEquipPanelView.RefreshPointer = RefreshPointer
UILWSquadEquipPanelView.OnEquipDataChange = OnEquipDataChange
UILWSquadEquipPanelView.OnEffectBtnClick = OnEffectBtnClick
UILWSquadEquipPanelView.ClosePanel = ClosePanel
UILWSquadEquipPanelView.ReInit = ReInit
return UILWSquadEquipPanelView
