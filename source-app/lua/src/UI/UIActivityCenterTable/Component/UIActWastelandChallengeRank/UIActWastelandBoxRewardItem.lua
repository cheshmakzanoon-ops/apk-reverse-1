local base = UIBaseContainer
local UIActWastelandBoxRewardItem = BaseClass("UIActWastelandBoxRewardItem", UIBaseContainer)
local UIActWastelandBoxComponent = require("UI.UIActivityCenterTable.Component.UIActWastelandChallengeRank.UIActWastelandBoxComponent")
local Localization = CS.GameEntry.Localization
local img_arrow_right_path = "imgArrowRight"
local img_arrowleft_path = "imgArrowleft"
local box_reward_path = "boxReward"
local content_path = "ScrollView/Viewport/Content"
local slider_path = "ScrollView/Viewport/Content/Slider"
local head_icon_path = "scoreIcon/HeadIcon"
local scroe_text_path = "scoreIcon/scroeText"
local scroll_view_path = "ScrollView"
local score_icon_path = "scoreIcon"

function UIActWastelandBoxRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActWastelandBoxRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActWastelandBoxRewardItem:ComponentDefine()
  self.img_arrow_right = self:AddComponent(UIImage, img_arrow_right_path)
  self.img_arrowleft = self:AddComponent(UIImage, img_arrowleft_path)
  self.box_reward = self:AddComponent(UIBaseContainer, box_reward_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.head_icon = self:AddComponent(CircleImage, head_icon_path)
  self.scroe_text = self:AddComponent(UITextMeshProUGUIEx, scroe_text_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.btn_score = self:AddComponent(UIButton, score_icon_path)
  self.btn_score:SetOnClick(BindCallback(self, self.ClickScoreIcon))
  self.scroll_view:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

function UIActWastelandBoxRewardItem:ComponentDestroy()
  self.img_arrow_right = nil
  self.img_arrowleft = nil
  self.box_reward = nil
  self.content = nil
  self.slider = nil
  self.head_icon = nil
  self.scroe_text = nil
  self.scroll_view = nil
  self.btn_score = nil
end

function UIActWastelandBoxRewardItem:DataDefine()
  self.itemIndex = 0
  self.nowScore = 0
  self.textList = {}
end

function UIActWastelandBoxRewardItem:DataDestroy()
  if self.slider then
    self.slider:SetValue(0)
  end
  self:ClearScroll()
  self.initProgress = nil
  self.itemIndex = nil
  self.nowScore = nil
  self.textList = nil
  self.jumpIndex = nil
end

function UIActWastelandBoxRewardItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonRefreshWastelandBoxInfo, self.Refresh)
  self:AddUIListener(EventId.SeasonRefreshWastelandDataChange, self.Refresh)
end

function UIActWastelandBoxRewardItem:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonRefreshWastelandBoxInfo, self.Refresh)
  self:RemoveUIListener(EventId.SeasonRefreshWastelandDataChange, self.Refresh)
  base.OnRemoveListener(self)
end

function UIActWastelandBoxRewardItem:ClickScoreIcon()
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.TreasureBoxTimeTip)
  param.contentText = Localization:GetString("season_monster_activity_kill_record", self.rewardList.score or 0)
  param.alignObject = self.btn_score
  param.yPosFix = 30
  param.addPosX = 0 * CommonUtil.ArabicAutoMirrorFactor()
  param.showArrow = true
  param.preferTop = false
  param.unEnableTouchThrough = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActShowTextTipView, {anim = true}, param)
end

function UIActWastelandBoxRewardItem:ClearScroll()
  self.content:RemoveComponents(UIActWastelandBoxComponent)
  self.scroll_view:ClearAllItems()
end

function UIActWastelandBoxRewardItem:ReInit(activityId)
  self:Refresh(activityId)
  SFSNetwork.SendMessage(MsgDefines.GetSeasonWastelandBoxInfo, activityId)
end

function UIActWastelandBoxRewardItem:Refresh(activityId)
  self.activityId = activityId
  self.rewardList = DataCenter.LWSeasonWastelandDataManager:GetBoxRewardByActivityId(activityId)
  self.nowScore = self.rewardList.score
  if not table.IsNullOrEmpty(self.rewardList) then
    if not self.initProgress then
      self:InitProgress(#self.rewardList)
      self.initProgress = true
    end
    self:UpdateRewardList(true)
  end
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if not string.IsNullOrEmpty(actData.para_7) then
    self.head_icon:LoadSprite(actData.para_7)
  end
end

function UIActWastelandBoxRewardItem:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rewardList then
    return nil
  end
  local packData = self.rewardList[index]
  local item = loopScroll:NewListViewItem("boxReward")
  local script = self.content:GetComponent(item.gameObject.name, UIActWastelandBoxComponent)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(UIActWastelandBoxComponent, objectName)
  end
  script:SetActive(true)
  script:ReInit(packData, self.nowScore, self.activityId)
  return item
end

function UIActWastelandBoxRewardItem:RefreshRewardList(jump)
  if table.IsNullOrEmpty(self.rewardList) then
    self.scroll_view:SetActive(false)
  else
    self.scroll_view:SetActive(true)
    self.scroll_view:SetListItemCount(#self.rewardList, false, false)
    self.scroll_view:RefreshAllShownItem()
    if not self.initProgress then
      self:InitProgress(#self.rewardList)
      self.initProgress = true
    end
    if jump then
      local jumpIndex = 1
      local maxTarget = -math.huge
      local findIt = false
      for i, v in ipairs(self.rewardList) do
        if maxTarget < v.target and v.isReward == 0 and v.target <= self.nowScore then
          maxTarget = v.target
          jumpIndex = i
          findIt = true
        end
      end
      if not findIt then
        for i, v in ipairs(self.rewardList) do
          if maxTarget < v.target and v.isReward == 1 and v.target <= self.nowScore then
            maxTarget = v.target
            jumpIndex = i
          end
        end
      end
      if 3 < jumpIndex then
        jumpIndex = jumpIndex - 3
      elseif jumpIndex <= 3 then
        jumpIndex = 0
      end
      self.jumpIndex = jumpIndex
      self.scroll_view:MovePanelToItemIndex(jumpIndex)
    end
  end
end

function UIActWastelandBoxRewardItem:UpdateRewardList(jump)
  self:RefreshRewardList(jump)
  self:RefreshScore()
end

local itemLength = 150
local spacing = -8

function UIActWastelandBoxRewardItem:InitProgress(count)
  if self.slider then
    local length = count * itemLength + spacing * (count - 1) - 60
    length = length < 0 and 0 or length
    self.slider.transform:Set_sizeDelta(length, 36)
  end
end

function UIActWastelandBoxRewardItem:RefreshScore()
  local score = self.nowScore
  self.scroe_text:SetLocalText("season_monster_kill_level", score)
  local progress = 0
  if not table.IsNullOrEmpty(self.rewardList) and self.scroll_view then
    local step = 1 / #self.rewardList
    local firstStep = step / 2
    local otherStep = (1 - firstStep) / (#self.rewardList - 1)
    local lastNeedScore = 0
    for i, v in ipairs(self.rewardList) do
      local curStageStep = i == 1 and firstStep or otherStep
      if v.isReward == 1 or score >= v.target then
        progress = progress + curStageStep
        lastNeedScore = v.target
      else
        progress = progress + curStageStep * (score - lastNeedScore) / (v.target - lastNeedScore)
        break
      end
    end
    progress = 1 < progress and 1 or progress
  end
  self.slider:SetValue(progress)
end

return UIActWastelandBoxRewardItem
