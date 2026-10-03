local WorldPlunderDes = BaseClass("WorldPlunderDes", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local desc_path = "Desc"
local info_path = "Desc/Info"
local empty_path = "Empty"
local empty_btn_path = "Empty/emptyInfo"
local disappear_path = "Disappear"
local time_path = "Disappear/timeLabel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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

local function ComponentDefine(self)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.info_btn = self:AddComponent(UIButton, info_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.empty_root = self:AddComponent(UIBaseContainer, empty_path)
  self.empty_btn = self:AddComponent(UIButton, empty_btn_path)
  self.empty_btn:SetOnClick(function()
    self:OnEmptyInfoClick()
  end)
  self.disappear_root = self:AddComponent(UIBaseContainer, disappear_path)
  self.time_label = self:AddComponent(UIText, time_path)
end

local function ComponentDestroy(self)
  self.desc_text = nil
  self.info_btn = nil
  self.time_label = nil
end

local function DataDefine(self)
  self.zone = BuildZoneType.No
  self.infoTips = {}
end

local function DataDestroy(self)
  self.zone = nil
  self.infoTips = nil
end

local function RefreshData(self, data)
  self:SetActive(false)
  if CS.SceneManager:IsInCity() then
    return
  end
  if not data.playerData then
    return
  end
  local buildId = DataCenter.BuildManager:GetBuildIdByPointId(data.playerData.pointId)
  if buildId == nil or buildId == BuildingTypes.FUN_BUILD_MAIN or buildId == BuildingTypes.WORM_HOLE_CROSS then
    return
  end
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate == nil then
    return
  end
  local zone = buildTemplate.zoneType
  local canPlunder = false
  if data.playerData.plunderResRate and data.playerData.plunderResRate > 0 and (0 < LuaEntry.Effect:GetGameEffect(EffectDefine.PLUNDER_REST_COUNT) and zone ~= BuildZoneType.No or buildId == BuildingTypes.FUN_BUILD_STONE or buildId == BuildingTypes.FUN_BUILD_WATER) then
    canPlunder = true
  end
  self.desc_text:SetLocalText(canPlunder and 300134 or 300135)
  self.infoTips = self:SetInfo(buildId, data, zone)
  self:SetEndTime(buildId, data)
  self:SetEmptyInfo(buildId)
  self:SetActive(true)
end

function WorldPlunderDes:SetInfo(buildId, data, zone)
  local infoTips = {}
  if not data or not buildId then
    return infoTips
  end
  if buildId == BuildingTypes.FUN_BUILD_STONE or buildId == BuildingTypes.FUN_BUILD_WATER then
    table.insert(infoTips, Localization:GetString("300136", data.playerData.plunderResRate))
  end
  if zone == BuildZoneType.Trade then
    table.insert(infoTips, Localization:GetString("300137"))
  elseif zone == BuildZoneType.Military then
    table.insert(infoTips, Localization:GetString("300138"))
  elseif zone == BuildZoneType.Hero then
    table.insert(infoTips, Localization:GetString("300139"))
  end
  if buildId ~= BuildingTypes.FUN_BUILD_STONE and buildId ~= BuildingTypes.FUN_BUILD_WATER then
    table.insert(infoTips, Localization:GetString("300140"))
  end
  return infoTips
end

function WorldPlunderDes:SetEndTime(buildId, data)
  if data and data.endTime and (buildId == BuildingTypes.LW_CITY_RUIN or buildId == BuildingTypes.LW_CITY_RUIN_1) then
    self.EndTime = data.endTime
    self:Update1000MS()
    self.disappear_root:SetActive(true)
  else
    self.EndTime = nil
    self.disappear_root:SetActive(false)
  end
end

function WorldPlunderDes:SetEmptyInfo(buildId)
  if buildId == BuildingTypes.LW_CITY_RUIN or buildId == BuildingTypes.LW_CITY_RUIN_1 then
    self.empty_root:SetActive(true)
    self.desc_text:SetActive(false)
  else
    self.empty_root:SetActive(false)
    self.desc_text:SetActive(true)
  end
end

function WorldPlunderDes:OnInfoClick()
  local param = {}
  param.type = "desc"
  param.title = ""
  param.isLocal = true
  param.desc = string.join(self.infoTips, "\n")
  param.alignObject = self.info_btn
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function WorldPlunderDes:OnEmptyInfoClick()
  local param = {}
  param.type = "desc"
  param.title = ""
  param.isLocal = true
  param.desc = string.join(self.infoTips, "\n")
  param.alignObject = self.empty_btn
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function WorldPlunderDes:Update1000MS()
  if self.EndTime then
    UIUtil.SetLeftTimeText(self.time_label, nil, self.EndTime)
  end
end

WorldPlunderDes.OnCreate = OnCreate
WorldPlunderDes.OnDestroy = OnDestroy
WorldPlunderDes.OnEnable = OnEnable
WorldPlunderDes.OnDisable = OnDisable
WorldPlunderDes.ComponentDefine = ComponentDefine
WorldPlunderDes.ComponentDestroy = ComponentDestroy
WorldPlunderDes.DataDefine = DataDefine
WorldPlunderDes.DataDestroy = DataDestroy
WorldPlunderDes.RefreshData = RefreshData
return WorldPlunderDes
