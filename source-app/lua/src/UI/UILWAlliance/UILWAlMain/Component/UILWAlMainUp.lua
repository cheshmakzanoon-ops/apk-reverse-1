local UILWAlMainUp = BaseClass("UILWAlMainUp", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")
local AllianceRateStarItem = require("UI.UIAlliance.UIAllianceInfo.Component.AllianceRateStarItem")
local icon_path = "FlagIcon"
local input_path = "InputField"
local default_input_path = "DefaultScroll/Viewport/Content/DefaultText"
local modify_btn_path = "BtnRoot/ModifyBtn"
local share_btn_path = "BtnRoot/ShareBtn"
local cancel_btn_path = "BtnRoot/CancelBtn"
local confirm_btn_path = "BtnRoot/ConfirmBtn"
local name_text_path = "NameText"
local gift_level_text_path = "GiftLevelText"
local star_title_path = "StarContent/StarText"
local star_item_path = "StarContent/AllianceRateStarItem"
local power_title_path = "PowerContent/PowerText"
local power_text_path = "PowerContent/PowerValue"
local leader_title_path = "LeaderContent/LeaderText"
local leader_text_path = "LeaderContent/LeaderValue"
local member_title_path = "MemberContent/MemberText"
local member_text_path = "MemberContent/MemberValue"
local lang_value_path = "LangContent/LangValue"
local trans_btn_path = "BtnRoot/TranslateBtnRoot/TranslateBtn"
local trans_transText_path = "TranslateScroll/Viewport/Content/TranslateText"
local trans_transDoingText_path = "TranslatingScroll/Viewport/Content/TranslatingText"
local trans_transBtnRoot_path = "BtnRoot/TranslateBtnRoot"
local trans_transFinishBtn = "BtnRoot/TranslateBtnRoot/TranslateFinishBtn"
local input_text_path = "InputField/ModifyScroll/Viewport/Content/Text"
local transTextRoot_path = "TranslateScroll"
local defaultRoot_path = "DefaultScroll"
local transltingRoot_path = "TranslatingScroll"
local STAR_TITLE_TXT = "alliance_invite_point_average"
local POWER_TITLE_TXT = 393001
local LEADER_TITLE_TXT = 390020
local MEMBER_TITLE_TXT = 455089

function UILWAlMainUp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMainUp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMainUp:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.input = self:AddComponent(UIInput, input_path)
  self.input:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.defaultInputText = self:AddComponent(UIText, default_input_path)
  self.modifyBtn = self:AddComponent(UIButton, modify_btn_path)
  self.modifyBtn:SetOnClick(function()
    self:OnModifyClick()
  end)
  self.shareBtn = self:AddComponent(UIButton, share_btn_path)
  self.shareBtn:SetActive(false)
  self.shareBtn:SetOnClick(function()
    self:OnShareClick()
  end)
  self.cancelBtn = self:AddComponent(UIButton, cancel_btn_path)
  self.cancelBtn:SetOnClick(function()
    self:OnCancelClick()
  end)
  self.confirmBtn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirmBtn:SetOnClick(function()
    self:OnConfirmClick()
  end)
  self.translateCancleBtn = self:AddComponent(UIButton, trans_transFinishBtn)
  self.translateCancleBtn:SetOnClick(function()
    self:RefreshRootUIShow(1)
    self.translateCancleBtn.gameObject:SetActive(false)
    self.translateBtn.gameObject:SetActive(true)
  end)
  self.translateBtn = self:AddComponent(UIButton, trans_btn_path)
  self.transText = self:AddComponent(UIText, trans_transText_path)
  self.transDoingText = self:AddComponent(UIText, trans_transDoingText_path)
  self.transBtnRoot = self.transform:Find(trans_transBtnRoot_path).gameObject
  self.transTextRoot = self.transform:Find(transTextRoot_path).gameObject
  self.defaultRoot = self.transform:Find(defaultRoot_path).gameObject
  self.transltingRoot = self.transform:Find(transltingRoot_path).gameObject
  self.inputText = self:AddComponent(UIText, input_text_path)
  self.inputText:SetPreferSize({x = 600, y = 260})
  self.transText:SetText("")
  self.nameText = self:AddComponent(UIText, name_text_path)
  self.giftLevelText = self:AddComponent(UIText, gift_level_text_path)
  self.starTitle = self:AddComponent(UIText, star_title_path)
  self.starItem = self:AddComponent(AllianceRateStarItem, star_item_path)
  self.powerTitle = self:AddComponent(UIText, power_title_path)
  self.powerText = self:AddComponent(UIText, power_text_path)
  self.leaderTitle = self:AddComponent(UIText, leader_title_path)
  self.leaderText = self:AddComponent(UIText, leader_text_path)
  self.memberTitle = self:AddComponent(UIText, member_title_path)
  self.memberText = self:AddComponent(UIText, member_text_path)
  self.lang_value = self:AddComponent(UIText, lang_value_path)
  self.starTitle:SetLocalText(STAR_TITLE_TXT)
  self.powerTitle:SetLocalText(POWER_TITLE_TXT)
  self.leaderTitle:SetLocalText(LEADER_TITLE_TXT)
  self.memberTitle:SetLocalText(MEMBER_TITLE_TXT)
end

function UILWAlMainUp:ComponentDestroy()
  self.icon = nil
  self.input = nil
  self.defaultInputText = nil
  self.modifyBtn = nil
  self.shareBtn = nil
  self.cancelBtn = nil
  self.confirmBtn = nil
  self.nameText = nil
  self.starTitle = nil
  self.starItem = nil
  self.giftLevelText = nil
  self.powerTitle = nil
  self.powerText = nil
  self.leaderTitle = nil
  self.leaderText = nil
  self.memberTitle = nil
  self.memberText = nil
  self.lang_value = nil
end

function UILWAlMainUp:DataDefine()
  self.cacheInput = ""
  self.strAnnounce = ""
end

function UILWAlMainUp:DataDestroy()
  self.cacheInput = nil
  self.strAnnounce = nil
end

function UILWAlMainUp:OnEnable()
  base.OnEnable(self)
end

function UILWAlMainUp:OnDisable()
  base.OnDisable(self)
end

function UILWAlMainUp:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMainUp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMainUp:RefreshContent()
  local alInfos = self.view.ctrl:GetAlInfos()
  if alInfos then
    self.icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, alInfos.icon))
    self:InitInput(alInfos.announce)
    self.nameText:SetText(alInfos.name)
    if alInfos.scoreInfo then
      self.starItem:RefreshByBaseInfo(alInfos.scoreInfo)
    else
      self.starItem:RefreshByBaseInfo({comprehensiveScore = 0})
    end
    self.giftLevelText:SetLocalText(300665, alInfos.gift)
    self.powerText:SetText(alInfos.power)
    self.leaderText:SetText(alInfos.leader)
    self.memberText:SetText(alInfos.member)
    self.lang_value:SetLocalText(alInfos.language)
  end
  self:RefreshRootUIShow(1)
  self:JudgeCanTranslate(alInfos)
