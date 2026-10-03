local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonGoldTreeMain = BaseClass("SeasonGoldTreeMain", base)
local Localization = CS.GameEntry.Localization
local BuffIcon = require("UI.LWMainUI.Component.UIMainLeft.BuffIcon")
local GoldTreePrayItem = require("UI.LWSeason.LWSeasonGoldTree.Component.GoldTreePrayItem")
local infoBtn_path = "Root/top/right/IntroBtn"
local rankBtn_path = "Root/top/right/rankBtn"
local bg_path = "mask/Bg"
local animator_path = ""
local treeChargeEffect_path = "mask/VX_bg_effect/Eff_ui_GoldenTree_enviroment_charge"
local treePrayEffect_path = "mask/VX_bg_effect/Eff_ui_GoldenTree_enviroment"
local rewardBtn_path = "Root/top/right/rewardBtn"
local recordBtn_path = "Root/top/right/recordBtn"
local tipsRoot_path = "Root/top/right/recordBtn/tipsRoot"
local name_path = "Root/top/left/Txt_ActName"
local desc_path = "Root/top/left/Txt_ActDesc"
local endTime_path = "Root/top/left/TimeInfoItem/timeBg2/TimeText"
local txtBuildingName_path = "Root/bot/TreeGroup/TxtBuildingTitle"
local btnPos_path = "Root/bot/TreeGroup/posGoto"
local txtPos_path = "Root/bot/TreeGroup/posGoto/pos"
local btnComb_path = "Root/bot/PrayGroup/Info/TxtTips/CombBtn"
local info_path = "Root/bot/PrayGroup/Info"
local txtTips_path = "Root/bot/PrayGroup/Info/TxtTips"
local txtTimeLeft_path = "Root/bot/PrayGroup/Info/TxtTimeLeft"
local btnGo_path = "Root/bot/ChargeGroup/BtnGo"
local ChargeGroup_path = "Root/bot/ChargeGroup"
local PrayGroup_path = "Root/bot/PrayGroup"
local txtCharge_path = "Root/bot/ChargeGroup/TxtCharge"
local chargeProgress_path = "Root/bot/ChargeGroup/ChargeProgress"
local txtProgress_path = "Root/bot/ChargeGroup/ChargeProgress/txtprogress"
local rewardContent_path = "Root/bot/ChargeGroup/Reward/RewardScroll/Viewport/Content"
local prayContent_path = "Root/bot/PrayGroup/PrayContent"
local prayItem_path = "Root/bot/PrayGroup/PrayContent/GoldTreePrayItem"
local prayDesc_path = "Root/bot/PrayGroup/TxtPrayDesc"
local finalFx_path = "mask/FinalFx"
local finalFxPray_path = "Root/bot/PrayGroup/FinalFxPray"
local thirdBtn_path = "Root/top/right/thirdBtn"
local txt_thirdTime_path = "Root/top/right/thirdBtn/txt_thirdTime"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.GoldTreeActView)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.treeChargeEffect = self:AddComponent(UIBaseContainer, treeChargeEffect_path)
  self.treePrayEffect = self:AddComponent(UIBaseContainer, treePrayEffect_path)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
  self.recordBtn = self:AddComponent(UIButton, recordBtn_path)
  self.tipsRoot = self:AddComponent(UIBaseContainer, tipsRoot_path)
  self.name = self:AddComponent(UIText, name_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.endTime = self:AddComponent(UIText, endTime_path)
  self.txtBuildingName = self:AddComponent(UIText, txtBuildingName_path)
  self.btnPos = self:AddComponent(UIButton, btnPos_path)
  self.txtPos = self:AddComponent(UIText, txtPos_path)
  self.btnComb = self:AddComponent(UIButton, btnComb_path)
  self.info = self:AddComponent(UIBaseContainer, info_path)
  self.txtTips = self:AddComponent(UIText, txtTips_path)
  self.txtTimeLeft = self:AddComponent(UIText, txtTimeLeft_path)
  self.btnGo = self:AddComponent(UIButton, btnGo_path)
  self.ChargeGroup = self:AddComponent(UIBaseContainer, ChargeGroup_path)
  self.PrayGroup = self:AddComponent(UIBaseContainer, PrayGroup_path)
  self.txtCharge = self:AddComponent(UIText, txtCharge_path)
  self.chargeProgress = self:AddComponent(UISlider, chargeProgress_path)
  self.txtProgress = self:AddComponent(UIText, txtProgress_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, rewardContent_path)
  self.prayContent = self:AddComponent(UIBaseContainer, prayContent_path)
  self.prayItem = self:AddComponent(UIBaseContainer, prayItem_path)
  self.prayDesc = self:AddComponent(UIText, prayDesc_path)
  self.finalFx = self:AddComponent(UIBaseContainer, finalFx_path)
  self.finalFxPray = self:AddComponent(UIBaseContainer, finalFxPray_path)
  self.thirdBtn = self:AddComponent(UIButton, thirdBtn_path)
  self.txt_thirdTime = self:AddComponent(UIText, txt_thirdTime_path)
  self.infoBtn:SetOnClick(function()
    if self.activityData and not string.IsNullOrEmpty(self.activityData.story) then
      local param = {}
      param.activityId = self.activityId
      param.activityRulesStr = Localization:GetString(self.activityData.story)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
    end
  end)
  self.rankBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.GoldTreeRank, {anim = true})
  end)
  self.rewardBtn:SetOnClick(function()
    if DataCenter.SeasonGoldTreeManager:IsCharge() then
      SFSNetwork.SendMessage(MsgDefines.GoldTreePowerRankView)
      UIManager:GetInstance():OpenWindow(UIWindowNames.GoldTreeReward, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.GoldTreeRule, {anim = true}, self.combinationId)
    end
  end)
  self.recordBtn:SetOnClick(function()
    DataCenter.SeasonGoldTreeManager:RequestAnnounceList()
    UIManager:GetInstance():OpenWindow(UIWindowNames.GoldTreePrayShow, {anim = true})
  end)
  self.btnComb:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.GoldTreeRule, {anim = true}, self.combinationId)
  end)
  self.btnGo:SetOnClick(function()
    self:Goto()
  end)
  self.btnPos:SetOnClick(function()
    self:Goto()
  end)
  self.prayObj = self.prayItem.gameObject
  self.prayObj:GameObjectCreatePool()
  self.prayObj:SetActive(false)
  self.thirdBtn:SetOnClick(function()
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    if not hasAlliance then
      UIUtil.ShowTipsId(900531)
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGoldTreeThird, {anim = true})
  end)
