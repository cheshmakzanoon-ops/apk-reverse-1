local GetSeasonForceValueMessage = BaseClass("GetSeasonForceValueMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonForceValueMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

function GetSeasonForceValueMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonDataManager:OnGetSeasonForceValue(t.type, t.value)
end

return GetSeasonForceValueMessage
