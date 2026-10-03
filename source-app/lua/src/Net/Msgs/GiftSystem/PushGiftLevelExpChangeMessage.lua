local PushGiftLevelExpChangeMessage = BaseClass("PushGiftLevelExpChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushGiftLevelExpChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushGiftLevelExpChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.GiftSystemManager:HandleGiftLevelExpChange(t)
    DataCenter.ValentineDataManager:SetActSendGiftRecordDataDirty()
  end
end

return PushGiftLevelExpChangeMessage
