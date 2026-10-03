local CommonEquipAutoMergeMessage = BaseClass("CommonEquipAutoMergeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CommonEquipAutoMergeMessage:OnCreate(slot)
  base.OnCreate(self)
  self.sfsObj:PutInt("slot", slot)
end

function CommonEquipAutoMergeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    print(errCode)
  elseif not table.IsNullOrEmpty(t.batchArr) then
    local deletedEquipsNum = {}
    local changes = {}
    for _, v in pairs(t.batchArr) do
      if not table.IsNullOrEmpty(v.deletes) then
        for _, v in pairs(v.deletes) do
          local equipInfo = DataCenter.CommonEquipDataManager:GetEquipInfo(v)
          if equipInfo then
            local equipId = equipInfo.cfgId
            if deletedEquipsNum[equipId] == nil then
              deletedEquipsNum[equipId] = 0
            end
            deletedEquipsNum[equipId] = deletedEquipsNum[equipId] + equipInfo.num
          end
        end
        for _, v in pairs(v.deletes) do
          DataCenter.CommonEquipDataManager:RemoveEquipInfo(v, false)
        end
      end
      if not table.IsNullOrEmpty(v.changes) then
        DataCenter.CommonEquipDataManager:UpdateEquipInfos(v.changes, false)
        for _, v in pairs(v.changes) do
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
    if not table.IsNullOrEmpty(t.deletedEquipsNum) or not table.IsNullOrEmpty(changesArr) and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSquadEquipResultPanel) then
      EventManager:GetInstance():Broadcast(EventId.CommonEquipMerge, {
        msg = {changes = changesArr},
        deletedEquipsNum = deletedEquipsNum
      })
    end
  end
end

return CommonEquipAutoMergeMessage
