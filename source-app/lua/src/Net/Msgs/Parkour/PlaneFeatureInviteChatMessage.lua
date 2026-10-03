local PlaneFeatureInviteChatMessage = BaseClass("PlaneFeatureInviteChatMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PlaneFeatureInviteChatMessage:OnCreate(stageId, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutInt("stageId", stageId)
  self.sfsObj:PutUtfString("targetUid", targetUid)
end

function PlaneFeatureInviteChatMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "frontline_help_tips_01" and t.errorPara2 and t.errorPara2[1] then
      local stageId = tonumber(t.errorPara2[1])
      local name = DataCenter.LWStageFeatureChapterManager:GetStageFeatureName(stageId)
      UIUtil.ShowTips(Localization:GetString(errCode, name))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    UIUtil.ShowTipsId(120061)
    local shareTimes = t.shareTimes
    local lastShareTime = t.lastShareTime
    DataCenter.LWStageFeatureChapterManager:UpdateShareTimes(shareTimes)
    DataCenter.LWStageFeatureChapterManager:UpdateLastShareTime(lastShareTime)
  end
end

return PlaneFeatureInviteChatMessage
