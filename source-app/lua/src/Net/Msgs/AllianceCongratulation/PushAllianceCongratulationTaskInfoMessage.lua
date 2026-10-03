local PushAllianceCongratulationTaskInfoMessage = BaseClass("PushAllianceCongratulationTaskInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceCongratulationTaskInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceCongratulationTaskInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.configId then
    local lineData = LocalController:instance():getLine(TableName.LW_Alliance_Congratulation, t.configId)
    if lineData then
      if not CS.SceneManager:IsInCity() and not CS.SceneManager:IsInWorld() then
        DataCenter.AllianceCongratulationDataManager:SetPopInfo(lineData)
      else
        UIUtil.OpenLWUIChatCommonShare(lineData.share_components)
      end
    end
  end
end

return PushAllianceCongratulationTaskInfoMessage
