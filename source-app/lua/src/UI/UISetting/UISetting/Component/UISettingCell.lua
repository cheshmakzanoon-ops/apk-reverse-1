local UISettingCell = BaseClass("UISettingCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local SDKManager = CS.SDKManager
local Param = DataClass("Param", ParamData)
local ParamData = {
  settingType
}
local btn_path = ""
local icon_path = "icon"
local btn_name_path = "BtnName"
local red_dot_path = "RedDot"
local foreIcon_path = "foreicon"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn_name = self:AddComponent(UIText, btn_name_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetSafeClickMode(true)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.red_dot = self:AddComponent(UIBaseComponent, red_dot_path)
  self.red_dot:SetActive(false)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.foreIconN = self:AddComponent(UIImage, foreIcon_path)
end

local function ComponentDestroy(self)
  self.btn_name = nil
  self.btn = nil
  self.icon = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self:RefreshView()
end

function UISettingCell:RefreshView()
  self:SetIcon()
  self:SetName()
end

local function OnBtnClick(self)
  if self.param.settingType == SettingType.Notice then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingNotice, {anim = true, hideTop = true})
  elseif self.param.settingType == SettingType.Setting then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingSet, {anim = true, hideTop = true})
  elseif self.param.settingType == SettingType.Account then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingAccount, {anim = true, hideTop = true})
  elseif self.param.settingType == SettingType.Description then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISetting)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerDetail)
    if CS.SceneManager:IsInCity() then
    end
  elseif self.param.settingType == SettingType.Language then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingLanguage, {anim = true, hideTop = true})
  elseif self.param.settingType == SettingType.Voice then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingLanguage, {anim = true, hideTop = true}, SettingType.Voice)
  elseif self.param.settingType == SettingType.RedemptionCode then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingRedemptionCode, {anim = true, hideTop = true})
  elseif self.param.settingType == SettingType.Ban then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingBlock)
  elseif self.param.settingType == SettingType.Flag then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingFlag, {anim = true})
  elseif self.param.settingType == SettingType.GM then
  elseif self.param.settingType == SettingType.Service then
    CS.UnityGameFramework.SDK.HelpManager.Instance:showFAQ("45238")
  elseif self.param.settingType == SettingType.NewGame then
    DataCenter.AccountManager:OnHandleNewGame()
  elseif self.param.settingType == SettingType.ChangeId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingChangeUid, {anim = true, hideTop = true})
  elseif self.param.settingType == SettingType.PVEFreeCamera then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISetting)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerDetail)
    DataCenter.BattleLevel:ToggleCameraFree()
  elseif self.param.settingType == SettingType.PlayerNation then
    local tempNation = LuaEntry.Player.countryFlag
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISetPlayerNation, {anim = true}, {
      nation = tempNation,
      callback = function(tempSelected)
        SFSNetwork.SendMessage(MsgDefines.SetCountryFlag, tempSelected)
        ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.GetUserInfoMulti, {
          LuaEntry.Player.uid
        })
      end
    })
  elseif self.param.settingType == SettingType.AllowTracking then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGotoAllowTracking)
  elseif self.param.settingType == SettingType.ChangeScene then
    self:ChangeScene()
  elseif self.param.settingType == SettingType.GameNotice then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMainNotice, {anim = true})
  elseif self.param.settingType == SettingType.CustomDecoration then
    EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewOpen)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true})
  elseif self.param.settingType == SettingType.DeleteAccount then
    UIUtil.DeleteAccountBtnClick()
  elseif self.param.settingType == SettingType.PrivacyAgreement then
    local urlStr = ""
    local lang = CS.GameEntry.Localization:GetLanguage()
    local cfg = LocalController:instance():tryGetLine(TableName.Lw_DmaLink, tostring(lang))
    if cfg == nil then
      cfg = LocalController:instance():getLine(TableName.Lw_DmaLink, "0")
    end
    if cfg then
      if Config.IsPC() then
        urlStr = cfg.pp_link_pc
      else
        urlStr = cfg.pp_link
      end
    end
    if not string.IsNullOrEmpty(urlStr) then
      CS.SDKManager.OpenURL(urlStr)
    end
  elseif self.param.settingType == SettingType.UserAgreement then
    local urlStr = ""
    local lang = CS.GameEntry.Localization:GetLanguage()
    local cfg = LocalController:instance():tryGetLine(TableName.Lw_DmaLink, tostring(lang))
    if cfg == nil then
      cfg = LocalController:instance():getLine(TableName.Lw_DmaLink, "0")
    end
    if cfg then
      if Config.IsPC() then
        urlStr = cfg.term_link_pc
      else
        urlStr = cfg.term_link
      end
    end
    if not string.IsNullOrEmpty(urlStr) then
      CS.SDKManager.OpenURL(urlStr)
    end
  elseif self.param.settingType == SettingType.AIHelp then
    local vip = DataCenter.VIPManager.vipinfo
    local id = "E006"
    if vip and vip.level then
      if vip.level <= 7 then
        id = "E006"
      elseif vip.level <= 12 then
        id = "E007"
      else
        id = "E008"
      end
    end
    CS.AIHelp.AIHelpProxy.Show(id, Localization:GetString("2700006"))
    DataCenter.LWCustomerServiceManager:CloseCustomerServiceRedPointData()
  elseif self.param.settingType == SettingType.AutoMarch then
    if LuaEntry.Player:GetUserSetting(UserSettingKey.AutoMarch) == "1" then
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.AutoMarch, "0")
    else
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.AutoMarch, "1")
    end
  elseif self.param.settingType == SettingType.push then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPushSettings, {anim = true, hideTop = true})
  elseif self.param.settingType == SettingType.CopyAccount then
    CommonUtil.CopyTextToClipboard(LuaEntry.Player.uid)
    UIUtil.ShowTipsId(128031)
  elseif self.param.settingType == SettingType.DebugChooseURL then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingChooseURL, {anim = true, hideTop = true})
  elseif self.param.settingType == SettingType.RemarkNameList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWRemarkNameList, {anim = true})
  elseif self.param.settingType == SettingType.GMPanel then
    GMUtils.Open()
  elseif self.param.settingType == SettingType.Attention then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWFriendsCircleFollowee, {anim = true})
  elseif self.param.settingType == SettingType.ItemRevert then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemRevert, {anim = true, hideTop = true})
  elseif self.param.settingType == SettingType.DownloadCenter then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerDownloadCenterMain, {anim = true, hideTop = true})
  end
