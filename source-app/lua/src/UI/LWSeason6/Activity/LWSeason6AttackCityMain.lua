local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LWSeason6AttackCityMain = BaseClass("LWSeason6AttackCityMain", base)
local Localization = CS.GameEntry.Localization
local bg_path = "Mask/Bg"
local city_bg_path = "RightView/icon/cityBg"
local city_icon_path = "RightView/icon/CityIcon"
local title_path = "RightView/Top/title"
local sub_title_path = "RightView/Top/subTitle"
local info_btn_path = "RightView/Top/InfoBtn"
local time_content_path = "RightView/Top/TimeBg"
local time_title_path = "RightView/icon/TimeBg/TimeTitle"
local remain_time_path = "RightView/icon/TimeBg/remainTime"
local rank_btn_path = "RightView/Top/RankBtn"
local gift_btn_path = "RightView/Top/GiftBtn"
local gift_text_path = "RightView/Top/GiftBtn/GiftIcon/GiftText"
local task_title_path = "RightView/Bottom/GameObject/TaskTitle"
local item_path = "RightView/Bottom/GameObject/Item"
local content_path = "RightView/Bottom/GameObject/ScrollView/Viewport/Content"
local building_path = "RightView/BottomAttack/GameObject/Build/building"
local bottom_path = "RightView/Bottom"
local bottom_attack_path = "RightView/BottomAttack"
local attack_title_path = "RightView/BottomAttack/AttackTitle"
local attack_city_icon_path = "RightView/BottomAttack/GameObject/Build/building/AttackCityIcon"
local text_path = "RightView/BottomAttack/GameObject/Build/Pos/Text"
local attack_detail_path = "RightView/BottomAttack/GameObject/Info/AttackDetail"
local scroll_view_path = "RightView/BottomAttack/GameObject/Info/ScrollView"
local content_attack_path = "RightView/BottomAttack/GameObject/Info/ScrollView/Viewport/ContentAttack"
local btn_jump_path = "RightView/BottomAttack/BtnJump"
local pos_path = "RightView/BottomAttack/GameObject/Build/Pos"
local red_point_path = "RightView/Top/GiftBtn/RedPoint"
local red_point_jump_path = "RightView/BottomAttack/BtnJump/RedPointJump"
local openTime_path = "RightView/Top/TimeBg/openTime"
local allianceInfo_path = "RightView/Top/allianceInfo"
local allianceName_path = "RightView/Top/allianceInfo/allianceName"
local allianceNum_path = "RightView/Top/allianceInfo/allianceNum"
local allianceAddContent_path = "RightView/Top/allianceAddContent"
local allianceAddTxt_path = "RightView/Top/allianceAddContent/allianceAddTxt"
local addAllianceBtn_path = "RightView/Top/allianceAddContent/allianceAddTxt/addAllianceBtn"
local season_path = "RightView/Season"
local season_title_path = "RightView/Season/season_title"
local season_city_info_path = "RightView/Season/season_cityInfo"
local season_reward_root_path = "RightView/Season/season_reward_root"
local season_reward_path = "RightView/Season/season_reward_root/season_reward"
local season_reward_count_path = "RightView/Season/season_reward_root/season_reward_count"
local season_reward_icon_path = "RightView/Season/season_reward_root/icon/season_reward_icon"
local season1_path = "RightView/Season1"
local season1_attack_title_path = "RightView/Season1/attack_title"
local season1_attack_time_path = "RightView/Season1/attack_time"
local season1_attack_city_icon_path = "RightView/Season1/AttackInfoRoot/attack_icon"
local season1_attack_city_name_path = "RightView/Season1/AttackInfoRoot/attack_name"
local season1_text_path = "RightView/Season1/AttackInfoRoot/Pos/attack_pos"
local season1_btn_attack_go_path = "RightView/Season1/AttackInfoRoot/BtnAttackGo"
local city_name_path = "RightView/Season1/cityName"
local season_stone_root_path = "RightView/Season/season_stone_root"
local season_stone_txt_path = "RightView/Season/season_stone_root/season_stone_txt"
local season_stone_icon_path = "RightView/Season/season_stone_root/icon/season_stone_icon"
local season_stone_count_path = "RightView/Season/season_stone_root/season_stone_count"
local needShowRedPoint = true