end

local function ComponentDestroy(self)
  self.prayContent:RemoveComponents(GoldTreePrayItem)
  self.prayObj:GameObjectRecycleAll()
  self:ClearRewardItems()
  if self.prayShowObj then
    self:GameObjectDestroy(self.prayShowObj)
    self.prayShowObj = nil
  end
  self.infoBtn = nil
  self.rankBtn = nil
  self.bg = nil
  self.animator = nil
  self.treeChargeEffect = nil
  self.treePrayEffect = nil
  self.rewardBtn = nil
  self.recordBtn = nil
  self.tipsRoot = nil
  self.name = nil
  self.desc = nil
  self.endTime = nil
  self.txtBuildingName = nil
  self.btnPos = nil
  self.txtPos = nil
  self.btnComb = nil
  self.info = nil
  self.txtTips = nil
  self.txtTimeLeft = nil
  self.btnGo = nil
  self.ChargeGroup = nil
  self.PrayGroup = nil
  self.txtCharge = nil
  self.chargeProgress = nil
  self.txtProgress = nil
  self.rewardContent = nil
  self.prayContent = nil
  self.prayItem = nil
  self.prayDesc = nil
  self.finalFx = nil
  self.finalFxPray = nil
  self.thirdBtn = nil
  self.txt_thirdTime = nil
end

local function DataDefine(self)
  self.itemList = {}
end

local function DataDestroy(self)
  self.itemList = nil
end

function SeasonGoldTreeMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GoldTreeOpenCard, self.OpenCard)
  self:AddUIListener(EventId.SeasonGoldTreeInfo, self.RefreshView)
  self:AddUIListener(EventId.GoldTreeAnnouncement, self.GoldTreeAnnouncement)
  self:AddUIListener(EventId.OnUnDelayPassDay, self.OnOnUnDelayPassDay)
end

function SeasonGoldTreeMain:OnRemoveListener()
  self:RemoveUIListener(EventId.GoldTreeOpenCard, self.OpenCard)
  self:RemoveUIListener(EventId.SeasonGoldTreeInfo, self.RefreshView)
  self:RemoveUIListener(EventId.GoldTreeAnnouncement, self.GoldTreeAnnouncement)
  self:RemoveUIListener(EventId.OnUnDelayPassDay, self.OnOnUnDelayPassDay)
  base.OnRemoveListener(self)
end

