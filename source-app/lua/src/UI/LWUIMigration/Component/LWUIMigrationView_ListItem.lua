local LWUIMigrationView_ListItem = BaseClass("LWUIMigrationView_ListItem", UIAsyncContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ZoneItem = require("UI.LWUIMigration.Component.LWUIMigrationView_ZoneItem")
local zone_item_path = "ZoneItem"
local bg_path = "WordBg"
local text_msg_path = "WordBg/MsgText"
local btn_trans_path = "WordBg/MsgText/TransBtn"
local btn_info_path = "WordBg/MsgText/InfoBtn"
local sp_path = "WordBg/Layout/Sp"
local text_sp_path = "WordBg/Layout/Sp/SpText"
local super_low_path = "WordBg/Layout/SuperLow"
local text_super_low_path = "WordBg/Layout/SuperLow/SLText"
local low_path = "WordBg/Layout/Low"
local text_low_path = "WordBg/Layout/Low/LText"
local normal_path = "WordBg/Layout/Normal"
local text_normal_path = "WordBg/Layout/Normal/NText"
local strong_path = "WordBg/Layout/Strong"
local text_strong_path = "WordBg/Layout/Strong/SText"
local un_open_path = "WordBg/Layout/UnOpen"
local lang_path = "WordBg/Lang%d"
local text_lang_path = "WordBg/Lang%d/LangText%d"
local text_state_path = "WordBg/StateText"
local btn_req_path = "WordBg/ReqBtn"
local state_g_path = "WordBg/StateG"
local text_state_g_path = "WordBg/StateG/StateGText"
local state_r_path = "WordBg/StateR"
local text_state_r_path = "WordBg/StateR/StateRText"
local IMG_IDENTITY_O = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_sanji_2.png"
local IMG_IDENTITY_M = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_shenpi_erji_dichen_1.png"
local COLOR_L_GREEN = Color.New(0.8705882352941177, 0.9803921568627451, 0.8901960784313725, 1)
local COLOR_L_GRAY = Color.New(0.9411764705882353, 0.9294117647058824, 1.0, 1)
local COLOR_GREEN = Color.New(0.03529411764705882, 0.6078431372549019, 0.2901960784313726, 1)
local COLOR_BLACK = Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1)

function LWUIMigrationView_ListItem:OnCreate()
  base.OnCreate(self)
  self.IsTranslating = false
  self.zone_item = self:AddComponent(ZoneItem, zone_item_path)
  self.zone_item:SetClickCb(BindCallback(self, self.OnBtnReqClick))
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(BindCallback(self, self.OnBtnReqClick))
  self.text_msg = self:AddComponent(UIText, text_msg_path)
  self.btn_trans = self:AddComponent(UIButton, btn_trans_path)
  self.btn_trans:SetOnClick(BindCallback(self, self.OnBtnTransClick))
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnBtnInfoClick))
  self.btn_sp = self:AddComponent(UIButton, sp_path)
  self.btn_sp:SetOnClick(function()
    DataCenter.ActMigrationManager:OpenFupinGuide()
  end)
  self.text_sp = self:AddComponent(UIText, text_sp_path)
  self.super_low = self:AddComponent(UIImage, super_low_path)
  self.text_super_low = self:AddComponent(UIText, text_super_low_path)
  self.low = self:AddComponent(UIImage, low_path)
  self.text_low = self:AddComponent(UIText, text_low_path)
  self.normal = self:AddComponent(UIImage, normal_path)
  self.text_normal = self:AddComponent(UIText, text_normal_path)
  self.strong = self:AddComponent(UIImage, strong_path)
  self.text_strong = self:AddComponent(UIText, text_strong_path)
  self.un_open = self:AddComponent(UIBaseComponent, un_open_path)
  self.img_lang = {}
  self.text_lang = {}
  for i = 1, 2 do
    self.img_lang[i] = self:AddComponent(UIImage, string.format(lang_path, i))
    self.text_lang[i] = self:AddComponent(UIText, string.format(text_lang_path, i, i))
  end
  self.text_state = self:AddComponent(UIText, text_state_path)
  self.btn_req = self:AddComponent(UIButton, btn_req_path)
  self.btn_req:SetOnClick(BindCallback(self, self.OnBtnReqClick))
  self.state_g = self:AddComponent(UIBaseComponent, state_g_path)
  self.text_state_g = self:AddComponent(UIText, text_state_g_path)
  self.state_r = self:AddComponent(UIBaseComponent, state_r_path)
  self.text_state_r = self:AddComponent(UIText, text_state_r_path)
