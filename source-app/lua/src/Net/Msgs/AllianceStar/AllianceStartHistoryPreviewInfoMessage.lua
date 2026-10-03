local AllianceStartHistoryPreviewInfoMessage = BaseClass("AllianceStartHistoryPreviewInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStartHistoryPreviewInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceStartHistoryPreviewInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceStarManager:OnAllianceStartHistoryPreviewInfo(t)
  end
end

return AllianceStartHistoryPreviewInfoMessage
