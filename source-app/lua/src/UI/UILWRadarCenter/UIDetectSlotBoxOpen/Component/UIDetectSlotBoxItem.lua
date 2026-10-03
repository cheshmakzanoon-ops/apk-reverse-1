local base = UIBaseContainer
local UIDetectSlotBoxItem = BaseClass("UIDetectSlotBoxItem", base)
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local animName = "Eff_ui_ActSlotMachineMain_boxrewardopen"
local reward_content_path = "rewardContent"
local reward_icon_path = "rewardContent/rewardIcon/UICommonResItem"
local mulit_path = "rewardContent/mulit"
local num_txt_path = "rewardContent/numTxt"
local box_content_path = "boxContent"
local box_img_container_path = "boxContent/boxImgContainer"
local box_img_path = "boxContent/boxImgContainer/boxImg"
local open_effect_path = "boxContent/Eff_ui_laba_baoxiangkaiqi1"
local box_content_anim_path = "boxContent"
local box_content_canvas_group_path = "boxContent"
local reward_content_canvas_group_path = "rewardContent"

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
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.openAnimTimer then
    self.openAnimTimer:Stop()
    self.openAnimTimer = nil
  end
end

local function ComponentDefine(self)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.reward_icon = self:AddComponent(UIBaseContainer, reward_icon_path)
  self.mulit = self:AddComponent(UIImage, mulit_path)
  self.num_txt = self:AddComponent(UIText, num_txt_path)
  self.box_content = self:AddComponent(UIBaseContainer, box_content_path)
  self.box_img_container = self:AddComponent(UIBaseContainer, box_img_container_path)
  self.box_img = self:AddComponent(UIImage, box_img_path)
  self.open_effect = self:AddComponent(UIBaseContainer, open_effect_path)
  self.box_content_anim = self:AddComponent(UIAnimator, box_content_anim_path)
  self.box_content_canvas_group = self:AddComponent(UICanvasGroup, box_content_canvas_group_path)
  self.reward_content_canvas_group = self:AddComponent(UICanvasGroup, reward_content_canvas_group_path)
  self.open_effect:SetActive(false)
  self.rewardItem = self:AddComponent(UICommonResItem, reward_icon_path)
  self.mulit:SetActive(false)
  self.box_content_canvas_group:SetAlpha(1)
  self.reward_content_canvas_group:SetAlpha(1)
  self.box_content_anim:SampleAnimationAtTime(animName, 0)
end

local function ComponentDestroy(self)
  self.reward_content = nil
  self.reward_icon = nil
  self.mulit = nil
  self.num_txt = nil
  self.box_content = nil
  self.box_img_container = nil
  self.box_img = nil
  self.open_effect = nil
  self.box_content_anim = nil
  self.box_content_canvas_group = nil
  self.reward_content_canvas_group = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function UIDetectSlotBoxItem:SetBoxIcon(picPath)
  self.box_img:LoadSprite(picPath)
end

function UIDetectSlotBoxItem:PlayOpenEffect(callback)
  if self.open_effect:GetActive() or self.openAnimTimer then
    return
  end
  self.open_effect:SetActive(true)
  self.box_content_anim:SampleAnimationAtTime(animName, 0)
  local result, animTime = self.box_content_anim:PlayAnimationReturnTime(animName)
  if result then
    self.changeImgTimer = TimerManager:GetInstance():DelayInvoke(function()
    end, 0.24)
    self.openAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.open_effect:SetActive(false)
      callback()
    end, animTime)
  else
    callback()
  end
end

function UIDetectSlotBoxItem:SetOpen(reward)
  if not (reward and reward.value) or not reward.type then
    return
  end
  local rewardData = {
    rewardType = reward.type,
    itemId = reward.value.itemId
  }
  self.rewardItem:ReInit(rewardData)
  self.num_txt.gameObject:SetActive(true)
  self.num_txt:SetText(tostring(reward.value.rewardAdd))
  self.reward_content:SetActive(true)
  self.box_content:SetActive(false)
  self.reward_content:SetLocalScaleXYZ(1, 1, 1)
  self.reward_content:SetOffsetMaxXY(0, 23)
  self.reward_content:SetOffsetMinXY(0, 23)
  self.reward_content_canvas_group:SetAlpha(1)
end

function UIDetectSlotBoxItem:SetData(data, index)
  self.data = data
  self.index = index
  self.reward_content:SetLocalScaleXYZ(1, 1, 1)
  self.reward_content:SetOffsetMaxXY(0, 23)
  self.reward_content:SetOffsetMinXY(0, 23)
  self.box_content_canvas_group:SetAlpha(1)
  self.reward_content_canvas_group:SetAlpha(1)
  self.box_img:SetColorRGBA255(255, 255, 255, 255)
  self.reward_content:SetActive(false)
  self.box_content:SetActive(true)
  local boxIcon = string.split(self.data.pic, "|")
  self.closeImg = boxIcon[1]
  self.openImg = boxIcon[2]
  self:SetBoxIcon(self.closeImg)
  self.num_txt.gameObject:SetActive(false)
  local tempRewardData = string.string2array_i(self.data.box_reward, ";", "|")
  local indexTempRewardData = tempRewardData[self.index]
  local rewardData = {
    rewardType = indexTempRewardData[1],
    itemId = indexTempRewardData[2],
    count = indexTempRewardData[3]
  }
  self.rewardItem:ReInit(rewardData)
end

UIDetectSlotBoxItem.OnCreate = OnCreate
UIDetectSlotBoxItem.OnDestroy = OnDestroy
UIDetectSlotBoxItem.OnEnable = OnEnable
UIDetectSlotBoxItem.OnDisable = OnDisable
UIDetectSlotBoxItem.ComponentDefine = ComponentDefine
UIDetectSlotBoxItem.ComponentDestroy = ComponentDestroy
UIDetectSlotBoxItem.DataDefine = DataDefine
UIDetectSlotBoxItem.DataDestroy = DataDestroy
return UIDetectSlotBoxItem
