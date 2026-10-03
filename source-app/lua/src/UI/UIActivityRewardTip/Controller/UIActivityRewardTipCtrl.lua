local UIActivityRewardTipCtrl = BaseClass("UIActivityRewardTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityRewardTip, {anim = true})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetRewardListByType(self, activityType, index, activityId)
  local showList = {}
  if activityType == EnumActivity.ActMeteorite.Type then
    local boxesConfig = DataCenter.ActMeteoriteBattleManager:GetRewardBoxes(1)
    local config = boxesConfig[index]
    local rewardList = RewardUtil.GetRewardsById(config ~= nil and config.reward or nil, true)
    table.walk(rewardList, function(_, v)
      local param = self:GetRewardParam(v)
      table.insert(showList, param)
    end)
  elseif activityType == EnumActivity.ActLandlord.Type then
    local boxesConfig = DataCenter.LandlordMgr:GetNieBoxConfig()
    local config = boxesConfig[index]
    local rewardList = RewardUtil.GetRewardsById(config ~= nil and config.reward or nil, true)
    table.walk(rewardList, function(_, v)
      local param = self:GetRewardParam(v)
      table.insert(showList, param)
    end)
  elseif activityType == EnumActivity.ActWinterStorm.Type then
    local boxesConfig = DataCenter.ActWinterStormManager:GetRewardTemplates()
    local config = boxesConfig[index]
    local rewardList = RewardUtil.GetRewardsById(config ~= nil and config.rewardId or nil, true)
    table.walk(rewardList, function(_, v)
      local param = self:GetRewardParam(v)
      table.insert(showList, param)
    end)
  elseif activityType == ActivityEventType.PERSONAL then
    local eventInfo = DataCenter.ActPersonalArmsInfo:GetEventInfo(activityId)
    if eventInfo ~= nil then
      local targetReward = eventInfo.targetReward
      if targetReward ~= nil then
        table.walk(targetReward[index], function(k, v)
          local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
          if goods ~= nil then
            local oneData = {}
            oneData.iconName = string.format(LoadPath.ItemPath, goods.icon)
            oneData.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
            oneData.count = v.count
            oneData.name = DataCenter.ItemTemplateManager:GetName(v.itemId)
            oneData.itemId = v.itemId
            oneData.type = goods.type
            oneData.para2 = goods.para2
            if goods.type == 2 then
              if goods.para1 ~= nil and goods.para1 ~= "" then
                local para1 = goods.para1
                local temp = string.split(para1, ";")
                if temp ~= nil and 1 < #temp then
                  oneData.itemFlag = temp[1] .. temp[2]
                end
              end
            elseif goods.type == 3 then
              local type2 = goods.type2
              if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                local res_num = tonumber(goods.para)
                oneData.itemFlag = string.GetFormattedStr(res_num)
              end
            end
            table.insert(showList, oneData)
          end
        end)
        if eventInfo.heroEventPoint and eventInfo.heroEventPoint ~= "" then
          local str = string.split(eventInfo.heroEventPoint, "|")
          local param = {}
          param.name = Localization:GetString("321081")
          param.heroEventPoint = true
          param.iconName = string.format(LoadPath.ItemPath, "icon_medal")
          param.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.ORANGE)
          for i, v in pairs(eventInfo.rewardScoreIndexArr) do
            if v == index then
              param.count = str[i] and str[i] or 1
              break
            end
          end
          table.insert(showList, 1, param)
        end
      end
    end
  elseif activityType == EnumActivity.AllianceCompete.EventType then
    local tempActivityData = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    local eventInfo = tempActivityData:GetEventInfo()
    if eventInfo ~= nil then
      local targetReward = eventInfo.targetReward
      if targetReward ~= nil then
        table.walk(targetReward[index], function(k, v)
          if v.rewardType == RewardType.RESOURCE_ITEM then
            local oneData = {}
            oneData.iconName = DataCenter.RewardManager:GetPicByType(tonumber(v.rewardType), tonumber(v.itemId))
            oneData.itemColor = DataCenter.RewardManager:GetRewardQualityBg(tonumber(v.rewardType), tonumber(v.itemId))
            oneData.count = v.count
            oneData.name = DataCenter.RewardManager:GetNameByType(tonumber(v.rewardType), tonumber(v.itemId))
            oneData.itemId = v.itemId
            oneData.rewardType = v.rewardType
            table.insert(showList, oneData)
          else
            local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
            if goods ~= nil then
              local oneData = {}
              oneData.iconName = string.format(LoadPath.ItemPath, goods.icon)
              oneData.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
              oneData.count = v.count
              oneData.name = DataCenter.ItemTemplateManager:GetName(v.itemId)
              oneData.itemId = v.itemId
              oneData.type = goods.type
              oneData.para2 = goods.para2
              if goods.type == 2 then
                if goods.para1 ~= nil and goods.para1 ~= "" then
                  local para1 = goods.para1
                  local temp = string.split(para1, ";")
                  if temp ~= nil and 1 < #temp then
                    oneData.itemFlag = temp[1] .. temp[2]
                  end
                end
              elseif goods.type == 3 then
                local type2 = goods.type2
                if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                  local res_num = tonumber(goods.para)
                  oneData.itemFlag = string.GetFormattedStr(res_num)
                end
              end
              table.insert(showList, oneData)
            end
          end
        end)
      end
    end
  elseif activityType == -1 then
    self.championBattleInfo = DataCenter.ActChampionBattleManager:GetChampionBattleInfo()
    local boxReward = self.championBattleInfo.rewardBoxList[index]
    if boxReward ~= nil and boxReward.reward ~= nil then
      local reward = DataCenter.RewardManager:ReturnRewardParamForView(boxReward.reward)
      for k1, v1 in pairs(reward) do
        local param = self:GetRewardParam(v1)
        table.insert(showList, param)
      end
    end
  elseif activityType == -2 then
    local allReward = DataCenter.HeroMonthCardManager:GetAllReward(activityId)
    if allReward ~= nil and table.count(allReward) > 0 then
      for k1, v1 in pairs(allReward) do
        local param = self:GetRewardParam(v1)
        table.insert(showList, param)
      end
      table.sort(showList, function(a, b)
        return a.rank > b.rank
      end)
    end
  elseif activityType == -3 then
    local data = DataCenter.EarthOrderDataManager:GetOneEarthOrder()
    if data ~= nil and data.addReward ~= nil and 0 < table.count(data.addReward) then
      local reward = DataCenter.RewardManager:ReturnRewardParamForView(data.addReward)
      for k1, v1 in pairs(reward) do
        local param = self:GetRewardParam(v1)
        table.insert(showList, param)
      end
      table.sort(showList, function(a, b)
        return a.rank > b.rank
      end)
    end
  elseif activityType == -4 then
    local id = tonumber(activityId)
    local data = DataCenter.KeepPayManager:GetData(id)
    if data then
      local stage = data.stages[index]
      if stage then
        for _, v in ipairs(stage.rewards) do
          local param = self:GetRewardParam(v)
          table.insert(showList, param)
        end
      end
    end
  elseif activityType == EnumActivity.TurntableActivity.Type then
    local actData = DataCenter.ActLuckyRollInfo:GetInfoByActId(tonumber(activityId))
    local reward = actData.stageArr[index].reward
    for k1, v1 in pairs(reward) do
      local param = self:GetRewardParam(v1)
      table.insert(showList, param)
    end
  elseif activityType == EnumActivity.JungleTrial.Type then
    local reward = DataCenter.JungleTrialDataManager:GetBoxReward() or {}
    for k1, v1 in pairs(reward) do
      local param = self:GetRewardParam({
        rewardType = v1.type,
        itemId = v1.value.id,
        count = v1.value.num
      })
      table.insert(showList, param)
    end
  elseif activityType == EnumActivity.BattlePass.Type then
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(activityId))
    local reward = DataCenter.RewardManager:StrRewardHandle(actListData.reward_goods, true)
    for k1, v1 in pairs(reward) do
      local param = {}
      param.itemId = v1.itemId
      param.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
      if goods ~= nil then
        param.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
        param.type = goods.type
        param.para2 = goods.para2
        param.iconName = string.format(LoadPath.ItemPath, goods.icon)
        param.name = DataCenter.ItemTemplateManager:GetName(param.itemId)
      end
      param.count = v1.count
      table.insert(showList, param)
    end
  elseif activityType == EnumActivity.SeasonPreview.Type then
    local rewards = DataCenter.SeasonPreviewManager:GetBoxDisplayRewardList(index)
    local reward = DataCenter.RewardManager:ReturnRewardParamForView(rewards)
    for k1, v1 in pairs(reward) do
      local param = self:GetRewardParam(v1)
      table.insert(showList, param)
    end
  elseif activityType == EnumActivity.SeasonPass.Type then
    local passInfo = DataCenter.SeasonPassManager:GetSeasonPassInfo(activityId)
    local rewards = DataCenter.RewardManager:ReturnRewardParamForView(passInfo.extraRewardList)
    for k1, v1 in pairs(rewards) do
      local param = self:GetRewardParam(v1)
      table.insert(showList, param)
    end
  elseif activityType == EnumActivity.HeroGrowth.Type then
    local rewards = DataCenter.HeroGrowthActivityManager:GetBoxDisplayRewardList(activityId, index)
    for k1, v1 in pairs(rewards) do
      local param = self:GetRewardParam(v1)
      table.insert(showList, param)
    end
  elseif activityType == nil then
    local list = DataCenter.DailyTaskManager:GetBoxRewardShow(index)
    if list then
      for k1, v1 in pairs(list) do
        local param = self:GetRewardParam(v1)
        table.insert(showList, param)
      end
    end
  end
  return showList
