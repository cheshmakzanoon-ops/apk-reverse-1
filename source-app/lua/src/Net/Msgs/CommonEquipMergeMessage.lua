local CommonEquipMergeMessage = BaseClass("CommonEquipMergeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CommonEquipMergeMessage:OnCreate(equipUid, oneKey, flag)
  base.OnCreate(self)
  self.sfsObj:PutLong("equipUid", equipUid)
  self.sfsObj:PutInt("oneKey", oneKey)
  if flag then
    self.sfsObj:PutInt("flag", flag)
  end
end

function CommonEquipMergeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
  else
    if not table.IsNullOrEmpty(t.putOffDeletes) then
      for _, v in pairs(t.putOffDeletes) do
        DataCenter.CommonEquipDataManager:RemoveEquipInfo(v, false)
      end
    end
    if not table.IsNullOrEmpty(t.putOffChanges) then
      DataCenter.CommonEquipDataManager:UpdateEquipInfos(t.putOffChanges, false)
    end
    local deletedEquipsNum = {}
    if not table.IsNullOrEmpty(t.deletes) then
      for _, v in pairs(t.deletes) do
        local equipInfo = DataCenter.CommonEquipDataManager:GetEquipInfo(v)
        if equipInfo then
          local equipId = equipInfo.cfgId
          if deletedEquipsNum[equipId] == nil then
            deletedEquipsNum[equipId] = 0
          end
          deletedEquipsNum[equipId] = deletedEquipsNum[equipId] + equipInfo.num
        end
      end
      for _, v in pairs(t.deletes) do
        DataCenter.CommonEquipDataManager:RemoveEquipInfo(v, false)
      end
    end
    if not table.IsNullOrEmpty(t.changes) then
      DataCenter.CommonEquipDataManager:UpdateEquipInfos(t.changes, false)
    end
    if not table.IsNullOrEmpty(t.putOnDeletes) then
      for _, v in pairs(t.putOnDeletes) do
        DataCenter.CommonEquipDataManager:RemoveEquipInfo(v, false)
      end
    end
    if not table.IsNullOrEmpty(t.putOnChanges) then
      DataCenter.CommonEquipDataManager:UpdateEquipInfos(t.putOnChanges, false)
    end
    EventManager:GetInstance():Broadcast(EventId.CommonEquipDataChanged)
    if not table.IsNullOrEmpty(t.deletes) or not table.IsNullOrEmpty(t.changes) and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSquadEquipResultPanel) then
      EventManager:GetInstance():Broadcast(EventId.CommonEquipMerge, {msg = t, deletedEquipsNum = deletedEquipsNum})
    end
  end
end

return CommonEquipMergeMessage
