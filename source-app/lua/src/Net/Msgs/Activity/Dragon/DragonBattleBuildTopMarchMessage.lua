local DragonBattleBuildTopMarchMessage = BaseClass("DragonBattleBuildTopMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DragonBattleBuildTopMarchMessage:OnCreate()
  base.OnCreate(self)
end

function DragonBattleBuildTopMarchMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil and t.world == nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActDragonManager:HandleBuildingHpChange(t)
end

return DragonBattleBuildTopMarchMessage
