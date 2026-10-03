local TornadoSlotData = BaseClass("TornadoSlotData")

function TornadoSlotData:Init(slotCount, radiusMax, height, liftSpeed, rotateSpeed)
  self.slotCount = slotCount
  self.radiusMax = radiusMax
  self.height = height
  self.liftSpeed = liftSpeed
  self.rotateSpeed = rotateSpeed
  self.tornadoSlotAngles = {}
  self.tornadoSlotUnitList = {}
  self.tornadoSlotUnitToIndex = {}
  local tmpSlotAngles = {}
  local baseStep = 360 / self.slotCount
  for i = 1, slotCount do
    tmpSlotAngles[i] = i * baseStep + Mathf.Random(-1, 1) * baseStep * 0.2
  end
  self:BalanceSlot(tmpSlotAngles, 1, self.slotCount, self.tornadoSlotAngles)
  local mid = Mathf.Floor((1 + self.slotCount) / 2)
  local diffCount = Mathf.Max(0, mid - 2)
  if 0 < diffCount then
    for i = 1, diffCount, 2 do
      local left = mid - i
      local right = mid + i
      local leftValue = self.tornadoSlotAngles[left]
      local rightValue = self.tornadoSlotAngles[right]
      self.tornadoSlotAngles[right] = leftValue
      self.tornadoSlotAngles[left] = rightValue
    end
  end
end

function TornadoSlotData:BalanceSlot(data, left, right, result)
  if right < left then
    return
  end
  local mid = Mathf.Floor((left + right) / 2)
  table.insert(result, data[mid])
  self:BalanceSlot(data, left, mid - 1, result)
  self:BalanceSlot(data, mid + 1, right, result)
end

function TornadoSlotData:TryGetSlot(unitId)
  local cur = self.tornadoSlotUnitToIndex[unitId]
  if cur then
    return cur
  end
  for i = 1, self.slotCount do
    if self.tornadoSlotUnitList[i] == nil then
      local index = i
      self.tornadoSlotUnitList[index] = unitId
      self.tornadoSlotUnitToIndex[unitId] = index
      return index
    end
  end
  return -1
end

function TornadoSlotData:Calc(slotIndex, elapsed)
  local cur = self.tornadoSlotUnitList[slotIndex]
  if cur == nil then
    return nil
  end
  local angle = (self.tornadoSlotAngles[slotIndex] + elapsed * self.rotateSpeed) * Mathf.Deg2Rad
  local offY = self.height + Mathf.Sin(elapsed * slotIndex) * self.liftSpeed
  local offX = Mathf.Cos(angle) * self.radiusMax
  local offZ = Mathf.Sin(angle) * self.radiusMax
  return offX, offY, offZ
end

function TornadoSlotData:ReleaseSlot(unitId, slotIndex)
  if slotIndex < 1 or slotIndex > self.slotCount then
    return
  end
  local cur = self.tornadoSlotUnitList[slotIndex]
  if cur == nil or cur ~= unitId then
    Logger.LogError("TornadoSlotData:ReleaseSlot invalid index : " .. slotIndex)
    return
  end
  self.tornadoSlotUnitList[slotIndex] = nil
  self.tornadoSlotUnitToIndex[unitId] = nil
end

return TornadoSlotData
