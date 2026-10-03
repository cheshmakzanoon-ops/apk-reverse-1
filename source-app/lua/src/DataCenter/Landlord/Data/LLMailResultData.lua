local LLMailResultData = BaseClass("LLMailResultData")

function LLMailResultData:__init()
  self.camp = LLConst.LandLordGroup.NONE
  self.weekNum = 0
  self.destroyRate = 0
  self.destroyScore = 0
  self.beforeDestroyScore = 0
  self.maxDestroyScore = 0
  self.buffList = {}
  self.buildingsList = {}
  self.rewardList = {}
end

function LLMailResultData:__delete()
  self.camp = nil
  self.weekNum = nil
  self.destroyRate = nil
  self.buffList = nil
  self.buildingsList = nil
  self.rewardList = nil
  self.destroyScore = nil
  self.beforeDestroyScore = nil
  self.maxDestroyScore = nil
end

function LLMailResultData:ParseData(message)
  if message == nil then
    return
  end
  if message.camp ~= nil then
    self.camp = message.camp
  end
  if message.weekNum ~= nil then
    self.weekNum = message.weekNum
  end
  if message.destroyRate ~= nil then
    self.destroyRate = message.destroyRate
  end
  if message.destroyScore ~= nil then
    self.destroyScore = message.destroyScore
  end
  if message.beforeDestroyScore ~= nil then
    self.beforeDestroyScore = message.beforeDestroyScore
  end
  if message.maxDestroyScore ~= nil then
    self.maxDestroyScore = message.maxDestroyScore
  end
  if message.buffList then
    for k, v in pairs(message.buffList) do
      table.insert(self.buffList, v)
    end
  end
  if message.buildings then
    local tmpSubTypeList = {}
    local tmpCityIdNumList = {}
    for k, v in pairs(message.buildings) do
      if tmpSubTypeList[v.subType] then
        tmpCityIdNumList[tmpSubTypeList[v.subType]] = tmpCityIdNumList[tmpSubTypeList[v.subType]] + 1
      else
        tmpSubTypeList[v.subType] = v.cityId
        tmpCityIdNumList[tmpSubTypeList[v.subType]] = 1
      end
    end
    for k, v in pairs(tmpCityIdNumList) do
      table.insert(self.buildingsList, {cityId = k, num = v})
    end
  end
end

return LLMailResultData
