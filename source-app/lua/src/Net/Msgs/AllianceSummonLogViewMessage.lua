local AllianceSummonLogViewMessage = BaseClass("AllianceSummonLogViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceSummonLogViewMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceSummonLogViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.allianceSummonLogArr then
    DataCenter.JungleTrialDataManager:HandleHistory(t.allianceSummonLogArr)
  end
end

return AllianceSummonLogViewMessage
