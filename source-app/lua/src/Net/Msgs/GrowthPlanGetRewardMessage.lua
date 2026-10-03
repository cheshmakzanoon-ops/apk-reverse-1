local GrowthPlanGetRewardMessage = BaseClass("GrowthPlanGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("id", param.id)
  self.sfsObj:PutInt("type", param.type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local cache = WelfareController.getWelfareCache(WelfareMessageKey.GrowthPlanInfo)
  for _, data in ipairs(cache.stageInfo) do
    if data.id == cache.id then
      if cache.type == GetRewardType.Normal then
        data.normalState = 1
        break
      end
      if cache.type == GetRewardType.Special then
        data.specialState = 1
      end
      break
    end
  end
  WelfareController.setWelfareCache(WelfareMessageKey.GrowthPlanInfo, cache)
  EventManager:GetInstance():Broadcast(EventId.GrowthPlanGetReward, t)
  EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

GrowthPlanGetRewardMessage.OnCreate = OnCreate
GrowthPlanGetRewardMessage.HandleMessage = HandleMessage
return GrowthPlanGetRewardMessage
