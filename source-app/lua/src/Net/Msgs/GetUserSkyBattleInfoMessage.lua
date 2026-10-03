local GetUserSkyBattleInfoMessage = BaseClass("GetUserSkyBattleInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetUserSkyBattleInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetUserSkyBattleInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSkyBattleGrowthChapterManager:InitBattleInfoData(t)
  end
end

return GetUserSkyBattleInfoMessage
