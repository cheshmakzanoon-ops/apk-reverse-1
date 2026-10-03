local PushUserSkyBattlePlaneMessage = BaseClass("PushUserSkyBattlePlaneMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserSkyBattlePlaneMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushUserSkyBattlePlaneMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSkyBattleGrowthChapterManager:RefreshBattlePlaneInfoData(t)
  end
end

return PushUserSkyBattlePlaneMessage
