local UIActEpidemicCampResultView = BaseClass("UIActEpidemicCampResultView", UIBaseView)
local UIActEpidemicSkillItem = require("UI.UIActEpidemicPopup.Component.UIActEpidemicSkillItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

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
end

local function ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBackground = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBackground:SetOnClick(function()
    self:OnBtnBackgroundClick()
  end)
  self.compCamp0 = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compCamp1 = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compCamp0skill0 = self.viewSkin:AddComponent(self, UIActEpidemicSkillItem, 4)
  self.compCamp0skill1 = self.viewSkin:AddComponent(self, UIActEpidemicSkillItem, 5)
  self.compCamp0skill2 = self.viewSkin:AddComponent(self, UIActEpidemicSkillItem, 6)
  self.textTmpCamp1AllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnContact = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnContact:SetOnClick(function()
    self:OnBtnContactClick()
  end)
  self.imgFlag = self.viewSkin:AddComponent(self, UIImage, 9)
  self.textTmpServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textTmpTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textTmpTitleTop = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textTmpCamp0Title = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textTmpCamp0Detail = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textTmpCamp1Title = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textTmpDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.btnShowAllianceInfo = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnShowAllianceInfo:SetOnClick(function()
    self:OnBtnShowAllianceInfoClick()
  end)
  self.textLabelNew = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.compRedContact = self.viewSkin:AddComponent(self, UIBaseComponent, 20)
  self.canvasGroupEmptyNode = self.viewSkin:AddComponent(self, UICanvasGroup, 21)
  self.canvasGroupResultNode = self.viewSkin:AddComponent(self, UICanvasGroup, 22)
  self.textTmpCamp1EmptyNodeTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.compIconNew = self.viewSkin:AddComponent(self, UIBaseComponent, 24)
  self.animatorUIActEpidemicCampResultView = self.viewSkin:AddComponent(self, UIAnimator, 25)
  self.imgTypeIcon = self.viewSkin:AddComponent(self, UIImage, 26)
  self.textBtn:SetLocalText("YiBianJinQu_event_button_6")
  self.textLabelNew:SetText("NEW")
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.btnBackground = nil
  self.compCamp0 = nil
  self.compCamp1 = nil
  self.compCamp0skill0 = nil
  self.compCamp0skill1 = nil
  self.compCamp0skill2 = nil
  self.textTmpCamp1AllianceName = nil
  self.btnContact = nil
  self.imgFlag = nil
  self.textTmpServer = nil
  self.textTmpTitle = nil
  self.textTmpTitleTop = nil
  self.textTmpCamp0Title = nil
  self.textTmpCamp0Detail = nil
  self.textTmpCamp1Title = nil
  self.textTmpDesc = nil
  self.textBtn = nil
  self.btnShowAllianceInfo = nil
  self.textLabelNew = nil
  self.compRedContact = nil
  self.canvasGroupEmptyNode = nil
  self.canvasGroupResultNode = nil
  self.textTmpCamp1EmptyNodeTitle = nil
  self.compIconNew = nil
  self.animatorUIActEpidemicCampResultView = nil
  self.imgTypeIcon = nil
end

local function DataDefine(self)
  local param = self:GetUserData()
  self.groupIndex = param and param.group or EpidemicZoneRole.Default
  self.group = ActEpidemicUtils.GetGroup(self.groupIndex)
  self.role = self.group ~= nil and self.group.selfRole or EpidemicZoneRole.Default
  if self.role == EpidemicZoneRole.Default then
    self.ctrl:CloseSelf()
    return
  end
  self:PlayAnim()
end

local function DataDestroy(self)
  self:DeleteTimer()
  self:ClearAnimPlayer()
  self.partner = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  for i = 1, 2 do
    LittleRedUtils.AddListener(LittleRedConst.NameActEpidemicOther, LittleRedConst.NameActEpidemicMainContact .. i, self, self.RefreshRedCount)
  end
end

local function OnRemoveListener(self)
  LittleRedUtils.ClearListener(LittleRedConst.NameActEpidemicOther, self)
  base.OnRemoveListener(self)
end

local function OnBtnBackgroundClick(self)
  local bShowSkillInfos = self.role == EpidemicZoneRole.Lord
  self.ctrl:CloseSelf()
  if bShowSkillInfos then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicCampResultSkillView, {anim = false}, self.groupIndex)
  end
end

local function OnBtnContactClick(self)
  local bSame = ActEpidemicUtils.GetMyGroupIndex() == self.groupIndex
  if not bSame then
    UIUtil.ShowTips(Localization:GetString("YiBianJinQu_trivial_tips_44", self.groupIndex))
    return
  end
  DataCenter.ActEpidemicZoneManager:MarkRed(LittleRedConst.NameActEpidemicOther, LittleRedConst.NameActEpidemicMainContact, self.groupIndex)
  local myPlayerState = ActEpidemicUtils.GetMyPlayerState()
  if myPlayerState == EpidemicZonePlayerState.None then
    UIUtil.ShowTipsId("YiBianJinQu_errorcode_17")
    return
  end
  ActEpidemicUtils.GotoChatRoom(self.role)
end

function UIActEpidemicCampResultView:RefreshRedCount()
  if self.compRedContact then
    if self.role == EpidemicZoneRole.Farmer and ActEpidemicUtils.GetMyGroupIndex() ~= self.groupIndex then
      self.compRedContact:SetActive(false)
    else
      self.compRedContact:SetActive(LittleRedUtils.GetCount(LittleRedConst.NameActEpidemicOther, LittleRedConst.NameActEpidemicMainContact .. self.groupIndex) > 0)
    end
  end
end

