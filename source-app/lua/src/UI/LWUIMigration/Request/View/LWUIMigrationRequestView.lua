local LWUIMigrationRequestView = BaseClass("LWUIMigrationRequestView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AlItem = require("UI.LWUIMigration.Request.Component.LWUIMigration_AllianceItem")
local close_btn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local king_path = "Common_bg_orange/Top/King"
local kPlayer_path = "Common_bg_orange/Top/King/Player"
local text_title_path = "Common_bg_orange/Top/King/TitleText"
local text_name_path = "Common_bg_orange/Top/King/NameText"
local text_lang_path = "Common_bg_orange/Top/Right/Lang%d/LangText%d"
local btn_rank_path = "Common_bg_orange/Top/Right/RankBtn"
local text_server_path = "Common_bg_orange/Top/ServerText"
local al_path = "Common_bg_orange/Alliance/Alliance"
local text_num_path = "Common_bg_orange/Requirements/List/Line%d/Text%d"
local img_arrow_path = "Common_bg_orange/Requirements/List/Line%d/Arrow%d"
local img_icon_path = "Common_bg_orange/Requirements/List/Line%d/Icon%d"
local line_4_path = "Common_bg_orange/Requirements/List/Line4"
local line_sp_path = "Common_bg_orange/Requirements/List/LineSp"
local text_num_sp_path = "Common_bg_orange/Requirements/List/LineSp/TextSp"
local btn_sp_path = "Common_bg_orange/Requirements/List/LineSp/TextSp/BtnSp"
local img_arrow_sp_path = "Common_bg_orange/Requirements/List/LineSp/ArrowSp"
local req_path = "Common_bg_orange/Req"
local input_path = "Common_bg_orange/Req/Input"
local inputField_path = "Common_bg_orange/Req/Input/InputField"
local inputField_placeholder_path = "Common_bg_orange/Req/Input/InputField/Placeholder"
local text_count_path = "Common_bg_orange/Req/Input/CountText"
local text_cd_path = "Common_bg_orange/Req/CDText"
local btn_req_path = "Common_bg_orange/Req/ReqBtn"
local text_req_path = "Common_bg_orange/Req/ReqBtn/Text"
local item_group_path = "Common_bg_orange/Req/ReqBtn/Item"
local item_icon_path = "Common_bg_orange/Req/ReqBtn/Item/ItemIcon"
local text_item_path = "Common_bg_orange/Req/ReqBtn/Item/ItemNum"
local state_g_path = "Common_bg_orange/Req/StateG"
local text_state_g_path = "Common_bg_orange/Req/StateG/StateGText"
local text_wait_path = "Common_bg_orange/WaitText"
local btn_info_path = "Common_bg_orange/WaitText/BtnInfo"
local MAX_AL_CHAR = MAX_AL_NAME_CHAR * 2
local IMG_ARROW_A = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_xuanze_duihao.png"
local IMG_ARROW_X = "Assets/Main/Sprites/UI/LWUIMigration/UIchampion_img_out.png"

function LWUIMigrationRequestView:OnCreate()
  base.OnCreate(self)
  self.serverId = self:GetUserData() or 0
  self.sInfo = DataCenter.ActMigrationManager:GetServerInfo(self.serverId) or {}
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.king = self:AddComponent(UIBaseComponent, king_path)
  self.kPlayer = self:AddComponent(UICommonHead, kPlayer_path)
  self.kPlayer:SetEnableClickShowInfo(true, true)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.languageLists = {}
  for i = 1, 2 do
    self.languageLists[i] = self:AddComponent(UIText, string.format(text_lang_path, i, i))
  end
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_rank:SetOnClick(BindCallback(self, self.OnBtnRankClick))
  self.text_server = self:AddComponent(UIText, text_server_path)
  self.als = {}
  self.nums = {}
  self.arrows = {}
  for i = 1, 4 do
    self.nums[i] = self:AddComponent(UIText, string.format(text_num_path, i, i))
    self.arrows[i] = self:AddComponent(UIImage, string.format(img_arrow_path, i, i))
    if i == 4 then
      local path = string.format(img_icon_path, i, i)
      self.identityIcon = self:AddComponent(UIImage, path)
      self.identityBtn = self:AddComponent(UIButton, path)
      self.identityBtn:SetOnClick(BindCallback(self, self.OnBtnIdentityClick))
    else
      self.als[i] = self:AddComponent(AlItem, al_path .. i)
    end
  end
  self.line_4 = self:AddComponent(UIBaseComponent, line_4_path)
  self.line_sp = self:AddComponent(UIBaseComponent, line_sp_path)
  self.nums[5] = self:AddComponent(UIText, text_num_sp_path)
  self.btn_sp = self:AddComponent(UIButton, btn_sp_path)
  self.btn_sp:SetOnClick(function()
    DataCenter.ActMigrationManager:OpenFupinGuide()
  end)
  self.arrows[5] = self:AddComponent(UIImage, img_arrow_sp_path)
  self.req = self:AddComponent(UIBaseComponent, req_path)
  self.input = self:AddComponent(UIBaseComponent, input_path)
  self.inputField = self:AddComponent(UIInput, inputField_path)
  self.inputField:SetOnValueChange(function(value)
    self:OnInputFieldValueChange(value)
  end)
  self.inputField_placeholder = self:AddComponent(UIText, inputField_placeholder_path)
  self.text_count = self:AddComponent(UIText, text_count_path)
  self.text_cd = self:AddComponent(UIText, text_cd_path)
  self.btn_req = self:AddComponent(UIButton, btn_req_path)
  self.btn_req:SetOnClick(BindCallback(self, self.OnBtnReqClick))
  self.text_req = self:AddComponent(UIText, text_req_path)
  self.item_group = self:AddComponent(UIBaseComponent, item_group_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  local iconPath = DataCenter.ActMigrationManager:GetItemIcon()
  if iconPath then
    self.item_icon:LoadSpriteAuto(iconPath)
  end
  self.text_item = self:AddComponent(UIText, text_item_path)
  if self.text_item.unity_tmpro then
    self.text_item.unity_tmpro.richText = true
  end
  self:RefreshBtnTxt()
  self.state_g = self:AddComponent(UIImage, state_g_path)
  self.text_state_g = self:AddComponent(UIText, text_state_g_path)
  self.text_wait = self:AddComponent(UIText, text_wait_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local stageInfo = self:GetNextStageInfo(ActMigrationState.Migrate)
    local time = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(stageInfo.sTime)
    local strTip = Localization:GetString("migration_activity_interface_10140", time)
    UIUtil.ShowBubbleTips(strTip, self.btn_info.transform.position, 0, 30, 0, nil, nil, {reversal = true})
  end)
  self:UpdateUI()
  DataCenter.ActMigrationManager:ReqApplyPanelInfo(self.serverId)
end

function LWUIMigrationRequestView:OnDestroy()
  self.timer_action = nil
  self:DeleteTimer()
  base.OnDestroy(self)
end

function LWUIMigrationRequestView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationServerInfoUpdate, self.OnInfoUpdate)
  self:AddUIListener(EventId.RefreshItems, self.RefreshBtnTxt)
end

function LWUIMigrationRequestView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationServerInfoUpdate, self.OnInfoUpdate)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshBtnTxt)
  base.OnRemoveListener(self)
