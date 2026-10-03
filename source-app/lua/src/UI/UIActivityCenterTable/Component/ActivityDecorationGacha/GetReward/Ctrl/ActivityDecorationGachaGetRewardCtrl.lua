local ActivityDecorationGachaGetRewardCtrl = BaseClass("ActivityDecorationGachaGetRewardCtrl", UIBaseCtrl)

function ActivityDecorationGachaGetRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityDecorationGachaGetReward)
end

function ActivityDecorationGachaGetRewardCtrl:GetShowDataList(dataList)
  local res = {}
  for i, v in pairs(dataList) do
    local data = {}
    data.rewardData = self:HandleReward(v.reward)
    data.multi = v.multiple
    data.pos = v.pos
    table.insert(res, data)
  end
  return res
end

function ActivityDecorationGachaGetRewardCtrl:HandleReward(reward)
  local notDecorationList = {}
  local decorationList = {}
  for i, v in pairs(reward) do
    if v.type == RewardType.DecorateBuild then
      table.insert(decorationList, v)
    else
      table.insert(notDecorationList, v)
    end
  end
  local notDecorationRes = DataCenter.RewardManager:ReturnRewardParamForView(notDecorationList)
  local decorationRes = {}
  for i, v in pairs(decorationList) do
    local param = {}
    local dic = v.value
    if dic ~= nil then
      param.rewardType = RewardType.DecorateBuild
      if dic.id ~= nil then
        param.itemId = dic.id
      elseif dic.itemId ~= nil then
        param.itemId = dic.itemId
      end
      local sm_addNum = 0
      if dic.num ~= nil then
        sm_addNum = dic.num
      elseif dic.add ~= nil then
        sm_addNum = dic.add
      end
      param.count = sm_addNum
      if dic.buildingUuid ~= nil then
        param.bUuid = dic.buildingUuid
      end
    end
    table.insert(decorationRes, param)
  end
  if notDecorationRes ~= nil then
    for i, v in pairs(notDecorationRes) do
      table.insert(decorationRes, v)
    end
  end
  return decorationRes
end

return ActivityDecorationGachaGetRewardCtrl
