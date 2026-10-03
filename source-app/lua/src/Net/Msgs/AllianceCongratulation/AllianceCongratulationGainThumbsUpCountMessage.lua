local AllianceCongratulationGainThumbsUpCountMessage = BaseClass("AllianceCongratulationGainThumbsUpCountMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceCongratulationGainThumbsUpCountMessage:OnCreate(targetUid, configId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutUtfString("configId", configId)
end

function AllianceCongratulationGainThumbsUpCountMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceCongratulationDataManager:SaveThumbsUpInfo(t)
  end
end

return AllianceCongratulationGainThumbsUpCountMessage
