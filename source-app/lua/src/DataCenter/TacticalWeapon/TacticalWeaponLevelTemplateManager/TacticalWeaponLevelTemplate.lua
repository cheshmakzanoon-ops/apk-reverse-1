local TacticalWeaponLevelTemplate = BaseClass("TacticalWeaponLevelTemplate")

local function __init(self)
  self.id = 0
  self.upgradeType = 0
  self.progress_total = 0
  self.progress_add = 0
  self.cost_resItem = {}
  self.attr_add = {}
  self.attr_per_progressAdd = {}
  self.skillLevel = 0
  self.skill = 0
  self.bouns_rate = 0
  self.promote_tips = ""
  self.appearance = 0
  self.need_building = {}
  self.power = {}
  self.chip_background = ""
  self.sub_level = -1
  self.level = 0
  self.upgrade_id = 0
end

local function __delete(self)
  self.id = nil
  self.upgradeType = nil
  self.progress_total = nil
  self.progress_add = nil
  self.cost_resItem = nil
  self.attr_add = nil
  self.attr_per_progressAdd = nil
  self.skillLevel = nil
  self.skill = nil
  self.bouns_rate = nil
  self.promote_tips = nil
  self.appearance = nil
  self.need_building = nil
  self.power = nil
  self.chip_background = nil
  self.sub_level = nil
  self.level = nil
  self.upgrade_id = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.upgradeType = row:getValue("upgradeType")
  self.progress_total = row:getValue("progress_total")
  self.progress_add = row:getValue("progress_add")
  self.skillLevel = row:getValue("skill_level")
  self.skill = row:getValue("skill")
  self.bouns_rate = row:getValue("bouns_rate")
  self.promote_tips = row:getValue("promote_tips")
  self.appearance = row:getValue("appearance")
  self.need_building = row:getValue("need_building") or {}
  self.power = row:getValue("power") or {}
  self.sub_level = row:getValue("sub_level")
  self.level = row:getValue("level")
  self.upgrade_id = row:getValue("upgrade_id")
  self.cost_resItem = {}
  local cost_resItem = row:getValue("cost_resItem") or ""
  if cost_resItem ~= "" then
    local cost_resItem_arr = string.split(cost_resItem, "|")
    for i = 1, #cost_resItem_arr do
      local cost_resItem_arr2 = string.split(cost_resItem_arr[i], ";")
      if #cost_resItem_arr2 == 2 then
        table.insert(self.cost_resItem, {
          id = tonumber(cost_resItem_arr2[1]),
          value = tonumber(cost_resItem_arr2[2])
        })
      end
    end
  end
  self.attr_add = {}
  local attr_add = row:getValue("attr_add") or ""
  if attr_add ~= "" then
    local attr_add_arr = string.split(attr_add, "|")
    for i = 1, #attr_add_arr do
      local attr_add_arr2 = string.split(attr_add_arr[i], ";")
      if #attr_add_arr2 == 2 then
        table.insert(self.attr_add, {
          id = tonumber(attr_add_arr2[1]),
          value = tonumber(attr_add_arr2[2])
        })
      end
    end
  end
  self.attr_per_progressAdd = {}
  local attr_per_progressAdd = row:getValue("attr_per_progressAdd") or ""
  if attr_per_progressAdd ~= "" then
    local attr_per_progressAdd_arr = string.split(attr_per_progressAdd, "|")
    for i = 1, #attr_per_progressAdd_arr do
      local attr_per_progressAdd_arr2 = string.split(attr_per_progressAdd_arr[i], ";")
      if #attr_per_progressAdd_arr2 == 2 then
        table.insert(self.attr_per_progressAdd, {
          id = tonumber(attr_per_progressAdd_arr2[1]),
          value = tonumber(attr_per_progressAdd_arr2[2])
        })
      end
    end
  end
  self.chip_background = row:getValue("chip_background")
end

local function GetAttrs(self, progress)
  local prog = progress or 0
  local attrs = {}
  for k, v in pairs(self.attr_add) do
    table.insert(attrs, v)
  end
  
  local function getIndex(arr, a)
    for i = 1, #arr do
      if arr[i].id == a then
        return i
      end
    end
    return nil
  end
  
  if 0 < progress and 0 < self.progress_add then
    for k, v in pairs(self.attr_per_progressAdd) do
      local index = getIndex(attrs, v.id)
      if not index then
        table.insert(attrs, v)
        index = #attrs
      end
      attrs[index].value = attrs[index].value + prog / self.progress_add * v.value
    end
  end
  return attrs
end

local function GetSkillInfos(self, addSkillStar)
  local skillInfos = {}
  local skillInfo = SkillInfo.New()
  local extraStar = 0
  if addSkillStar then
    extraStar = addSkillStar
  else
    extraStar = DataCenter.TacticalWeaponManager:GetMainWeaponSkillStarExtra()
  end
  skillInfo:CreateFromTemplate(self.skill + extraStar, true, self.skillLevel)
  table.insert(skillInfos, skillInfo)
  return skillInfos
end

local function GetPower(self, progress)
  local power = 0
  if #self.power >= 2 then
    power = self.power[1]
    local prog = progress or 0
    if 0 < progress and 0 < self.progress_add then
      power = power + prog / self.progress_add * self.power[2]
    end
  end
  return power
end

TacticalWeaponLevelTemplate.__init = __init
TacticalWeaponLevelTemplate.__delete = __delete
TacticalWeaponLevelTemplate.InitData = InitData
TacticalWeaponLevelTemplate.GetAttrs = GetAttrs
TacticalWeaponLevelTemplate.GetSkillInfos = GetSkillInfos
TacticalWeaponLevelTemplate.GetPower = GetPower
return TacticalWeaponLevelTemplate
