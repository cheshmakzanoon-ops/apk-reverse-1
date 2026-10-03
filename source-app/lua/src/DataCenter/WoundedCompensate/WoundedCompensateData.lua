local WoundedCompensateData = BaseClass("WoundedCompensateData", Singleton)

function WoundedCompensateData:__init()
  self.list = {}
  self.cdTime = LuaEntry.DataConfig:TryGetNum("newplayer_death_return", "k2")
end

function WoundedCompensateData:__delete()
  self.list = nil
end

function WoundedCompensateData:InitData(message)
  self.list = {}
  if message.compensateArr then
    local compensateArr = message.compensateArr
    for i = 1, #compensateArr do
      local param = {}
      if compensateArr[i].uuid then
        param.uuid = compensateArr[i].uuid
      end
      if compensateArr[i].reward then
        param.reward = DataCenter.RewardManager:ReturnRewardParamForView(compensateArr[i].reward)
      end
      if compensateArr[i].time then
        param.time = compensateArr[i].time
        param.endTime = param.time + self.cdTime * 1000
      end
      if compensateArr[i].targetInfo then
        param.targetInfo = {}
        param.targetInfo.name = compensateArr[i].targetInfo.name
        param.targetInfo.alAbbr = compensateArr[i].targetInfo.alAbbr
        param.targetInfo.server = compensateArr[i].targetInfo.server
      end
      if compensateArr[i].scale then
        local scale = compensateArr[i].scale * 1000
        local value = math.floor(scale * 1000 + 0.5) / 1000
        param.scale = value / 1000 * 100
      end
      table.insert(self.list, param)
    end
    if next(self.list) then
      table.sort(self.list, function(a, b)
        if a.time < b.time then
          return true
        end
        return false
      end)
      DataCenter.WoundedCompensateManager:StartUp()
    end
  end
end

function WoundedCompensateData:UpdateData(message)
  local param = {}
  if message.reward then
    param.reward = DataCenter.RewardManager:ReturnRewardParamForView(message.reward)
  end
  if message.targetInfo then
    param.targetInfo = {}
    param.targetInfo.name = message.targetInfo.name
    param.targetInfo.alAbbr = message.targetInfo.alAbbr
    param.targetInfo.server = message.targetInfo.server
  end
  if message.time then
    param.time = message.time
    param.endTime = param.time + self.cdTime * 1000
  end
  if message.uuid then
    param.uuid = message.uuid
  end
  if message.scale then
    local scale = message.scale * 1000
    local value = math.floor(scale * 1000 + 0.5) / 1000
    param.scale = value / 1000 * 100
  end
  if next(param) then
    table.insert(self.list, param)
  end
  if next(self.list) then
    table.sort(self.list, function(a, b)
      if a.time < b.time then
        return true
      end
      return false
    end)
    DataCenter.WoundedCompensateManager:StartUp()
    DataCenter.GuideManager:CheckNeedWaitTriggerGuide(GuideTriggerType.DefendWall, SaveGuideDoneValue)
  end
end

function WoundedCompensateData:GetDataInfo()
  if self.list and next(self.list) then
    return self.list[1]
  end
  return nil
end

function WoundedCompensateData:ReceiveRewardHandle(message)
  DataCenter.RewardManager:ShowCommonReward(message, nil, nil, nil, true)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  for i = 1, #self.list do
    if self.list[i].uuid == message.uuid then
      table.remove(self.list, i)
      break
    end
  end
  if not next(self.list) then
    DataCenter.CityNpcManager:RemoveOneNpc("CityNpc_jianzhang")
  end
end

return WoundedCompensateData
