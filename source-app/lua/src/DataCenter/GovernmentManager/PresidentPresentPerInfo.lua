local PresidentPresentPerInfo = BaseClass("PresidentPresentPerInfo")

function PresidentPresentPerInfo:__init()
  self.presentId = 0
  self.useCount = 0
  self.reward = {}
end

function PresidentPresentPerInfo:__delete()
  self.presentId = 0
  self.useCount = 0
  self.reward = {}
end

function PresidentPresentPerInfo:ParseData(message)
  if message == nil then
    return
  end
  self.presentId = message.presentId
  self.useCount = message.useCount
  if message.reward ~= nil then
    self.reward = DataCenter.RewardManager:ReturnRewardParamForView(message.reward)
  end
end

return PresidentPresentPerInfo
