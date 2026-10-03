local base = UIBaseContainer
local GreenRewardGroup = BaseClass("GreenRewardGroup", base)
local Localization = CS.GameEntry.Localization
local GreenRewardDetailItem = require("UI.LWSeason3.LWSeasonGreen.SeasonGreenMain.Component.GreenRewardDetailItem")
local ScoreBtn_path = "ScoreBtn"
local UICommonResItem_path = "ScoreBtn/UICommonResItem"
local ResQuality_path = "ScoreBtn/UICommonResItem/clickBtn/ImgQuality"
local ResIcon_path = "ScoreBtn/UICommonResItem/clickBtn/ItemIcon"
local ScoreBtnText_path = "ScoreBtn/ScoreBtnText"
local RedPoint_path = "ScoreBtn/RedPoint"
local ScoreDetailContent_path = "ScoreDetailContent"
local Image_arrow = "ScoreDetailContent/BG_1"
local ClickMask_path = "ScoreDetailContent/ClickMask"
local desc_path = "ScoreDetailContent/desc"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.SeasonGreenCityProgressInfo)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.ScoreBtn = self:AddComponent(UIButton, ScoreBtn_path)
  self.UICommonResItem = self:AddComponent(UIBaseContainer, UICommonResItem_path)
  self.ResQuality = self:AddComponent(UIImage, ResQuality_path)
  self.ResIcon = self:AddComponent(UIImage, ResIcon_path)
  self.ScoreBtnText = self:AddComponent(UIText, ScoreBtnText_path)
  self.RedPoint = self:AddComponent(UIBaseContainer, RedPoint_path)
  self.ScoreDetailContent = self:AddComponent(UIBaseContainer, ScoreDetailContent_path)
  self.ClickMask = self:AddComponent(UIButton, ClickMask_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.arrow = self:AddComponent(UIBaseContainer, Image_arrow)
  self.ScoreDetailContent:SetActive(false)
  self.RedPoint:SetActive(false)
  self._reward_item = self:AddComponent(UICommonResItem, UICommonResItem_path)
  self.ScoreBtn:SetOnClick(function()
    self:RefreshContent()
    self.ScoreDetailContent:SetActive(true)
  end)
  self.ClickMask:SetOnClick(function()
    self.ScoreDetailContent:SetActive(false)
  end)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.ScoreDetailContent.transform:Set_localPosition(-349, -180, 0)
    self.arrow.transform:Set_localPosition(261.2, 188, 0)
    self.arrow.transform.rotation = Quaternion.Euler(0, 0, 270)
  end
end

local function ComponentDestroy(self)
  self.ScoreBtn = nil
  self.UICommonResItem = nil
  self.ResQuality = nil
  self.ResIcon = nil
  self.ScoreBtnText = nil
  self.RedPoint = nil
  self.ScoreDetailContent = nil
  self.ClickMask = nil
  self.desc = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GreenRewardGroup:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonGreenCityProgressInfo, self.RefreshView)
end

function GreenRewardGroup:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonGreenCityProgressInfo, self.RefreshView)
  base.OnRemoveListener(self)
end

function GreenRewardGroup:RefreshView()
  self.curNum = DataCenter.SeasonGreenManager.curNum or 0
  self.rewardInfo = DataCenter.SeasonGreenManager.rewardInfo or {}
  self.canGetReward = DataCenter.SeasonGreenManager.canGetReward
  local nextTarget = self:GetNextReward(self.rewardInfo, self.curNum)
  if nextTarget then
    self.ScoreBtnText:SetText(self.curNum .. "/" .. nextTarget.num)
  else
    self.ScoreBtnText:SetText(self.curNum)
  end
  self:RefreshCurItem()
  self:RefreshContent(true)
end

function GreenRewardGroup:RefreshCurItem()
  local isGetRewardComplete = false
  local reward = self.canGetReward
  reward = reward or self:GetNextReward(self.rewardInfo, self.curNum)
  if not reward and self.rewardInfo then
    reward = self.rewardInfo[#self.rewardInfo]
    isGetRewardComplete = true
  end
  local rewardData = reward and DataCenter.RewardManager:ParseRewardInfo(reward.reward[1])
  if not rewardData then
    return
  end
  
  function rewardData.clickCallBack()
    self:RefreshContent()
    self.ScoreDetailContent:SetActive(true)
  end
  
  self.curIndex = reward.index
  self._reward_item:ReInit(rewardData)
  CS.UIGray.SetGray(self.ResQuality.transform, isGetRewardComplete, true)
  CS.UIGray.SetGray(self.ResIcon.transform, isGetRewardComplete, true)
  self:RefreshRedPoint()
end

function GreenRewardGroup:RefreshContent(checkShow)
  if checkShow and (not self._score_detail_item or not self.ScoreDetailContent:GetActive()) then
    return
  end
  if not self._score_detail_item then
    self._score_detail_item = self:AddComponent(GreenRewardDetailItem, ScoreDetailContent_path)
  end
  self._score_detail_item:ReInit(self.curNum, self.rewardInfo, self.curIndex)
end

function GreenRewardGroup:GetNextReward(rewardInfo, curNum)
  if not rewardInfo then
    return
  end
  for i, reward in ipairs(rewardInfo) do
    if curNum < reward.num then
      return reward
    end
  end
end

function GreenRewardGroup:RefreshRedPoint()
  self.RedPoint:SetActive(self.canGetReward ~= nil)
end

GreenRewardGroup.OnCreate = OnCreate
GreenRewardGroup.OnDestroy = OnDestroy
GreenRewardGroup.OnEnable = OnEnable
GreenRewardGroup.OnDisable = OnDisable
GreenRewardGroup.ComponentDefine = ComponentDefine
GreenRewardGroup.ComponentDestroy = ComponentDestroy
GreenRewardGroup.DataDefine = DataDefine
GreenRewardGroup.DataDestroy = DataDestroy
return GreenRewardGroup
