local PveResRecordManager = BaseClass("PveResRecordManager")
local Localization = CS.GameEntry.Localization
local Const = require("Scene.PVEBattleLevel.Const")
local SyncDecStaminaCount = 10
local MaxTipShowCount = 3

function PveResRecordManager:__init(battleLevel)
  self.battleLevel = battleLevel
  self.cutCount = {}
  self.allRecord = {}
  self.curRecord = {}
  self.decStamina = 0
  self.submitTriggerResource = {}
  self.submitTriggerResourceItem = {}
  self.maxTipTries = {}
end

function PveResRecordManager:__delete()
  self.cutCount = {}
  self.allRecord = {}
  self.curRecord = {}
  self.decStamina = 0
  self.submitTriggerResource = {}
  self.submitTriggerResourceItem = {}
  self.maxTipTries = {}
end

function PveResRecordManager:InitPveRecord(record)
  self.allRecord = {}
  if record ~= nil and record ~= "" then
    local spl = string.split_ss_array(record, "|")
    for k, v in ipairs(spl) do
      local spl1 = string.split_ii_array(v, ";")
      if 1 < #spl1 then
        self.allRecord[spl1[1]] = spl1[2]
      end
    end
  end
end

function PveResRecordManager:SyncPveResource()
  if table.count(self.curRecord) > 0 then
    local param = {}
    param.level = self.battleLevel.levelId
    param.pveResArr = DeepCopy(self.curRecord)
    SFSNetwork.SendMessage(MsgDefines.SyncPveResource, param)
    self.curRecord = {}
    self.decStamina = 0
    self.battleLevel:SaveDB()
  end
end

function PveResRecordManager:SyncPveResourceHandle(message)
  if message.errorCode == nil then
    self:InitPveRecord(message.pveResRecord)
    if message.resource ~= nil then
      LuaEntry.Resource:UpdateResource(message.resource)
    end
    if message.accPoint ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(message.accPoint)
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

function PveResRecordManager:GetAllRecordCount(id)
  return self.allRecord[id] or 0
end

function PveResRecordManager:ChangeRecordCount(id, num, collectionData)
  local template = DataCenter.PveAtomTemplateManager:GetTemplate(id)
  if template ~= nil then
    if self.curRecord[id] == nil then
      self.curRecord[id] = 0
    end
    if self.allRecord[id] == nil then
      self.allRecord[id] = 0
    end
    self.curRecord[id] = self.curRecord[id] + num
    self.allRecord[id] = self.allRecord[id] + num
    local stamina = DataCenter.PveAtomTemplateManager:GetCostStamina(id)
    LuaEntry.Player:ChangePveStamina(-stamina)
    EventManager:GetInstance():Broadcast(EventId.FormationStaminaUpdate)
    local pos
    local collectionObj = collectionData:GetObj()
    if collectionObj ~= nil then
      pos = collectionData:GetPosition()
    end
    if not table.IsNullOrEmpty(template.outResource) then
      local addNum = template:GetEffectOutResourceNum()
      for k, v in ipairs(template.outResource) do
        local realNum, _ = math.modf(v.count + addNum)
        if collectionObj ~= nil then
          collectionObj:ShowFlyResAnim(collectionData:GetType(), realNum)
        end
        self.battleLevel:ChangeResTypeCount(Const.ResourceTypeToResType[v.resourceType], realNum, pos)
        if template.type == PveAtomType.Tree or template.type == PveAtomType.Stone then
          DataCenter.TaskManager:FelledTreeHandle(v.resourceType, realNum)
        end
      end
      EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
    end
    local hasResItem = false
    if not table.IsNullOrEmpty(template.outResItem) then
      for _, v in ipairs(template.outResItem) do
        if DataCenter.ResourceItemDataManager:CheckIsStorageFull(v.count) then
          self.curRecord = {}
          self.decStamina = 0
          UIUtil.ShowSingleTip(Localization:GetString("128001"))
          DataCenter.WarningBallManager:CheckBag()
          break
        else
          DataCenter.ResourceItemDataManager:AddItemNum(v.itemId, v.count)
          self.battleLevel:ChangeResTypeCount(v.itemId, v.count, pos)
          if collectionObj then
            collectionObj:ShowFlyResAnim(collectionData:GetType(), v.count)
          end
          hasResItem = true
        end
        if template.type == PveAtomType.Tree or template.type == PveAtomType.Stone then
          DataCenter.TaskManager:FelledTreeHandle(v.itemId, v.count)
        end
      end
    end
    self.decStamina = self.decStamina + stamina
    if self.decStamina >= SyncDecStaminaCount or hasResItem then
      self:SyncPveResource()
    end
  end
end

function PveResRecordManager:ChangeSubmitResource(resourceType, num)
  if self.submitTriggerResource[resourceType] == nil then
    self.submitTriggerResource[resourceType] = num
  else
    self.submitTriggerResource[resourceType] = self.submitTriggerResource[resourceType] + num
  end
  EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
end

function PveResRecordManager:GetResourceCount(resourceType)
  local num = LuaEntry.Resource:GetCntByResType(resourceType)
  if self.submitTriggerResource[resourceType] ~= nil then
    num = num - self.submitTriggerResource[resourceType]
  end
  if num < 0 then
    num = 0
  end
  return num
end

function PveResRecordManager:Clear()
  self.submitTriggerResource = {}
  self.submitTriggerResourceItem = {}
end

function PveResRecordManager:ChangeSubmitResourceItem(resourceType, num)
  if self.submitTriggerResourceItem[resourceType] == nil then
    self.submitTriggerResourceItem[resourceType] = num
  else
    self.submitTriggerResourceItem[resourceType] = self.submitTriggerResourceItem[resourceType] + num
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshResourceItem)
end

function PveResRecordManager:GetResourceItemCount(resourceType)
  local num = DataCenter.ResourceItemDataManager:GetCountByItemId(resourceType)
  if self.submitTriggerResourceItem[resourceType] ~= nil then
    num = num - self.submitTriggerResourceItem[resourceType]
  end
  if num < 0 then
    num = 0
  end
  return num
end

function PveResRecordManager:ChangeCutCount(id, num)
  if self.cutCount[id] == nil then
    self.cutCount[id] = 0
  end
  self.cutCount[id] = self.cutCount[id] + num
end

function PveResRecordManager:GetCutCount(id)
  return self.cutCount[id] or 0
end

function PveResRecordManager:TryShowMaxTip(levelId, id)
  if self.maxTipTries[levelId] == nil then
    self.maxTipTries[levelId] = {}
  end
  if self.maxTipTries[levelId][id] == nil then
    self.maxTipTries[levelId][id] = 0
  end
  if self.maxTipTries[levelId][id] < MaxTipShowCount then
    UIUtil.ShowSingleTip(Localization:GetString("400092"))
  end
  self.maxTipTries[levelId][id] = self.maxTipTries[levelId][id] + 1
end

function PveResRecordManager:ClearMaxTipTries()
  self.maxTipTries = {}
end

return PveResRecordManager
