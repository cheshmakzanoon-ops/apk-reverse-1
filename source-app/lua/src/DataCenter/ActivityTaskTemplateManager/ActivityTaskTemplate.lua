local ActivityTaskTemplate = BaseClass("ActivityTaskTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.name = ""
  self.desc = ""
  self.gotype2 = QuestGoType.None
  self.gopara = {}
  self.desctype = QuestDescType.Normal
  self.para1 = ""
  self.para2 = 0
  self.para3 = 0
  self.order = 0
  self.icon = ""
  self.tableinfo_type = 0
  self.type2 = 0
  self.reward = 0
  self.group = ""
  self.freeReward = ""
  self.payReward = ""
  self.team = ""
  self.slots_icon = ""
  self.score = 0
  self.pre_id = 0
  self.cycle_group = 0
  self.daily_refresh = 0
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.desc = nil
  self.gotype2 = nil
  self.gopara = nil
  self.desctype = nil
  self.para1 = nil
  self.para2 = nil
  self.para3 = nil
  self.order = nil
  self.icon = nil
  self.tableinfo_type = nil
  self.type2 = nil
  self.reward = nil
  self.group = nil
  self.freeReward = nil
  self.payReward = nil
  self.team = nil
  self.slots_icon = nil
  self.score = nil
  self.pre_id = nil
  self.cycle_group = nil
  self.daily_refresh = nil
  self.overflow = 0
  self.overflow_value = 0
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name", "")
  self.desc = row:getValue("desc", "")
  self.gotype2 = row:getValue("gotype2")
  self.gopara = row:getValue("gopara")
  self.desctype = row:getValue("desctype")
  self.para1 = row:getValue("para1")
  self.para2 = row:getValue("para2")
  self.para3 = row:getValue("para3")
  self.type = row:getValue("type")
  self.order = row:getValue("order")
  self.icon = row:getValue("icon", "")
  self.icon_full_path = row:getValue("icon_new", "")
  self.tableinfo_type = row:getValue("tableinfo_type")
  self.type2 = row:getValue("type2")
  self.reward = row:getValue("reward")
  self.group = row:getValue("group") or ""
  self.team = row:getValue("team") or ""
  self.slots_icon = row:getValue("slots_icon") or ""
  self.score = tonumber(row:getValue("score"))
  self.pre_id = tonumber(row:getValue("pre_id")) or 0
  self.cycle_group = tonumber(row:getValue("cycle_group")) or 0
  self.daily_refresh = tonumber(row:getValue("daily_refresh")) or 0
  self.overflow = tonumber(row:getValue("overflow")) or 0
  self.overflow_value = tonumber(row:getValue("overflow_value")) or 0
  self.raw_reward_para = row:getValue("reward_para") or ""
end

local function getter_freeReward(self)
  if not string.IsNullOrEmpty(self.raw_reward_para) then
    local rewardList = string.split(self.raw_reward_para, ";")
    if not string.IsNullOrEmpty(rewardList[1]) then
      self.freeReward = LocalController:instance():getLine(TableName.RewardConfig, tonumber(rewardList[1]))
    end
    return self.freeReward
  end
  return nil
end

local function getter_payReward(self)
  if not string.IsNullOrEmpty(self.raw_reward_para) then
    local rewardList = string.split(self.raw_reward_para, ";")
    if not string.IsNullOrEmpty(rewardList[2]) then
      self.payReward = LocalController:instance():getLine(TableName.RewardConfig, tonumber(rewardList[2]))
    end
    return self.payReward
  end
  return nil
end

local function GetDesc(self, isChatView)
  return QuestUtil.GetQuestDesc(self, isChatView)
end

local function GetTargetNum(self)
  return QuestUtil.GetTargetNum(self)
end

local InvalidTaskTypeInCrossServer = {
  31,
  92,
  89,
  63,
  212,
  330,
  352,
  359,
  378
}

local function IsGotoValidInCrossServer(self)
  for i, v in pairs(InvalidTaskTypeInCrossServer) do
    if self.type2 == v then
      return false
    end
  end
  return true
end

function ActivityTaskTemplate:GetIconPath()
  if string.IsNullOrEmpty(self.icon_full_path) then
    return UIUtil.GetFullPath(LoadPath.UITask, self.icon)
  end
  return self.icon_full_path
end

function ActivityTaskTemplate:GetRewardShowData()
  local res = {}
  local rewardConfig = LocalController:instance():getLine(TableName.RewardConfig, tonumber(self.reward))
  if rewardConfig ~= nil then
    local itemValues = rewardConfig:getValue("item") or ""
    local numValues = rewardConfig:getValue("num") or ""
    if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
      local ids = string.split(itemValues, "|")
      local nums = string.split(numValues, "|")
      if ids ~= nil and 0 < #ids then
        for i, id in pairs(ids) do
          local oneData = {}
          oneData.itemId = id
          oneData.count = nums[i] or 0
          oneData.rewardType = RewardType.GOODS
          table.insert(res, oneData)
        end
      end
    end
  end
  return res
end

ActivityTaskTemplate.__init = __init
ActivityTaskTemplate.__delete = __delete
ActivityTaskTemplate.InitData = InitData
ActivityTaskTemplate.GetDesc = GetDesc
ActivityTaskTemplate.GetTargetNum = GetTargetNum
ActivityTaskTemplate.IsGotoValidInCrossServer = IsGotoValidInCrossServer
ActivityTaskTemplate.getters.freeReward = getter_freeReward
ActivityTaskTemplate.getters.payReward = getter_payReward
return ActivityTaskTemplate
