local CookingScoreDetail = BaseClass("CookingScoreDetail", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local CookingRewardBoxItem = require("UI.UIActivityCenterTable.Component.ThanksGiving.Cooking.CookingRewardBoxItem")

function CookingScoreDetail:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CookingScoreDetail:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CookingScoreDetail:ComponentDefine()
  self._title_txt = self:AddComponent(UIText, "BG/BG (2)/Title")
  self._title_txt:SetLocalText("thanksactivity_UI016")
  self._slider = self:AddComponent(UISlider, "RewardRect/ViewPort/Content/Slider")
  self._box_scroll_rect = self:AddComponent(UIScrollRect, "RewardRect")
  self._reward_content = self:AddComponent(UIBaseContainer, "RewardRect/ViewPort/Content/RewardContent")
  self._score_detail_close_btn = self:AddComponent(UIButton, "ClickMask")
  self._score_detail_close_btn:SetOnClick(function()
    self:OnClickCloseScore()
  end)
end

function CookingScoreDetail:OnEnable()
  base.OnEnable(self)
  self:RefreshRewardBox()
end

function CookingScoreDetail:OnDisable()
  base.OnDisable(self)
end

function CookingScoreDetail:DataDefine()
end

function CookingScoreDetail:DataDestroy()
  self.boxList = nil
  self.boxDataList = nil
end

function CookingScoreDetail:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActGiftBoxScoreRewardReceive, self.OnRewardReceive)
  self:AddUIListener(EventId.ActCookingScoreRewardReceive, self.OnRewardReceive)
end

function CookingScoreDetail:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActGiftBoxScoreRewardReceive, self.OnRewardReceive)
  self:RemoveUIListener(EventId.ActCookingScoreRewardReceive, self.OnRewardReceive)
end

function CookingScoreDetail:OnRewardReceive()
  self:RefreshRewardBox()
end

function CookingScoreDetail:ReInit(activityId, selfScore)
  self.activityId = activityId
  self.selfScore = selfScore
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self.baseActData = activityInfo
  self:RefreshRewardBox()
  self:RefreshSlider()
end

function CookingScoreDetail:SetAllCellDestroy()
  self._reward_content:RemoveComponents(CookingRewardBoxItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function CookingScoreDetail:RefreshSlider()
  local count = #self.boxDataList
  local haveReachedIndex = 0
  local nextIndex = 0
  for k, v in ipairs(self.boxDataList) do
    if self.selfScore >= self.boxDataList[k].targetScore then
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
    self._slider:SetValue(haveReachedIndex / count + (self.selfScore - curStageScore) / (nextStageScore - curStageScore) / count)
  end
end

function CookingScoreDetail:RefreshRewardBox()
  if self.baseActData then
    if self.baseActData.type == EnumActivity.GiftBoxActivity.Type then
      self.boxDataList = DataCenter.ActGiftBoxData:GetActScoreBoxListById(tonumber(self.activityId))
    elseif self.baseActData.type == EnumActivity.Cooking.Type then
      self.boxDataList = DataCenter.ActCookingData:GetActScoreList()
    end
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
          local cell = self._reward_content:AddComponent(CookingRewardBoxItem, go.name)
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
end

function CookingScoreDetail:OnClickCloseScore()
  if self.baseActData.type == EnumActivity.GiftBoxActivity.Type then
    EventManager:GetInstance():Broadcast(EventId.ActGiftBoxCloseScoreDetail)
  elseif self.baseActData.type == EnumActivity.Cooking.Type then
    EventManager:GetInstance():Broadcast(EventId.ActCookingCloseScoreDetail)
  end
end

function CookingScoreDetail:ScrollToTargetIndex()
  for k, v in ipairs(self.boxDataList) do
    if v.state == 0 then
      self._box_scroll_rect:SetHorizontalNormalizedPosition(k / table.count(self.boxDataList))
      return
    end
  end
  self._box_scroll_rect:SetHorizontalNormalizedPosition(1)
end

return CookingScoreDetail
