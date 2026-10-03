local LWSheepGetInfoMessage = BaseClass("LWSheepGetInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSheepDataManager:UpdateSheepInfo(t)
  end
end

LWSheepGetInfoMessage.HandleMessage = HandleMessage
return LWSheepGetInfoMessage
