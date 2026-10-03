local LWSeasonUserMaxForceRewardGetMessage = BaseClass("LWSeasonUserMaxForceRewardGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("selectId", id)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonRewardDataManager:GetSelectRewardSuccess(t, SeasonScoreRewardPanelType.PersonalOccupyLand)
end

LWSeasonUserMaxForceRewardGetMessage.OnCreate = OnCreate
LWSeasonUserMaxForceRewardGetMessage.HandleMessage = HandleMessage
return LWSeasonUserMaxForceRewardGetMessage
