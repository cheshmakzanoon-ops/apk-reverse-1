local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActMonsterInvasion = BaseClass("ActMonsterInvasion", base)
local Localization = CS.GameEntry.Localization
local MonsterInvasionFindItem = require("UI.UIActivityCenterTable.Component.ActMonsterInvasion.MonsterInvasionFindItem")
local InvasionSummonProgressItem = require("UI.UIInvasionSummonProgress.Component.InvasionSummonProgressItem")
local BuffActInfoComp = require("UI.UILWRadarCenter.UIDetectEvent.Component.BuffActInfoComp")
local LWUIActivityRewardChangePreviewEntranceComponent = require("UI/LWUIActivityRewardChangePreview/AccuRecharge/Component/LWUIActivityRewardChangePreviewEntranceComponent")
local CalendarAddBtnContent = require("UI.LWUIActivityAlarmClock.Component.CalendarAddBtnContent")
local bannerRawImage_path = "rect_mask/bannerRawImage"
local txt_act_name_path = "rect/ActivityTopGo/Txt_ActName"
local txt_desc_path = "rect/ActivityTopGo/Txt_Desc"
local timeContent_path = "rect/ActivityTopGo/Time/TimeContent"
local txt_times_path = "rect/ActivityTopGo/Time/TimeContent/Txt_Times"
local txt_pre_path = "rect/ActivityTopGo/txt_Pre"
local intro_btn_path = "rect/BtnList/IntroBtn"
local btn_shop_path = "rect/BtnList/BtnShop"
local btn_rank_path = "rect/BtnList/BtnRank"
local btn_reward_path = "rect/BtnList/BtnReward"
local btn_record_path = "rect/BtnRecord"
local btn_record_old_path = "rect/BtnList/BtnRecordOld"
local btn_reward_change_path = "rect/BtnList/BtnRewardChange"
local contentPre_path = "rect/contentPre"
local rewardContent_path = "rect/contentPre/rewardScrollView/Viewport/rewardContent"
local rewardItem_path = "rect/contentPre/rewardItem"
local content_path = "rect/content"
local toggle1_path = "rect/content/selectContent/selectBg/Toggle1"
local unselectTextToggle1_path = "rect/content/selectContent/selectBg/Toggle1/unselectTextToggle1"
local selectToggle1_path = "rect/content/selectContent/selectBg/Toggle1/selectToggle1"
local selectTextToggle1_path = "rect/content/selectContent/selectBg/Toggle1/selectToggle1/selectTextToggle1"
local toggle2_path = "rect/content/selectContent/selectBg/Toggle2"
local unselectTextToggle2_path = "rect/content/selectContent/selectBg/Toggle2/unselectTextToggle2"
local selectToggle2_path = "rect/content/selectContent/selectBg/Toggle2/selectToggle2"
local selectTextToggle2_path = "rect/content/selectContent/selectBg/Toggle2/selectToggle2/selectTextToggle2"
local monsterContent_path = "rect/content/monsterScrollView/Viewport/monsterContent"
local monsterItem_path = "rect/content/monsterItem"
local joinBtn_path = "rect/content/JoinBtn"
local emptyTip_path = "rect/content/emptyTip"
local monsterRefreshTime_path = "rect/monsterRefreshTime"
local btn_go_path = "rect/BtnGo"
local invasion_progress_group_path = "rect/InvasionProgressGroup"
local effect_root_path = "rect_mask/bannerRawImage/EffectRoot"
local search_boss_btn_path = "rect/SearchBossBtn"
local comp_buff_path = "rect/ActivityTopGo/buffContent"
local mask_btn_path = "rect/btnMask"
local calendar_add_btn_content_path = "rect/InvasionProgressGroup/CountDownArea/countDownText/CalendarAddBtnContent"
local red_point_shop_Path = "rect/BtnList/BtnShop/RedPoint"
local sendMsgTimeInterval = 3000
local actStageType = {
  NoData = -1,
  Preview = 0,
  Start = 1
}

function ActMonsterInvasion:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.sendMsgTime = 0
  self.nextRefreshTime = 0
  self.monsterFindType = MonsterInvasionFindSelectType.Alliance
  self.dataNeedRefresh = true
  self.isInit = nil
  self.maxEffectNum = 0
  self.displayItems = nil
  self.timer = nil
  self.refreshTimer = nil
  self.bgResourcePath = {}
  self:RefreshShopRed()
end

function ActMonsterInvasion:OnEnable()
  base.OnEnable(self)
end

