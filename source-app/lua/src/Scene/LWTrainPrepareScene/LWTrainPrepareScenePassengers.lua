local LWTrainPrepareScenePassengers = BaseClass("LWTrainPrepareScenePassengers")
local LWTrainPrepareScenePassenger = require("Scene.LWTrainPrepareScene.LWTrainPrepareScenePassenger")
local LWTrainPrepareScenePassengerBubble = require("Scene.LWTrainPrepareScene.LWTrainPrepareScenePassengerBubble")
local Localization = CS.GameEntry.Localization
local startX = -6.9
local startZ = -6.5
local MaxBubbleCount = 10

function LWTrainPrepareScenePassengers:__init(controlCamera, rootTransform, coachIndex)
  self.controlCamera = controlCamera
  self.rootTransform = rootTransform
  self.coachIndex = coachIndex
  self.VIPRoot = vip
  self.passengersList = {}
  self.passengersIndexes = {}
  self.passengersCoachMap = {}
  self.passengersIndexMap = {}
  self.coachCountMap = {}
  self.allPassengers = {}
  self.vipPassenger = nil
  self.bubblePool = {}
  self.bubbleCount = 0
  self.randomBubbleCount = DataCenter.LWAllyStationDataManager:GetBubbleShowMember()
end

function LWTrainPrepareScenePassengers:__delete()
  self.rootTransform = nil
  for _, v in pairs(self.passengersList) do
    for _, passenger in pairs(v) do
      passenger:Delete()
    end
  end
  for _, v in ipairs(self.bubblePool) do
    v:Delete()
  end
  self.bubblePool = nil
  self.bubbleCount = 0
  if self.vipPassenger then
    self.vipPassenger:Delete()
    self.vipPassenger = nil
  end
  self.controlCamera = nil
  self.passengersList = nil
  self.allPassengers = nil
  self.passengersIndexes = nil
  self.passengersCoachMap = nil
  self.passengersIndexMap = nil
  self.coachCountMap = nil
  self.VIPRoot = nil
end

function LWTrainPrepareScenePassengers:InitVIPPassenger(vipRoot, vipId)
  if vipRoot then
    self.VIPRoot = vipRoot
  end
  if self.VIPRoot then
    local data = {uid = vipId}
    if self.vipPassenger then
      self.vipPassenger:Delete()
      self.vipPassenger = nil
    end
    local p = LWTrainPrepareScenePassenger.New(self, self.VIPRoot, 5, 1, 0, -10, data, true)
    self.vipPassenger = p
    p:MoveTo(0, 0, nil, true)
  end
end

function LWTrainPrepareScenePassengers:RefreshPassengers(passengers, refresh, trainName)
  self:RemoveVipPassengerByUid()
  self.trainName = trainName
  if refresh then
    local leaveCoachIndexMap = {
      {},
      {},
      {},
      {}
    }
    for i = 1, 4 do
      local lineUp = passengers[i + 1]
      if lineUp then
        local count = #lineUp
        local oldCount = self.coachCountMap[i]
        local newCount = 0
        local oriCount = 0
        local changeCount = 0
        for j = 1, count do
          local data = lineUp[j]
          local uid = data.uid
          local oldCoach = self.passengersCoachMap[uid] or 0
          if oldCoach == 0 then
            newCount = newCount + 1
            oldCount = oldCount + 1
            local index = oldCount
            self.passengersCoachMap[uid] = i
            self.passengersIndexMap[uid] = index
            local p = LWTrainPrepareScenePassenger.New(self, self.rootTransform, i, index, startX, startZ, data)
            local x, z = self:GetPos(i, index)
            p:MoveTo(x, z)
            self.passengersList[i][uid] = p
            self.passengersIndexes[i][index] = p
            table.insert(self.allPassengers, p)
          elseif oldCoach == i then
            oriCount = oriCount + 1
          else
            changeCount = changeCount + 1
            local oldIndex = self.passengersIndexMap[uid]
            table.insert(leaveCoachIndexMap[oldCoach], oldIndex)
            oldCount = oldCount + 1
            local index = oldCount
            self.passengersCoachMap[uid] = i
            self.passengersIndexMap[uid] = index
            local p = self.passengersList[oldCoach][uid]
            local x, z = self:GetPos(i, index)
            p:MoveTo(x, z, false)
            self.passengersList[oldCoach][uid] = nil
            self.passengersIndexes[oldCoach][oldIndex] = nil
            self.passengersList[i][uid] = p
            self.passengersIndexes[i][index] = p
          end
        end
        self.coachCountMap[i] = oldCount
      else
      end
    end
    for i = 1, 4 do
      local newCount = 0
      local lineUp = passengers[i + 1]
      if lineUp then
        newCount = #lineUp
      end
      local oldCount = self.coachCountMap[i]
      self.coachCountMap[i] = newCount
      if newCount < oldCount and 0 < newCount then
        local offset = oldCount - newCount
        local leaveIndexMap = leaveCoachIndexMap[i]
        for j = 0, offset - 1 do
          local index = oldCount - j
          local p = self.passengersIndexes[i][index]
          if p == nil then
          else
            local leaveIndex = leaveIndexMap[j + 1]
            local x, z = self:GetPos(i, leaveIndex)
            p:MoveTo(x, z)
            self.passengersIndexes[i][index] = nil
            self.passengersIndexes[i][leaveIndex] = p
            local uid = p.uid
            self.passengersIndexMap[uid] = leaveIndex
          end
        end
      end
    end
    return
  end
  for i = 1, 4 do
    local list = {}
    table.insert(self.passengersList, list)
    local indexes = {}
    table.insert(self.passengersIndexes, indexes)
    local lineUp = passengers[i + 1]
    if lineUp then
      local count = #lineUp
      self.coachCountMap[i] = count
      for j = 1, count do
        local data = lineUp[j]
        local uid = data.uid
        self.passengersCoachMap[uid] = i
        self.passengersIndexMap[uid] = j
        local p = LWTrainPrepareScenePassenger.New(self, self.rootTransform, i, j, startX, startZ, data)
        local x, z = self:GetPos(i, j)
        p:MoveTo(x, z)
        list[uid] = p
        indexes[j] = p
        table.insert(self.allPassengers, p)
      end
    else
      self.coachCountMap[i] = 0
    end
  end
