local UILWSalaHeroPopView = BaseClass("UILWSalaHeroPopView", UIBaseView)
local Const = require("Scene.LWBattle.Const")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local EffectBtn_path = "ImgBg/btnGetHero/rect_effect"
local EffectPop_path = "ImgBg/Bg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetData()
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
  self.bgCloseBtn = self:AddComponent(UIButton, "Panel")
  self.bgCloseBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickCloseBtn()
  end)
  self.TextContinue = self:AddComponent(UITextMeshProUGUIEx, "TextContinue")
  self.closeBtnN = self:AddComponent(UIButton, "ImgBg/closeBtn")
  self.closeBtnN:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickCloseBtn()
  end)
  self.showKill = self:AddComponent(UIButton, "ImgBg/showSkill")
  self.showKill:SetOnClick(function()
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(40019)
    local heroId = 40019
    local skillId = heroTemplate.skills[2]
    local skillLv = 1
    local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    local skillMaxLv = skillTemplate.maxLevel
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPreviewSkillWindow, {anim = true}, heroId, skillId, skillLv, skillMaxLv)
  end)
  self.btnGetHero = self:AddComponent(UIButton, "ImgBg/btnGetHero")
  self.btnGetHero:SetOnClick(function()
    self:OnClickBtnGetHero()
  end)
  self.btnTimeText = self:AddComponent(UIText, "ImgBg/btnGetHero/rect_time/btnTime")
  self.canGetImg = self:AddComponent(UIImage, "ImgBg/btnGetHero/canGetImg")
  self.getText = self:AddComponent(UIText, "ImgBg/btnGetHero/canGetImg/getText")
  self.rect_time = self:AddComponent(UIBaseContainer, "ImgBg/btnGetHero/rect_time")
  self.btnGetInfo = self:AddComponent(UIButton, "ImgBg/btnGetInfo")
  self.btnGetInfo:SetOnClick(function()
    self:OnClickBtnGetHeroInfo()
  end)
  if not self.effectButton then
    self.effectButton = self:AddComponent(UIVfx, EffectBtn_path, VfxAssets.SaraPopButtonEffect, {
      lifeType = UIVfxLifeType.Stay
    })
  end
  self.effectButton:Replay()
  self:AddDelayTimer()
  UIGray.SetGrayWithIgnore(self.btnGetHero.transform, true, "canGetImg")
  self.bgCloseBtn:SetInteractable(false)
  self.TextContinue:SetActive(false)
  self.delayCloseTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.TextContinue:SetActive(true)
    self.bgCloseBtn:SetInteractable(true)
  end, 1.6600000000000001)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.closeBtnN:SetAnchoredPositionXY(266, 540)
  end
end

local function ComponentDestroy(self)
  self.bgCloseBtn = nil
  self.closeBtnN = nil
  self.showKill = nil
  self.btnGetHero = nil
  self.btnTimeText = nil
  self.canGetImg = nil
  self.btnGetInfo = nil
  self.getText = nil
  self.rect_time = nil
  if self.delayCloseTimer then
    self.delayCloseTimer:Stop()
    self.delayCloseTimer = nil
  end
  self:DeleteDelayTimer()
end

local function DeleteDelayTimer(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function AddDelayTimer(self)
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if not self.effectPop then
      self.effectPop = self:AddComponent(UIVfx, EffectPop_path, VfxAssets.SaraPopEffect, {
        lifeType = UIVfxLifeType.Stay
      })
    end
    self.effectPop:Replay()
  end, 0.25)
  self.delayTimer:Start()
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.buildData = nil
  self.timeDiff = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnClickCloseBtn(self)
  local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
  if self.buildData and self.buildData.fixCityHeroEndTime and curTime >= self.buildData.fixCityHeroEndTime then
    SFSNetwork.SendMessage(MsgDefines.FreeBuildingFixCityHero, self.BUuid)
    CS.GameEntry.Setting:SetInt(SettingKeys.SALA_HERO_POP_LASTTIME .. LuaEntry.Player.uid, -1)
  end
  self.ctrl:CloseSelf()
end

local function OnClickBtnGetHero(self)
  local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
  if self.buildData and self.buildData.fixCityHeroEndTime and curTime >= self.buildData.fixCityHeroEndTime then
    SFSNetwork.SendMessage(MsgDefines.FreeBuildingFixCityHero, self.BUuid)
    CS.GameEntry.Setting:SetInt(SettingKeys.SALA_HERO_POP_LASTTIME .. LuaEntry.Player.uid, -1)
    self.ctrl:CloseSelf()
  else
    local last = UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(self.buildData.fixCityHeroEndTime - curTime)
    UIUtil.ShowTips(Localization:GetString("monopoly_event_tips_01", last))
  end
end

local function SetData(self)
  self.BUuid = self:GetUserData()
  if not self.BUuid then
    self.BUuid = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_HERO_COUNTDOWN)[1].uuid
  end
  self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.BUuid)
  local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
  if self.buildData and self.buildData.fixCityHeroEndTime and curTime >= self.buildData.fixCityHeroEndTime then
    self.getText:SetActive(true)
    self.rect_time:SetActive(false)
  else
    self.getText:SetActive(false)
    self.rect_time:SetActive(true)
  end
  self.timeDiff = self.buildData.fixCityHeroEndTime - self.buildData.growValStartTime
end

local function Update1000MS(self)
  if self.buildData and self.buildData.fixCityHeroEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.buildData.fixCityHeroEndTime - curTime
    if 0 < remainTime then
      self.btnTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      self.canGetImg:SetFillAmount(1 - remainTime / self.timeDiff)
    else
      self.getText:SetActive(true)
      self.rect_time:SetActive(false)
      self.canGetImg:SetFillAmount(1)
    end
  end
end

local function OnClickBtnGetHeroInfo(self)
  local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
  if not heroWindow then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, 40019, {40019}, nil, {
      arrowType = HeroDetailGuideArrowType.SkillPreview
    })
  end
end

UILWSalaHeroPopView.OnCreate = OnCreate
UILWSalaHeroPopView.OnDestroy = OnDestroy
UILWSalaHeroPopView.OnEnable = OnEnable
UILWSalaHeroPopView.OnDisable = OnDisable
UILWSalaHeroPopView.ComponentDefine = ComponentDefine
UILWSalaHeroPopView.ComponentDestroy = ComponentDestroy
UILWSalaHeroPopView.DataDefine = DataDefine
UILWSalaHeroPopView.DataDestroy = DataDestroy
UILWSalaHeroPopView.OnAddListener = OnAddListener
UILWSalaHeroPopView.OnRemoveListener = OnRemoveListener
UILWSalaHeroPopView.OnClickCloseBtn = OnClickCloseBtn
UILWSalaHeroPopView.SetData = SetData
UILWSalaHeroPopView.OnClickBtnGetHero = OnClickBtnGetHero
UILWSalaHeroPopView.Update1000MS = Update1000MS
UILWSalaHeroPopView.OnClickBtnGetHeroInfo = OnClickBtnGetHeroInfo
UILWSalaHeroPopView.AddDelayTimer = AddDelayTimer
UILWSalaHeroPopView.DeleteDelayTimer = DeleteDelayTimer
return UILWSalaHeroPopView
