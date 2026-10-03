local UIMainCenter = BaseClass("UIMainCenter", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIMainFireworkBackBtnItem = require("UI.LWMainUI.Component.UIMainCenter.UIMainFireworkBackBtnItem")
local world_world_center_back_btn_path = "WorldCenterBackBtn"
local world_world_center_back_arrow_path = "WorldCenterBackBtn/WorldCenterBackArrow"
local world_world_center_back_name_path = "WorldCenterBackBtn/WorldCenterBackBtnName"
local leftPadding = 250
local topPadding = 250
local NamePosDelta = Vector3.New(-2, -25, 0)
local BgRotationDelta = Vector3.New(0, 0, 0)
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
  self:AddUIListener(EventId.FireworkGiftDataCsUpdate, self.OnFireworkDataCsUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.FireworkGiftDataCsUpdate, self.OnFireworkDataCsUpdate)
end

local function ComponentDefine(self)
  self.world_world_center_back_btn = self:AddComponent(UIButton, world_world_center_back_btn_path)
  self.world_world_center_back_arrow = self:AddComponent(UIBaseContainer, world_world_center_back_arrow_path)
  self.world_world_center_back_name = self:AddComponent(UIText, world_world_center_back_name_path)
  self.world_world_center_back_btn:SetOnClick(function()
    if self.view == nil then
      return
    end
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local finalPos
    if BattleFieldUtil.InBattleField() then
      local mainWorldPos = LuaEntry.Player:GetBattleFieldPos()
      GoToUtil.GotoDragonPos(SceneUtils.TileIndexToWorld(mainWorldPos, ForceChangeScene.World), CS.SceneManager.World.InitZoom)
      return
    end
    if self.view.ConstructingBuildID == BuildingTypes.APS_BUILD_WORMHOLE_SUB then
      local vTargetPos = SceneUtils.WorldToTile(self.ConstructPos)
      local vOrigPos = SceneUtils.WorldToTile(self.CacheOrigPos)
      local distance = SceneUtils.TileDistance(vTargetPos, vOrigPos)
      local buildLevel = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.APS_BUILD_WORMHOLE_MAIN, 1)
      local num = buildLevel.offer_range / distance
      finalPos = (num - num % 0.1) * (self.ConstructPos - self.CacheOrigPos) + self.CacheOrigPos
    elseif self.ConstructPos ~= nil then
      finalPos = self.ConstructPos
    end
    self.view.ctrl:OnClickBackHomeBtn(finalPos)
  end)
end

local function ComponentDestroy(self)
  self:DestroyFirework()
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

local function UpdateMilePointer(self, isShow)
  if self.view == nil then
    return
  end
  if isShow then
    local show, dist, refDistance, refDist, pos_x, pos_y, eulerAngles_z
    if not self.topPadding then
      self.topPadding = topPadding
    end
    if CS.SceneManager:IsInCity() then
      show = false
    elseif self.view.ConstructingBuildID and self.view.ConstructingBuildID == BuildingTypes.APS_BUILD_WORMHOLE_SUB then
      if not self.CacheOrigPos then
        local mainWormHoleInfo = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.APS_BUILD_WORMHOLE_MAIN)
        if mainWormHoleInfo then
          self.CacheOrigPos = SceneUtils.TileIndexToWorld(mainWormHoleInfo.pointId)
        end
      end
      local buildLevel = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.APS_BUILD_WORMHOLE_MAIN, 1)
      refDistance = buildLevel.offer_range
      show, dist, pos_x, pos_y, eulerAngles_z = UIUtil.CalcConstructMilePointer(leftPadding * self.lossyScale, self.topPadding * self.lossyScale, self.CacheOrigPos, self.ConstructPos)
      refDist = dist - refDistance
    else
      if self.ConstructPos == nil then
        refDistance = BackBtnShowDistance
        show, dist, pos_x, pos_y, eulerAngles_z = UIUtil.CalcMilePointer(leftPadding * self.lossyScale, self.topPadding * self.lossyScale)
      else
        refDistance = 0
        show, dist, pos_x, pos_y, eulerAngles_z = UIUtil.CalcConstructMilePointer(leftPadding * self.lossyScale, self.topPadding * self.lossyScale, self.ConstructPos, CS.SceneManager.World.CurTarget)
      end
      refDist = dist
    end
    if show and dist > refDistance then
      if self:SetWorldWorldCenterActive(true) then
        self:SetWorldWorldCenterBackBtnRotation(eulerAngles_z)
        self:SetWorldWorldCenterBackBtnPosition(pos_x, pos_y)
        self:SetWorldWorldCenterBackName(refDist .. " " .. self.disText)
      end
    else
      self:SetWorldWorldCenterActive(false)
    end
  else
    self:SetWorldWorldCenterActive(false)
  end
