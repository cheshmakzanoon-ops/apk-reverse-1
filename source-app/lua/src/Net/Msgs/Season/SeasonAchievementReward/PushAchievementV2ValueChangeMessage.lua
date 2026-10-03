local PushAchievementV2ValueChangeMessage = BaseClass("PushAchievementV2ValueChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  if t.id and t.value then
    local msg = {}
    msg.achievementId = t.id
    msg.gradeValue = t.value
    DataCenter.SeasonRewardDataManager:UpdataAchievementGrade(msg)
  end
end

PushAchievementV2ValueChangeMessage.OnCreate = OnCreate
PushAchievementV2ValueChangeMessage.HandleMessage = HandleMessage
return PushAchievementV2ValueChangeMessage
