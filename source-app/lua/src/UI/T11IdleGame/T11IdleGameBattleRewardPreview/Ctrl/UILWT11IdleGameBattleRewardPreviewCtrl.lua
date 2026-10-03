local UILWT11IdleGameBattleRewardPreviewCtrl = BaseClass("UILWT11IdleGameBattleRewardPreviewCtrl", UIBaseCtrl)

function UILWT11IdleGameBattleRewardPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWT11IdleGameBattleRewardPreview)
end

function UILWT11IdleGameBattleRewardPreviewCtrl:GetShowRewards(data)
  local rewards = {}
  for i, v in ipairs(data) do
    local splitStr = string.split(v, ";")
    if #splitStr == 3 then
      local reward = {
        rewardType = tonumber(splitStr[1]),
        itemId = tonumber(splitStr[2]),
        count = tonumber(splitStr[3])
      }
      table.insert(rewards, reward)
    elseif #splitStr == 4 then
      local reward = {
        rewardType = tonumber(splitStr[1]),
        itemId = tonumber(splitStr[2]),
        count = tonumber(splitStr[3])
      }
      table.insert(rewards, {
        reward = reward,
        prob = string.percentage(tonumber(splitStr[4]) / 100, 100, 2)
      })
    end
  end
  return rewards
end

return UILWT11IdleGameBattleRewardPreviewCtrl
