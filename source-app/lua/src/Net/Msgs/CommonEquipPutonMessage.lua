local CommonEquipPutonMessage = BaseClass("CommonEquipPutonMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CommonEquipPutonMessage:OnCreate(targetId, equips)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("wearTargetId", tostring(targetId))
  local equipArr = SFSArray.New()
  for slotId, equipUuId in pairs(equips) do
    local obj1 = SFSObject.New()
    obj1:PutInt("slot", slotId)
    obj1:PutLong("equipUid", equipUuId)
    equipArr:AddSFSObject(obj1)
  end
  self.sfsObj:PutSFSArray("equips", equipArr)
end

function CommonEquipPutonMessage:HandleMessage(t)
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
    EventManager:GetInstance():Broadcast(EventId.PutonCommonEquip)
  end
end

return CommonEquipPutonMessage