end

local function SetIcon(self)
  self.foreIconN:SetActive(false)
  if self.param.settingType == SettingType.Notice then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_alliow.png")
  elseif self.param.settingType == SettingType.Setting then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/settting_icon_gearwheels@2x.png")
  elseif self.param.settingType == SettingType.Account then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/img_iconSettingFunction_Account.png")
  elseif self.param.settingType == SettingType.Description then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/img_iconSettingFunction_Q&A.png")
  elseif self.param.settingType == SettingType.Language then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/settting_icon_language.png")
  elseif self.param.settingType == SettingType.Voice then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/settting_icon_voice.png")
  elseif self.param.settingType == SettingType.RedemptionCode then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/img_iconSettingFunction_GiftExchange.png")
  elseif self.param.settingType == SettingType.Ban then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/zyf_shezhi_pingbi_icon.png")
  elseif self.param.settingType == SettingType.Flag then
    local template = DataCenter.NationTemplateManager:GetNationTemplate(LuaEntry.Player.countryFlag)
    self.icon:LoadSprite(template:GetNationFlagPath())
  elseif self.param.settingType == SettingType.GM then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/img_iconSettingFunction_Lilith.png")
  elseif self.param.settingType == SettingType.Service then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/img_iconSettingFunction_Discord.png")
  elseif self.param.settingType == SettingType.NewGame then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/settting_icon_reload.png")
  elseif self.param.settingType == SettingType.ChangeId then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_newgame.png")
  elseif self.param.settingType == SettingType.PVE then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_newgame.png")
  elseif self.param.settingType == SettingType.PVEFreeCamera then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_newgame.png")
  elseif self.param.settingType == SettingType.AllowTracking then
    if CS.SDKManager.IS_IPhonePlayer() and not CS.GameEntry.Setting:GetBool(SettingKeys.ALLOW_TRACKING_CLICK, false) then
      self.red_dot:SetActive(true)
    end
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_IDFA.png")
  elseif self.param.settingType == SettingType.PlayerNation then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/settting_icon_country.png")
  elseif self.param.settingType == SettingType.ChangeScene then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_newgame.png")
  elseif self.param.settingType == SettingType.GameNotice then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_gonggao.png")
  elseif self.param.settingType == SettingType.CustomDecoration then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/sj_shezhi_zhuangban.png")
  elseif self.param.settingType == SettingType.DeleteAccount then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/zyf_zhanghaoshanchu_icon1.png")
  elseif self.param.settingType == SettingType.PrivacyAgreement then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/zyf_yinsixieyi_icon.png")
  elseif self.param.settingType == SettingType.UserAgreement then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/zyf_yonghuxieyi_icon.png")
  elseif self.param.settingType == SettingType.AIHelp then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/zyf_kefuxiezhu_icon_110x110.png")
    local show = DataCenter.LWCustomerServiceManager:GetCustomerServiceRedPointData()
    self.red_dot:SetActive(show)
  elseif self.param.settingType == SettingType.AutoMarch then
    if LuaEntry.Player:GetUserSetting(UserSettingKey.AutoMarch) == "1" then
      self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/icon_gongjizengyi.png")
    else
      self.icon:LoadSprite("Assets/Main/Sprites/ItemIcons/icon_gongjizengyi.png")
    end
  elseif self.param.settingType == SettingType.push then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/zyf_shezhi_tixing.png")
  elseif self.param.settingType == SettingType.CopyAccount then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/zyf_shezhi_fuzhiid_icon.png")
  elseif self.param.settingType == SettingType.DebugChooseURL then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/settting_icon_reload.png")
  elseif self.param.settingType == SettingType.RemarkNameList then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/zyf_beizhugongneng_rukou_icon.png")
  elseif self.param.settingType == SettingType.GMPanel then
    self.icon:LoadSprite(GMUtils.GetSkinPath().icon)
  elseif self.param.settingType == SettingType.Attention then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/zyf_gerenshezhi_guanzhu_icon.png")
  elseif self.param.settingType == SettingType.ItemRevert then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/mjc_shezhi_daojutuihui.png")
  elseif self.param.settingType == SettingType.DownloadCenter then
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UILWPlayerInfo/FX_xiazaizhongxing_xiazai_icon.png")
  end
  self.icon:SetNativeSize()