function ActMonsterInvasion:OnDisable()
  base.OnDisable(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.refreshTimer then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
  self:CloseUICacheData()
end

function ActMonsterInvasion:OnDestroy()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardItem:GameObjectRecycleAll()
  self.monsterContent:RemoveComponents(MonsterInvasionFindItem)
  self.monsterItem:GameObjectRecycleAll()
  self.isInit = nil
  self.maxEffectNum = nil
  self.displayItems = nil
  self.bgResourcePath = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActMonsterInvasion:ComponentDefine()
  self.bannerRawImage = self:AddComponent(UIRawImage, bannerRawImage_path)
  self.txt_act_name = self:AddComponent(UIText, txt_act_name_path)
  self.txt_desc = self:AddComponent(UIText, txt_desc_path)
  self.timeContent = self:AddComponent(UIBaseContainer, timeContent_path)
  self.txt_times = self:AddComponent(UIText, txt_times_path)
  self.txt_pre = self:AddComponent(UIText, txt_pre_path)
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTip()
  end)
  self.btn_shop = self:AddComponent(UIButton, btn_shop_path)
  self.btn_shop:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickShop()
  end)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.btn_reward:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRewardBtn()
  end)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_rank:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRankBtn()
  end)
  self.btn_record = self:AddComponent(UIButton, btn_record_path)
  self.btn_record:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRecordBtn()
  end)
  self.btn_record_old = self:AddComponent(UIButton, btn_record_old_path)
  self.btn_record_old:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRecordBtn()
  end)
  self.contentPre = self:AddComponent(UIBaseContainer, contentPre_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.rewardItem = self.transform:Find(rewardItem_path).gameObject
  self.rewardItem:GameObjectCreatePool()
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.toggle1 = self:AddComponent(UIButton, toggle1_path)
  self.toggle1:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ToggleSelect(MonsterInvasionFindSelectType.Alliance)
  end)
  self.selectToggle1 = self:AddComponent(UIBaseContainer, selectToggle1_path)
  self.toggle2 = self:AddComponent(UIButton, toggle2_path)
  self.toggle2:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ToggleSelect(MonsterInvasionFindSelectType.Self)
  end)
  self.joinBtn = self:AddComponent(UIButton, joinBtn_path)
  self.joinBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:JoinAlliance()
  end)
  self.selectToggle2 = self:AddComponent(UIBaseContainer, selectToggle2_path)
  self.monsterContent = self:AddComponent(UIBaseContainer, monsterContent_path)
  self.monsterItem = self.transform:Find(monsterItem_path).gameObject
  self.monsterItem:GameObjectCreatePool()
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickGoBtn()
  end)
  self.emptyTip = self:AddComponent(UIText, emptyTip_path)
  self.monsterRefreshTime = self:AddComponent(UIText, monsterRefreshTime_path)
  self.invasion_progress_group = self:AddComponent(InvasionSummonProgressItem, invasion_progress_group_path)
  self.effect_root = self:AddComponent(UIBaseContainer, effect_root_path)
  self.search_boss_btn = self:AddComponent(UIButton, search_boss_btn_path)
  self.search_boss_btn:SetOnClick(BindCallback(self, self.OnSearchBossBtnClick))
  self.buffActInfoComp = self:AddComponent(BuffActInfoComp, comp_buff_path)
  self.btnMask = self:AddComponent(UIButton, mask_btn_path)
  self.btnMask:SetOnClick(function()
    self.buffActInfoComp:HideBuffDetail()
  end)
  self.comp_reward_change_entrance = self:AddComponent(LWUIActivityRewardChangePreviewEntranceComponent, btn_reward_change_path)
  self.calendar_add_btn_content = self:AddComponent(CalendarAddBtnContent, calendar_add_btn_content_path)
  self.objRedPointShop = self:AddComponent(UIBaseContainer, red_point_shop_Path)
  self.objRedPointShop:SetActive(false)
end

function ActMonsterInvasion:ComponentDestroy()
  self.bannerRawImage = nil
  self.txt_act_name = nil
  self.txt_desc = nil
  self.timeContent = nil
  self.txt_times = nil
  self.txt_pre = nil
  self.intro_btn = nil
  self.btn_shop = nil
  self.btn_rank = nil
  self.btn_record = nil
  self.btn_record_old = nil
  self.btn_reward = nil
  self.contentPre = nil
  self.rewardContent = nil
  self.rewardItem = nil
  self.content = nil
  self.toggle1 = nil
  self.selectToggle1 = nil
  self.toggle2 = nil
  self.selectToggle2 = nil
  self.joinBtn = nil
  self.emptyTip = nil
  self.monsterRefreshTime = nil
  self.monsterContent = nil
  self.monsterItem = nil
  self.btn_go = nil
  self.search_boss_btn = nil
  self:CloseUICacheData()
  self.invasion_progress_group = nil
  self.effect_root = nil
  self.calendar_add_btn_content = nil
  self.objRedPointShop = nil
