local PveMonsterTemplate = BaseClass("PveMonsterTemplate")
local Const = require("Scene.LWBattle.Const")

local function __init(self)
end

local function __delete(self)
  self.skill = nil
  self.collide_damage = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.name = row:getValue("name")
  self.asset = row:getValue("asset")
  self.avatar = row:getValue("avatar")
  self.icon = row:getValue("icon")
  self.type = tonumber(row:getValue("type")) or 0
  self.monster_type = tonumber(row:getValue("monster_type")) or 0
  self.is_attack = tonumber(row:getValue("is_attack")) or 0
  self.is_move = tonumber(row:getValue("is_move")) or 0
  self.move_speed = tonumber(row:getValue("move_speed")) or 0
  self.alert_range = tonumber(row:getValue("alert_range")) or 0
  self.hp_bar_num = tonumber(row:getValue("hp_bar_num")) or 1
  self.attack = tonumber(row:getValue("attack")) or 0
  self.attack_interval = tonumber(row:getValue("attack_interval")) or 0
  self.attack_radius = tonumber(row:getValue("attack_radius")) or 0
  self.hp = tonumber(row:getValue("hp")) or 1
  self.hp_bar_height = tonumber(row:getValue("hp_bar_height")) or 2
  self.hp_type = tonumber(row:getValue("hp_type")) or 0
  self.is_hp_text = tonumber(row:getValue("is_hp_text")) or 0
  self.collide_radius = tonumber(row:getValue("collide_radius")) or 1
  self.death_trigger_item = tonumber(row:getValue("death_trigger_item"))
  self.model_size = tonumber(row:getValue("model_size")) or 1
  self.crash_kill = tonumber(row:getValue("crash_kill")) or 0
  self.is_boss = tonumber(row:getValue("is_boss")) or 0
  self.hp = tonumber(row:getValue("hp")) or 1
  self.physics_defence = tonumber(row:getValue("physics_defence")) or 0
  self.magic_defence = tonumber(row:getValue("magic_defence")) or 0
  local skillStr = row:getValue("skill")
  if skillStr == nil or skillStr == "" then
    self.skill = nil
  else
    self.skill = {}
    skillStr = string.split(skillStr, "|")
    for _, skill in pairs(skillStr) do
      table.insert(self.skill, tonumber(skill))
    end
  end
  self.ignore_hit_stiff = tonumber(row:getValue("ignore_hit_stiff")) or 0
  self.ignore_hit_back = tonumber(row:getValue("ignore_hit_back")) or 0
  self.property = row:getValue("property")
  self.monster_effect = tonumber(row:getValue("monster_effect")) or 0
  self.collide_count = tonumber(row:getValue("collide_count")) or -1
  self.collide_damage = nil
  local spl = string.split(row:getValue("collide_damage"), "|")
  if #spl == 3 then
    self.collide_damage = {}
    for i, v in ipairs(spl) do
      self.collide_damage[i] = tonumber(v)
    end
  end
  local headshot_show = tonumber(row:getValue("headshot_show"))
  self.headshot_show = headshot_show == 1
  self.action_type = tonumber(row:getValue("action_type")) or 0
  self.use_idle_anim = tonumber(row:getValue("use_idle_anim")) or 0
  self.dynamic_resource = row:getValue("dynamic_resource")
  self.start_hp = tonumber(row:getValue("start_hp")) or 0
  self.trigger_para = row:getValue("trigger_para")
  self.monster_param = row:getValue("monster_param")
  self.fire_paths = row:getValue("fire_path")
  if self.monster_type == Const.MonsterType.AisillaBoss and not string.IsNullOrEmpty(self.monster_param) then
    self.specialSkill = {}
    local specialSkillStr = string.split(self.monster_param, "|")
    for _, skill in ipairs(specialSkillStr) do
      table.insert(self.specialSkill, tonumber(skill))
    end
  end
  self.comps_path = row:getValue("comps_path") or {}
  self.skin_obj_paths = row:getValue("skin_obj_paths") or {}
  self.comp_monsters = {}
  local compMonsterCfgArr = row:getValue("comp_monsters")
  if compMonsterCfgArr and 0 < #compMonsterCfgArr then
    for i, cmpMonsterCfgStr in ipairs(compMonsterCfgArr) do
      local monsterId = 0
      local monsterCmpPathIndic = 0
      if not string.IsNullOrEmpty(cmpMonsterCfgStr) then
        local paramStrs = string.split(cmpMonsterCfgStr, ";")
        monsterId = paramStrs[1] and tonumber(paramStrs[1]) or 0
        monsterCmpPathIndic = paramStrs[2] and tonumber(paramStrs[2]) or 0
      end
      table.insert(self.comp_monsters, {monsterId = monsterId, cmpPathIndic = monsterCmpPathIndic})
    end
  end
  self.comp_groups = {}
  local compGroupsCfgArr = row:getValue("comp_groups")
  if compGroupsCfgArr and 0 < #compGroupsCfgArr then
    for i, compGroupsCfgStr in ipairs(compGroupsCfgArr) do
      local cmpMonsterIndices = {}
      if not string.IsNullOrEmpty(compGroupsCfgStr) then
        local cmpMonsterIndicesStrs = string.split(compGroupsCfgStr, ";")
        for j, monsterIndicStr in ipairs(cmpMonsterIndicesStrs) do
          table.insert(cmpMonsterIndices, tonumber(monsterIndicStr))
        end
      end
      table.insert(self.comp_groups, cmpMonsterIndices)
    end
  end
  self.comp_group_params = {}
  local compGroupCfgParams = row:getValue("comp_group_params")
  if compGroupCfgParams and 0 < #compGroupCfgParams then
    for i, compGroupCfgParamStr in ipairs(compGroupCfgParams) do
      local groupIndic = 1
      local groupAliveShowSkinIndices = {}
      local groupAliveHideSkinIndices = {}
      local groupInAliveShowSkinIndices = {}
      local groupInAliveHideSkinIndices = {}
      local groupInAliveAnim
      if not string.IsNullOrEmpty(compGroupCfgParamStr) then
        local compGroupParamStrs = string.split(compGroupCfgParamStr, ";")
        groupIndic = compGroupParamStrs[1] and tonumber(compGroupParamStrs[1]) or 0
        if not string.IsNullOrEmpty(compGroupParamStrs[2]) then
          local cmpAliveShowSkinIndicStrs = string.split(compGroupParamStrs[2], ":")
          for j, cmpAliveShowSkinIndicStr in ipairs(cmpAliveShowSkinIndicStrs) do
            table.insert(groupAliveShowSkinIndices, tonumber(cmpAliveShowSkinIndicStr))
          end
        end
        if not string.IsNullOrEmpty(compGroupParamStrs[3]) then
          local cmpAliveHideSkinIndicStrs = string.split(compGroupParamStrs[3], ":")
          for j, cmpAliveHideSkinIndicStr in ipairs(cmpAliveHideSkinIndicStrs) do
            table.insert(groupAliveHideSkinIndices, tonumber(cmpAliveHideSkinIndicStr))
          end
        end
        if not string.IsNullOrEmpty(compGroupParamStrs[4]) then
          local cmpInAliveShowSkinIndicStrs = string.split(compGroupParamStrs[4], ":")
          for j, cmpInAliveShowSkinIndicStr in ipairs(cmpInAliveShowSkinIndicStrs) do
            table.insert(groupInAliveShowSkinIndices, tonumber(cmpInAliveShowSkinIndicStr))
          end
        end
        if not string.IsNullOrEmpty(compGroupParamStrs[5]) then
          local cmpInAliveHideSkinIndicStrs = string.split(compGroupParamStrs[5], ":")
          for j, cmpInAliveHideSkinIndicStr in ipairs(cmpInAliveHideSkinIndicStrs) do
            table.insert(groupInAliveHideSkinIndices, tonumber(cmpInAliveHideSkinIndicStr))
          end
        end
        groupInAliveAnim = compGroupParamStrs[6]
      end
      local compGroupCfgParam = {
        groupIndic = groupIndic,
        aliveShowSkinIndices = groupAliveShowSkinIndices,
        aliveHideSkinIndices = groupAliveHideSkinIndices,
        inAliveShowSkinIndices = groupInAliveShowSkinIndices,
        inAliveHideSkinIndices = groupInAliveHideSkinIndices,
        inAliveAnim = groupInAliveAnim
      }
      table.insert(self.comp_group_params, compGroupCfgParam)
    end
  end
  self.status_group_params = {}
  local statusGroupCfgParams = row:getValue("status_group_params")
  if statusGroupCfgParams and 0 < #statusGroupCfgParams then
    for i, statusGroupsCfgStr in ipairs(statusGroupCfgParams) do
      local statusGroupIndices = {}
      if not string.IsNullOrEmpty(statusGroupsCfgStr) then
        local statusGroupCfgStrs = string.split(statusGroupsCfgStr, ";")
        for j, statusGroupCfgStr in ipairs(statusGroupCfgStrs) do
          table.insert(statusGroupIndices, tonumber(statusGroupCfgStr))
        end
      end
      table.insert(self.status_group_params, statusGroupIndices)
    end
  end
  local uiPath = row:getValue("ui_path")
  if not string.IsNullOrEmpty(uiPath) then
    self.ui_path = uiPath
  end
end

PveMonsterTemplate.__init = __init
PveMonsterTemplate.__delete = __delete
PveMonsterTemplate.InitData = InitData
return PveMonsterTemplate
