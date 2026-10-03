local SeasonWeekBuffReceiveRewardMessage = BaseClass("SeasonWeekBuffReceiveRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonWeekManager:HandleReceiveReward(t)
end

SeasonWeekBuffReceiveRewardMessage.OnCreate = OnCreate
SeasonWeekBuffReceiveRewardMessage.HandleMessage = HandleMessage
return SeasonWeekBuffReceiveRewardMessage
