local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local AttackCityS0Main = BaseClass("AttackCityS0Main", base)
local Localization = CS.GameEntry.Localization
local title_path = "root/RightView/Top/title"
local sub_title_path = "root/RightView/Top/subTitle"
local info_btn_path = "root/RightView/Top/InfoBtn"
local time_content_path = "root/RightView/Top/TimeBg"
local time_title_path = "root/RightView/Bottom/TimeBg/TimeTitle"
local remain_time_path = "root/RightView/Bottom/TimeBg/remainTime"
local remain_time_bg_path = "root/RightView/Bottom/TimeBg/imgTimeBg"
local image_city_path = "root/mask/ImageCity"
local image_king_icon_path = "root/mask/imgKingIcon"
local image_city_icon_path = "root/mask/imgCityIcon"
local gift_btn_path = "root/RightView/Top/GiftBtn"
local gift_text_path = "root/RightView/Top/GiftBtn/GiftIcon/GiftText"
local task_title_path = "root/RightView/Bottom/GameObject/TaskTitle"
local item_path = "root/RightView/Bottom/GameObject/Item"
local content_path = "root/RightView/Bottom/GameObject/ScrollView/Viewport/Content"
local building_path = "root/RightView/BottomAttack/GameObject/Build/building"
local bottom_path = "root/RightView/Bottom"
local bottom_attack_path = "root/RightView/BottomAttack"
local attack_title_path = "root/RightView/BottomAttack/AttackTitle"
local city_path = "root/RightView/BottomAttack/GameObject/Build/building/city"
local king_path = "root/RightView/BottomAttack/GameObject/Build/building/king"
local text_path = "root/RightView/BottomAttack/GameObject/Build/Pos/Text"
local attack_detail_path = "root/RightView/BottomAttack/GameObject/Info/AttackDetail"
local scroll_view_path = "root/RightView/BottomAttack/GameObject/Info/ScrollView"
local content_attack_path = "root/RightView/BottomAttack/GameObject/Info/ScrollView/Viewport/ContentAttack"
local btn_jump_path = "root/RightView/BottomAttack/BtnJump"
local pos_path = "root/RightView/BottomAttack/GameObject/Build/Pos"
local red_point_path = "root/RightView/Top/GiftBtn/RedPoint"
local btnGoal1_path = "root/RightView/Bottom/BtnGoal1"
local goal1Text_path = "root/RightView/Bottom/BtnGoal1/rect_text/Goal1Text"
local goal1Time_path = "root/RightView/Bottom/BtnGoal1/rect_text/Goal1Time"
local btnGoal2_path = "root/RightView/BottomAttack/BtnGoal2"
local goal2Text_path = "root/RightView/BottomAttack/BtnGoal2/rect_text/Goal2Text"
local goal2Time_path = "root/RightView/BottomAttack/BtnGoal2/rect_text/Goal2Time"
local nextTime_path = "root/RightView/Top/TimeBg/nextTime"
local openTime_path = "root/RightView/Top/TimeBg/openTime"
local allianceInfo_path = "root/RightView/Top/allianceInfo"
local allianceName_path = "root/RightView/Top/allianceInfo/allianceName"
local allianceNum_path = "root/RightView/Top/allianceInfo/allianceNum"
local allianceAddContent_path = "root/RightView/Top/allianceAddContent"
local allianceAddTxt_path = "root/RightView/Top/allianceAddContent/allianceAddTxt"
local addAllianceBtn_path = "root/RightView/Top/allianceAddContent/allianceAddTxt/addAllianceBtn"
local desc_btn_path = "root/RightView/Top/DescBtn"
local desc_text_path = "root/RightView/Top/DescBtn/DescIcon/DescText"
local btn_gift_path = "root/RightView/bottomBtns/btnGift"
local btn_view_path = "root/RightView/bottomBtns/btnView"
local btn_personal_path = "root/RightView/bottomBtns/btnPersonal"
local btn_alliance_goal_path = "root/RightView/bottomBtns/btnAlliance"
local needShowRedPoint = true
local ActivityState = {
  BeforeBattle = 1,
  InBattle = 2,
  AfterBattle = 3
}
local FixedTimeDays = 17