end

function LWUIMigrationRequestView:OnInfoUpdate(serverId)
  if self.serverId == serverId then
    self.sInfo = DataCenter.ActMigrationManager:GetServerInfo(self.serverId) or {}
    self:UpdateUI()
  end
end

function LWUIMigrationRequestView:RefreshBtnTxt()
  local curHave = DataCenter.ActMigrationManager:GetItemHave()
  local pInfo = DataCenter.ActMigrationManager:GetMyPersonStandard()
  local costNum = pInfo ~= nil and pInfo.cost or 1
  local myInfo = DataCenter.ActMigrationManager:GetMyInfo()
  local migrated = myInfo ~= nil and myInfo.migrated or 0
  if migrated == 1 then
    costNum = 0
  end
  local str = curHave < costNum and "<color=#f53c3d>" or "<color=#099b4a>"
  self.text_item:SetText(str .. curHave .. "</color>/" .. costNum)
end

function LWUIMigrationRequestView:OnBtnReqClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local mgr = DataCenter.ActMigrationManager
  local myInfo = mgr:GetMyInfo()
  local sId = myInfo ~= nil and myInfo.serverId or 0
  local applyState = myInfo ~= nil and myInfo.applyState or 0
  if sId ~= 0 then
    local bSelf = sId == self.serverId
    if applyState == 1 then
      if bSelf then
        mgr:ReqCancelApply()
      else
        UIUtil.ShowTipsId("migration_activity_tips_20008")
      end
      return
    elseif applyState == 2 then
      if bSelf then
        mgr:ReqGiveUp(self.serverId)
      else
        local str = Localization:GetString("migration_activity_tips_20009", sId)
        UIUtil.ShowTips(str)
      end
      return
    end
  end
  if not self.flag1 then
    UIUtil.ShowTipsId("migration_activity_tips_20005")
    return
  end
  if not self.flag2 then
    UIUtil.ShowTipsId("migration_activity_tips_20006")
    return
  end
  if not self.flag3 then
    UIUtil.ShowTipsId("migration_activity_interface_10136")
    return
  end
  if not self.flag4 then
    if self.line_sp:GetActive() then
      UIUtil.ShowTipsId("migration_activity_tips_20056")
    else
      UIUtil.ShowTipsId("migration_activity_tips_20007")
    end
    return
  end
  local value = self.inputField:GetText()
  local len = #value
  if len > MAX_AL_CHAR then
    UIUtil.ShowTipsId(120193)
    return
  end
  local migrated = myInfo ~= nil and myInfo.migrated or 0
  local curHave = mgr:GetItemHave()
  local pInfo = mgr:GetMyPersonStandard()
  local costNum = pInfo ~= nil and pInfo.cost or 1
  if migrated == 1 then
    costNum = 0
  end
  if curHave < costNum then
    GoToUtil.GotoMigrationTicketShop()
    UIUtil.ShowTipsId("migration_activity_tips_20010")
    return
  end
  local cdTime = self.sInfo.applyCdEndTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if 0 < cdTime and cdTime > curTime then
    local str = Localization:GetString("migration_activity_tips_20011", cdTime - curTime)
    UIUtil.ShowTips(str)
    return
  end
  local day = ""
  local stateInfo = self:GetNextStageInfo(ActMigrationState.Migrate)
  if stateInfo ~= nil then
    local date = UITimeManager:GetInstance():TimeStampToLocalDate(stateInfo.sTime)
    local hour = date.hour
    local exStr = 12 < hour and "pm" or "am"
    hour = 12 < hour and hour - 12 or hour
    local date2 = UITimeManager:GetInstance():TimeStampToLocalDate(stateInfo.eTime)
    local hour2 = date2.hour
    local exStr2 = 12 < hour2 and "pm" or "am"
    hour2 = 12 < hour2 and hour2 - 12 or hour2
    day = string.format("%0d/%0d %0d%s ~ %0d/%0d %0d%s", date.month, date.day, hour, exStr, date2.month, date2.day, hour2, exStr2)
  end
  
  local function cb()
    local msg = self.inputField:GetText()
    mgr:ReqApply(self.serverId, msg)
  end
  
  local tipText = Localization:GetString("migration_activity_tips_20012", costNum, day)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMigrationRequestConfirm, {anim = true}, tipText, cb)
