local base = UIBaseContainer
local SnowStormFurnaceRender = BaseClass("SnowStormFurnaceRender", base)
local Localization = CS.GameEntry.Localization
local temperature_path = "temperature"
local stateDes_path = "stateDes"
local desc1_path = "Description1"
local desc2_path = "Description2"
local progressFront_path = "bg1 (1)/progressfront"
local progress_path = "bg1 (1)"
local jumpBtn_path = "Description2/jumpBtn"
local icon_path = "icon"
local desc3_path = "Description3"
local bannerbg_path = "bannerbg"
local furnaceType = {alliance = 1, personal = 2}

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.temperature = self:AddComponent(UIText, temperature_path)
  self.stateDes = self:AddComponent(UIText, stateDes_path)
  self.desc1 = self:AddComponent(UIText, desc1_path)
  self.desc2 = self:AddComponent(UIText, desc2_path)
  self.progressFront = self:AddComponent(UIBaseContainer, progressFront_path)
  self.progress = self:AddComponent(UIBaseContainer, progress_path)
  self.jumpBtn = self:AddComponent(UIButton, jumpBtn_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.desc3 = self:AddComponent(UIText, desc3_path)
  self.bannerbg = self:AddComponent(UIBaseContainer, bannerbg_path)
  self.jumpBtn:SetOnClick(function()
    self:JumpBtn()
  end)
end

local function ComponentDestroy(self)
  self.temperature = nil
  self.stateDes = nil
  self.desc1 = nil
  self.desc2 = nil
  self.progressFront = nil
  self.progress = nil
  self.jumpBtn = nil
  self.icon = nil
  self.desc3 = nil
  self.bannerbg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SnowStormFurnaceRender:SetData(type)
  self.type = type
  if type == furnaceType.personal then
    self:SetActive(true)
    self:ShowPersonalFurnace()
  elseif type == furnaceType.alliance then
    self:SetActive(true)
    self:ShowAllianceFurnace()
  else
    self:SetActive(false)
  end
end

function SnowStormFurnaceRender:ShowPersonalFurnace()
  self.progress:SetActive(false)
  self.existBuilding = false
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILDING_SEASON2_PERSONAL_FURNACE)
  if buildData then
    local buildId = buildData.itemId
    local level = buildData.level
    local buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    local build = DataCenter.BuildManager:GetFurnaceData(buildData.uuid)
    self.buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    self.icon:LoadSpriteAuto(buildCurLevelTemplate:GetBuildIconOutCity())
    self.endTime = nil
    if not string.IsNullOrEmpty(buildCurLevelTemplate.temperature_status) then
      local dataTemperature = DataCenter.HeatSourceTemplateManager:GetTemplate(tonumber(buildCurLevelTemplate.temperature_status))
      if build then
        self.existBuilding = true
        local cost = 0
        if build.state == HeatSourceState.Close then
          self.stateDes:SetLocalText("season_s2_storm_event_08")
          self.temperature:SetText(Localization:GetString("season_s2_storm_event_10", 0))
        elseif build.state == HeatSourceState.Active then
          self.stateDes:SetLocalText("season_s2_storm_event_09")
          cost = buildCurLevelTemplate.coal_normal[2] * 60
          local temp = dataTemperature.active_temperature or ""
          self.temperature:SetText(Localization:GetString("season_s2_storm_event_10", temp))
        elseif build.state == HeatSourceState.Overload then
          cost = buildCurLevelTemplate.coal_overload[2] * 60
          local temp = dataTemperature.overload_temperature or ""
          self.stateDes:SetLocalText("season_s2_temperature_status_name05")
          self.temperature:SetText(Localization:GetString("season_s2_storm_event_10", temp))
        else
          self.stateDes:SetLocalText("season_s2_storm_event_08")
          self.temperature:SetText(Localization:GetString("season_s2_storm_event_10", 0))
        end
        if build.endTime then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          local restTime = build.endTime - curTime
          if 0 <= restTime then
            self.endTime = build.endTime
            self.desc1:SetText(Localization:GetString("season_s2_alliance_building_ui013") .. UITimeManager:GetInstance():MilliSecondToFmtString(restTime))
          else
            self.desc1:SetText("")
          end
        end
        self.desc2:SetText(Localization:GetString("season_person_building_name770000"))
      end
      self.icon:SetColorRGBA(1, 1, 1, 1)
      self.bannerbg:SetActive(true)
    else
      local buildId = BuildingTypes.LW_BUILDING_SEASON2_PERSONAL_FURNACE
      local level = 1
      local buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      self.icon:LoadSpriteAuto(buildCurLevelTemplate:GetBuildIconOutCity())
      self:BuildEmpty()
    end
  else
    local buildId = BuildingTypes.LW_BUILDING_SEASON2_PERSONAL_FURNACE
    local level = 1
    local buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    self.icon:LoadSpriteAuto(buildCurLevelTemplate:GetBuildIconOutCity())
    self:BuildEmpty()
  end
end

function SnowStormFurnaceRender:BuildEmpty()
  self.bannerbg:SetActive(false)
  self.desc1:SetText("")
  self.stateDes:SetText("")
  self.desc3:SetText("")
  self.icon:SetColorRGBA(1, 1, 1, 0.5)
  self.desc2:SetText(Localization:GetString("110015"))
  self.temperature:SetText(Localization:GetString("season_tips104"))
  self.existBuilding = false