function AttackCityS0Main:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function AttackCityS0Main:OnDestroy()
  DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.CityWar, false)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AttackCityS0Main:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.sub_title = self:AddComponent(UIText, sub_title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.time_content = self:AddComponent(UIBaseContainer, time_content_path)
  self.time_title = self:AddComponent(UIText, time_title_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.remain_time_bg = self:AddComponent(UIImage, remain_time_bg_path)
  self.imageKingIcon = self:AddComponent(UIImage, image_king_icon_path)
  self.imageCityIcon = self:AddComponent(UIImage, image_city_icon_path)
  self.image_city = self:AddComponent(UIImage, image_city_path)
  self.detail_btn = self:AddComponent(UIButton, gift_btn_path)
  self.detail_text = self:AddComponent(UIText, gift_text_path)
  self.task_title = self:AddComponent(UIText, task_title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.desc_btn = self:AddComponent(UIButton, desc_btn_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self.desc_btn:SetOnClick(function()
    self:OnDescBtnClick()
  end)
  self.desc_text:SetLocalText("city_war_main_UI_06")
  self.detail_text:SetLocalText("456505")
  self.task_title:SetLocalText("456504")
  self.imageKingIcon:SetActive(false)
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
  self.city = self:AddComponent(UIBaseContainer, city_path)
  self.king = self:AddComponent(UIBaseContainer, king_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.attack_detail = self:AddComponent(UIText, attack_detail_path)
  self.scroll_view = self:AddComponent(UIImage, scroll_view_path)
  self.content_attack = self:AddComponent(UIBaseContainer, content_attack_path)
  self.building = self:AddComponent(UIButton, building_path)
  self.btn_jump = self:AddComponent(UIButton, btn_jump_path)
  self.pos = self:AddComponent(UIButton, pos_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.btn_jump:SetOnClick(function()
    self:JumpTo()
  end)
  self.building:SetOnClick(function()
    self:JumpTo()
  end)
  self.pos:SetOnClick(function()
    self:JumpTo()
  end)
  self.red_point:SetActive(needShowRedPoint and AttackCityS0Main.ExistDeclareWar())
  self.btnGoal1 = self:AddComponent(UIButton, btnGoal1_path)
  self.goal1Text = self:AddComponent(UIText, goal1Text_path)
  self.goal1Time = self:AddComponent(UIText, goal1Time_path)
  self.btnGoal2 = self:AddComponent(UIButton, btnGoal2_path)
  self.goal2Text = self:AddComponent(UIText, goal2Text_path)
  self.goal2Time = self:AddComponent(UIText, goal2Time_path)
  self.goal1Text:SetLocalText(456517)
  self.goal2Text:SetLocalText(456517)
  self.btnGoal1:SetOnClick(function()
    self:OnTargetBtnClick()
  end)
  self.btnGoal2:SetOnClick(function()
    self:OnTargetBtnClick()
  end)
  self.openActivityTime = self:AddComponent(UIText, openTime_path)
  self.nextTime = self:AddComponent(UITextMeshProUGUIEx, nextTime_path)
  self.allianceInfo = self:AddComponent(UIBaseContainer, allianceInfo_path)
  self.allianceName = self:AddComponent(UIText, allianceName_path)
  self.allianceNum = self:AddComponent(UIText, allianceNum_path)
  self.allianceAddContent = self:AddComponent(UIBaseContainer, allianceAddContent_path)
  self.allianceAddTxt = self:AddComponent(UIText, allianceAddTxt_path)
  self.addAllianceBtn = self:AddComponent(UIButton, addAllianceBtn_path)
  self.addAllianceBtn:SetOnClick(function()
    self:OnAddAllianceBtnClick()
  end)
  self.btnGift = self:AddComponent(UIButton, btn_gift_path)
  self.btnGift:SetOnClick(function()
    self:OnBtnGiftClick()
  end)
  self.btnView = self:AddComponent(UIButton, btn_view_path)
  self.btnView:SetOnClick(function()
    self:OnBtnViewClick()
  end)
  self.btnPersonal = self:AddComponent(UIButton, btn_personal_path)
  self.btnPersonal:SetOnClick(function()
    self:OnBtnPersonalClick()
  end)
  self.btnAllianceGoal = self:AddComponent(UIButton, btn_alliance_goal_path)
  self.btnAllianceGoal:SetOnClick(function()
    self:OnBtnAllianceGoalClick()
  end)
  self.allianceInfo:SetActive(false)
  self.allianceAddContent:SetActive(false)
  self.areTimesActive = true
  self:RefreshActivityState()
  self.btnGoal1:SetActive(false)
  self.btnGoal2:SetActive(false)
end

function AttackCityS0Main:JumpTo()
  if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
    local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetCurServerId())
  end
end

function AttackCityS0Main:ComponentDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.content_attack:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.title = nil
  self.sub_title = nil
  self.info_btn = nil
  self.nextTime = nil
  self.time_content = nil
  self.time_title = nil
  self.remain_time = nil
  self.image_king = nil
  self.image_city = nil
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
  self.desc_btn = nil
  self.desc_text = nil
  self.areTimesActive = nil
  self.remain_time_bg = nil
  self.imageCityIcon = nil
  self.imageKingIcon = nil
  self.btnView = nil
  self.btnPersonal = nil
  self.btnGift = nil
  self.btnAllianceGoal = nil
end

function AttackCityS0Main:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  self:AddUIListener(EventId.GetActivityDetail, self.UpdateData)
  self:AddUIListener(EventId.ActivityAttackCityRankDataUpdate, self.RefreshRankView)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.RefreshRankView)
  self:AddUIListener(EventId.GetAllDetectInfo, self.OpenRadar)
end

function AttackCityS0Main:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  self:RemoveUIListener(EventId.GetActivityDetail, self.UpdateData)
  self:RemoveUIListener(EventId.ActivityAttackCityRankDataUpdate, self.RefreshRankView)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.RefreshRankView)
  self:RemoveUIListener(EventId.GetAllDetectInfo, self.OpenRadar)
  base.OnRemoveListener(self)
end

function AttackCityS0Main:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityDataOld = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.AttackCityActivity.Type)
  if not self.activityDataOld then
    return
  end
  self.activityIdOld = self.activityDataOld.activityId
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.title:SetLocalText(self.activityData.activityName)
  self.sub_title:SetLocalText(self.activityData.desc_info)
  CS.GameEntry.Setting:SetBool("OpenedAttackCity_" .. LuaEntry.Player.uid, true)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  self:RefreshUI()
  DataCenter.LWGuideFlowManager:TryTriggerFlexibly(7002)
  SFSNetwork.SendMessage(MsgDefines.GetCityWarRank, self.activityIdOld, -1)
end

function AttackCityS0Main:Update1000MS()
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
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.goal1Time:SetText(showTime)
      self.goal2Time:SetText(showTime)
      if not self.areTimesActive then
        self.goal1Time:SetActive(true)
        self.goal2Time:SetActive(true)
        self.areTimesActive = true
      end
    else
      self.goal1Time:SetText("")
      self.goal2Time:SetText("")
      if self.areTimesActive then
        self.goal1Time:SetActive(false)
        self.goal2Time:SetActive(false)
        self.areTimesActive = false
      end
    end
  else
    self.goal1Time:SetText("")
    self.goal2Time:SetText("")
    if self.areTimesActive then
      self.goal1Time:SetActive(false)
      self.goal2Time:SetActive(false)
      self.areTimesActive = false
    end
  end
  if not (self.activityDataOld and self.remain_time:GetActive()) or self.openTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.openTime - curTime
  if 0 < remainTime then
    self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.remain_time:SetActive(false)
    self.remain_time_bg:SetActive(false)
    self.time_title:SetActive(false)
    self.openTime = nil
    if self.sendMsgTime == nil or curTime > self.sendMsgTime + 5000 then
      self.sendMsgTime = curTime
      SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
    end
  end
  local fightEndTime = cityWarInfo.fightEndTime
  if fightEndTime == nil then
    fightEndTime = 0
  end
  local curDays = UITimeManager:GetInstance():GetServerOpenDays()
  local diff = FixedTimeDays - curDays
  if self.activityState == ActivityState.AfterBattle and fightEndTime ~= 0 then
    if 1 <= diff then
      local sec = UITimeManager:GetInstance():GetResSecondsTo24(fightEndTime) + (diff - 1) * 86400
      self.nextTime:SetLocalText("city_war_main_UI_16", UITimeManager:GetInstance():MilliSecondToFmtString(sec * 1000))
    end
  elseif diff <= 1 then
    self.nextTime.gameObject:SetActive(true)
    local sec = UITimeManager:GetInstance():GetResSecondsTo24(fightEndTime) + (diff - 1) * 86400
    if 0 < sec then
      self.nextTime:SetLocalText("city_war_main_UI_16", UITimeManager:GetInstance():MilliSecondToFmtString(sec * 1000))
    else
      self.nextTime.gameObject:SetActive(false)
    end
  end
  if cityWarInfo ~= nil then
    local curState = self:GetActivityState()
    if self.activityState ~= curState then
      self:RefreshUI()
    end
  end
end

function AttackCityS0Main:RefreshAttackUI(cityId, dataServer)
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
  else
    local txt1 = "<color=#f97077>[" .. dataServer.alAbbr .. "]" .. dataServer.alName .. "</color>"
    local txt2 = "<color=\"white\">" .. Localization:GetString("456518") .. "</color>"
    self.scroll_view:SetActive(false)
    self.attack_detail:SetText(txt1 .. txt2)
  end
  if dataConfig ~= nil and dataConfig.pos ~= nil then
    self.text:SetText("<u>(" .. dataConfig.pos.x .. "," .. dataConfig.pos.y .. ")</u>")
  else
    self.text:SetText("")
  end
  self.dataConfig = dataConfig
  self.dataServer = dataServer
  self.cityPos = dataConfig.pos
end

function AttackCityS0Main:RefreshUI()
  local openLevel = 7
  local openTime = 0
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  self.nextTime.gameObject:SetActive(false)
  if cityWarInfo ~= nil and cityWarInfo.nextOpen ~= nil then
    openLevel = cityWarInfo.nextOpen.level or 7
    openTime = cityWarInfo.nextOpen.openTime or 0
    self.time_title:SetLocalText("city_war_main_UI_10", openLevel)
    self.remain_time:SetActive(true)
    self.remain_time_bg:SetActive(true)
    self.time_title:SetActive(true)
    self.openTime = openTime
    local fightStartTime = cityWarInfo.fightStartTime
    local fightEndTime = cityWarInfo.fightEndTime
    if fightStartTime == nil then
      fightStartTime = 0
    end
    if fightEndTime == nil then
      fightEndTime = 0
    end
    local startStr = UITimeManager:GetInstance():TimeStampToDayForLocal(fightStartTime)
    local endStr = UITimeManager:GetInstance():TimeStampToDayForLocal(fightEndTime)
    self.openActivityTime:SetText(Localization:GetString("city_war_main_UI_07") .. startStr .. " - " .. endStr)
    if self.activityState == ActivityState.AfterBattle and fightEndTime ~= 0 then
      self.nextTime.gameObject:SetActive(true)
    end
  else
    openLevel = 7
    self.time_title:SetLocalText(456515, openLevel)
    self.remain_time:SetActive(false)
    self.remain_time_bg:SetActive(false)
    self.time_title:SetActive(true)
    self.openActivityTime:SetText("")
  end
  self.openLevel = openLevel
  self.detail_btn:SetActive(true)
  self.imageKingIcon:SetActive(7 <= openLevel)
  self.imageCityIcon:SetActive(openLevel < 7)
  local DeclareWarDataList = DataCenter.AllianceDeclareWarManager:GetAllianceDeclareWarData()
  if DeclareWarDataList ~= nil then
    local allianceId = LuaEntry.Player:GetAllianceUid()
    for _, WarData in ipairs(DeclareWarDataList) do
      if WarData.aId == allianceId then
        local cityId = tonumber(WarData.content)
        self.bottom:SetActive(false)
        self.bottom_attack:SetActive(true)
        self:RefreshAttackUI(cityId, cityWarInfo.cityInfoList[cityId])
        return
      end
    end
  end
  local show_reward = DataCenter.AllianceCityTemplateManager:GetFirstRewardByLevel(openLevel or 7)
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
  if self.activityState == ActivityState.AfterBattle then
    self.openActivityTime:SetActive(false)
    self.allianceInfo:SetActive(false)
    self.allianceAddContent:SetActive(false)
  elseif self.activityState == ActivityState.BeforeBattle then
    self.openActivityTime:SetActive(true)
    self.allianceInfo:SetActive(false)
    self.allianceAddContent:SetActive(false)
  else
    self.openActivityTime:SetActive(true)
    self.allianceInfo:SetActive(true)
    self.allianceAddContent:SetActive(true)
  end
  self:RefreshRankView()
  self:Update1000MS()
end

function AttackCityS0Main:UpdateData()
  self:RefreshUI()
end

function AttackCityS0Main:OnDescBtnClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("city_war_tips_02")
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAttackCityS0BattleResultPopView, {anim = true})
  end
end

function AttackCityS0Main:OnHelpBtnClick()
  if not self.activityData then
    return
  end
  local param = {}
  param.howToPlayList = self.activityData.howtoplay
  param.defaultTitle = self.activityData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function AttackCityS0Main:OnBtnDetailClick()
  if self.openLevel == 1 then
    UIUtil.ShowTipsId("456522")
  else
    SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityAttackCityDetail)
  end