end

function LWUIMigrationView_ListItem:OnDestroy()
  self.IsTranslating = false
  self:DeleteTimer()
  base.OnDestroy(self)
end

function LWUIMigrationView_ListItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationServerInfoUpdate, self.OnInfoUpdate)
end

function LWUIMigrationView_ListItem:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationServerInfoUpdate, self.OnInfoUpdate)
  base.OnRemoveListener(self)
end

function LWUIMigrationView_ListItem:OnBtnReqClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationRequest, {anim = true}, self.sInfo.serverId)
end

function LWUIMigrationView_ListItem:OnBtnTransClick()
  if self.IsTranslating or self.sInfo == nil then
    return
  end
  self.IsTranslating = true
  DataCenter.ActMigrationManager:DoMsgTrans(self.sInfo.notice, function(result, str)
    if result and self.IsTranslating and self.text_msg then
      self.text_msg:SetText(str)
    end
  end)
end

function LWUIMigrationView_ListItem:OnBtnInfoClick()
  local wordStr = self.sInfo ~= nil and self.sInfo.notice or nil
  if string.IsNullOrEmpty(wordStr) then
    return
  end
  local pInfo = self.sInfo ~= nil and self.sInfo.presidentInfo or nil
  if pInfo == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
    type = ReportType.actMigrateSNotice,
    uid = pInfo.uid,
    name = pInfo.name,
    msg = wordStr
  })
end

function LWUIMigrationView_ListItem:OnInfoUpdate(serverId)
  local sId = self.sInfo ~= nil and self.sInfo.serverId or nil
  if sId == serverId then
    self.sInfo = DataCenter.ActMigrationManager:GetServerInfo(sId)
    self:UpdateInfo()
  end
end

function LWUIMigrationView_ListItem:SetData(sInfo)
  self.IsTranslating = false
  self.sInfo = sInfo
  self:RefreshView()
end

function LWUIMigrationView_ListItem:UpdateData()
  if self.sInfo == nil then
    return
  end
  self.zone_item:SetData(self.sInfo, false)
  self.zone_item:ShowPlayer(true)
  self:UpdateInfo()
end

