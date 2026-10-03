local p_text_act_title_path = "root/top/p_text_act_title"
local content_time_path = "root/top/content_time"
local p_text_act_time_path = "root/top/content_time/p_text_act_time"
local p_btn_info_path = "root/top/p_btn_info"
local p_img_info_icon_path = "root/top/p_btn_info/p_img_info_icon"
local p_content_no_time_path = "root/mid/p_content_no_time"
local p_text_green_time_path = "root/mid/p_content_no_time/go_green/tips/content_time/img_bg_green_time/p_text_green_time"
local p_text_green_desc_path = "root/mid/p_content_no_time/go_green/tips/p_text_green_desc"
local p_text_red_time_path = "root/mid/p_content_no_time/go_red/tips/content_time/img_bg_red_time/p_text_red_time"
local p_text_red_desc_path = "root/mid/p_content_no_time/go_red/tips/p_text_red_desc"
local p_content_has_time_path = "root/mid/p_content_has_time"
local p_comp_state_path = "root/mid/p_content_has_time/img_bg_has_time/p_comp_state"
local p_text_has_time_desc_path = "root/mid/p_content_has_time/p_text_has_time_desc"
local p_btn_set_path = "root/bottom/p_btn_set"
local p_text_btn_set_path = "root/bottom/p_btn_set/LW_Btn_Common_New_Base/p_text_btn_set"
local p_btn_time_1_path = "root/mid/p_content_no_time/img_circle/p_img_btn_select1/p_img_btn_icon/p_btn_time_1"
local p_btn_time_2_path = "root/mid/p_content_no_time/img_circle/p_img_btn_select2/p_img_btn_icon/p_btn_time_2"
local p_btn_time_3_path = "root/mid/p_content_no_time/img_circle/p_img_btn_select3/p_img_btn_icon/p_btn_time_3"
local p_btn_help_path = "root/top/p_btn_help"
local p_text_btn_help_path = "root/top/p_btn_help/p_text_btn_help"
local state_time_comp_script = require("UI.LWSeason5.UILWSeasonAllianceWarTime.Common.UILWSeasonAllianceWarTimeStateComp")
local base = UIBaseContainer
local UILWSeasonAllianceWarTimeMain = BaseClass("UILWSeasonAllianceWarTimeMain", UIBaseContainer)

function UILWSeasonAllianceWarTimeMain:ComponentDefine()
  self.img_bg = self:AddComponent(UIRawImage, "img_bg")
  self.p_text_act_title = self:AddComponent(UITextMeshProUGUIEx, p_text_act_title_path)
  self.content_time = self:AddComponent(UIBaseContainer, content_time_path)
  self.p_text_act_time = self:AddComponent(UITextMeshProUGUIEx, p_text_act_time_path)
  self.p_btn_info = self:AddComponent(UIButton, p_btn_info_path)
  self.p_img_info_icon = self:AddComponent(UIImage, p_img_info_icon_path)
  self.p_btn_info:SetOnClick(BindCallback(self, self.OnInfoClicked))
  self.p_content_no_time = self:AddComponent(UIBaseContainer, p_content_no_time_path)
  self.p_text_green_time = self:AddComponent(UITextMeshProUGUIEx, p_text_green_time_path)
  self.p_text_green_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_green_desc_path)
  self.p_text_red_time = self:AddComponent(UITextMeshProUGUIEx, p_text_red_time_path)
  self.p_text_red_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_red_desc_path)
  self.p_content_has_time = self:AddComponent(UIBaseContainer, p_content_has_time_path)
  self.p_comp_state = self:AddComponent(state_time_comp_script, p_comp_state_path)
  self.p_text_has_time_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_has_time_desc_path)
  self.p_btn_set = self:AddComponent(UIButton, p_btn_set_path)
  self.p_btn_set:SetOnClick(BindCallback(self, self.OnBtnSetClicked))
  self.p_text_btn_set = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_set_path)
  self.p_btn_time_1 = self:AddComponent(UIButton, p_btn_time_1_path)
  self.p_btn_time_1:SetOnClick(function()
    self:OnTimeClicked(self.p_btn_time_1, "s5_alliance_battle_time_ui101")
  end)
  self.p_btn_time_2 = self:AddComponent(UIButton, p_btn_time_2_path)
  self.p_btn_time_2:SetOnClick(function()
    self:OnTimeClicked(self.p_btn_time_2, "s5_alliance_battle_time_ui111")
  end)
  self.p_btn_time_3 = self:AddComponent(UIButton, p_btn_time_3_path)
  self.p_btn_time_3:SetOnClick(function()
    self:OnTimeClicked(self.p_btn_time_3, "s5_alliance_battle_time_ui121")
  end)
  self.p_btn_help = self:AddComponent(UIButton, p_btn_help_path)
  self.p_btn_help:SetOnClick(BindCallback(self, self.OnHelpClicked))
  self.p_text_btn_help = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_help_path)