end

function AttackCityS0Main.ExistDeclareWar()
  if LuaEntry.Player:IsInAlliance() then
    local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
    if data ~= nil then
      return needShowRedPoint
    end
  end
  return false
end

function AttackCityS0Main.IsInBattleTime()
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
    if fightStartTime < curTime and fightEndTime > curTime then
      return true
    end
  end
  return false
end

function AttackCityS0Main:OnTargetBtnClick()
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if self.activityState == ActivityState.AfterBattle then
    if cityWarInfo ~= nil and cityWarInfo.nextOpen ~= nil then
      if cityWarInfo.nextOpen.level < 3 then
        UIUtil.ShowTipsId("city_war_tips_14")
      else
        UIUtil.ShowTipsId("city_war_tips_13")
      end
    else
      UIUtil.ShowTipsId("city_war_tips_11")
    end
    return
  end
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
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityAttackCityTargetInfo, cityWarInfo.activityId)
    end
  end
end

function AttackCityS0Main.GetEventCanRewardCount()
  local need_red_point = true
  need_red_point = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.CityWar)
  need_red_point = need_red_point or not CS.GameEntry.Setting:GetBool("OpenedAttackCity_" .. LuaEntry.Player.uid, false)
  local isInTime = AttackCityS0Main.IsInBattleTime()
  if isInTime and need_red_point then
    return 1
  end
  return 0
