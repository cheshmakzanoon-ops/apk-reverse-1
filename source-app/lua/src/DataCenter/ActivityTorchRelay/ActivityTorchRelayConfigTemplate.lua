local ActivityTorchRelayConfigTemplate = BaseClass("ActivityTorchRelayConfigTemplate")
local TorchRelayBattleStageConfigTemplate = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Config/TorchRelayBattleStageConfigTemplate")

function ActivityTorchRelayConfigTemplate:__init()
  self.id = 0
  self.exchange_id = 0
  self.rule_description = ""
  self.game_item = ""
  self.settlement_stage = 0
  self.offline_mail = ""
  self.guaranteed_meter = 0
  self.game_stage_id = 0
  self.game_distance_score = ""
  self.game_distance_reward = ""
  self.game_distance_reward_show = ""
  self.draw_box_id = 0
  self.daily_task = 0
  self.game_task = 0
  self.game_task_reward_show = ""
  self.grow_up_id = 0
  self.cheer_num_max = 0
  self.game_cheer_num = 0
  self.cheer_other_num = 0
  self.cheer_other_reward = 0
  self.world_cd_time = 0
  self.alliance_cd_time = 0
  self.private_cd_time = 0
  self.rare_cheer_reward = ""
  self.rare_cheer_reward_num = 0
  self.rank_minscore = 0
  self.rank_reward_show = ""
  self.rank_reward = ""
  self.rank_mail = 0
  self.rank_personal_winner_mail = ""
  self.rank_minscore_alliance = 0
  self.rank_reward_alliance = ""
  self.rank_mail_alliance = 0
  self.rank_alliance_winner_mail = ""
  self.allianceTopRankMail = 0
  self.playerTopRankMail = 0
  self.playerNoRankMail = 0
  self.allianceNoRankMail = 0
  self.rank_banner_show = 0
  self.thumbs_up_reward = 0
  self.thumbs_up_reward_limit = 0
  self.distance_score_id = 0
  self.free_iap_reward = 0
  self.game_task_score = ""
  self.getmore_title = ""
end

function ActivityTorchRelayConfigTemplate:__delete()
  self.id = nil
  self.rule_description = nil
  self.game_item = nil
  self.settlement_stage = nil
  self.offline_mail = nil
  self.guaranteed_meter = nil
  self.game_stage_id = nil
  self.game_distance_score = nil
  self.game_distance_reward = nil
  self.game_distance_reward_show = nil
  self.draw_box_id = nil
  self.daily_task = nil
  self.game_task = nil
  self.game_task_reward_show = nil
  self.grow_up_id = nil
  self.cheer_num_max = nil
  self.game_cheer_num = nil
  self.cheer_other_num = nil
  self.cheer_other_reward = nil
  self.world_cd_time = nil
  self.alliance_cd_time = nil
  self.private_cd_time = nil
  self.rare_cheer_reward = nil
  self.rare_cheer_reward_num = nil
  self.rank_minscore = nil
  self.rank_reward_show = nil
  self.rank_reward = nil
  self.rank_mail = nil
  self.rank_personal_winner_mail = nil
  self.rank_minscore_alliance = nil
  self.rank_reward_alliance = nil
  self.rank_mail_alliance = nil
  self.rank_alliance_winner_mail = nil
  self.allianceTopRankMail = nil
  self.playerTopRankMail = nil
  self.playerNoRankMail = nil
  self.allianceNoRankMail = nil
  self.rank_banner_show = nil
  self.thumbs_up_reward = nil
  self.thumbs_up_reward_limit = nil
  self.distance_score_id = nil
  self.exchange_id = nil
  self.free_iap_reward = nil
  self.game_task_score = nil
  self.skill_pic = nil
  self.main_skillbanner = nil
  self.main_bubble = nil
  self.main_title = nil
  self.main_team = nil
  self.task_banner = nil
  self.rank_banner = nil
  self.main_backbanner = nil
  self.getmore_title = nil
end

function ActivityTorchRelayConfigTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.rule_description = row:getValue("rule_description") or ""
  self.game_item = row:getValue("game_item") or ""
  self.settlement_stage = tonumber(row:getValue("settlement_stage")) or 0
  self.offline_mail = row:getValue("offline_mail") or ""
  self.guaranteed_meter = tonumber(row:getValue("guaranteed_meter")) or 0
  self.game_stage_id = tonumber(row:getValue("game_stage_id")) or 0
  self.game_distance_score = row:getValue("game_distance_score") or ""
  self.game_distance_reward = row:getValue("game_distance_reward") or ""
  self.game_distance_reward_show = row:getValue("game_distance_reward_show") or ""
  self.draw_box_id = tonumber(row:getValue("draw_box_id")) or 0
  self.daily_task = tonumber(row:getValue("daily_task")) or 0
  self.game_task = tonumber(row:getValue("game_task")) or 0
  self.game_task_reward_show = row:getValue("game_task_reward_show") or ""
  self.grow_up_id = tonumber(row:getValue("grow_up_id")) or 0
  self.cheer_num_max = tonumber(row:getValue("cheer_num_max")) or 0
  self.game_cheer_num = tonumber(row:getValue("game_cheer_num")) or 0
  self.cheer_other_num = tonumber(row:getValue("cheer_other_num")) or 0
  self.cheer_other_reward = tonumber(row:getValue("cheer_other_reward")) or 0
  self.world_cd_time = tonumber(row:getValue("world_cd_time")) or 0
  self.alliance_cd_time = tonumber(row:getValue("alliance_cd_time")) or 0
  self.private_cd_time = tonumber(row:getValue("private_cd_time")) or 0
  self.rare_cheer_reward = row:getValue("rare_cheer_reward") or ""
  self.rare_cheer_reward_num = tonumber(row:getValue("rare_cheer_reward_num")) or 0
  self.rank_minscore = tonumber(row:getValue("rank_minscore")) or 0
  self.rank_reward_show = row:getValue("rank_reward_show") or ""
  self.rank_reward = row:getValue("rank_reward") or ""
  self.rank_mail = tonumber(row:getValue("rank_mail")) or 0
  self.rank_personal_winner_mail = row:getValue("rank_personal_winner_mail") or ""
  self.rank_minscore_alliance = tonumber(row:getValue("rank_minscore_alliance")) or 0
  self.rank_reward_alliance = row:getValue("rank_reward_alliance") or ""
  self.rank_mail_alliance = tonumber(row:getValue("rank_mail_alliance")) or 0
  self.rank_alliance_winner_mail = row:getValue("rank_alliance_winner_mail") or ""
  self.allianceTopRankMail = tonumber(row:getValue("allianceTopRankMail")) or 0
  self.playerTopRankMail = tonumber(row:getValue("playerTopRankMail")) or 0
  self.playerNoRankMail = tonumber(row:getValue("playerNoRankMail")) or 0
  self.allianceNoRankMail = tonumber(row:getValue("allianceNoRankMail")) or 0
  self.rank_banner_show = tonumber(row:getValue("rank_banner_show")) or 0
  self.thumbs_up_reward = tonumber(row:getValue("thumbs_up_reward")) or 0
  self.thumbs_up_reward_limit = tonumber(row:getValue("thumbs_up_reward_limit")) or 0
  self.distance_score_id = tonumber(row:getValue("distance_score_id")) or 0
  self.exchange_id = tonumber(row:getValue("exchange_id")) or 0
  self.free_iap_reward = tonumber(row:getValue("free_iap_reward")) or 0
  self.task_daily = row:getValue("task_daily")
  self.task_game = row:getValue("task_game")
  self.cheer_other_reward_show = row:getValue("cheer_other_reward_show")
  self.game_task_score = row:getValue("game_task_score")
  self.skill_pic = row:getValue("skill_pic")
  self.main_skillbanner = row:getValue("main_skillbanner")
  self.main_bubble = row:getValue("main_bubble")
  self.main_title = row:getValue("main_title")
  self.main_team = row:getValue("main_team")
  self.task_banner = row:getValue("task_banner")
  self.rank_banner = row:getValue("rank_banner")
  self.main_backbanner = row:getValue("main_backbanner")
  self.getmore_title = row:getValue("getmore_title")
end

