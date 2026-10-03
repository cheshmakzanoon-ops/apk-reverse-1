local UILWSeasonS5CrossOccupyDetailView = BaseClass("UILWSeasonS5CrossOccupyDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local tips1_path = "PopUpTitle/bg/tips1"
local tips2_path = "PopUpTitle/bg/tips2"
local value_total_path = "PopUpTitle/Common_bg_orange2/valueTotal"
local info_btn_cross_path = "PopUpTitle/InfoBtnCross"
local info_btn2_path = "PopUpTitle/Local/icon2/InfoBtn2"
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
local info_btn3_path = "PopUpTitle/Cross/icon3/InfoBtn3"
local title3_path = "PopUpTitle/Cross/title3"
local title4_path = "PopUpTitle/Cross/title4"

function UILWSeasonS5CrossOccupyDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
  SFSNetwork.SendMessage(MsgDefines.FetchOutpostList)
  self.info_btn_cross:SetOnClick(function()
    local msg = Localization:GetString("war_zone_outpost_88")
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end)
  self.info_btn2:SetOnClick(function()
    UIUtil.ShowButtonTips(self.info_btn2, nil, "war_zone_outpost_85", false)
  end)
  self.info_btn3:SetOnClick(function()
    UIUtil.ShowButtonTips(self.info_btn3, nil, "season_s5_zone_city_tips01", false)
  end)
end

function UILWSeasonS5CrossOccupyDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonS5CrossOccupyDetailView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.tips1 = self:AddComponent(UITextMeshProUGUIEx, tips1_path)
  self.tips2 = self:AddComponent(UITextMeshProUGUIEx, tips2_path)
  self.value_total = self:AddComponent(UITextMeshProUGUIEx, value_total_path)
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
end

function UILWSeasonS5CrossOccupyDetailView:ComponentDestroy()
  self.btn_back = nil
  self.tips1 = nil
  self.tips2 = nil
  self.value_total = nil
  self.info_btn_cross = nil
  self.info_btn2 = nil
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

function UILWSeasonS5CrossOccupyDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OutpostListUpdate, self.UpdateData)
end

