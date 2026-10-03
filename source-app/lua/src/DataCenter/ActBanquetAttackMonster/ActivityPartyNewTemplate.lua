local ActivityPartyNewTemplate = BaseClass("ActivityPartyNewTemplate")

local function __init(self)
  self.id = 0
  self.activity = 0
  self.cost_item = {}
  self.unit_num = 0
  self.cost_item2 = {}
  self.unit_num2 = 0
  self.add_score1 = 0
  self.add_score2 = 0
  self.add_score3 = 0
  self.add_score4 = 0
  self.monster_order = {}
  self.mode_2_times = 0
  self.option_init = 0
  self.level_max = 0
  self.level_dic = {}
  self.show_building = 0
  self.open_dic = {}
  self.rank_reward_show = nil
  self.rank_reward_show_list = {}
  self.rank_minscore = 0
  self.rank_minscore_alliance = 0
  self.rank_banner_show = 0
  self.score_pic = ""
  self.add_score1 = {}
  self.add_score2 = {}
  self.add_score3 = 0
  self.add_score4 = 0
  self.special_damage = {}
  self.is_show_convert = nil
  self.convert_btn = nil
  self.is_show_task = nil
  self.drop_show = nil
  self.support_isopen = nil
  self.is_show_treasure = nil
  self.treasure_btn_pic = nil
  self.scene = ""
  self.attackSpeed_type = nil
  self.attackBox_type = nil
  self.treasure_para = nil
  self.treasure_id = nil
  self.rank_actid = nil
  self.dropBoxType = nil
  self.treasure_btn_name = nil
end

local function __delete(self)
  self.id = nil
  self.activity = nil
  self.cost_item = nil
  self.unit_num = nil
  self.cost_item2 = nil
  self.unit_num2 = nil
  self.add_score1 = nil
  self.add_score2 = nil
  self.add_score3 = nil
  self.add_score4 = nil
  self.monster_order = nil
  self.mode_2_times = nil
  self.option_init = nil
  self.level_max = nil
  self.level_dic = nil
  self.show_building = nil
  self.open_dic = nil
  self.rank_reward_show = nil
  self.rank_reward_show_list = nil
  self.rank_minscore = nil
  self.rank_minscore_alliance = nil
  self.rank_banner_show = nil
  self.score_pic = nil
  self.add_score1 = nil
  self.add_score2 = nil
  self.add_score3 = nil
  self.add_score4 = nil
  self.special_damage = nil
  self.is_show_convert = nil
  self.convert_btn = nil
  self.is_show_task = nil
  self.drop_show = nil
  self.support_isopen = nil
  self.is_show_treasure = nil
  self.treasure_btn_pic = nil
  self.scene = nil
  self.attackSpeed_type = nil
  self.attackBox_type = nil
  self.treasure_para = nil
  self.treasure_id = nil
  self.rank_actid = nil
  self.dropBoxType = nil
  self.treasure_btn_name = nil
end

