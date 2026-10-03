local ActChampBattleDataRefreshMessage = BaseClass("ActChampBattleDataRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.ActChampionBattleManager:RefreshChampionBattleInfo(message)
end

ActChampBattleDataRefreshMessage.OnCreate = OnCreate
ActChampBattleDataRefreshMessage.HandleMessage = HandleMessage
return ActChampBattleDataRefreshMessage
