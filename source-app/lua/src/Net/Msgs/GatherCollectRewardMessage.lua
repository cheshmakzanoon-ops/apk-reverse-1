local GatherCollectRewardMessage = BaseClass("GatherCollectRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuidList)
  base.OnCreate(self)
  local uuidArr = SFSArray.New()
  for i, v in ipairs(uuidList) do
    uuidArr:AddLong(v)
  end
  self.sfsObj:PutSFSArray("uuidArr", uuidArr)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  else
    local singleShowReward = {}
    local showReward = {}
    if t.reward ~= nil then
      for k, v in pairs(t.reward) do
        local isSingle = false
        if v.type and v.type == RewardType.GOODS and v.value and v.value.itemId then
          local template = DataCenter.ItemTemplateManager:GetItemTemplate(v.value.itemId)
          if template and template.is_single_show > 0 then
            isSingle = true
            table.insert(singleShowReward, v)
          end
        end
        if isSingle == false then
          table.insert(showReward, v)
        end
      end
      local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(showReward)
      if 0 < #singleShowReward then
        DataCenter.RewardManager:ShowCommonReward({reward = singleShowReward}, nil, nil, nil, nil, nil, function()
          if rewardList ~= nil then
            EventManager:GetInstance():Broadcast(EventId.OnClaimCollectRewardSucc, rewardList)
          end
        end)
      elseif rewardList ~= nil then
        EventManager:GetInstance():Broadcast(EventId.OnClaimCollectRewardSucc, rewardList)
      end
      TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.RewardManager:AddRewardsAndRes(t)
      end, 1.5)
    end
    DataCenter.CollectRewardDataManager:UpdateCollectRewardList(t)
    EventManager:GetInstance():Broadcast(EventId.RefreshMonsterRewardBag)
  end
end

GatherCollectRewardMessage.OnCreate = OnCreate
GatherCollectRewardMessage.HandleMessage = HandleMessage
return GatherCollectRewardMessage
