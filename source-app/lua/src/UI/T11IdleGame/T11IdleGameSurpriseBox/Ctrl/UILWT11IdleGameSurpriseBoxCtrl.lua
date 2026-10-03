local UILWT11IdleGameSurpriseBoxCtrl = BaseClass("UILWT11IdleGameSurpriseBoxCtrl", UIBaseCtrl)

function UILWT11IdleGameSurpriseBoxCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWT11IdleGameSurpriseBox)
end

function UILWT11IdleGameSurpriseBoxCtrl:GetFakeGetTotalRewardList(fakeTotalCount)
  local res = {}
  local count = 0
  local list = DataCenter.T11IdleGameTemplateManager:GetSurpriseBoxRewardData()
  if not table.IsNullOrEmpty(list) then
    while fakeTotalCount > count do
      for i, v in ipairs(list) do
        table.insert(res, v)
        count = count + 1
      end
    end
  end
  return res
end

function UILWT11IdleGameSurpriseBoxCtrl:GetTotalRewardList(reward, fakeTotalCount, fakeShowIndex)
  local res = {}
  local count = 0
  local rewardForShowList = DataCenter.RewardManager:ReturnRewardParamForView({reward})
  local rewardForShow = rewardForShowList[1]
  local rewardIndex = 0
  local list = DataCenter.T11IdleGameTemplateManager:GetSurpriseBoxRewardData()
  local singleLoopCount = #list
  while fakeTotalCount > count do
    for i, v in ipairs(list) do
      if rewardIndex == 0 and tostring(v.itemId) == tostring(rewardForShow.itemId) and v.count == rewardForShow.count then
        rewardIndex = i
      end
      table.insert(res, v)
      count = count + 1
    end
  end
  local showRewardIndexInOne = (fakeShowIndex - 1) % singleLoopCount + 1
  local showRewardIndexInTotal = fakeShowIndex + (rewardIndex - showRewardIndexInOne)
  local tmp = res[showRewardIndexInTotal]
  res[showRewardIndexInTotal] = res[fakeShowIndex]
  res[fakeShowIndex] = tmp
  return res
end

return UILWT11IdleGameSurpriseBoxCtrl
