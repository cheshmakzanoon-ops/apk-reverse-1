local HeroEventClaimBoxRewardMessage = BaseClass("HeroEventClaimBoxRewardMessage", SFSBaseMessage)
local RewardUtil = require("Util.RewardUtil")
local base = SFSBaseMessage

function HeroEventClaimBoxRewardMessage:OnCreate(uuid, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
  self.sfsObj:PutLong("uuid", uuid)
end

function HeroEventClaimBoxRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    local heroEventUserInfo = RewardUtil.FetchHeroEventData(t.uuid)
    if heroEventUserInfo then
      if heroEventUserInfo.scoreRewardIndex == nil then
        heroEventUserInfo.scoreRewardIndex = {
          t.index
        }
      else
        table.insert(heroEventUserInfo.scoreRewardIndex, t.index)
      end
    else
      heroEventUserInfo = {
        uuid = t.uuid,
        score = 0,
        scoreRewardIndex = {
          t.index
        }
      }
      RewardUtil.AddHeroEventData(t.uuid, heroEventUserInfo)
    end
    EventManager:GetInstance():Broadcast(EventId.HeroEventClaimBoxReward, t.uuid)
  end
end

return HeroEventClaimBoxRewardMessage
