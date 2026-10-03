local base = UIBaseContainer
local boxRewardComponent = BaseClass("boxRewardComponent", UIBaseContainer)
local UILWRewardPreviewView = require("UI.UISurfing.UIAct.RewardPreview.View.UILWRewardPreviewView")
local Localization = CS.GameEntry.Localization

function boxRewardComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function boxRewardComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function boxRewardComponent:ComponentDefine()
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
end

function boxRewardComponent:ComponentDestroy()
  self.viewSkin = nil
  self.effectCanGet = nil
  self.btnReward = nil
  self.imgGet = nil
  self.text = nil
  self.effectFlyFinish = nil
end

function boxRewardComponent:DataDefine()
  self.rewardData = nil
end

function boxRewardComponent:DataDestroy()
  self.rewardData = nil
end

function boxRewardComponent:OnAddListener()
  base.OnAddListener(self)
end

function boxRewardComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function boxRewardComponent:OnBtnRewardClick()
  if self.rewardData.isReward == 1 or self.rewardData.target > self.nowScore then
    self:ViewReward()
  elseif self.rewardData.target <= self.nowScore then
    DataCenter.DigTreasureBoxRewardManager:SendGetBoxRewardMessage()
  end
end

function boxRewardComponent:ViewReward()
  local param = UILWRewardPreviewView.ParamDataClass.New()
  param.position = self.btnReward.transform.position
  param.arrowDeltaY = 30
  param.showRewardList = self.rewardData.rewardInfo
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWRewardPreviewView, {anim = false}, param)
end

function boxRewardComponent:ReInit(data, score)
  self.rewardData = data
  self.nowScore = score
  self.text:SetText(data.target)
  if data.isReward == 1 then
    self.imgGet.gameObject:SetActive(true)
    self.effectCanGet.gameObject:SetActive(false)
  elseif data.isReward == 0 then
    self.imgGet.gameObject:SetActive(false)
    if score >= data.target then
      self.effectCanGet.gameObject:SetActive(true)
    else
      self.effectCanGet.gameObject:SetActive(false)
    end
  end
  if data.quality == 5 then
    self.imgReward:LoadSpriteAsync("Assets/Main/Sprites/UI/UIDigTreasure/lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_jin2.png")
  else
    self.imgReward:LoadSpriteAsync("Assets/Main/Sprites/UI/UIDigTreasure/lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_yin2.png")
  end
end

return boxRewardComponent
