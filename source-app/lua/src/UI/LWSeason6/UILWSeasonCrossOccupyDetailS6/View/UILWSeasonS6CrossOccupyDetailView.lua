local UILWSeasonS6CrossOccupyDetailView = BaseClass("UILWSeasonS6CrossOccupyDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local tips1_path = "PopUpTitle/bg/tips1"
local tips2_path = "PopUpTitle/bg/tips2"
local value_total_path = "PopUpTitle/Common_bg_orange2/valueTotal"
local value_rank_path = "PopUpTitle/Common_bg_orange2/valueRank"
local info_btn_cross_path = "PopUpTitle/InfoBtnCross"
local info_btn2_path = "PopUpTitle/Local/icon2/InfoBtn2"
local info_btn3_path = "PopUpTitle/Cross/icon3/InfoBtn3"
local info_btn4_path = "PopUpTitle/Cross/icon4/InfoBtn4"
local icon2_path = "PopUpTitle/Local/icon2"
local count2_path = "PopUpTitle/Local/icon2/count2"
local influence2_path = "PopUpTitle/Local/icon2/influence2"
local icon1_path = "PopUpTitle/Local/icon1"
local count1_path = "PopUpTitle/Local/icon1/count1"
local influence1_path = "PopUpTitle/Local/icon1/influence1"
local title1_path = "PopUpTitle/Local/title1"
local title2_path = "PopUpTitle/Local/title2"
local icon4_path = "PopUpTitle/Cross/icon4"
local count4_path = "PopUpTitle/Cross/icon4/count4"
local influence4_path = "PopUpTitle/Cross/icon4/influence4"
local icon3_path = "PopUpTitle/Cross/icon3"
local count3_path = "PopUpTitle/Cross/icon3/count3"
local influence3_path = "PopUpTitle/Cross/icon3/influence3"
local title3_path = "PopUpTitle/Cross/title3"
local title4_path = "PopUpTitle/Cross/title4"
local icon12_path = "PopUpTitle/bg/icon12"
local icon11_path = "PopUpTitle/bg/icon11"

function UILWSeasonS6CrossOccupyDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
  self.value_rank:SetText("")
  self.btn_rank:SetOnClick(function()
    if self.data then
      local globalRank = toInt(self.data.globalRank)
      if 0 < globalRank then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, {anim = true}, 1)
      end
    end
  end)
  self.info_btn_cross:SetOnClick(function()
    local msg = Localization:GetString("s6_sore_ui_info01")
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end)
  self.info_btn2:SetOnClick(function()
    UIUtil.ShowButtonTips(self.info_btn2, nil, "s6_sore_ui_03", false)
  end)
  self.info_btn3:SetOnClick(function()
    UIUtil.ShowButtonTips(self.info_btn3, nil, "s6_sore_ui_02", false)
  end)
  self.info_btn4:SetOnClick(function()
    UIUtil.ShowButtonTips(self.info_btn4, nil, "s6_sore_ui_04", false)
  end)
  local allianceId = LuaEntry.Player.allianceId
  if allianceId ~= nil and allianceId ~= "" then
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceCityForceDetail, allianceId)
  end
end

