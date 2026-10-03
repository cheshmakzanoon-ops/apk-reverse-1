local BloodyNightStageTemplate = BaseClass("BloodyNightStageTemplate")

local function __init(self)
  self.id = 0
end

local function __delete(self)
  self.id = nil
  self.flag = nil
  self.stage = nil
  self.durationTime = nil
  self.stage_bg = nil
  self.stage_banner = nil
  self.stage_icon = nil
  self.stage_name = nil
  self.ppt_show = nil
  self.rank_id = nil
end

local function InitConfig(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.flag = row:getValue("flag")
  self.stage = row:getValue("stage")
  self.durationTime = row:getValue("durationTime")
  self.stage_bg = row:getValue("stage_bg")
  self.stage_banner = row:getValue("stage_banner")
  self.stage_icon = row:getValue("stage_icon")
  self.stage_name = row:getValue("stage_name")
  self.stage_desc = row:getValue("stage_desc")
  self.stage_png = row:getValue("stage_png")
  self.ppt_show = row:getValue("ppt_show")
  self.blood_night_switch = row:getValue("blood_night_switch") == "1"
  local rank_id = row:getValue("rank_id")
  if not table.IsNullOrEmpty(rank_id) then
    self.rank_id = rank_id
  end
end

BloodyNightStageTemplate.__init = __init
BloodyNightStageTemplate.__delete = __delete
BloodyNightStageTemplate.InitConfig = InitConfig
return BloodyNightStageTemplate
