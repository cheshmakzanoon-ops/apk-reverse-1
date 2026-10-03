local UserSesaonAchievementV2InfoMesage = BaseClass("UserSesaonAchievementV2InfoMesage", SFSBaseMessage)
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
  DataCenter.SeasonRewardDataManager:InitSeasonAchievementData(t)
end

UserSesaonAchievementV2InfoMesage.OnCreate = OnCreate
UserSesaonAchievementV2InfoMesage.HandleMessage = HandleMessage
return UserSesaonAchievementV2InfoMesage
