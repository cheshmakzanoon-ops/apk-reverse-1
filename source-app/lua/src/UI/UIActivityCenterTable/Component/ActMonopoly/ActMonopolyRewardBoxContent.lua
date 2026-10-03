local ActMonopolyRewardBoxContent = BaseClass("ActMonopolyRewardBoxContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local reward_btn_path = "bottomContent/rewardBtn"
local reward_btn_icon_path = "bottomContent/rewardBtn/rewardBtnIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
  self.reward_btn_icon = self:AddComponent(UIImage, reward_btn_icon_path)
  self.reward_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:RewardBtnClick()
  end)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, mainView, activityId, activityInfo, activityDetailData, costData, isBoss)
  self.mainView = mainView
  self.activityId = activityId
  self.activityInfo = activityInfo
  self.activityDetailData = activityDetailData
  self.costData = costData
  self.isBoss = isBoss
  self:RefreshView()
end

local function RefreshView(self)
  self.reward_btn:SetActive(#self.activityDetailData.damageReward > 0)
end

local function RewardBtnClick(self)
  local canClick = self.mainView:CanClickBtn()
  if not canClick then
    return
  end
  if self.activityDetailData.damageReward and #self.activityDetailData.damageReward > 0 then
    if self.activityDetailData.isDamageRewardDataComplete == false then
      SFSNetwork.SendMessage(MsgDefines.RichManDamageRewardView, self.activityId)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActMonopolyBoxReward, {anim = true}, self.activityId)
  end
end

ActMonopolyRewardBoxContent.OnCreate = OnCreate
ActMonopolyRewardBoxContent.OnDestroy = OnDestroy
ActMonopolyRewardBoxContent.ComponentDefine = ComponentDefine
ActMonopolyRewardBoxContent.ComponentDestroy = ComponentDestroy
ActMonopolyRewardBoxContent.DataDefine = DataDefine
ActMonopolyRewardBoxContent.DataDestroy = DataDestroy
ActMonopolyRewardBoxContent.SetData = SetData
ActMonopolyRewardBoxContent.RefreshView = RefreshView
ActMonopolyRewardBoxContent.RewardBtnClick = RewardBtnClick
return ActMonopolyRewardBoxContent