function SeasonGoldTreeMain:SetData(activityId)
  base.SetData(self, activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  self.activityData = data
  self.name:SetLocalText(data.name)
  self.desc:SetLocalText(data.desc)
  self.StartTime = data.startTime
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.EndTime = DataCenter.SeasonDataManager.nextSeasonStartTime
  else
    self.EndTime = data.endTime
  end
  self:RefreshView()
  self:Update1000MS()
end

function SeasonGoldTreeMain:Update1000MS()
  if self.activityData then
    UIUtil.SetLeftTimeText(self.endTime, self.StartTime, self.EndTime)
  end
  if self.endTimeCur or self.startTimeCur then
    UIUtil.SetLeftTimeText(self.txtTimeLeft, self.startTimeCur, self.endTimeCur, "season_s4_golden_tree_UI_45")
  end
  if self.max then
    self:RefreshProgress()
  end
  if self.showEndTime and self.txt_thirdTime then
    local nWeekZeroTime = DataCenter.SeasonGoldTreeThirdManager:GetWeekEndTime()
    UIUtil.SetLeftTimeText(self.txt_thirdTime, nil, nWeekZeroTime)
  end
end

function SeasonGoldTreeMain:RefreshView()
  local info = DataCenter.SeasonGoldTreeManager.goldTreeInfo
  if not info then
    return
  end
  self.max = nil
  self.cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(info.treeId, LuaEntry.Player:GetSourceServerId())
  self:RefreshTree(info)
  self.endTimeCur = nil
  self.startTimeCur = nil
  self.txtTips:SetActive(false)
  self.txtTimeLeft:SetActive(false)
  if not DataCenter.SeasonGoldTreeManager:IsActive() then
    self.ChargeGroup:SetActive(false)
    self.PrayGroup:SetActive(false)
    self.rankBtn:SetActive(false)
    self.recordBtn:SetActive(false)
    self.treeChargeEffect:SetActive(false)
    self.treePrayEffect:SetActive(false)
    self.thirdBtn:SetActive(false)
    self.bg:LoadSprite(string.format(LoadPath.TextureSeason4Path, "Activity/zxl_s4_huangjinshu_chongneng_banner"))
    return
  end
  self.thirdBtn:SetActive(DataCenter.SeasonGoldTreeThirdManager:Active())
  self:OnOnUnDelayPassDay()
  self:CheckBubble()
  if DataCenter.SeasonGoldTreeManager:IsCharge() then
    self:RefreshCharge(info)
    self.ChargeGroup:SetActive(true)
    self.PrayGroup:SetActive(false)
    self.rankBtn:SetActive(true)
    self.recordBtn:SetActive(false)
    self.treeChargeEffect:SetActive(true)
    self.treePrayEffect:SetActive(false)
    self.bg:LoadSprite(string.format(LoadPath.TextureSeason4Path, "Activity/zxl_s4_huangjinshu_chongneng_banner"))
    return
  end
  self:RefreshPrayList()
  self:TryShowPrayShowContent()
  self.ChargeGroup:SetActive(false)
  self.PrayGroup:SetActive(true)
  self.rankBtn:SetActive(false)
  self.recordBtn:SetActive(true)
  self.treeChargeEffect:SetActive(false)
  self.treePrayEffect:SetActive(true)
  self.bg:LoadSprite(string.format(LoadPath.TextureSeason4Path, "Activity/zxl_s4_huangjinshu_banner"))
end

function SeasonGoldTreeMain:RefreshTree(info)
  self.txtBuildingName:SetLocalText(self.cityMeta.name)
  self.txtPos:SetText(string.format("#%s X:%s Y:%s", LuaEntry.Player:GetSourceServerId(), self.cityMeta.pos.x, self.cityMeta.pos.y))
end

function SeasonGoldTreeMain:RefreshCharge(info)
  self.max = self.cityMeta.battery or 1
  self:RefreshProgress()
  self:RefreshReward()
end

function SeasonGoldTreeMain:ClearRewardItems()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardContent:RemoveComponents(BuffIcon)
  if self.rewardItems then
    for k, v in pairs(self.rewardItems) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function SeasonGoldTreeMain:RefreshReward()
  if self.rewardItems then
    return
  end
  self:ClearRewardItems()
  self.rewardItems = {}
  local contentTrans = self.rewardContent.transform
  local index = 0
  local buffIdStr = DataCenter.SeasonGoldTreeTemplateManager:GetGoldTreeTemp("charging_buff")
  if buffIdStr then
    local scale = 2.4
    local buffIdList = string.split(tostring(buffIdStr), ";") or {}
    for i, v in ipairs(buffIdList) do
      self.rewardItems[index] = self:GameObjectInstantiateAsync(UIAssets.BuffIcon, function(request)
        index = index + 1
        if request.isError then
          return
        end
        local stateMeta = LocalController:instance():getLine(TableName.StatusTab, v)
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(contentTrans)
        go.transform:Set_localScale(scale, scale, scale)
        go.name = "BuffIcon" .. index
        local cell = self.rewardContent:AddComponent(BuffIcon, go.name)
        local param = {
          meta = stateMeta,
          OnClick = function()
            if stateMeta and not string.IsNullOrEmpty(stateMeta.info) then
              UIUtil.ShowBubbleTips(Localization:GetString(stateMeta.info), go.transform.position, 0, -30, 0, nil, nil)
            end
          end
        }
        cell:ReInit(param)
      end)
    end
  end
  local chargeRewardId = DataCenter.SeasonGoldTreeTemplateManager:GetGoldTreeTemp("charging_reward")
  local rewardList = chargeRewardId and DataCenter.RewardTemplateManager:GetList(chargeRewardId) or {}
  local scale = 1.1
  for i, v in ipairs(rewardList) do
    self.rewardItems[index] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      index = index + 1
      if request.isError then
        return
      end
      local go = request.gameObject
      local trans = go.transform
      trans:SetParent(contentTrans)
      trans:Set_localScale(scale, scale, scale)
      trans:Set_sizeDelta(100, 100)
      trans.pivot = Vector2.New(0.5, 0.5)
      go.name = "item" .. index
      local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
      cell:ReInit(rewardList[i])
    end)
  end
