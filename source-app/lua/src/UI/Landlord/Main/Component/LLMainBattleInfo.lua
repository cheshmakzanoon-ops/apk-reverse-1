local base = UIAsyncContainer
local LLMainBattleInfo = BaseClass("LLMainBattleInfo", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local LL_MAX_CNT = 120
local EMPTY_R5 = "zonewar_landlord_limit_1068"
local EMPTY_DEF = "zonewar_landlord_desc_1007"

function LLMainBattleInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainBattleInfo:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainBattleInfo:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.input = self.viewSkin:AddComponent(self, UIInput, 1)
  self.modifyBtn = self.viewSkin:AddComponent(self, UIButton, 2)
  self.modifyBtn:SetOnClick(function()
    self:OnModifyBtnClick()
  end)
  self.playerHead = self.viewSkin:AddComponent(self, UICommonHead, 3)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.cancelBtn = self.viewSkin:AddComponent(self, UIButton, 5)
  self.cancelBtn:SetOnClick(function()
    self:OnCancelBtnClick()
  end)
  self.confirmBtn = self.viewSkin:AddComponent(self, UIButton, 6)
  self.confirmBtn:SetOnClick(function()
    self:OnConfirmBtnClick()
  end)
  self.translateCancelBtn = self.viewSkin:AddComponent(self, UIButton, 7)
  self.translateCancelBtn:SetOnClick(function()
    self:OnTranslateCancelBtnClick()
  end)
  self.translateBtn = self.viewSkin:AddComponent(self, UIButton, 8)
  self.translateBtn:SetOnClick(function()
    self:OnTranslateBtnClick()
  end)
  self.defaultInputText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.transText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.transDoingText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.transBtnRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.transTextRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.defaultRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 14)
  self.translatingRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.inputText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.compAL = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.compEmpty = self.viewSkin:AddComponent(self, UIBaseComponent, 18)
  self.btnJoin = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnJoin:SetOnClick(function()
    self:OnBtnJoinClick()
  end)
  self.textPlaceHolder = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
end

function LLMainBattleInfo:ComponentDestroy()
  self.viewSkin = nil
  self.input = nil
  self.modifyBtn = nil
  self.playerHead = nil
  self.textName = nil
  self.cancelBtn = nil
  self.confirmBtn = nil
  self.translateCancelBtn = nil
  self.translateBtn = nil
  self.defaultInputText = nil
  self.transText = nil
  self.transDoingText = nil
  self.transBtnRoot = nil
  self.transTextRoot = nil
  self.defaultRoot = nil
  self.translatingRoot = nil
  self.inputText = nil
  self.compAL = nil
  self.compEmpty = nil
  self.btnJoin = nil
  self.textPlaceHolder = nil
end

function LLMainBattleInfo:DataDefine()
  self.cacheInput = ""
  self.strAnnounce = ""
  self.is_input = nil
  self:SetInputTextPreferSize()
  self.transText:SetText("")
  self.input:SetCharacterLimit(LL_MAX_CNT)
  self.input:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self:ShowCanTranslateUI()
end

function LLMainBattleInfo:DataDestroy()
  self.cacheInput = ""
  self.strAnnounce = ""
  self.is_input = nil
  self.refreshCur = nil
end

function LLMainBattleInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.RefreshLeader)
  self:AddUIListener(EventId.LandlordAllyMsgTranslateFinish, self.OnTranslateFinish)
end

function LLMainBattleInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.RefreshLeader)
  self:RemoveUIListener(EventId.LandlordAllyMsgTranslateFinish, self.OnTranslateFinish)
  base.OnRemoveListener(self)
end

function LLMainBattleInfo:OnModifyBtnClick()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  if DataCenter.AllianceBaseDataManager:IsR5() then
    self:SetInputState(true)
    self:RefreshTranslateRootUIShow(false)
    self:RefreshRootUIShow(2)
    self:SetInputTextPreferSize()
  else
    UIUtil.ShowTipsId(393018)
  end
end

function LLMainBattleInfo:OnCancelBtnClick()
  self:SetInputState(false)
  self:RefreshTranslateRootUIShow(true)
  self:RefreshRootUIShow(1)
end

function LLMainBattleInfo:OnConfirmBtnClick()
  local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
  if not canChat then
    return
  end
  if string.IsNullOrEmpty(self.cacheInput) then
    self.cacheInput = Localization:GetString(EMPTY_DEF)
  end
  if self.cacheInput ~= self.strAnnounce then
    self.transText:SetText("")
    self:ShowCanTranslateUI()
  else
    self:RefreshTranslateRootUIShow(true)
  end
  ActMgr:ReqActAllyMsg(self.cacheInput)
  self:InitInput(self.cacheInput)
  self:RefreshRootUIShow(1)
end

function LLMainBattleInfo:OnTranslateCancelBtnClick()
  self:RefreshRootUIShow(1)
  self.translateCancelBtn:SetActive(false)
  self.translateBtn:SetActive(true)
end

