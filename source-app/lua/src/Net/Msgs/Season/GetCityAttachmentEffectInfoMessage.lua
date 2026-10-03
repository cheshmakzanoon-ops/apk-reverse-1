local GetCityAttachmentEffectInfoMessage = BaseClass("GetCityAttachmentEffectInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCityAttachmentEffectInfoMessage:OnCreate()
  base.OnCreate(self)
end

function GetCityAttachmentEffectInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.SeasonFarmerManager:SetCityAttachmentEffectInfo(t)
  end
end

return GetCityAttachmentEffectInfoMessage
