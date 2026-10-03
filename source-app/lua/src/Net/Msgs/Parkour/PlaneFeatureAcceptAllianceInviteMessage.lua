local PlaneFeatureAcceptAllianceInviteMessage = BaseClass("PlaneFeatureAcceptAllianceInviteMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PlaneFeatureAcceptAllianceInviteMessage:OnCreate(uuid, stageId, targetUid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("stageId", stageId)
  self.sfsObj:PutUtfString("fromUid", targetUid)
end

function PlaneFeatureAcceptAllianceInviteMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "frontline_help_tips_06" and t.errorPara2 and t.errorPara2[1] then
      local stageId = tonumber(t.errorPara2[1])
      local name = DataCenter.LWStageFeatureChapterManager:GetStageFeatureName(stageId)
      UIUtil.ShowTips(Localization:GetString(errCode, name))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    UIUtil.ShowTipsId("frontline_help_tips_12")
    local helpTimes = t.helpTimes
    DataCenter.LWStageFeatureChapterManager:UpdateHelpTimes(helpTimes)
    local uuid = t.uuid
    local stageId = t.stageId
    DataCenter.LWStageFeatureChapterManager:SaveAcceptInviteUuid(uuid)
    DataCenter.LWStageFeatureChapterManager:ShowGoToTipsMessage(uuid, stageId)
  end
end

return PlaneFeatureAcceptAllianceInviteMessage
