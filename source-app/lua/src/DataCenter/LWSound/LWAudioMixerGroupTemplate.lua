local LWAudioMixerGroupTemplate = BaseClass("LWAudioMixerGroupTemplate")

local function __init(self)
  self.id = 0
  self.group = ""
  self.menu_option = 0
  self.lod_eq_city = nil
  self.lod_eq_world = nil
  self.lod_volume_city = nil
  self.lod_volume_world = nil
end

local function __delete(self)
  self.id = nil
  self.group = nil
  self.menu_option = nil
  self.lod_eq_city = nil
  self.lod_eq_world = nil
  self.lod_volume_city = nil
  self.lod_volume_world = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.group = row:getValue("audiomixer_group") or ""
  self.menu_option = tonumber(row:getValue("menu_option")) or 1
  local lod_eq_str = row:getValue("lod_eq")
  if not string.IsNullOrEmpty(lod_eq_str) then
    local p = string.split(lod_eq_str, ";")
    local cityEq = string.split(p[1], ",")
    self.lod_eq_city = {}
    for i, v in ipairs(cityEq) do
      self.lod_eq_city[i] = tonumber(v) or 0
    end
    local worldEq = string.split(p[2], ",")
    self.lod_eq_world = {}
    for i, v in ipairs(worldEq) do
      self.lod_eq_world[i] = tonumber(v) or 0
    end
  end
  local lod_volume_str = row:getValue("lod_volume")
  if not string.IsNullOrEmpty(lod_volume_str) then
    local p = string.split(lod_volume_str, ";")
    local cityVolumes = string.split(p[1], ",")
    self.lod_volume_city = {}
    for i, v in ipairs(cityVolumes) do
      self.lod_volume_city[i] = tonumber(v) or 0
    end
    local worldVolumes = string.split(p[2], ",")
    self.lod_volume_world = {}
    for i, v in ipairs(worldVolumes) do
      self.lod_volume_world[i] = tonumber(v) or 0
    end
  end
end

LWAudioMixerGroupTemplate.__init = __init
LWAudioMixerGroupTemplate.__delete = __delete
LWAudioMixerGroupTemplate.InitData = InitData
return LWAudioMixerGroupTemplate
