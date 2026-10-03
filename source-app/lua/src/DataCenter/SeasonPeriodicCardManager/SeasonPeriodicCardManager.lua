local SeasonPeriodicCardManager = BaseClass("SeasonPeriodicCardManager")
local periodicCardData = require("DataCenter.SeasonPeriodicCardManager.SeasonPeriodicCardData")

function SeasonPeriodicCardManager:__init()
  self.periodicCardData = {}
  self:AddListener()
end

function SeasonPeriodicCardManager:__delete()
  self.periodicCardData = nil
  self:RemoveListener()
end

function SeasonPeriodicCardManager:AddListener()
end

function SeasonPeriodicCardManager:RemoveListener()
end

function SeasonPeriodicCardManager:StartUp()
end

function SeasonPeriodicCardManager:InitInfo(message)
  self:UpdateInfo(message)
end

function SeasonPeriodicCardManager:UpdateInfo(message)
  local id = message.card_id
  if id then
    local needCheckBought = false
    local IsBoughtOld = false
    local tmpData = self.periodicCardData[id]
    if tmpData then
      needCheckBought = true
      IsBoughtOld = tmpData:IsBought()
    else
      tmpData = periodicCardData.New()
      self.periodicCardData[id] = tmpData
    end
    tmpData:ParseData(message)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonWeekCardInfoUpdate, id)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonWeekCardTabRedPoint, id)
    if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
      EventManager:GetInstance():Broadcast(EventId.LWSeasonMainEntranceRedPoint)
    end
    local IsBoughtNew = tmpData:IsBought()
    if needCheckBought and IsBoughtNew and IsBoughtOld ~= IsBoughtNew then
      DataCenter.SeasonRewardDataManager:InitAchievementsGroupData(true)
    end
    DataCenter.BuildBubbleManager.DoSeasonWeekCardBubbleRefresh()
  end
end

function SeasonPeriodicCardManager:UpdateFreeRewardDate(message, isAutoClaim)
  local id = message.card_id
  local freeRewardTime = message.free_reward
  if id and freeRewardTime then
    local tmpData = self.periodicCardData[id]
    if tmpData then
      tmpData.freeRewardTime = freeRewardTime
      if message.rewards then
        local tmpMsg = {}
        tmpMsg.reward = message.rewards
        local tips = isAutoClaim and CS.GameEntry.Localization:GetString("auto_receive_desc") or ""
        DataCenter.RewardManager:ShowGiftReward(tmpMsg, nil, nil, tips)
        DataCenter.RewardManager:AddRewardsAndRes(tmpMsg)
      end
      EventManager:GetInstance():Broadcast(EventId.LWSeasonWeekCardFreeRewardUpdate)
      EventManager:GetInstance():Broadcast(EventId.LWSeasonMainEntranceRedPoint)
      EventManager:GetInstance():Broadcast(EventId.LWSeasonWeekCardTabRedPoint, id)
    end
    DataCenter.BuildBubbleManager.DoSeasonWeekCardBubbleRefresh()
  end
end

function SeasonPeriodicCardManager:UpdateDailyRewardDate(message)
  local id = message.card_id
  local dailyRewardTime = message.daily_reward
  if id and dailyRewardTime then
    local tmpData = self.periodicCardData[id]
    if tmpData then
      tmpData.dailyRewardTime = dailyRewardTime
      if message.rewards then
        local tmpMsg = {}
        tmpMsg.reward = message.rewards
        DataCenter.RewardManager:ShowCommonReward(tmpMsg, nil, nil, nil, nil, nil, function()
          local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(id)
          if cardData and not cardData:IsTodayClaimedFree() then
            TimerManager:GetInstance():DelayInvoke(function()
              local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("free_chest_receive")
              if not isFunctionOn then
                return
              end
              SFSNetwork.SendMessage(MsgDefines.LWSeasonWeekCardFreeReward, id, true)
            end, 0.2)
          end
        end)
        DataCenter.RewardManager:AddRewardsAndRes(tmpMsg)
      end
      EventManager:GetInstance():Broadcast(EventId.LWSeasonWeekCardDailyRewardUpdate)
      EventManager:GetInstance():Broadcast(EventId.LWSeasonMainEntranceRedPoint)
      EventManager:GetInstance():Broadcast(EventId.LWSeasonWeekCardTabRedPoint, id)
    end
    DataCenter.BuildBubbleManager.DoSeasonWeekCardBubbleRefresh()
  end
end

function SeasonPeriodicCardManager:GetCardData(id)
  if self.periodicCardData then
    return self.periodicCardData[id]
  end
  return nil
end

return SeasonPeriodicCardManager
