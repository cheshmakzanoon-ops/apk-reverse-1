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
local btn_change_alliance_path = "Root/bg/content/top/p_img_my_alliance_flag/btnChangeAlliance"
local empty_text_path = "Root/bg/content/EmptyText"
local top_path = "Root/bg/content/top"
local bottom_path = "Root/bg/content/bottom"
local SeasonCampDestroyWarTimeStateComp = require("UI/LWSeason6/SeasonCampDestroy/Comps/SeasonCampDestroyWarTimeStateComp")
local SeasonCampDestroyWarTimeStateIconComp = require("UI/LWSeason6/SeasonCampDestroy/Comps/SeasonCampDestroyWarTimeStateIconComp")
local SeasonCampDestroyWarTimeCityInfoCell = require("UI/LWSeason6/SeasonCampDestroy/WarTime/SeasonCampDestroyWarTimeCityInfoCell")
local base = UIBaseView
local SeasonCampDestroyWarTimeView = BaseClass("SeasonCampDestroyWarTimeView", UIBaseView)

function SeasonCampDestroyWarTimeView:ComponentDefine()
  self.p_btn_blur = self:AddComponent(UIButton, p_btn_blur_path)
  self.p_btn_blur:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_btn_close:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_img_my_alliance_flag = self:AddComponent(UIImage, p_img_my_alliance_flag_path)
  self.p_text_my_alliance_abbr = self:AddComponent(UITextMeshProUGUIEx, p_text_my_alliance_abbr_path)
  self.p_text_my_alliance_name = self:AddComponent(UITextMeshProUGUIEx, p_text_my_alliance_name_path)
  self.p_comp_state = self:AddComponent(SeasonCampDestroyWarTimeStateComp, p_comp_state_path)
  self.p_text_rule_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_rule_desc_path)
  self.p_comp_my_alliance_war_time = self:AddComponent(SeasonCampDestroyWarTimeStateIconComp, p_comp_my_alliance_war_time_path)
  self.p_text_list_title = self:AddComponent(UITextMeshProUGUIEx, p_text_list_title_path)
  self.p_list_city_info = self:AddComponent(UILoopListView2, p_list_city_info_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.p_Btn_ChangeAlliance = self:AddComponent(UIButton, btn_change_alliance_path)
  self.p_Btn_ChangeAlliance:SetOnClick(BindCallback(self, self.OnBtnChangeAllianceClicked))
  self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
  self.topCanvas = self:AddComponent(UICanvasGroup, top_path)
  self.bottomCanvas = self:AddComponent(UICanvasGroup, bottom_path)
  self.items = {}
  self.empty_text:SetLocalText("season_s6_activity_1200112_desc24")
end

function SeasonCampDestroyWarTimeView:ComponentDestroy()
  self.items = {}
  self.content:RemoveComponents(SeasonCampDestroyWarTimeCityInfoCell)
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
  self.empty_text = nil
  self.topCanvas = nil
  self.bottomCanvas = nil
  self.content = nil
end

function SeasonCampDestroyWarTimeView:DataDefine()
  self.currentViewAllianceId = LuaEntry.Player.allianceId
  self.viewingAllianceAllyId = nil
  self.refreshTweenSeq = nil
end

function SeasonCampDestroyWarTimeView:DataDestroy()
  if self.refreshTweenSeq ~= nil then
    self.refreshTweenSeq:Kill(false)
    self.refreshTweenSeq = nil
  end
  if self.topCanvas ~= nil then
    self.topCanvas:SetAlpha(1)
    self.topCanvas:SetInteractable(true)
    self.topCanvas:SetBlocksRaycasts(true)
  end
  if self.bottomCanvas ~= nil then
    self.bottomCanvas:SetAlpha(1)
    self.bottomCanvas:SetInteractable(true)
    self.bottomCanvas:SetBlocksRaycasts(true)
  end
end

function SeasonCampDestroyWarTimeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function SeasonCampDestroyWarTimeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyWarTimeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.Season5DeclareCityWarTimeUpdate, self.OnWarTimeUpdate)
  self:AddUIListener(EventId.SeasonCampDestroyWarTimeGetInfoUpdate, self.OnGetInfoUpdate)
  self:AddUIListener(EventId.SeasonCampDestroyActRefresh, self.OnSeasonCampDestroyActRefresh)
end

function SeasonCampDestroyWarTimeView:OnRemoveListener()
  self:RemoveUIListener(EventId.Season5DeclareCityWarTimeUpdate, self.OnWarTimeUpdate)
  self:RemoveUIListener(EventId.SeasonCampDestroyWarTimeGetInfoUpdate, self.OnGetInfoUpdate)
  self:RemoveUIListener(EventId.SeasonCampDestroyActRefresh, self.OnSeasonCampDestroyActRefresh)
  base.OnRemoveListener(self)
