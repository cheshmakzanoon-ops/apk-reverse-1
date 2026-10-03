local BiuBiuGetInfoMessage = BaseClass("BiuBiuGetInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWBiuBiuDataManager:UpdateInfo(t)
    EventManager:GetInstance():Broadcast(EventId.SeasonGetBiuBiuInfo)
  end
end

BiuBiuGetInfoMessage.HandleMessage = HandleMessage
return BiuBiuGetInfoMessage
