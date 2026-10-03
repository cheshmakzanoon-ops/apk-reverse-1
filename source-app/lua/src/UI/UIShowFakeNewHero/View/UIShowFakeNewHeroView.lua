local UIShowFakeNewHeroView = BaseClass("UIShowFakeNewHeroView", UIBaseView)
local base = UIBaseView
local HeroModelViewer = require("UI.UIHero2.UIHeroInfo.Component.HeroModelViewer")
local panel_path = "Panel"
local raw_image_path = "RawImage"
local nick_name_text_path = "Root/NodeHeroInfo/TextNickName"
local hero_name_text_path = "Root/NodeHeroInfo/TextHeroName"
local rarity_img_path = "Root/NodeHeroInfo/ImgRarity"
local tip_text_path = "Root/NodeCloseTip/TextTip"
local close_node_path = "Root/NodeCloseTip"

function UIShowFakeNewHeroView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIShowFakeNewHeroView:OnDestroy()
  DataCenter.HeroEntrustManager:CheckShowReward()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIShowFakeNewHeroView:ComponentDefine()
  self.nick_name_text = self:AddComponent(UIText, nick_name_text_path)
  self.hero_name_text = self:AddComponent(UIText, hero_name_text_path)
  self.rarity_img = self:AddComponent(UIImage, rarity_img_path)
  self.tip_text = self:AddComponent(UIText, tip_text_path)
  self.modelViewer = self:AddComponent(HeroModelViewer, raw_image_path)
  self.close_node = self:AddComponent(UIBaseContainer, close_node_path)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIShowFakeNewHeroView:ComponentDestroy()
  self.nick_name_text = nil
  self.hero_name_text = nil
  self.rarity_img = nil
  self.tip_text = nil
  self.modelViewer = nil
  self.close_node = nil
  self.panel = nil
end

function UIShowFakeNewHeroView:DataDefine()
  self.param = {}
  
  function self.can_close_timer_action()
    self:CanCloseTimerAction()
  end
  
  self.canClose = false
end

function UIShowFakeNewHeroView:DataDestroy()
  self.param = {}
  self:DeleteCanCloseTimer()
  self.can_close_timer_action = nil
  self.canClose = false
end

function UIShowFakeNewHeroView:OnEnable()
  base.OnEnable(self)
  pcall(function()
    CS.SceneManager.World:DisablePostProcess()
  end)
end

function UIShowFakeNewHeroView:OnDisable()
  base.OnDisable(self)
  pcall(function()
    CS.SceneManager.World:EnablePostProcess()
  end)
end

function UIShowFakeNewHeroView:OnAddListener()
  base.OnAddListener(self)
end

function UIShowFakeNewHeroView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIShowFakeNewHeroView:ReInit()
  self.param = self:GetUserData()
  self.tip_text:SetLocalText(GameDialogDefine.CLICK_EVER_TO_CLOSE)
  self.modelViewer:SetHeroId(self.param.heroId, true)
  local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.param.heroId)
  if heroConfig ~= nil then
    local rarity = heroConfig.rarity
    self.rarity_img:LoadSprite(HeroUtils.GetRarityIconName(rarity, true))
    self.hero_name_text:SetLocalText(heroConfig.name)
    self.nick_name_text:SetLocalText(heroConfig.desc)
    self.hero_name_text:SetColor(HeroUtils.GetHeroNameColorByRarity(rarity, false))
    self.nick_name_text:SetColor(HeroUtils.GetHeroNameColorByRarity(rarity, false))
  end
  if self.param.canClickTime == nil or self.param.canClickTime == 0 then
    self:CanCloseTimerAction()
  else
    self:AddCanCloseTimer(self.param.canClickTime)
  end
end

function UIShowFakeNewHeroView:AddCanCloseTimer(time)
  self.close_node:SetActive(false)
  self.canClose = false
  self:DeleteCanCloseTimer()
  self.canCloseTimer = TimerManager:GetInstance():GetTimer(time, self.can_close_timer_action, self, true, false, false)
  self.canCloseTimer:Start()
end

function UIShowFakeNewHeroView:CanCloseTimerAction()
  self:DeleteCanCloseTimer()
  self.canClose = true
  self.close_node:SetActive(true)
end

function UIShowFakeNewHeroView:DeleteCanCloseTimer()
  if self.canCloseTimer then
    self.canCloseTimer:Stop()
    self.canCloseTimer = nil
  end
end

function UIShowFakeNewHeroView:OnBtnClick()
  if self.canClose then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end
end

return UIShowFakeNewHeroView
