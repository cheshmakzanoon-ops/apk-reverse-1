local SeasonPlayerMonsterLevelInfoMessage = BaseClass("SeasonPlayerMonsterLevelInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonPlayerMonsterLevelInfoMessage:OnCreate()
  base.OnCreate(self)
end

function SeasonPlayerMonsterLevelInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonDataManager:UpdateMonsterMaxLevel(t)
end

return SeasonPlayerMonsterLevelInfoMessage