end

function UILWAlMainUp:InitInput(announce)
  self:SetInputState(false)
  if announce ~= nil and announce ~= "" then
    if self.strAnnounce ~= announce then
    end
    self.strAnnounce = announce
  else
    self.strAnnounce = Localization:GetString("128024")
  end
  self.defaultInputText:SetText(self.strAnnounce)
end

function UILWAlMainUp:SetInputState(is_input)
  if is_input then
    self.defaultInputText:SetActive(false)
    self.input:SetText(self.strAnnounce)
    self.input:SetInteractable(true)
    self.modifyBtn:SetActive(false)
    self.cancelBtn:SetActive(true)
    self.confirmBtn:SetActive(true)
  else
    self.input:SetText("")
    self.input:SetInteractable(false)
    self.defaultInputText:SetActive(true)
    self.modifyBtn:SetActive(true)
    self.cancelBtn:SetActive(false)
    self.confirmBtn:SetActive(false)
  end
end

function UILWAlMainUp:IptOnValueChange(value)
  self.cacheInput = value
  self.inputText:SetPreferSize({x = 600, y = 260})
end

function UILWAlMainUp:OnModifyClick()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  local canChange = DataCenter.AllianceBaseDataManager:IsSelfLeader() or DataCenter.AllianceBaseDataManager:IsR4orR5()
  if canChange then
    self:SetInputState(true)
    self:RefreshTranslateRootUIShow(false)
    self:RefreshRootUIShow(2)
    self.inputText:SetPreferSize({x = 600, y = 260})
  else
    UIUtil.ShowTipsId(393018)
  end
