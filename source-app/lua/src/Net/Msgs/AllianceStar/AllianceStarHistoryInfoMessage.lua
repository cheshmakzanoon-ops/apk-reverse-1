local AllianceStarHistoryInfoMessage = BaseClass("AllianceStarHistoryInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarHistoryInfoMessage:OnCreate(ceremonyEdition)
  base.OnCreate(self)
  self.sfsObj:PutInt("ceremonyEdition", ceremonyEdition)
end

function AllianceStarHistoryInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnAllianceStarHistoryInfo(t)
  end
end

return AllianceStarHistoryInfoMessage
