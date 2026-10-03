local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonAttackCityMain = BaseClass("SeasonAttackCityMain", base)
local UIRewardTipView = require("UI.UIRewardTip.View.UIRewardTipView")
local Localization = CS.GameEntry.Localization
local city_icon_path = "RightView/icon/CityIcon"
local title_path = "RightView/Top/title"
local sub_title_path = "RightView/Top/subTitle"
local info_btn_path = "RightView/Top/InfoBtn"
local time_content_path = "RightView/Top/TimeBg"
local time_title_path = "RightView/Bottom/TimeBg/TimeTitle"
local remain_time_path = "RightView/Bottom/TimeBg/remainTime"
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
local needShowRedPoint = true
local ActivityState = {
  BeforeBattle = 1,
  InBattle = 2,
  AfterBattle = 3
}

function SeasonAttackCityMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonAttackCityMain:OnDestroy()
  DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.SeasonCityWar, false)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAttackCityMain:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.sub_title = self:AddComponent(UIText, sub_title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.time_content = self:AddComponent(UIBaseContainer, time_content_path)
  self.time_title = self:AddComponent(UIText, time_title_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.rank_btn = self:AddComponent(UIButton, rank_btn_path)
  self.rank_btn:SetOnClick(function()
    if self.openLevel == 1 then
      UIUtil.ShowTipsId("456522")
    else
      local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonAttackCityActivity.Type)
      local actInfo = actList and actList[1] or nil
      if actInfo and actInfo.id then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonAttackCityRank, actInfo.id)
      end
    end
  end)
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
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
    self.red_point:SetActive(false)
    self:OnBtnDetailClick()
  end)
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
  self.red_point:SetActive(needShowRedPoint and SeasonAttackCityMain.ExistDeclareWar())
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
  self:RefreshActivityState()
end

function SeasonAttackCityMain:OnRewardShowClick()
  local param = UIRewardTipView.ParamDataClass.New()
  param.position = self.season_reward_icon:GetPosition()
  local _screenPos = PosConverse.UIWorldToScreenPos(param.position)
  local ScreenSize = CS.UnityEngine.Screen
  if _screenPos.x * 2 < ScreenSize.width then
    param.deltaX = 30
    param.dir = UIRewardTipView.Direction.LEFT
  else
    param.deltaX = -30
    param.dir = UIRewardTipView.Direction.RIGHT
  end
  param.rewardList = DataCenter.SeasonDataManager:GetLootRewardList()
  param.totalVal = 0
  if param.rewardList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardTip, {anim = false}, param)
  end
end

function SeasonAttackCityMain:JumpTo()
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

function SeasonAttackCityMain:ComponentDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.content_attack:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
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
end

function SeasonAttackCityMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  self:AddUIListener(EventId.GetActivityDetail, self.UpdateData)
  self:AddUIListener(EventId.ActivityAttackCityRankDataUpdate, self.RefreshRankView)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.RefreshRankView)
end

function SeasonAttackCityMain:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  self:RemoveUIListener(EventId.GetActivityDetail, self.UpdateData)
  self:RemoveUIListener(EventId.ActivityAttackCityRankDataUpdate, self.RefreshRankView)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.RefreshRankView)
  base.OnRemoveListener(self)
end

function SeasonAttackCityMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.title:SetLocalText(self.activityData.activityName)
  self.sub_title:SetLocalText(self.activityData.desc_info)
  CS.GameEntry.Setting:SetBool("OpenedAttackCity_" .. LuaEntry.Player.uid, true)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  if self.openLevel == nil then
    self:RefreshUI()
  end
  SFSNetwork.SendMessage(MsgDefines.GetCityWarRank, self.activityId, -1)
end

function SeasonAttackCityMain:Update1000MS()
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo ~= nil then
    local fightStartTime = cityWarInfo.fightStartTime
    local fightEndTime = cityWarInfo.fightEndTime
    if fightStartTime == nil then
      fightStartTime = 0
    end
    if fightEndTime == nil then
      fightEndTime = 0
    end
  end
  if not (self.activityData and self.remain_time:GetActive()) or self.openTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.openTime - curTime
  if 0 < remainTime then
    self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.remain_time:SetActive(false)
    self.time_title:SetActive(false)
    self.openTime = nil
    if self.sendMsgTime == nil or curTime > self.sendMsgTime + 5000 then
      self.sendMsgTime = curTime
      SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
    end
  end
end

function SeasonAttackCityMain:RefreshAttackUI(cityId, dataServer)
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