end

local function SetName(self)
  if self.param.settingType == SettingType.Notice then
    self.btn_name:SetLocalText(100646)
  elseif self.param.settingType == SettingType.Setting then
    self.btn_name:SetLocalText(280170)
  elseif self.param.settingType == SettingType.Account then
    self.btn_name:SetLocalText(280039)
  elseif self.param.settingType == SettingType.Description then
    self.btn_name:SetLocalText(100171)
  elseif self.param.settingType == SettingType.Language then
    self.btn_name:SetLocalText(100101)
  elseif self.param.settingType == SettingType.Voice then
    self.btn_name:SetLocalText("voice_selection_title")
  elseif self.param.settingType == SettingType.RedemptionCode then
    self.btn_name:SetLocalText(110004)
  elseif self.param.settingType == SettingType.Ban then
    self.btn_name:SetLocalText(280013)
  elseif self.param.settingType == SettingType.Flag then
    self.btn_name:SetLocalText(390065)
  elseif self.param.settingType == SettingType.GM then
    self.btn_name:SetText("GM")
  elseif self.param.settingType == SettingType.Service then
    self.btn_name:SetLocalText(100331)
  elseif self.param.settingType == SettingType.NewGame then
    self.btn_name:SetLocalText(280045)
  elseif self.param.settingType == SettingType.ChangeId then
    self.btn_name:SetLocalText("\229\136\135\229\143\183")
  elseif self.param.settingType == SettingType.PVE then
    self.btn_name:SetText("PVE")
  elseif self.param.settingType == SettingType.PVEFreeCamera then
    self.btn_name:SetText("PVE FreeCamera")
  elseif self.param.settingType == SettingType.AllowTracking then
    self.btn_name:SetLocalText(208222)
  elseif self.param.settingType == SettingType.PlayerNation then
    self.btn_name:SetLocalText("143589")
  elseif self.param.settingType == SettingType.ChangeScene then
    self.btn_name:SetText("ChangeScene")
  elseif self.param.settingType == SettingType.GameNotice then
    self.btn_name:SetLocalText(312082)
  elseif self.param.settingType == SettingType.CustomDecoration then
    self.btn_name:SetLocalText(2900047)
  elseif self.param.settingType == SettingType.DeleteAccount then
    self.btn_name:SetLocalText(121074)
  elseif self.param.settingType == SettingType.PrivacyAgreement then
    self.btn_name:SetLocalText("contract_2")
  elseif self.param.settingType == SettingType.UserAgreement then
    self.btn_name:SetLocalText("contract_1")
  elseif self.param.settingType == SettingType.AIHelp then
    self.btn_name:SetLocalText(2010122)
  elseif self.param.settingType == SettingType.AutoMarch then
    if LuaEntry.Player:GetUserSetting(UserSettingKey.AutoMarch) == "1" then
      self.btn_name:SetLocalText("new_city_activity_battle_tips1043")
    else
      self.btn_name:SetLocalText("new_city_activity_battle_tips1044")
    end
  elseif self.param.settingType == SettingType.push then
    self.btn_name:SetLocalText("100646")
  elseif self.param.settingType == SettingType.CopyAccount then
    self.btn_name:SetLocalText("head_copy_id")
  elseif self.param.settingType == SettingType.DebugChooseURL then
    self.btn_name:SetText("\233\128\137\230\139\169\231\186\191\232\183\175")
  elseif self.param.settingType == SettingType.RemarkNameList then
    self.btn_name:SetLocalText("remake_list_title")
  elseif self.param.settingType == SettingType.GMPanel then
    self.btn_name:SetText("GM")
  elseif self.param.settingType == SettingType.Attention then
    self.btn_name:SetLocalText("chat_subtab_follow")
  elseif self.param.settingType == SettingType.ItemRevert then
    self.btn_name:SetLocalText("undo_system_setting_name")
  elseif self.param.settingType == SettingType.DownloadCenter then
    self.btn_name:SetLocalText("download_center_btn")
  end
