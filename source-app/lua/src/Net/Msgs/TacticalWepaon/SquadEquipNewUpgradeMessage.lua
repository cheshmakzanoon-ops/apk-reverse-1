local SquadEquipNewUpgradeMessage = BaseClass("SquadEquipNewUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SquadEquipNewUpgradeMessage:OnCreate(costArr, slot)
  base.OnCreate(self)
  local array = SFSArray.New()
  for i, v in ipairs(costArr) do
    local obj = SFSObject.New()
    obj:PutLong("uuid", tonumber(v.uuid))
    obj:PutInt("num", v.num)
    array:AddSFSObject(obj)
  end
  self.sfsObj:PutSFSArray("costArr", array)
  self.sfsObj:PutInt("slot", slot)
end

function SquadEquipNewUpgradeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local deletedEquipsNum = {}
    local changes = {}
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
      for _, v in pairs(t.changes) do
        if v.cfgId then
          local equipId = v.cfgId
          if changes[equipId] == nil then
            changes[equipId] = v
          else
            changes[equipId].changeNum = changes[equipId].changeNum + v.changeNum
          end
        end
      end
    end
    if t.curWearModel then
      DataCenter.CommonEquipDataManager:UpdateEquipInfo(t.curWearModel)
    end
    for k, v in pairs(changes) do
      if deletedEquipsNum[k] then
        v.changeNum = v.changeNum - deletedEquipsNum[k]
        deletedEquipsNum[k] = nil
      end
    end
    local changesArr = {}
    for k, v in pairs(changes) do
      table.insert(changesArr, v)
    end
    EventManager:GetInstance():Broadcast(EventId.CommonEquipDataChanged)
  end
end

return SquadEquipNewUpgradeMessage