function LWSeason6AttackCityMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWSeason6AttackCityMain:OnDestroy()
  DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.SeasonCityWar, false)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeason6AttackCityMain:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.sub_title = self:AddComponent(UIText, sub_title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.time_content = self:AddComponent(UIBaseContainer, time_content_path)
  self.time_title = self:AddComponent(UIText, time_title_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.rank_btn = self:AddComponent(UIButton, rank_btn_path)
  self.rank_btn:SetActive(false)
  self.detail_btn = self:AddComponent(UIButton, gift_btn_path)
  self.detail_text = self:AddComponent(UIText, gift_text_path)
  self.task_title = self:AddComponent(UIText, task_title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.detail_text:SetLocalText("456505")
  self.task_title:SetLocalText("456504")
  self.city_icon = self:AddComponent(UIRawImage, city_icon_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.info_btn:SetOnClick(function()
    self:OnHelpBtnClick()
  end)
  self.detail_btn:SetOnClick(function()
    if needShowRedPoint then
      needShowRedPoint = false
      EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    end
    self.red_point:SetActive(false)
    self:OnBtnDetailClick()
  end)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.city_bg = self:AddComponent(UIRawImage, city_bg_path)
  self.bottom = self:AddComponent(UIBaseContainer, bottom_path)
  self.bottom_attack = self:AddComponent(UIBaseContainer, bottom_attack_path)
  self.attack_title = self:AddComponent(UIText, attack_title_path)
  self.cityAttack = self:AddComponent(UIImage, attack_city_icon_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.attack_detail = self:AddComponent(UIText, attack_detail_path)
  self.scroll_view = self:AddComponent(UIImage, scroll_view_path)
  self.content_attack = self:AddComponent(UIBaseContainer, content_attack_path)
  self.building = self:AddComponent(UIButton, building_path)
  self.btn_jump = self:AddComponent(UIButton, btn_jump_path)
  self.pos = self:AddComponent(UIButton, pos_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_point_jump = self:AddComponent(UIImage, red_point_jump_path)
  self.btn_jump:SetOnClick(function()
    self:JumpTo()
  end)
  self.building:SetOnClick(function()
    self:JumpTo()
  end)
  self.pos:SetOnClick(function()
    self:JumpTo()
  end)
  self.red_point:SetActive(false)
  self.red_point_jump:SetActive(false)
  self.openActivityTime = self:AddComponent(UIText, openTime_path)
  self.allianceInfo = self:AddComponent(UIBaseContainer, allianceInfo_path)
  self.allianceName = self:AddComponent(UIText, allianceName_path)
  self.allianceNum = self:AddComponent(UIText, allianceNum_path)
  self.allianceAddContent = self:AddComponent(UIBaseContainer, allianceAddContent_path)
  self.allianceAddTxt = self:AddComponent(UIText, allianceAddTxt_path)
  self.addAllianceBtn = self:AddComponent(UIButton, addAllianceBtn_path)
  self.addAllianceBtn:SetOnClick(function()
    self:OnAddAllianceBtnClick()
  end)
  self.allianceInfo:SetActive(false)
  self.allianceAddContent:SetActive(false)
  self.season = self:AddComponent(UIBaseContainer, season_path)
  self.season_title = self:AddComponent(UIText, season_title_path)
  self.season_city_info = self:AddComponent(UIText, season_city_info_path)
  self.season_reward_root = self:AddComponent(UIBaseContainer, season_reward_root_path)
  self.season_reward = self:AddComponent(UIText, season_reward_path)
  self.season_reward_count = self:AddComponent(UIText, season_reward_count_path)
  self.season_reward_icon = self:AddComponent(UIButton, season_reward_icon_path)
  self.season_reward_icon:SetOnClick(function()
    self:OnRewardShowClick()
  end)
  self.season1 = self:AddComponent(UIBaseContainer, season1_path)
  self.season1_attack_title = self:AddComponent(UIText, season1_attack_title_path)
  self.season1_attack_time = self:AddComponent(UIText, season1_attack_time_path)
  self.season1_attack_city_icon = self:AddComponent(UIImage, season1_attack_city_icon_path)
  self.season1_attack_city_name = self:AddComponent(UIText, season1_attack_city_name_path)
  self.season1_text = self:AddComponent(UITextMeshProUGUIEx, season1_text_path)
  self.season1_btn_attack_go = self:AddComponent(UIButton, season1_btn_attack_go_path)
  self.city_name = self:AddComponent(UIText, city_name_path)
  self.season1_btn_attack_go:SetOnClick(function()
    self:OnGotoBtnClick()
  end)
  self.season1:SetActive(false)
  self.season_stone_root = self:AddComponent(UIBaseContainer, season_stone_root_path)
  self.season_stone_icon = self:AddComponent(UIButton, season_stone_icon_path)
  self.season_stone_count = self:AddComponent(UITextMeshProUGUIEx, season_stone_count_path)
  self.season_stone_txt = self:AddComponent(UITextMeshProUGUIEx, season_stone_txt_path)
  self.season_stone_icon:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.isLocal = true
    param.desc = DataCenter.ResourceManager:GetResourceDescByType(ResourceType.AllianceStone)
    param.alignObject = self.season_stone_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.season_stone_txt:SetText(Localization:GetString("season_s2_city_description_08") .. ":")
  self.btn_city_icon = self:AddComponent(UIButton, city_icon_path)
  self.btn_season_title = self:AddComponent(UIButton, season_title_path)
  self.btn_city_icon:SetOnClick(function()
    self:JumpToOpenCity()
  end)
  self.btn_season_title:SetOnClick(function()
    self:JumpToOpenCity()
  end)
end

function LWSeason6AttackCityMain:JumpToOpenCity()
  if self.WarCityId and self.cityInfo then
    self.cityInfo:JumpTo()
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local cityList = DataCenter.AllianceCityTemplateManager:GetAllTemplate(mySourceServerId)
  local cityMeta
  if cityList ~= nil and self.openLevel ~= nil then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local curServerId = LuaEntry.Player:GetCurServerId()
    local mgr = DataCenter.SeasonDataManager
    local openLevel = toInt(self.openLevel)
    for _, meta in pairs(cityList) do
      if meta ~= nil and meta.level == openLevel and (meta.type == WorldAllianceCityType.City or meta.type == WorldAllianceCityType.King) then
        local theServerId = mgr:GetNinePalacesServer(meta.bigMapIndex, ServerEnum.Source)
        if meta.bigMapIndex == 5 or theServerId == curServerId or theServerId == loginServerId then
          cityMeta = meta
          break
        end
      end
    end
  end
  if cityMeta then
    cityMeta:JumpTo()
  end
end

function LWSeason6AttackCityMain:OnGotoBtnClick()
  if self.WarCityId and self.cityInfo then
    local theCityId = self.WarCityId
    self.cityInfo:JumpTo()
    UIUtil.GetTodayActiveCount("SeasonAttackCity" .. theCityId, true)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonCrossAttackCityInfo)
    return
  end
  if self.thePreDeclareCity ~= nil then
    local cityPos = self.thePreDeclareCity.pos
    if cityPos ~= nil and cityPos.x ~= nil and cityPos.y ~= nil then
      local SourceServerId = LuaEntry.Player:GetSourceServerId()
      local v3 = SceneUtils.TileToWorld(cityPos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, nil, nil, nil, SourceServerId)
    end
  end
end

function LWSeason6AttackCityMain:OnRewardShowClick()
  if ComponentIsValid(self.season_reward_icon) then
    UIUtil.ShowLootRewardList(self.season_reward_icon:GetPosition())
  end
end

function LWSeason6AttackCityMain:JumpTo()
  if self.WarCityId and self.cityInfo then
    local theCityId = self.WarCityId
    self.cityInfo:JumpTo()
    UIUtil.GetTodayActiveCount("SeasonAttackCity" .. theCityId, true)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonCrossAttackCityInfo)
    return
  end
  if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
    local SourceServerId = LuaEntry.Player:GetSourceServerId()
    local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
    if self.cityInfo then
      UIUtil.GetTodayActiveCount("SeasonAttackCity" .. self.cityInfo.id, true)
      EventManager:GetInstance():Broadcast(EventId.LWSeasonCrossAttackCityInfo)
    end
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, nil, nil, nil, SourceServerId)
  end
end

function LWSeason6AttackCityMain:ComponentDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.content_attack:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  self.bg = nil
  self.city_bg = nil
  self.city_name = nil
  self.title = nil
  self.sub_title = nil
  self.info_btn = nil
  self.time_content = nil
  self.time_title = nil
  self.remain_time = nil
  self.detail_btn = nil
  self.detail_text = nil
  self.task_title = nil
  self.content = nil
  self.theItem = nil
  self.openActivityTime = nil
  self.allianceInfo = nil
  self.allianceName = nil
  self.allianceNum = nil
  self.allianceAddContent = nil
  self.allianceAddTxt = nil
  self.addAllianceBtn = nil
  self.season1 = nil
  self.season1_attack_title = nil
  self.season1_attack_time = nil
  self.season1_attack_city_icon = nil
  self.season1_attack_city_name = nil
  self.season1_text = nil
  self.season1_btn_attack_go = nil
  self.season_stone_root = nil
  self.season_stone_txt = nil
  self.season_stone_icon = nil
  self.season_stone_count = nil
  self.btn_city_icon = nil
  self.btn_season_title = nil
end

function LWSeason6AttackCityMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  self:AddUIListener(EventId.GetActivityDetail, self.UpdateData)
end

function LWSeason6AttackCityMain:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  self:RemoveUIListener(EventId.GetActivityDetail, self.UpdateData)
  base.OnRemoveListener(self)
end

function LWSeason6AttackCityMain:SetData(activityId, openLevel, openTime, forDeclare)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.openLevel = openLevel
  self.openTime = openTime
  self.forDeclare = forDeclare
  self.thePreDeclareTime = nil
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.title:SetLocalText(self.activityData.activityName)
  self.sub_title:SetLocalText(self.activityData.desc_info)
  CS.GameEntry.Setting:SetBool("S6OpenedAttackCity_" .. LuaEntry.Player.uid, true)
  self:RefreshUI()
end

function LWSeason6AttackCityMain:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.thePreDeclareTime then
    local remainTime = self.thePreDeclareTime - curTime
    if 0 < remainTime then
      self.season1_attack_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      self.remain_time:SetActive(false)
      self.time_title:SetActive(false)
      self.openTime = nil
    else
      self.thePreDeclareTime = nil
      self.season1:SetActive(false)
    end
  end
  if not (self.activityData and self.remain_time:GetActive()) or self.openTime == nil then
    return
  end
  local remainTime = self.openTime - curTime
  if 0 < remainTime then
    self.remain_time:SetActive(true)
    self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.remain_time:SetActive(false)
    self.time_title:SetActive(false)
    self.openTime = nil
    if self.sendMsgTime == nil or curTime > self.sendMsgTime + 5000 then
      self.sendMsgTime = curTime
      DataCenter.WorldAllianceCityDataManager:GetCityWarInfo(nil, true)
    end
  end
end

function LWSeason6AttackCityMain:RefreshAttackUI(cityId, dataServer)
  self.bottom:SetActive(false)
  self.bottom_attack:SetActive(true)
  self.attack_title:SetLocalText("456520")
  local dataConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
  if dataServer == nil or dataServer.alId == nil or dataServer.alId == "" then
    self.scroll_view:SetActive(true)
    self.attack_detail:SetLocalText("456504")
    local extraRewards = DataCenter.RewardManager:ParseRewardsStr(dataConfig.show_reward)
    if extraRewards ~= nil then
      local goItem, theItem
      self.content_attack:RemoveComponents(UICommonResItem)
      self.theItem:GameObjectRecycleAll()
      for i, item in ipairs(extraRewards) do
        local levelName = "item_" .. i
        goItem = self.theItem:GameObjectSpawn(self.content_attack.transform)
        goItem.name = levelName
        goItem:SetActive(true)
        theItem = self.content_attack:AddComponent(UICommonResItem, levelName)
        theItem:ReInit(item)
      end
    end
    self.cityAttack:SetActive(true)
    self.cityAttack:LoadSprite(dataConfig:GetIconPath(true))
  else
    local txt1 = "<color=#f97077>[" .. dataServer.alAbbr .. "]" .. dataServer.alName .. "</color>"
    local txt2 = "<color=\"white\">" .. Localization:GetString("456518") .. "</color>"
    self.scroll_view:SetActive(false)
    self.attack_detail:SetText(txt1 .. txt2)
    self.cityAttack:SetActive(true)
    self.cityAttack:LoadSprite(dataConfig:GetIconPath(false))
  end
  self.cityAttack:SetNativeSize()
  if dataConfig ~= nil and dataConfig.pos ~= nil then
    self.text:SetText("<u>(" .. dataConfig.pos.x .. "," .. dataConfig.pos.y .. ")</u>")
  else
    self.text:SetText("")
  end
  self.dataConfig = dataConfig
  self.dataServer = dataServer
  self.cityPos = dataConfig.pos
end

function LWSeason6AttackCityMain:ShowCityInfo(cityInfo)
  local bigMapIndex = cityInfo.bigMapIndex
  local theServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(bigMapIndex)
  local myCampId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(theServerId)
  if myCampId == 1 then
    self.bg:LoadSprite("Assets/Main/SeasonRes/S6/Textures/Activity/Bg/attack_city/mjc_S6_CSJS_milin_bg01.png")
    self.city_bg:LoadSprite("Assets/Main/SeasonRes/S6/Textures/Activity/Bg/attack_city/mjc_S6_CSJS_milin_bg02.png")
  else
    self.bg:LoadSprite("Assets/Main/SeasonRes/S6/Textures/Activity/Bg/attack_city/mjc_S6_CSJS_shidi_bg01.png")
    self.city_bg:LoadSprite("Assets/Main/SeasonRes/S6/Textures/Activity/Bg/attack_city/mjc_S6_CSJS_shidi_bg02.png")
  end
  self.city_icon:LoadSprite(cityInfo:GetBigIconPath())
  self.city_icon:SetNativeSize()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(mySourceServerId)
  if seasonInfo and LocalController:instance():hasTable(TableName.SeasonCampSkin) then
    local seasonCheck = string.format(";%s;", seasonInfo:GetSeasonIndex())
    LocalController:instance():visitTable(TableName.SeasonCampSkin, function(id, line)
      if line and line.season ~= nil and line.resource_type == 2 and string.match(line.season, seasonCheck) then
        if id == 1 and self.bg ~= nil then
          self.bg:LoadSpriteAuto(line["resource_camp0" .. myCampId])
        elseif id == 2 and self.city_bg ~= nil then
          self.city_bg:LoadSpriteAuto(line["resource_camp0" .. myCampId])
        end
      end
    end)
  end
  self.season_title:SetText(string.format("<u><size=65>LV%s.</size>%s</u>", cityInfo.level, Localization:GetString(cityInfo.name)))
  local str
  if toInt(cityInfo.force) > 0 then
    str = string.format("<color=#FFECD1>%s: </color>%s", Localization:GetString("season_influence"), string.GetFormattedSeparatorNum(toInt(cityInfo.force)))
  end
  if 0 < toInt(cityInfo.city_resistance_b) then
    if str then
      str = string.format([[
%s
<color=#FFECD1>%s: </color>%s]], str, Localization:GetString("803053"), string.GetFormattedSeparatorNum(toInt(cityInfo.city_resistance_b)))
    else
      str = string.format("<color=#FFECD1>%s: </color>%s", Localization:GetString("803053"), string.GetFormattedSeparatorNum(toInt(cityInfo.city_resistance_b)))
    end
  end
  if string.IsNullOrEmpty(str) then
    self.season_city_info:SetActive(false)
  else
    self.season_city_info:SetActive(true)
    self.season_city_info:SetText(str or "")
  end
  local itemProductId = cityInfo.itemProductId
  local itemProductCount = cityInfo.itemProductCount
  if itemProductId and itemProductCount then
    self.season_stone_root:SetActive(true)
    self.season_stone_count:SetLocalText("390968", string.GetFormattedSeparatorNum(itemProductCount))
  else
    self.season_stone_root:SetActive(false)
  end
  self.cityInfo = cityInfo
  if cityInfo.loot_rewards == nil or cityInfo.loot_rewards == 0 then
    self.season_reward_root:SetActive(false)
  else
    self.season_reward_root:SetActive(true)
    self.season_reward:SetText(Localization:GetString("season_world_city_reward_box"))
    self.season_reward_count:SetText("\195\151" .. cityInfo.loot_rewards)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.season_reward_root.transform)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.season.transform)
  if LuaEntry.Player:IsInAlliance() then
    local click_count = UIUtil.GetTodayActiveCount("SeasonAttackCity" .. cityInfo.id, false)
    if click_count == 0 then
      self.red_point_jump:SetActive(true)
    end
  end
end

function LWSeason6AttackCityMain:RefreshUI()
  local openLevel = self.openLevel
  local openTime = self.openTime
  local forDeclare = self.forDeclare
  local cityWarInfoSource, cityWarInfoCenter = DataCenter.WorldAllianceCityDataManager:FetchBitMapCityWarInfo()
  local cityInfoList1 = {}
  local cityInfoList2 = {}
  if cityWarInfoSource ~= nil then
    cityInfoList1 = cityWarInfoSource.cityInfoList
  end
  if cityWarInfoCenter ~= nil then
    cityInfoList2 = cityWarInfoCenter.cityInfoList
  end
  if forDeclare then
    local state, declareInfo = DataCenter.AllianceDeclareWarManager:GetDeclareState()
    if state == DeclareWarState.PreDeclare then
      local cityId = toInt(declareInfo.content)
      local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
      local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(cityId)
      if openLevel ~= cityMeta.level then
        openLevel = cityMeta.level
        self.openTime = nil
      end
      self.thePreDeclareTime = protectTime
      self.thePreDeclareCity = cityMeta
      self.season1:SetActive(true)
      self.season:SetActive(false)
      self.season1_attack_title:SetLocalText("season_tips230")
      self.season1_attack_time:SetText("")
      self.city_name:SetText(string.format("<size=65>LV%s.</size>%s", cityMeta.level, Localization:GetString(cityMeta.name)))
    else
      self.season1:SetActive(false)
      self.season:SetActive(true)
    end
    local DeclareWarDataList = DataCenter.AllianceDeclareWarManager:GetAllianceDeclareWarData()
    if DeclareWarDataList ~= nil then
      local allianceId = LuaEntry.Player:GetAllianceUid()
      for _, WarData in ipairs(DeclareWarDataList) do
        if WarData.aId == allianceId then
          local cityId = tonumber(WarData.content)
          local cityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
          self.cityInfo = cityInfo
          self.WarCityId = cityId
          self.openTime = nil
          self.remain_time:SetActive(false)
          self.time_title:SetActive(false)
          self.bottom:SetActive(false)
          self.bottom_attack:SetActive(true)
          self:RefreshAttackUI(cityId, cityInfoList1[cityId] or cityInfoList2[cityId])
          self:ShowCityInfo(cityInfo)
          return
        end
      end
    end
  else
    self.season1:SetActive(false)
    self.season:SetActive(true)
  end
  if openTime ~= nil and openTime ~= 0 then
    if self.thePreDeclareTime ~= nil then
      self.time_title:SetLocalText("season_tips230")
    else
      self.time_title:SetLocalText(456503, openLevel)
    end
    self.remain_time:SetActive(openTime ~= nil and openTime ~= 0)
    self.time_title:SetActive(openTime ~= nil and openTime ~= 0)
    self.openTime = openTime
  else
    self.time_title:SetLocalText(456515, openLevel)
    self.remain_time:SetActive(false)
    self.time_title:SetActive(true)
    self.openActivityTime:SetText("")
    self.openTime = nil
  end
  self.WarCityId = nil
  self.openLevel = openLevel
  self.detail_btn:SetActive(true)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local bigMapIndex = DataCenter.SeasonDataManager:GetNinePalacesIndex(mySourceServerId)
  local cityInfo = DataCenter.AllianceCityTemplateManager:GetCityByLevel(openLevel, mySourceServerId, WorldAllianceCityType.City, bigMapIndex)
  self:ShowCityInfo(cityInfo)
  local show_reward = cityInfo.show_reward
  local extraRewards = DataCenter.RewardManager:ParseRewardsStr(show_reward)
  if extraRewards ~= nil then
    local goItem, theItem
    self.content:RemoveComponents(UICommonResItem)
    self.theItem:GameObjectRecycleAll()
    for i, item in ipairs(extraRewards) do
      local levelName = "item_" .. i
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      theItem = self.content:AddComponent(UICommonResItem, levelName)
      theItem:ReInit(item)
    end
  end
  self.bottom:SetActive(true)
  self.bottom_attack:SetActive(false)
  self.time_content:SetActive(false)
  self.allianceInfo:SetActive(false)
  self.allianceAddContent:SetActive(false)
  self:Update1000MS()
end

function LWSeason6AttackCityMain:UpdateData()
  self:RefreshUI()
end

function LWSeason6AttackCityMain:OnHelpBtnClick()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local msg = Localization:GetString(self.activityData.story)
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end
end

function LWSeason6AttackCityMain:OnBtnDetailClick()
  if self.openLevel == 1 then
    UIUtil.ShowTipsId("456522")
  elseif LuaEntry.Player:IsInAlliance() then
    DataCenter.WorldAllianceCityDataManager:FetchBitMapCityWarInfo()
    SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
    SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonAttackCityDetail)
  else
    UIUtil.ShowTipsId(2010218)
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
  end
end

function LWSeason6AttackCityMain.ExistDeclareWar()
  if LuaEntry.Player:IsInAlliance() then
    local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
    if data ~= nil then
      return needShowRedPoint
    end
  end
  return false
end

function LWSeason6AttackCityMain:OnAddAllianceBtnClick()
  if LuaEntry.Player:IsInAlliance() == false then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      return
    end
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

return LWSeason6AttackCityMain