end

local function ChangeScene(self)
end

function UISettingCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UserSettingChanged, self.OnUserSettingChanged)
end

function UISettingCell:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UserSettingChanged, self.OnUserSettingChanged)
end

function UISettingCell:OnUserSettingChanged(userSettingKey)
  if self.param.settingType == SettingType.AutoMarch and userSettingKey == UserSettingKey.AutoMarch then
    self:RefreshView()
    if LuaEntry.Player:GetUserSetting(UserSettingKey.AutoMarch) == "1" then
      UIUtil.ShowTipsId("new_city_activity_battle_tips1045")
    else
      UIUtil.ShowTipsId("new_city_activity_battle_tips1046")
    end
  end
end

UISettingCell.OnCreate = OnCreate
UISettingCell.OnDestroy = OnDestroy
UISettingCell.Param = Param
UISettingCell.OnEnable = OnEnable
UISettingCell.OnDisable = OnDisable
UISettingCell.ComponentDefine = ComponentDefine
UISettingCell.ComponentDestroy = ComponentDestroy
UISettingCell.DataDefine = DataDefine
UISettingCell.DataDestroy = DataDestroy
UISettingCell.ReInit = ReInit
UISettingCell.OnBtnClick = OnBtnClick
UISettingCell.SetIcon = SetIcon
UISettingCell.SetName = SetName
UISettingCell.ChangeScene = ChangeScene
return UISettingCell
