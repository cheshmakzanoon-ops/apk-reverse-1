local UIFingerArrowView = BaseClass("UIFingerArrowView", UIBaseView)
local base = UIBaseView
local rotation_go_path = "finger"
local return_path = "Panel"
local rotationRota_go_path = "RotationGos"
local ParamData = {
  arrowType,
  positionType,
  position,
  pointId,
  uuid
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rotation_go = self:AddComponent(UIBaseContainer, rotation_go_path)
end

local function ComponentDestroy(self)
  if self.rotation_go then
    local rt = self.rotation_go.transform:GetComponent(typeof(CS.UnityEngine.RectTransform))
    rt.anchoredPosition3D = Vector3.New(63, -63, 0)
    self.rotation_go = nil
  end
end

local function DataDefine(self)
  self.param = nil
  self.modelHeight = nil
  self.arrow_timer = nil
  
  function self.arrow_action(temp)
    self:RefreshArrowTimer(temp)
  end
end

local function DataDestroy(self)
  self.param = nil
  self.modelHeight = nil
  self:DeleteArrowTimer()
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.param = DataCenter.ArrowManager:GetFingerArrowParam()
  self:InitModelHeight()
  self:Refresh()
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self)
  if self.param ~= nil then
    local screenPosition
    if self.param.positionType == PositionType.World then
      screenPosition = CS.SceneManager.World:WorldToScreenPoint(self.param.position + self.modelHeight)
    elseif self.param.positionType == PositionType.Screen then
      screenPosition = self.param.position + self.modelHeight
    elseif self.param.positionType == PositionType.PointId then
      screenPosition = CS.SceneManager.World:WorldToScreenPoint(SceneUtils.TileIndexToWorld(self.param.pointId) + self.modelHeight)
    end
    if screenPosition ~= nil then
      self.rotation_go.transform.position = screenPosition
    end
    if self.param.isPanel == false then
    else
    end
    if self.param.isReversal then
      self.rotation_go:SetActive(false)
    else
      self.rotation_go:SetActive(true)
    end
    if self.param.isAutoClose then
      self:AddArrowTimer(self.param.isAutoClose)
    end
  end
end

local function InitModelHeight(self)
  if self.modelHeight == nil then
    self.modelHeight = Vector3.New(0, 0, 0)
  end
  if self.param ~= nil then
    if self.param.arrowType == ArrowType.Monster then
      self.modelHeight.y = CS.SceneManager.World:GetModelHeight(self.param.uuid)
    elseif self.param.arrowType == ArrowType.Building then
      local pos = SceneUtils.WorldToTileIndex(self.param.position)
      self.modelHeight.y = CS.SceneManager.World:GetBuildingHeight(pos)
    elseif self.param.arrowType == ArrowType.BuildBox then
      if self.param.tileX == BuildTilesSize.One then
        self.modelHeight.y = 3
      elseif self.param.tileX == BuildTilesSize.Two then
        self.modelHeight.y = 4
      else
        self.modelHeight.y = 4
      end
    end
  end
end

local function AddArrowTimer(self, closeTime)
  if self.arrow_timer == nil then
    self.arrow_timer = TimerManager:GetInstance():GetTimer(closeTime, self.arrow_action, self, true, false, false)
    self.arrow_timer:Start()
  end
end

local function RefreshArrowTimer(self)
  self:DeleteArrowTimer()
  DataCenter.ArrowManager:RemoveFingerArrow()
end

local function DeleteArrowTimer(self)
  if self.arrow_timer ~= nil then
    self.arrow_timer:Stop()
    self.arrow_timer = nil
    EventManager:GetInstance():Broadcast(EventId.ChapterTaskOrWarningBall)
  end
end

UIFingerArrowView.OnCreate = OnCreate
UIFingerArrowView.OnDestroy = OnDestroy
UIFingerArrowView.OnEnable = OnEnable
UIFingerArrowView.OnDisable = OnDisable
UIFingerArrowView.OnAddListener = OnAddListener
UIFingerArrowView.OnRemoveListener = OnRemoveListener
UIFingerArrowView.ComponentDefine = ComponentDefine
UIFingerArrowView.ComponentDestroy = ComponentDestroy
UIFingerArrowView.DataDefine = DataDefine
UIFingerArrowView.DataDestroy = DataDestroy
UIFingerArrowView.ReInit = ReInit
UIFingerArrowView.Refresh = Refresh
UIFingerArrowView.InitModelHeight = InitModelHeight
UIFingerArrowView.AddArrowTimer = AddArrowTimer
UIFingerArrowView.RefreshArrowTimer = RefreshArrowTimer
UIFingerArrowView.DeleteArrowTimer = DeleteArrowTimer
return UIFingerArrowView
