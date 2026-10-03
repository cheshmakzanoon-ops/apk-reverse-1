local UserSesaonAchievementV2Grade = BaseClass("UserSesaonAchievementV2Grade", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("achievementId", tonumber(id))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonRewardDataManager:UpdataAchievementGrade(t)
end

UserSesaonAchievementV2Grade.OnCreate = OnCreate
UserSesaonAchievementV2Grade.HandleMessage = HandleMessage
return UserSesaonAchievementV2Grade
