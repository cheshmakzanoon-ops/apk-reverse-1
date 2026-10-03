local base = UIBaseView
local OfficialView = BaseClass("OfficialView", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Setting = CS.GameEntry.Setting
local UITimeMgr = UITimeManager:GetInstance()
local Cls_conqueror = "UI.UIGovernment.Official.Component.OfficialConqueror"
local Prefab_conqueror = "Assets/Main/Prefabs/UI/UIGovernment/OfficialConqueror.prefab"
local Cls_native = "UI.UIGovernment.Official.Component.OfficialNative"
local Prefab_native = "Assets/Main/Prefabs/UI/UIGovernment/OfficialNative.prefab"

function OfficialView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function OfficialView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function OfficialView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgGender = self.viewSkin:AddComponent(self, UIImage, 1)
  self.btn_back = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btn_back:SetOnClick(function()
    self:OnBtn_backClick()
  end)
  self.autoBtn = self.viewSkin:AddComponent(self, UIButton, 3)
  self.autoBtn:SetOnClick(function()
    self:OnAutoBtnClick()
  end)
  self.btn_set = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btn_set:SetOnClick(function()
    self:OnBtn_setClick()
  end)
  self.btn_rank = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btn_rank:SetOnClick(function()
    self:OnBtn_rankClick()
  end)
  self.btn_set_text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.autoBtnIcon = self.viewSkin:AddComponent(self, UIImage, 7)
  self.autoBtnText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.text_title = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.badges_icon = self.viewSkin:AddComponent(self, UIImage, 10)
  self.badges_title = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.info_btn = self.viewSkin:AddComponent(self, UIButton, 12)
  self.info_btn:SetOnClick(function()
    self:OnInfo_btnClick()
  end)
  self.time_mode_change_btn = self.viewSkin:AddComponent(self, UIButton, 13)
  self.time_mode_change_btn:SetOnClick(function()
    self:OnTime_mode_change_btnClick()
  end)
  self.timing_text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.time_tip_text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 16)
  self.place_holder = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
end

function OfficialView:ComponentDestroy()
  self.viewSkin = nil
  self.imgGender = nil
  self.btn_back = nil
  self.autoBtn = nil
  self.btn_set = nil
  self.btn_rank = nil
  self.btn_set_text = nil
  self.autoBtnIcon = nil
  self.autoBtnText = nil
  self.text_title = nil
  self.badges_icon = nil
  self.badges_title = nil
  self.info_btn = nil
  self.time_mode_change_btn = nil
  self.timing_text = nil
  self.time_tip_text = nil
  self.scrollRect = nil
  self.place_holder = nil
  self.compContent = nil
end

function OfficialView:DataDefine()
  self.btn_set:SetActive(false)
  self.autoBtn:SetActive(false)
  local param = self:GetUserData()
  self.serverId = LuaEntry.Player:GetSourceServerId()
  if param and toInt(param) > 0 then
    self.serverId = toInt(param)
    self.param = param
  end
  self.cdIndex = 0
  self.cdIndexUpdateTime = 0
  self.setBtnUnusable = false
  self.isServer = Setting:GetBool(SettingKeys.OFFICIAL_APPLY_TIME_SHOW_MODE, true)
  SFSNetwork.SendMessage(MsgDefines.GetKingInfo, self.serverId)
  SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, self.serverId)
  self:Init()
end

function OfficialView:DataDestroy()
  self.conqueror = nil
  self.native = nil
  self.cdIndex = nil
  self.cdIndexUpdateTime = nil
  self.isPresident = nil
  self.setBtnUnusable = nil
  self.isServer = nil
  self.autoAgreeInfo = nil
  self.autoAgreeShow = nil
  self.autoAgreeTime = nil
end

function OfficialView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrossKingdomPositionsRefresh, self.UpdatePositionsData)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.OnAppoint)
  self:AddUIListener(EventId.OfficialGetPositionCd, self.OnPositionCdDataUpdate)
  self:AddUIListener(EventId.OfficialGetAutoAgreeInfo, self.OnOfficialGetAutoAgreeInfo)
  self:AddUIListener(EventId.OnPassDay, self.SendKingdomPositionAutoAgreeGet)
end

function OfficialView:OnRemoveListener()
  self:RemoveUIListener(EventId.CrossKingdomPositionsRefresh, self.UpdatePositionsData)
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.OnAppoint)
  self:RemoveUIListener(EventId.OfficialGetPositionCd, self.OnPositionCdDataUpdate)
  self:RemoveUIListener(EventId.OfficialGetAutoAgreeInfo, self.OnOfficialGetAutoAgreeInfo)
  self:RemoveUIListener(EventId.OnPassDay, self.SendKingdomPositionAutoAgreeGet)
  base.OnRemoveListener(self)
