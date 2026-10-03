local ClaimWeekCardRewardMessage = BaseClass("ClaimWeekCardRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:ShowCommonReward(t, nil, nil, nil, nil, nil, function()
        local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("free_chest_receive")
        if not isFunctionOn then
          return
        end
        local hasFree = DataCenter.WeekCardManager:CheckIfHasFreeReward()
        if hasFree then
          TimerManager:GetInstance():DelayInvoke(function()
            SFSNetwork.SendMessage(MsgDefines.ClaimWeekCardFreeReward, true)
          end, 0.2)
        end
      end)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    DataCenter.WeekCardManager:UpdateOneWeekCard(t)
  end
end

ClaimWeekCardRewardMessage.OnCreate = OnCreate
ClaimWeekCardRewardMessage.HandleMessage = HandleMessage
return ClaimWeekCardRewardMessage