function SeasonAttackCityMain:ShowCityInfo(cityInfo)
  self.city_icon:LoadSprite(cityInfo:GetBigIconPath())
  self.city_icon:SetNativeSize()
  self.season:SetActive(true)
  self.season_title:SetText(string.format("<size=65>LV%s.</size>%s", cityInfo.level, Localization:GetString(cityInfo.name)))
  self.season_city_info:SetText(string.format([[
<color=#FFECD1>%s: </color>%s
<color=#FFECD1>%s: </color>%s]], Localization:GetString("season_influence"), string.GetFormattedSeparatorNum(cityInfo.force), Localization:GetString("803053"), string.GetFormattedSeparatorNum(cityInfo.city_resistance_b)))
  self.cityInfo = cityInfo
  if cityInfo.loot_rewards == nil or cityInfo.loot_rewards == 0 then
    self.season_reward_root:SetActive(false)
  else
    self.season_reward_root:SetActive(true)
    self.season_reward:SetText(Localization:GetString("season_world_city_reward_box"))
    self.season_reward_count:SetText("x" .. cityInfo.loot_rewards)
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

function SeasonAttackCityMain:RefreshUI()
  local openLevel = 6
  local openTime = 0
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo ~= nil and cityWarInfo.nextOpen ~= nil then
    openLevel = cityWarInfo.nextOpen.level or 6
    openTime = cityWarInfo.nextOpen.openTime or 0
    self.time_title:SetLocalText(456503, openLevel)
    self.remain_time:SetActive(true)
    self.time_title:SetActive(true)
    self.openTime = openTime
  else
    openLevel = 6
    self.time_title:SetLocalText(456515, openLevel)
    self.remain_time:SetActive(false)
    self.time_title:SetActive(true)
    self.openActivityTime:SetText("")
  end
  self.openLevel = openLevel
  self.detail_btn:SetActive(true)
  local DeclareWarDataList = DataCenter.AllianceDeclareWarManager:GetAllianceDeclareWarData()
  if DeclareWarDataList ~= nil then
    local allianceId = LuaEntry.Player:GetAllianceUid()
    for _, WarData in ipairs(DeclareWarDataList) do
      if WarData.aId == allianceId then
        local cityId = tonumber(WarData.content)
        local cityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
        self.bottom:SetActive(false)
        self.bottom_attack:SetActive(true)
        self:RefreshAttackUI(cityId, cityWarInfo.cityInfoList[cityId])
        self:ShowCityInfo(cityInfo)
        return
      end
    end
  end
  local cityInfo = DataCenter.AllianceCityTemplateManager:GetCityByLevel(openLevel)
  self:ShowCityInfo(cityInfo)
  local show_reward = DataCenter.AllianceCityTemplateManager:GetFirstRewardByLevel(openLevel or 6)
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
  self:RefreshActivityState()
  self.activityState = ActivityState.AfterBattle
  if self.activityState == ActivityState.AfterBattle then
    self.time_content:SetActive(false)
    self.allianceInfo:SetActive(false)
    self.allianceAddContent:SetActive(false)
  elseif self.activityState == ActivityState.BeforeBattle then
    self.time_content:SetActive(true)
    self.allianceInfo:SetActive(false)
    self.allianceAddContent:SetActive(false)
  else
    self.time_content:SetActive(true)
    self.allianceInfo:SetActive(true)
    self.allianceAddContent:SetActive(true)
  end
  self:RefreshRankView()
  self:Update1000MS()
end

function SeasonAttackCityMain:UpdateData()
  self:RefreshUI()
end

function SeasonAttackCityMain:OnHelpBtnClick()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local msg = Localization:GetString(self.activityData.story)
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end
end

function SeasonAttackCityMain:OnBtnDetailClick()
  if self.openLevel == 1 then
    UIUtil.ShowTipsId("456522")
  else
    SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
    SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
    if SeasonUtil.GetSeasonType() == SeasonMapType.CityStronghold then
      SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonAttackCityDetail)
  end
end

function SeasonAttackCityMain.ExistDeclareWar()
  if LuaEntry.Player:IsInAlliance() then
    local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
    if data ~= nil then
      return needShowRedPoint
    end
  end
  return false
end

function SeasonAttackCityMain:OnTargetBtnClick()
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo ~= nil then
    local fightStartTime = cityWarInfo.fightStartTime
    local fightEndTime = cityWarInfo.fightEndTime
    if fightStartTime == nil then
      fightStartTime = 0
    end
    if fightEndTime == nil then
      fightEndTime = 0
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = fightStartTime - curTime
    if 0 < deltaTime then
      UIUtil.ShowTipsId("456551")
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonAttackCityTargetInfo, {anim = true}, self.activityId)
    end
  end
end

function SeasonAttackCityMain:RefreshRankView()
  if self.activityState ~= ActivityState.InBattle then
    return
  end
  local allianceuid = LuaEntry.Player.allianceId
  if allianceuid == "" then
    self.allianceInfo:SetActive(false)
    self.allianceAddContent:SetActive(true)
    self.allianceAddTxt:SetLocalText(456550)
  else
    self.allianceInfo:SetActive(true)
    self.allianceAddContent:SetActive(false)
    local rankData = DataCenter.ActivityAttackCityDataManager:GetRankData(self.activityId)
    local rankList = {}
    if rankData ~= nil then
      rankList = rankData.data
    end
    local selfData
    for i = 1, #rankList do
      if rankList[i].aid == allianceuid then
        selfData = rankList[i]
        break
      end
    end
    if selfData == nil then
      local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      self.allianceName:SetText(Localization:GetString(456528) .. " 0")
      self.allianceNum:SetText(Localization:GetString(456549))
    else
      self.allianceName:SetText(Localization:GetString(456528) .. " " .. selfData.score)
      self.allianceNum:SetText(Localization:GetString(456529) .. " " .. selfData.rank)
    end
  end
end

function SeasonAttackCityMain:OnAddAllianceBtnClick()
  if LuaEntry.Player:IsInAlliance() == false then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      return
    end
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

function SeasonAttackCityMain:RefreshActivityState()
  self.activityState = self:GetActivityState()
end

function SeasonAttackCityMain:GetActivityState()
  local state = ActivityState.AfterBattle
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo ~= nil then
    local fightStartTime = cityWarInfo.fightStartTime
    local fightEndTime = cityWarInfo.fightEndTime
    if fightStartTime == nil then
      fightStartTime = 0
    end
    if fightEndTime == nil then
      fightEndTime = 0
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if fightStartTime > curTime then
      state = ActivityState.BeforeBattle
    elseif fightEndTime < curTime then
      state = ActivityState.AfterBattle
    else
      state = ActivityState.InBattle
    end
  end
  return state
end

return SeasonAttackCityMain