end

function OfficialView:OnBtn_backClick()
  self.ctrl:CloseSelf()
end

function OfficialView:OnAutoBtnClick()
  if self.autoAgreeShow and self.isPresident and self.autoAgreeInfo then
    local now = UITimeMgr:GetServerTime()
    if self.autoAgreeInfo.autoAgreeTime and self.autoAgreeInfo.autoAgreeTime - now >= 0 then
      local diff = math.modf((self.autoAgreeInfo.autoAgreeTime - now) / 1000)
      UIUtil.ShowTips(Localization:GetString("officer_apply_054", UITimeMgr:SecondToFmtStringWithoutHour(diff)))
    elseif self.autoAgreeInfo.autoAgree then
      UIUtil.ShowConfirmNew({
        contentText = Localization:GetString("officer_apply_055"),
        btnNum = 2,
        showToggle = false,
        confirmBtnParam = {
          action = function()
            SFSNetwork.SendMessage(MsgDefines.KingdomPositionAutoAgree, 0)
          end
        }
      })
    else
      UIUtil.ShowConfirmNew({
        contentText = Localization:GetString("officer_apply_052"),
        btnNum = 2,
        showToggle = false,
        confirmBtnParam = {
          action = function()
            SFSNetwork.SendMessage(MsgDefines.KingdomPositionAutoAgree, 1)
          end
        }
      })
    end
  end
end

function OfficialView:OnBtn_setClick()
  if self.isPresident then
    if self.setBtnUnusable then
      UIUtil.ShowTipsId("officer_apply_037")
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.OfficialCDSetting, {anim = true}, self.cdIndex)
  end
end

function OfficialView:OnBtn_rankClick()
  if DataCenter.BuildManager.MainLv >= 10 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankTable, {anim = true, hideTop = true}, self.serverId)
  else
    UIUtil.ShowTipsId(451038)
  end
end

function OfficialView:OnInfo_btnClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("457028")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function OfficialView:OnTime_mode_change_btnClick()
  local isServer = not self.isServer
  self.isServer = isServer
  self:RefreshTimingGroup(isServer)
  Setting:SetBool(SettingKeys.OFFICIAL_APPLY_TIME_SHOW_MODE, isServer)
end

function OfficialView:UpdatePositionsData()
  local presidentInfo = DataCenter.GovernmentManager:GetCurPresident(self.serverId)
  local conquerorPositions = DataCenter.GovernmentManager:GetConquerorPositionByServerId(self.serverId)
  local conquerorServerId
  if conquerorPositions then
    for _, v in pairs(conquerorPositions) do
      conquerorServerId = v.serverId
      break
    end
  end
  if conquerorServerId then
    if self.conqueror == nil then
      self.conqueror = self:LoadComponentAsync(Cls_conqueror, Prefab_conqueror, self.compContent)
      self.conqueror:SetSiblingIndex(1)
    end
    self.conqueror:SetActive(true)
    self.conqueror:ReInit(conquerorServerId, self.serverId)
    self.place_holder:SetActive(false)
    self:SetKingGender()
  else
    if self.conqueror then
      self.conqueror:SetActive(false)
    end
    self.place_holder:SetActive(true)
    if presidentInfo == nil or presidentInfo.uid == 0 or presidentInfo.uid == "" or presidentInfo.gender == nil then
      self:SetKingGender()
    else
      self:SetKingGender(presidentInfo.gender)
    end
  end
  if self.native == nil then
    self.native = self:LoadComponentAsync(Cls_native, Prefab_native, self.compContent)
  end
  self.native:ReInit(self.serverId)
end

function OfficialView:OnAppoint(isAppoint)
  if isAppoint and toInt(self.serverId) > 0 then
    SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, self.serverId)
  end
end

function OfficialView:OnPositionCdDataUpdate(msg)
  if self.isPresident and msg then
    self.btn_set:SetActive(true)
    self.cdIndex = msg.cdIndex
    self.cdIndexUpdateTime = msg.cdIndexUpdateTime
    local offset = self.cdIndexUpdateTime - UITimeMgr:GetServerTime()
    if 0 <= offset then
      self.setBtnUnusable = true
      UIGray.SetGray(self.btn_set.transform, true, true)
    else
      self.cdIndexUpdateTime = 0
      self.btn_set_text:SetLocalText("officer_apply_btn_002")
      UIGray.SetGray(self.btn_set.transform, false, true)
      self.setBtnUnusable = false
    end
  else
    self.btn_set:SetActive(false)
  end
end

