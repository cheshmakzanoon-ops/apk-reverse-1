local LWSeasonUserMaxForceRewardGetAllMessage = BaseClass("LWSeasonUserMaxForceRewardGetAllMessage", SFSBaseMessage)
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
  DataCenter.SeasonRewardDataManager:GetAllRewardSuccess(t, SeasonScoreRewardPanelType.PersonalOccupyLand)
end

LWSeasonUserMaxForceRewardGetAllMessage.OnCreate = OnCreate
LWSeasonUserMaxForceRewardGetAllMessage.HandleMessage = HandleMessage
return LWSeasonUserMaxForceRewardGetAllMessage
