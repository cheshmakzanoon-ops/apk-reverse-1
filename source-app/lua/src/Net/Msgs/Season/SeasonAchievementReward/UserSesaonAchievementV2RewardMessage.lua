local UserSesaonAchievementV2RewardMessage = BaseClass("UserSesaonAchievementV2RewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id, grade)
  base.OnCreate(self)
  self.sfsObj:PutInt("achievementId", tonumber(id))
  self.sfsObj:PutInt("grade", tonumber(grade))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonRewardDataManager:GetAchievementSelectRewardSuccess(t)
end

UserSesaonAchievementV2RewardMessage.OnCreate = OnCreate
UserSesaonAchievementV2RewardMessage.HandleMessage = HandleMessage
return UserSesaonAchievementV2RewardMessage