end

function ActMonsterInvasion:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MonsterInvasionGetPoint, self.GetPosMsg)
  self:AddUIListener(EventId.MonsterInvasionGetData, self.GetDataMsg)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.AllianceDataChange)
  self:AddUIListener(EventId.MonsterInvasionShopDataUpdate, self.RefreshShopRed)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshShopRed)
end

function ActMonsterInvasion:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MonsterInvasionGetPoint, self.GetPosMsg)
  self:RemoveUIListener(EventId.MonsterInvasionGetData, self.GetDataMsg)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.AllianceDataChange)
  self:RemoveUIListener(EventId.MonsterInvasionShopDataUpdate, self.RefreshShopRed)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshShopRed)
end

function ActMonsterInvasion:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self:InitRecordBtnState()
  self.bgResourcePath = DataCenter.ActivityMonsterInvasionDataManager:GetMonstorRatityBgList(self.activityId)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.monsterFindType = MonsterInvasionFindSelectType.Alliance
  if not string.IsNullOrEmpty(self.activityInfo.activity_pic) then
    local picPath = "Assets/Main/TextureEx/MonsterInvasion/" .. self.activityInfo.activity_pic
    self.bannerRawImage:LoadSprite(picPath)
  end
  self:RefreshData()
  self:RefreshView()
  self:SendGetDataMsg()
  self:RecordOpenTime()
  self.comp_reward_change_entrance:ReInit(self.activityInfo, nil, true)
  self.buffActInfoComp:ReInit(EnumActivity.MonsterInvasionS4Buff.Type)
  local _, summon_score = DataCenter.ActivityMonsterInvasionDataManager:GetInvasionSummonProgress()
  self.effect_root:SetActive(0 < summon_score)
  self.isInit = true
end

function ActMonsterInvasion:InitRecordBtnState()
  local configOpenState = LuaEntry.DataConfig:CheckSwitch("new_monster_invasion")
  if configOpenState then
    self.btn_record:SetActive(true)
    self.btn_record_old:SetActive(false)
    self.btn_reward:SetActive(true)
  else
    self.btn_record:SetActive(false)
    self.btn_record_old:SetActive(true)
    self.btn_reward:SetActive(false)
  end
end

function ActMonsterInvasion:SendGetDataMsg()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.sendMsgTime = curTime
  SFSNetwork.SendMessage(MsgDefines.MonsterInvasionActInfo, self.activityId)
  self.dataNeedRefres = false
end

function ActMonsterInvasion:CheckCanSendGetDataMsg()
  local canSend = true
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.sendMsgTime == nil then
    self.sendMsgTime = 0
  end
  canSend = curTime > self.sendMsgTime + sendMsgTimeInterval
  return canSend
end

function ActMonsterInvasion:TrySendGetDataMsg()
  local canSend = self:CheckCanSendGetDataMsg()
  if canSend then
    self:SendGetDataMsg()
  end
  return canSend
end

function ActMonsterInvasion:RefreshData()
  self.sendMsgTime = 0
  self.nextRefreshTime = 0
  self.actStage = actStageType.NoData
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.nextRefreshTime = curTime + 86400000
  self.sendMsgTime = curTime
  self.activityDetailData = DataCenter.ActivityMonsterInvasionDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.actStage = self.activityDetailData.stage
  if self.activityDetailData.stage == actStageType.Preview then
    if self.activityDetailData.fightTime < self.nextRefreshTime then
      self.nextRefreshTime = self.activityDetailData.fightTime
    end
  elseif self.activityDetailData.stage == actStageType.Start then
    local monsterData = self.activityDetailData.aliMonsters
    for k, v in pairs(monsterData) do
      local endTime = v.refreshTime
      if endTime < self.nextRefreshTime then
        self.nextRefreshTime = endTime
      end
    end
    local monsterData = self.activityDetailData.selfMonsters
    for k, v in pairs(monsterData) do
      local endTime = v.refreshTime
      if endTime < self.nextRefreshTime then
        self.nextRefreshTime = endTime
      end
    end
    local monsterRefreshTime = self.activityDetailData.refreshTime
    if monsterRefreshTime < self.nextRefreshTime then
      self.nextRefreshTime = monsterRefreshTime
    end
  end