end

function UILWAlMainUp:OnShareClick()
end

function UILWAlMainUp:OnCancelClick()
  self:SetInputState(false)
  self:RefreshTranslateRootUIShow(true)
  self:RefreshRootUIShow(1)
end

function UILWAlMainUp:OnConfirmClick()
  local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
  if not canChat then
    return
  end
  if self.cacheInput == nil or self.cacheInput == "" then
    self.cacheInput = Localization:GetString("128024")
  end
  if self.cacheInput ~= self.strAnnounce then
    self.transText:SetText("")
    self:ShowCanTranslateUI()
  else
    self:RefreshTranslateRootUIShow(true)
  end
  SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, "", "", -1, "", "", "", "", self.cacheInput)
  DataCenter.AllianceBaseDataManager:SetAnnounce(self.cacheInput)
  self:InitInput(self.cacheInput)
  self:RefreshRootUIShow(1)
  AlPostEventLog.PostEventLog_Declaration()
end

function UILWAlMainUp:OnClickTranslate()
  self.view.ctrl:TranslateAnnounce()
  self:ShowTranslatingUI()
  self:RefreshRootUIShow(4)
end

function UILWAlMainUp:JudgeCanTranslate(alInfos)
  if alInfos == nil then
    return
  end
  local msg = alInfos.translateMsg
  if not string.IsNullOrEmpty(alInfos.announce) then
    self.translateBtn:SetOnClick(function()
      self:OnTranslateBtnClick(alInfos)
    end)
    if string.IsNullOrEmpty(msg) then
      self:ShowCanTranslateUI()
      self:RefreshRootUIShow(1)
    else
      self:OnAllianceAnnouncementTranslateFinish(msg)
      self:RefreshRootUIShow(3)
    end
  end
end

function UILWAlMainUp:OnTranslateBtnClick(alInfos)
  local translating = alInfos.translating
  local text = self.transText:GetText()
  if not string.IsNullOrEmpty(text) then
    self:OnAllianceAnnouncementTranslateFinish(text)
    self:RefreshRootUIShow(3)
    return
  end
  if translating == 0 or not translating then
    self:OnClickTranslate()
  end
end

function UILWAlMainUp:OnAllianceAnnouncementTranslateFinish(msg)
  self:RefreshTranslateRootUIShow(true)
  self.translateCancleBtn.gameObject:SetActive(true)
  self.translateBtn.gameObject:SetActive(false)
  self.transText:SetText(msg)
  self.transText.gameObject:SetActive(true)
  self.transDoingText.gameObject:SetActive(false)
  local detalHeight = self.defaultInputText:GetHeight() - 0.5
  self:RefreshRootUIShow(3)
end

function UILWAlMainUp:ShowTranslatingUI()
  self:RefreshTranslateRootUIShow(true)
  self.translateBtn.gameObject:SetActive(flase)
  self.translateCancleBtn.gameObject:SetActive(false)
  self.transText.gameObject:SetActive(false)
  self.transDoingText:SetText(CS.GameEntry.Localization:GetString("120039"))
  self.transDoingText.gameObject:SetActive(true)
end

function UILWAlMainUp:ShowCanTranslateUI()
  self:RefreshTranslateRootUIShow(true)
  self.translateBtn.gameObject:SetActive(true)
  self.translateCancleBtn.gameObject:SetActive(false)
  self.transText.gameObject:SetActive(false)
  self.transDoingText.gameObject:SetActive(false)
end

function UILWAlMainUp:RefreshTranslateRootUIShow(flag)
  self.transBtnRoot.gameObject:SetActive(flag)
end

function UILWAlMainUp:RefreshRootUIShow(index)
  self.transTextRoot:SetActive(index == 3)
  self.defaultRoot:SetActive(index == 1)
  self.input.gameObject:SetActive(index == 2)
  self.transltingRoot.gameObject:SetActive(index == 4)
end

return UILWAlMainUp
