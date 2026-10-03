local UIAllianceStarMainRewardTipPanel = BaseClass("UIAllianceStarMainRewardTipPanel", UIAsyncContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIAllianceStarMainRewardTipBoxItem = require("UI.UIAllianceStarMain.Component.RewardTip.UIAllianceStarMainRewardTipBoxItem")
local UIAllianceStarMainRewardTipBoxRewardItem = require("UI.UIAllianceStarMain.Component.RewardTip.UIAllianceStarMainRewardTipBoxRewardItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:Refresh()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnCloseBg = self:AddComponent(UIButton, "CloseBg")
  self.btnCloseBg:SetOnClick(function()
    self:OnBtnCloseBgClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Bg/TitleText")
  self.textTip = self:AddComponent(UITextMeshProUGUIEx, "Bg/TipText")
  self.slider = self:AddComponent(UISlider, "Bg/SliderItem/Slider")
  self.compBoxItem1 = self:AddComponent(UIAllianceStarMainRewardTipBoxItem, "Bg/SliderItem/Slider/BoxList/BoxItem1")
  self.compBoxItem2 = self:AddComponent(UIAllianceStarMainRewardTipBoxItem, "Bg/SliderItem/Slider/BoxList/BoxItem2")
  self.compBoxItem3 = self:AddComponent(UIAllianceStarMainRewardTipBoxItem, "Bg/SliderItem/Slider/BoxList/BoxItem3")
  self.compBoxRewardItem1 = self:AddComponent(UIAllianceStarMainRewardTipBoxRewardItem, "Bg/BoxRewardItem1")
  self.compBoxRewardItem2 = self:AddComponent(UIAllianceStarMainRewardTipBoxRewardItem, "Bg/BoxRewardItem2")
  self.compBoxRewardItem3 = self:AddComponent(UIAllianceStarMainRewardTipBoxRewardItem, "Bg/BoxRewardItem3")
  self.sliderFullLen = self.slider:GetSizeDelta().x
  self.sliderNodeProgress = {}
  self.curTargetScores = {}
  for i = 1, 3 do
    table.insert(self.sliderNodeProgress, self["compBoxItem" .. i]:GetAnchoredPositionX() / self.sliderFullLen)
  end
  self.textTitle:SetLocalText("alliance_weeklyStar_reward_title")
end

local function ComponentDestroy(self)
  self.btnCloseBg = nil
  self.textTitle = nil
  self.textTip = nil
  self.slider = nil
  self.compBoxItem1 = nil
  self.compBoxItem2 = nil
  self.compBoxItem3 = nil
  self.compBoxRewardItem1 = nil
  self.compBoxRewardItem2 = nil
  self.compBoxRewardItem3 = nil
end

local function DataDefine(self)
  self.nowProgress = 0
  self.targetProgress = 0
end

local function DataDestroy(self)
  self.sliderFullLen = nil
  self.sliderNodeProgress = nil
  self.nowProgress = 0
  self.targetProgress = 0
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnCloseBgClick(self)
  self.view:CloseRewardTipPanel()
end

local function Refresh(self)
  local rewardSetting = DataCenter.AllianceStarManager:GetRewardSetting()
  local fullData = DataCenter.AllianceStarManager:GetCeremonyFullData()
  local count = 0
  local claimedIndex = 0
  if fullData and fullData.emojiThumbsRewardInfo then
    count = fullData.emojiThumbsRewardInfo.count
    claimedIndex = fullData.emojiThumbsRewardInfo.claimedIndex
  end
  self.curTargetScores = {}
  for i = 1, 3 do
    self["compBoxItem" .. i]:Refresh(rewardSetting[i], claimedIndex)
    self["compBoxRewardItem" .. i]:Refresh(rewardSetting[i])
    table.insert(self.curTargetScores, rewardSetting[i][1])
  end
  local nowProgress = self:GetScoreProgress(count, 0)
  self.slider:SetValue(nowProgress)
  if claimedIndex == 1 then
    self.textTip:SetLocalText("alliance_weeklyStar_reward_desc_1", count)
  elseif claimedIndex == 2 then
    self.textTip:SetLocalText("alliance_weeklyStar_reward_desc_2", count)
  elseif claimedIndex == 3 then
    self.textTip:SetLocalText("alliance_weeklyStar_reward_desc_3", count)
  else
    self.textTip:SetLocalText("alliance_weeklyStar_reward_desc_0")
  end
end

local function GetScoreProgress(self, checkScore, zeroScore)
  local nowIndex = 0
  local score = checkScore - zeroScore
  for i = 1, #self.curTargetScores do
    local needScore = self.curTargetScores[i]
    if checkScore >= needScore then
      nowIndex = i
    else
      if 1 < i then
        score = checkScore - self.curTargetScores[i - 1]
      end
      break
    end
  end
  local value = 0
  if nowIndex == #self.curTargetScores then
    value = self.sliderNodeProgress[#self.sliderNodeProgress]
  else
    local preScore = zeroScore
    if 0 < nowIndex then
      preScore = self.curTargetScores[nowIndex]
    end
    local nodeRatio = score / (self.curTargetScores[nowIndex + 1] - preScore)
    local preProgress = 0
    if 0 < nowIndex then
      preProgress = self.sliderNodeProgress[nowIndex]
    end
    value = preProgress + nodeRatio * (self.sliderNodeProgress[nowIndex + 1] - preProgress)
  end
  return value
end

local function UpdateData(self)
  self:SetOffsetMaxXY(0, 0)
  self:SetOffsetMinXY(0, 0)
end

UIAllianceStarMainRewardTipPanel.OnCreate = OnCreate
UIAllianceStarMainRewardTipPanel.OnDestroy = OnDestroy
UIAllianceStarMainRewardTipPanel.OnEnable = OnEnable
UIAllianceStarMainRewardTipPanel.OnDisable = OnDisable
UIAllianceStarMainRewardTipPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainRewardTipPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainRewardTipPanel.DataDefine = DataDefine
UIAllianceStarMainRewardTipPanel.DataDestroy = DataDestroy
UIAllianceStarMainRewardTipPanel.OnAddListener = OnAddListener
UIAllianceStarMainRewardTipPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainRewardTipPanel.OnBtnCloseBgClick = OnBtnCloseBgClick
UIAllianceStarMainRewardTipPanel.Refresh = Refresh
UIAllianceStarMainRewardTipPanel.GetScoreProgress = GetScoreProgress
UIAllianceStarMainRewardTipPanel.UpdateData = UpdateData
return UIAllianceStarMainRewardTipPanel
