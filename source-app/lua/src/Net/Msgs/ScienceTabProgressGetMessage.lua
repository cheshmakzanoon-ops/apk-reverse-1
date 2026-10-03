local ScienceTabProgressGetMessage = BaseClass("ScienceTabProgressGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ScienceTabProgressGetMessage:OnCreate(param)
  base.OnCreate(self)
end

function ScienceTabProgressGetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.scienceTabProgress ~= nil then
    DataCenter.ScienceDataManager:UpdateScienceTabProgress(t.scienceTabProgress)
  end
end

return ScienceTabProgressGetMessage
