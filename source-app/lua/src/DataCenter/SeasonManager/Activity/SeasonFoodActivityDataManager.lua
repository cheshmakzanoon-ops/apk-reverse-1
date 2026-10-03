local SeasonFoodActivityDataManager = BaseClass("SeasonFoodActivityDataManager")
local Localization = CS.GameEntry.Localization
local SeasonFoodMenuData = require("DataCenter.SeasonManager.Activity.SeasonFoodMenuData")

function SeasonFoodActivityDataManager:__init()
  self.init = false
  self.seasonFoodMenuMapByGroup = {}
  self.seasonFoodMenuMapById = {}
  self.seasonFoodActivityData = {}
end

function SeasonFoodActivityDataManager:__delete()
end

function SeasonFoodActivityDataManager:Init()
  if not self.init then
    LocalController:instance():visitTable(TableName.SeasonFoodMenu, function(id, lineData)
      local template = SeasonFoodMenuData.New()
      template:SetData(lineData)
      local dataList = self.seasonFoodMenuMapByGroup[template.group]
      if dataList == nil then
        dataList = {}
        self.seasonFoodMenuMapByGroup[template.group] = dataList
      end
      dataList[template.id] = template
      self.seasonFoodMenuMapById[template.id] = template
    end)
    self.init = true
  end
end

function SeasonFoodActivityDataManager:GetSeasonFoodMenuTemplateData(id)
  self:Init()
  return self.seasonFoodMenuMapById[id]
end

function SeasonFoodActivityDataManager:UpdateSeasonFoodData(message, flag)
  local activityId = message.act_id
  local data = self.seasonFoodActivityData[activityId]
  if data == nil then
    data = {}
    self.seasonFoodActivityData[activityId] = data
  end
  data.time = message.time
  data.menuId = message.menuId
  data.num = message.num
  if message.reward_prefect then
    data.reward_prefect = message.reward_prefect
  end
  if message.reward_normal then
    data.reward_normal = message.reward_normal
  end
  if flag then
    EventManager:GetInstance():Broadcast(EventId.LWSasonFoodInfoUpdate)
  end
end

function SeasonFoodActivityDataManager:ResetSeasonFoodCookData()
  self.curCookSuccessData = nil
end

function SeasonFoodActivityDataManager:UpdateSeasonFoodCookData(message)
  if message.info then
    self:UpdateSeasonFoodData(message.info, false)
  end
  self.curCookSuccessData = {}
  self.curCookSuccessData.matched = message.matched
  self.curCookSuccessData.food = message.food
  self.curCookSuccessData.reward = message.reward
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  EventManager:GetInstance():Broadcast(EventId.LWSasonCookFoodSuccess)
end

function SeasonFoodActivityDataManager:GetSeasonFoodData(activityId)
  return self.seasonFoodActivityData[toInt(activityId)]
end

return SeasonFoodActivityDataManager
