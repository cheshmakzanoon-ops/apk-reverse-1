local BuildBloodTip = BaseClass("BuildBloodTip")
local time_text_path = "PosGo/Bg/TimeText"
local slider_path = "PosGo/Bg/Slider"
local bg_path = "PosGo/Bg"
local PositionDelta7 = Vector3.New(-6, 5, -6)
local PositionDelta = Vector3.New(0, 5, 0)
local SliderLength = Vector2.New(4.692847, 0.63)

function BuildBloodTip:__delete()
  self:OnDestroy()
end

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.time_text = self.transform:Find(time_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.slider = self.transform:Find(slider_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.bg = self.transform:Find(bg_path)
  self.isDoAnim = false
  
  function self.__update_handle()
    self:Update()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
end

local function ComponentDestroy(self)
  self:RemoveTimer()
  self.time_text = nil
  self.slider = nil
  self.bg = nil
  self.bUuid = nil
  self.data = nil
end

local function RemoveTimer(self)
  if self.__update_handle then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
end

local function StartShowBlood(self, param)
  self.data = param
  self.bUuid = param.bUuid
  self:UpdatePosition(self.data.serverId, self.data.pointId)
  self.curTime = 0
  self.curSize = Vector2.New(SliderLength.x, SliderLength.y)
  self.startPro = self.data.startValue / self.data.maxValue
  self.targetPro = self.data.targetValue / self.data.maxValue
  self.deltaPro = self.targetPro - self.startPro
  self.isDoAnim = true
  self:Update()
end

local function RefreshSlider(self, value)
  if 0 <= value and value <= 1 then
    self.curSize.x = SliderLength.x * value
    if not IsNull(self.slider) then
      self.slider.size = self.curSize
    end
  end
end

function BuildBloodTip:_TryDestroySelf()
  if self.bUuid then
    BuildBloodManager:GetInstance():RemoveOneEffect(self.bUuid)
  else
    Logger.LogError("Try remove build blood tips failed. Buuid is tmd nil.")
  end
  self:RemoveTimer()
end

local function Update(self)
  if IsNull(self.slider) or IsNull(self.slider.gameObject) then
    self:_TryDestroySelf()
    return
  end
  if self.isDoAnim then
    self.curTime = self.curTime + Time.deltaTime
    if self.curTime > 2.5 then
      self:_TryDestroySelf()
    elseif self.curTime <= 2 then
      local changePro = self.curTime / 2
      local curPro = self.startPro + changePro * self.deltaPro
      self:RefreshSlider(curPro)
      local temp = math.floor(curPro * self.data.maxValue)
      if not IsNull(self.time_text) then
        self.time_text.text = string.GetFormattedSeperatorNum(temp) .. "/" .. string.GetFormattedSeperatorNum(self.data.maxValue)
      end
    end
  else
    self:_TryDestroySelf()
  end
end

local function UpdatePosition(self, serverId, index)
  local worldPos
  if self.data.tileX == BuildTilesSize.One and self.data.tileY == BuildTilesSize.One and self.data.buildId and SeasonUtil.IsSeasonPlayerBuilding(self.data.buildId) then
    worldPos = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World, serverId) + Vector3.New(-3, 0, 0)
  elseif self.data.tileX == BuildTilesSize.Seven then
    worldPos = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World, serverId) + PositionDelta7 + PositionDelta
  else
    worldPos = BuildingUtils.GetBuildModelDownVec(index, self.data.tileX, self.data.tileY) + PositionDelta
    local x, y, z = SceneUtils.GetNinePalacesOffset(serverId)
    if x ~= nil and z ~= nil then
      worldPos.x = worldPos.x + x
      worldPos.z = worldPos.z + z
    end
  end
  self.transform.position = worldPos
end

BuildBloodTip.OnCreate = OnCreate
BuildBloodTip.OnDestroy = OnDestroy
BuildBloodTip.ComponentDefine = ComponentDefine
BuildBloodTip.ComponentDestroy = ComponentDestroy
BuildBloodTip.RefreshSlider = RefreshSlider
BuildBloodTip.UpdatePosition = UpdatePosition
BuildBloodTip.Update = Update
BuildBloodTip.StartShowBlood = StartShowBlood
BuildBloodTip.RemoveTimer = RemoveTimer
return BuildBloodTip
