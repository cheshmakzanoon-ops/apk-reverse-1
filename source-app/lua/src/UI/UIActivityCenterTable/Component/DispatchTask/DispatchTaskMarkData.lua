local DispatchTaskMarkData = BaseClass("DispatchTaskMarkData")

function DispatchTaskMarkData:__init()
  self.Data = nil
  self.InPool = false
  self.MarkState = {
    None = 0,
    Expired = 1,
    UnComplete = 2,
    CanClaim = 3
  }
end

function DispatchTaskMarkData:__delete()
end

function DispatchTaskMarkData:Init(data)
  if data ~= nil then
    self.Data = data
    self.Cell = LocalController:instance():getLine(TableName.LwDispatchTask, data.missionCfgId)
    self.ShareUserInfo = data.shareUserInfo
    self.StealList = data.serverPoint.stealList
    if self.StealList == nil then
      self.StealList = {}
    end
    self.InPool = false
  end
end

function DispatchTaskMarkData:UpdateThumbsUp(hasThumbsUp)
  if self:Valid() then
    self.Data.hasThumbs = hasThumbsUp
  end
end

function DispatchTaskMarkData:UpdateSteal()
  if not self:Valid() then
    return
  end
  if not table.hasvalue(self.StealList, LuaEntry.Player.uid) then
    table.insert(self.StealList, LuaEntry.Player.uid)
    EventManager:GetInstance():Broadcast(EventId.DispatchTaskStealSuccess, self:GetMissionUuid())
  end
end

function DispatchTaskMarkData:UpdateShare()
end

function DispatchTaskMarkData:GetShareUserInfo()
  if self:Valid() then
    return self.Data.shareUserInfo
  end
  return nil
end

function DispatchTaskMarkData:GetUuid()
  if self:Valid() then
    return self.Data.uuid
  end
  return 0
end

function DispatchTaskMarkData:GetMissionUuid()
  if self:Valid() then
    return self.Data.missionUuid
  end
  return 0
end

function DispatchTaskMarkData:GetMissionServerId()
  if self:Valid() then
    return self.Data.serverPoint.missionCurrentServerId
  end
  return 0
end

function DispatchTaskMarkData:GetMissionPointId()
  if self:Valid() then
    return self.Data.serverPoint.pointId
  end
  return 0
end

function DispatchTaskMarkData:GetMissionOwnerUserInfo()
  if self:Valid() then
    return self.Data.serverPoint.shareUserInfo
  end
  return ""
end

function DispatchTaskMarkData:GetRewards()
  if self:Valid() then
    return self.Data.reward
  end
  return nil
end

function DispatchTaskMarkData:TimeToClaim()
  if self:Valid() then
    return checknumber(self.Data.canPlunderTime) - UITimeManager:GetInstance():GetServerTime()
  end
  return 0
end

function DispatchTaskMarkData:CanClaim()
  return self:GetState() == self.MarkState.CanClaim
end

function DispatchTaskMarkData:FromMe()
  if self:Valid() then
    return self.Data.shareUserInfo.uid == LuaEntry.Player.uid
  end
  return false
end

function DispatchTaskMarkData:BelongAllies()
  if self:Valid() then
    local ownerUserInfo = self:GetMissionOwnerUserInfo()
    if ownerUserInfo ~= nil then
      return ownerUserInfo.allianceId == LuaEntry.Player.allianceId
    end
  end
  return false
end

function DispatchTaskMarkData:InValidServerRange()
  return DataCenter.ActGhostreconManager:IsCanGetTheReward(self:GetMissionServerId())
end

function DispatchTaskMarkData:CanShowInList()
  return self:Valid() and not self:HasSteal() and not self:BelongAllies() and self:InValidServerRange()
end

function DispatchTaskMarkData:HasThumbsUp()
  if self:Valid() then
    return self.Data.hasThumbs
  end
  return false
end

function DispatchTaskMarkData:HasSteal()
  if self:Valid() then
    return table.hasvalue(self.StealList, LuaEntry.Player.uid)
  end
  return true
end

function DispatchTaskMarkData:GetState()
  if not self:Valid() then
    return self.MarkState.None
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now >= checknumber(self.Data.shareExpireTime) then
    return self.MarkState.Expired
  end
  if now <= checknumber(self.Data.canPlunderTime) then
    return self.MarkState.UnComplete
  end
  return self.MarkState.CanClaim
end

function DispatchTaskMarkData:CompareTo(markB)
  if self:Valid() and not markB:Valid() then
    return false
  end
  if not self:Valid() and markB:Valid() then
    return true
  end
  local stateA = self:GetState()
  local stateB = markB:GetState()
  if stateA ~= stateB then
    return stateA > stateB
  end
  local isSpecialA = self.Cell.is_special
  local isSpecialB = markB.Cell.is_special
  if isSpecialA ~= isSpecialB then
    return isSpecialA > isSpecialB
  end
  local colorA = self.Cell.color
  local colorB = markB.Cell.color
  if colorA ~= colorB then
    return colorA > colorB
  end
  local starA = self.Cell.task_star
  local starB = markB.Cell.task_star
  if starA ~= starB then
    return starA > starB
  end
  local timeA = 0
  local timeB = 0
  if stateA == self.MarkState.CanClaim then
    timeA = self.Data.shareExpireTime
    timeB = markB.Data.shareExpireTime
  elseif stateA == self.MarkState.UnComplete then
    timeA = self.Data.canPlunderTime
    timeB = markB.Data.canPlunderTime
  end
  if timeA ~= timeB then
    return timeA < timeB
  end
  return self.Data.uuid < markB.Data.uuid
end

function DispatchTaskMarkData:TriggerUpdate()
  EventManager:GetInstance():Broadcast(EventId.DispatchTaskThumbsUp, self)
end

function DispatchTaskMarkData:Reset()
  self.InPool = true
  self.Data = nil
  self.Cell = nil
  self.ShareUserInfo = nil
  self.StealList = {}
end

function DispatchTaskMarkData:Valid()
  return not self.InPool
end

return DispatchTaskMarkData
