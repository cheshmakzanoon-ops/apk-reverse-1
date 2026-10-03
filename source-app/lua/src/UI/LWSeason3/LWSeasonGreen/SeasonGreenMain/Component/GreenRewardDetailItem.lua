local GreenRewardDetailItem = BaseClass("GreenRewardDetailItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local GreenRewardItem = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenMain.Component.GreenRewardItem")

function GreenRewardDetailItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GreenRewardDetailItem:OnDestroy()
  self:SetAllCellDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function GreenRewardDetailItem:ComponentDefine()
  self._slider = self:AddComponent(UISlider, "RewardRect/ViewPort/Content/Slider")
  self._box_scroll_rect = self:AddComponent(UIScrollRect, "RewardRect")
  self._reward_content = self:AddComponent(UIBaseContainer, "RewardRect/ViewPort/Content")
  self._item = self:AddComponent(UIBaseContainer, "RewardRect/ViewPort/Content/GreenRewardItem")
  self._desc = self:AddComponent(UIText, "desc")
  self._desc:SetLocalText("season_oasis_UI_16")
  self.itemObj = self._item.gameObject
  self.itemObj:GameObjectCreatePool()
  self.itemObj:SetActive(false)
end

function GreenRewardDetailItem:OnEnable()
  base.OnEnable(self)
  if self.rewardInfo then
    self:RefreshRewardBox()
  end
end

function GreenRewardDetailItem:OnDisable()
  base.OnDisable(self)
end

function GreenRewardDetailItem:DataDefine()
end

function GreenRewardDetailItem:DataDestroy()
  self.boxList = nil
  self.rewardInfo = nil
end

function GreenRewardDetailItem:OnAddListener()
  base.OnAddListener(self)
end

function GreenRewardDetailItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GreenRewardDetailItem:ReInit(curNum, rewardInfo, curIndex)
  self.curNum = curNum
  self.rewardInfo = rewardInfo
  self.curIndex = curIndex
  if not self.rewardInfo then
    return
  end
  self:RefreshSlider()
  self:RefreshRewardBox()
end

function GreenRewardDetailItem:SetAllCellDestroy()
  self._reward_content:RemoveComponents(GreenRewardItem)
  self.itemObj:GameObjectRecycleAll()
end

function GreenRewardDetailItem:RefreshSlider()
  local count = #self.rewardInfo
  local selfScore = self.curNum
  local haveReachedIndex = 0
  local nextIndex = 0
  for k, v in ipairs(self.rewardInfo) do
    if selfScore >= v.num then
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
      curStageScore = self.rewardInfo[haveReachedIndex].num
    end
    local nextStageScore = self.rewardInfo[nextIndex].num
    self._slider:SetValue((haveReachedIndex - 1) / (count - 1) + (selfScore - curStageScore) / (nextStageScore - curStageScore) / (count - 1))
  end
end

function GreenRewardDetailItem:RefreshRewardBox()
  self:SetAllCellDestroy()
  self.boxList = {}
  local count = #self.rewardInfo
  local goItem, theItem = 0
  for index = 1, count do
    goItem = self.itemObj:GameObjectSpawn(self._reward_content.transform)
    goItem.name = string.format("rewardItem_%d", index)
    goItem:SetActive(true)
    theItem = self._reward_content:AddComponent(GreenRewardItem, goItem.name)
    theItem:ReInit(index, self.rewardInfo[index], self.curNum)
    self.boxList[index] = theItem
  end
  self._slider.rectTransform.sizeDelta = Vector2.New(self._slider.rectTransform.sizeDelta.x, (count - 1) * 82)
  self:ScrollToTargetIndex()
end

function GreenRewardDetailItem:ScrollToTargetIndex()
  if not self.rewardInfo then
    return
  end
  if self.curIndex then
    local moveIndex = self.curIndex
    if moveIndex <= 1 then
      moveIndex = 0
    end
    self._box_scroll_rect:SetVerticalNormalizedPosition(1 - moveIndex / #self.rewardInfo)
    return
  end
  self._box_scroll_rect:SetVerticalNormalizedPosition(1)
end

return GreenRewardDetailItem