end

function SeasonCampDestroyWarTimeView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    if self:UpdateWarTimeData() then
      self:UpdateWarTimeUi()
    else
      DataCenter.SeasonCampDestroyManager:SendGetWarTimeInfo(self.currentViewAllianceId)
    end
  end
end

function SeasonCampDestroyWarTimeView:InitData(data)
  self.IsWarTimeFuncOpen = DataCenter.SeasonCampDestroyManager:IsFuncOpen(true)
  return true
end

function SeasonCampDestroyWarTimeView:InitUi()
  self.p_text_title:SetLocalText("season_s6_activity_1200112_btn01")
  self.p_text_rule_desc:SetLocalText("season_s5_activity_1200059_desc12")
  self.p_text_list_title:SetLocalText("season_s5_activity_1200059_desc13")
  self.p_comp_state:SetActive(false)
  self:InitListView()
  if self.topCanvas ~= nil then
    self.topCanvas:SetAlpha(0)
    self.topCanvas:SetInteractable(false)
    self.topCanvas:SetBlocksRaycasts(false)
  end
  if self.bottomCanvas ~= nil then
    self.bottomCanvas:SetAlpha(0)
    self.bottomCanvas:SetInteractable(false)
    self.bottomCanvas:SetBlocksRaycasts(false)
  end
  DataCenter.SeasonDataManager:SendGetNearAllianceWarTime(self.currentViewAllianceId)
end

function SeasonCampDestroyWarTimeView:UpdateData()
  return true
end

function SeasonCampDestroyWarTimeView:UpdateUi()
  local hasFriend = not string.IsNullOrEmpty(self.viewingAllianceAllyId)
  self.p_Btn_ChangeAlliance:SetActive(hasFriend)
  local allianceData
  if self.currentViewAllianceId == LuaEntry.Player.allianceId then
    allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  else
    allianceData = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.currentViewAllianceId)
  end
  if allianceData ~= nil then
    self.p_img_my_alliance_flag:LoadSpriteAsync(string.format(AL_FLAG_SPRITE_PATH, allianceData.icon))
    self.p_text_my_alliance_abbr:SetTextFormat("[%s]", allianceData.abbr)
    self.p_text_my_alliance_name:SetText(allianceData.allianceName)
  end
  local warTimeIconData = {}
  warTimeIconData.AllianceId = self.currentViewAllianceId
  self.p_comp_my_alliance_war_time:ReInit(warTimeIconData)
end

function SeasonCampDestroyWarTimeView:UpdateWarTimeData()
  self.MyWarTimeData = DataCenter.SeasonCampDestroyManager:GetAllianceWarTimeData(self.currentViewAllianceId)
  if self.MyWarTimeData ~= nil then
    return true
  end
  return false
end

function SeasonCampDestroyWarTimeView:UpdateWarTimeUi()
  self.p_comp_state:SetActive(true)
  local data = {}
  data.TimeIndex = self.MyWarTimeData.TimeIndex
  data.SetTime = self.MyWarTimeData.SetTime
  self.p_comp_state:ReInit(data)
end

function SeasonCampDestroyWarTimeView:OnCloseClicked()
  if self.refreshTweenSeq ~= nil then
    self.refreshTweenSeq:Kill(false)
    self.refreshTweenSeq = nil
  end
  if self.topCanvas ~= nil then
    self.topCanvas:SetAlpha(1)
    self.topCanvas:SetInteractable(true)
    self.topCanvas:SetBlocksRaycasts(true)
  end
  if self.bottomCanvas ~= nil then
    self.bottomCanvas:SetAlpha(1)
    self.bottomCanvas:SetInteractable(true)
    self.bottomCanvas:SetBlocksRaycasts(true)
  end
  self.ctrl:CloseSelf()
end

function SeasonCampDestroyWarTimeView:OnBtnChangeAllianceClicked()
  if string.IsNullOrEmpty(self.viewingAllianceAllyId) then
    return
  end
  if self.refreshTweenSeq ~= nil then
    self.refreshTweenSeq:Kill(false)
    self.refreshTweenSeq = nil
  end
  local fadeOutDuration = 0.1
  self.refreshTweenSeq = DOTween.Sequence()
  if self.topCanvas ~= nil then
    self.refreshTweenSeq:Join(self.topCanvas:FadeOut(fadeOutDuration))
    self.topCanvas:SetInteractable(false)
    self.topCanvas:SetBlocksRaycasts(false)
  end
  if self.bottomCanvas ~= nil then
    self.refreshTweenSeq:Join(self.bottomCanvas:FadeOut(fadeOutDuration))
    self.bottomCanvas:SetInteractable(false)
    self.bottomCanvas:SetBlocksRaycasts(false)
  end
  self.currentViewAllianceId = self.viewingAllianceAllyId
  self:UpdateUi()
  if self:UpdateWarTimeData() then
    self:UpdateWarTimeUi()
  else
    DataCenter.SeasonCampDestroyManager:SendGetWarTimeInfo(self.currentViewAllianceId)
  end
  DataCenter.SeasonDataManager:SendGetNearAllianceWarTime(self.currentViewAllianceId)
