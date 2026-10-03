local Arena3V3LikeMessage = BaseClass("Arena3V3LikeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local reward = t.reward
    if reward ~= nil then
      DataCenter.RewardManager:AddRewardsAndRes(t)
      if t.changeGold and t.changeGold > 0 then
        local name = DataCenter.ResourceManager:GetResourceNameByType(ResourceType.Gold)
        local num = t.changeGold
        UIUtil.ShowTips(Localization:GetString("500216", name, num))
      end
    end
    DataCenter.LW3V3ArenaManager.remainPraise = t.remainPraise or 0
    DataCenter.LW3V3ArenaManager:SetPlayerLikeCount(t.uid, t.praise)
    EventManager:GetInstance():Broadcast(EventId.Arena3V3SendLike, t.uid)
    EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
  end
end

Arena3V3LikeMessage.OnCreate = OnCreate
Arena3V3LikeMessage.HandleMessage = HandleMessage
return Arena3V3LikeMessage
