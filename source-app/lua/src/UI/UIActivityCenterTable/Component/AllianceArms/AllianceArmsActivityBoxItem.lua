local AllianceArmsActivityBoxItem = BaseClass("AllianceArmsActivityBoxItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local diamondObj_path = "dimondBg/Imageicon"
local diamondTxt_path = "dimondBg/dimondTxt"
local diamondBg_path = "dimondBg"
local diamondBg2_path = "bgOpacity/dimondBg2"
local valueTxt_path = "valueTxt"
local itemImg_path = "Icon"
local animator_path = "Icon"
local bgNormal_path = "bg"
local bgGray_path = "bgGray"
local lockGo_path = "lockGo"
local boxBtn_path = "Button"
local bgOpacity_path = "bgOpacity"
local reward_effect_path = "VFX_ui_box_reward"
local reward_light_path = "VFX_ui_box_light"
local rewardDouble_path = "isDouble"
local new_path = "new"

local function OnCreate(self)
  base.OnCreate(self)
  self.diamondObj = self:AddComponent(UIImage, diamondObj_path)
  self.diamondTxt = self:AddComponent(UIText, diamondTxt_path)
  self.valueTxt = self:AddComponent(UIText, valueTxt_path)
  self.reward_effect = self:AddComponent(UIBaseContainer, reward_effect_path)
  self.reward_light = self:AddComponent(UIBaseContainer, reward_light_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.itemImg = self:AddComponent(UIImage, itemImg_path)
  self.bgNormal = self:AddComponent(UIRawImage, bgNormal_path)
  self.dimondBg = self:AddComponent(UIImage, diamondBg_path)
  self.dimondBg2 = self:AddComponent(UIImage, diamondBg2_path)
  self.bgGray = self:AddComponent(UIRawImage, bgGray_path)
  self.bgOpacity = self:AddComponent(UIRawImage, bgOpacity_path)
  self.lockGo = self:AddComponent(UIImage, lockGo_path)
  self.boxBtn = self:AddComponent(UIButton, boxBtn_path)
  self.boxBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickBox()
  end)
  self.rewardDoubleN = self:AddComponent(UIText, rewardDouble_path)
  self.new = self:AddComponent(UIBaseComponent, new_path)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ShowDiamond(self, state)
  self.diamondObj:SetActive(state)
end

local function SetBoxInfo(self, boxIndex, state, diamondV, isNew)
  self.new:SetActive(isNew)
  self.diamondObj:SetActive(false)
  self.curState = state
  self.boxIndex = boxIndex
  self.diamondValue = diamondV
  local newIndex = boxIndex % 3
  self.animator:Enable(true)
  self.animator:Play("box_unOpen", 0, 0)
  self.reward_effect:SetActive(false)
  self.reward_light:SetActive(false)
  self.diamondTxt:SetText(string.GetFormattedSeperatorNum(diamondV))
  self.dimondBg2.rectTransform.sizeDelta = Vector2.New(self.dimondBg.rectTransform.sizeDelta.x, self.dimondBg.rectTransform.sizeDelta.y)
  if state == 1 then
    self.diamondTxt:SetColor(Color.New(0.7176470588235294, 0.4, 0.18823529411764706))
    self.bgGray:SetActive(true)
    self.bgNormal:SetActive(false)
    self.itemImg.rectTransform:Set_sizeDelta(182, 188)
    if newIndex == 1 then
      self.itemImg:LoadSprite(string.format(LoadPath.UIAllianceArmament, "UIAllianceArmament_img_reward01"))
    elseif newIndex == 2 then
      self.itemImg:LoadSprite(string.format(LoadPath.UIAllianceArmament, "UIAllianceArmament_img_reward03"))
    else
      self.itemImg:LoadSprite(string.format(LoadPath.UIAllianceArmament, "UIAllianceArmament_img_reward05"))
    end
  elseif state == 2 then
    self.diamondTxt:SetColor(Color.New(0.7176470588235294, 0.4, 0.18823529411764706))
    self.bgGray:SetActive(false)
    self.bgNormal:SetActive(true)
    self.itemImg.rectTransform:Set_sizeDelta(182, 188)
    self.animator:Enable(true)
    self.animator:Play("box_open", 0, 0)
    self.reward_effect:SetActive(true)
    self.reward_light:SetActive(true)
    if newIndex == 1 then
      self.itemImg:LoadSprite(string.format(LoadPath.UIAllianceArmament, "UIAllianceArmament_img_reward01"))
    elseif newIndex == 2 then
      self.itemImg:LoadSprite(string.format(LoadPath.UIAllianceArmament, "UIAllianceArmament_img_reward03"))
    else
      self.itemImg:LoadSprite(string.format(LoadPath.UIAllianceArmament, "UIAllianceArmament_img_reward05"))
    end
  else
    self.diamondTxt:SetColor(Color.New(0.7176470588235294, 0.4, 0.18823529411764706))
    self.bgGray:SetActive(true)
    self.bgNormal:SetActive(false)
    self.itemImg.rectTransform:Set_sizeDelta(182, 188)
    if newIndex == 1 then
      self.itemImg:LoadSprite(string.format(LoadPath.UIAllianceArmament, "UIAllianceArmament_img_reward02"))
    elseif newIndex == 2 then
      self.itemImg:LoadSprite(string.format(LoadPath.UIAllianceArmament, "UIAllianceArmament_img_reward04"))
    else
      self.itemImg:LoadSprite(string.format(LoadPath.UIAllianceArmament, "UIAllianceArmament_img_reward06"))
    end
  end
  if self.view.CheckIfDoubleReward then
    local isDouble = self.view:CheckIfDoubleReward()
    self.rewardDoubleN:SetActive(isDouble)
  else
    self.rewardDoubleN:SetActive(false)
  end
end

local function SetLocked(self, index)
  if DataCenter.AllianceCompeteDataManager:Check9BoxUnlock(index) then
    self.bgOpacity:SetActive(false)
    self.lockGo:SetActive(false)
    self.bgGray:SetColor(Color32.New(1.0, 1.0, 1.0, 1.0))
    self.itemImg:SetColor(Color32.New(1.0, 1.0, 1.0, 1.0))
    self.dimondBg:SetColor(Color32.New(1.0, 1.0, 1.0, 1.0))
    self.diamondObj:SetColor(Color32.New(1.0, 1.0, 1.0, 1.0))
    self.diamondTxt:SetColor(Color32.New(0.7176470588235294, 0.4, 0.18823529411764706, 1.0))
  else
    self.lockGo:SetActive(true)
    self.bgOpacity:SetActive(true)
    self.bgGray:SetColor(Color32.New(0.7058823529411765, 0.7058823529411765, 0.7058823529411765, 0.6666666666666666))
    self.itemImg:SetColor(Color32.New(0.7058823529411765, 0.7058823529411765, 0.7058823529411765, 0.9019607843137255))
    self.dimondBg:SetColor(Color32.New(0.7058823529411765, 0.7058823529411765, 0.7058823529411765, 1.0))
    self.diamondObj:SetColor(Color32.New(0.7058823529411765, 0.7058823529411765, 0.7058823529411765, 1.0))
    self.diamondTxt:SetColor(Color32.New(0.49411764705882355, 0.3254901960784314, 0.2235294117647059, 1.0))
  end
end

local function OnClickBox(self)
  EventManager:GetInstance():Broadcast(EventId.AllianceArms_OpenBox, self.boxIndex)
end

AllianceArmsActivityBoxItem.OnCreate = OnCreate
AllianceArmsActivityBoxItem.OnDestroy = OnDestroy
AllianceArmsActivityBoxItem.ShowDiamond = ShowDiamond
AllianceArmsActivityBoxItem.SetBoxInfo = SetBoxInfo
AllianceArmsActivityBoxItem.OnClickBox = OnClickBox
AllianceArmsActivityBoxItem.SetLocked = SetLocked
return AllianceArmsActivityBoxItem