end

function SeasonGoldTreeMain:RefreshProgress()
  local info = DataCenter.SeasonGoldTreeManager.goldTreeInfo
  if not info then
    return
  end
  local cur = info.power or 0
  local max = self.max or 1
  local progress = 0
  progress = cur / max
  self.chargeProgress:SetValue(progress)
  self.txtProgress:SetText(string.format("%s%%", math.floor(progress * 10000) * 0.01))
end

function SeasonGoldTreeMain:Goto()
  if not self.cityMeta then
    return
  end
  GoToUtil.CloseAllWindows()
  local pos = SceneUtils.TileToWorld(self.cityMeta.pos)
  GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, LuaEntry.Player:GetSourceServerId())
end

function SeasonGoldTreeMain:RefreshPrayList()
  self.prayContent:RemoveComponents(GoldTreePrayItem)
  self.prayObj:GameObjectRecycleAll()
  for day = DataCenter.SeasonGoldTreeManager.startDay, DataCenter.SeasonGoldTreeManager.endDay do
    local theItem = self.prayObj:GameObjectSpawn(self.prayContent.transform)
    theItem.name = string.format("PrayItem_%d", day)
    theItem:SetActive(true)
    theItem = self.prayContent:AddComponent(GoldTreePrayItem, theItem.name)
    theItem:ReInit(DataCenter.SeasonGoldTreeManager:GetPrayCardInfo(day), day)
    self.itemList[day] = theItem
  end
  self:RefreshPrayTips()
end

function SeasonGoldTreeMain:RefreshPrayItem(day)
  local item = self.itemList[day]
  if item then
    item:ReInit(DataCenter.SeasonGoldTreeManager:GetPrayCardInfo(day), day)
  end
  self:RefreshPrayTips()
end

function SeasonGoldTreeMain:RefreshPrayTips()
  local userGoldTreeInfo = DataCenter.SeasonGoldTreeManager.userGoldTreeInfo
  local combinationId = userGoldTreeInfo and userGoldTreeInfo:GetCombinationId(true)
  self.combinationId = combinationId
  local combinationConf = combinationId and 0 < combinationId and DataCenter.SeasonGoldTreeTemplateManager:GetCardCombinationsTemp(combinationId)
  local combinationName, combinationDesc
  if combinationConf then
    combinationName = Localization:GetString(combinationConf.name)
    combinationDesc = Localization:GetString(combinationConf.desc)
  else
    combinationName = Localization:GetString(100206)
    combinationDesc = Localization:GetString("season_s4_golden_tree_UI_51")
  end
  self.txtTips:SetText(string.format(Localization:GetString("season_s4_golden_tree_UI_37", combinationName)))
  self.txtTips:SetActive(true)
  self.prayDesc:SetText(combinationDesc)
  self.startTimeCur = DataCenter.SeasonGoldTreeManager:GetNextWeekPrayTime()
  if self.startTimeCur then
    self.txtTimeLeft:SetActive(true)
  else
    self.txtTimeLeft:SetActive(false)
  end
end

