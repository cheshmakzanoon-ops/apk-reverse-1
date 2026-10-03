local RewardUtil = require("Util.RewardUtil")
local LwSeasonMilitaryLevelTemplate = BaseClass("LwSeasonMilitaryLevelTemplate")

function LwSeasonMilitaryLevelTemplate:GetCampId(serverId)
  if checknumber(serverId) == 0 then
    serverId = LuaEntry.Player:GetSourceServerId()
  end
  return Mathf.Clamp(checknumber(DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(serverId)), 1, 2)
end

function LwSeasonMilitaryLevelTemplate:GetIcon(serverId)
  local icons = string.string2table_is(self.icon, ";", "|")
  return table.TryGetValue(icons, self:GetCampId(serverId), "")
end

function LwSeasonMilitaryLevelTemplate:GetName(serverId)
  local names = string.string2table_is(self.name, ";", "|")
  return table.TryGetValue(names, self:GetCampId(serverId), "")
end

function LwSeasonMilitaryLevelTemplate:GetNameLoc(serverId)
  return CS.GameEntry.Localization:GetString(self:GetName(serverId))
end

function LwSeasonMilitaryLevelTemplate:GetStatus(serverId)
  local status = string.string2table_is(self.status, ";", "|")
  return table.TryGetValue(status, self:GetCampId(serverId), "")
end

function LwSeasonMilitaryLevelTemplate:GetLevelUpReward()
  local rewards = {}
  local campResIdsStr = string.string2table_is(self.title_show, ";", "|")
  local resIdsStr = table.TryGetValue(campResIdsStr, self:GetCampId(), "")
  if not string.IsNullOrEmpty(resIdsStr) then
    local ids = string.split(resIdsStr, "#")
    if not table.IsNullOrEmpty(ids) then
      for _, id in pairs(ids) do
        local reward = DataCenter.RewardManager:ParseOneReward(id, RewardType.RESOURCE_ITEM, 1)
        if reward ~= nil then
          table.insert(rewards, reward)
        end
      end
    end
  end
  return rewards
end

function LwSeasonMilitaryLevelTemplate:GetFinalRewards()
  local rewardsPairs = string.string2table_is(self.final_rewards, ";", "|")
  local rewardsId = checknumber(table.TryGetValue(rewardsPairs, self:GetCampId(), 0))
  local rewards = RewardUtil.GetRewardsById(rewardsId)
  return rewards
end

function LwSeasonMilitaryLevelTemplate:GetDescInfos()
  if table.IsNullOrEmpty(self.DescInfos) then
    self:GenerateDescInfos()
  end
  return self.DescInfos
end

function LwSeasonMilitaryLevelTemplate:GetDescInfo(index)
  if table.IsNullOrEmpty(self.DescInfos) then
    self:GenerateDescInfos()
  end
  return table.TryGetValue(self.DescInfos, index, nil)
end

function LwSeasonMilitaryLevelTemplate:GenerateDescInfos()
  self.DescInfos = {}
  local benefitPairs = string.split(self.effect_desc, ";")
  local params = string.split(self.effect_num, ";")
  for i = 1, table.count(benefitPairs) do
    local benefitStr = benefitPairs[i]
    local benefit = string.split(benefitStr, ",")
    if table.count(benefit) >= 2 then
      local key, fmt = benefit[1], checknumber(benefit[2])
      local param = table.TryGetValue(params, i, "")
      local info = {}
      info.DescKey = key
      info.Param = param
      info.ParamStr = self:GetFormatedParamByFmt(fmt, param)
      info.Format = fmt
      self.DescInfos[i] = info
    end
  end
end

function LwSeasonMilitaryLevelTemplate:GetFormatedParamByFmt(fmt, param)
  if fmt == 1 then
    return string.GetFormattedSeparatorNum(checknumber(param))
  elseif fmt == 2 then
    return string.format("%s%s", checknumber(param), "%")
  end
  return ""
end

function LwSeasonMilitaryLevelTemplate:GetFormatedParam(index, param)
  local descInfo = self:GetDescInfo(index)
  if descInfo ~= nil then
    return self:GetFormatedParamByFmt(descInfo.Format, param)
  end
  return ""
end

function LwSeasonMilitaryLevelTemplate:__init()
  self.id = 0
  self.group = ""
  self.level = ""
  self.level_group = ""
  self.status = ""
  self.effect_desc = ""
  self.effect_num = ""
  self.daily_salary = ""
  self.title = ""
  self.title_show = ""
  self.unlock_score = ""
  self.unlock_score_desc = ""
  self.unlock_condition_type = ""
  self.unlock_condition_para = ""
  self.unlock_condition_desc = ""
  self.standard_level = ""
  self.need_rank = ""
  self.rank_value = ""
  self.rank_desc = ""
  self.final_rewards = ""
  self.final_title = ""
  self.name = ""
  self.icon = ""
  self.DescInfos = {}
end

function LwSeasonMilitaryLevelTemplate:__delete()
  self.DescInfos = {}
  self.id = nil
  self.group = nil
  self.level = nil
  self.level_group = nil
  self.status = nil
  self.effect_desc = nil
  self.effect_num = nil
  self.daily_salary = nil
  self.title = nil
  self.title_show = nil
  self.unlock_score = nil
  self.unlock_score_desc = nil
  self.unlock_condition_type = nil
  self.unlock_condition_para = nil
  self.unlock_condition_desc = nil
  self.standard_level = nil
  self.need_rank = nil
  self.rank_value = nil
  self.rank_desc = nil
  self.final_rewards = nil
  self.final_title = nil
  self.name = nil
  self.icon = nil
end

function LwSeasonMilitaryLevelTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or ""
  self.level = rowData:getValue("level") or ""
  self.level_group = rowData:getValue("level_group") or ""
  self.status = rowData:getValue("status") or ""
  self.effect_desc = rowData:getValue("effect_desc") or ""
  self.effect_num = rowData:getValue("effect_num") or ""
  self.daily_salary = rowData:getValue("daily_salary") or ""
  self.title = rowData:getValue("title") or ""
  self.title_show = rowData:getValue("title_show") or ""
  self.unlock_score = rowData:getValue("unlock_score") or ""
  self.unlock_score_desc = rowData:getValue("unlock_score_desc") or ""
  self.unlock_condition_type = rowData:getValue("unlock_condition_type") or ""
  self.unlock_condition_para = rowData:getValue("unlock_condition_para") or ""
  self.unlock_condition_desc = rowData:getValue("unlock_condition_desc") or ""
  self.standard_level = rowData:getValue("standard_level") or ""
  self.need_rank = rowData:getValue("need_rank") or ""
  self.rank_value = rowData:getValue("rank_value") or ""
  self.rank_desc = rowData:getValue("rank_desc") or ""
  self.final_rewards = rowData:getValue("final_rewards") or ""
  self.final_title = rowData:getValue("final_title") or ""
  self.name = rowData:getValue("name") or ""
  self.icon = rowData:getValue("icon") or ""
end

return LwSeasonMilitaryLevelTemplate
