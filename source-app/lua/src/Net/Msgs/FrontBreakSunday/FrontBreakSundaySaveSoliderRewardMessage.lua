local FrontBreakSundaySaveSoliderRewardMessage = BaseClass("FrontBreakSundaySaveSoliderRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FrontBreakSundaySaveSoliderRewardMessage:OnCreate(activityId, boxId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("id", boxId)
end

function FrontBreakSundaySaveSoliderRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.ActFrontBreakSundayDataManager:HandleSaveSoliderRewardMessage(message)
end

return FrontBreakSundaySaveSoliderRewardMessage
