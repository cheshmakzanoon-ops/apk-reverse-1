local MonopolyPlacealityTemplate = BaseClass("MonopolyPlacealityTemplate")

function MonopolyPlacealityTemplate:__init()
  self.id = 0
  self.match = 0
  self.coordinate = {}
  self.tiles = {}
  self.type = 0
  self.type_para = {}
  self.pad_before = ""
  self.showCondition = 0
  self.pad_after = ""
  self.tileList = {}
  self.rankStageId = 0
  self.plot_before = ""
  self.polot_type = ""
  self.plot_before = ""
  self.pawn_before = ""
  self.pawn_after = ""
  self.plot_affer = ""
  self.reward = ""
  self.land_lock = 0
  self.lock_module_key = ""
  self.lock_module_tips_key = ""
  self.hasLockModule = false
  self.tryHeroes = {}
  self.base_land_type = 0
  self.event_plot_id = nil
  self.event_display_id = 0
  self.soldier_num = 0
  self.soldier_lan_num = nil
  self.bornEffect = nil
  self.headPath = nil
  self.textKey = nil
  self.event_reward_show = nil
  self.show_condition_param = 0
  self.soundId = 0
  self.quest_order = nil
  self.top_effect_path = nil
end

function MonopolyPlacealityTemplate:__delete()
  self.id = nil
  self.match = nil
  self.coordinate = nil
  self.tiles = nil
  self.type = nil
  self.type_para = nil
  self.pad_before = nil
  self.pad_after = nil
  self.pawn_before = nil
  self.pawn_after = nil
  self.plot_before = nil
  self.plot_affer = nil
  self.reward = nil
  self.land_lock = nil
  self.lock_module_key = nil
  self.lock_module_tips_key = nil
  self.hasLockModule = nil
  self.tryHeroes = nil
  self.base_land_type = nil
  self.event_plot_id = nil
  self.event_display_id = nil
  self.soldier_num = nil
  self.soldier_lan_num = nil
  self.bornEffect = nil
  self.headPath = nil
  self.textKey = nil
  self.event_reward_show = nil
  self.quest_order = nil
  self.top_effect_path = nil
end

function MonopolyPlacealityTemplate:InitData(row, id)
  self.id = tonumber(id) or 0
  self.match = row:getValue("match") or 0
  local coordinate = row:getValue("coordinate") or {}
  if type(coordinate) == "string" then
    coordinate = string.split(coordinate or "", ";")
  end
  if 1 < #coordinate then
    self.coordinate.x = tonumber(coordinate[1])
    self.coordinate.y = tonumber(coordinate[2])
  end
  if LuaEntry.DataConfig:CheckSwitch("monopoly_update") then
    local tileStrs = row:getValue("tiles_show") or {}
    for _, value in ipairs(tileStrs) do
      local num = tonumber(value) or 0
      local x = num % 10000 - 100
      local y = math.floor(num / 10000)
      table.insert(self.tileList, {x = x, y = y})
    end
  else
    local tileStrs = string.split(row:getValue("tiles") or "", "|")
    for _, str in ipairs(tileStrs) do
      local spls = string.split(str, ";")
      if #spls == 2 then
        local x = tonumber(spls[1])
        local y = tonumber(spls[2])
        table.insert(self.tileList, {x = x, y = y})
      end
    end
  end
  self.type = row:getValue("type") or 0
  self.type_para = row:getValue("type_para") or ""
  self.pad_before = row:getValue("pad_before") or ""
  self.pad_after = row:getValue("pad_after") or ""
  self.pawn_before = row:getValue("pawn_before") or ""
  self.pawn_after = row:getValue("pawn_after") or ""
  self.plot_before = row:getValue("plot_before") or ""
  self.plot_after = row:getValue("plot_after") or ""
  self.reward = row:getValue("reward") or ""
  self.land_lock = tonumber(row:getValue("land_lock")) or 0
  self.showCondition = tonumber(row:getValue("show_condition")) or 0
  self.plot_type = row:getValue("plot_type") or ""
  self.pawn_show = tonumber(row:getValue("pawn_show")) or 2
  self.name = row:getValue("name") or ""
  self.desc = row:getValue("desc") or ""
  self.icon = row:getValue("icon") or ""
  self.image = row:getValue("image") or ""
  self.reward_show = row:getValue("reward_show") or ""
  self.variantPatch = row:getValue("type_para2") or ""
  local playerGoCameraFollow = row:getValue("type_para3") or ""
  self.chapter_quest_condition = row:getValue("chapter_quest_condition") or 0
  if string.IsNullOrEmpty(playerGoCameraFollow) or tonumber(playerGoCameraFollow) ~= 1 then
    self.playerGoCameraFollow = true
  else
    self.playerGoCameraFollow = false
  end
  self.pawn_unrotate = row:getValue("pawn_unrotate") or 0
  self.building_condition = row:getValue("building_condition") or ""
  local stage = row:getValue("rank_stage_id")
  if not string.IsNullOrEmpty(stage) then
    self.rankStageId = tonumber(stage)
  end
  self.lock_module_key = row:getValue("lock_module_key")
  self.lock_module_tips_key = row:getValue("lock_module_tips_key")
  self.hasLockModule = not string.IsNullOrEmpty(self.lock_module_key)
  self.tryHeroes = row:getValue("hero_try") or {}
  self.base_land_type = tonumber(row:getValue("base_land_type")) or 1
  self.event_plot_id = row:getValue("event_plot_id") or {}
  self.event_display_id = row:getValue("event_display_id") or 0
  self.soldier_num = tonumber(row:getValue("soldier_num")) or 0
  local soldier_lan_array = row:getValue("soldier_lan_num")
  if soldier_lan_array and 0 < #soldier_lan_array then
    self.soldier_lan_num = {}
    for i = 1, #soldier_lan_array do
      self.soldier_lan_num[soldier_lan_array[i]] = true
    end
  end
  self.bornEffect = row:getValue("effect") or ""
  local time_condition_array = row:getValue("time_condition") or {}
  if type(time_condition_array) == "string" then
    time_condition_array = string.split(time_condition_array or "", ";")
  end
  if time_condition_array and 1 < #time_condition_array then
    self.openSeasonId = tonumber(time_condition_array[1])
    self.openSeasonPassDay = tonumber(time_condition_array[2])
  else
    self.openSeasonId = 0
    self.openSeasonPassDay = 0
  end
  local skipIdStr = row:getValue("skip_id")
  if not string.IsNullOrEmpty(skipIdStr) then
    self.skip_id = tonumber(skipIdStr)
  end
  local initInvisible = row:getValue("init_invisible")
  if not string.IsNullOrEmpty(initInvisible) then
    self.initInvisible = tonumber(initInvisible) == 1
  else
    self.initInvisible = false
  end
  local event_Info = row:getValue("event_info") or {}
  if type(event_Info) == "string" then
    event_Info = string.split(event_Info or "", "|")
  end
  if 1 < #event_Info then
    self.headPath = event_Info[1]
    self.textKey = event_Info[2]
  end
  self.event_reward_show = row:getValue("event_reward_show")
  self.stage_feature_building_id = tonumber(row:getValue("stage_feature_building_id")) or 0
  self.show_condition_param = tonumber(row:getValue("show_condition_param")) or 0
  self.soundId = row:getValue("sound_id") or 0
  self.sound_id_born = row:getValue("sound_id_born") or 0
  self.quest_order = row:getValue("quest_order")
  self.top_effect_path = row:getValue("top_effect_path")
end

return MonopolyPlacealityTemplate
