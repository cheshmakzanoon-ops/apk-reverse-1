local LastStandManager = BaseClass("LastStandManager", CEventable)

function LastStandManager:__init()
end

function LastStandManager:Destroy()
end

function LastStandManager:EnterLevel(levelId, uuid)
  local param = {}
  param.type = PVEType.LastStand
  param.levelId = levelId
  param.detectUuid = uuid
  DataCenter.LWBattleManager:Enter(param)
end

function LastStandManager:SendWinLevel(uuid, levelId)
  SFSNetwork.SendMessage(MsgDefines.DetectEventLastStandFeature, uuid, true, levelId)
end

return LastStandManager
