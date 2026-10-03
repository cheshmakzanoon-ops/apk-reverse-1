local LWSeasonTowerGroupTemplate = BaseClass("LWSeasonTowerGroupTemplate")

function LWSeasonTowerGroupTemplate:__init()
  self.id = 0
  self.inner_sever = ""
  self.online_sever = ""
  self.season = 0
  self.open_week = 0
  self.score_reward_id = ""
  self.rank_id = 0
  self.user_buff = ""
  self.user_buff_pool = ""
  self.user_buff_icon = ""
  self.all_buff = ""
  self.all_buff_icon = ""
  self.end_time = 0
  self.scoreRewardList = {}
  self.card_buff_desc = ""
  self.cardBuffs = {}
  self.core_reward = ""
  self.preheatReward = {}
  self.preheatTitle = {}
  self.season_tower_bgm = 0
  self.cardBuffEffectPathList = {}
end

function LWSeasonTowerGroupTemplate:__delete()
  self.id = 0
  self.inner_sever = 0
  self.online_sever = 0
  self.season = 0
  self.open_week = 0
  self.score_reward = 0
  self.rank_id = 0
  self.user_buff = 0
  self.user_buff_pool = ""
  self.user_buff_icon = ""
  self.all_buff = ""
  self.all_buff_icon = ""
  self.end_time = 0
  self.scoreRewardList = {}
  self.card_buff_desc = ""
  self.cardBuffs = {}
  self.core_reward = ""
  self.preheatReward = {}
  self.preheatTitle = {}
  self.season_tower_bgm = 0
  self.cardBuffEffectPathList = {}
  self.cardBuffDescNumList = {}
end

function LWSeasonTowerGroupTemplate:InitData(groupId)
  local rowData = LocalController:instance():getLine(TableName.SEASON_TOWER_GROUP, groupId)
  if not rowData then
    Logger.LogError("LWSeasonTowerGroupTemplate:InitData rowData is nil, groupId: " .. groupId)
    return
  end
  self.id = rowData.id
  self.inner_sever = rowData.inner_sever
  self.online_sever = rowData.online_sever
  self.season = rowData.season
  self.open_week = rowData.open_week
  self.rank_id = rowData.rank_id
  self.user_buff = rowData.user_buff
  self.user_buff_pool = rowData.user_buff_pool
  self.user_buff_icon = rowData.user_buff_icon
  self.all_buff = rowData.all_buff
  self.all_buff_icon = rowData.all_buff_icon
  self.end_time = rowData.end_time
  self.card_buff_desc = rowData.card_buff_desc
  self.core_reward = rowData.core_reward
  self.season_tower_bgm = rowData.season_tower_bgm
  if string.IsNullOrEmpty(rowData.preheat_reward) then
    self.preheatReward = {}
  else
    self.preheatReward = string.split(rowData.preheat_reward, "|")
  end
  if string.IsNullOrEmpty(rowData.preheat_title) then
    self.preheatTitle = {}
  else
    self.preheatTitle = string.split(rowData.preheat_title, "|")
  end
  self.scoreRewardList = {}
  if not string.IsNullOrEmpty(rowData.score_reward) then
    local rewards = string.string2array_num(rowData.score_reward, ";", "|")
    for _, v in pairs(rewards) do
      if #v == 3 then
        table.insert(self.scoreRewardList, {
          score = tonumber(v[1]),
          rewardId = v[2],
          titleId = tostring(v[3])
        })
      end
    end
  end
  self.cardBuffDescNumList = {}
  if not string.IsNullOrEmpty(rowData.card_buff_desc_num) then
    self.cardBuffDescNumList = string.string2array_s(rowData.card_buff_desc_num, ";", "|")
  end
  self.cardBuffs = {}
  if not string.IsNullOrEmpty(rowData.card_buff_desc) then
    local tab = string.string2array_s(rowData.card_buff_desc, ";", "|")
    for i, v in pairs(tab) do
      if #v == 2 then
        table.insert(self.cardBuffs, {
          level = tonumber(v[1]),
          name = v[2],
          param = self.cardBuffDescNumList[i] or {}
        })
      end
    end
    table.sort(self.cardBuffs, function(a, b)
      return a.level < b.level
    end)
  end
  self.cardBuffEffectPathList = {}
  if not string.IsNullOrEmpty(rowData.card_buff_desc_ux) then
    local tab = string.string2array_s(rowData.card_buff_desc_ux, ";", "|")
    for i, v in pairs(tab) do
      if #v == 3 then
        table.insert(self.cardBuffEffectPathList, {
          start = tonumber(v[1]),
          finish = tonumber(v[2]),
          path = v[3]
        })
      end
    end
  end
end

function LWSeasonTowerGroupTemplate:GetPreviewRewardList()
  local list = {}
  for _, v in ipairs(self.preheatTitle) do
    local titleCell = LocalController:instance():tryGetLine(TableName.LW_TITLE, v)
    if titleCell ~= nil then
      table.insert(list, {
        rewardType = RewardType.RESOURCE_ITEM,
        itemId = titleCell.connect_resource_item
      })
    end
  end
  for _, v in ipairs(self.preheatReward) do
    table.insert(list, {
      rewardType = RewardType.GOODS,
      itemId = v
    })
  end
  return list
end

return LWSeasonTowerGroupTemplate
