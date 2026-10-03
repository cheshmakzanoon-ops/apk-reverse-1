local UIArrowView = BaseClass("UIArrowView", UIBaseView)
local base = UIBaseView
local rotation_go_path = "RotationGo"
local image_path = "RotationGo/Image"
local return_path = "Panel"
local rotationRota_go_path = "RotationGos"
local ParamData = {
  arrowType,
  positionType,
  position,
  pointId,
  uuid,
  clickClose,
  UseScale,
  useLiteAnim
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:PlayShowSound()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rotation_go = self:AddComponent(UIBaseContainer, rotation_go_path)
  self.bg = self:AddComponent(UIEventTrigger, return_path)
  self.bg:OnBeginDrag(function(eventData)
    if self.param ~= nil and self.param.clickClose then
    else
      self.ctrl:CloseSelf()
    end
  end)
  self.bg:OnPointerClick(function(eventData)
    if self.param ~= nil and self.param.clickClose then
    else
      self.ctrl:CloseSelf()
    end
  end)
  self.rotationRota_go = self:AddComponent(UIBaseContainer, rotationRota_go_path)
  self.arrow_anim = self:AddComponent(UISimpleAnimation, "RotationGo/Image")
  self.arrow_anim_s = self:AddComponent(UISimpleAnimation, "RotationGos/Images")
end

function UIArrowView.OnUpdate()
  if CS.UnityEngine.Input.GetMouseButtonDown(0) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArrow)
  end
end

local function ComponentDestroy(self)
  self.rotation_go = nil
  self:StopShowSound()
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
  self.param = DataCenter.ArrowManager:GetArrowParam()
  self:InitModelHeight()
  self:Refresh()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshArrow, self.RefreshArrowSignal)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.ChangeCameraPointSignal)
  self:AddUIListener(EventId.WorldTroopGameObjectCreateFinish, self.WorldTroopGameObjectCreateFinishSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshArrow, self.RefreshArrowSignal)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.ChangeCameraPointSignal)
  self:RemoveUIListener(EventId.WorldTroopGameObjectCreateFinish, self.WorldTroopGameObjectCreateFinishSignal)
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
      self.rotationRota_go.transform.position = screenPosition
    end
    if self.param.isPanel == false then
      self.bg:SetActive(false)
    else
      self.bg:SetActive(true)
    end
    if self.param.isReversal then
      self.rotation_go:SetActive(false)
      self.rotationRota_go:SetActive(true)
    else
      self.rotation_go:SetActive(true)
      self.rotationRota_go:SetActive(false)
    end
    local scale = 1.5
    if self.param.UseScale then
      scale = self.param.UseScale
    end
    if self.param.useLiteAnim then
      self.arrow_anim:Play("lite", 0, 0)
      self.arrow_anim_s:Play("lite", 0, 0)
    else
      self.arrow_anim:Play("Default", 0, 0)
      self.arrow_anim_s:Play("Default", 0, 0)
    end
    if self.param.YisReversal then
      self.rotation_go:SetLocalScaleXYZ(scale, -scale, scale)
      self.rotationRota_go:SetLocalScaleXYZ(scale, -scale, scale)
    else
      self.rotation_go:SetLocalScaleXYZ(scale, scale, scale)
      self.rotationRota_go:SetLocalScaleXYZ(scale, scale, scale)
    end
    if self.param.isAutoClose then
      self:AddArrowTimer(self.param.isAutoClose)
    end
  end
end

local function RefreshArrowSignal(self)
  self.param = DataCenter.ArrowManager:GetArrowParam()
  self:InitModelHeight()
  self:Refresh()
end

local function ChangeCameraPointSignal(self)
  self:Refresh()
end

local function WorldTroopGameObjectCreateFinishSignal(self, data)
  if data ~= nil then
    local marchUuid = tonumber(data)
    if self.param ~= nil and self.param.uuid == marchUuid then
      self:InitModelHeight()
      self:Refresh()
    end
  end
end

local function InitModelHeight(self)
  if self.modelHeight == nil then
    self.modelHeight = Vector3.New(0, 0, 0)
  end
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
  elseif self.param.arrowType == ArrowType.CityNpc then
    self.modelHeight.y = self.param.modelHeight or 80
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
  DataCenter.ArrowManager:RemoveArrow()
end

local function DeleteArrowTimer(self)
  if self.arrow_timer ~= nil then
    self.arrow_timer:Stop()
    self.arrow_timer = nil
    if self.param and self.param.quest then
      EventManager:GetInstance():Broadcast(EventId.ChapterTaskOrWarningBall)
    end
  end
end

function UIArrowView:PlayShowSound()
  self:StopShowSound()
  self.playingShowSoundId = DataCenter.LWSoundManager:PlaySound(62295, false)
end

function UIArrowView:StopShowSound()
  if self.playingShowSoundId then
    DataCenter.LWSoundManager:StopSound(self.playingShowSoundId)
    self.playingShowSoundId = nil
  end
end

UIArrowView.OnCreate = OnCreate
UIArrowView.OnDestroy = OnDestroy
UIArrowView.OnEnable = OnEnable
UIArrowView.OnDisable = OnDisable
UIArrowView.OnAddListener = OnAddListener
UIArrowView.OnRemoveListener = OnRemoveListener
UIArrowView.ComponentDefine = ComponentDefine
UIArrowView.ComponentDestroy = ComponentDestroy
UIArrowView.DataDefine = DataDefine
UIArrowView.DataDestroy = DataDestroy
UIArrowView.ReInit = ReInit
UIArrowView.Refresh = Refresh
UIArrowView.RefreshArrowSignal = RefreshArrowSignal
UIArrowView.ChangeCameraPointSignal = ChangeCameraPointSignal
UIArrowView.WorldTroopGameObjectCreateFinishSignal = WorldTroopGameObjectCreateFinishSignal
UIArrowView.InitModelHeight = InitModelHeight
UIArrowView.AddArrowTimer = AddArrowTimer
UIArrowView.RefreshArrowTimer = RefreshArrowTimer
UIArrowView.DeleteArrowTimer = DeleteArrowTimer
return UIArrowView
