local base = UIBaseContainer
local UIActCrazyRockRewardPreviewItem = BaseClass("UIActCrazyRockRewardPreviewItem", base)
local Localization = CS.GameEntry.Localization
local M = UIActCrazyRockRewardPreviewItem
local level_path = "Level"
local score_path = "Score"
local score_text_path = "ScoreText"
local reward_scroll_path = "RewardScroll"
local content_path = "RewardScroll/Viewport/Content"
local bg_path = "Bg"
local levelIconMap = {
  [1] = "Assets/Main/Sprites/UI/ActCrazyRockRewardPreview/lyt_2025yinyuejie_fengkuangyaogun_shuomings.png",
  [2] = "Assets/Main/Sprites/UI/ActCrazyRockRewardPreview/lyt_2025yinyuejie_fengkuangyaogun_shuominga.png",
  [3] = "Assets/Main/Sprites/UI/ActCrazyRockRewardPreview/lyt_2025yinyuejie_fengkuangyaogun_shuomingb.png"
}

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.level = self:AddComponent(UIImage, level_path)
  self.score = self:AddComponent(UITextMeshProUGUIEx, score_path)
  self.scoreText = self:AddComponent(UITextMeshProUGUIEx, score_text_path)
  self.rewardScroll = self:AddComponent(UILoopListView2, reward_scroll_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.rewardScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.scoreText:SetLocalText("activity_concert_24")
  self.bg = self:AddComponent(UIRawImage, bg_path)
end

function M:ComponentDestroy()
  self.level = nil
  self.score = nil
  self.scoreText = nil
  self.rewardScroll = nil
  self.content = nil
  self.bg = nil
end

function M:DataDefine()
  self.itemIndex = 0
  self.rewardList = {}
end

function M:DataDestroy()
  self.itemIndex = nil
  self.rewardList = nil
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  self:ClearScroll()
  base.OnDisable(self)
end

function M:SetData(data, actId, showConfig)
  self.rewardData = data
  self.activityId = actId
  self.rewardList = data.rewardArr
  self.showConfig = showConfig
  self:RefreshAll()
end

function M:RefreshAll()
  self:RefreshBg()
  self:RefreshReward()
  self:RefreshLevel()
end

function M:RefreshBg()
  if not self.showConfig or string.IsNullOrEmpty(self.showConfig.board_list_tiao) then
    Logger.LogError("showConfig is nil")
    return
  end
  self.bg:LoadSpriteAsync(self.showConfig.board_list_tiao)
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rewardList then
    return nil
  end
  self.itemIndex = self.itemIndex or 0
  local data = self.rewardList[index]
  local item = loopScroll:NewListViewItem("UICommonResItem")
  local cell = self.content:GetComponent(item.gameObject.name, UICommonResItem)
  if cell == nil then
    item.name = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    cell = self.content:AddComponent(UICommonResItem, item.name)
  end
  cell:SetLocalScaleXYZ(0.85, 0.85, 1)
  cell:SetSizeDelta(Vector2.New(118, 118))
  cell:SetActive(true)
  cell:ParseInfo(data)
  return item
end

function M:RefreshReward()
  if not self.rewardList then
    Logger.LogError("rewardList is nil")
    return
  end
  self.rewardScroll:SetListItemCount(#self.rewardList, false, false)
  self.rewardScroll:RefreshAllShownItem()
end

function M:RefreshLevel()
  local index = self.rewardData.index or 0
  if index < 1 or index > table.length(levelIconMap) then
    Logger.LogError("index is out of range: " .. index)
    return
  end
  self.level:LoadSprite(levelIconMap[index])
  local scoreRange = ""
  if index == 1 then
    local begin = self.rewardData.beginNum or 0
    scoreRange = Localization:GetString("activity_concert_23", begin)
  else
    local begin = self.rewardData.beginNum or 0
    local endNum = self.rewardData.endNum or 0
    scoreRange = Localization:GetString("activity_concert_25", begin, endNum)
  end
  self.score:SetText(scoreRange)
end

function M:ClearScroll()
  self.content:RemoveComponents(UICommonResItem)
  self.rewardScroll:ClearAllItems()
end

return UIActCrazyRockRewardPreviewItem
