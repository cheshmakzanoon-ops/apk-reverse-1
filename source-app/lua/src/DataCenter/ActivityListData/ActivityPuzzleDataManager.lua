local ActivityPuzzleDataManager = BaseClass("ActivityPuzzleDataManager")
local Localization = CS.GameEntry.Localization
local ActivityPuzzleData = require("DataCenter.ActivityListData.ActivityPuzzleData")
local ActBossData = require("DataCenter.ActBossDataManager.ActBossData")
local ActBossRankDataList = require("DataCenter.ActBossDataManager.ActBossRankDataList")
local Setting = CS.GameEntry.Setting

function ActivityPuzzleDataManager:__init()
  self.info = nil
  self.activityName = nil
  self.bossRankList = {}
  self.bossRewardList = {}
end

function ActivityPuzzleDataManager:__delete()
  self.info = nil
  self.activityName = nil
  self.bossRankList = nil
  self.bossRewardList = nil
end

function ActivityPuzzleDataManager:SendMessageGetInfo(activityId)
  SFSNetwork.SendMessage(MsgDefines.GetPuzzleActivityInfo, activityId)
end

function ActivityPuzzleDataManager:SendMessageGetTaskReward()
  SFSNetwork.SendMessage(MsgDefines.ReceivePuzzleTaskReward)
end

function ActivityPuzzleDataManager:SendMessageGetPuzzleReward()
  SFSNetwork.SendMessage(MsgDefines.ReceivePuzzleReward)
end

function ActivityPuzzleDataManager:SendCreatePuzzleBoss(monsterId)
  SFSNetwork.SendMessage(MsgDefines.CreatePuzzleBoss, monsterId)
end

function ActivityPuzzleDataManager:SendGetPuzzleBossMarch()
  SFSNetwork.SendMessage(MsgDefines.GetPuzzleBossMarch)
end

function ActivityPuzzleDataManager:SendUserGetPuzzleBossRank(uuid)
  SFSNetwork.SendMessage(MsgDefines.UserGetPuzzleBossRank, uuid)
end

function ActivityPuzzleDataManager:SendGetPuzzleBossRankRewardInfo(uuid)
  SFSNetwork.SendMessage(MsgDefines.GetPuzzleBossRankRewardInfo, uuid)
end

function ActivityPuzzleDataManager:HandleMessageCreatePuzzleBoss(message)
  local errorCode = message.errorCode
  if errorCode ~= nil and errorCode ~= SeverErrorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  self:UpdateInfo(message)
  GoToUtil.CloseAllWindows()
  GoToUtil.MoveToWorldPointAndOpen(message.monsterPointId, nil, message.monsterUuid, LuaEntry.Player:GetSelfServerId())
end

function ActivityPuzzleDataManager:HandleMessageGetPuzzleBossMarch(message)
  local errorCode = message.errorCode
  if errorCode ~= nil and errorCode ~= SeverErrorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  self.puzzleMarches = {}
  if message.marches ~= nil then
    local arr = message.marches
    for k, v in pairs(arr) do
      if v ~= nil then
        local oneData = ActBossData.New()
        oneData:ParseData(v)
        if oneData.uuid ~= 0 then
          self.puzzleMarches[oneData.uuid] = oneData
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.OnPuzzleMonsterDataRefresh)
end

function ActivityPuzzleDataManager:GetPuzzleMarches()
  return self.puzzleMarches
end

function ActivityPuzzleDataManager:HandleMessageUserGetPuzzleBossRank(message)
  local errorCode = message.errorCode
  if errorCode ~= nil and errorCode ~= SeverErrorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  local oneData = ActBossRankDataList.New()
  oneData:ParseData(message)
  if oneData.uuid ~= 0 then
    self.bossRankList[oneData.uuid] = oneData
  end
  EventManager:GetInstance():Broadcast(EventId.OnPuzzleMonsterRankRefresh)
end

function ActivityPuzzleDataManager:GetBossRankDataByUuid(uuid)
  return self.bossRankList[uuid]
end

