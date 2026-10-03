local BankItemData = BaseClass("BankItemData")

function BankItemData:__init()
  self.id = 0
  self.allianceId = ""
  self.ownerServerId = 0
  self.curDepositNum = 0
  self.serviceScope = 0
  self.curAsset = 0
  self.isConnect = false
  self.protectEndTime = 0
  self.robState = 0
end

function BankItemData:__delete()
  self.id = nil
  self.allianceId = nil
  self.curDepositNum = nil
  self.serviceScope = nil
  self.curAsset = nil
  self.isConnect = nil
  self.protectEndTime = nil
  self.robState = nil
end

function BankItemData:ParseData(msg, serverId)
  self.id = msg.id or 0
  self.serverId = serverId or 0
  self.allianceId = msg.allianceId or ""
  self.ownerServerId = msg.ownerServerId or self.serverId
  self.curDepositNum = msg.curDepositNum or 0
  self.serviceScope = msg.serviceScope or 0
  self.curAsset = msg.curAsset or 0
  self.isConnect = msg.isConnect or false
  self.protectEndTime = msg.protectEndTime or 0
  self.robState = msg.robState or 0
  local cityMeta = self:GetMeta()
  if cityMeta then
    self.level = cityMeta.level
    self.priority = self.serverId * 1000 + self.level * 10 + (self:IsOwner() and 1 or 0)
    self.iconPath = cityMeta:GetIconPath(false)
    self.posStr = string.format("X: %s Y: %s", cityMeta.pos.x, cityMeta.pos.y)
    self.pos = {}
    self.pos.x = cityMeta.pos.x
    self.pos.y = cityMeta.pos.y
    self.pointId = cityMeta:GetPointId()
    self.max_asset = cityMeta.max_asset or 0
    self.max_player = cityMeta.max_player or 0
    self.only_original_zone = cityMeta.only_original_zone == -1 or false
  end
end

function BankItemData:IsProtect()
  if self.protectEndTime > UITimeManager:GetInstance():GetServerTime() then
    return true
  end
  if self.only_original_zone then
    if LuaEntry.Player:GetSourceServerId() == self.serverId then
      return false
    else
      return true
    end
  end
  return false
end

function BankItemData:IsOwner()
  return not string.IsNullOrEmpty(self.allianceId) and self.allianceId == LuaEntry.Player.allianceId
end

function BankItemData:CanDeposit(showTips)
  if not DataCenter.SeasonBankManager:CanDepositByScope(self.serviceScope, self.ownerServerId, self.allianceId, showTips) then
    return false
  end
  if self.robState and self.robState == 1 then
    return false
  end
  if self.curAsset >= self.max_asset then
    return false
  end
  if self.curDepositNum >= self.max_player then
    return false
  end
  return true
end

function BankItemData:GetMeta()
  return self.id and DataCenter.AllianceCityTemplateManager:GetTemplate(self.id, self.serverId)
end

return BankItemData
