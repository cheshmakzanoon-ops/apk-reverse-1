local GetParkourMainInfoMessage = BaseClass("GetParkourMainInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetParkourMainInfoMessage:OnCreate(type)
  base.OnCreate(self)
  type = type or 0
  self.sfsObj:PutInt("type", type)
end

function GetParkourMainInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSurfingDataManager:InitSurfingBattleData(t)
  end
end

return GetParkourMainInfoMessage
