local UIActMonopolyBoxRewardView = BaseClass("UIActMonopolyBoxRewardView", UIBaseView)
local base = UIBaseView
local UIActMonopolyBoxRewardContent = require("UI.UIActMonopoly.UIActMonopolyBoxReward.Component.UIActMonopolyBoxRewardContent")
local Localization = CS.GameEntry.Localization
local title_path = "panel/Common_bg_orange/text_title"
local close_path = "panel"
local close_btn_path = "panel/Common_bg_orange/closeBtn"
local box_reward_content_path = "panel/Common_bg_orange/CenterContent/boxRewardContent"
local tip_text3_content_path = "panel/Common_bg_orange/CenterContent/boxRewardContent/tip3ScrollView/Viewport/TipText3Content"

function UIActMonopolyBoxRewardView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self.activityId = self:GetUserData()
  self:ReInit()
  PostEventLog.Track(PostEventLog.Defines.ActMonopolyBoxRewardOpen, {})
end

function UIActMonopolyBoxRewardView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActMonopolyBoxRewardView:DataDefine()
  self.activityId = nil
end

function UIActMonopolyBoxRewardView:DataDestroy()
  self.activityId = nil
end

function UIActMonopolyBoxRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMonopolyBoxRewardDataGet, self.ReInit)
end

function UIActMonopolyBoxRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActMonopolyBoxRewardDataGet, self.ReInit)
end

function UIActMonopolyBoxRewardView:ComponentDefine()
  self.close = self:AddComponent(UIButton, close_path)
  self.titleText = self:AddComponent(UIText, title_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleText:SetLocalText("activity_sports_uitips_007")
  self.box_reward_content = self:AddComponent(UIActMonopolyBoxRewardContent, box_reward_content_path)
  self.tip_text3_content = self:AddComponent(UITextMeshProUGUIEx, tip_text3_content_path)
end

function UIActMonopolyBoxRewardView:ComponentDestroy()
  self.tip_text3_content = nil
end

function UIActMonopolyBoxRewardView:ReInit()
  self.box_reward_content:ReInit(self.activityId)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not activityInfo then
    return
  end
  local activityDetailData = DataCenter.ActMonopolyDataManager:GetActData(self.activityId)
  if not activityDetailData then
    return
  end
  local autoDiceNum = activityDetailData.autoDiceNum
  local autoDiceDoubleNum = activityDetailData.autoDiceDoubleNum
  local autoDiceCost = activityDetailData.autoDiceCost
  local autoDiceDiamond = activityDetailData.autoDiceDiamond
  local sep1 = "|"
  local sep2 = ","
  local sep3 = ";"
  local costStr = activityInfo.para_4
  local oneTypeCostStr = string.split(costStr, sep1)
  local costData = {}
  if #oneTypeCostStr == 2 then
    local typeCostStr = oneTypeCostStr[2]
    local costRewardStr = string.split(typeCostStr, sep2)
    for j = 1, #costRewardStr do
      local rewardStr = costRewardStr[j]
      local rewardParam = string.split(rewardStr, sep3)
      if #rewardParam == 3 then
        local type = tonumber(rewardParam[1])
        local itemId = tonumber(rewardParam[2])
        local count = tonumber(rewardParam[3])
        local rewardType = type
        if type == 1 then
          rewardType = ResTypeToReward[itemId]
        end
        local rewardData = {
          type = rewardType,
          itemId = itemId,
          count = count
        }
        table.insert(costData, rewardData)
      end
    end
  end
  local cost1Name = ""
  local cost2Name = ""
  if #costData == 2 then
    cost1Name = DataCenter.RewardManager:GetNameByType(costData[1].type, costData[1].itemId)
    cost2Name = DataCenter.RewardManager:GetNameByType(costData[2].type, costData[2].itemId)
  end
  local costStr = ""
  if 0 < autoDiceCost then
    costStr = costStr .. cost1Name .. "\195\151" .. autoDiceCost
  end
  if 0 < autoDiceDiamond then
    local language = Localization:GetLanguage()
    if language == Language.Japanese then
      costStr = costStr .. "\227\128\129" .. cost2Name .. "\195\151" .. autoDiceDiamond
    else
      costStr = costStr .. "," .. cost2Name .. "\195\151" .. autoDiceDiamond
    end
  end
  if 0 < autoDiceNum and 0 < autoDiceDoubleNum then
    self.tip_text3_content:SetLocalText("activity_sports_uitips_036", autoDiceNum, autoDiceDoubleNum, costStr)
  elseif 0 < autoDiceNum then
    self.tip_text3_content:SetLocalText("activity_sports_uitips_034", autoDiceNum, costStr)
  elseif 0 < autoDiceDoubleNum then
    self.tip_text3_content:SetLocalText("activity_sports_uitips_035", autoDiceDoubleNum, costStr)
  end
end

return UIActMonopolyBoxRewardView