end

function LWTrainPrepareScenePassengers:RemoveVipPassengerByUid()
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if not trainData then
    return
  end
  if trainData.vipInfo then
    local uid = trainData.vipInfo.vipId
    local oldCoach = self.passengersCoachMap[uid] or 0
    if oldCoach == 0 then
      return
    end
    local oldIndex = self.passengersIndexMap[uid]
    local passenger = self.passengersList[oldCoach][uid]
    if not passenger then
      return
    end
    passenger:Delete()
    self.passengersList[oldCoach][uid] = nil
    self.passengersIndexes[oldCoach][oldIndex] = nil
    self.passengersCoachMap[uid] = nil
    self.passengersIndexMap[uid] = nil
    self.coachCountMap[oldCoach] = self.coachCountMap[oldCoach] - 1
  end
end

function LWTrainPrepareScenePassengers:GetPos(coachIndex, posIndex)
  local posArray = DataCenter.LWTrainPrepareSceneManager.posArray
  if posArray then
    local startX = 0
    local startZ = -9.5 * (coachIndex - 1) + 1.5
    local offSetX = startX - 10
    local offsetZ = startZ - 3
    local length = #posArray
    if posIndex <= length then
      local base = posArray[posIndex]
      return base[1] + offSetX, base[2] + offsetZ
    end
  end
  local z = 1.25 * (-1) ^ (posIndex + 1) - 9.5 * (coachIndex - 1)
  local x = math.modf((posIndex - 1) / 2) * -1.5
  return x, z
end

function LWTrainPrepareScenePassengers:GetBubble()
  local count = #self.bubblePool
  if 0 < count then
    local bubble = table.remove(self.bubblePool)
    bubble:OutPool()
    return bubble
  end
  if self.bubbleCount >= MaxBubbleCount then
    return nil
  end
  local bubble = LWTrainPrepareScenePassengerBubble.New(self.controlCamera)
  bubble:Load()
  self.bubbleCount = self.bubbleCount + 1
  return bubble
end

function LWTrainPrepareScenePassengers:PushBubble(bubble)
  bubble:InPool()
  table.insert(self.bubblePool, bubble)
end

function LWTrainPrepareScenePassengers:GetPassengerBubbleLange()
  local key = DataCenter.LWAllyStationDataManager:GetPassengerLang()
  if not string.IsNullOrEmpty(key) then
    return Localization:GetString(key, self.trainName)
  end
  return nil
end

function LWTrainPrepareScenePassengers:RandomBubble()
  if self.randomBubbleCount <= 0 then
    return
  end
  local totalCount = #self.allPassengers
  if totalCount == 0 then
    return
  end
  local randomTotalCount = 0
  for i, v in pairs(self.coachCountMap) do
    local count = Mathf.Clamp(v, 0, 10)
    randomTotalCount = randomTotalCount + count
  end
  if randomTotalCount <= self.randomBubbleCount then
    for i, v in pairs(self.coachCountMap) do
      local count = Mathf.Clamp(v, 0, 10)
      if 0 < count then
        local list = self.passengersIndexes[i]
        if list then
          for j = 1, count do
            local p = list[j]
            if p then
              p:ForceShowBubble()
            end
          end
        end
      end
    end
    return
  end
  for i = 1, self.randomBubbleCount do
    local index = Mathf.Random(1, randomTotalCount)
    local relaIndex = 0
    local realCoach = 0
    local realCoachIndex = 0
    for j, v in pairs(self.coachCountMap) do
      local count = Mathf.Clamp(v, 0, 10)
      if index <= count then
        relaIndex = relaIndex + index
        realCoach = j
        realCoachIndex = index
        break
      else
        relaIndex = relaIndex + v
        index = index - count
      end
    end
    local list = self.passengersIndexes[realCoach]
    if list then
      local p = list[realCoachIndex]
      if p then
        p:ForceShowBubble()
      end
    end
  end
end

return LWTrainPrepareScenePassengers
