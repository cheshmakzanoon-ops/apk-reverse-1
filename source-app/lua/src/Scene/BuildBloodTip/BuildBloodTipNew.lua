local BuildBloodTipNew = BaseClass("BuildBloodTipNew")
local time_text_path = "PosGo/Bg/TimeText"
local slider_path = "PosGo/Bg/Slider"
local slider1_path = "PosGo/Bg/Slider1"
local bg_path = "PosGo/Bg"
local PlayTime = 0.9166666666666666
local PlayTimeFinal = 0.5 + PlayTime
local PlayTime1 = 0.18181818181818182 * PlayTime
local PlayTime2 = 0.09090909090909091 * PlayTime
local PlayTime3 = 0.7272727272727273 * PlayTime
local PositionDelta7 = Vector3.New(-6, 5, -6)
local PositionDelta = Vector3.New(0, 5, 0)
local SliderLength = Vector2.New(4.692847, 0.63)
local blueSprite = "Assets/Main/Sprites/UI/UIBuildBubble/uibuild_time_bar_blue.png"
local greenSprite = "Assets/Main/Sprites/UI/UIBuildBubble/uibuild_time_bar_green.png"

function BuildBloodTipNew:__delete()
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
  self.slider1 = self.transform:Find(slider1_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
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
  self.slider1 = nil
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
  local bAdd = self.data.startValue < self.data.targetValue
  self.bAdd = bAdd
  local fileName = bAdd and "uibuild_time_bar_yellow.png" or "uibuild_time_bar_red.png"
  self.slider1:LoadSprite(string.format(LoadPath.UIBuildBubble, fileName))
  if param.colorType == 2 then
    self.slider:LoadSprite(blueSprite)
  else
    self.slider:LoadSprite(greenSprite)
  end
  self.curTime = 0
  self.curSize = Vector2.New(SliderLength.x, SliderLength.y)
  self.startPro = self.data.startValue / self.data.maxValue
  self.targetPro = self.data.targetValue / self.data.maxValue
  self.deltaPro = self.targetPro - self.startPro
  self:RefreshSlider(self.startPro, self.slider)
  self:RefreshSlider(self.startPro, self.slider1)
  self.isDoAnim = true
  self:Update()
end

local function RefreshSlider(self, value, slider)
  if 0 <= value and value <= 1 then
    self.curSize.x = SliderLength.x * value
    if not IsNull(slider) then
      slider.size = self.curSize
    end
  end
end

function BuildBloodTipNew:_TryDestroySelf()
  if self.bUuid then
    BuildBloodManager:GetInstance():RemoveOneEffect(self.bUuid)
  else
    Logger.LogError("Try remove build blood tips NEW failed. Buuid is tmd nil.")
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
    if self.curTime > PlayTimeFinal then
      self:_TryDestroySelf()
    else
      local bAdd = self.bAdd
      if self.curTime < PlayTime1 then
        local slider = bAdd and self.slider1 or self.slider
        local changePro = self.curTime / PlayTime1
        local curPro = self.startPro + changePro * self.deltaPro
        self:RefreshSlider(curPro, slider)
      elseif self.curTime <= PlayTime1 + PlayTime2 then
        local slider = bAdd and self.slider1 or self.slider
        self:RefreshSlider(self.targetPro, slider)
      elseif self.curTime < PlayTime then
        local slider = bAdd and self.slider or self.slider1
        local changePro = (self.curTime - PlayTime1 - PlayTime2) / PlayTime3
        local curPro = self.startPro + changePro * self.deltaPro
        self:RefreshSlider(curPro, slider)
      else
        local slider = bAdd and self.slider or self.slider1
        self:RefreshSlider(self.targetPro, slider)
      end
      if not IsNull(self.time_text) then
        if self.curTime < PlayTime then
          local changePro = self.curTime / PlayTime
          local curPro = self.startPro + changePro * self.deltaPro
          local temp = math.floor(curPro * self.data.maxValue)
          self.time_text.text = string.GetFormattedSeperatorNum(temp) .. "/" .. string.GetFormattedSeperatorNum(self.data.maxValue)
        else
          self.time_text.text = string.GetFormattedSeperatorNum(self.data.targetValue) .. "/" .. string.GetFormattedSeperatorNum(self.data.maxValue)
        end
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

BuildBloodTipNew.OnCreate = OnCreate
BuildBloodTipNew.OnDestroy = OnDestroy
BuildBloodTipNew.ComponentDefine = ComponentDefine
BuildBloodTipNew.ComponentDestroy = ComponentDestroy
BuildBloodTipNew.RefreshSlider = RefreshSlider
BuildBloodTipNew.UpdatePosition = UpdatePosition
BuildBloodTipNew.Update = Update
BuildBloodTipNew.StartShowBlood = StartShowBlood
BuildBloodTipNew.RemoveTimer = RemoveTimer
return BuildBloodTipNew