end

local function GetRewardParam(self, reward)
  local param = {}
  param.rewardType = reward.rewardType
  param.itemId = reward.itemId
  if param.rewardType == RewardType.RESOURCE then
    local tmpType = ResTypeToReward[tonumber(param.itemId)]
    if tmpType ~= nil then
      param.rewardType = tmpType
    end
  end
  param.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
  param.rank = ItemColor.WHITE
  param.name = DataCenter.RewardManager:GetNameByType(param.rewardType, param.itemId)
  param.iconName = DataCenter.RewardManager:GetPicByType(param.rewardType, param.itemId)
  if param.rewardType == RewardType.GOODS then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
    if goods ~= nil then
      param.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
      param.type = goods.type
      param.para2 = goods.para2
      param.rank = goods.color
    end
  elseif reward.rewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(param.itemId)
    if template ~= nil then
      param.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(template.quality)
    end
  elseif reward.rewardType == RewardType.RESOURCE then
    param.itemColor = DataCenter.RewardManager:GetRewardQualityBg(tonumber(reward.rewardType), tonumber(param.itemId))
  elseif RewardToResType[param.rewardType] ~= nil then
    param.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
  end
  param.count = reward.count
  return param
end

local function GetRewardByType(self, activityType)
  if activityType == 29 then
    SFSNetwork.SendMessage(MsgDefines.SurvivalBigBox)
  end
  self:CloseSelf()
end

UIActivityRewardTipCtrl.CloseSelf = CloseSelf
UIActivityRewardTipCtrl.Close = Close
UIActivityRewardTipCtrl.GetRewardListByType = GetRewardListByType
UIActivityRewardTipCtrl.GetRewardByType = GetRewardByType
UIActivityRewardTipCtrl.GetRewardParam = GetRewardParam
return UIActivityRewardTipCtrl
