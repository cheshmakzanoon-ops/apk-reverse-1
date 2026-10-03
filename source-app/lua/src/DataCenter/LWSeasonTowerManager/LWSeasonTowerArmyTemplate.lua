local LWSeasonTowerArmyTemplate = BaseClass("LWSeasonTowerArmyTemplate")

local function __init(self)
  self.id = 0
end

local function __delete(self)
  self.id = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.army_icon = row:getValue("army_icon")
  self.name = row:getValue("name")
  self.rec_uav_power = tonumber(row:getValue("rec_uav_power")) or 0
  self.rec_equip_power = tonumber(row:getValue("rec_equip_power")) or 0
  self.rec_sci_power = tonumber(row:getValue("rec_sci_power")) or 0
  self.rec_honor_power = tonumber(row:getValue("rec_honor_power")) or 0
  self.replace_icon = row:getValue("replace_icon") or ""
  self.army_awaken = row:getValue("army_awaken")
  local pve_power = row:getValue("pve_power")
  if not string.IsNullOrEmpty(pve_power) then
    self.pve_power = string.string2array_num_oneSep(pve_power, "|")
  end
  self.line_up = {}
  for i = 1, 6 do
    local heroParam = string.format("hero%d", i)
    local soldierParam = string.format("hero%d_soldier", i)
    local heroStr = row:getValue(heroParam)
    local soldierStr = row:getValue(soldierParam)
    if not string.IsNullOrEmpty(heroStr) then
      local heroData, soldierData
      local heroArr = string.split_ss_array(heroStr, "|")
      heroData = {
        metaId = tonumber(heroArr[1]),
        level = tonumber(heroArr[2]),
        skillStar = tonumber(heroArr[3]),
        skillLevel = tonumber(heroArr[4]),
        rank = tonumber(heroArr[5] or 0) or 0,
        awakenLv = self.army_awaken ~= nil and self.army_awaken[i] or 0
      }
      if not string.IsNullOrEmpty(soldierStr) then
        local soldierArr = string.split_ss_array(soldierStr, "|")
        soldierData = {
          metaId = tonumber(soldierArr[1]),
          num = tonumber(soldierArr[2])
        }
      end
      self.line_up[i] = {heroData = heroData, soldierData = soldierData}
    end
  end
  local uav_property_str = row:getValue("uav_property")
  if not string.IsNullOrEmpty(uav_property_str) then
    self.uav_property = {}
    local uav_property_arr = string.split_ss_array(uav_property_str, "|")
    for _, uav_property_pair in pairs(uav_property_arr) do
      local uav_property_pair_arr = string.split_ss_array(uav_property_pair, ";")
      if #uav_property_pair_arr == 2 then
        local effectId = tonumber(uav_property_pair_arr[1])
        local effectValue = tonumber(uav_property_pair_arr[2])
        self.uav_property[effectId] = effectValue
      end
    end
  end
  local uav_skill_str = row:getValue("uav_skill")
  if not string.IsNullOrEmpty(uav_skill_str) then
    self.uav_skill = {}
    local uav_skill_arr = string.split_ss_array(uav_skill_str, "|")
    for _, uav_skill_pair in pairs(uav_skill_arr) do
      local uav_skill_pair_arr = string.split_ss_array(uav_skill_pair, ";")
      if #uav_skill_pair_arr == 2 then
        local skillId = tonumber(uav_skill_pair_arr[1])
        local skillLevel = tonumber(uav_skill_pair_arr[2])
        self.uav_skill[skillId] = skillLevel
      end
    end
  end
end

function LWSeasonTowerArmyTemplate:InterpolationTable(lastTemplate, nextTemplate, name, percent)
  local lastValue = lastTemplate[name]
  local newValue = nextTemplate[name]
  for i, v in pairs(lastValue) do
    local new = newValue[i]
    lastValue[i] = v + (new - v) * percent
  end
end

function LWSeasonTowerArmyTemplate:InterpolationNumber(lastTemplate, nextTemplate, name, percent)
  local lastValue = lastTemplate[name]
  local newValue = nextTemplate[name]
  self[name] = lastValue + (newValue - lastValue) * percent
end

function LWSeasonTowerArmyTemplate:InterpolationByTemplate(nextTemplate, progress, total)
  local percent = progress / total
  self:InterpolationTable(self, nextTemplate, "pve_power", percent)
  self:InterpolationTable(self, nextTemplate, "uav_property", percent)
  self:InterpolationNumber(self, nextTemplate, "rec_honor_power", percent)
  self:InterpolationNumber(self, nextTemplate, "rec_sci_power", percent)
  self:InterpolationNumber(self, nextTemplate, "rec_equip_power", percent)
  self:InterpolationNumber(self, nextTemplate, "rec_uav_power", percent)
  for k, v in pairs(self.line_up) do
    self:InterpolationTable(v, nextTemplate.line_up[k], "soldierData", percent)
  end
end

LWSeasonTowerArmyTemplate.__init = __init
LWSeasonTowerArmyTemplate.__delete = __delete
LWSeasonTowerArmyTemplate.InitData = InitData
return LWSeasonTowerArmyTemplate
