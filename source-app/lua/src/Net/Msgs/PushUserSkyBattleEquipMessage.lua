local PushUserSkyBattleEquipMessage = BaseClass("PushUserSkyBattleEquipMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUserSkyBattleEquipMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushUserSkyBattleEquipMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSkyBattleGrowthChapterManager:RefreshBattleEquipInfoData(t)
  end
end

return PushUserSkyBattleEquipMessage
