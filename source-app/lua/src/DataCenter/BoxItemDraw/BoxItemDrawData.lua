local BoxItemDrawData = BaseClass("BoxItemDrawData")

function BoxItemDrawData:__init()
  self.configs = nil
  self.data = nil
  self.groupId = nil
end

function BoxItemDrawData:__delete()
  self.configs = nil
  self.data = nil
  self.groupId = nil
end

function BoxItemDrawData:UpdateData(groupId, data)
  self.groupId = groupId
  if self.data == nil then
    self.data = {}
  end
  if data ~= nil then
    for i, v in pairs(data) do
      self.data[i] = v
    end
  end
  self.configs = DataCenter.BoxItemDrawManager:GetBoxItemDrawTemplates(self.groupId)
end

function BoxItemDrawData:GetCurRound()
  if self.data == nil or self.data.round == nil then
    return 1
  end
  return self.data.round
end

function BoxItemDrawData:GetAlreadySum()
  if self.data ~= nil then
    return self.data.alreadySum or 0
  end
  return 0
end

function BoxItemDrawData:GetTemplate(round)
  if self.configs ~= nil then
    for i, v in pairs(self.configs) do
      local startRound, endRound = v:GetRoundRange()
      if round >= startRound and round <= endRound then
        return v
      end
    end
  end
end

function BoxItemDrawData:GetCurCount(index)
  if self.data ~= nil and self.data.rewardObj ~= nil then
    for i, v in pairs(self.data.rewardObj) do
      if tonumber(i + 1) == index then
        return v
      end
    end
  end
  return 0
end

function BoxItemDrawData:GetCurTotalLeftCount()
  local res = 0
  local curTemplate = self:GetTemplate(self:GetCurRound())
  if curTemplate then
    local rewards = curTemplate:GetRewards()
    for i, v in pairs(rewards) do
      if not curTemplate:IsBigReward(v.index) then
        res = res + (v.limit - self:GetCurCount(v.index))
      end
    end
    res = res + 1
  end
  return res
end

function BoxItemDrawData:GetTotalCount()
  local total = 0
  local curTemplate = self:GetTemplate(self:GetCurRound())
  if curTemplate then
    local rewards = curTemplate:GetRewards()
    for i, v in pairs(rewards) do
      if v then
        total = total + v.limit
      end
    end
  end
  return total
end

function BoxItemDrawData:GetDrawNum()
  local drawNum = 5
  if 5 > self:GetCurTotalLeftCount() then
    drawNum = self:GetCurTotalLeftCount()
  end
  return drawNum
end

return BoxItemDrawData
