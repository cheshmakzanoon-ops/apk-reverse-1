local ClaimAllWeekCardRewardMessage = BaseClass("ClaimAllWeekCardRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:ShowCommonReward(t, nil, nil, nil, nil, nil, function()
        local hasFree = DataCenter.WeekCardManager:CheckIfHasFreeReward()
        if hasFree then
          TimerManager:GetInstance():DelayInvoke(function()
            local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("free_chest_receive")
            if not isFunctionOn then
              return
            end
            SFSNetwork.SendMessage(MsgDefines.ClaimWeekCardFreeReward, true)
          end, 0.2)
        end
      end)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    DataCenter.WeekCardManager:UpdateWeekCardList(t.cards)
  end
end

ClaimAllWeekCardRewardMessage.OnCreate = OnCreate
ClaimAllWeekCardRewardMessage.HandleMessage = HandleMessage
return ClaimAllWeekCardRewardMessage