local function ParseData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id") or 0
  self.activity = row:getValue("activity") or 0
  local cost_item = row:getValue("cost_item") or ""
  if not string.IsNullOrEmpty(cost_item) then
    local strList = string.string2array_i_oneSep(cost_item, ";")
    self.cost_item = strList
  end
  self.unit_num = row:getValue("unit_num") or 0
  local cost_item2 = row:getValue("cost_item2") or ""
  if not string.IsNullOrEmpty(cost_item2) then
    local strList = string.string2array_i_oneSep(cost_item2, ";")
    self.cost_item2 = strList
  end
  self.unit_num2 = row:getValue("unit_num2") or 0
  self.add_score1 = row:getValue("add_score1") or 0
  self.add_score2 = row:getValue("add_score2") or 0
  self.add_score3 = row:getValue("add_score3") or 0
  self.add_score4 = row:getValue("add_score4") or 0
  local monster_order = row:getValue("monster_order") or ""
  if not string.IsNullOrEmpty(monster_order) then
    local strList = string.string2array_i_oneSep(monster_order, "|")
    self.monster_order = strList
  end
  self.mode_2_times = row:getValue("mode_2_times") or 0
  self.option_init = row:getValue("option_init") or 0
  self.level_max = row:getValue("leve_max") or 0
  self.show_building = row:getValue("show_building") or 0
  local level = row:getValue("level") or ""
  self.level_dic = {}
  if not string.IsNullOrEmpty(level) then
    local levelList = string.split(level, "|")
    for k, v in ipairs(levelList) do
      local strList = string.split(v, ";")
      if 2 <= #strList then
        self.level_dic[tonumber(strList[1])] = tonumber(strList[2])
      end
    end
  end
  local add_goods = row:getValue("add_goods") or ""
  if not string.IsNullOrEmpty(add_goods) then
    local str = string.split(add_goods, ";")
    if 3 <= #str then
      self.add_good_id = tonumber(str[2])
      self.add_good_num = tonumber(str[3])
    end
  end
  local level_unlock = row:getValue("level_unlock") or ""
  if not string.IsNullOrEmpty(level_unlock) then
    local str1 = string.split(level_unlock, ";")
    for k, v in ipairs(str1) do
      local str2 = string.split(v, "|")
      if 2 <= #str2 then
        self.open_dic[tonumber(str2[1])] = tonumber(str2[2])
      end
    end
  end
  self.rank_reward_show = row:getValue("rank_reward_show") or ""
  self.rank_reward_show_list = {}
  if not string.IsNullOrEmpty(self.rank_reward_show) then
    local strData = string.string2array_i(self.rank_reward_show, ";", "|")
    for _, v in ipairs(strData) do
      if #v == 3 then
        local rewardData = {
          rewardType = v[1],
          itemId = v[2],
          count = v[3]
        }
        table.insert(self.rank_reward_show_list, rewardData)
      end
    end
  end
  self.rank_minscore = tonumber(row:getValue("rank_minscore") or 0)
  self.rank_minscore_alliance = tonumber(row:getValue("rank_minscore_alliance") or 0)
  self.rank_banner_show = row:getValue("rank_banner_show")
  self.score_pic = row:getValue("score_pic")
  local add_score1 = row:getValue("add_score1") or ""
  self.add_score1 = string.split(add_score1, "|")
  local add_score2 = row:getValue("add_score2") or ""
  self.add_score2 = string.split(add_score2, "|")
  self.add_score3 = tonumber(row:getValue("add_score3") or 0)
  self.add_score4 = tonumber(row:getValue("add_score4") or 0)
  local special_damage = row:getValue("special_damage")
  if not string.IsNullOrEmpty(special_damage) then
    self.special_damage = string.string2array_i(special_damage, ";", "|")
  end
  self.is_show_convert = row:getValue("is_show_convert") or 0
  self.convert_btn = row:getValue("convert_btn") or ""
  self.is_show_task = row:getValue("is_show_task") or ""
  self.drop_show = row:getValue("drop_show") or 0
  self.support_isopen = row:getValue("support_isopen") or 0
  local is_show_treasure = row:getValue("is_show_treasure") or 0
  self.is_show_treasure = is_show_treasure == 1
  self.treasure_btn_pic = row:getValue("treasure_btn_pic") or ""
  self.scene = row:getValue("scene") or ""
  local speedType = row:getValue("attackspeed_type")
  self.attackSpeed_type = speedType == 0 and 1 or speedType
  local attackBoxType = row:getValue("attackbox_type")
  self.attackBox_type = attackBoxType == 0 and 1 or attackBoxType
  self.treasure_para = row:getValue("treasure_para") or ""
  self.treasure_id = row:getValue("treasure_id") or ""
  self.rank_actid = row:getValue("rank_actid") or ""
  local dropbox_type = row:getValue("dropbox_type")
  self.dropBoxType = dropbox_type and tonumber(dropbox_type) or 0
  self.treasure_btn_name = row:getValue("treasure_btn_name") or ""
end

ActivityPartyNewTemplate.__init = __init
ActivityPartyNewTemplate.__delete = __delete
ActivityPartyNewTemplate.ParseData = ParseData
return ActivityPartyNewTemplate