function UILWSeasonS5CrossOccupyDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.OutpostListUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonS5CrossOccupyDetailView:SetBaseInfo()
  local dailyDeclareNum = DataCenter.SeasonDataManager.dailyDeclareNum or 0
  local dailyOccupyNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyNum or 0
  local dailyOccupyMaxNum = DataCenter.SeasonDataManager.dailyStrongholdOccupyMaxNum or 0
  local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
  self.tips1:SetLocalText("season_s2_city_description_07", k6 - dailyDeclareNum, k6)
  self.tips2:SetLocalText("season_s1_citylist_02", dailyOccupyMaxNum - dailyOccupyNum, dailyOccupyMaxNum)
  self.fightOpenTime = nil
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local force_city_value = 0
  local force_outpost_value = 0
  local force_king_value = 0
  local force_city_num = 0
  local force_bank_num = 0
  local force_outpost_num = 0
  local force_king_num = 0
  local force_city_count = DataCenter.SeasonDataManager.CrossOccupyCityMaxNumLocal
  local force_bank_count = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s5_stronghold", "k4", 12))
  local force_outpost_count = 8
  local force_king_count = 1
  local meta
  local mgr = DataCenter.AllianceCityTemplateManager
  local CrossOccupyCityList = DataCenter.SeasonDataManager.CrossOccupyCityList
  if CrossOccupyCityList then
    for k, v in pairs(CrossOccupyCityList) do
      meta = mgr:GetTemplate(toInt(v.cityId), v.serverId)
      if meta and meta:IsCity() then
        force_city_num = force_city_num + 1
        force_bank_count = force_bank_count + meta:getIntValue("stronghold_max", 0)
      end
    end
  end
  local CrossOccupyStrongholdList = DataCenter.SeasonDataManager.CrossOccupyStrongholdList
  if CrossOccupyStrongholdList then
    for k, v in pairs(CrossOccupyStrongholdList) do
      meta = mgr:GetTemplate(toInt(v.id), v.serverId)
      if meta then
        force_bank_num = force_bank_num + 1
      end
    end
  end
  local occupyOutpostList = DataCenter.SeasonDataManager.OccupyOutpostList
  if occupyOutpostList then
    local serverId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.Source)
    for k, OutpostId in pairs(occupyOutpostList) do
      meta = mgr:GetTemplate(toInt(OutpostId), serverId)
      if meta then
        force_outpost_num = force_outpost_num + 1
        force_outpost_value = force_outpost_value + meta:getIntValue("force", 0)
      end
    end
  end
  local allCityList = DataCenter.WorldAllianceCityDataManager:GetAllianceCityList(mySourceServerId)
  if allCityList then
    for k, v in pairs(allCityList) do
      if v:IsRuins() then
      elseif v and v.allianceId == myAllianceId then
        meta = mgr:GetTemplate(v.cityId, mySourceServerId)
        if meta and meta:IsCity() then
          force_city_value = force_city_value + meta:getIntValue("force", 0)
        elseif occupyOutpostList == nil and meta and meta:IsCrossZoneOutpostCity() then
          force_outpost_num = force_outpost_num + 1
          force_outpost_value = force_outpost_value + meta:getIntValue("force", 0)
        end
      elseif v and v.occupyServerId == mySourceServerId then
        meta = mgr:GetTemplate(v.cityId, mySourceServerId)
        if meta and meta:IsCity() and meta:getIntValue("force_type", 0) == 1 then
          force_city_value = force_city_value + meta:getIntValue("force", 0)
        elseif occupyOutpostList == nil and meta and meta:IsCrossZoneOutpostCity() then
          if meta:getIntValue("force_type", 0) == 1 then
            force_outpost_value = force_outpost_value + meta:getIntValue("force", 0)
          end
          force_outpost_num = force_outpost_num + 1
        end
      end
    end
  end
  local centerServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.View)
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(centerServerId)
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(kingCityId, centerServerId)
  if cityMeta and not string.IsNullOrEmpty(myAllianceId) then
    local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(kingCityId, centerServerId)
    if cityData ~= nil and cityData.allianceId == myAllianceId and cityData.occupyServerId ~= 0 and cityData.occupyServerId ~= nil then
      force_king_value = cityMeta:getIntValue("force", 0)
      force_king_num = 1
    end
  end
  self.icon1:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/CommonS5/LodIcon/zyf_S5_wujisuofang_3.png")
  self.icon2:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/CommonS5/LodIcon/zyf_S5_wujisuofang_2.png")
  self.icon3:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/CommonS5/LodIcon/zyf_S5_wujisuofang_5.png")
  self.icon4:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/CommonS5/LodIcon/zyf_S5_wujisuofang_7.png")
  self.count1:SetText(force_city_num .. "/" .. force_city_count)
  self.count2:SetText(force_bank_num .. "/" .. force_bank_count)
  self.count3:SetText(force_outpost_num .. "/" .. force_outpost_count)
  self.count4:SetText(force_king_num .. "/" .. force_king_count)
  self.influence1:SetText(string.GetFormattedSeparatorNum(force_city_value))
  self.influence2:SetLocalText("war_zone_outpost_86")
  self.influence3:SetText(string.GetFormattedSeparatorNum(force_outpost_value))
  self.influence4:SetText(string.GetFormattedSeparatorNum(force_king_value))
  self.title1:SetLocalText("300724")
  self.title2:SetLocalText("100199")
  self.title3:SetLocalText("war_zone_outpost_1")
  local colorWhite, colorBlue = Color.white, Color.New(0.344, 0.694, 1, 1)
  self.icon1:SetColor(0 < force_city_num and colorBlue or colorWhite)
  self.icon2:SetColor(0 < force_bank_num and colorBlue or colorWhite)
  self.icon3:SetColor(0 < force_outpost_num and colorBlue or colorWhite)
  self.icon4:SetColor(0 < force_king_num and colorBlue or colorWhite)
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local cityId, cityPos = SeasonUtil.GetCenterCityId(loginServerId)
  meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, mySourceServerId)
  if meta ~= nil then
    self.title4:SetLocalText(meta.name)
  else
    self.title4:SetText("???")
  end
  local force_value = force_city_value + force_outpost_value + force_king_value
  self.value_total:SetText(Localization:GetString("803025") .. ":" .. string.GetFormattedSeparatorNum(force_value))
end

function UILWSeasonS5CrossOccupyDetailView:UpdateData()
  self:SetBaseInfo()
  local isDeclareDay = DataCenter.UILWSeasonAllianceWarTimeManager:IsDeclareDay()
  local isCrossDeclareActiveOpen = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonCrossDeclareWarActivity.Type)
  if isDeclareDay and isCrossDeclareActiveOpen then
  else
    self.fightOpenTime = DataCenter.UILWSeasonAllianceWarTimeManager:GetNextDeclareTime()
    self:Update1000MS()
  end
end

function UILWSeasonS5CrossOccupyDetailView:Update1000MS()
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

return UILWSeasonS5CrossOccupyDetailView
