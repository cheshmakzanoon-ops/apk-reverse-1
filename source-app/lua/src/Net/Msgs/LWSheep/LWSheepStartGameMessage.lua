local LWSheepStartGameMessage = BaseClass("LWSheepStartGameMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSheepDataManager:UpdateGameInfo(t)
  end
end

LWSheepStartGameMessage.OnCreate = OnCreate
LWSheepStartGameMessage.HandleMessage = HandleMessage
return LWSheepStartGameMessage
