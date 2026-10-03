local base = UIBaseContainer
local UISurvivorPackRewardItem = BaseClass("UISurvivorPackRewardItem", UIBaseContainer)
local RewardUtil = require("Util.RewardUtil")

function UISurvivorPackRewardItem:SetRewardSelectFrameVisible(show)
  self.selectEffect:SetActive(show)
end

function UISurvivorPackRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UISurvivorPackRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISurvivorPackRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.textProgressTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgBlackBg = self.viewSkin:AddComponent(self, UIImage, 3)
  self.selectEffect = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
end

function UISurvivorPackRewardItem:ComponentDestroy()
  self.viewSkin = nil
  self.compUICommonResItem = nil
  self.textProgressTxt = nil
  self.imgBlackBg = nil
  self.selectEffect = nil
end

function UISurvivorPackRewardItem:DataDefine()
  self._rewardBarData = nil
  self.index = 0
end

function UISurvivorPackRewardItem:DataDestroy()
  self._rewardBarData = nil
  self.index = nil
end

function UISurvivorPackRewardItem:GetScoreItemCount()
  local itemCount = 0
  local scoreItemId = DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.score_item or nil
  if not string.IsNullOrEmpty(scoreItemId) then
    local itemInfo = DataCenter.ItemData:GetItemById(scoreItemId)
    if itemInfo ~= nil and itemInfo.count ~= nil then
      itemCount = tonumber(itemInfo.count) or 0
    end
  end
  return itemCount
end

function UISurvivorPackRewardItem:IsScoreRewardReceived(index)
  local receiveScoreArr = DataCenter.SurvivorPackManager and DataCenter.SurvivorPackManager.receiveScoreArr or nil
  if receiveScoreArr == nil then
    return false
  end
  local idx = tonumber(index)
  if idx == nil then
    return false
  end
  for _, v in ipairs(receiveScoreArr) do
    if tonumber(v) == idx then
      return true
    end
  end
  return false
end

function UISurvivorPackRewardItem:OnBarRewardResItemClick(param)
  SFSNetwork.SendMessage(MsgDefines.SurvivorVisitorReceiveScore, DataCenter.SurvivorPackManager.actData.activityId, self.index)
end

function UISurvivorPackRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function UISurvivorPackRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISurvivorPackRewardItem:SetData(data, index)
  self.index = index
  if data == nil then
    self:SetRewardSelectFrameVisible(false)
    if self.imgBlackBg ~= nil then
      self.imgBlackBg:SetActive(false)
    end
    self:SetActive(false)
    self._rewardBarData = nil
    return
  end
  self._rewardBarData = data
  local score = tonumber(data.score) or 0
  local rewardId = data.rewardId
  local itemCount = self:GetScoreItemCount()
  local canSelect = score <= itemCount
  local isReceived = self:IsScoreRewardReceived(self.index)
  if self.textProgressTxt ~= nil then
    self.textProgressTxt:SetText(tostring(score))
  end
  if self.imgBlackBg ~= nil then
    self.imgBlackBg:SetActive(isReceived)
  end
  if self.compUICommonResItem ~= nil and rewardId ~= nil then
    local rewardIdNum = tonumber(rewardId)
    local rewardList = RewardUtil.GetRewardsById(rewardIdNum)
    local firstReward = rewardList and rewardList[1] or nil
    if firstReward ~= nil and firstReward.itemId ~= nil then
      local reinitParam = {
        rewardType = firstReward.rewardType or RewardType.GOODS,
        itemId = tonumber(firstReward.itemId) or firstReward.itemId,
        count = tonumber(firstReward.count) or 1,
        enableClick = not isReceived
      }
      if canSelect and not isReceived then
        reinitParam.clickCallBack = BindCallback(self, self.OnBarRewardResItemClick)
      end
      self.compUICommonResItem:ReInit(reinitParam)
      if self.compUICommonResItem.SetImgQuailtyShow ~= nil then
        self.compUICommonResItem:SetImgQuailtyShow(true)
      end
      self:SetRewardSelectFrameVisible(not isReceived and canSelect)
    else
      self:SetRewardSelectFrameVisible(false)
      if self.imgBlackBg ~= nil then
        self.imgBlackBg:SetActive(false)
      end
      self:SetActive(false)
      return
    end
  else
    self:SetRewardSelectFrameVisible(false)
    if self.imgBlackBg ~= nil then
      self.imgBlackBg:SetActive(false)
    end
  end
  self:SetActive(true)
end

return UISurvivorPackRewardItem
