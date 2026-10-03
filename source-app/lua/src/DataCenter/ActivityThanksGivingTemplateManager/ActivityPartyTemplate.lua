local ActivityPartyTemplate = BaseClass("ActivityPartyTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.activity = 0
  self.donate_item_id = 0
  self.unit_num = 0
  self.add_score = 0
  self.contribution = 0
  self.add_good_id = 0
  self.add_good_num = 0
  self.level_max = 0
  self.level_dic = {}
  self.show_building = 0
  self.open_dic = {}
  self.rank_reward_show = nil
  self.rank_reward_show_list = {}
  self.rank_minscore = 0
  self.rank_minscore_alliance = 0
  self.rank_banner_show = ""
  self.score_pic = ""
  self.extra_desc1 = ""
  self.rank_underdesc = ""
  self.concert_entrance = 0
  self.concert_entrance_name = ""
  self.concert_entrance_icon = ""
  self.concert_entrance_prefab = ""
end

local function __delete(self)
  self.id = nil
  self.activity = nil
  self.donate_item_id = nil
  self.unit_num = nil
  self.add_score = nil
  self.contribution = nil
  self.add_good_id = nil
  self.add_good_num = nil
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
  self.extra_desc1 = nil
  self.rank_underdesc = nil
  self.concert_entrance = nil
  self.concert_entrance_name = nil
  self.concert_entrance_icon = nil
  self.concert_entrance_prefab = nil
end

local function ParseData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id") or 0
  self.activity = row:getValue("activity") or 0
  local cost_item = row:getValue("cost_item") or ""
  if not string.IsNullOrEmpty(cost_item) then
    local strList = string.split(cost_item, ";")
    if 2 <= #strList then
      self.donate_item_id = tonumber(strList[2])
    end
  end
  self.unit_num = row:getValue("unit_num") or 0
  self.add_score = row:getValue("add_score") or 0
  self.contribution = row:getValue("contribution") or 0
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
  self.extra_desc1 = row:getValue("extra_desc1")
  self.rank_underdesc = row:getValue("rank_underdesc")
  self.concert_entrance = row:getValue("concert_entrance") or 0
  self.concert_entrance_name = row:getValue("concert_entrance_name") or ""
  self.concert_entrance_icon = row:getValue("concert_entrance_icon") or ""
  self.concert_entrance_prefab = row:getValue("concert_entrance_prefab") or ""
end

ActivityPartyTemplate.__init = __init
ActivityPartyTemplate.__delete = __delete
ActivityPartyTemplate.ParseData = ParseData
return ActivityPartyTemplate
