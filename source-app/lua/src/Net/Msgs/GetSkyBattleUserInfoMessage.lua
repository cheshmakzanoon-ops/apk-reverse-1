local GetSkyBattleUserInfoMessage = BaseClass("GetSkyBattleUserInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSkyBattleUserInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetSkyBattleUserInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSkyBattleGrowthChapterManager:InitUserInfoData(t)
  end
end

return GetSkyBattleUserInfoMessage