end

function UILWSeasonAllianceWarTimeMain:ComponentDestroy()
  self.img_bg = nil
  self.p_text_act_title = nil
  self.content_time = nil
  self.p_text_act_time = nil
  self.p_btn_info = nil
  self.p_img_info_icon = nil
  self.p_content_no_time = nil
  self.p_text_green_time = nil
  self.p_text_green_desc = nil
  self.p_text_red_time = nil
  self.p_text_red_desc = nil
  self.p_content_has_time = nil
  self.p_comp_state = nil
  self.p_text_has_time_desc = nil
  self.p_btn_set = nil
  self.p_text_btn_set = nil
  self.p_btn_time_1 = nil
  self.p_btn_time_2 = nil
  self.p_btn_time_3 = nil
end

function UILWSeasonAllianceWarTimeMain:DataDefine()
  self.ImgInfoRed = "Assets/Main/Sprites/UI/UISeason/Sprites/CityPopup/Mjc_saijijianzhu_tanhao_03.png"
  self.ImgInfoGreen = "Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/Mjc_saijijianzhu_tanhao_04.png"
end

function UILWSeasonAllianceWarTimeMain:DataDestroy()
  self.ActData = nil
  DataCenter.UILWSeasonAllianceWarTimeManager:ClearWaitingGetInfo()
end

function UILWSeasonAllianceWarTimeMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWSeasonAllianceWarTimeMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonAllianceWarTimeMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonAllianceWarTimeGetInfoUpdate, self.OnGetInfoUpdate)
  self:AddUIListener(EventId.SeasonAllianceWarTimePush, self.OnSetTimeUpdate)
end

