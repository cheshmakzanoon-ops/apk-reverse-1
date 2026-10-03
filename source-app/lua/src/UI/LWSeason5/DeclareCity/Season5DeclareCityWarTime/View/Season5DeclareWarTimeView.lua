local p_btn_blur_path = "p_btn_blur"
local p_text_title_path = "Root/bg/title/Common_img_title/p_text_title"
local p_btn_close_path = "Root/bg/title/p_btn_close"
local p_img_my_alliance_flag_path = "Root/bg/content/top/p_img_my_alliance_flag"
local p_text_my_alliance_abbr_path = "Root/bg/content/top/p_img_my_alliance_flag/p_text_my_alliance_abbr"
local p_text_my_alliance_name_path = "Root/bg/content/top/p_img_my_alliance_flag/p_text_my_alliance_name"
local p_comp_state_path = "Root/bg/content/top/p_comp_state"
local p_text_rule_desc_path = "Root/bg/content/top/content_text/p_text_rule_desc"
local p_comp_my_alliance_war_time_path = "Root/bg/content/top/p_comp_my_alliance_war_time"
local p_text_list_title_path = "Root/bg/content/bottom/img_bg_title/p_text_list_title"
local p_list_city_info_path = "Root/bg/content/bottom/p_list_city_info"
local content_path = "Root/bg/content/bottom/p_list_city_info/Viewport/Content"
local UILWSeasonAllianceWarTimeStateComp = require("UI/LWSeason5/UILWSeasonAllianceWarTime/Common/UILWSeasonAllianceWarTimeStateComp")
local SeasonAllianceWarTimeStateIconComp = require("UI/LWSeason5/UILWSeasonAllianceWarTime/Common/SeasonAllianceWarTimeStateIconComp")
local Season5DeclareWarTimeCityInfoCell = require("UI/LWSeason5/DeclareCity/Season5DeclareCityWarTime/Comp/Season5DeclareWarTimeCityInfoCell")
local base = UIBaseView
local Season5DeclareWarTimeView = BaseClass("Season5DeclareWarTimeView", UIBaseView)

function Season5DeclareWarTimeView:ComponentDefine()
  self.p_btn_blur = self:AddComponent(UIButton, p_btn_blur_path)
  self.p_btn_blur:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_btn_close:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_img_my_alliance_flag = self:AddComponent(UIImage, p_img_my_alliance_flag_path)
  self.p_text_my_alliance_abbr = self:AddComponent(UITextMeshProUGUIEx, p_text_my_alliance_abbr_path)
  self.p_text_my_alliance_name = self:AddComponent(UITextMeshProUGUIEx, p_text_my_alliance_name_path)
  self.p_comp_state = self:AddComponent(UILWSeasonAllianceWarTimeStateComp, p_comp_state_path)
  self.p_text_rule_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_rule_desc_path)
  self.p_comp_my_alliance_war_time = self:AddComponent(SeasonAllianceWarTimeStateIconComp, p_comp_my_alliance_war_time_path)
  self.p_text_list_title = self:AddComponent(UITextMeshProUGUIEx, p_text_list_title_path)
  self.p_list_city_info = self:AddComponent(UILoopListView2, p_list_city_info_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.items = {}
end

function Season5DeclareWarTimeView:ComponentDestroy()
  self.items = {}
  self.content:RemoveComponents(Season5DeclareWarTimeCityInfoCell)
  self.p_list_city_info:ClearAllItems()
  self.p_btn_blur = nil
  self.p_text_title = nil
  self.p_btn_close = nil
  self.p_img_my_alliance_flag = nil
  self.p_text_my_alliance_abbr = nil
  self.p_text_my_alliance_name = nil
  self.p_comp_state = nil
  self.p_text_rule_desc = nil
  self.p_comp_my_alliance_war_time = nil
  self.p_text_list_title = nil
  self.p_list_city_info = nil
  self.content = nil
end

function Season5DeclareWarTimeView:DataDefine()
end

function Season5DeclareWarTimeView:DataDestroy()
end

function Season5DeclareWarTimeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function Season5DeclareWarTimeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareWarTimeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.Season5DeclareCityWarTimeUpdate, self.OnWarTimeUpdate)
  self:AddUIListener(EventId.SeasonAllianceWarTimeGetInfoUpdate, self.OnGetInfoUpdate)