end

function LWUIMigrationRequestView:OnBtnRankClick()
  if DataCenter.BuildManager.MainLv >= 10 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankTable, {anim = true, hideTop = true}, self.serverId)
  else
    UIUtil.ShowTipsId(451038)
  end
end

function LWUIMigrationRequestView:OnInputFieldValueChange(_)
  local value = self.inputField:GetText()
  local bNull = string.IsNullOrEmpty(value)
  local len = bNull and 0 or #value
  self.inputField_placeholder:SetActive(bNull)
  self.text_count:SetText(len .. "/" .. MAX_AL_CHAR)
  if not (self.flag1 and self.flag2 and self.flag3 and self.flag4) or len > MAX_AL_CHAR then
    CS.UIGray.SetGray(self.btn_req.transform, true, true)
  else
    CS.UIGray.SetGray(self.btn_req.transform, false, true)
  end
end

function LWUIMigrationRequestView:OnBtnIdentityClick()
  local strTip = Localization:GetString("migration_activity_tips_20040")
  UIUtil.ShowBubbleTips(strTip, self.identityBtn.transform.position, 0, -30, 0, nil, nil)
end

function LWUIMigrationRequestView:UpdateUI()
  self:UpdateTop()
  self:UpdateAl()
  self:UpdateReq()
end

