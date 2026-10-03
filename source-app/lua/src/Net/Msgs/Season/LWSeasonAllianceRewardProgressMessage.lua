local LWSeasonAllianceRewardProgressMessage = BaseClass("LWSeasonAllianceRewardProgressMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, eventId, subType, startIndex, endIndex)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonRewardDataManager:RefreshAllianceRewardConditionProgress(t)
end

LWSeasonAllianceRewardProgressMessage.OnCreate = OnCreate
LWSeasonAllianceRewardProgressMessage.HandleMessage = HandleMessage
return LWSeasonAllianceRewardProgressMessage
