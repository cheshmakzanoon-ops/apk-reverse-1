local base = UIBaseContainer
local rewardBoxItem = BaseClass("rewardBoxItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UILWRewardPreviewView = require("UI.UISurfing.UIAct.RewardPreview.View.UILWRewardPreviewView")
local SimpleAnimation = typeof(CS.SimpleAnimation)

function rewardBoxItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function rewardBoxItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function rewardBoxItem:ComponentDefine()
  self.imgOpen = self:AddComponent(UIButton, "openImg")
  self.imgOpen:SetOnClick(function()
    self:ViewReward()
  end)
  self.imgNotOpen = self:AddComponent(UIImage, "notOpenImg")
  local skin = self.gameObject.transform:Find("notOpenImg")
  self.animation = skin:GetComponent(SimpleAnimation)
  self.imgNotOpenBtn = self:AddComponent(UIButton, "notOpenImg")
  self.imgNotOpenBtn:SetOnClick(function()
    self:OnNotOpenBtnClick()
  end)
  self.textPersonalScore = self:AddComponent(UITextMeshProUGUIEx, "personalScoreText")
  self.slider = self:AddComponent(UISlider, "mask/Slider")
  self.effect = self:AddComponent(UIBaseContainer, "effect")
end

function rewardBoxItem:ComponentDestroy()
  self.imgOpen = nil
  self.imgNotOpen = nil
  self.textPersonalScore = nil
  self.slider = nil
end

function rewardBoxItem:DataDefine()
end

function rewardBoxItem:DataDestroy()
end

function rewardBoxItem:ReInit(data, index)
  self.rewardData = data
  if self.rewardData.state == TaskState.CanReceive or self.rewardData.state == TaskState.Received then
    self.slider:SetValue(1)
  else
    self.slider:SetValue(DataCenter.LWSurfingDataManager:GetNowSelectBoxSliderValue(index))
  end
  local num = GetTableData(TableName.lw_parkour_battle_pass, self.rewardData.id, "score")
  self.textPersonalScore:SetText(string.GetFormattedStr(num))
  local icons = GetTableData(TableName.lw_parkour_battle_pass, self.rewardData.id, "icon")
  if icons and 1 < #icons then
    self.imgNotOpen:LoadSprite(string.format(LoadPath.SurfingBattlePassBoxIconPath, icons[1]))
    self.imgOpen:LoadSprite(string.format(LoadPath.SurfingBattlePassBoxIconPath, icons[2]))
  end
  self.imgNotOpen.gameObject:SetActive(self.rewardData.state ~= TaskState.Received)
  self.imgOpen.gameObject:SetActive(self.rewardData.state == TaskState.Received)
  self.effect.gameObject:SetActive(self.rewardData.state == TaskState.CanReceive)
  if self.animation then
    if self.rewardData.state == TaskState.CanReceive then
      self.animation:Play("Default")
    else
      self.animation:Stop()
    end
  end
end

function rewardBoxItem:GetRewardState()
  return self.rewardData.state == TaskState.CanReceive
end

function rewardBoxItem:OnNotOpenBtnClick()
  if self:GetRewardState() then
    local round = DataCenter.LWSurfingDataManager:GetRound()
    DataCenter.LWSurfingDataManager:ReceiveRewardParkourBattlePassMessage(round, SurfingBattlePassType.Personal, 0)
  else
    self:ViewReward()
  end
end

function rewardBoxItem:ViewReward()
  local param = UILWRewardPreviewView.ParamDataClass.New()
  param.position = self.imgNotOpenBtn.transform.position
  param.arrowDeltaY = 30
  param.showRewardList = self.rewardData.reward
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWRewardPreviewView, {anim = false}, param)
end

function rewardBoxItem:OnAddListener()
  base.OnAddListener(self)
end

function rewardBoxItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return rewardBoxItem
