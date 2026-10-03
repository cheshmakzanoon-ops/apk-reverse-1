local WorldZombieRushDes = BaseClass("WorldZombieRushDes", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local round_text_path = "RoundContent/HorLayout/RoundText"
local state_text_path = "StateText"
local time_text_path = "TimeContent/HorLayout/TimeText"
local detail_btn_path = "DetailInfoContent/DetailBtn"
local tips_text_path = "DetailInfoContent/TipsText"
local progress_path = "DetailInfoContent/Progress"
local progress_text_path = "DetailInfoContent/Progress/ProgressText"
local reward_scroll_view_path = "DetailInfoContent/RewardScrollView"
local detail_info_content_path = "DetailInfoContent"
local reward_tips_text_path = "DetailInfoContent/RewardTipsText"

function WorldZombieRushDes:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function WorldZombieRushDes:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function WorldZombieRushDes:ComponentDefine()
  self.round_text = self:AddComponent(UITextMeshProUGUIEx, round_text_path)
  self.state_text = self:AddComponent(UITextMeshProUGUIEx, state_text_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
  self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  self.progress = self:AddComponent(UISlider, progress_path)
  self.progress_text = self:AddComponent(UITextMeshProUGUIEx, progress_text_path)
  self.detail_info_content = self:AddComponent(UIBaseContainer, detail_info_content_path)
  self.reward_tips_text = self:AddComponent(UITextMeshProUGUIEx, reward_tips_text_path)
  self.reward_scroll_view = self:AddComponent(UIScrollView, reward_scroll_view_path)
  self.reward_scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.reward_scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.tips_text:SetLocalText("zombieRush_title_07")
  self.detail_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIZombieRushReward, {anim = true}, self.data.templateId)
  end)
end

function WorldZombieRushDes:ComponentDestroy()
  self:ClearScroll()
  self.round_text = nil
  self.state_text = nil
  self.time_text = nil
  self.detail_btn = nil
  self.tips_text = nil
  self.progress = nil
  self.progress_text = nil
  self.reward_scroll_view = nil
  self.detail_info_content = nil
  self.reward_tips_text = nil
end

function WorldZombieRushDes:OnAddListener()
  base.OnAddListener(self)
end

function WorldZombieRushDes:OnRemoveListener()
  base.OnRemoveListener(self)
end

function WorldZombieRushDes:Update100MS()
  self:UpdateTime()
end

function WorldZombieRushDes:RefreshData(param)
  self.data = param
  local template = DataCenter.LWZombieRushTemplateManager:GetTemplate(self.data.templateId)
  if template then
    local maxValue = template:GetMaxRoundValue()
    self.round_text:SetText(Localization:GetString("zombieRush_tips_10", self.data.round, maxValue))
  end
  if self.data.state == ZombieRushAllianceStatus.Ready then
    self.state_text:SetLocalText("zombieRush_state_01")
  elseif self.data.state == ZombieRushAllianceStatus.InBattle then
    self.state_text:SetLocalText("zombieRush_state_02")
  elseif self.data.state == ZombieRushAllianceStatus.Prepare then
    self.state_text:SetLocalText("zombieRush_tips_29")
  end
  self.detail_info_content:SetActive(self.worldPointDetailData ~= nil)
  if self.worldPointDetailData ~= nil then
    self:RefreshDetailInfoShow()
  end
  self:UpdateTime()
end

function WorldZombieRushDes:UpdateTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local surplusTime = self.data.stateEndTime - curTime
  if 0 < surplusTime then
    if self.time_text then
      self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    end
  else
    if self.time_text then
      self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
    end
    self.view.ctrl:CloseSelf()
  end
end

function WorldZombieRushDes:UpdateDetailInfo(data)
  self.worldPointDetailData = data
  self.detail_info_content:SetActive(self.worldPointDetailData ~= nil)
  if self.worldPointDetailData ~= nil then
    self:RefreshDetailInfoShow()
  end
end

function WorldZombieRushDes:RefreshDetailInfoShow()
  if self.worldPointDetailData.alBuilding ~= nil then
    self.progress_text:SetText(string.format("%d/%d", self.worldPointDetailData.alBuilding.curRound, self.worldPointDetailData.alBuilding.maxRound))
    local progress = self.worldPointDetailData.alBuilding.curRound / self.worldPointDetailData.alBuilding.maxRound
    self.progress:SetValue(progress)
    local rewardCount = table.count(self.worldPointDetailData.alBuilding.reward)
    self.reward_scroll_view:SetActive(0 < rewardCount)
    self.reward_tips_text:SetActive(rewardCount == 0)
    self:ClearScroll()
    if 0 < rewardCount then
      self.reward_scroll_view:SetTotalCount(rewardCount)
      self.reward_scroll_view:RefillCells()
    else
      self.reward_tips_text:SetLocalText("zombieRush_tips_16")
    end
  end
end

function WorldZombieRushDes:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.reward_scroll_view:AddComponent(UICommonResItem, itemObj)
  itemRender:SetLocalScaleXYZ(0.65, 0.65, 1)
  itemRender:ReInit(self.worldPointDetailData.alBuilding.reward[index])
end

function WorldZombieRushDes:OnRewardItemMoveOut(itemObj, index)
  self.reward_scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

function WorldZombieRushDes:ClearScroll()
  self.reward_scroll_view:ClearCells()
  self.reward_scroll_view:RemoveComponents(UICommonResItem)
end

return WorldZombieRushDes