end

local function SetWorldWorldCenterActive(self, value)
  local curServerId = LuaEntry.Player:GetCurServerId()
  local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(curServerId)
  if isBigMapMode and loginSameGroup then
  elseif not LuaEntry.Player:IsInSelfServer() and not BattleFieldUtil.InBattleField() then
    value = false
  end
  if self.worldWorldCenterActive ~= value then
    self.worldWorldCenterActive = value
    self.world_world_center_back_btn:SetActive(value)
    self.world_world_center_back_name:SetActive(value)
  end
  return value
end

local function SetWorldWorldCenterBackBtnPosition(self, x, y)
  if self.worldWorldCenterBackBtnPositionX == x and self.worldWorldCenterBackBtnPositionY == y then
    return
  end
  self.worldWorldCenterBackBtnPositionX = x
  self.worldWorldCenterBackBtnPositionY = y
  self.world_world_center_back_btn:SetPositionXYZ(x, y, 0)
  self.world_world_center_back_name:SetPositionXYZ(x + NamePosDelta.x * self.lossyScale, y + NamePosDelta.y * self.lossyScale, 0)
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
    self.world_world_center_back_name:SetText(value)
  end
end

local function OnFireworkDataCsUpdate(self)
  self:LoadFirework()
end

local function DestroyFirework(self)
  if self.fireworkReq then
    self:RemoveComponents(UIMainFireworkBackBtnItem)
    self:GameObjectDestroy(self.fireworkReq)
    self.fireworkBackBtnItem = nil
    self.fireworkReq = nil
  end
end

local function LoadFirework(self)
  if BattleFieldUtil.InBattleField() then
    return
  end
  if not self.fireworkReq then
    self.fireworkReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWMainUI/FireworkBackBtn.prefab", function(request)
      if request.isError or IsNull(request.gameObject) then
        self.fireworkReq = nil
        Logger.LogError("FireworkBackBtn load failed")
        self:GameObjectDestroy(request)
        return
      end
      if IsNull(self.transform) then
        self.fireworkReq = nil
        self:GameObjectDestroy(request)
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(0, 0, 0)
      self.fireworkBackBtnItem = self:AddComponent(UIMainFireworkBackBtnItem, go.name)
      self.fireworkBackBtnItem:ReInit()
      if self.view and self.view.CheckCenterShow then
        self.fireworkBackBtnItem:UpdateMilePointer(self.view:CheckCenterShow())
      end
    end)
  end
end

local function UpdateFireworkBackBtnMilePointer(self, isShow)
  if self.fireworkBackBtnItem then
    self.fireworkBackBtnItem:UpdateMilePointer(isShow)
  end
end

local function UpdateFireworkBackBtnConstructPos(self)
  if self.fireworkBackBtnItem then
    self.fireworkBackBtnItem:GetData()
  end
end

UIMainCenter.OnCreate = OnCreate
UIMainCenter.OnDisable = OnDisable
UIMainCenter.OnDestroy = OnDestroy
UIMainCenter.ReInit = ReInit
UIMainCenter.ComponentDefine = ComponentDefine
UIMainCenter.DataDefine = DataDefine
UIMainCenter.ComponentDestroy = ComponentDestroy
UIMainCenter.DataDestroy = DataDestroy
UIMainCenter.OnEnable = OnEnable
UIMainCenter.SetVisible = SetVisible
UIMainCenter.ShowVisible = ShowVisible
UIMainCenter.OnAddListener = OnAddListener
UIMainCenter.OnRemoveListener = OnRemoveListener
UIMainCenter.UpdateMilePointer = UpdateMilePointer
UIMainCenter.SetWorldWorldCenterActive = SetWorldWorldCenterActive
UIMainCenter.SetWorldWorldCenterBackBtnPosition = SetWorldWorldCenterBackBtnPosition
UIMainCenter.SetWorldWorldCenterBackBtnRotation = SetWorldWorldCenterBackBtnRotation
UIMainCenter.SetWorldWorldCenterBackName = SetWorldWorldCenterBackName
UIMainCenter.UpdateConstructPos = UpdateConstructPos
UIMainCenter.OnFireworkDataCsUpdate = OnFireworkDataCsUpdate
UIMainCenter.DestroyFirework = DestroyFirework
UIMainCenter.LoadFirework = LoadFirework
UIMainCenter.UpdateFireworkBackBtnMilePointer = UpdateFireworkBackBtnMilePointer
UIMainCenter.UpdateFireworkBackBtnConstructPos = UpdateFireworkBackBtnConstructPos
return UIMainCenter