function ActivityTorchRelayConfigTemplate:GetStageConfigTemplate()
  if self.gameStageConfigTemplate == nil and self.game_stage_id > 0 then
    local lineData = LocalController:instance():getLine(TableName.Activity_Torch_Relay_Stage, tonumber(self.game_stage_id))
    if lineData then
      local template = TorchRelayBattleStageConfigTemplate.New()
      template:InitData(lineData)
      self.gameStageConfigTemplate = template
    end
  end
  return self.gameStageConfigTemplate
end

function ActivityTorchRelayConfigTemplate:GetGameCost()
  if not string.IsNullOrEmpty(self.game_item) then
    local strSplited = string.split(self.game_item, ";")
    if #strSplited == 2 then
      return tonumber(strSplited[1]), tonumber(strSplited[2])
    end
  end
end

function ActivityTorchRelayConfigTemplate:GetShowRankReward()
  local res = {}
  if not string.IsNullOrEmpty(self.rank_reward_show) then
    local strSplited = string.split(self.rank_reward_show, "|")
    for i, v in pairs(strSplited) do
      local strSplited2 = string.split(v, ";")
      if #strSplited2 == 3 then
        local data = {
          rewardType = tonumber(strSplited2[1]),
          itemId = tonumber(strSplited2[2]),
          count = tonumber(strSplited2[3])
        }
        table.insert(res, data)
      end
    end
  end
  return res
end

function ActivityTorchRelayConfigTemplate:GetShowDrawReward()
  if self.draw_box_id > 0 then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.draw_box_id)
    if itemTemplate and itemTemplate.type == GOODS_TYPE.GOODS_TYPE_DRAW_BOX then
      local groupId = itemTemplate.para1
      local data = DataCenter.BoxItemDrawManager:GetUserData(groupId)
      if data then
        local curTemplate = data:GetTemplate(data:GetCurRound())
        if curTemplate then
          return curTemplate:GetBigRewardShowData()
        end
      end
    end
  end
end

function ActivityTorchRelayConfigTemplate:GetMilestonesPointList()
  if self.milestonesPointList then
    return self.milestonesPointList
  end
  if string.IsNullOrEmpty(self.game_task_reward_show) then
    Logger.LogError("game_task_reward_show is nil")
    return
  end
  self.milestonesPointList = {}
  local strSplited = string.split(self.game_task_reward_show, "|")
  for i, v in pairs(strSplited) do
    local strSplited2 = string.split(v, ",")
    if #strSplited2 == 2 then
      local point = {
        progress = tonumber(strSplited2[1]),
        reward = DataCenter.RewardManager:ParseOneRewardStr(strSplited2[2])
      }
      table.insert(self.milestonesPointList, point)
    end
  end
  return self.milestonesPointList
end

function ActivityTorchRelayConfigTemplate:GetFreeGiftRewards()
  local res = {}
  if self.free_iap_reward > 0 then
    local line = LocalController:instance():getLine(TableName.RewardConfig, self.free_iap_reward)
    if line ~= nil then
      local MyStrNull = string.IsNullOrEmpty
      local MySplit = string.split
      local MyInsert = table.insert
      local itemValues = line:getValue("item") or ""
      local numValues = line:getValue("num") or ""
      if not MyStrNull(itemValues) and not MyStrNull(numValues) then
        local ids = MySplit(itemValues, "|")
        local nums = MySplit(numValues, "|")
        if ids ~= nil and 0 < #ids then
          for i, id in pairs(ids) do
            local oneData = {}
            oneData.itemId = id
            oneData.count = nums[i] or 0
            oneData.rewardType = RewardType.GOODS
            MyInsert(res, oneData)
          end
        end
      end
      local itemValuesRes = line:getValue("resource_randomtype") or ""
      local numValuesRes = line:getValue("resource_rate") or ""
      if not MyStrNull(itemValuesRes) and not MyStrNull(numValuesRes) then
        local idsRes = MySplit(itemValuesRes, "|")
        local numsRes = MySplit(numValuesRes, "|")
        if idsRes ~= nil and 0 < #idsRes then
          for i, id in pairs(idsRes) do
            local oneData = {}
            oneData.itemId = id
            local numss = MySplit(numsRes[i], ";")
            oneData.count = numss[1] or 0
            oneData.rewardType = RewardType.RESOURCE
            MyInsert(res, oneData)
          end
        end
      end
    end
  end
  return res