function UILWSeasonS6CrossOccupyDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonS6CrossOccupyDetailView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.tips1 = self:AddComponent(UITextMeshProUGUIEx, tips1_path)
  self.tips2 = self:AddComponent(UITextMeshProUGUIEx, tips2_path)
  self.value_total = self:AddComponent(UITextMeshProUGUIEx, value_total_path)
  self.value_rank = self:AddComponent(UITextMeshProUGUIEx, value_rank_path)
  self.btn_rank = self:AddComponent(UIButton, "PopUpTitle/Common_bg_orange2/valueRank/btnRank")
  self.info_btn_cross = self:AddComponent(UIButton, info_btn_cross_path)
  self.info_btn2 = self:AddComponent(UIButton, info_btn2_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.count2 = self:AddComponent(UITextMeshProUGUIEx, count2_path)
  self.influence2 = self:AddComponent(UITextMeshProUGUIEx, influence2_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.count1 = self:AddComponent(UITextMeshProUGUIEx, count1_path)
  self.influence1 = self:AddComponent(UITextMeshProUGUIEx, influence1_path)
  self.title1 = self:AddComponent(UITextMeshProUGUIEx, title1_path)
  self.title2 = self:AddComponent(UITextMeshProUGUIEx, title2_path)
  self.icon4 = self:AddComponent(UIImage, icon4_path)
  self.count4 = self:AddComponent(UITextMeshProUGUIEx, count4_path)
  self.influence4 = self:AddComponent(UITextMeshProUGUIEx, influence4_path)
  self.icon3 = self:AddComponent(UIImage, icon3_path)
  self.count3 = self:AddComponent(UITextMeshProUGUIEx, count3_path)
  self.influence3 = self:AddComponent(UITextMeshProUGUIEx, influence3_path)
  self.info_btn3 = self:AddComponent(UIButton, info_btn3_path)
  self.title3 = self:AddComponent(UITextMeshProUGUIEx, title3_path)
  self.title4 = self:AddComponent(UITextMeshProUGUIEx, title4_path)
  self.info_btn4 = self:AddComponent(UIButton, info_btn4_path)
  self.icon12 = self:AddComponent(UIButton, icon12_path)
  self.icon11 = self:AddComponent(UIButton, icon11_path)
end

function UILWSeasonS6CrossOccupyDetailView:ComponentDestroy()
  self.btn_back = nil
  self.tips1 = nil
  self.tips2 = nil
  self.value_total = nil
  self.value_rank = nil
  self.btn_rank = nil
  self.info_btn_cross = nil
  self.info_btn2 = nil
  self.info_btn3 = nil
  self.info_btn4 = nil
  self.icon12 = nil
  self.icon11 = nil
  self.icon1 = nil
  self.icon2 = nil
  self.icon3 = nil
  self.icon4 = nil
  self.count1 = nil
  self.count2 = nil
  self.count3 = nil
  self.count4 = nil
  self.influence2 = nil
  self.influence1 = nil
  self.influence3 = nil
  self.influence4 = nil
  self.title1 = nil
  self.title2 = nil
  self.title3 = nil
  self.title4 = nil
end

function UILWSeasonS6CrossOccupyDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCampDestroyInfluenceDetailRefresh, self.OnInfluenceDetail)
end

function UILWSeasonS6CrossOccupyDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCampDestroyInfluenceDetailRefresh, self.OnInfluenceDetail)
  base.OnRemoveListener(self)
end

function UILWSeasonS6CrossOccupyDetailView:OnInfluenceDetail(data)
  self.data = data or DataCenter.WorldAllianceCityDataManager:GetAllianceCityForceDetail(LuaEntry.Player.allianceId, false)
  self:UpdateData()
end

