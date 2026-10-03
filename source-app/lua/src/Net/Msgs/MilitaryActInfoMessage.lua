local MilitaryActInfoMessage = BaseClass("MilitaryActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MilitaryActInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function MilitaryActInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t ~= nil then
    DataCenter.SeasonMilitaryManager:OnGetInfoCallback(t)
  end
end

return MilitaryActInfoMessage