function UILWSeasonAllianceWarTimeMain:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonAllianceWarTimeGetInfoUpdate, self.OnGetInfoUpdate)
  self:RemoveUIListener(EventId.SeasonAllianceWarTimePush, self.OnSetTimeUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonAllianceWarTimeMain:SetData(actId, actData)
  self.ActData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  self.content_time:SetActive(true)
  self.EndTime = self.ActData ~= nil and checknumber(self.ActData:GetShowEndTime()) or 0
  self:Update1000MS()
end

function UILWSeasonAllianceWarTimeMain:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if LuaEntry.Player:IsInAlliance() then
      if self:UpdateData() then
        self:UpdateUi()
      else
        DataCenter.UILWSeasonAllianceWarTimeManager:SendGetInfo()
      end
    else
      self.p_btn_info:SetActive(true)
      self:ShowNoTime()
    end
  end
end

function UILWSeasonAllianceWarTimeMain:InitData(data)
  DataCenter.UILWSeasonAllianceWarTimeManager:ClearMyAllianceWarTimeData()
  return true
end

function UILWSeasonAllianceWarTimeMain:InitUi()
  self.p_btn_info:SetActive(false)
  self.p_text_btn_set:SetLocalText("activity_desc_1200054_btn1")
  self.p_text_act_title:SetLocalText("s5_alliance_battle_time_ui01")
  self.p_text_btn_help:SetLocalText("zone_selection_location_UI_2")
  self:LoadImgBg()
  self:ShowNo()
end

function UILWSeasonAllianceWarTimeMain:LoadImgBg()
  local defaultImg = "Assets/Main/SeasonRes/S5/Textures/AllianceWarTime/mjc_S5_MZ_zhuye_banner.png"
  local actData = DataCenter.UILWSeasonAllianceWarTimeManager:GetActData()
  if actData ~= nil and not string.IsNullOrEmpty(actData.activity_pic_full) then
    defaultImg = actData.activity_pic_full
  end
  self.img_bg:LoadSpriteAsync(defaultImg)
end

function UILWSeasonAllianceWarTimeMain:ShowNo()
  self.p_content_no_time:SetActive(false)
  self.p_content_has_time:SetActive(false)
end

function UILWSeasonAllianceWarTimeMain:ShowNoTime()
  self.p_content_no_time:SetActive(true)
  self.p_content_has_time:SetActive(false)
  self.p_img_info_icon:LoadSpriteAsync(self.ImgInfoRed)
  self.p_text_green_desc:SetLocalText("s5_alliance_battle_time_ui41")
  local warTimeConfigData2 = DataCenter.UILWSeasonAllianceWarTimeManager:GetWarTimeConfigData(2)
  if warTimeConfigData2 ~= nil then
    self.p_text_green_time:SetLocalText("s5_alliance_battle_time_ui39", warTimeConfigData2:GetServerTimeRangeStr())
  end
  self.p_text_red_desc:SetLocalText("s5_alliance_battle_time_ui42")
  local warTimeConfigData1 = DataCenter.UILWSeasonAllianceWarTimeManager:GetWarTimeConfigData(1)
  if warTimeConfigData1 ~= nil then
    self.p_text_red_time:SetLocalText("s5_alliance_battle_time_ui38", warTimeConfigData1:GetServerTimeRangeStr())
  end
end

function UILWSeasonAllianceWarTimeMain:ShowHasTime()
  self.p_content_no_time:SetActive(false)
  self.p_content_has_time:SetActive(true)
  self.p_img_info_icon:LoadSpriteAsync(self.ImgInfoGreen)
  local timeIndex = checknumber(self.MyAllianceWarTimeData.TimeIndex)
  local realIndex = DataCenter.UILWSeasonAllianceWarTimeManager:GetRealTimeIndex(timeIndex, self.MyAllianceWarTimeData.SetTime)
  local data = {}
  data.TimeIndex = realIndex
  data.SetTime = checknumber(self.MyAllianceWarTimeData.SetTime)
  self.p_comp_state:ReInit(data)
  self.p_text_has_time_desc:SetLocalText("s5_alliance_battle_time_ui18")
end

function UILWSeasonAllianceWarTimeMain:UpdateData()
  self.MyAllianceWarTimeData = DataCenter.UILWSeasonAllianceWarTimeManager:GetMyAllianceWarTimeData()
  return self.MyAllianceWarTimeData ~= nil
end

function UILWSeasonAllianceWarTimeMain:HasSetTime()
  if self.MyAllianceWarTimeData ~= nil then
    local realIndex = DataCenter.UILWSeasonAllianceWarTimeManager:GetRealTimeIndex(self.MyAllianceWarTimeData.TimeIndex, self.MyAllianceWarTimeData.SetTime)
    return 0 <= realIndex and realIndex <= 2
  end
  return false
end

function UILWSeasonAllianceWarTimeMain:UpdateUi()
  self.p_btn_info:SetActive(true)
  if self:HasSetTime() then
    self:ShowHasTime()
  else
    self:ShowNoTime()
  end
end

function UILWSeasonAllianceWarTimeMain:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  local leftTime = math.max(0, self.EndTime - now)
  if 0 < leftTime then
    self.p_text_act_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  else
    self.content_time:SetActive(false)
  end
end

function UILWSeasonAllianceWarTimeMain:OnBtnSetClicked()
  if not LuaEntry.Player:IsInAlliance() then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonAllianceWarTimeSetView)
  end
end

function UILWSeasonAllianceWarTimeMain:OnGetInfoUpdate(evtData)
  if evtData == nil then
    return
  end
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function UILWSeasonAllianceWarTimeMain:OnSetTimeUpdate(evtData)
  if evtData == nil then
    return
  end
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function UILWSeasonAllianceWarTimeMain:OnInfoClicked()
  local msg = CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui40")
  if self:HasSetTime() then
    msg = CS.GameEntry.Localization:GetString("activity_desc_1200054_tips1")
  end
  UIUtil.ShowBubbleTips(msg, self.p_btn_info.transform.position, 0, -30, 0)
end

function UILWSeasonAllianceWarTimeMain:OnTimeClicked(target, text)
  local msg = CS.GameEntry.Localization:GetString(text)
  UIUtil.ShowBubbleTips(msg, target.transform.position, 0, -30, 0)
end

function UILWSeasonAllianceWarTimeMain:OnHelpClicked()
  if self.ActData == nil then
    return
  end
  local param = {}
  param.howToPlayList = self.ActData.howtoplay
  param.story = self.ActData.story
  param.defaultTitle = self.ActData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

return UILWSeasonAllianceWarTimeMain
