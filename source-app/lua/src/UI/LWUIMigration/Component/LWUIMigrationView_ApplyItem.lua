local LWUIMigrationView_ApplyItem = BaseClass("LWUIMigrationView_ApplyItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local head_path = "Head"
local text_desc_path = "WordBg/DescText"
local text_time_path = "WordBg/TimeText"
local btn_info_path = "WordBg/BtnInfo"
local btn_trans_path = "WordBg/BtnTrans"
local text_server_path = "ServerText"
local text_name_path = "NameText"
local text_power_path = "PowerText"
local btn_accept_path = "BtnAccept"
local img_type1_path = "BtnAccept/Info/Icon1"
local img_type2_path = "BtnAccept/Info/Icon2"
local img_type3_path = "BtnAccept/Info/Icon3"
local text_add_path = "BtnAccept/Info/Text"
local btn_refuses_path = "BtnRefuses"
local state_path = "State"
local text_state_path = "State/StateText"
local migration_sign_path = "MigrationSign"

function LWUIMigrationView_ApplyItem:OnCreate()
  base.OnCreate(self)
  self.IsTranslating = false
  self.bg = self:AddComponent(UIImage, bg_path)
  self.head = self:AddComponent(UICommonHead, head_path)
  self.head:SetEnableClickShowInfo(true, true)
  self.text_desc = self:AddComponent(UIText, text_desc_path)
  self.text_time = self:AddComponent(UIText, text_time_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnBtnInfoClick))
  self.btn_trans = self:AddComponent(UIButton, btn_trans_path)
  self.btn_trans:SetOnClick(BindCallback(self, self.OnBtnTransClick))
  self.text_server = self:AddComponent(UIText, text_server_path)
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.text_power = self:AddComponent(UIText, text_power_path)
  self.btn_accept = self:AddComponent(UIButton, btn_accept_path)
  self.btn_accept:SetOnClick(BindCallback(self, self.OnBtnAcceptClick))
  self.img_type1 = self:AddComponent(UIImage, img_type1_path)
  self.img_type2 = self:AddComponent(UIImage, img_type2_path)
  self.img_type3 = self:AddComponent(UIImage, img_type3_path)
  self.text_add = self:AddComponent(UIText, text_add_path)
  self.btn_refuses = self:AddComponent(UIButton, btn_refuses_path)
  self.btn_refuses:SetOnClick(BindCallback(self, self.OnBtnRefusesClick))
  self.state = self:AddComponent(UIImage, state_path)
  self.text_state = self:AddComponent(UIText, text_state_path)
  self.migrationSign = self:AddComponent(UIBaseComponent, migration_sign_path)
end

function LWUIMigrationView_ApplyItem:OnDestroy()
  self.IsTranslating = false
  self.migrationSign = nil
  self.playerInfo = nil
  base.OnDestroy(self)
end

function LWUIMigrationView_ApplyItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationPlayerUpdate, self.UpdateData)
  self:AddUIListener(EventId.ActMigrationMarkPlayerUpdate, self.RefreshMigrationSign)
end

function LWUIMigrationView_ApplyItem:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationPlayerUpdate, self.UpdateData)
  self:RemoveUIListener(EventId.ActMigrationMarkPlayerUpdate, self.RefreshMigrationSign)
  base.OnRemoveListener(self)
end

function LWUIMigrationView_ApplyItem:OnBtnAcceptClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local sInfo = DataCenter.ActMigrationManager:GetMyServerInfo()
  local zInfo = DataCenter.ActMigrationManager:GetMyZoneStandard()
  local identity = self.playerInfo.identity
  local isFupin = sInfo ~= nil and sInfo:IsFupin()
  local cur, max = 0, 0
  if identity == ActMigrationIdentity.High or not isFupin then
    if identity == ActMigrationIdentity.High then
      max = zInfo ~= nil and zInfo.strongNum or 0
      cur = sInfo ~= nil and sInfo.highPlayerIn or 0
    elseif identity == ActMigrationIdentity.Normal then
      max = zInfo ~= nil and zInfo.normalNum or 0
      cur = sInfo ~= nil and sInfo.playerIn or 0
    elseif identity == ActMigrationIdentity.Low then
      max = zInfo ~= nil and zInfo.lowNum or 0
      cur = sInfo ~= nil and sInfo.lowPlayerIn or 0
    elseif identity == ActMigrationIdentity.SuperLow then
      max = zInfo ~= nil and zInfo.superLowNum or 0
      cur = sInfo ~= nil and sInfo.superLowPlayerIn or 0
    end
    if max < cur + 1 then
      UIUtil.ShowTipsId("migration_activity_tips_20024")
      return
    end
  elseif isFupin then
    max = sInfo ~= nil and sInfo.curFupinScore or 0
    cur = self.playerInfo and self.playerInfo.applyScore or 0
    if max < cur then
      UIUtil.ShowTipsId("migration_activity_tips_20057")
      return
    end
    local rNum = DataCenter.ActMigrationManager.remainNumber
    if rNum <= 0 then
      UIUtil.ShowTipsId("migration_activity_tips_20058")
      return
    end
  end
  local name = ""
  if self.playerInfo ~= nil then
    name = UIUtil.FormatServerAllianceName(self.playerInfo.serverId, "", self.playerInfo.name)
  end
  local tipText
  if identity == ActMigrationIdentity.High or not isFupin then
    tipText = Localization:GetString("migration_activity_tips_20041", name)
  else
    tipText = Localization:GetString("migration_activity_desc_1001", name, string.GetFormattedSeparatorNum(cur), string.GetFormattedSeparatorNum(max - cur), DataCenter.ActMigrationManager.remainNumber - 1)
  end
  UIUtil.ShowSecondMessageByParam({
    tipText = tipText,
    btnNum = 2,
    showToggle = false,
    alignment = CommonUtil.IsArabicAutoMirrorOpen() and CS.UnityEngine.TextAnchor.MiddleRight or CS.UnityEngine.TextAnchor.MiddleLeft,
    sureAction = function()
      DataCenter.ActMigrationManager:ReqApproval(self.playerInfo.uid, 1)
    end
  })