end

function SnowStormFurnaceRender:ShowAllianceFurnace()
  local info = DataCenter.AllianceMineManager:GetAllianceStoveCenterStatus()
  local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  local flag = false
  if theStoveCenter and theStoveCenter.buildId == BuildingTypes.SEASON_POWER_CENTER then
    local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(1 + BuildingTypes.SEASON_POWER_CENTER)
    self.icon:LoadSprite(string.format(meta:GetIconPath()))
    self:BuildEmpty()
    return
  end
  if theStoveCenter and theStoveCenter.buildId == BuildingTypes.SEASON_MUMMY_CENTER then
    local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(1 + BuildingTypes.SEASON_MUMMY_CENTER)
    self.icon:LoadSprite(string.format(meta:GetIconPath()))
    self:BuildEmpty()
    return
  end
  if info and theStoveCenter then
    self.existBuilding = true
    if theStoveCenter.status ~= AllianceMineStatus.Ruin then
      flag = true
      local furnaceState = info.state
      local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(theStoveCenter.level + BuildingTypes.SEASON_STOVE_CENTER)
      self.icon:LoadSprite(string.format(meta:GetIconPath()))
      if furnaceState == HeatSourceState.Close then
        self.stateDes:SetLocalText("season_s2_storm_event_08")
        self.temperature:SetText(Localization:GetString("season_s2_storm_event_10", 0))
      elseif furnaceState == HeatSourceState.Active then
        self.stateDes:SetLocalText("season_s2_storm_event_09")
        local temp = meta.temperatureCfg.active_temperature or ""
        self.temperature:SetText(Localization:GetString("season_s2_storm_event_10", temp))
      elseif furnaceState == HeatSourceState.Overload then
        local temp = meta.temperatureCfg.overload_temperature or ""
        self.stateDes:SetLocalText("season_s2_temperature_status_name05")
        self.temperature:SetText(Localization:GetString("season_s2_storm_event_10", temp))
      else
        self.stateDes:SetLocalText("season_s2_storm_event_08")
        self.temperature:SetText(Localization:GetString("season_s2_storm_event_10", 0))
      end
      local resCoal = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceCoal)
      local r = resCoal / meta.coal_limit
      if 1 < r then
        r = 1
      elseif r < 0 then
        r = 0
      end
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local restTime = info.endTime - curTime
      if 0 <= restTime then
        self.endTime = info.endTime
        self.desc1:SetText(Localization:GetString("season_s2_alliance_building_ui013") .. UITimeManager:GetInstance():MilliSecondToFmtString(restTime))
      else
        self.endTime = nil
        self.desc1:SetText("")
      end
      local point = SceneUtils.IndexToTilePos(theStoveCenter.pointId, ForceChangeScene.World)
      self.desc2:SetText(string.format("#%s, x:%s y:%s", tostring(LuaEntry.Player:GetSelfServerId()), tostring(point.x), tostring(point.y)))
      self.desc3:SetText("Lv." .. theStoveCenter.level .. " " .. meta:GetName())
    end
    self.icon:SetColorRGBA(1, 1, 1, 1)
    self.bannerbg:SetActive(true)
  else
    local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(1 + BuildingTypes.SEASON_STOVE_CENTER)
    self.icon:LoadSprite(string.format(meta:GetIconPath()))
    self:BuildEmpty()
  end
end

function SnowStormFurnaceRender:JumpBtn()
  GoToUtil.CloseAllWindows()
  if self.type == furnaceType.personal then
    if self.existBuilding then
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILDING_SEASON2_PERSONAL_FURNACE)
      if buildData then
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City), nil, nil, function()
        end)
      end
    else
      SceneUtils.ChangeToCity(function()
        local point = BuildingUtils.GetPointByBuildCanPut(BuildingTypes.LW_BUILDING_SEASON2_PERSONAL_FURNACE, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
        local pos = SceneUtils.TileIndexToWorld(point)
        GoToUtil.GotoPos(pos, CS.SceneManager.World.InitZoom, 0, function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList)
        end)
      end)
    end
  elseif self.type == furnaceType.alliance then
    if self.existBuilding then
      local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(theStoveCenter.pointId, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      end, theStoveCenter.curServerId)
    else
      if LuaEntry.Player:IsInAlliance() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonStoveCenter, {anim = true, hideTop = true})
      else
      end
    end
  end
end

function SnowStormFurnaceRender:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local restTime = self.endTime - curTime
    if 0 <= restTime then
      self.desc1:SetText(Localization:GetString("season_s2_alliance_building_ui013") .. UITimeManager:GetInstance():MilliSecondToFmtString(restTime))
    else
      self.endTime = nil
      self.desc1:SetText("")
    end
  end
end

SnowStormFurnaceRender.OnCreate = OnCreate
SnowStormFurnaceRender.OnDestroy = OnDestroy
SnowStormFurnaceRender.OnEnable = OnEnable
SnowStormFurnaceRender.OnDisable = OnDisable
SnowStormFurnaceRender.ComponentDefine = ComponentDefine
SnowStormFurnaceRender.ComponentDestroy = ComponentDestroy
SnowStormFurnaceRender.DataDefine = DataDefine
SnowStormFurnaceRender.DataDestroy = DataDestroy
return SnowStormFurnaceRender