function ActivityPuzzleDataManager:HandleMessageGetPuzzleBossRankRewardInfo(message)
  local errorCode = message.errorCode
  if errorCode ~= nil and errorCode ~= SeverErrorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  
  local function GetRewardList(rewardList)
    local reward = {}
    table.walk(rewardList, function(_, v)
      local item = {}
      item.count = v.count
      item.itemId = v.itemId
      item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
      item.rewardType = v.rewardType
      local desc = DataCenter.RewardManager:GetDescByType(v.rewardType, v.itemId)
      local name = DataCenter.RewardManager:GetNameByType(v.rewardType, v.itemId)
      item.itemName = name
      item.itemDesc = desc
      item.isLocal = true
      if v.rewardType == RewardType.GOODS then
        if v.itemId ~= nil then
          local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
          if goods ~= nil then
            local join_method = -1
            local icon_join
            if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
              join_method = goods.join_method
              icon_join = goods.icon_join
            end
            if 0 < join_method and icon_join ~= nil and icon_join ~= "" then
              local tempJoin = string.split(icon_join, ";")
              if 1 < #tempJoin then
                item.itemColor = tempJoin[2]
              end
              if 2 < #tempJoin then
                item.iconName = tempJoin[3]
              end
            else
              item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
              local itemType = goods.type
              if itemType == 2 then
                if goods.para1 ~= nil and goods.para1 ~= "" then
                  local para1 = goods.para1
                  local temp = string.split(para1, ";")
                  if temp ~= nil and 1 < #temp then
                    item.itemFlag = temp[1] .. temp[2]
                  end
                end
              elseif itemType == 3 then
                local type2 = goods.type2
                if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                  local res_num = tonumber(goods.para)
                  item.itemFlag = string.GetFormattedStr(res_num)
                end
              end
              item.iconName = string.format(LoadPath.ItemPath, goods.icon)
            end
          end
        end
      elseif v.rewardType == RewardType.GOLD then
        item.iconName = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
        item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
      elseif v.rewardType == RewardType.OIL or v.rewardType == RewardType.METAL or v.rewardType == RewardType.FORMATION_STAMINA or v.rewardType == RewardType.WATER or v.rewardType == RewardType.PVE_POINT or v.rewardType == RewardType.DETECT_EVENT or v.rewardType == RewardType.FOOD or v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OBSIDIAN or v.rewardType == RewardType.ELECTRICITY then
        item.iconName = DataCenter.RewardManager:GetPicByType(v.rewardType)
        item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
      elseif v.rewardType == RewardType.RESOURCE_ITEM then
        local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v.itemId)
        if template ~= nil then
          item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
          item.iconName = template:GetIconPath()
        end
      end
      table.insert(reward, item)
    end)
    return reward
  end
  
  self.bossReward = {}
  local title1 = {}
  title1.title = 372247
  table.insert(self.bossReward, title1)
  if message.callReward then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(message.callReward)
    local reward = GetRewardList(rewardList)
    local oneData = {}
    oneData.rewardStr = reward
    oneData.createrName = message.userName or ""
    table.insert(self.bossReward, oneData)
  end
  local title2 = {}
  title2.title = 372248
  table.insert(self.bossReward, title2)
  if message.partakeReward ~= nil then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(message.partakeReward)
    local reward = GetRewardList(rewardList)
    local oneData = {}
    oneData.rewardStr = reward
    oneData.attacked = message.attacked or 0
    table.insert(self.bossReward, oneData)
  end
  local title3 = {}
  title3.title = 372249
  table.insert(self.bossReward, title3)
  if message.rankRewardArr ~= nil then
    table.walk(message.rankRewardArr, function(_, v)
      local startRank = v.start
      local endRank = v["end"]
      local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
      local reward = GetRewardList(rewardList)
      local oneData = {}
      oneData.rankStr = startRank .. "-" .. endRank
      oneData.rewardStr = reward
      table.insert(self.bossReward, oneData)
    end)
  end
  EventManager:GetInstance():Broadcast(EventId.OnPuzzleMonsterRankRefresh)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityPuzzleDataManager:GetBossRankReward(uuid)
  return self.bossReward
