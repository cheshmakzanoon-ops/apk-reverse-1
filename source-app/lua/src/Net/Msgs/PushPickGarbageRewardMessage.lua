local PushPickGarbageRewardMessage = BaseClass("PushPickGarbageRewardMessage", SFSBaseMessage)
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
  elseif t.reward ~= nil then
    if t.pointId ~= nil and not UIManager:GetInstance():HasWindow() then
      local pos = SceneUtils.IndexToTilePos(t.pointId)
      local worldPos = SceneUtils.TileToWorld(pos)
      local screenPos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
      local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(t.reward)
      if rewardList ~= nil then
        table.walk(rewardList, function(_, v)
          local pic = DataCenter.RewardManager:GetPicByType(v.rewardType, v.itemId)
          local flyPos = Vector3:New(0, 0, 0)
          local num = v.count
          num = math.min(num, 3)
          if v.rewardType == RewardType.OIL or v.rewardType == RewardType.METAL or v.rewardType == RewardType.WATER or v.rewardType == RewardType.ELECTRICITY or v.rewardType == RewardType.FOOD or v.rewardType == RewardType.FLINT or v.rewardType == RewardType.OBSIDIAN then
            local param = {}
            param.resType = RewardToResType[v.rewardType]
            param.rewardTyp = tonumber(v.rewardType)
            param.num = num
            param.pic = pic
            param.screenPos = screenPos
            param.flyPos = flyPos
            EventManager:GetInstance():Broadcast(EventId.ShowPickGarbageResource, param)
          else
            UIUtil.DoFly(tonumber(RewardType.GOODS), num, pic, screenPos, flyPos)
          end
        end)
      end
    end
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end, 1.5)
  end
end

PushPickGarbageRewardMessage.OnCreate = OnCreate
PushPickGarbageRewardMessage.HandleMessage = HandleMessage
return PushPickGarbageRewardMessage
