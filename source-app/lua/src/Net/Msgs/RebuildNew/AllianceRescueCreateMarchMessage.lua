local AllianceRescueCreateMarchMessage = BaseClass("AllianceRescueCreateMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceRescueCreateMarchMessage:OnCreate(create)
  base.OnCreate(self)
  self.sfsObj:PutBool("create", create)
end

function AllianceRescueCreateMarchMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CityRebuildDataManager:SetAllianceAndMarchInfo(t)
  end
end

return AllianceRescueCreateMarchMessage
