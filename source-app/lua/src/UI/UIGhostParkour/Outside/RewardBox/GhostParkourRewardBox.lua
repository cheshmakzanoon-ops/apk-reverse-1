local base = UIBaseContainer
local GhostParkourRewardBox = BaseClass("GhostParkourRewardBox", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UILWRewardPreviewView = require("UI.UISurfing.UIAct.RewardPreview.View.UILWRewardPreviewView")
local SimpleAnimation = typeof(CS.SimpleAnimation)

function GhostParkourRewardBox:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GhostParkourRewardBox:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GhostParkourRewardBox:ComponentDefine()
  self.imgOpen = self:AddComponent(UIButton, "openImg")
  self.imgOpenImg = self:AddComponent(UIImage, "openImg")
  self.imgOpen:SetSafeClickMode(true)
  self.imgOpen:SetOnClick(function()
    self:ViewReward()
  end)
  self.imgNotOpen = self:AddComponent(UIImage, "notOpenImg")
  local skin = self.gameObject.transform:Find("notOpenImg")
  self.animation = skin:GetComponent(SimpleAnimation)
  self.imgNotOpenBtn = self:AddComponent(UIButton, "notOpenImg")
  self.imgNotOpenBtn:SetSafeClickMode(true)
  self.imgNotOpenBtn:SetOnClick(function()
    self:OnNotOpenBtnClick()
  end)
  self.textPersonalScore = self:AddComponent(UITextMeshProUGUIEx, "personalScoreText")
  self.effect = self:AddComponent(UIBaseContainer, "effect")
end

function GhostParkourRewardBox:ComponentDestroy()
  self.imgOpen = nil
  self.imgOpenImg = nil
  self.imgNotOpen = nil
  self.textPersonalScore = nil
end

function GhostParkourRewardBox:DataDefine()
end

function GhostParkourRewardBox:DataDestroy()
end

function GhostParkourRewardBox:ReInit(data)
  self.rewardData = data
  local num = GetTableData(TableName.lw_parkour_battle_pass, self.rewardData.id, "score")
  self.textPersonalScore:SetLocalText("ghost_parkour_task_count", string.GetFormattedStr(num))
  local icons = GetTableData(TableName.lw_parkour_battle_pass, self.rewardData.id, "icon")
  if icons and 1 < #icons then
    self.imgNotOpen:LoadSpriteAuto(string.format(LoadPath.SurfingBattlePassBoxIconPath, icons[1]))
    self.imgOpenImg:LoadSpriteAuto(string.format(LoadPath.SurfingBattlePassBoxIconPath, icons[2]))
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

function GhostParkourRewardBox:GetRewardState()
  return self.rewardData.state == TaskState.CanReceive
end

function GhostParkourRewardBox:OnNotOpenBtnClick()
  if self:GetRewardState() then
    local round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
    DataCenter.LWGhostParkourDataManager:SendRewardGhostParkourBattlePassMessage(round, 0, GhostParkourPassType.Personal)
  else
    self:ViewReward()
  end
end

function GhostParkourRewardBox:ViewReward()
  local param = UILWRewardPreviewView.ParamDataClass.New()
  param.position = self.imgNotOpenBtn.transform.position
  param.arrowDeltaY = 30
  param.showRewardList = self.rewardData.reward
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWRewardPreviewView, {anim = false}, param)
end

function GhostParkourRewardBox:OnAddListener()
  base.OnAddListener(self)
end

function GhostParkourRewardBox:OnRemoveListener()
  base.OnRemoveListener(self)
end

return GhostParkourRewardBox
