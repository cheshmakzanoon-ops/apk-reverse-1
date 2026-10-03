local FrontBreakSundayStartChallengeMessage = BaseClass("FrontBreakSundayStartChallengeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FrontBreakSundayStartChallengeMessage:OnCreate(stageId)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", tonumber(stageId))
end

function FrontBreakSundayStartChallengeMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
  DataCenter.ActFrontBreakSundayDataManager:HandleStartChallengeMessage(message)
end

return FrontBreakSundayStartChallengeMessage