end

function ActMonsterInvasion:RefreshView()
  self.txt_act_name:SetLocalText(self.activityInfo.bannerTittle)
  self.txt_desc:SetLocalText(self.activityInfo.desc_info)
  self:Update1000MS()
  self:ShowCalendatBtnContent()
  if self.actStage == actStageType.NoData then
    self:RefreshNoDataView()
  elseif self.actStage == actStageType.Preview then
    self:RefreshPreviewView()
  elseif self.actStage == actStageType.Start then
    self:RefreshStartView()
  end
end

function ActMonsterInvasion:ShowCalendatBtnContent()
  self.calendar_add_btn_content:SetActive(false)
  if self.activityInfo == nil then
    return
  end
  local _, targetVal = DataCenter.ActivityMonsterInvasionDataManager:GetInvasionSummonProgress()
  if targetVal and 0 < targetVal then
    local startTime = 0
    local endTime = 0
    local planTime = DataCenter.ActivityMonsterInvasionDataManager:GetBossPlanTimeFromServer()
    startTime = toInt(planTime / 1000)
    endTime = toInt(planTime / 1000)
    self.calendar_add_btn_content:SetActive(true)
    self.calendar_add_btn_content:SetDataWithDefautValue(9, startTime, endTime, CalendarSourcePath.Activity)
  end
end

function ActMonsterInvasion:RefreshNoDataView()
  self.txt_desc:SetActive(false)
  self.timeContent:SetActive(false)
  self.txt_pre:SetActive(false)
  self.btn_rank:SetActive(false)
  self.contentPre:SetActive(false)
  self.content:SetActive(false)
  self.btn_go:SetActive(false)
  self.search_boss_btn:SetActive(false)
  self.monsterRefreshTime:SetActive(false)
end

