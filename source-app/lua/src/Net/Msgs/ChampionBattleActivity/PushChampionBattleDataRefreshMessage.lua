local PushChampionBattleDataRefreshMessage = BaseClass("PushChampionBattleDataRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, formationArr)
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

PushChampionBattleDataRefreshMessage.OnCreate = OnCreate
PushChampionBattleDataRefreshMessage.HandleMessage = HandleMessage
return PushChampionBattleDataRefreshMessage