function LWUIMigrationRequestView:UpdateTop()
  local kInfo = self.sInfo.presidentInfo
  if kInfo then
    self.king:SetActive(true)
    self.kPlayer:ParseHeadInfo(kInfo)
    self.text_title:SetLocalText(457202)
    self.text_name:SetText(UIUtil.FormatAllianceAndName(kInfo.abbr, kInfo.name, kInfo.uid))
  else
    self.king:SetActive(false)
  end
  local langList = self.sInfo.languageList or {}
  for i, v in ipairs(self.languageLists) do
    local lang = langList[i]
    local flag = not string.IsNullOrEmpty(lang)
    v.transform.parent.gameObject:SetActive(flag)
    if flag then
      v:SetLocalText(lang)
    end
  end
  local str = Localization:GetString("800941")
  self.text_server:SetText(str .. [[

<size=60>#]] .. self.serverId)
end

function LWUIMigrationRequestView:UpdateAl()
  local alList = self.sInfo.allianceList or {}
  for i, v in ipairs(self.als) do
    v:SetData(alList[i], self.serverId)
  end
end

function LWUIMigrationRequestView:GetNextStageInfo(checkState)
  local mgr = DataCenter.ActMigrationManager
  local stage, info = mgr:GetCurStageInfo()
  local state = info ~= nil and info.state or ActMigrationState.Notice
  local bLast = false
  while state ~= checkState do
    local tmpInfo = mgr:GetStageInfo(stage + 1)
    if tmpInfo == nil then
      bLast = true
      break
    end
    info = tmpInfo
    stage = stage + 1
    state = info ~= nil and info.state or ActMigrationState.Notice
  end
  return info, bLast
end

function LWUIMigrationRequestView:LoadArrSprite(idx, flag)
  local arr = self.arrows[idx]
  if arr == nil then
    return
  end
  arr:SetActive(true)
  arr:LoadSpriteAuto(flag and IMG_ARROW_A or IMG_ARROW_X)
end

function LWUIMigrationRequestView:UpdateReq()
  self.endTime1 = nil
  self.endTime2 = nil
  self.endTime3 = nil
  local applyLevel = self.sInfo.applyLevel or 0
  self.nums[1]:SetText("\226\137\165 Lv." .. applyLevel)
  self.flag1 = applyLevel <= DataCenter.BuildManager.MainLv
  self:LoadArrSprite(1, self.flag1)
  local applyPower = self.sInfo.applyPower or 0
  self.nums[2]:SetText("\226\137\165 " .. string.GetFormattedSeparatorNum(math.floor(applyPower)))
  self.flag2 = applyPower <= LuaEntry.Player.power
  self:LoadArrSprite(2, self.flag2)
  self.nums[3]:SetLocalText("migration_activity_interface_10132")
  local flag3 = true
  local curPresident = DataCenter.GovernmentManager:GetCurPresident()
  if curPresident and curPresident.uid == LuaEntry.Player:GetUid() then
    flag3 = false
  elseif DataCenter.AllianceBaseDataManager:IsSelfLeader() then
    flag3 = false
  end
  self.flag3 = flag3
  self:LoadArrSprite(3, self.flag3)
  local mgr = DataCenter.ActMigrationManager
  local myInfo = mgr:GetMyInfo()
  local zInfo = mgr:GetZoneStandard(self.sInfo.serverState)
  local identity = myInfo ~= nil and myInfo.identity or 0
  local isFupin = self.sInfo.IsFupin and self.sInfo:IsFupin() or false
  local checkNum, maxNum
  if identity == ActMigrationIdentity.High or not isFupin then
    if identity == ActMigrationIdentity.High then
      checkNum = self.sInfo.highPlayerIn or 0
      maxNum = zInfo ~= nil and zInfo.strongNum or 0
    elseif identity == ActMigrationIdentity.SuperLow then
      checkNum = self.sInfo.superLowPlayerIn or 0
      maxNum = zInfo ~= nil and zInfo.superLowNum or 0
    elseif identity == ActMigrationIdentity.Low then
      checkNum = self.sInfo.lowPlayerIn or 0
      maxNum = zInfo ~= nil and zInfo.lowNum or 0
    elseif identity == ActMigrationIdentity.Normal then
      checkNum = self.sInfo.playerIn or 0
      maxNum = zInfo ~= nil and zInfo.normalNum or 0
    end
    self.line_4:SetActive(true)
    self.line_sp:SetActive(false)
    self.nums[4]:SetText(checkNum .. "/" .. maxNum)
    local imgPath = DataCenter.ActMigrationManager:GetPlayerTypeImg(identity)
    self.identityIcon:LoadSpriteAuto(imgPath)
    self.flag4 = maxNum ~= 0 and checkNum < maxNum
    self:LoadArrSprite(4, self.flag4)
  elseif isFupin then
    checkNum = myInfo ~= nil and myInfo.score or 0
    maxNum = self.sInfo.curFupinScore or 0
    self.line_4:SetActive(false)
    self.line_sp:SetActive(true)
    self.nums[5]:SetText("< " .. string.GetFormattedStr(maxNum))
    self.flag4 = maxNum ~= 0 and checkNum <= maxNum
    self:LoadArrSprite(5, self.flag4)
  end
  local _, stageInfo = mgr:GetCurStageInfo()
  local state = stageInfo ~= nil and stageInfo.state or ActMigrationState.Notice
  if state ~= ActMigrationState.Apply then
    self.req:SetActive(false)
    self.text_wait:SetActive(true)
    local info, bLast = self:GetNextStageInfo(ActMigrationState.Apply)
    if bLast then
      self.text_wait:SetLocalText("migration_activity_interface_10093")
    else
      self.endTime1 = info ~= nil and info.sTime or 0
      self:AddTimer()
    end
    if state == ActMigrationState.Notice then
      local idx = not (identity ~= ActMigrationIdentity.High and isFupin) and 4 or 5
      self.nums[idx]:SetLocalText("migration_activity_interface_10121")
    end
    return
  end
  self:DeleteTimer()
  if self.serverId == LuaEntry.Player:GetSourceServerId() then
    self.req:SetActive(false)
    self.text_wait:SetActive(true)
    self.text_wait:SetLocalText("migration_activity_tips_20034")
    return
  end
  self.req:SetActive(true)
  self.text_wait:SetActive(false)
  local applyState = myInfo ~= nil and myInfo.applyState or 0
  local sId = myInfo ~= nil and myInfo.serverId or 0
  local bFlag, sFlag, iFlag, tFlag, itemFlag = false, false, false, false
  if sId ~= 0 and sId == self.serverId then
    if applyState == 1 then
      bFlag = true
      sFlag = true
      self.text_state_g:SetLocalText("migration_activity_interface_10041")
      self.text_req:SetLocalText("migration_activity_interface_10047")
      CS.UIGray.SetGray(self.btn_req.transform, false, true)
    elseif applyState == 2 then
      sFlag = true
      tFlag = true
      self.text_state_g:SetLocalText("migration_activity_interface_10043")
      stageInfo = self:GetNextStageInfo(ActMigrationState.Migrate)
      self.endTime3 = stageInfo ~= nil and stageInfo.sTime or 0
      self:AddTimer()
    end
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local cdTime = self.sInfo.applyCdEndTime or 0
    if curTime < cdTime then
      sFlag = true
      tFlag = true
      self.text_state_g:SetLocalText("migration_activity_interface_10044")
      self.endTime2 = cdTime
      self:AddTimer()
    else
      bFlag = true
      iFlag = true
      itemFlag = true
      self.inputField:SetText("")
      self.text_req:SetLocalText("migration_activity_interface_10046")
      self:OnInputFieldValueChange()
    end
  end
  self.btn_req:SetActive(bFlag)
  self.state_g:SetActive(sFlag)
  if sFlag then
    local _, kPath = mgr:GetApplyStateImg(applyState)
    self.state_g:LoadSpriteAuto(kPath)
    if applyState == 0 then
      self.text_state_g:SetColorRGBA255(196, 130, 125, 255)
    else
      self.text_state_g:SetColorRGBA255(9, 155, 74, 255)
    end
  end
  self.input:SetActive(iFlag)
  self.text_cd:SetActive(tFlag)
  self.item_group:SetActive(itemFlag)
end

function LWUIMigrationRequestView:AddTimer()
  self:DeleteTimer()
  if self.timer_action == nil then
    function self.timer_action(_)
      self:TimerAction()
    end
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, true, false)
  self.timer:Start()
end

function LWUIMigrationRequestView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWUIMigrationRequestView:TimerAction()
  local uitMgr = UITimeManager:GetInstance()
  local curTime = uitMgr:GetServerTime()
  local remainTime = 0
  if self.endTime1 then
    remainTime = self.endTime1 - curTime or 0
    remainTime = remainTime < 0 and 0 or remainTime
    local tmpStr = [[

<size=60>]] .. uitMgr:SecondToFmtString(remainTime / 1000)
    self.text_wait:SetLocalText("migration_activity_interface_10049", tmpStr)
  elseif self.endTime2 then
    remainTime = self.endTime2 - curTime or 0
    remainTime = remainTime < 0 and 0 or remainTime
    local tmpStr = uitMgr:SecondToFmtString(remainTime / 1000)
    self.text_cd:SetLocalText("migration_activity_interface_10094", tmpStr)
  elseif self.endTime3 then
    remainTime = self.endTime3 - curTime or 0
    remainTime = remainTime < 0 and 0 or remainTime
    local tmpStr = uitMgr:SecondToFmtString(remainTime / 1000)
    self.text_cd:SetLocalText("migration_activity_interface_10095", tmpStr)
  end
  if remainTime == 0 then
    self:UpdateReq()
  end
end

return LWUIMigrationRequestView