function ActMonsterInvasion:RefreshPreviewView()
  self.txt_desc:SetActive(false)
  self.timeContent:SetActive(true)
  self.txt_pre:SetActive(true)
  self.btn_rank:SetActive(false)
  self.contentPre:SetActive(true)
  self.content:SetActive(false)
  self.btn_go:SetActive(false)
  self.search_boss_btn:SetActive(false)
  self.monsterRefreshTime:SetActive(false)
  local show_reward = self.activityDetailData.reward
  show_reward = DataCenter.RewardManager:ReturnRewardParamForView(show_reward)
  if show_reward ~= nil then
    local goItem, theItem
    self.rewardContent:RemoveComponents(UICommonResItem)
    self.rewardItem:GameObjectRecycleAll()
    for i, item in ipairs(show_reward) do
      local levelName = "item_" .. i
      goItem = self.rewardItem:GameObjectSpawn(self.rewardContent.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      theItem = self.rewardContent:AddComponent(UICommonResItem, levelName)
      theItem:ReInit(item)
    end
  end
end

function ActMonsterInvasion:RefreshStartView()
  self.txt_desc:SetActive(true)
  self.timeContent:SetActive(true)
  self.txt_pre:SetActive(false)
  self.btn_rank:SetActive(true)
  self.contentPre:SetActive(false)
  self.content:SetActive(true)
  self.btn_go:SetActive(true)
  self.search_boss_btn:SetActive(true)
  self.monsterRefreshTime:SetActive(true)
  self:RefreshStartViewMonsterContent()
  self:DisplayEffect()
end

function ActMonsterInvasion:RefreshStartViewMonsterContent()
  self.selectToggle1:SetActive(self.monsterFindType == MonsterInvasionFindSelectType.Alliance)
  self.selectToggle2:SetActive(self.monsterFindType == MonsterInvasionFindSelectType.Self)
  local showData = {}
  if self.monsterFindType == MonsterInvasionFindSelectType.Alliance then
    if self.activityDetailData.aliMonsters ~= nil then
      if self.isInit then
        self.isInit = self:InitInvasionProgressGroup()
        if self.isInit then
          local killedMonsters = self.activityDetailData:GetKilledMonsters()
          if not table.IsNullOrEmpty(killedMonsters) then
            table.insertto(killedMonsters, self.activityDetailData.aliMonsters)
            showData = killedMonsters
          else
            showData = self.activityDetailData.aliMonsters
          end
        else
          showData = self.activityDetailData.aliMonsters
        end
      else
        showData = self.activityDetailData.aliMonsters
      end
    end
  elseif self.monsterFindType == MonsterInvasionFindSelectType.Self and self.activityDetailData.selfMonsters ~= nil then
    showData = self.activityDetailData.selfMonsters
  end
  local goItem, theItem
  self.monsterContent:RemoveComponents(MonsterInvasionFindItem)
  self.monsterItem:GameObjectRecycleAll()
  self.displayItems = {}
  table.sort(showData, function(a, b)
    return a.createTime < b.createTime
  end)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local isPlanFuncOpen = DataCenter.ActivityMonsterInvasionDataManager:GetPlanTimeFuncOpen()
  local showEmptyTip = true
  for i, item in ipairs(showData) do
    local leftTime = item.refreshTime - curTime
    local isBossPrepare = item.invasionBossInfo and curTime < item.invasionBossInfo.battleStartTime
    if not (leftTime <= 0) and (not isPlanFuncOpen or not isBossPrepare) then
      local levelName = "item_" .. i
      goItem = self.monsterItem:GameObjectSpawn(self.monsterContent.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      theItem = self.monsterContent:AddComponent(MonsterInvasionFindItem, levelName)
      theItem:ReInit(item, self.monsterFindType, self.bgResourcePath)
      showEmptyTip = false
      if item.killed then
        table.insert(self.displayItems, theItem)
      end
    end
  end
  if self.monsterFindType == MonsterInvasionFindSelectType.Alliance then
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    if hasAlliance then
      self.monsterContent:SetActive(true)
      self.joinBtn:SetActive(false)
      self.emptyTip:SetActive(showEmptyTip or #showData == 0)
    else
      self.monsterContent:SetActive(false)
      self.joinBtn:SetActive(true)
      self.emptyTip:SetActive(false)
    end
    self.emptyTip:SetLocalText(2901033)
  else
    self.monsterContent:SetActive(true)
    self.joinBtn:SetActive(false)
    self.emptyTip:SetActive(#showData == 0)
    self.emptyTip:SetLocalText(2901048)
  end
end

function ActMonsterInvasion:ClickTip()
  if self.activityInfo ~= nil and self.activityInfo.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityInfo.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function ActMonsterInvasion:ClickGoBtn()
  SFSNetwork.SendMessage(MsgDefines.FindMonsterInvasion, WorldMonsterSpecialType.MonsterInvasion)
end

function ActMonsterInvasion:OnSearchBossBtnClick()
  SFSNetwork.SendMessage(MsgDefines.FindMonsterInvasion, WorldMonsterSpecialType.MonsterInvasionBoss)
end

function ActMonsterInvasion:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  if self.actStage == actStageType.NoData then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.actStage == actStageType.Preview then
    local leftTime = self.activityDetailData.fightTime - curTime
    if leftTime < 0 then
      leftTime = 0
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    local showTxt = Localization:GetString("2901001", countDownTimeStr)
    self.txt_pre:SetText(showTxt)
    self.txt_times:SetText(countDownTimeStr)
  elseif self.actStage == actStageType.Start then
    local leftTime = self.activityDetailData.endTime - curTime
    if leftTime < 0 then
      leftTime = 0
    end
    local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.txt_times:SetText(countDownTimeStr)
    local refreshLeftTime = self.activityDetailData.refreshTime - curTime
    if refreshLeftTime < 0 then
      refreshLeftTime = 0
    end
    local refreshCountDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(refreshLeftTime)
    local refreshShowStr = Localization:GetString("2901049", refreshCountDownTimeStr)
    self.monsterRefreshTime:SetText(refreshShowStr)
  end
  if curTime > self.nextRefreshTime then
    self.dataNeedRefresh = true
    self:TrySendGetDataMsg()
  end
  if self.dataNeedRefresh then
    self:TrySendGetDataMsg()
  end
end

function ActMonsterInvasion:ClickShop()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMonsterInvasionShop, {anim = true}, self.activityId)
end

function ActMonsterInvasion:ClickRankBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMonsterInvasionRank, {anim = true}, self.activityId)
end

function ActMonsterInvasion:ClickRewardBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMonsterInvasionLevelRewardPop, {anim = true}, self.activityId)
end

function ActMonsterInvasion:ClickRecordBtn()
  if string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    UIUtil.ShowTipsId("monster_invasion_no_alliance")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMonsterInvasionRecord, {anim = true}, self.activityId)
end

function ActMonsterInvasion:JoinAlliance()
  UIUtil.OnJoinAllianceBtnClick()
end

