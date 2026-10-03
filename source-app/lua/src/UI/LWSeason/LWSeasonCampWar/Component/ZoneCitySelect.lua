local base = UIBaseContainer
local ZoneCitySelect = BaseClass("ZoneCitySelect", base)
local btn_path = ""
local icon_path = "cityIcon"
local name_path = "cityName"

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
  self.btn = self:AddComponent(UIButton, btn_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name = self:AddComponent(UIText, name_path)
  self.btn:SetOnClick(function()
    self:Goto()
  end)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.icon = nil
  self.name = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function ZoneCitySelect:ReInit(cityId, configSchedule)
  self.cityId = cityId
  self.configSchedule = configSchedule
  local meta = cityId and DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(cityId), LuaEntry.Player:GetSourceServerId())
  if not meta then
    return
  end
  self.pos = meta.pos
  self.name:SetLocalText(meta.name)
end

function ZoneCitySelect:Goto()
  if not self.pos then
    return
  end
  local deServerId = DataCenter.ZoneWarManager:GetDefenderServerId()
  if 0 < deServerId then
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(SceneUtils.TileToWorld(self.pos), nil, nil, function()
    end, deServerId, 0)
  end
end

ZoneCitySelect.OnCreate = OnCreate
ZoneCitySelect.OnDestroy = OnDestroy
ZoneCitySelect.OnEnable = OnEnable
ZoneCitySelect.OnDisable = OnDisable
ZoneCitySelect.ComponentDefine = ComponentDefine
ZoneCitySelect.ComponentDestroy = ComponentDestroy
ZoneCitySelect.DataDefine = DataDefine
ZoneCitySelect.DataDestroy = DataDestroy
return ZoneCitySelect
