local BloodyNightTemplate = BaseClass("BloodyNightTemplate")

local function __init(self)
  self.id = 0
end

local function __delete(self)
  self.id = nil
  self.buff_icon = nil
  self.buff_desc = nil
  self.night_desc = nil
end

local function InitConfig(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.buff_icon = row:getValue("buff_icon") or {}
  self.buff_desc = row:getValue("buff_desc") or {}
  self.night_desc = row:getValue("night_desc") or {}
  self.para3 = tonumber(row:getValue("para3")) or 0
  self.timeType = tonumber(row:getValue("timeType")) or 0
  self.running_boss_switch = row:getValue("running_boss_switch") == 1
end

BloodyNightTemplate.__init = __init
BloodyNightTemplate.__delete = __delete
BloodyNightTemplate.InitConfig = InitConfig
return BloodyNightTemplate
