local AllianceHelpItem = BaseClass("AllianceHelpItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local first_name_path = "firstNameTxt"
local second_name_path = "secondNameTxt"
local anim_path = "switchAnim"
local reduceTimeTxt_path = "switchAnim/Slider/reduceTime/reduceTimeTxt"
local slider_path = "switchAnim/Slider"
local slider_txt_path = "switchAnim/Slider/helpedNum/helpedNum"
local bgImg_path = "bg_img"
local sliderBg_path = "sliderBg"
local playerHead = "UIPlayerHead/HeadIcon"
local playerBg = "UIPlayerHead"
local playerHeadFg = "UIPlayerHead/Foreground"

local function OnCreate(self)
  base.OnCreate(self)
  self.first_txt = self:AddComponent(UIText, first_name_path)
  self.second_txt = self:AddComponent(UIText, second_name_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_txt = self:AddComponent(UIText, slider_txt_path)
  self.bgImg = self:AddComponent(UIImage, bgImg_path)
  self.sliderBg = self:AddComponent(UIImage, sliderBg_path)
  self.playerHead = self:AddComponent(UIPlayerHead, playerHead)
  self.playerBg = self:AddComponent(UIImage, playerBg)
  self.playerHeadFg = self:AddComponent(UIImage, playerHeadFg)
  self.switchAnim = self:AddComponent(UIAnimator, anim_path)
  self.reduceTimeTxt = self:AddComponent(UIText, reduceTimeTxt_path)
end

local function SetItemShow(self, data)
  self.data = data
  self.first_txt:SetText(self.data.name)
  self.second_txt:SetText(self.data.des)
  local strReduce = UITimeManager:GetInstance():MilliSecondToFmtString(self.data.reduceSec * 1000)
  self.reduceTimeTxt:SetLocalText(141084, strReduce)
  self.slider_txt:SetText(self.data.nowCount .. "/" .. self.data.maxCount)
  local percent = self.data.nowCount / math.max(1, self.data.maxCount)
  self.slider:SetValue(percent)
  self.switchAnim:Play("AlHelpSwitch", 0, 0)
  if self.data.uid == LuaEntry.Player.uid then
    self.bgImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_bg_item_supple3.png")
    self.sliderBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_bg5.png")
  else
    self.bgImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_bg_item_supple.png")
    self.sliderBg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/Common_bg1.png")
  end
  self.playerHead:SetData(self.data.uid, self.data.pic, self.data.picVer)
  if self.data.headBg then
    self.playerHeadFg:SetActive(true)
  else
    self.playerHeadFg:SetActive(false)
  end
end

AllianceHelpItem.OnCreate = OnCreate
AllianceHelpItem.SetItemShow = SetItemShow
return AllianceHelpItem
