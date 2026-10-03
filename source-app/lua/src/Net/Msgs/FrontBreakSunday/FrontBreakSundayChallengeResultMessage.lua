local FrontBreakSundayChallengeResultMessage = BaseClass("FrontBreakSundayChallengeResultMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FrontBreakSundayChallengeResultMessage:OnCreate(stageId, remainSoilder)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", stageId)
  self.sfsObj:PutInt("soldier", remainSoilder)
end

function FrontBreakSundayChallengeResultMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
  DataCenter.ActFrontBreakSundayDataManager:HandleChallengeResultMessage(message)
end

return FrontBreakSundayChallengeResultMessage
