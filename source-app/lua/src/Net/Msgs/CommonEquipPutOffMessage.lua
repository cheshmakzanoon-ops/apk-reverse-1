local CommonEquipPutOffMessage = BaseClass("CommonEquipPutOffMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CommonEquipPutOffMessage:OnCreate(equipUid)
  base.OnCreate(self)
  self.sfsObj:PutLong("equipUid", equipUid)
end

function CommonEquipPutOffMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
  else
    if not table.IsNullOrEmpty(t.deletes) then
      for _, v in pairs(t.deletes) do
        DataCenter.CommonEquipDataManager:RemoveEquipInfo(v, false)
      end
    end
    if not table.IsNullOrEmpty(t.changes) then
      DataCenter.CommonEquipDataManager:UpdateEquipInfos(t.changes, true)
    end
    EventManager:GetInstance():Broadcast(EventId.PutoffCommonEquip)
  end
end

return CommonEquipPutOffMessage