function LLMainBattleInfo:OnTranslateBtnClick()
  local text = self.transText:GetText()
  if not string.IsNullOrEmpty(text) then
    self:OnTranslateFinish(text)
    self:RefreshRootUIShow(3)
    return
  end
  local actData = ActMgr:GetActData()
  if actData then
    actData:SetIsTranslating(true)
    local translateManager = DataCenter.MailDataManager.Translate
    translateManager:Translate(actData, translateManager.TranslateEnum.LandlordAllyMsg)
  end
  self:ShowTranslatingUI()
  self:RefreshRootUIShow(4)
end

function LLMainBattleInfo:OnBtnJoinClick()
  self.view.ctrl:CloseSelf()
  DataCenter.BuildBubbleManager.OnClickCallBack({
    buildBubbleType = BuildBubbleType.NoAlliance
  })
end

function LLMainBattleInfo:IptOnValueChange(value)
  self.cacheInput = value
  self:SetInputTextPreferSize()
end

function LLMainBattleInfo:SetInputTextPreferSize()
  self.inputText:SetPreferSize({x = 705, y = 140})
  self.textPlaceHolder:SetPreferSize({x = 705, y = 140})
end

function LLMainBattleInfo:RefreshCur(refreshCur)
  self.refreshCur = refreshCur
  self:SetActive(true)
  self:RefreshView()
end

function LLMainBattleInfo:UpdateData()
  if self.refreshCur == true and self.is_input == true then
    self.refreshCur = nil
    return
  end
  self.refreshCur = nil
  local inAl = LuaEntry.Player:IsInAlliance()
  self.compAL:SetActive(inAl)
  self.compEmpty:SetActive(not inAl)
  if inAl then
    self:RefreshLeader()
    self:RefreshContent()
  end
end

function LLMainBattleInfo:RefreshLeader(uid)
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data == nil then
    self.textName:SetActive(false)
    self.playerHead:SetData()
    self.playerHead:SetEnableClickShowInfo(false, true)
    return
  end
  self.textName:SetActive(true)
  local tmpUid = uid or data.leaderUid
  self.textName:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.leaderName, tmpUid))
  local info = UIUtil.GetPlayerInfoShowByUid(tmpUid)
  if info == nil or string.IsNullOrEmpty(info.name) then
    self.playerHead:SetData(tmpUid, data.leaderPic, data.leaderPicVer)
    self.playerHead:SetEnableClickShowInfo(true, true)
  else
    self.playerHead:ParseHeadInfo(info)
  end
end

function LLMainBattleInfo:RefreshContent()
  local actData = ActMgr:GetActData()
  self:RefreshRootUIShow(1)
  local msg = actData ~= nil and actData.allyMsg or ""
  self:InitInput(msg)
  local transMsg = actData ~= nil and actData.translateMsg or ""
  if not string.IsNullOrEmpty(msg) then
    if string.IsNullOrEmpty(transMsg) then
      self:ShowCanTranslateUI()
      self:RefreshRootUIShow(1)
    else
      self:OnTranslateFinish(transMsg)
      self:RefreshRootUIShow(3)
    end
  end
end

function LLMainBattleInfo:InitInput(announce)
  self:SetInputState(false)
  if string.IsNullOrEmpty(announce) then
    self.strAnnounce = Localization:GetString(EMPTY_DEF)
  else
    self.strAnnounce = announce
  end
  self.defaultInputText:SetText(self.strAnnounce)
end

function LLMainBattleInfo:SetInputState(is_input)
  self.is_input = is_input
  if is_input then
    self.defaultInputText:SetActive(false)
    if string.IsNullOrEmpty(self.strAnnounce) or self.strAnnounce == Localization:GetString(EMPTY_DEF) then
      self.input:SetText("")
    else
      self.input:SetText(self.strAnnounce)
    end
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

function LLMainBattleInfo:OnTranslateFinish(data)
  local msg = type(data) == "table" and data.translateMsg or data
  self:RefreshTranslateRootUIShow(true)
  self.translateCancelBtn:SetActive(true)
  self.translateBtn:SetActive(false)
  self.transText:SetText(msg)
  self.transText:SetActive(true)
  self.transDoingText:SetActive(false)
  self:RefreshRootUIShow(3)
end

function LLMainBattleInfo:ShowTranslatingUI()
  self:RefreshTranslateRootUIShow(true)
  self.translateBtn:SetActive(false)
  self.translateCancelBtn:SetActive(false)
  self.transText:SetActive(false)
  self.transDoingText:SetLocalText(120039)
  self.transDoingText:SetActive(true)
end

function LLMainBattleInfo:ShowCanTranslateUI()
  self:RefreshTranslateRootUIShow(true)
  local showTrans = true
  if string.IsNullOrEmpty(self.strAnnounce) or self.strAnnounce == Localization:GetString(EMPTY_DEF) then
    showTrans = false
  end
  self.translateBtn:SetActive(showTrans and not DataCenter.AllianceBaseDataManager:IsR5())
  self.translateCancelBtn:SetActive(false)
  self.transText:SetActive(false)
  self.transDoingText:SetActive(false)
end

function LLMainBattleInfo:RefreshTranslateRootUIShow(flag)
  self.transBtnRoot:SetActive(flag)
end

function LLMainBattleInfo:RefreshRootUIShow(index)
  self.transTextRoot:SetActive(index == 3)
  self.defaultRoot:SetActive(index == 1)
  self.input:SetActive(index == 2)
  self.translatingRoot:SetActive(index == 4)
end

return LLMainBattleInfo
