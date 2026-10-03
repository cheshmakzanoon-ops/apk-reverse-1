local GiftBoxScoreDetailItem = BaseClass("GiftBoxScoreDetailItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local GiftBoxRewardBoxItem = require("UI.UIActivityCenterTable.Component.GiftBox.GiftBoxRewardBoxItem")

function GiftBoxScoreDetailItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GiftBoxScoreDetailItem:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function GiftBoxScoreDetailItem:ComponentDefine()
  self._title_txt = self:AddComponent(UIText, "BG (2)/Title")
  self._title_txt:SetLocalText(2800050)
  self._slider = self:AddComponent(UISlider, "RewardRect/ViewPort/Content/Slider")
  self._box_scroll_rect = self:AddComponent(UIScrollRect, "RewardRect")
  self._reward_content = self:AddComponent(UIBaseContainer, "RewardRect/ViewPort/Content/RewardContent")
  self._score_detail_close_btn = self:AddComponent(UIButton, "ClickMask")
  self._score_detail_close_btn:SetOnClick(function()
    self:OnClickCloseScore()
  end)
end

function GiftBoxScoreDetailItem:OnEnable()
  base.OnEnable(self)
  if self.boxDataList then
    self:RefreshRewardBox()
  end
end

function GiftBoxScoreDetailItem:OnDisable()
  base.OnDisable(self)
end

function GiftBoxScoreDetailItem:DataDefine()
end

function GiftBoxScoreDetailItem:DataDestroy()
  self.boxList = nil
  self.boxDataList = nil
end

function GiftBoxScoreDetailItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActGiftBoxScoreRewardReceive, self.OnRewardReceive)
end

function GiftBoxScoreDetailItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActGiftBoxScoreRewardReceive, self.OnRewardReceive)
end

function GiftBoxScoreDetailItem:OnRewardReceive()
  self.boxDataList = DataCenter.ActGiftBoxData:GetActScoreBoxListById(tonumber(self.activityId))
  self:RefreshRewardBox()
end

function GiftBoxScoreDetailItem:ReInit(activityId)
  self.activityId = activityId
  self.boxDataList = DataCenter.ActGiftBoxData:GetActScoreBoxListById(tonumber(self.activityId))
  self:RefreshSlider()
  self:RefreshRewardBox()
end

function GiftBoxScoreDetailItem:SetAllCellDestroy()
  self._reward_content:RemoveComponents(GiftBoxRewardBoxItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function GiftBoxScoreDetailItem:RefreshSlider()
  local count = #self.boxDataList
  local selfScore = DataCenter.ActGiftBoxData:GetActScoreById(tonumber(self.activityId))
  local haveReachedIndex = 0
  local nextIndex = 0
  for k, v in ipairs(self.boxDataList) do
    if selfScore >= self.boxDataList[k].targetScore then
      haveReachedIndex = k
    else
      nextIndex = k
      break
    end
  end
  if nextIndex == 0 then
    self._slider:SetValue(1)
  else
    local curStageScore = 0
    if 0 < haveReachedIndex then
      curStageScore = self.boxDataList[haveReachedIndex].targetScore
    end
    local nextStageScore = self.boxDataList[nextIndex].targetScore
    self._slider:SetValue(haveReachedIndex / count + (selfScore - curStageScore) / (nextStageScore - curStageScore) / count)
  end
end

function GiftBoxScoreDetailItem:RefreshRewardBox()
  self:SetAllCellDestroy()
  self.model = {}
  self.boxList = {}
  local count = #self.boxDataList
  if 0 < count then
    for i = 1, count do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UIGiftBoxMainRewardBoxItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._reward_content.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "rewardBox" .. i
        local cell = self._reward_content:AddComponent(GiftBoxRewardBoxItem, go.name)
        cell:ReInit(self.boxDataList[i], tonumber(self.activityId))
        self.boxList[i] = cell
        if i == count then
          self.delay = TimerManager:GetInstance():DelayFrameInvoke(function()
            self:ScrollToTargetIndex()
          end, 5)
        end
      end)
    end
    self._slider.rectTransform.sizeDelta = Vector2.New(count * 120, self._slider.rectTransform.sizeDelta.y)
  end
end

function GiftBoxScoreDetailItem:OnClickCloseScore()
  EventManager:GetInstance():Broadcast(EventId.ActGiftBoxCloseScoreDetail)
end

function GiftBoxScoreDetailItem:ScrollToTargetIndex()
  if self.boxDataList then
    for k, v in ipairs(self.boxDataList) do
      if v.state == 0 then
        self._box_scroll_rect:SetHorizontalNormalizedPosition(k / table.count(self.boxDataList))
        return
      end
    end
    self._box_scroll_rect:SetHorizontalNormalizedPosition(1)
  end
end

return GiftBoxScoreDetailItem