function UILWSeasonS6CrossOccupyDetailView:SetBaseInfo()
  local dailyDeclareNum = DataCenter.SeasonDataManager.dailyDeclareNum or 0
  local dailyOccupyNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyNum or 0
  local dailyOccupyMaxNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyMaxNum or 0
  local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
  self.tips1:SetLocalText("season_s2_city_description_07", k6 - dailyDeclareNum, k6)
  self.tips2:SetLocalText("s6_sore_ui01", dailyOccupyMaxNum - dailyOccupyNum, dailyOccupyMaxNum)
  self.fightOpenTime = nil
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local force_city_value = 0
  local force_king_value = 0
  local force_city_num = 0
  local force_king_num = 0
  local force_city_value_destroy = 0
  local force_king_value_destroy = 0
  local force_city_num_destroy = 0
  local force_king_num_destroy = 0
  local force_city_count = DataCenter.SeasonDataManager.CrossOccupyCityMaxNumLocal
  local meta
  local mgr = DataCenter.AllianceCityTemplateManager
  if self.data then
    local occupiedCities = self.data.occupiedCities
    if occupiedCities then
      for _, cityId in ipairs(occupiedCities) do
        meta = mgr:GetTemplate(cityId, mySourceServerId)
        if meta:IsThroneCity() then
          force_king_num = force_king_num + 1
          force_king_value = force_king_value + meta:getIntValue("force", 0)
        elseif meta:IsCity() then
          force_city_num = force_city_num + 1
          force_city_value = force_city_value + meta:getIntValue("force", 0)
        end
      end
    else
      force_city_value = 0
      force_king_value = 0
      force_city_num = 0
      force_king_num = 0
    end
    local destroyedCities = self.data.destroyedCities
    if destroyedCities then
      for _, cityId in ipairs(destroyedCities) do
        meta = mgr:GetTemplate(cityId, mySourceServerId)
        if meta:IsThroneCity() then
          force_king_num_destroy = force_king_num_destroy + 1
          force_king_value_destroy = force_king_value_destroy + meta:getIntValue("destroy_force", 0)
        elseif meta:IsCity() then
          force_city_num_destroy = force_city_num_destroy + 1
          force_city_value_destroy = force_city_value_destroy + meta:getIntValue("destroy_force", 0)
        end
      end
    else
      force_city_value_destroy = 0
      force_king_value_destroy = 0
      force_city_num_destroy = 0
      force_king_num_destroy = 0
    end
  else
    local allCityList = DataCenter.WorldAllianceCityDataManager:GetAllianceCityList(mySourceServerId)
    if allCityList then
      for k, v in pairs(allCityList) do
        if v and v.allianceId == myAllianceId then
          meta = mgr:GetTemplate(v.cityId, mySourceServerId)
          if meta and meta:IsCity() then
            if v.destroyServerId == 0 then
              force_city_num = force_city_num + 1
              force_city_value = force_city_value + meta:getIntValue("force", 0)
            else
              force_city_num_destroy = force_city_num_destroy + 1
              force_city_value_destroy = force_city_value_destroy + meta:getIntValue("destroy_force", 0)
            end
          end
          if meta and meta:IsThroneCity() then
            if v.destroyServerId == 0 then
              force_king_num = force_king_num + 1
              force_king_value = force_king_value + meta:getIntValue("force", 0)
            else
              force_king_num_destroy = force_king_num_destroy + 1
              force_king_value_destroy = force_king_value_destroy + meta:getIntValue("destroy_force", 0)
            end
          end
        elseif v and v.occupyServerId == mySourceServerId then
          meta = mgr:GetTemplate(v.cityId, mySourceServerId)
          if meta and meta:IsCity() and meta:getIntValue("force_type", 0) == 1 then
            if v.destroyServerId == 0 then
              force_city_value = force_city_value + meta:getIntValue("force", 0)
            else
              force_city_value_destroy = force_city_value_destroy + meta:getIntValue("destroy_force", 0)
            end
          end
          if meta and meta:IsThroneCity() and meta:getIntValue("force_type", 0) == 1 then
            if v.destroyServerId == 0 then
              force_king_value = force_king_value + meta:getIntValue("force", 0)
            else
              force_king_value_destroy = force_king_value_destroy + meta:getIntValue("destroy_force", 0)
            end
          end
        end
      end
    end
  end
  local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
  if myCampId == 1 then
    self.icon1:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_2.png")
    self.icon2:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_12.png")
    self.icon3:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_1.png")
    self.icon4:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_8.png")
    self.icon12:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_3.png")
    self.icon11:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_2.png")
  else
    self.icon1:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_1.png")
    self.icon2:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_8.png")
    self.icon3:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_2.png")
    self.icon4:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_12.png")
    self.icon12:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_3.png")
    self.icon11:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/LodIcon/lyt_S6_wujisuofang_1.png")
  end
  self.count1:SetText("<u>" .. force_city_num .. "/" .. force_city_count .. "</u>")
  self.count2:SetText("<u>" .. force_king_num .. "/4</u>")
  self.count3:SetText("<u>" .. tostring(force_city_num_destroy) .. "</u>")
  self.count4:SetText("<u>" .. force_king_num_destroy .. "/4</u>")
  self.influence2:SetText(string.GetFormattedSeparatorNum(force_king_value))
  self.influence1:SetText(string.GetFormattedSeparatorNum(force_city_value))
  self.influence4:SetText(string.GetFormattedSeparatorNum(toInt(force_king_value_destroy)))
  self.influence3:SetText(string.GetFormattedSeparatorNum(toInt(force_city_value_destroy)))
  self.title2:SetLocalText("s6_sore_title_03")
  self.title1:SetLocalText("300724")
  self.title4:SetLocalText("s6_sore_title_02")
  self.title3:SetLocalText("s6_sore_title_01")
  local force_value = toInt(force_city_value + force_king_value)
  if self.data then
    local globalRank = toInt(self.data.globalRank)
    force_value = toInt(self.data.forceValue)
    if 0 < globalRank then
      self.value_rank:SetText("<u>" .. Localization:GetString("801140", globalRank) .. "</u>")
    else
      self.value_rank:SetText("")
    end
  else
    self.value_rank:SetText("")
  end
  self.value_total:SetText(Localization:GetString("803025") .. ":" .. string.GetFormattedSeparatorNum(force_value))
end

function UILWSeasonS6CrossOccupyDetailView:UpdateData()
  self:SetBaseInfo()
  local isDeclareDay = DataCenter.UILWSeasonAllianceWarTimeManager:IsDeclareDay()
  local isCrossDeclareActiveOpen = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonCrossDeclareWarActivity.Type)
  if isDeclareDay and isCrossDeclareActiveOpen then
  else
    self.fightOpenTime = DataCenter.UILWSeasonAllianceWarTimeManager:GetNextDeclareTime()
    self:Update1000MS()
  end
end

function UILWSeasonS6CrossOccupyDetailView:Update1000MS()
  if self.fightOpenTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.fightOpenTime - curTime
    if 0 < remainTime then
      self.tips1:SetLocalText("war_zone_outpost_87", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self:SetBaseInfo()
    end
  end
end

return UILWSeasonS6CrossOccupyDetailView
