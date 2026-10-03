local UIAccuRechargeTargetItem = BaseClass("UIAccuRechargeTargetItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local UICommonResItem = require("UI/UIActivityCenterTable/Component/UIAccuRecharge/UIAccuRechargeResItem")
local UIGray = CS.UIGray
local rewardListPath = "Rect_Reward/Viewport/Content"
local rewardBtnPath = "Btn_Reward"
local rewardBtnTextPath = "Btn_Reward/Txt_Reward"
local targetTextPath = "TargetScoreText"
local scoreIconPath = "ScoreIcon"
local specialBgPath = "SpecialBg"
local complete_content_path = "CompleteContent"

function UIAccuRechargeTargetItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAccuRechargeTargetItem:ComponentDefine()
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardListPath)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtnPath)
  self.rewardBtn:SetOnClick(function()
    self:OnClickReward()
  end)
  self.rewardBtnText = self:AddComponent(UIText, rewardBtnTextPath)
  self.targetText = self:AddComponent(UIText, targetTextPath)
  self.scoreIcon = self:AddComponent(UIImage, scoreIconPath)
  if not IsNull(self.transform:Find(specialBgPath)) then
    self.specialBg = self:AddComponent(UIBaseContainer, specialBgPath)
  end
  self.completeContent = self:TryAddComponent(UIBaseContainer, complete_content_path)
end

function UIAccuRechargeTargetItem:ComponentDestroy()
  self.rewardContent = nil
  self.rewardBtn = nil
  self.rewardBtnText = nil
  self.targetText = nil
  self.scoreIcon = nil
  self.specialBg = nil
end

function UIAccuRechargeTargetItem:OnDestroy()
  base.OnDestroy(self)
end

function UIAccuRechargeTargetItem:OnEnable()
  base.OnEnable(self)
end

function UIAccuRechargeTargetItem:OnDisable()
  base.OnDisable(self)
end

function UIAccuRechargeTargetItem:RefreshData(stageInfo, curScore, actId, pointIcon, curIndex, maxIndex)
  if not stageInfo then
    return
  end
  self.curScore = curScore
  self.actId = actId
  self.stageInfo = stageInfo
  self.targetText:SetText(self.stageInfo.needScore)
  self.state = self.stageInfo.state
  self.rewardList = DeepCopy(self.stageInfo.reward)
  self.curIndex = curIndex
  self.maxIndex = maxIndex
  if self.state == 0 then
    if curScore >= self.stageInfo.needScore then
      UIGray.SetGray(self.rewardBtn.transform, false, true)
      self.rewardBtnText:SetLocalText(2000410)
    else
      UIGray.SetGray(self.rewardBtn.transform, true, false)
      self.rewardBtnText:SetLocalText(2000410)
    end
    if self.completeContent then
      self.completeContent:SetActive(false)
    end
    self.rewardBtn:SetActive(true)
  else
    UIGray.SetGray(self.rewardBtn.transform, true, false)
    self.rewardBtnText:SetLocalText(2000411)
    if self.completeContent then
      self.completeContent:SetActive(true)
      self.rewardBtn:SetActive(false)
    else
      self.rewardBtn:SetActive(true)
    end
  end
  self:RefreshReward(self.rewardList)
  if not string.IsNullOrEmpty(pointIcon) then
    self.scoreIcon:LoadSprite(string.format(LoadPath.ItemPath, pointIcon))
    self.scoreIcon:SetNativeSize()
  else
    self.scoreIcon:LoadSprite(string.format(LoadPath.ItemPath, DefaultRechargePointIconPath))
    self.scoreIcon:SetNativeSize()
  end
  if self.specialBg then
    self.specialBg:SetActive(self.curIndex == self.maxIndex)
  end
end

function UIAccuRechargeTargetItem:SetAllCellDestroy()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if not table.IsNullOrEmpty(self.model) then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function UIAccuRechargeTargetItem:RefreshReward(list)
  self.showList = list
  if not self.model then
    self.model = {}
  end
  local currentRewardCount = 0
  if self.model then
    currentRewardCount = #self.model
  end
  local newRewardCount = #self.showList or 0
  
  local function GetItemName(index)
    return string.format("item%s", index)
  end
  
  if currentRewardCount < newRewardCount then
    for i = currentRewardCount + 1, newRewardCount do
      self.model[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/AccuRecharge/UICommonResItemAccuRecharge.prefab", function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.rewardContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = GetItemName(i)
        local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.showList[i])
        self.showList[i].iconImg = cell:GetIconTrans()
      end)
    end
  elseif currentRewardCount > newRewardCount then
    for i = newRewardCount + 1, currentRewardCount do
      if self.model[i] ~= nil then
        self.rewardContent:RemoveComponent(GetItemName(i), UICommonResItem)
        self:GameObjectDestroy(self.model[i])
        self.model[i] = nil
      end
    end
  end
  for i = 1, newRewardCount do
    if self.model[i] ~= nil then
      local cell = self.rewardContent:GetComponent(GetItemName(i), UICommonResItem)
      if cell ~= nil then
        cell:ReInit(self.showList[i])
        self.showList[i].iconImg = cell:GetIconTrans()
      end
    end
  end
end

function UIAccuRechargeTargetItem:OnClickReward()
  if not self.actId or not self.stageInfo then
    return
  end
  if self.stageInfo.state ~= 0 then
    return
  end
  if self.curScore < self.stageInfo.needScore then
    return
  end
  DataCenter.CumulativeRechargeManager:SendReward(self.actId, self.stageInfo.stageId)
end

function UIAccuRechargeTargetItem:TriggerRewardChangeEffect(stageUpdateData, stageNewData)
  if stageUpdateData ~= nil then
    local cells = self.rewardContent:GetComponents(UICommonResItem)
    if cells then
      for _, cell in pairs(cells) do
        local itemId = cell:GetItemId()
        if tonumber(itemId) == stageUpdateData.newRewardData.itemId then
          cell:PlayUpdateEffect()
        end
      end
    end
  end
  if stageNewData then
    local cells = self.rewardContent:GetComponents(UICommonResItem)
    if cells then
      for _, cell in pairs(cells) do
        local itemId = cell:GetItemId()
        if tonumber(itemId) == stageNewData.rewardData.itemId then
          cell:PlayNewEffect()
        end
      end
    end
  end
end

return UIAccuRechargeTargetItem
