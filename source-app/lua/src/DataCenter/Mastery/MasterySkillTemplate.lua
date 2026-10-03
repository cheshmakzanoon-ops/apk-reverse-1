local MasterySkillTemplate = BaseClass("MasterySkillTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.type = 0
  self.need_id = 0
  self.gotoId = 0
  self.name = ""
  self.desc = ""
  self.descValueStr = ""
  self.descValueList = {}
  self.icon = ""
  self.duration = 0
  self.cd_type = 1
  self.cd = 0
  self.cd_time = 0
  self.extra = ""
  self.useItem = {}
  self.values = {}
  self.values2 = {}
  self.location = MasterySkillLocation.None
  self.use_position = MasterySkillUsePosType.None
  self.skill_type = MasterySkillType.Normal
  self.guide_img_list = {}
  self.guide_description_list = {}
  self.active_skills = true
  self.passive_skill_tips = ""
  self.skill_display_type = 0
  self.passive_skill_toast = nil
  self.tips_after_use = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.need_id = tonumber(row:getValue("need_id")) or 0
  self.gotoId = tonumber(row:getValue("goto")) or 0
  self.name = row:getValue("name") or ""
  self.desc = row:getValue("description") or ""
  self.descValueList = {}
  self.descValueStr = row:getValue("des_value") or ""
  self.descValueList = string.split(self.descValueStr, "|")
  self.icon = row:getValue("icon") or ""
  self.duration = tonumber(row:getValue("time")) or 0
  self.cd_type = tonumber(row:getValue("cd_type")) or 1
  self.cd = tonumber(row:getValue("CD")) or 0
  self.cd_time = tonumber(row:getValue("cd_time")) or 0
  self.action = tonumber(row:getValue("action")) or 0
  self.red_point = tonumber(row:getValue("value4")) or 0
  self.extra = ""
  self.useItem = {}
  self.value1 = row:getValue("value1") or ""
  self.value2 = row:getValue("value2") or ""
  self.value3 = row:getValue("value3") or ""
  self.values = {}
  local valueStr = self.value1
  if not string.IsNullOrEmpty(valueStr) then
    local sep = string.contains(valueStr, "#") and "#" or ";"
    for i, str in ipairs(string.split(valueStr, sep)) do
      self.values[i] = tonumber(str)
    end
  end
  self.values2 = {}
  local value2Str = self.value2 or ""
  if not string.IsNullOrEmpty(value2Str) then
    local sep = string.contains(value2Str, "#") and "#" or ";"
    for i, str in ipairs(string.split(value2Str, sep)) do
      self.values2[i] = tonumber(str)
    end
  end
  self.skill_type = tonumber(row:getValue("skill_type")) or MasterySkillType.Normal
  self.location = tonumber(row:getValue("use_position")) or MasterySkillLocation.None
  local use_position = row:getValue("use_position")
  use_position = string.split(use_position, "|")
  self.use_position = {}
  for _, v in pairs(use_position) do
    table.insert(self.use_position, tonumber(v))
  end
  self.use_target = row:getValue("use_target")
  local guide_img = row:getValue("guide_img")
  if not string.IsNullOrEmpty(guide_img) then
    self.guide_img_list = string.split(guide_img, "|")
  end
  local guide_description = row:getValue("guide_description")
  if not string.IsNullOrEmpty(guide_description) then
    self.guide_description_list = string.split(guide_description, "|")
  end
  self.active_skills = row:getValue("active_skills") == 1
  self.passive_skill_tips = row:getValue("passive_skill_tips") or ""
  self.skill_display_type = row:getValue("skill_display_type") or 0
  self.passive_skill_toast = row:getValue("passive_skill_toast")
  if string.IsNullOrEmpty(self.passive_skill_toast) then
    self.passive_skill_toast = nil
  end
  self.tips_after_use = row:getValue("tips_after_use") or ""
  local active_skill_confirm_popup_key = row:getValue("active_skill_confirm_popup_key")
  if not string.IsNullOrEmpty(active_skill_confirm_popup_key) then
    self.active_skill_confirm_popup_key = active_skill_confirm_popup_key
  end
end

local function GetDescStr(self)
  return Localization:GetString(self.desc, table.unpack(self.descValueList))
end

function MasterySkillTemplate:CheckUsePosition(pos)
  for _, v in pairs(self.use_position) do
    if v == pos then
      return true
    end
  end
  return false
end

function MasterySkillTemplate:IsLandMineSkill()
  return self.type == MasterySkill.FireMine or self.type == MasterySkill.BrokenMine or self.type == MasterySkill.IceMine or self.type == MasterySkill.SandWormMine or self.type == MasterySkill.SandWormCaller or self.type == MasterySkill.LightMine
end

function MasterySkillTemplate:IsWarFlagSkill()
  return self.type == MasterySkill.WarFlag or self.type == MasterySkill.SandStorm or self.type == MasterySkill.FireBomb or self.type == MasterySkill.IceBomb or self.type == MasterySkill.Flare
end

local function GetIconFullPath(self)
  return UIUtil.GetFullPath(LoadPath.LWMasterySpritePath, self.icon)
end

MasterySkillTemplate.__init = __init
MasterySkillTemplate.InitData = InitData
MasterySkillTemplate.GetDescStr = GetDescStr
MasterySkillTemplate.GetIconFullPath = GetIconFullPath
return MasterySkillTemplate
