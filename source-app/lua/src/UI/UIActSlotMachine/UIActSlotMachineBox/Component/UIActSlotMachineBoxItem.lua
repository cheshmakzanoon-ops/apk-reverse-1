local UIActSlotMachineBoxItem = BaseClass("UIActSlotMachineBoxItem", UIBaseContainer)
local base = UIBaseContainer
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local reward_content_path = "rewardContent"
local reward_icon_path = "rewardContent/rewardIcon/UICommonResItem"
local mulit_path = "rewardContent/mulit"
local num_txt_path = "rewardContent/numTxt"
local box_content_path = "boxContent"
local box_img_container_path = "boxContent/boxImgContainer"
local box_img_path = "boxContent/boxImgContainer/boxImg"
local open_effect_path = "boxContent/Eff_ui_laba_baoxiangkaiqi1"

function UIActSlotMachineBoxItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActSlotMachineBoxItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local animName = "Eff_ui_ActSlotMachineMain_boxrewardopen"

function UIActSlotMachineBoxItem:ComponentDefine()
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.reward_icon = self:AddComponent(UICommonResItem, reward_icon_path)
  self.mulit = self:AddComponent(UIImage, mulit_path)
  self.num_txt = self:AddComponent(UITextMeshProUGUIEx, num_txt_path)
  self.box_content = self:AddComponent(UIBaseContainer, box_content_path)
  self.box_img_container = self:AddComponent(UIBaseContainer, box_img_container_path)
  self.box_img = self:AddComponent(UIImage, box_img_path)
  self.box_content_anim = self:AddComponent(UIAnimator, box_content_path)
  self.open_effect = self:AddComponent(UIBaseContainer, open_effect_path)
  self.open_effect:SetActive(false)
  self.box_content_anim:SampleAnimationAtTime(animName, 0)
  self.box_img:LoadSprite("Assets/Main/Sprites/UI/ActSlotMachine/cfm_fuhuojie_baoxiang_1.png")
  self.box_content_canvas_group = self:AddComponent(UICanvasGroup, box_content_path)
  self.reward_content_canvas_group = self:AddComponent(UICanvasGroup, reward_content_path)
  self.box_content_canvas_group:SetAlpha(1)
  self.reward_content_canvas_group:SetAlpha(1)
end

function UIActSlotMachineBoxItem:ComponentDestroy()
  self.reward_content = nil
  self.reward_icon = nil
  self.mulit = nil
  self.num_txt = nil
  self.box_content = nil
  self.box_img = nil
  self.box_content_anim = nil
  self.open_effect = nil
end

function UIActSlotMachineBoxItem:DataDefine()
  self.param = nil
  self.closeBoxImg = ""
  self.openBoxImg = ""
end

function UIActSlotMachineBoxItem:DataDestroy()
  self.param = nil
  self.closeBoxImg = nil
  self.openBoxImg = nil
end

function UIActSlotMachineBoxItem:SetData(activityDetailData, data, index, isFinOpen, finOpenRIndex)
  self.activityDetailData = activityDetailData
  self.data = data
  self.index = index
  self.isFinOpen = isFinOpen
  self.finOpenRIndex = finOpenRIndex
  self.closeBoxImg = "cfm_fuhuojie_baoxiang_1"
  self.openBoxImg = "cfm_fuhuojie_baoxiang_2"
  local boxIndexData = data.boxRewards[index]
  local infoTemp = self.activityDetailData.infoTemp
  local groupId = infoTemp.eventid
  local boxTemp = DataCenter.ActSlotMachineDataManager.boxTempDict[groupId][self.data.id]
  local rIndex = index
  if boxIndexData.state == 1 then
    rIndex = boxIndexData.rewardIndex + 1
  elseif self.isFinOpen and self.finOpenRIndex then
    rIndex = self.finOpenRIndex
  end
  local tempRewardData = string.string2array_i(boxTemp.box_reward, ";", "|")
  local indexTempRewardData = tempRewardData[rIndex]
  local rewardData = {
    rewardType = indexTempRewardData[1],
    itemId = indexTempRewardData[2]
  }
  self.reward_icon:ReInit(rewardData)
  self.mulit:SetActive(self.data.multiple ~= nil and self.data.multiple == 5)
  self.num_txt:SetText(indexTempRewardData[3])
  self.reward_content:SetLocalScaleXYZ(1, 1, 1)
  self.reward_content:SetOffsetMaxXY(0, 23)
  self.reward_content:SetOffsetMinXY(0, 23)
  self.box_content_canvas_group:SetAlpha(1)
  self.reward_content_canvas_group:SetAlpha(1)
  self.box_img:SetColorRGBA255(255, 255, 255, 255)
  if not self.isFinOpen then
    self.reward_content:SetActive(boxIndexData.state == 1)
    self.box_content:SetActive(boxIndexData.state ~= 1)
  elseif boxIndexData.state == 1 then
    self.reward_content:SetActive(true)
    self.box_content:SetActive(false)
  else
    self.reward_content:SetActive(true)
    self.box_content:SetActive(true)
    self.box_content_canvas_group:SetAlpha(0.5)
    self.reward_content_canvas_group:SetAlpha(0.6)
    self.box_img:SetColorRGBA255(150, 150, 150, 255)
    self.reward_content:SetLocalScaleXYZ(0.7, 0.7, 0.7)
    self.reward_content:SetOffsetMaxXY(0, 23)
    self.reward_content:SetOffsetMinXY(0, 23)
  end
  if infoTemp and infoTemp.big_box_pic and #infoTemp.big_box_pic == 3 then
    self.closeBoxImg = infoTemp.big_box_pic[2]
    self.openBoxImg = infoTemp.big_box_pic[3]
  end
  if boxIndexData.state == 1 then
    self.box_img:LoadSprite(string.format(UIAssets.UIActSlotMachineSpritePath, self.openBoxImg))
  else
    self.box_img:LoadSprite(string.format(UIAssets.UIActSlotMachineSpritePath, self.closeBoxImg))
  end
end

function UIActSlotMachineBoxItem:PlayOpenEffect(callback)
  if self.open_effect:GetActive() or self.openAnimTimer then
    return
  end
  self.open_effect:SetActive(true)
  self.box_content_anim:SampleAnimationAtTime(animName, 0)
  local result, animTime = self.box_content_anim:PlayAnimationReturnTime(animName)
  if result then
    self.changeImgTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.box_img:LoadSprite(string.format(UIAssets.UIActSlotMachineSpritePath, self.openBoxImg))
    end, 0.24)
    self.openAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.open_effect:SetActive(false)
      callback()
    end, animTime)
  else
    callback()
  end
end

function UIActSlotMachineBoxItem:OnDisable()
  if self.openAnimTimer then
    self.openAnimTimer:Stop()
    self.openAnimTimer = nil
  end
  if self.changeImgTimer then
    self.changeImgTimer:Stop()
    self.changeImgTimer = nil
  end
  base.OnDisable(self)
end

return UIActSlotMachineBoxItem