end

function ActivityPuzzleDataManager:ResetBossRankReward(uuid)
  self.bossReward = nil
end

function ActivityPuzzleDataManager:HandleMessageGetInfo(message)
  local errorCode = message.errorCode
  if errorCode ~= nil and errorCode ~= SeverErrorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  self:UpdateInfo(message)
end

function ActivityPuzzleDataManager:HandleMessageGetTaskReward(message)
  local errorCode = message.errorCode
  if errorCode ~= nil and errorCode ~= SeverErrorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  self:UpdateInfo(message)
end

function ActivityPuzzleDataManager:HandleMessageGetPuzzleReward(message)
  local errorCode = message.errorCode
  if errorCode ~= nil and errorCode ~= SeverErrorCode then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  self:UpdateInfo(message)
end

function ActivityPuzzleDataManager:HandlePushPuzzleTaskFinish(message)
  if self.info ~= nil then
    self.info:UpdateCurrentTaskState(message)
  end
  EventManager:GetInstance():Broadcast(EventId.PuzzleDataUpdate)
  EventManager:GetInstance():Broadcast(EventId.PuzzleTaskUpdate)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityPuzzleDataManager:UpdateInfo(info)
  if self.info == nil then
    self.info = ActivityPuzzleData.New()
  end
  self.info:ParseData(info)
  EventManager:GetInstance():Broadcast(EventId.PuzzleDataUpdate)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActivityPuzzleDataManager:GetPuzzleData()
  return self.info
end

function ActivityPuzzleDataManager:GetRedDotNum()
  if self.info ~= nil then
    return self.info:GetUnReceivedRewardNum()
  end
  return 0
end

function ActivityPuzzleDataManager:GetActivityPanelName(activityId)
  if self.activityName == nil then
    local activityLine = LocalController:instance():getLine(TableName.ActivityPanel, activityId)
    local activityName = Localization:GetString(activityLine.name)
    self.activityName = activityName
  end
  return self.activityName
end

function ActivityPuzzleDataManager:CanCreatePuzzleBoss()
  if self.info == nil then
    return false
  end
  return self.info:CanCreatePuzzleBoss()
end

function ActivityPuzzleDataManager:IsBossUnlock(bossId)
  if self.info == nil then
    return false, 0, 0
  end
  local monster = DataCenter.ActivityPuzzleMonsterTemplateManager:GetTemplate(bossId)
  if monster == nil then
    return false, 0, 0
  end
  local needDmg = monster.unlock
  local dmgRate = self.info.dmgRateArr[bossId - 1] or 0
  return needDmg <= dmgRate, needDmg, dmgRate
end

function ActivityPuzzleDataManager:SaveBossUnlockAnimationPlay(bossId)
  local settingStr = "PuzzleMonsterOpenEffectShow_" .. LuaEntry.Player.uid .. "__" .. bossId
  Setting:SetString(settingStr, "1")
end

function ActivityPuzzleDataManager:GetBossUnlockAnimationPlay(bossId)
  local settingStr = "PuzzleMonsterOpenEffectShow_" .. LuaEntry.Player.uid .. "__" .. bossId
  local str = Setting:GetString(settingStr, "")
  return not string.IsNullOrEmpty(str)
end

function ActivityPuzzleDataManager:SaveBossRewardRedDot(bossId, time)
  local settingStr = "BossRewardRedDot_" .. LuaEntry.Player.uid .. "__" .. bossId .. "_" .. time
  Setting:SetString(settingStr, "1")
end

function ActivityPuzzleDataManager:GetBossRewardRedDot(bossId, time)
  local settingStr = "BossRewardRedDot_" .. LuaEntry.Player.uid .. "__" .. bossId .. "_" .. time
  local str = Setting:GetString(settingStr, "")
  return string.IsNullOrEmpty(str)
end

return ActivityPuzzleDataManager
