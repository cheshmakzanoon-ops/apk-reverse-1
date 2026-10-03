local GetBattleCardBookDataMessage = BaseClass("GetBattleCardBookDataMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    return
  end
  DataCenter.TacticalCardDataManager:UpdateCardBookData(message.collectCards)
end

GetBattleCardBookDataMessage.OnCreate = OnCreate
GetBattleCardBookDataMessage.HandleMessage = HandleMessage
return GetBattleCardBookDataMessage