end

function LWUIMigrationView_ApplyItem:OnBtnRefusesClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local name = ""
  if self.playerInfo ~= nil then
    name = UIUtil.FormatServerAllianceName(self.playerInfo.serverId, "", self.playerInfo.name)
  end
  UIUtil.ShowSecondMessageByParam({
    tipText = Localization:GetString("migration_activity_tips_20042", name),
    btnNum = 2,
    showToggle = false,
    sureAction = function()
      DataCenter.ActMigrationManager:ReqApproval(self.playerInfo.uid, 0)
    end
  })
end

function LWUIMigrationView_ApplyItem:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.playerInfo == nil then
    return
  end
  DataCenter.ActMigrationManager:DoMsgReport(self.playerInfo)
end

function LWUIMigrationView_ApplyItem:OnBtnTransClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.IsTranslating or self.playerInfo == nil then
    return
  end
  self.IsTranslating = true
  DataCenter.ActMigrationManager:DoMsgTrans(self.playerInfo.message, function(result, str)
    if result and self.IsTranslating and self.text_desc then
      self.text_desc:SetText(str)
    end
  end)
end

function LWUIMigrationView_ApplyItem:SetData(playerInfo)
  self.IsTranslating = false
  self.playerInfo = playerInfo
  self:UpdateUI()
end

function LWUIMigrationView_ApplyItem:UpdateData(uid)
  if self.playerInfo and uid == self.playerInfo.uid then
    self.playerInfo = DataCenter.ActMigrationManager:GetPlayerDataByUid(uid)
    self:UpdateUI()
  end
end

function LWUIMigrationView_ApplyItem:UpdateUI()
  local playerInfo = self.playerInfo
  self.head:ParseHeadInfo(playerInfo)
  local msg = playerInfo.message
  if string.IsNullOrEmpty(msg) then
    msg = Localization:GetString("migration_activity_tips_20022")
    self.btn_info:SetActive(false)
    self.btn_trans:SetActive(false)
  else
    self.btn_info:SetActive(true)
    self.btn_trans:SetActive(true)
  end
  self.text_desc:SetText(msg)
  self.text_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(playerInfo.time))
  self.text_server:SetText(UIUtil.FormatServerAllianceName(playerInfo.serverId, nil, playerInfo.name, playerInfo.uid))
  local serverStr
  if string.IsNullOrEmpty(playerInfo.abbr) or string.IsNullOrEmpty(playerInfo.alName) then
    serverStr = Localization:GetString("100206")
  else
    serverStr = "[" .. playerInfo.abbr .. "] " .. playerInfo.alName
  end
  self.text_name:SetText(serverStr)
  self.text_power:SetText(Localization:GetString("100644") .. ": " .. string.GetFormattedSeparatorNum(math.floor(playerInfo.power)))
  local mgr = DataCenter.ActMigrationManager
  local state = playerInfo.applyState
  local _, stageInfo = mgr:GetCurStageInfo()
  local sFlag = stageInfo ~= nil and stageInfo.state == ActMigrationState.Apply
  self.btn_accept:SetActive(sFlag and state == 1)
  self.btn_refuses:SetActive(sFlag and state == 1)
  self.state:SetActive(state ~= 1)
  local bgPath, kPath = mgr:GetApplyStateImg(state)
  self.bg:LoadSpriteAuto(bgPath)
  if state == 1 then
    local identity = playerInfo.identity
    local sInfo = DataCenter.ActMigrationManager:GetMyServerInfo()
    local isFupin = sInfo ~= nil and sInfo:IsFupin()
    if identity == ActMigrationIdentity.High or not isFupin then
      local path = mgr:GetPlayerTypeImg(identity)
      self.img_type1:LoadSpriteAuto(path)
      self.img_type2:SetActive(false)
      self.img_type3:SetActive(false)
      self.text_add:SetText("\195\1511")
    else
      local path = mgr:GetPlayerTypeImg(ActMigrationIdentity.SuperLow)
      self.img_type1:LoadSpriteAuto(path)
      self.img_type2:SetActive(true)
      path = mgr:GetPlayerTypeImg(ActMigrationIdentity.Low)
      self.img_type2:LoadSpriteAuto(path)
      self.img_type3:SetActive(true)
      path = mgr:GetPlayerTypeImg(ActMigrationIdentity.Normal)
      self.img_type3:LoadSpriteAuto(path)
      self.text_add:SetText(string.GetFormattedStr(playerInfo.applyScore))
    end
  else
    self.state:LoadSpriteAuto(kPath)
    self.text_state:SetLocalText(state == 2 and "migration_activity_interface_10043" or "migration_activity_interface_10044")
    if state == 2 then
      self.text_state:SetColorRGBA255(9, 155, 74, 255)
    else
      self.text_state:SetColorRGBA255(196, 130, 125, 255)
    end
  end
  self:RefreshMigrationSign()
end

function LWUIMigrationView_ApplyItem:RefreshMigrationSign()
  if self.migrationSign ~= nil then
    local isMigrationSign = self.playerInfo ~= nil and DataCenter.ActMigrationManager:IsPlayerMarked(self.playerInfo.uid) or false
    self.migrationSign:SetActive(isMigrationSign)
  end
end

return LWUIMigrationView_ApplyItem
