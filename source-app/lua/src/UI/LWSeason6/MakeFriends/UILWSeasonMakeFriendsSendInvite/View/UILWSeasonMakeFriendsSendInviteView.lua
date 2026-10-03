local UILWSeasonMakeFriendsSendInviteView = BaseClass("UILWSeasonMakeFriendsSendInviteView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local SendInviteItem = require("UI.LWSeason6.MakeFriends.UILWSeasonMakeFriendsSendInvite.Component.UILWSeasonMakeFriendsSendInviteItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local btn_send_path = "PopUpTitle/BtnSend"
local tip_c_d_path = "PopUpTitle/TipCD"
local condition1_path = "PopUpTitle/ScrollView/Viewport/Content/Condition1"
local tick1_path = "PopUpTitle/ScrollView/Viewport/Content/Condition1/tick1"
local title1_path = "PopUpTitle/ScrollView/Viewport/Content/Condition1/title1"
local condition2_path = "PopUpTitle/ScrollView/Viewport/Content/Condition2"
local tick2_path = "PopUpTitle/ScrollView/Viewport/Content/Condition2/tick2"
local title2_path = "PopUpTitle/ScrollView/Viewport/Content/Condition2/title2"
local condition3_path = "PopUpTitle/ScrollView/Viewport/Content/Condition3"
local tick3_path = "PopUpTitle/ScrollView/Viewport/Content/Condition3/tick3"
local title3_path = "PopUpTitle/ScrollView/Viewport/Content/Condition3/title3"
local condition4_path = "PopUpTitle/ScrollView/Viewport/Content/Condition4"
local tick4_path = "PopUpTitle/ScrollView/Viewport/Content/Condition4/tick4"
local title4_path = "PopUpTitle/ScrollView/Viewport/Content/Condition4/title4"
local sub_title_path = "PopUpTitle/SubTitle"
local input_field_path = "PopUpTitle/InputFieldBg/InputField"

function UILWSeasonMakeFriendsSendInviteView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.input_field:SetLocalText("s6_alliance_ally_desc26")
  self.theContent = Localization:GetString("s6_alliance_ally_desc26")
  self.title1:SetLocalText("s6_alliance_ally_tips16")
  self.title2:SetLocalText("s6_alliance_ally_tips17")
  self.title3:SetLocalText("s6_alliance_ally_tips18")
  self.title4:SetLocalText("season_camp_science_ui_43_limit")
  self.btn_send:SetOnClick(function()
    self:OnSendBtnClick()
  end)
  local officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
  if not DataCenter.AllianceBaseDataManager:IsR5() and officialPos ~= LWAlMemberOffcialType.Al_Goddess then
    self.tip_c_d:SetLocalText("s6_alliance_ally_tips15")
  else
    self.tip_c_d:SetLocalText("s6_alliance_ally_desc24")
  end
  self.data = self:GetUserData()
  if self.data ~= nil then
    self.allianceId = self.data.allianceUid or self.data.uid
    local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceId)
    if allianceInfo == nil then
      SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, self.allianceId)
    else
      self.allianceInfo = allianceInfo
      self:UpdateData()
    end
  end
end

function UILWSeasonMakeFriendsSendInviteView:OnEnable()
  base.OnEnable(self)
  self:UpdateData()
end

function UILWSeasonMakeFriendsSendInviteView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsSendInviteView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  self:AddUIListener(EventId.MFAllyRequestDetailUpdate, self.UpdateData)
end

