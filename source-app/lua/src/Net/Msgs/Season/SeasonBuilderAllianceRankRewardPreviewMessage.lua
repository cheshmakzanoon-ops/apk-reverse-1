local SeasonBuilderAllianceRankRewardPreviewMessage = BaseClass("SeasonBuilderAllianceRankRewardPreviewMessage", SFSBaseMessage)
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
  DataCenter.SeasonRewardDataManager:SeasonFamerRankRewardInfoUpdate(t)
end

SeasonBuilderAllianceRankRewardPreviewMessage.OnCreate = OnCreate
SeasonBuilderAllianceRankRewardPreviewMessage.HandleMessage = HandleMessage
return SeasonBuilderAllianceRankRewardPreviewMessage
