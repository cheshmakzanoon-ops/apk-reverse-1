local PlaneFeatureAcceptResultMessage = BaseClass("PlaneFeatureAcceptResultMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PlaneFeatureAcceptResultMessage:OnCreate(uuid, stageId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("stageId", stageId)
end

function PlaneFeatureAcceptResultMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "frontline_help_tips_05" and t.errorPara2 and t.errorPara2[1] then
      local stageId = tonumber(t.errorPara2[1])
      local name = DataCenter.LWStageFeatureChapterManager:GetStageFeatureName(stageId)
      UIUtil.ShowTips(Localization:GetString(errCode, name))
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    local beHelpTimes = t.beHelpedTimes
    if beHelpTimes then
      DataCenter.LWStageFeatureChapterManager:UpdateBeHelpedTimes(beHelpTimes)
    end
    local stageId = t.stageId
    EventManager:GetInstance():Broadcast(EventId.ParkourBattleWin, stageId)
    EventManager:GetInstance():Broadcast(EventId.PlaneFeatureAcceptResultSuccess, t)
    local totalCount = t.totalSoldier
    if stageId then
      if DataCenter.LWIntegratedStageFeatureChapterManager:IsOpen() then
        EventManager:GetInstance():Broadcast(EventId.StageFeatureIntegratedWinCheckUploadGameCenterData, {stageId = stageId, remainMemberCount = totalCount})
      else
        EventManager:GetInstance():Broadcast(EventId.StageFeatureChapterWinCheckUploadGameCenterData, {stageId = stageId, remainMemberCount = totalCount})
      end
    end
  end
end

return PlaneFeatureAcceptResultMessage