function UILWSeasonMakeFriendsSendInviteView:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  self:RemoveUIListener(EventId.MFAllyRequestDetailUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonMakeFriendsSendInviteView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("s6_alliance_ally_btn07")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_send = self:AddComponent(UIButton, btn_send_path)
  self.tip_c_d = self:AddComponent(UITextMeshProUGUIEx, tip_c_d_path)
  self.condition1 = self:AddComponent(UIImage, condition1_path)
  self.tick1 = self:AddComponent(UIImage, tick1_path)
  self.title1 = self:AddComponent(UITextMeshProUGUIEx, title1_path)
  self.condition2 = self:AddComponent(UIImage, condition2_path)
  self.tick2 = self:AddComponent(UIImage, tick2_path)
  self.title2 = self:AddComponent(UITextMeshProUGUIEx, title2_path)
  self.condition3 = self:AddComponent(UIImage, condition3_path)
  self.tick3 = self:AddComponent(UIImage, tick3_path)
  self.title3 = self:AddComponent(UITextMeshProUGUIEx, title3_path)
  self.condition4 = self:AddComponent(UIImage, condition4_path)
  self.tick4 = self:AddComponent(UIButton, tick4_path)
  self.title4 = self:AddComponent(UITextMeshProUGUIEx, title4_path)
  self.tick4:SetOnClick(function()
    self:CheckCampScience()
  end)
  self.sub_title = self:AddComponent(UITextMeshProUGUIEx, sub_title_path)
  self.input_field = self:AddComponent(UIInput, input_field_path)
  self.input_field:SetOnValueChange(function(value)
    self:TextValueChange(value)
  end)
end

function UILWSeasonMakeFriendsSendInviteView:ComponentDestroy()
  self.btn_back = nil
  self.btn_send = nil
  self.condition1 = nil
  self.tick1 = nil
  self.title1 = nil
  self.condition2 = nil
  self.tick2 = nil
  self.title2 = nil
  self.condition3 = nil
  self.tick3 = nil
  self.title3 = nil
  self.condition4 = nil
  self.tick4 = nil
  self.title4 = nil
  self.sub_title = nil
  self.input_field = nil
  self.tip_c_d = nil
end

function UILWSeasonMakeFriendsSendInviteView:UpdateData()
  local allianceInfo = self.allianceInfo
  if allianceInfo == nil then
    allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceId)
    if allianceInfo == nil then
      return
    end
    self.allianceInfo = allianceInfo
  end
  local name = allianceInfo:GetAllianceServerName()
  self.sub_title:SetLocalText("s6_alliance_ally_desc23", name)
  local allConditionOK = true
  local status1, status2, status3, status4 = DataCenter.SeasonAllyFriendManager:CheckCondition(self.data)
  self.title1:SetLocalText("s6_alliance_ally_tips12")
  if status1 then
    self.title1:SetColorHex("#249BC5")
    self.tick1:SetColorHex("#87E1C8")
    self.tick1:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_biaoji_duigou.png")
  else
    allConditionOK = false
    self.title1:SetColorHex("#f53c3d")
    self.tick1:SetColorHex("#f0a0a0")
    self.tick1:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_biaoji_cha.png")
  end
  self.title2:SetLocalText("s6_alliance_ally_tips13")
  if status2 then
    self.title2:SetColorHex("#249BC5")
    self.tick2:SetColorHex("#87E1C8")
    self.tick2:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_biaoji_duigou.png")
  else
    allConditionOK = false
    self.title2:SetColorHex("#f53c3d")
    self.tick2:SetColorHex("#f0a0a0")
    self.tick2:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_biaoji_cha.png")
  end
  self.title3:SetLocalText("s6_alliance_ally_tips14")
  if status3 then
    self.title3:SetColorHex("#249BC5")
    self.tick3:SetColorHex("#87E1C8")
    self.tick3:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_biaoji_duigou.png")
  else
    allConditionOK = false
    self.title3:SetColorHex("#f53c3d")
    self.tick3:SetColorHex("#f0a0a0")
    self.tick3:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_biaoji_cha.png")
  end
  if DataCenter.CampScienceDataManager:IsOpenCampScience() and DataCenter.CampScienceDataManager:IsOpenMakeAllianceCampScience() then
    self.title4:SetColorHex("#249BC5")
    self.tick4:SetColorHex("#87E1C8")
    self.tick4:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_biaoji_duigou.png")
  else
    allConditionOK = false
    self.title4:SetColorHex("#f53c3d")
    self.tick4:SetColorHex("#f0a0a0")
    self.tick4:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_biaoji_cha.png")
  end
  CS.UIGray.SetGray(self.btn_send.transform, not allConditionOK, true)
end

function UILWSeasonMakeFriendsSendInviteView:TextValueChange(value)
  self.theContent = value or ""
end

function UILWSeasonMakeFriendsSendInviteView:CheckCampScience()
  if not DataCenter.CampScienceDataManager:IsOpenMakeAllianceCampScience() then
    local msg = Localization:GetString("season_camp_science_tips_24")
    if DataCenter.CampScienceDataManager:IsOpenCampScience() then
      UIUtil.ShowMessage(msg, 2, "110088", GameDialogDefine.CANCEL, function()
        GoToUtil.GoToCampScience()
      end, function()
      end)
    else
      UIUtil.ShowTipsId("season_camp_science_tips_24")
    end
    return true
  end
  return false
end

function UILWSeasonMakeFriendsSendInviteView:OnSendBtnClick()
  local officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
  if not DataCenter.AllianceBaseDataManager:IsR5() and officialPos ~= LWAlMemberOffcialType.Al_Goddess then
    UIUtil.ShowTipsId("s6_alliance_ally_tips15")
    return
  end
  if self:CheckCampScience() then
    return
  end
  local status1, status2, status3, status4 = DataCenter.SeasonAllyFriendManager:CheckCondition(self.data)
  if not status2 or not status3 then
    UIUtil.ShowTipsId("season_s6_s_ally_02")
    return
  end
  local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceId)
  if allianceInfo == nil then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data == nil or data.abbr == nil then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  local theAllianceId = self.allianceId
  local theContent = self.theContent
  if theContent ~= nil and theContent ~= "" and string.len(theContent) > 4096 then
    UIUtil.ShowTipsId("120193")
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local name1 = UIUtil.FormatServerAllianceName(mySourceServerId, data.abbr, nil)
  local name2 = UIUtil.FormatServerAllianceName(allianceInfo.createServer or allianceInfo.ownerServerId, allianceInfo.abbr, nil)
  local param = {}
  param.tipText = Localization:GetString("s6_alliance_ally_desc27", name1, name2)
  param.btnNum = 2
  param.showToggle = false
  param.delayConfirm = {delayTime = 10}
  
  function param.sureAction()
    local _officialPos = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(LuaEntry.Player.uid)
    if DataCenter.AllianceBaseDataManager:IsR5() or _officialPos == LWAlMemberOffcialType.Al_Goddess then
      SFSNetwork.SendMessage(MsgDefines.SendAllianceAllyApply, theAllianceId, theContent)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsSendInvite)
    else
      UIUtil.ShowTipsId("s6_alliance_ally_tips15")
    end
  end
  
  UIUtil.ShowSecondMessageByParam(param)
end

return UILWSeasonMakeFriendsSendInviteView
