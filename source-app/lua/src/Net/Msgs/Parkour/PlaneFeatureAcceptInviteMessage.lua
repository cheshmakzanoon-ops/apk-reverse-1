local PlaneFeatureAcceptInviteMessage = BaseClass("PlaneFeatureAcceptInviteMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PlaneFeatureAcceptInviteMessage:OnCreate(uuid, stageId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("stageId", stageId)
end

function PlaneFeatureAcceptInviteMessage:HandleMessage(t)
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
    local helpTimes = t.helpTimes
    DataCenter.LWStageFeatureChapterManager:UpdateHelpTimes(helpTimes)
    EventManager:GetInstance():Broadcast(EventId.PlaneFeatureAcceptInviteSuccess, t)
    local uuid = t.uuid
    local stageId = t.stageId
    DataCenter.LWStageFeatureChapterManager:ShowGoToTipsMessage(uuid, stageId)
  end
end

return PlaneFeatureAcceptInviteMessage