function SeasonGoldTreeMain:OpenCard(data)
  self:RefreshPrayItem(data.day)
  if table.IsNullOrEmpty(data.combinationRewardArr) then
    return
  end
  if not self.finalFxComp then
    local param = {
      duration = 5,
      lifeType = UIVfxLifeType.HideAfterOnce
    }
    self.finalFxComp = self:AddComponent(UIVfx, finalFx_path, VfxAssets.GoldTreeFinalEffect, param)
    self.finalFxPrayComp = self:AddComponent(UIVfx, finalFxPray_path, VfxAssets.GoldTreeFinalPrayEffect, param)
  end
  if self.finalFxComp then
    self.finalFxComp:Replay()
  end
  if self.finalFxPrayComp then
    self.finalFxPrayComp:Replay()
  end
  TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.RewardManager:ShowCommonReward({
      reward = data.combinationRewardArr
    })
  end, 2.2)
end

function SeasonGoldTreeMain:TryShowPrayShowContent()
  DataCenter.SeasonGoldTreeManager:RequestAnnounceList()
end

function SeasonGoldTreeMain:GoldTreeAnnouncement(msg)
  local announceArr = msg and msg.announceArr
  local isEmpty = true
  if announceArr then
    for i, v in ipairs(announceArr) do
      if not v:IsEmpty() then
        isEmpty = false
        break
      end
    end
  end
  self.recordBtn:SetActive(not isEmpty or DataCenter.SeasonGoldTreeManager:GetPrayWeek() > 1)
  if isEmpty then
    return
  end
  if UIUtil.GetMonthActiveCount(string.format("GoldTreeShow_%s", msg.weekNum), true) > 0 then
    return
  end
  if self.prayShowObj then
    if self.prayShowObj.gameObject then
      self.prayShowObj.gameObject:SetActive(true)
    end
    return
  end
  self.prayShowObj = self:GameObjectInstantiateAsync(UIAssets.UIGoldTreePrayContent, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    local trans = go.transform
    trans:SetParent(self.tipsRoot.transform)
    trans:Set_localScale(1, 1, 1)
    trans:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.name = "GoldTreePrayContent"
    local GoldTreePrayDetail = require("UI.LWSeason.LWSeasonGoldTree.Component.GoldTreePrayDetail")
    local goldTreePrayDetail = self.tipsRoot:AddComponent(GoldTreePrayDetail, "GoldTreePrayContent/GoldTreePrayDetail")
    goldTreePrayDetail:RefreshView(msg)
    local btnInfo = self.tipsRoot:AddComponent(UIButton, "GoldTreePrayContent/info")
    btnInfo:SetOnClick(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.GoldTreeRule, {anim = true})
    end)
    local btnClose = self.tipsRoot:AddComponent(UIButton, "GoldTreePrayContent/close")
    btnClose:SetOnClick(function()
      self.prayShowObj.gameObject:SetActive(false)
    end)
  end)
end

function SeasonGoldTreeMain:OnOnUnDelayPassDay()
  local weekIndex = UITimeManager:GetInstance():GetNowWeekdayIndex()
  self.showEndTime = weekIndex ~= 1 and weekIndex ~= 7
  self.txt_thirdTime:SetActive(self.showEndTime)
end

function SeasonGoldTreeMain:CheckBubble()
  if not DataCenter.SeasonGoldTreeThirdManager:Active() then
    return
  end
  TimerManager:DelayInvoke(function()
    if self.thirdBtn == nil then
      return
    end
    local lastServerTime = CS.GameEntry.Setting:GetInt(SettingKeys.SEASON_GOLD_TREE_THIRD_SHOW_BUBBLE, 0)
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    local year, month, day = UITimeManager:GetInstance():TimeStampToServerTime(serverTime)
    local time = year * 1000 + month * 100 + day
    if time ~= lastServerTime then
      CS.GameEntry.Setting:SetInt(SettingKeys.SEASON_GOLD_TREE_THIRD_SHOW_BUBBLE, time)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonTips)
      UIUtil.ShowBubbleTipsAuto(Localization:GetString("season_golden_tree_phase_third_UI_39"), self.thirdBtn.transform.position, 0, -30, -40, nil, nil)
    end
  end, 1.0)
end

SeasonGoldTreeMain.OnCreate = OnCreate
SeasonGoldTreeMain.OnDestroy = OnDestroy
SeasonGoldTreeMain.OnEnable = OnEnable
SeasonGoldTreeMain.OnDisable = OnDisable
SeasonGoldTreeMain.ComponentDefine = ComponentDefine
SeasonGoldTreeMain.ComponentDestroy = ComponentDestroy
SeasonGoldTreeMain.DataDefine = DataDefine
SeasonGoldTreeMain.DataDestroy = DataDestroy
return SeasonGoldTreeMain