end

function Season5DeclareWarTimeView:OnRemoveListener()
  self:RemoveUIListener(EventId.Season5DeclareCityWarTimeUpdate, self.OnWarTimeUpdate)
  self:RemoveUIListener(EventId.SeasonAllianceWarTimeGetInfoUpdate, self.OnGetInfoUpdate)
  base.OnRemoveListener(self)
end

function Season5DeclareWarTimeView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    if self:UpdateWarTimeData() then
      self:UpdateWarTimeUi()
    else
      DataCenter.UILWSeasonAllianceWarTimeManager:SendGetInfo()
    end
  end
end

function Season5DeclareWarTimeView:InitData(data)
  self.IsWarTimeFuncOpen = DataCenter.UILWSeasonAllianceWarTimeManager:IsFuncOpen(true)
  return true
end

function Season5DeclareWarTimeView:InitUi()
  self.p_text_title:SetLocalText("season_s5_activity_1200059_desc24")
  self.p_text_rule_desc:SetLocalText("season_s5_activity_1200059_desc12")
  self.p_text_list_title:SetLocalText("season_s5_activity_1200059_desc13")
  self.p_comp_state:SetActive(false)
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData ~= nil then
    self.p_img_my_alliance_flag:LoadSpriteAsync(string.format(AL_FLAG_SPRITE_PATH, allianceData.icon))
    self.p_text_my_alliance_abbr:SetTextFormat("[%s]", allianceData.abbr)
    self.p_text_my_alliance_name:SetText(allianceData.allianceName)
  end
  local warTimeIconData = {}
  warTimeIconData.AllianceId = LuaEntry.Player.allianceId
  self.p_comp_my_alliance_war_time:ReInit(warTimeIconData)
  self:InitListView()
  DataCenter.SeasonDataManager:SendGetNearAllianceWarTime()
end

function Season5DeclareWarTimeView:UpdateData()
  return true
end

function Season5DeclareWarTimeView:UpdateUi()
end

function Season5DeclareWarTimeView:UpdateWarTimeData()
  self.MyWarTimeData = DataCenter.UILWSeasonAllianceWarTimeManager:GetMyAllianceWarTimeData()
  if self.MyWarTimeData ~= nil then
    return true
  end
  return false
end

function Season5DeclareWarTimeView:UpdateWarTimeUi()
  self.p_comp_state:SetActive(true)
  local data = {}
  data.TimeIndex = self.MyWarTimeData.TimeIndex
  data.SetTime = self.MyWarTimeData.SetTime
  self.p_comp_state:ReInit(data)
end

function Season5DeclareWarTimeView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

function Season5DeclareWarTimeView:OnWarTimeUpdate(payload)
  if payload ~= nil then
    self.CityList = payload.cities
    self.p_list_city_info:SetListItemCount(#self.CityList, false, false)
    self.p_list_city_info:RefreshAllShownItem()
  end
end

function Season5DeclareWarTimeView:OnGetInfoUpdate(evtData)
  if evtData ~= nil and evtData.AllianceId == LuaEntry.Player.allianceId and self:UpdateWarTimeData() then
    self:UpdateWarTimeUi()
  end
end

function Season5DeclareWarTimeView:InitListView()
  self.p_list_city_info:InitListView(0, function(list, index)
    return self:GetListViewItem(list, index)
  end)
end

function Season5DeclareWarTimeView:GetListViewItem(list, index)
  local dataList = self.CityList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem
  local data = dataList[index]
  local allianceCount = table.count(data.nearbyAlliances)
  local theScript
  if allianceCount <= 3 then
    csItem = list:NewListViewItem("p_city_list_template_1")
    theScript = Season5DeclareWarTimeCityInfoCell
  else
    csItem = list:NewListViewItem("p_city_list_template_2")
    theScript = Season5DeclareWarTimeCityInfoCell
  end
  if self.items[csItem] == nil then
    local nameStr = "cell" .. UIUtil.GetLoopListItemIndex("declare_war_time_")
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(theScript, nameStr)
  end
  if self.items[csItem] ~= nil then
    local cellData = {}
    cellData.CityData = data
    self.items[csItem]:ReInit(cellData)
  end
  return csItem
end

return Season5DeclareWarTimeView
