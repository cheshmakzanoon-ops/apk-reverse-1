local GaleArenaPraiseMessage = BaseClass("GaleArenaPraiseMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      local reward = t.reward
      if reward ~= nil then
        DataCenter.RewardManager:AddRewardsAndRes(t)
        if t.changeGold and t.changeGold > 0 then
          local name = DataCenter.ResourceManager:GetResourceNameByType(ResourceType.Gold)
          local num = t.changeGold
          UIUtil.ShowTips(Localization:GetString("500216", name, num))
        end
      end
      DataCenter.NewGaleArenaManager:NewArenaPraiseHandler(t)
      EventManager:GetInstance():Broadcast(EventId.NewGaleArenaPraise, t.uid)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

GaleArenaPraiseMessage.OnCreate = OnCreate
GaleArenaPraiseMessage.HandleMessage = HandleMessage
return GaleArenaPraiseMessage
