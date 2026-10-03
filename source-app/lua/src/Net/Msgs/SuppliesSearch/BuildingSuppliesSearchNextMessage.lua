local BuildingSuppliesSearchNextMessage = BaseClass("BuildingSuppliesSearchNextMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BuildingSuppliesSearchNextMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("buildingUuid", uuid)
end

function BuildingSuppliesSearchNextMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SuppliesSearchManager:UpdateSuppliesSearchInfo(SuppliesSearchType.Monopoly, t)
  end
end

return BuildingSuppliesSearchNextMessage