function LWUIMigrationView_ListItem:UpdateInfo()
  self:DeleteTimer()
  local sInfo = self.sInfo
  local mgr = DataCenter.ActMigrationManager
  local myInfo = mgr:GetMyInfo()
  local msg = sInfo.notice
  if string.IsNullOrEmpty(msg) then
    msg = Localization:GetString("migration_activity_tips_20037")
    self.btn_trans:SetActive(false)
    self.btn_info:SetActive(false)
  else
    self.btn_trans:SetActive(true)
    self.btn_info:SetActive(true)
  end
  self.text_msg:SetText(msg)
  local zInfo = mgr:GetZoneStandard(sInfo.serverState)
  local identity = myInfo ~= nil and myInfo.identity or 0
  local isFupin = sInfo:IsFupin()
  self.btn_sp:SetActive(isFupin)
  self.super_low:SetActive(not isFupin)
  self.low:SetActive(not isFupin)
  self.normal:SetActive(not isFupin)
  local curFupinScore = sInfo.curFupinScore or 0
  local myScore = myInfo ~= nil and myInfo.score or 0
  local maxSuperLow = zInfo ~= nil and zInfo.superLowNum or 0
  local maxLow = zInfo ~= nil and zInfo.lowNum or 0
  local maxNormal = zInfo ~= nil and zInfo.normalNum or 0
  if isFupin then
    self.text_sp:SetText(string.GetFormattedStr(curFupinScore))
    if identity == ActMigrationIdentity.High then
      self.btn_sp:LoadSpriteAuto(IMG_IDENTITY_O)
    else
      self.btn_sp:LoadSpriteAuto(curFupinScore < myScore and IMG_IDENTITY_M or IMG_IDENTITY_O)
    end
  else
    self.text_super_low:SetText(sInfo.superLowPlayerIn .. "/" .. maxSuperLow)
    self.super_low:LoadSpriteAuto(maxSuperLow <= sInfo.superLowPlayerIn and IMG_IDENTITY_M or IMG_IDENTITY_O)
    self.text_low:SetText(sInfo.lowPlayerIn .. "/" .. maxLow)
    self.low:LoadSpriteAuto(maxLow <= sInfo.lowPlayerIn and IMG_IDENTITY_M or IMG_IDENTITY_O)
    self.text_normal:SetText(sInfo.playerIn .. "/" .. maxNormal)
    self.normal:LoadSpriteAuto(maxNormal <= sInfo.playerIn and IMG_IDENTITY_M or IMG_IDENTITY_O)
  end
  local maxStrong = zInfo ~= nil and zInfo.strongNum or 0
  self.text_strong:SetText(sInfo.highPlayerIn .. "/" .. maxStrong)
  self.strong:LoadSpriteAuto(maxStrong <= sInfo.highPlayerIn and IMG_IDENTITY_M or IMG_IDENTITY_O)
  local myLang = ChatInterface.getLanguageName()
  local langList = sInfo.languageList or {}
  for i = 1, 2 do
    local lang = langList[i]
    local flag = not string.IsNullOrEmpty(lang)
    self.img_lang[i]:SetActive(flag)
    if flag then
      flag = myLang == lang
      self.img_lang[i]:SetColor(flag and COLOR_L_GREEN or COLOR_L_GRAY)
      self.text_lang[i]:SetColor(flag and COLOR_GREEN or COLOR_BLACK)
      self.text_lang[i]:SetLocalText(lang)
    end
  end
  local reqSId = myInfo ~= nil and myInfo.serverId or 0
  local reqState = myInfo ~= nil and myInfo.applyState or 0
  local bFlag, gFlag, rFlag = false, false, false
  local stateKey = "migration_activity_tips_20027"
  local flag = false
  local sR, sG, sB = 42, 40, 48
  local cdTime = sInfo.applyCdEndTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if 0 < cdTime and cdTime > curTime then
    rFlag = true
    self.text_state_r:SetLocalText("migration_activity_interface_10044")
    self.timer = TimerManager:GetInstance():DelayInvoke(BindCallback(self, self.UpdateInfo), (cdTime - curTime) / 1000)
  elseif reqSId == sInfo.serverId then
    gFlag = true
    self.text_state_g:SetLocalText(reqState == 1 and "migration_activity_interface_10042" or "migration_activity_interface_10043")
  else
    bFlag = true
    local flag1 = DataCenter.BuildManager.MainLv >= sInfo.applyLevel
    local flag2 = LuaEntry.Player.power >= sInfo.applyPower
    local flag4 = true
    local curPresident = DataCenter.GovernmentManager:GetCurPresident()
    if curPresident and curPresident.uid == LuaEntry.Player:GetUid() then
      flag4 = false
    elseif DataCenter.AllianceBaseDataManager:IsSelfLeader() then
      flag4 = false
    end
    local checkNum, maxNum, flag3 = 0, 0, false
    if identity == ActMigrationIdentity.High or not isFupin then
      if identity == ActMigrationIdentity.High then
        checkNum = sInfo.highPlayerIn
        maxNum = maxStrong
      elseif identity == ActMigrationIdentity.Normal then
        checkNum = sInfo.playerIn
        maxNum = maxNormal
      elseif identity == ActMigrationIdentity.Low then
        checkNum = sInfo.lowPlayerIn
        maxNum = maxLow
      elseif identity == ActMigrationIdentity.SuperLow then
        checkNum = sInfo.superLowPlayerIn
        maxNum = maxSuperLow
      end
      flag3 = checkNum < maxNum
    elseif isFupin then
      checkNum = myScore
      maxNum = curFupinScore
      flag3 = checkNum <= maxNum
    end
    flag = flag1 and flag2 and flag3 and flag4
    stateKey = flag and "migration_activity_tips_20043" or "migration_activity_tips_20044"
    sR = flag and 9 or 245
    sG = flag and 155 or 60
    sB = flag and 74 or 61
  end
  self.text_state:SetLocalText(stateKey)
  self.text_state:SetColorRGBA255(sR, sG, sB, 255)
  self.btn_req:SetActive(bFlag)
  self.state_g:SetActive(gFlag)
  self.state_r:SetActive(rFlag)
  local _, info = mgr:GetCurStageInfo()
  local uoFlag = info == nil or info.state == ActMigrationState.Notice
  self.un_open:SetActive(uoFlag)
  if uoFlag then
    self.text_low:SetText("???")
    self.text_normal:SetText("???")
    self.text_strong:SetText("???")
    self.text_sp:SetText("???")
  end
end

function LWUIMigrationView_ListItem:AddTimer()
  self:DeleteTimer()
  if self.timer_action == nil then
    function self.timer_action(_)
      self:TimerAction()
    end
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, true, false)
  self.timer:Start()
end

function LWUIMigrationView_ListItem:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

return LWUIMigrationView_ListItem
