local LWZombieRushTemplate = BaseClass("LWZombieRushTemplate")

function LWZombieRushTemplate:__init()
  self.id = 0
  self.type = 0
  self.difficulty = 0
  self.target_lv = 0
  self.target_lv_range = ""
  self.power = 0
  self.unlock_condition = ""
  self.unlockConditionList = nil
  self.reward_alliance = ""
  self.reward_personal = ""
  self.alliance_res_build = 0
  self.monster_config = {}
  self.eliteBoss_show = ""
  self.eliteBoss_reward_show = ""
  self.eliteBoss_alter_reward_banner = ""
  self.eliteBgPic = nil
  self.eliteBoss_target = ""
  self.alter_rate = ""
end

function LWZombieRushTemplate:__delete()
  self.id = nil
  self.type = nil
  self.difficulty = nil
  self.target_lv = nil
  self.power = nil
  self.unlock_condition = nil
  self.reward_alliance = nil
  self.reward_personal = nil
  self.target_lv_range = nil
  self.alliance_res_build = nil
  self.unlockConditionList = nil
  self.monster_config = nil
  self.eliteBoss_show = nil
  self.eliteBoss_reward_show = nil
  self.eliteBoss_alter_reward_banner = nil
  self.eliteBgPic = nil
  self.eliteBoss_target = nil
  self.alter_rate = nil
end

function LWZombieRushTemplate:Init(row)
  self.id = row:getValue("id") or 0
  self.type = row:getValue("type") or 0
  self.difficulty = row:getValue("difficulty") or 0
  self.target_lv = row:getValue("target_lv") or 0
  self.power = row:getValue("power") or 0
  self.target_lv_range = row:getValue("target_lv_range") or ""
  self.unlock_condition = row:getValue("unlock_condition") or ""
  self.reward_alliance = row:getValue("reward_alliance") or 0
  self.reward_personal = row:getValue("reward_personal") or 0
  self.alliance_res_build = row:getValue("alliance_res_build") or 0
  self.monster_config = row:getValue("monster_config") or {}
  self.eliteBoss_show = row:getValue("eliteBoss_show") or ""
  self.eliteBoss_reward_show = row:getValue("eliteBoss_reward_show") or ""
  self.eliteBoss_alter_reward_banner = row:getValue("eliteBoss_alter_reward_banner") or ""
  self.eliteBoss_target = row:getValue("eliteBoss_target") or ""
  self.alter_rate = row:getValue("alter_rate") or ""
end

function LWZombieRushTemplate:GetUnlockConditionList()
  if self.unlock_condition == "" then
    return {}
  end
  if self.unlockConditionList == nil then
    self.unlockConditionList = {}
    local array = string.split(self.unlock_condition, "|")
    for i = 1, table.count(array) do
      local str = array[i]
      local strArray = string.split(str, ";")
      if table.count(strArray) > 0 then
        local oneData = {}
        oneData.conditionType = tonumber(strArray[1])
        oneData.conditionParam = {}
        for j = 2, table.count(strArray) do
          oneData.conditionParam[j - 1] = tonumber(strArray[j])
        end
        table.insert(self.unlockConditionList, oneData)
      end
    end
  end
  return self.unlockConditionList
end

function LWZombieRushTemplate:GetMaxRoundValue()
  return table.count(self.monster_config)
end

local function GetCurSeasonEliteBgPic(self)
  if self.eliteBgPic == nil then
    local pic
    local eliteBoss_alter_reward_banner = self.eliteBoss_alter_reward_banner
    if not string.IsNullOrEmpty(eliteBoss_alter_reward_banner) then
      local season = DataCenter.SeasonDataManager:GetSeason()
      local arr = string.split(eliteBoss_alter_reward_banner, "|")
      local defaultPic
      for _, v in ipairs(arr) do
        if not string.IsNullOrEmpty(v) then
          local v_arr = string.split(v, ";")
          if v_arr and #v_arr == 2 then
            local v_season = tonumber(v_arr[1])
            if v_season == season then
              pic = v_arr[2]
              break
            end
            if v_season == 0 then
              defaultPic = v_arr[2]
            end
          end
        end
      end
      if pic == nil then
        pic = defaultPic
      end
      self.eliteBgPic = pic
    end
  end
  return self.eliteBgPic
end

LWZombieRushTemplate.GetCurSeasonEliteBgPic = GetCurSeasonEliteBgPic
return LWZombieRushTemplate
