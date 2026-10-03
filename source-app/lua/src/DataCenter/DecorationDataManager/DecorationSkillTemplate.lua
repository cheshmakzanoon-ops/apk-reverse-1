local DecorationSkillTemplate = BaseClass("DecorationSkillTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.type = 0
  self.name = ""
  self.desc = ""
  self.icon = ""
  self.status_id = 0
  self.cool_down = 0
  self.quality = 0
  self.order = 0
  self.lock_tips = ""
  self.range = 0
  self.camera_height = 0
  self.cd_show = 0
  self.use_times = 0
  self.recovery_speed = 0
  self.skill_tips = ""
  self.act_para = 0
  self.range_effect = ""
  self.range_effect_new = ""
  self.buff_effect = ""
  self.use_type = 0
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.name = nil
  self.desc = nil
  self.icon = nil
  self.status_id = nil
  self.cool_down = nil
  self.quality = nil
  self.order = nil
  self.lock_tips = nil
  self.range = nil
  self.camera_height = nil
  self.cd_show = nil
  self.use_times = nil
  self.recovery_speed = nil
  self.skill_tips = nil
  self.act_para = nil
  self.range_effect = nil
  self.range_effect_new = nil
  self.buff_effect = nil
  self.use_type = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.name = row:getValue("name") or ""
  self.desc = row:getValue("desc") or ""
  self.icon = row:getValue("icon") or ""
  self.status_id = tonumber(row:getValue("status_id")) or 0
  self.cool_down = tonumber(row:getValue("cool_down")) or 0
  self.quality = tonumber(row:getValue("quality")) or 0
  self.order = tonumber(row:getValue("order")) or 0
  self.lock_tips = row:getValue("lock_tips") or ""
  self.range = tonumber(row:getValue("range")) or 0
  self.camera_height = tonumber(row:getValue("camera_height")) or 0
  self.cd_show = tonumber(row:getValue("cd_show")) or 0
  self.use_times = tonumber(row:getValue("use_times")) or 0
  self.recovery_speed = tonumber(row:getValue("recovery_speed")) or 0
  self.skill_tips = row:getValue("skill_tips") or ""
  self.act_para = tonumber(row:getValue("act_para")) or 0
  self.range_effect = row:getValue("range_effect") or ""
  self.range_effect_new = row:getValue("range_effect_new") or ""
  self.buff_effect = row:getValue("buff_effect") or ""
  self.use_type = tonumber(row:getValue("use_type")) or 0
end

local function IsRangeTimeDescType(skillType)
  return skillType == DecorationSkillType.Music or skillType == DecorationSkillType.Season or skillType == DecorationSkillType.Sound or skillType == DecorationSkillType.SeasonMummy or skillType == DecorationSkillType.SeasonRainforest
end

local function GetDescStr(self)
  local descStr = ""
  if IsRangeTimeDescType(self.type) then
    local time = 0
    if 0 < self.status_id then
      time = GetTableData(TableName.StatusTab, self.status_id, "time") or 0
    end
    descStr = Localization:GetString(self.desc, self.range, time, self.cd_show)
  else
    descStr = Localization:GetString(self.desc)
  end
  return descStr
end

local function GetDescParams(self)
  if IsRangeTimeDescType(self.type) then
    local time = 0
    if 0 < self.status_id then
      time = GetTableData(TableName.StatusTab, self.status_id, "time") or 0
    end
    return self.range, time, self.cd_show
  else
    return nil
  end
end

local function GetCurNum(self, intervalUseTime)
  local curNum = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local intervalUseTimeMs = intervalUseTime * 1000
  if curTime > intervalUseTimeMs then
    curNum = math.floor((curTime - intervalUseTimeMs) / (self.recovery_speed * 1000))
    curNum = math.min(curNum, self.use_times)
  end
  return curNum
end

local function GetMaxNumTime(self, intervalUseTime)
  local maxNumTime = intervalUseTime * 1000
  maxNumTime = maxNumTime + self.use_times * (self.recovery_speed * 1000)
  return maxNumTime
end

local function GetSkillEffectList(self)
  if not self.effectList then
    self.effectList = {}
    local effectStr, index = self.range_effect, 1
    if not string.IsNullOrEmpty(effectStr) then
      self.effectList[index] = {effectStr, 5}
      index = index + 1
    end
    effectStr = self.range_effect_new
    if not string.IsNullOrEmpty(effectStr) then
      local effectVec = string.split(effectStr, "|")
      for k, v in pairs(effectVec) do
        local effect = string.split(v, ",")
        if 1 <= table.count(effect) then
          self.effectList[index] = {
            effect[1],
            tonumber(effect[2] or 10)
          }
          index = index + 1
        end
      end
    end
  end
  return self.effectList
end

DecorationSkillTemplate.__init = __init
DecorationSkillTemplate.__delete = __delete
DecorationSkillTemplate.InitData = InitData
DecorationSkillTemplate.GetDescStr = GetDescStr
DecorationSkillTemplate.GetDescParams = GetDescParams
DecorationSkillTemplate.GetCurNum = GetCurNum
DecorationSkillTemplate.GetMaxNumTime = GetMaxNumTime
DecorationSkillTemplate.GetSkillEffectList = GetSkillEffectList
return DecorationSkillTemplate
