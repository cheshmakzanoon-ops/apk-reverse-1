local UILastStandMonsterIndicator = BaseClass("UILastStandMonsterIndicator", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local world_world_center_back_btn_path = "WorldCenterBackBtn"
local world_world_center_back_arrow_path = "WorldCenterBackBtn/WorldCenterBackArrow"
local world_world_center_back_name_path = "WorldCenterBackBtn/WorldCenterBackBtnName"
local leftPadding = 90
local topPadding = 250
local NamePosDelta = Vector3.New(-2, -25, 0)
local BgRotationDelta = Vector3.New(0, 0, 60)
local BackBtnShowDistance = 8

local function OnCreate(self)
  base.OnCreate(self)
  local ok, errorMsg = pcall(function()
    self:ComponentDefine()
    self:DataDefine()
  end)
  if not ok and errorMsg then
    Logger.LogError(errorMsg)
  end
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.world_world_center_back_btn = self:AddComponent(UIButton, world_world_center_back_btn_path)
  self.world_world_center_back_arrow = self:AddComponent(UIBaseContainer, world_world_center_back_arrow_path)
  self.world_world_center_back_name = self:AddComponent(UIText, world_world_center_back_name_path)
end

local function ComponentDestroy(self)
  self.world_world_center_back_btn = nil
  self.world_world_center_back_arrow = nil
  self.world_world_center_back_name = nil
end

local function DataDefine(self)
  local x, y = self.transform:Get_lossyScale()
  self.lossyScale = y
  self.mileDist = 0
  self.topPadding = topPadding
  self.position = Vector3.New(self.transform:Get_position())
  self.isVisible = true
  self.worldWorldCenterActive = nil
  self.worldWorldCenterBackBtnRotation = nil
  self.worldWorldCenterBackBtnPositionX = nil
  self.worldWorldCenterBackBtnPositionY = nil
  self.disText = Localization:GetString(GameDialogDefine.KILOMETRE)
end

local function DataDestroy(self)
  self.lossyScale = nil
  self.mileDist = nil
  self.position = nil
  self.isVisible = nil
  self.worldWorldCenterActive = nil
  self.worldWorldCenterBackBtnRotation = nil
  self.worldWorldCenterBackBtnPositionX = nil
  self.worldWorldCenterBackBtnPositionY = nil
  self.disText = nil
  self.UIWorldPosHelper = nil
end

local function ReInit(self, topP)
  if topP ~= nil then
    self.topPadding = topP
  else
    self.topPadding = topPadding
  end
  self:ShowVisible()
  self.ConstructPos = DataCenter.NextGarbagePointManager:GetCurPos()
  self:UpdateMilePointer(false)
end

local function SetVisible(self, isVisible)
  if self.isVisible ~= isVisible then
    self.isVisible = isVisible
    self:ShowVisible()
  end
end

local function ShowVisible(self)
  if self.isVisible then
    self.transform:Set_position(self.position.x, self.position.y, self.position.z)
  else
    self.transform:Set_position(FalseVisiblePos.x, FalseVisiblePos.y, FalseVisiblePos.z)
  end
end

local function UpdateConstructPos(self, tempPos)
  self.ConstructPos = tempPos
end

function UILastStandMonsterIndicator:Hide()
  self:SetWorldWorldCenterActive(false)
end

function UILastStandMonsterIndicator:UpdateIndicator(monster)
  if not self.UIWorldPosHelper then
    return
  end
  local pos = monster:GetPosition()
  local show, dist, pos_x, pos_y, eulerAngles_z
  show, dist, pos_x, pos_y, eulerAngles_z = self.UIWorldPosHelper:CalcConstructMilePointerSimple(leftPadding * self.lossyScale, self.topPadding * self.lossyScale, pos)
  if show then
    self:SetWorldWorldCenterActive(true)
    self:SetWorldWorldCenterBackBtnRotation(eulerAngles_z)
    self:SetWorldWorldCenterBackBtnPosition(pos_x, pos_y)
  else
    self:SetWorldWorldCenterActive(false)
  end
end

local function SetWorldWorldCenterActive(self, value)
  if self.worldWorldCenterActive ~= value then
    self.worldWorldCenterActive = value
    self.world_world_center_back_btn:SetActive(value)
  end
end

local function SetWorldWorldCenterBackBtnPosition(self, x, y)
  if self.worldWorldCenterBackBtnPositionX == x and self.worldWorldCenterBackBtnPositionY == y then
    return
  end
  self.worldWorldCenterBackBtnPositionX = x
  self.worldWorldCenterBackBtnPositionY = y
  self.world_world_center_back_btn:SetPositionXYZ(x, y, 0)
end

local function SetWorldWorldCenterBackBtnRotation(self, value)
  if self.worldWorldCenterBackBtnRotation ~= value then
    self.worldWorldCenterBackBtnRotation = value
    self.world_world_center_back_arrow:SetEulerAnglesXYZ(0, 0, BgRotationDelta.z + value)
  end
end

local function SetWorldWorldCenterBackName(self, value)
  if self.worldWorldCenterBackName ~= value then
    self.worldWorldCenterBackName = value
  end
end

function UILastStandMonsterIndicator:SetHelper(UIWorldPosHelper)
  self.UIWorldPosHelper = UIWorldPosHelper
end

UILastStandMonsterIndicator.OnCreate = OnCreate
UILastStandMonsterIndicator.OnDisable = OnDisable
UILastStandMonsterIndicator.OnDestroy = OnDestroy
UILastStandMonsterIndicator.ReInit = ReInit
UILastStandMonsterIndicator.ComponentDefine = ComponentDefine
UILastStandMonsterIndicator.DataDefine = DataDefine
UILastStandMonsterIndicator.ComponentDestroy = ComponentDestroy
UILastStandMonsterIndicator.DataDestroy = DataDestroy
UILastStandMonsterIndicator.OnEnable = OnEnable
UILastStandMonsterIndicator.SetVisible = SetVisible
UILastStandMonsterIndicator.ShowVisible = ShowVisible
UILastStandMonsterIndicator.OnAddListener = OnAddListener
UILastStandMonsterIndicator.OnRemoveListener = OnRemoveListener
UILastStandMonsterIndicator.SetWorldWorldCenterActive = SetWorldWorldCenterActive
UILastStandMonsterIndicator.SetWorldWorldCenterBackBtnPosition = SetWorldWorldCenterBackBtnPosition
UILastStandMonsterIndicator.SetWorldWorldCenterBackBtnRotation = SetWorldWorldCenterBackBtnRotation
UILastStandMonsterIndicator.SetWorldWorldCenterBackName = SetWorldWorldCenterBackName
UILastStandMonsterIndicator.UpdateConstructPos = UpdateConstructPos
return UILastStandMonsterIndicator