end

function AttackCityS0Main:RefreshRankView()
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
    local rankData = DataCenter.ActivityAttackCityDataManager:GetRankData(self.activityIdOld)
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
      self.allianceName:SetText(Localization:GetString(456528) .. " 0")
      self.allianceNum:SetText(Localization:GetString(456549))
    else
      self.allianceName:SetText(Localization:GetString(456528) .. " " .. selfData.score)
      self.allianceNum:SetText(Localization:GetString(456529) .. " " .. selfData.rank)
    end
  end
end

function AttackCityS0Main:OnAddAllianceBtnClick()
  if LuaEntry.Player:IsInAlliance() == false then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      return
    end
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

function AttackCityS0Main:RefreshActivityState()
  self.activityState = self:GetActivityState()
end

function AttackCityS0Main:GetActivityState()
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

function AttackCityS0Main:OnBtnGiftClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAttackCityS0RewardPopView, {anim = true})
end

function AttackCityS0Main:OpenRadar()
  if not DataCenter.AttackCityS0DataManager:GetCityClueAndRadarOpenState() then
    local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
    if cityWarInfo ~= nil and cityWarInfo.nextOpen == nil then
      UIUtil.ShowTipsId("city_war_tips_16")
    else
      UIUtil.ShowTipsId("city_war_tips_01")
    end
    return
  end
  local cityRadar = DataCenter.AttackCityS0DataManager:GetDetectEventInfoByType(DetectEventType.AttackCityS0_City_Scout)
  if not table.IsNullOrEmpty(cityRadar) and cityRadar[1] then
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, cityRadar[1].uuid, true)
  else
    local monsterRadar = DataCenter.AttackCityS0DataManager:GetDetectEventInfoByType(DetectEventType.AttackCityS0_City_Monster)
    if not table.IsNullOrEmpty(monsterRadar) then
      GoToUtil.CloseAllWindows()
      if monsterRadar[1] and monsterRadar[1].cityId then
        local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(tonumber(monsterRadar[1].cityId))
        if cityMeta and cityMeta.pos then
          local worldPos = SceneUtils.TileToWorld(cityMeta.pos)
          GoToUtil.GotoWorldPos(worldPos)
        end
      end
    else
      UIUtil.ShowTipsId("city_war_tips_04")
    end
  end
end

function AttackCityS0Main:OnBtnViewClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("city_war_tips_02")
  else
    DataCenter.RadarCenterDataManager:GetDetectEventData(true)
  end
end

function AttackCityS0Main:OnBtnPersonalClick()
  self.view:ChangeShowType(2)
end

function AttackCityS0Main:OnBtnAllianceGoalClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("city_war_tips_02")
  else
    self:OnTargetBtnClick()
  end
end

return AttackCityS0Main