function ActMonsterInvasion:ToggleSelect(selectType)
  if self.monsterFindType == selectType then
    return
  end
  self.monsterFindType = selectType
  self:RefreshStartViewMonsterContent()
end

function ActMonsterInvasion:GetPosMsg(data)
  if data and data.pointId ~= nil and data.pointId > 0 then
    GoToUtil.CloseAllWindows()
    GoToUtil.MoveToWorldPointAndOpen(data.pointId, nil, data.uuid, LuaEntry.Player:GetSelfServerId())
  end
end

function ActMonsterInvasion:GetDataMsg()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  self:RefreshData()
  self:RefreshView()
  self.dataNeedRefresh = false
end

function ActMonsterInvasion:AllianceDataChange()
  self.dataNeedRefresh = true
  self:TrySendGetDataMsg()
end

function ActMonsterInvasion:RecordOpenTime()
  local monsterInvasionTipTimeKey = "LAST_OPEN_TIMESTAMP_" .. self.activityId
  local curTime = UITimeManager:GetInstance():GetServerTime()
  CommonUtil.PlayerPrefsSetLong(monsterInvasionTipTimeKey, curTime)
end

local function InitInvasionProgressGroup(self)
  if string.IsNullOrEmpty(CS.GameEntry.Data.Player:GetAllianceId()) then
    self.invasion_progress_group:SetActive(false)
    return false
  end
  local _, targetVal = DataCenter.ActivityMonsterInvasionDataManager:GetInvasionSummonProgress()
  if targetVal and 0 < targetVal then
    self.invasion_progress_group:SetActive(true)
    local cacheProgress = DataCenter.ActivityMonsterInvasionDataManager:GetCacheUIProgress()
    self.invasion_progress_group:ReInit(cacheProgress)
    return true
  end
  self.invasion_progress_group:SetActive(false)
  return false
end

local function PlayProgressAnimEffect(self)
  if self.invasion_progress_group then
    local progress = DataCenter.ActivityMonsterInvasionDataManager:GetInvasionSummonProgress()
    self.invasion_progress_group:DisplayProgressTween(progress)
  end
end

local function DisplayEffect(self)
  if self.isInit then
    if not table.IsNullOrEmpty(self.displayItems) then
      for _, v in ipairs(self.displayItems) do
        if v then
          v:PlayBrokenEffect()
        end
      end
      if self.timer then
        self.timer:Stop()
        self.timer = nil
      end
      self.timer = TimerManager:GetInstance():DelayInvoke(function()
        local callback
        if self.invasion_progress_group then
          local targetPos = self:GetFlyTargetPos()
          if targetPos then
            for i, v in ipairs(self.displayItems) do
              if v then
                callback = i == 1 and function()
                  self:PlayProgressAnimEffect()
                end or nil
                UIUtil.DoFlyCustom(nil, nil, 1, v:GetPos(), targetPos, nil, nil, callback, "Assets/Main/Prefabs/UI/ActivityCenter/MonsterInvasion/FlyEffect.prefab")
              end
            end
          end
        end
        if self.timer then
          self.timer:Stop()
          self.timer = nil
        end
      end, 0.3)
      if self.refreshTimer then
        self.refreshTimer:Stop()
        self.refreshTimer = nil
      end
      self.refreshTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:RefreshStartViewMonsterContent()
        if self.refreshTimer then
          self.refreshTimer:Stop()
          self.refreshTimer = nil
        end
      end, 1)
    else
      self:PlayProgressAnimEffect()
    end
    self.isInit = false
  end
end

local function GetFlyTargetPos(self)
  if self.invasion_progress_group then
    return self.invasion_progress_group.progress_slider.transform.position
  end
end

local function CloseUICacheData(self)
  if self.invasion_progress_group then
    DataCenter.ActivityMonsterInvasionDataManager:UpdateCacheUIProgress()
  end
end

function ActMonsterInvasion:RefreshShopRed()
  local hasRed = DataCenter.ActivityMonsterInvasionDataManager:GetActRedNum() > 0
  self.objRedPointShop:SetActive(hasRed)
end

ActMonsterInvasion.InitInvasionProgressGroup = InitInvasionProgressGroup
ActMonsterInvasion.PlayProgressAnimEffect = PlayProgressAnimEffect
ActMonsterInvasion.DisplayEffect = DisplayEffect
ActMonsterInvasion.CloseUICacheData = CloseUICacheData
ActMonsterInvasion.GetFlyTargetPos = GetFlyTargetPos
return ActMonsterInvasion
