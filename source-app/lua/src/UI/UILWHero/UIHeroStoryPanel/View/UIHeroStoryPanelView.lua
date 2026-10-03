local base = UIBaseView
local UIHeroStoryPanelView = BaseClass("UIHeroStoryPanelView", base)
local btnPanel_path = "panel"
local closeBtn_path = "PopUpTitle/CloseBtn"
local titleText_path = "PopUpTitle/Common_img_title/titleText"
local contentText_path = "PopUpTitle/Common_bg_orange2/ContentScroll/Viewport/ContentText"
local IconImg_path = "PopUpTitle/Common_bg_orange2/HeroBg/IconImg"
local nameText_path = "PopUpTitle/Common_bg_orange2/HeroBg/HeroNameText"
local nickNameText_path = "PopUpTitle/Common_bg_orange2/HeroBg/HeroNickNameText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
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
  self.btnPanel = self:AddComponent(UIButton, btnPanel_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.contentText = self:AddComponent(UIText, contentText_path)
  self.IconImg = self:AddComponent(UIRawImage, IconImg_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.nickNameText = self:AddComponent(UIText, nickNameText_path)
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.titleText:SetLocalText("season_s2_callback_name_2")
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.closeBtn = nil
  self.titleText = nil
  self.contentText = nil
  self.IconImg = nil
  self.nameText = nil
  self.nickNameText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshUI(self)
  local heroData = self:GetUserData()
  if heroData == nil then
    return
  end
  self.contentText:SetLocalText(heroData.meta.backstory_desc)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentText.transform)
  self.nameText:SetLocalText(heroData.meta.name)
  self.nickNameText:SetLocalText(heroData.meta.nickName)
  self.IconImg:LoadSprite(heroData.meta.backstory_image)
  self.IconImg:SetNativeSize()
end

UIHeroStoryPanelView.OnCreate = OnCreate
UIHeroStoryPanelView.OnDestroy = OnDestroy
UIHeroStoryPanelView.OnEnable = OnEnable
UIHeroStoryPanelView.OnDisable = OnDisable
UIHeroStoryPanelView.ComponentDefine = ComponentDefine
UIHeroStoryPanelView.ComponentDestroy = ComponentDestroy
UIHeroStoryPanelView.DataDefine = DataDefine
UIHeroStoryPanelView.DataDestroy = DataDestroy
UIHeroStoryPanelView.RefreshUI = RefreshUI
return UIHeroStoryPanelView
