local LWMasteryTemplate = BaseClass("LWMasteryTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.mastery_id = 0
  self.home = 0
  self.icon = ""
  self.name = ""
  self.description = ""
  self.des_value = 0
  self.pos = 0
  self.priors = {}
  self.needPriorLv = {}
  self.type = 0
  self.need_home_lv = 0
  self.need_mastery = 0
  self.lv = 0
  self.max_lv = 0
  self.effectDict = {}
  self.skill = 0
  self.canOverview = false
  self.descList = {}
  self.descValuesList = {}
  self.nexts = {}
  self.logo = 0
  self.color = 0
  self.season_only = 0
  self.mastery_lock = false
  self.desc_condition = nil
  self.description_new = nil
  self.extra_condition = nil
  self.extra_condition_desc = nil
end

local function __delete(self)
  self.id = 0
  self.mastery_id = 0
  self.home = 0
  self.icon = ""
  self.name = ""
  self.description = ""
  self.des_value = 0
  self.pos = 0
  self.priors = {}
  self.needPriorLv = {}
  self.type = 0
  self.need_home_lv = 0
  self.need_mastery = 0
  self.lv = 0
  self.max_lv = 0
  self.effectDict = {}
  self.skill = 0
  self.canOverview = false
  self.descList = {}
  self.descValuesList = {}
  self.nexts = {}
  self.logo = 0
  self.color = 0
  self.season_only = 0
  self.mastery_lock = false
  self.desc_condition = nil
  self.description_new = nil
  self.extra_condition = nil
  self.extra_condition_desc = nil
  self.season_step = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.mastery_id = tonumber(row:getValue("group")) or 0
  self.pos = 1
  self.pos = toInt(row:getValue("pos")) or 1
  self.home = tonumber(row:getValue("home")) or 0
  self.icon = row:getValue("icon") or ""
  self.name = row:getValue("name") or ""
  self.descList = {}
  local descListStr = tostring(row:getValue("description") or "")
  local descStrs = string.split(descListStr, "|")
  for _, str in ipairs(descStrs) do
    local sep = string.contains(str, ",") and "," or ";"
    local descSpls = string.split(str, sep)
    if #descSpls == 2 then
      local desc = {
        dialog = descSpls[1],
        type = tonumber(descSpls[2])
      }
      table.insert(self.descList, desc)
    end
  end
  self.des_value = tonumber(row:getValue("des_value"))
  self.descValuesList = {}
  local descValuesListStr = tostring(row:getValue("des_value") or "")
  local descValuesStr = string.split(descValuesListStr, "|")
  for _, str in ipairs(descValuesStr) do
    local values = {}
    for _, spl in ipairs(string.split(tostring(str), ";")) do
      table.insert(values, tonumber(spl))
    end
    table.insert(self.descValuesList, values)
  end
  self.type = tonumber(row:getValue("type")) or 0
  self.need_home_lv = tonumber(row:getValue("need_home_lv")) or 0
  self.need_mastery = tonumber(row:getValue("need_mastery")) or 0
  self.priors = {}
  self.condType = MasteryCondType.And
  local priorStr = row:getValue("priors") or ""
  if not string.IsNullOrEmpty(priorStr) then
    self.condType = string.contains(priorStr, "|") and MasteryCondType.Or or MasteryCondType.And
    for _, str in ipairs(string.split(tostring(priorStr), self.condType == MasteryCondType.And and ";" or "|")) do
      table.insert(self.priors, tonumber(str))
    end
  end
  self.needPriorLv = {}
  local needTalentStr = row:getValue("needTalent") or ""
  if not string.IsNullOrEmpty(needTalentStr) then
    self.condType = string.contains(needTalentStr, "|") and MasteryCondType.Or or MasteryCondType.And
    for _, str in ipairs(string.split(tostring(needTalentStr), self.condType == MasteryCondType.And and ";" or "|")) do
      local spls = string.split(str, "_")
      if 0 < #spls then
        self.needPriorLv[tonumber(spls[1])] = tonumber(spls[2]) or 1
      end
    end
  end
  self.lv = tonumber(row:getValue("Lv")) or 0
  self.max_lv = tonumber(row:getValue("maxLv")) or 0
  self.effectDict = {}
  local effectStr = row:getValue("extraPara") or ""
  if not string.IsNullOrEmpty(effectStr) then
    for _, str in ipairs(string.split(effectStr, "|")) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        self.effectDict[tonumber(spls[1]) or 0] = tonumber(spls[2])
      end
    end
  end
  self.skill = tonumber(row:getValue("linkSkill")) or 0
  self.canOverview = tonumber(row:getValue("overview")) == 1
  self.logo = tonumber(row:getValue("logo")) or 0
  self.color = tonumber(row:getValue("color")) or 0
  self.season_only = tonumber(row:getValue("season_only")) or 0
  self.mastery_lock = tonumber(row:getValue("mastery_lock")) == 1
  self.desc_condition = row:getValue("desc_condition")
  local description_new = row:getValue("description_new")
  if not table.IsNullOrEmpty(description_new) then
    self.descList_new = {}
    for i = 1, #description_new do
      local str = tostring(description_new[i] or "")
      local sep = string.contains(str, ",") and "," or ";"
      local reg
      if sep == "," then
        reg = "([^;]+),([^;]+)"
      else
        reg = "([^;]+);([^;]+)"
      end
      local dialog, type = string.match(str, reg)
      if dialog and type then
        local desc = {
          dialog = dialog,
          type = tonumber(type)
        }
        table.insert(self.descList_new, desc)
      end
    end
  end
  local extra_condition = row:getValue("extra_condition")
  if not string.IsNullOrEmpty(extra_condition) then
    self.extra_condition = string.split(extra_condition, ",")
    local extra_condition_desc = row:getValue("extra_condition_desc")
    if not string.IsNullOrEmpty(extra_condition_desc) then
      self.extra_condition_desc = string.split(extra_condition_desc, ",")
    end
  end
  self.season_step = row:getValue("season_step")
  self.recommend_weight = row:getValue("recommend_weight")
end

local function IsSkillNode(self)
  return self.skill ~= 0
end

local function GetName(self)
  if self:IsSkillNode() then
    local skillTemplate = DataCenter.MasteryManager:GetSkillTemplate(self.skill)
    return skillTemplate.name
  end
  return self.name
end

local function GetDescStr(self)
  if self:IsSkillNode() then
    local skillTemplate = DataCenter.MasteryManager:GetSkillTemplate(self.skill)
    return skillTemplate:GetDescStr(self.lv)
  end
  local lines = {}
  for i, desc in ipairs(self.descList) do
    local line = ""
    local values = self.descValuesList[i] or {}
    local strs = {}
    for _, value in ipairs(values) do
      if desc.type ~= EffectLocalType.Dialog then
        local str = DataCenter.BuildManager:GetEffectNumWithType(value, desc.type)
        table.insert(strs, str)
      end
    end
    if 0 < #strs then
      if string.contains(Localization:GetString(desc.dialog, "", "", ""), "{") then
        line = Localization:GetString(desc.dialog, table.unpack(strs))
      else
        line = Localization:GetString(desc.dialog) .. " <color=green>" .. table.unpack(strs) .. "</color>"
      end
    else
      line = Localization:GetString(desc.dialog)
    end
    table.insert(lines, line)
  end
  if 0 < #lines then
    return string.join(lines, "\n")
  else
    return ""
  end
end

local function GetPriorsShowInTip(self)
  local list = {}
  for _, priorGroup in ipairs(self.priors) do
    local priorTemplate = DataCenter.MasteryManager:GetTemplate(priorGroup)
    if priorTemplate and not priorTemplate.isDefault then
      table.insert(list, priorGroup)
    end
  end
  return list
end

local function GetDesc(self)
  local dialog, type, dialog_info
  if not table.IsNullOrEmpty(self.desc_condition) then
    local nowSeason = SeasonUtil.GetSeason()
    local nowSeasonDay = SeasonUtil.GetSeasonDay()
    local key_id
    for i = #self.desc_condition, 1, -1 do
      local condition = self.desc_condition[i]
      local season, seasonDay = string.match(condition, "(%d+);(%d+)")
      if season and seasonDay and (nowSeason > tonumber(season) or nowSeason == tonumber(season) and nowSeasonDay >= tonumber(seasonDay)) then
        key_id = i
        break
      end
    end
    if key_id then
      if self.descList_new[key_id] then
        dialog_info = self.descList_new[key_id]
      else
        dialog_info = self.descList_new[#self.descList_new]
      end
    end
  end
  if not dialog_info and self.descList and self.descList[1] then
    dialog_info = self.descList[1]
  end
  if dialog_info then
    dialog = dialog_info.dialog
    type = dialog_info.type
  end
  return dialog, type
end

local function GetIconFullPath(self)
  return UIUtil.GetFullPath(LoadPath.LWMasterySpritePath, self.icon)
end

LWMasteryTemplate.__init = __init
LWMasteryTemplate.InitData = InitData
LWMasteryTemplate.IsSkillNode = IsSkillNode
LWMasteryTemplate.GetName = GetName
LWMasteryTemplate.GetDescStr = GetDescStr
LWMasteryTemplate.GetPriorsShowInTip = GetPriorsShowInTip
LWMasteryTemplate.GetDesc = GetDesc
LWMasteryTemplate.GetIconFullPath = GetIconFullPath
return LWMasteryTemplate