end

function SeasonCampDestroyWarTimeView:OnWarTimeUpdate(info)
  local shouldFadeOutFirst = self.topCanvas ~= nil and self.topCanvas:GetAlpha() > 0.01
  if self.bottomCanvas ~= nil and 0.01 < self.bottomCanvas:GetAlpha() then
    shouldFadeOutFirst = true
  end
  if self.refreshTweenSeq ~= nil then
    self.refreshTweenSeq:Kill(false)
    self.refreshTweenSeq = nil
  end
  if self.topCanvas ~= nil then
    self.topCanvas:SetInteractable(false)
    self.topCanvas:SetBlocksRaycasts(false)
  end
  if self.bottomCanvas ~= nil then
    self.bottomCanvas:SetInteractable(false)
    self.bottomCanvas:SetBlocksRaycasts(false)
  end
  local fadeOutDuration = 0.15
  local fadeInDuration = 0.15
  self.refreshTweenSeq = DOTween.Sequence()
  if shouldFadeOutFirst then
    if self.topCanvas ~= nil then
      self.refreshTweenSeq:Join(self.topCanvas:FadeOut(fadeOutDuration))
    end
    if self.bottomCanvas ~= nil then
      self.refreshTweenSeq:Join(self.bottomCanvas:FadeOut(fadeOutDuration))
    end
  end
  self.refreshTweenSeq:AppendCallback(function()
    if IsNull(self.transform) then
      return
    end
    if info.allyInfo then
      self.viewingAllianceAllyId = info.allyInfo and info.allyInfo.allyAllianceId
    else
      self.viewingAllianceAllyId = nil
    end
    self.CityList = info.cities
    self:UpdateActData()
    self:UpdateUi()
    local count = #self.CityList
    self.p_list_city_info:SetListItemCount(count, false, false)
    self.p_list_city_info:RefreshAllShownItem()
    self.empty_text:SetActive(count <= 0)
  end)
  if self.topCanvas ~= nil then
    self.refreshTweenSeq:Join(self.topCanvas:FadeIn(fadeInDuration))
  end
  if self.bottomCanvas ~= nil then
    self.refreshTweenSeq:Join(self.bottomCanvas:FadeIn(fadeInDuration))
  end
  self.refreshTweenSeq:OnComplete(function()
    self.refreshTweenSeq = nil
    if self.topCanvas ~= nil then
      self.topCanvas:SetInteractable(true)
      self.topCanvas:SetBlocksRaycasts(true)
    end
    if self.bottomCanvas ~= nil then
      self.bottomCanvas:SetInteractable(true)
      self.bottomCanvas:SetBlocksRaycasts(true)
    end
  end)
end

function SeasonCampDestroyWarTimeView:OnSeasonCampDestroyActRefresh()
  if self:UpdateActData() then
    self.p_list_city_info:RefreshAllShownItem()
  end
end

function SeasonCampDestroyWarTimeView:UpdateActData()
  if not self.CityList then
    return false
  end
  local mgr = DataCenter.SeasonCampDestroyManager
  local declareList = mgr:GetDeclareList()
  local beDeclareList = mgr:GetBeDeclareList()
  for _, cityData in ipairs(self.CityList) do
    cityData.isAttacker = false
    cityData.isDefender = false
    for _, declare in ipairs(declareList) do
      if declare.cityId == cityData.cityid and declare.serverId == cityData.sid then
        cityData.isAttacker = true
        break
      end
    end
    for _, beDeclare in ipairs(beDeclareList) do
      if beDeclare.cityId == cityData.cityid and beDeclare.serverId == cityData.sid then
        cityData.isDefender = true
        break
      end
    end
  end
  return true
end

function SeasonCampDestroyWarTimeView:OnGetInfoUpdate(evtData)
  if evtData ~= nil and evtData.AllianceId == self.currentViewAllianceId and self:UpdateWarTimeData() then
    self:UpdateWarTimeUi()
  end
end

function SeasonCampDestroyWarTimeView:InitListView()
  self.p_list_city_info:InitListView(0, function(list, index)
    return self:GetListViewItem(list, index)
  end)
end

function SeasonCampDestroyWarTimeView:GetListViewItem(list, index)
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
    theScript = SeasonCampDestroyWarTimeCityInfoCell
  else
    csItem = list:NewListViewItem("p_city_list_template_2")
    theScript = SeasonCampDestroyWarTimeCityInfoCell
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

return SeasonCampDestroyWarTimeView