end

function ActivityTorchRelayConfigTemplate:GetDailyTaskIdList()
  local taskIdList = {}
  if string.IsNullOrEmpty(self.task_daily) then
    return taskIdList
  end
  local strSplited = string.split(self.task_daily, ";")
  for i, v in ipairs(strSplited) do
    if not string.IsNullOrEmpty(v) then
      table.insert(taskIdList, tonumber(v))
    end
  end
  return taskIdList
end

function ActivityTorchRelayConfigTemplate:GetMilesTaskIdList()
  local taskIdList = {}
  if string.IsNullOrEmpty(self.task_game) then
    return taskIdList
  end
  local strSplited = string.split(self.task_game, ";")
  for i, v in ipairs(strSplited) do
    if not string.IsNullOrEmpty(v) then
      table.insert(taskIdList, tonumber(v))
    end
  end
  return taskIdList
end

function ActivityTorchRelayConfigTemplate:GetPersonalReward()
  local res = {}
  if not string.IsNullOrEmpty(self.rank_reward) then
    local str1 = string.split(self.rank_reward, "|")
    for _, v in pairs(str1) do
      local str2 = string.split(v, ";")
      if #str2 == 2 then
        local str3 = string.split(str2[1], "-")
        if #str3 == 2 then
          local data = {
            startN = tonumber(str3[1]),
            endN = tonumber(str3[2]),
            reward = tonumber(str2[2])
          }
          table.insert(res, data)
        end
      end
    end
  end
  return res
end

function ActivityTorchRelayConfigTemplate:GetAllianceReward()
  local res = {}
  if not string.IsNullOrEmpty(self.rank_reward_alliance) then
    local str1 = string.split(self.rank_reward_alliance, "|")
    for _, v in pairs(str1) do
      local str2 = string.split(v, ";")
      if #str2 == 2 then
        local str3 = string.split(str2[1], "-")
        if #str3 == 2 then
          local data = {
            startN = tonumber(str3[1]),
            endN = tonumber(str3[2]),
            reward = tonumber(str2[2])
          }
          table.insert(res, data)
        end
      end
    end
  end
  return res
end

function ActivityTorchRelayConfigTemplate:GetInGameMileStoneRewardDict()
  local res = {}
  if not string.IsNullOrEmpty(self.game_distance_reward_show) then
    local str1 = string.split(self.game_distance_reward_show, "|")
    local start = 0
    for _, v in pairs(str1) do
      local str2 = string.split(v, ";")
      if #str2 == 4 then
        local data = {
          startScore = start,
          endScore = tonumber(str2[1]),
          rewardId = tonumber(str2[2]),
          rewardType = tonumber(str2[3]),
          count = tonumber(str2[4])
        }
        table.insert(res, data)
        start = data.endScore
      end
    end
  end
  table.sort(res, function(a, b)
    return a.startScore < b.startScore
  end)
  return res
end

function ActivityTorchRelayConfigTemplate:GetGameSkillPic(index)
  if self.skill_pic then
    return self.skill_pic[index]
  end
  return nil
end

function ActivityTorchRelayConfigTemplate:GetGameSkillPicBg()
  return self.main_skillbanner
end

function ActivityTorchRelayConfigTemplate:GetGameSkillIcon(index)
  if self.main_bubble then
    return self.main_bubble[index]
  end
  return nil
end

function ActivityTorchRelayConfigTemplate:GetGameSkillTitleBg()
  return self.main_title[1]
end

function ActivityTorchRelayConfigTemplate:GetGameTeamTitleBg()
  return self.main_title[2]
end

function ActivityTorchRelayConfigTemplate:GetGameTeamMemberBg()
  return self.main_team
end

function ActivityTorchRelayConfigTemplate:GetTaskBanner()
  return self.task_banner
end

function ActivityTorchRelayConfigTemplate:GetRankBannerBg()
  return self.rank_banner[1]
end

function ActivityTorchRelayConfigTemplate:GetRankBannerBorder()
  return self.rank_banner[2]
end

function ActivityTorchRelayConfigTemplate:GetGameMainBg()
  return self.main_backbanner
end

return ActivityTorchRelayConfigTemplate
