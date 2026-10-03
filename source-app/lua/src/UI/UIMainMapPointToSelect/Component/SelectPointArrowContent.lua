local SelectPointArrowContent = BaseClass("SelectPointArrowContent", UIBaseContainer)
local base = UIBaseContainer
local select_point_path = "selectPoint"

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

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
end

local function ComponentDefine(self)
  self.select_point = self:AddComponent(UIBaseContainer, select_point_path)
end

local function ComponentDestroy(self)
  self.select_point = nil
end

local function DataDefine(self)
  self.selectZonePosId = nil
  self.selectZoneId = nil
  self.selectPointWorldPos = nil
  self.selectPointUIPos = nil
  self.selectServerId = nil
end

local function DataDestroy(self)
  self.selectZonePosId = nil
  self.selectZoneId = nil
  self.selectPointWorldPos = nil
  self.selectPointUIPos = nil
  self.selectServerId = nil
end

local function SetData(self)
  self.selectPointWorldPos = nil
  self.selectPointUIPos = nil
  self.selectZonePosId, self.selectZoneId, self.selectServerId = self.view:GetSelectZoneData()
  if self.selectZonePosId and self.selectZoneId and self.selectServerId then
    self.selectPointWorldPos = SceneUtils.TileIndexToWorld(self.selectZonePosId, ForceChangeScene.World, self.selectServerId)
  end
  if self.selectPointWorldPos then
    self.select_point:SetActive(true)
  else
    self.select_point:SetActive(false)
  end
  self:SetPointUIPos()
  self:RefreshView()
end

local function OnUpdate(self)
end

local function RefreshCameraPoint(self)
  self:SetPointUIPos()
  self:RefreshView()
end

local function SetPointUIPos(self)
  if self.selectPointWorldPos == nil then
    return
  end
  self.selectPointUIPos = CS.CSUtils.WorldPositionToUISpacePosition(self.selectPointWorldPos)
end

local function RefreshView(self)
  if self.selectPointWorldPos == nil then
    return
  end
  self.select_point:SetPositionXYZ(self.selectPointUIPos.x, self.selectPointUIPos.y, 0)
end

SelectPointArrowContent.OnCreate = OnCreate
SelectPointArrowContent.OnDestroy = OnDestroy
SelectPointArrowContent.OnAddListener = OnAddListener
SelectPointArrowContent.OnRemoveListener = OnRemoveListener
SelectPointArrowContent.ComponentDefine = ComponentDefine
SelectPointArrowContent.ComponentDestroy = ComponentDestroy
SelectPointArrowContent.DataDefine = DataDefine
SelectPointArrowContent.DataDestroy = DataDestroy
SelectPointArrowContent.SetData = SetData
SelectPointArrowContent.OnUpdate = OnUpdate
SelectPointArrowContent.RefreshCameraPoint = RefreshCameraPoint
SelectPointArrowContent.SetPointUIPos = SetPointUIPos
SelectPointArrowContent.RefreshView = RefreshView
return SelectPointArrowContent
