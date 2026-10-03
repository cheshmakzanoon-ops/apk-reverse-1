local base = UIBaseContainer
local UIActWastelandBoxComponent = BaseClass("UIActWastelandBoxComponent", UIBaseContainer)
local UILWRewardPreviewView = require("UI.UISurfing.UIAct.RewardPreview.View.UILWRewardPreviewView")
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local RewardUtil = require("Util.RewardUtil")
local btn_reward_path = "btnReward"

function UIActWastelandBoxComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActWastelandBoxComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActWastelandBoxComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.effectCanGet = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 2)
  self.imgReward = self:AddComponent(UIImage, "btnReward")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.imgGet = self.viewSkin:AddComponent(self, UIImage, 3)
  self.text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.effectFlyFinish = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.anim_reward = self:AddComponent(UISimpleAnimation, btn_reward_path)
end

function UIActWastelandBoxComponent:ComponentDestroy()
  self.viewSkin = nil
  self.effectCanGet = nil
  self.btnReward = nil
  self.imgGet = nil
  self.text = nil
  self.effectFlyFinish = nil
  self.anim_reward = nil
end

function UIActWastelandBoxComponent:DataDefine()
  self.rewardData = nil
end

function UIActWastelandBoxComponent:DataDestroy()
  self.rewardData = nil
end

function UIActWastelandBoxComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIActWastelandBoxComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActWastelandBoxComponent:OnBtnRewardClick()
  if self.rewardData.isReward == 1 or self.rewardData.target > self.nowScore then
    self:ViewReward()
  elseif self.rewardData.target <= self.nowScore then
    SFSNetwork.SendMessage(MsgDefines.ClaimSeasonWastelandBox, self.activityId, self.rewardData.id)
  end
end

function UIActWastelandBoxComponent:ViewReward()
  local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
  param.position = self.btnReward:GetPosition()
  param.deltaX = -60
  if CommonUtil.IsArabicAutoMirrorOpen() then
    param.dir = param.position.x < -1150 and UIPersonalArmsRewardTipView.Direction.LEFT or UIPersonalArmsRewardTipView.Direction.RIGHT
    param.deltaX = param.dir == UIPersonalArmsRewardTipView.Direction.LEFT and -30 or 30
  else
    param.dir = param.position.x > -1150 and UIPersonalArmsRewardTipView.Direction.RIGHT or UIPersonalArmsRewardTipView.Direction.LEFT
    param.deltaX = param.dir == UIPersonalArmsRewardTipView.Direction.RIGHT and -30 or 30
  end
  param.hideCount = true
  param.rewardList = RewardUtil.GetRewardsById(self.rewardData.reward)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
end

function UIActWastelandBoxComponent:ReInit(data, score, activityId)
  self.rewardData = data
  self.nowScore = score
  self.activityId = activityId
  self.text:SetText(data.target)
  if data.isReward == 1 then
    self.imgGet.gameObject:SetActive(true)
    self.effectCanGet.gameObject:SetActive(false)
    self.imgReward:LoadSpriteAsync(data.received)
    self.anim_reward:Play("Default")
  elseif data.isReward == 0 then
    self.imgGet.gameObject:SetActive(false)
    if score >= data.target then
      self.effectCanGet.gameObject:SetActive(true)
      self.imgReward:LoadSpriteAsync(data.canReceive)
      self.anim_reward:Play("Open")
    else
      self.effectCanGet.gameObject:SetActive(false)
      self.imgReward:LoadSpriteAsync(data.notFinish)
      self.anim_reward:Play("Default")
    end
  end
end

return UIActWastelandBoxComponent
