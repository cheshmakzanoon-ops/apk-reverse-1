local ScienceTabTemplate = BaseClass("ScienceTabTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.icon = ""
  self.icon_start = ""
  self.type = ScienceType.Build
  self.order = 0
  self.unlock_level = 0
  self.unlockConditionType = 0
  self.unlock_condition = {}
  self.show_progress = ""
  self.show_level = ""
  self.unlock_progress = ""
  self.show_effect_id = {}
  self.show_open_time = {}
  self.unlock_effect_id = {}
  self.unlock_open_time = {}
  self.unlock_dialog = ""
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.icon = nil
  self.icon_start = nil
  self.type = nil
  self.order = nil
  self.unlock_level = nil
  self.unlockConditionType = nil
  self.unlock_condition = nil
  self.show_progress = nil
  self.show_level = nil
  self.unlock_progress = nil
  self.show_effect_id = nil
  self.show_open_time = nil
  self.unlock_effect_id = nil
  self.unlock_open_time = nil
  self.unlock_dialog = nil
  self.unlockCondition = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.icon = row:getValue("icon")
  self.icon_start = row:getValue("icon_start")
  self.type = row:getIntValue("type")
  self.order = row:getIntValue("order")
  self.unlock_level = row:getIntValue("unlock_level")
  self.unlockConditionType = row:getIntValue("unlock_condition")
  self.show_progress = row:getValue("show_progress")
  self.show_level = row:getValue("show_level")
  self.show_effect_id = {}
  local show_effect_id = row:getValue("show_effect_id")
  if not string.IsNullOrEmpty(show_effect_id) then
    self.show_effect_id = string.string2array_num_oneSep(show_effect_id, ";")
  end
  self.show_open_time = {}
  local show_open_time = row:getValue("show_open_time")
  if not string.IsNullOrEmpty(show_open_time) then
    self.show_open_time = string.string2array_num_oneSep(show_open_time, ";")
  end
  self.unlock_effect_id = {}
  local unlock_effect_id = row:getValue("unlock_effect_id")
  if not string.IsNullOrEmpty(unlock_effect_id) then
    self.unlock_effect_id = string.string2array_num_oneSep(unlock_effect_id, ";")
  end
  self.unlock_open_time = {}
  local unlock_open_time = row:getValue("unlock_open_time")
  if not string.IsNullOrEmpty(unlock_open_time) then
    self.unlock_open_time = string.string2array_num_oneSep(unlock_open_time, ";")
  end
  local para_type = row:getValue("para_type")
  local para1 = row:getValue("para1")
  if para_type ~= nil and para_type ~= "" and para1 ~= nil and para1 ~= "" then
    local spl = string.split(para_type, "|")
    local spl2 = string.split(para1, "|")
    local count = #spl
    if count == #spl2 then
      for i = 1, count do
        local condition = {}
        condition.type = tonumber(spl[i])
        condition.para = {}
        local spl3 = string.split(spl2[i], ";")
        for k, v in ipairs(spl3) do
          condition.para[k] = tonumber(v)
        end
        table.insert(self.unlock_condition, condition)
      end
    end
  end
  self.unlock_progress = row:getValue("unlock_progress") or ""
  if not string.IsNullOrEmpty(self.unlock_progress) then
    local unlock_progressStr = string.split(self.unlock_progress, ";")
    self.unlockCondition = {}
    self.unlockCondition.idList = {}
    self.unlockCondition.totalPercent = 0
    if #unlock_progressStr == 2 then
      local tempIdStr = unlock_progressStr[1]
      if not string.IsNullOrEmpty(tempIdStr) then
        local idList = string.split(tempIdStr, ",")
        for i, v in ipairs(idList) do
          if v then
            local id = tonumber(v)
            table.insert(self.unlockCondition.idList, id)
          end
        end
        self.unlockCondition.totalPercent = tonumber(unlock_progressStr[2])
      end
    end
  end
  self.unlock_dialog = row:getValue("unlock_dialog") or ""
end

ScienceTabTemplate.__init = __init
ScienceTabTemplate.__delete = __delete
ScienceTabTemplate.InitData = InitData
return ScienceTabTemplate
