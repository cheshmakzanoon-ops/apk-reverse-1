local UIRebateNewActivityPackageRewardView = BaseClass("UIRebateNewActivityPackageRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIRebateNewActivityPackageRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:UpdateUI()
end

function UIRebateNewActivityPackageRewardView:OnDestroy()
  self:ClearLuckyScroll()
  self:ClearNormalScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRebateNewActivityPackageRewardView:ComponentDefine()
  self.textOtherTitle = self:AddComponent(UIText, "SpecialBg/OtherTitleBg/OtherTitleText")
  self.textOtherTitle:SetText(Localization:GetString("320320"))
  self.textNormalTitle = self:AddComponent(UIText, "layout/NormalTitle")
  self.textNormalTitle:SetText(Localization:GetString("total_mobilization_desc12"))
  self.compNormalScrollView = self:AddComponent(UIScrollView, "layout/NormalScrollView")
  self.compNormalScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnNormalCellMoveIn(itemObj, index)
  end)
  self.compNormalScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnNormalCellMoveOut(itemObj, index)
  end)
  self.compNormalContent = self:AddComponent(UIBaseContainer, "layout/NormalScrollView/Viewport/NormalContent")
  self.textLuckyTitle = self:AddComponent(UIText, "layout/LuckyTitle")
  self.textLuckyTitle:SetText(Localization:GetString("total_mobilization_desc14"))
  self.textLuckySpecialTitle = self:AddComponent(UIText, "layout/LuckySpecialTitle")
  self.textLuckySpecialTitle:SetText(Localization:GetString("total_mobilization_desc13"))
  self.compLuckyScrollView = self:AddComponent(UIScrollView, "layout/LuckyScrollView")
  self.compLuckyScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnLuckyCellMoveIn(itemObj, index)
  end)
  self.compLuckyScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnLuckyCellMoveOut(itemObj, index)
  end)
  self.compLuckyContent = self:AddComponent(UIBaseContainer, "layout/LuckyScrollView/Viewport/LuckyContent")
  self.btnClaim = self:AddComponent(UIButton, "BtnClaim")
  self.btnClaim:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.textClaim = self:AddComponent(UIText, "BtnClaim/Btn/TextClaim")
  self.textClaim:SetText(Localization:GetString("total_mobilization_desc15"))
  self.btnSkipAnimButton = self:AddComponent(UIButton, "SkipAnimButton")
  self.btnSkipAnimButton:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UIRebateNewActivityPackageRewardView:ComponentDestroy()
  self.textOtherTitle = nil
  self.textNormalTitle = nil
  self.compNormalScrollView = nil
  self.compNormalContent = nil
  self.textLuckyTitle = nil
  self.textLuckySpecialTitle = nil
  self.compLuckyScrollView = nil
  self.compLuckyContent = nil
  self.btnClaim = nil
  self.textClaim = nil
  self.btnSkipAnimButton = nil
end

function UIRebateNewActivityPackageRewardView:DataDefine()
  self.param = self:GetUserData()
end

function UIRebateNewActivityPackageRewardView:DataDestroy()
  self.param = nil
end

function UIRebateNewActivityPackageRewardView:OnAddListener()
  base.OnAddListener(self)
end

function UIRebateNewActivityPackageRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIRebateNewActivityPackageRewardView:UpdateUI()
  local function HasBigReward()
    local rewards = {}
    
    local buyClass = DataCenter.ActivityRebateNewManager:GetBuyClassCache()
    if buyClass ~= nil and 0 < buyClass then
      local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.param.activityId)
      if activityData ~= nil and activityData.para_6 ~= nil then
        local splitedStr = string.split(tostring(activityData.para_6), "|")
        if splitedStr ~= nil then
          for i, v in pairs(splitedStr) do
            if i == buyClass then
              local rewardDataStrList = string.split(v, ";")
              if rewardDataStrList ~= nil then
                for _, singleStr in pairs(rewardDataStrList) do
                  local idNumStrList = string.split(singleStr, ",")
                  if idNumStrList ~= nil and #idNumStrList == 2 then
                    local rewardId = checknumber(idNumStrList[1])
                    local num = checknumber(idNumStrList[2])
                    table.insert(rewards, {id = rewardId, num = num})
                  end
                end
              end
            end
          end
        end
      end
    end
    if self.param.luckyRewards ~= nil then
      for i, v in pairs(rewards) do
        for _, reward in pairs(self.param.luckyRewards) do
          if tostring(reward.itemId) == tostring(v.id) and reward.count >= v.num then
            return true
          end
        end
      end
    end
    return false
  end
  
  if self.param == nil then
    return
  end
  self:ClearNormalScroll()
  local hasNormalRewards = not table.IsNullOrEmpty(self.param.normalRewards)
  self.textNormalTitle:SetActive(hasNormalRewards)
  self.compNormalScrollView:SetActive(hasNormalRewards)
  if hasNormalRewards then
    self.compNormalScrollView:SetTotalCount(#self.param.normalRewards)
    self.compNormalScrollView:RefillCells()
  end
  self:ClearLuckyScroll()
  local hasLuckyRewards = not table.IsNullOrEmpty(self.param.luckyRewards)
  self.textLuckyTitle:SetActive(hasLuckyRewards)
  self.textLuckySpecialTitle:SetActive(hasLuckyRewards)
  self.compLuckyScrollView:SetActive(hasLuckyRewards)
  if hasLuckyRewards then
    local hasBigReward = HasBigReward()
    self.textLuckyTitle:SetActive(not hasBigReward)
    self.textLuckySpecialTitle:SetActive(hasBigReward)
    self.compLuckyScrollView:SetTotalCount(#self.param.luckyRewards)
    self.compLuckyScrollView:RefillCells()
  end
end

function UIRebateNewActivityPackageRewardView:OnBtnClaimClick()
end

function UIRebateNewActivityPackageRewardView:OnBtnSkipAnimButtonClick()
end

function UIRebateNewActivityPackageRewardView:ClearNormalScroll()
  self.compNormalScrollView:ClearCells()
  self.compNormalScrollView:RemoveComponents(UICommonResItem)
end

function UIRebateNewActivityPackageRewardView:ClearLuckyScroll()
  self.compLuckyScrollView:ClearCells()
  self.compLuckyScrollView:RemoveComponents(UICommonResItem)
end

function UIRebateNewActivityPackageRewardView:OnNormalCellMoveIn(itemObj, index)
  itemObj.name = "normal" .. tostring(index)
  local cellItem = self.compNormalScrollView:AddComponent(UICommonResItem, itemObj)
  if self.param ~= nil and self.param.normalRewards ~= nil and self.param.normalRewards[index] ~= nil then
    cellItem:ReInit(self.param.normalRewards[index])
  end
end

function UIRebateNewActivityPackageRewardView:OnNormalCellMoveOut(itemObj, index)
  self.compNormalScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function UIRebateNewActivityPackageRewardView:OnLuckyCellMoveIn(itemObj, index)
  itemObj.name = "lucky" .. tostring(index)
  local cellItem = self.compLuckyScrollView:AddComponent(UICommonResItem, itemObj)
  if self.param ~= nil and self.param.luckyRewards ~= nil and self.param.luckyRewards[index] ~= nil then
    cellItem:ReInit(self.param.luckyRewards[index])
  end
end

function UIRebateNewActivityPackageRewardView:OnLuckyCellMoveOut(itemObj, index)
  self.compLuckyScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

return UIRebateNewActivityPackageRewardView