function OfficialView:OnOfficialGetAutoAgreeInfo()
  self.autoAgreeInfo = DataCenter.GovernmentManager:GetKingdomPositionAutoAgreeInfo()
  self:RefreshAutoBtn()
end

function OfficialView:SendKingdomPositionAutoAgreeGet()
  self.autoAgreeShow = DataCenter.GovernmentManager:GetAutoAgreeShow()
  DataCenter.GovernmentManager:SendKingdomPositionAutoAgreeGet()
end

function OfficialView:Init()
  if self.param then
    self.badges_icon:LoadSpriteAuto(DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(self.param))
    self.badges_title:SetText("#" .. self.param)
    self.text_title:SetActive(false)
    self.badges_title:SetActive(true)
    self.badges_icon:SetActive(true)
  else
    self.text_title:SetLocalText("457006")
    self.text_title:SetActive(true)
    self.badges_title:SetActive(false)
    self.badges_icon:SetActive(false)
  end
  self.isPresident = LuaEntry.Player:IsPresident(self.param or LuaEntry.Player:GetSourceServerId())
  if self.isPresident then
    DataCenter.GovernmentManager:SendKingdomPositionAppointmentCd()
    self:SendKingdomPositionAutoAgreeGet()
  end
  self:RefreshTimingGroup(self.isServer)
  self:UpdatePositionsData()
end

function OfficialView:RefreshAutoBtn()
  self.autoAgreeTime = nil
  if self.autoAgreeShow and self.isPresident and self.autoAgreeInfo then
    self.autoBtn:SetActive(true)
    local now = UITimeMgr:GetServerTime()
    local iconName
    if self.autoAgreeInfo.autoAgreeTime and self.autoAgreeInfo.autoAgreeTime - now >= 0 then
      iconName = "cfm_tongyong_anniu_1.png"
      local diff = math.modf((self.autoAgreeInfo.autoAgreeTime - now) / 1000)
      self.autoBtnText:SetText(UITimeMgr:SecondToFmtStringWithoutHour(diff))
      self.autoAgreeTime = self.autoAgreeInfo.autoAgreeTime
    elseif self.autoAgreeInfo.autoAgree then
      iconName = "cfm_tongyong_anniu_5.png"
      self.autoBtnText:SetLocalText("officer_apply_btn_004")
    else
      iconName = "cfm_tongyong_anniu_3.png"
      self.autoBtnText:SetLocalText("officer_apply_btn_003")
    end
    self.autoBtnIcon:LoadSpriteAuto(string.format(LoadPath.CommonNewPath, iconName))
  else
    self.autoBtn:SetActive(false)
  end
end

function OfficialView:RefreshTimingGroup(isServer)
  if isServer then
    self.time_tip_text:SetLocalText("officer_apply_047")
  else
    self.time_tip_text:SetLocalText("officer_apply_046")
  end
  self:RefreshCurTime(isServer)
end

function OfficialView:RefreshCurTime(isServer)
  if self.timing_text ~= nil then
    local timeText = ""
    local curTime = UITimeMgr:GetServerTime()
    if isServer then
      timeText = UITimeMgr:TimeStampToTimeForServer(curTime, true)
    else
      timeText = UITimeMgr:TimeStampToTimeForLocalSimple(curTime, true)
    end
    self.timing_text:SetText(timeText)
  end
end

function OfficialView:SetKingGender(gender)
  local fileName
  if gender == 1 then
    fileName = "zyf_renmingguanzhi_man.png"
  elseif gender == 2 then
    fileName = "zyf_renmingguanzhi_woman.png"
  end
  self.imgGender:SetActive(fileName ~= nil)
  if fileName ~= nil then
    self.imgGender:LoadSpriteAsyncWithCallback(string.format(LoadPath.UIGovernment, fileName), function()
      if self.imgGender then
        self.imgGender:SetNativeSize()
      end
    end)
  end
end

function OfficialView:Update1000MS()
  if self.isPresident and self.cdIndexUpdateTime > 0 then
    local offset = self.cdIndexUpdateTime - UITimeManager:GetInstance():GetServerTime()
    if 0 <= offset then
      self.btn_set_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(offset))
    else
      self.cdIndexUpdateTime = 0
      self.btn_set_text:SetLocalText("officer_apply_btn_002")
      UIGray.SetGray(self.btn_set.transform, false, true)
      self.setBtnUnusable = false
    end
  end
  self:RefreshCurTime(self.isServer)
  if self.autoAgreeTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local diff = self.autoAgreeTime - now
    if 0 <= diff then
      diff = math.modf(diff / 1000)
      self.autoBtnText:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutHour(diff))
    else
      self:RefreshAutoBtn()
    end
  end
end

return OfficialView
