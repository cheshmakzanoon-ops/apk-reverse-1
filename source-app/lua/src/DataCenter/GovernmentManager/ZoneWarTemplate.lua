local ZoneWarTemplate = BaseClass("ZoneWarTemplate")
local Localization = CS.GameEntry.Localization

function ZoneWarTemplate:__init()
  self.id = 0
  self.name = ""
  self.desc = ""
  self.week_tile = {}
  self.open_time = nil
  self.end_time = nil
  self.server_ids = nil
  self.last_server_ids = nil
  self.type = 4
  self.open_week = 2
  self.stage_points = nil
  self.stage_vs = 6
  self.wonder_war = nil
  self.win_reward = nil
  self.rank_reward = nil
  self.king_reward = nil
  self.guild_reward = nil
  self.medal_reward = nil
  self.rank_reward_faction_win = nil
  self.rank_reward_faction_lose = nil
  self.faction_a_icon = nil
  self.faction_b_icon = nil
  self.faction_a_name = nil
  self.faction_b_name = nil
  self.faction_a_desc = nil
  self.faction_b_desc = nil
end

function ZoneWarTemplate:__delete()
end

function ZoneWarTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getIntValue("id", 0)
  self.type = row:getIntValue("type", 0)
  self.name = row:getValue("name") or "801407"
  self.desc = row:getValue("desc") or "801419"
  self.new_pic = row:getValue("new_pic")
  self.new_desc = row:getValue("new_desc")
  self.wonder_war = toInt(row:getValue("wonder_war"))
  self.week_tile = {}
  local week_tile = row:getValue("weekl_tile")
  if week_tile then
    for item in string.gmatch(week_tile, "([^|]+)|?") do
      table.insert(self.week_tile, item)
    end
  end
  self.server_ids = {}
  local server_ids = row:getValue("server_ids")
  if server_ids and type(server_ids) == "string" then
    for server_group in string.gmatch(server_ids, "([^|]+)|?") do
      for serverId in string.gmatch(server_group, "([^;]+);?") do
        self.server_ids[toInt(serverId)] = true
      end
    end
  end
  self.rank_reward_faction_win = row:getValue("rank_reward_faction_win")
  self.rank_reward_faction_lose = row:getValue("rank_reward_faction_lose")
  self.faction_a_icon = row:getValue("faction_a_icon")
  self.faction_b_icon = row:getValue("faction_b_icon")
  self.faction_a_name = row:getValue("faction_a_name")
  self.faction_b_name = row:getValue("faction_b_name")
  self.faction_a_desc = row:getValue("faction_a_desc")
  self.faction_b_desc = row:getValue("faction_b_desc")
end

function ZoneWarTemplate:InitFromServerData(data, serverData)
  if data == nil then
    return
  end
  self.id = toInt(data.id)
  self.type = toInt(data.type)
  self.name = data.name or "801407"
  self.desc = data.desc or "801419"
  self.new_pic = data.new_pic
  self.new_desc = data.new_desc
  self.wonder_war = toInt(data.wonder_war or 0)
  self.week_tile = {}
  self.server_ids = {}
  if data.server_ids then
    for item in string.gmatch(data.server_ids, "([^|]+)|?") do
      for server_id in string.gmatch(item, "([^;]+);?") do
        self.server_ids[toInt(server_id)] = true
      end
    end
  elseif serverData and serverData.initServerGroup and serverData.initServerGroup.group then
    if serverData.initServerGroup.group.a then
      for _, server_id in ipairs(serverData.initServerGroup.group.a) do
        self.server_ids[toInt(server_id)] = true
      end
    end
    if serverData.initServerGroup.group.b then
      for _, server_id in ipairs(serverData.initServerGroup.group.b) do
        self.server_ids[toInt(server_id)] = true
      end
    end
  end
  local week_tile = data.weekl_tile or "801442|801443"
  if week_tile then
    for item in string.gmatch(week_tile, "([^|]+)|?") do
      table.insert(self.week_tile, item)
    end
  end
  self.rank_reward_faction_win = data.rank_reward_faction_win
  self.rank_reward_faction_lose = data.rank_reward_faction_lose
  self.faction_a_icon = data.faction_a_icon
  self.faction_b_icon = data.faction_b_icon
  self.faction_a_name = data.faction_a_name
  self.faction_b_name = data.faction_b_name
  self.faction_a_desc = data.faction_a_desc
  self.faction_b_desc = data.faction_b_desc
end

function ZoneWarTemplate:IsBattleMember(server_id)
  return self.server_ids[toInt(server_id)] == true
end

function ZoneWarTemplate:GetWeekNum()
  return DataCenter.ZoneWarManager:GetWeekNum()
end

function ZoneWarTemplate:GetWeekText()
  if not self.week_tile then
    if self.type == ServerBattleType.VS4 then
      return "801442"
    end
    return "801444"
  end
  local weekIndex = DataCenter.ZoneWarManager:GetWeekNum()
  if self.type == ServerBattleType.VS4 then
    return self.week_tile[weekIndex] or "801442"
  end
  if self.type == ServerBattleType.VS8 then
    return self.week_tile[weekIndex] or "801444"
  end
  if self.type == ServerBattleType.VSCamp then
    return self.week_tile[weekIndex] or self.week_tile[1] or "801444"
  end
  return "801442"
end

function ZoneWarTemplate:GetStartTime()
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule then
    return configSchedule.startTime
  end
  return UITimeManager:GetInstance():GetServerTime() - 8650000
end

function ZoneWarTemplate:GetEndTime()
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule then
    return configSchedule.endTime
  end
  return UITimeManager:GetInstance():GetServerTime() + 8650000
end

function ZoneWarTemplate:ShowActivityDesc()
  if not string.IsNullOrEmpty(self.desc) then
    local param = {}
    param.activityRulesStr = Localization:GetString(self.desc)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function ZoneWarTemplate:HasActivityNews()
  if string.IsNullOrEmpty(self.new_pic) or string.IsNullOrEmpty(self.new_desc) then
    return false
  end
  return true
end

function ZoneWarTemplate:ShowActivityNews(pos, animShow, animHide)
  if string.IsNullOrEmpty(self.new_pic) or string.IsNullOrEmpty(self.new_desc) then
    return
  end
  local param = {}
  local new_pic = string.split_ss_array(self.new_pic, "|")
  local new_desc = string.split_ss_array(self.new_desc, "|")
  param.pos = pos
  param.animShow = animShow
  param.animHide = animHide
  param.guideList = {}
  for k, v in ipairs(new_pic) do
    if v ~= nil and new_desc[k] ~= nil then
      table.insert(param.guideList, {
        img = v,
        txt = new_desc[k]
      })
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.ServerBattleCampDetail, {anim = true}, param)
end

return ZoneWarTemplate