function UIActEpidemicCampResultView:SetupMode(modeType)
  if modeType == 0 then
    self.textTmpCamp0Title:SetLocalText("YiBianJinQu_camp_name_1")
    self.textTmpCamp1EmptyNodeTitle:SetLocalText("YiBianJinQu_camp_name_2")
    self.compCamp0skill2:Setup(-1)
    self.textTmpDesc:SetActive(false)
    self.compIconNew:SetActive(false)
  elseif modeType == 1 then
    self.textTmpDesc:SetActive(true)
    if self.role == EpidemicZoneRole.Lord then
      self.textTmpTitle:SetLocalText("YiBianJinQu_camp_name_1")
      self.textTmpCamp0Title:SetLocalText("YiBianJinQu_match_result_tips_2")
      self.textTmpDesc:SetLocalText("YiBianJinQu_camp_select_tips_3")
      self.compCamp0skill2:Setup(ActEpidemicUtils.GetLordSkillRandom(self.groupIndex))
      self.compIconNew:SetActive(true)
      self.imgTypeIcon:LoadSprite(string.format(LoadPath.LWBattleFieldEpidemicPath, "mjc_YBJQ_zhenying_icon_s1"))
    elseif self.role == EpidemicZoneRole.Farmer then
      self.textTmpTitle:SetLocalText("YiBianJinQu_camp_name_2")
      self.textTmpCamp1Title:SetLocalText("YiBianJinQu_match_result_tips_3")
      self.textTmpDesc:SetLocalText("YiBianJinQu_camp_select_tips_4")
      self.imgTypeIcon:LoadSprite(string.format(LoadPath.LWBattleFieldEpidemicPath, "mjc_YBJQ_zhenying_icon_s2"))
      self.partner = nil
      for k, v in ipairs(self.group.roles or {}) do
        if v and v.role == self.role and not v.oneself then
          self.partner = v
          break
        end
      end
      if self.partner then
        self.textTmpServer:SetText(string.format("#%s", self.partner.serverId))
        self.textTmpCamp1AllianceName:SetText(string.format("[%s]%s", self.partner.abbr, self.partner.name))
        self.imgFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, self.partner.icon))
        self.imgFlag:SetNativeSize()
      end
    end
  end
end

function UIActEpidemicCampResultView:PlayAnim()
  self:ClearAnimPlayer()
  self.compCamp0:SetActive(true)
  self.compCamp1:SetActive(true)
  local titleKey = self.groupIndex == ActEpidemicUtils.Group1 and "YiBianJinQu_trivial_tips_5" or "YiBianJinQu_trivial_tips_6"
  self.textTmpTitleTop:SetLocalText("YiBianJinQu_match_result_tips_1", Localization:GetString(titleKey))
  self.compCamp0skill0:Setup(ActEpidemicUtils.GetLordSkillArbiter())
  self.compCamp0skill1:Setup(ActEpidemicUtils.GetLordSkillPassive())
  self:SetupMode(0)
  local animName = self.role == EpidemicZoneRole.Lord and "UIActEpidemicCampResultViewBlueIn" or "UIActEpidemicCampResultViewRedIn"
  self.animatorUIActEpidemicCampResultView:Play(animName)
  self.tweenSequence = DOTween.Sequence()
  self.tweenSequence:InsertCallback(2.2, function()
    self:SetupMode(1)
  end)
  self.tweenSequence:InsertCallback(2.4, function()
    self.compCamp0:SetActive(self.role == EpidemicZoneRole.Lord)
    self.compCamp1:SetActive(self.role == EpidemicZoneRole.Farmer)
  end)
  if self.role == EpidemicZoneRole.Farmer then
    local bSame = ActEpidemicUtils.GetMyGroupIndex() == self.groupIndex
    CS.UIGray.SetGray(self.btnContact.transform, not bSame, true)
  end
  self:RefreshRedCount()
  DataCenter.LWSoundManager:PlaySound(93018, false)
end

function UIActEpidemicCampResultView:OnBtnShowAllianceInfoClick()
  if self.partner then
    UIUtil.TryShowAllianceInfo(self.partner.serverId, self.partner.allianceId, self.partner.name)
  end
end

function UIActEpidemicCampResultView:ClearAnimPlayer()
  if self.tweenSequence then
    self.tweenSequence:Kill()
    self.tweenSequence = nil
  end
end

function UIActEpidemicCampResultView:AddTimer()
  self:DeleteTimer()
  local bShowSkillInfos = self.role == EpidemicZoneRole.Lord
  if not bShowSkillInfos then
    return
  end
  self.timer_action = BindCallback(self, self.TimerAction)
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  self.timer:Start()
end

function UIActEpidemicCampResultView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  self.timeSign = 0
  self.timer_action = nil
end

function UIActEpidemicCampResultView:TimerAction()
  self.timeSign = self.timeSign + 1
  if self.timeSign == 3 then
    self:DeleteTimer()
    self:OnBtnBackgroundClick()
  end
end

UIActEpidemicCampResultView.OnCreate = OnCreate
UIActEpidemicCampResultView.OnDestroy = OnDestroy
UIActEpidemicCampResultView.OnEnable = OnEnable
UIActEpidemicCampResultView.OnDisable = OnDisable
UIActEpidemicCampResultView.ComponentDefine = ComponentDefine
UIActEpidemicCampResultView.ComponentDestroy = ComponentDestroy
UIActEpidemicCampResultView.DataDefine = DataDefine
UIActEpidemicCampResultView.DataDestroy = DataDestroy
UIActEpidemicCampResultView.OnAddListener = OnAddListener
UIActEpidemicCampResultView.OnRemoveListener = OnRemoveListener
UIActEpidemicCampResultView.OnBtnBackgroundClick = OnBtnBackgroundClick
UIActEpidemicCampResultView.OnBtnContactClick = OnBtnContactClick
return UIActEpidemicCampResultView
