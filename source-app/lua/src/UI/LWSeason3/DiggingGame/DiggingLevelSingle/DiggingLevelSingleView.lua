local base = UIBaseView
local DiggingLevelSingleView = BaseClass("DiggingLevelSingleView", base)
local DiggingBlockInfo = require("UI.LWSeason3.DiggingGame.DiggingLevelSingle.Component.DiggingBlockInfo")
local DiggingUseItem = require("UI.LWSeason3.DiggingGame.DiggingLevelSingle.Component.DiggingUseItem")
local DiggingHelpItem = require("UI.LWSeason3.DiggingGame.DiggingLevelSingle.Component.DiggingHelpItem")
local DiggingMap = require("UI.LWSeason3.DiggingGame.DiggingMap.DiggingMap")
local DiggingUseItemPrefab = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/SeasonActivity/DiggingGame/Component/DiggingUseItem.prefab"
local TitleText_path = "Root/Title"
local TimeText_path = "Root/TimeInfoItem/timeBg2/TimeText"
local Layout_path = "Root/DiggingProgress/Layout"
local DiggingBlockInfo_path = "Root/DiggingProgress/Layout/DiggingBlockInfo"
local IntroBtn_path = "Root/InfoBtn"
local CloseBtn_path = "Root/CloseBtn"
local UseItemTop_path = "Root/UseItemTop"
local HelpInfo_path = "Root/Bottom/HelpInfo"
local SelfInfo_path = "Root/Bottom/SelfInfo"
local ShareBtn_path = "Root/Bottom/SelfInfo/ShareBtn"
local HelpRoot_path = "Root/Bottom/SelfInfo/HelpRoot"
local DiggingHelpItem_path = "Root/Bottom/SelfInfo/HelpRoot/DiggingHelpItem"
local Reward_path = "Root/DiggingProgress/Layout/Reward"
local RewardIcon_path = "Root/DiggingProgress/Layout/Reward/RewardIcon"
local RewardRed_path = "Root/DiggingProgress/Layout/Reward/red"
local EffectCanGet1_path = "Root/DiggingProgress/Layout/Reward/EffectCanGet1"
local EffectCanGet2_path = "Root/DiggingProgress/Layout/Reward/EffectCanGet2"
local RewardEffectOpen_path = "Root/DiggingProgress/Layout/Reward/EffectOpen"
local DiggingMap_path = "Root/DiggingMap"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.mapData = self:GetUserData()
  self:OnRefresh()
end

local function OnDestroy(self)
  DataCenter.DiggingDataManager.curMapData = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.hasOpen and self.mapData and self.mapData.uid == LuaEntry.Player.uid then
    SFSNetwork.SendMessage(MsgDefines.SeasonDigGameReadHelp, self.mapData.uuid)
  end
end

local function ComponentDefine(self)
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.TimeText = self:AddComponent(UIText, TimeText_path)
  self.Layout = self:AddComponent(UIBaseContainer, Layout_path)
  self.DiggingBlockInfo = self:AddComponent(UIBaseContainer, DiggingBlockInfo_path)
  self.IntroBtn = self:AddComponent(UIButton, IntroBtn_path)
  self.CloseBtn = self:AddComponent(UIButton, CloseBtn_path)
  self.UseItemTop = self:AddComponent(UIBaseContainer, UseItemTop_path)
  self.HelpInfo = self:AddComponent(UIBaseContainer, HelpInfo_path)
  self.SelfInfo = self:AddComponent(UIBaseContainer, SelfInfo_path)
  self.ShareBtn = self:AddComponent(UIButton, ShareBtn_path)
  self.HelpRoot = self:AddComponent(UIBaseContainer, HelpRoot_path)
  self.DiggingHelpItem = self:AddComponent(UIBaseContainer, DiggingHelpItem_path)
  self.Reward = self:AddComponent(UIBaseContainer, Reward_path)
  self.RewardIcon = self:AddComponent(UIImage, RewardIcon_path)
  self.RewardRed = self:AddComponent(UIImage, RewardRed_path)
  self.EffectCanGet1 = self:AddComponent(UIBaseContainer, EffectCanGet1_path)
  self.EffectCanGet2 = self:AddComponent(UIBaseContainer, EffectCanGet2_path)
  self.CloseBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.IntroBtn:SetOnClick(function()
    local activityData = DataCenter.DiggingDataManager:GetActivityData()
    if activityData then
      local param = {}
      param.activityId = activityData.id
      param.activityRulesStr = CS.GameEntry.Localization:GetString(activityData.story)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
    end
  end)
  self.RewardAnim = self:AddComponent(UIAnimator, Reward_path)
  self.RewardBtn = self:AddComponent(UIButton, RewardIcon_path)
  self.RewardBtn:SetOnClick(BindCallback(self, self.ClickReward))
  self.RewardEffectOpen = self:AddComponent(UIVfx, RewardEffectOpen_path, VfxAssets.DiggingRewardOpen)
  self.ShareBtn:SetOnClick(BindCallback(self, self.OnClickShare))
  self.DiggingMap = self:AddComponent(DiggingMap, DiggingMap_path)
  self.ItemObj = self.DiggingBlockInfo.gameObject
  self.ItemObj:GameObjectCreatePool()
  self.ItemObj:SetActive(false)
  self.HelpObj = self.DiggingHelpItem.gameObject
  self.HelpObj:GameObjectCreatePool()
  self.HelpObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.Layout:RemoveComponents(DiggingBlockInfo)
  self.ItemObj:GameObjectRecycleAll()
  self.HelpRoot:RemoveComponents(DiggingHelpItem)
  self.HelpObj:GameObjectRecycleAll()
  if self.useItemHandle then
    self.useItemHandle:Destroy()
    self.useItemHandle = nil
  end
  if self.ShowHelpCo then
    coroutine.stopwaiting(self.ShowHelpCo)
    self.ShowHelpCo = nil
  end
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  self.TitleText = nil
  self.TimeText = nil
  self.Layout = nil
  self.DiggingBlockInfo = nil
  self.IntroBtn = nil
  self.CloseBtn = nil
  self.UseItemTop = nil
  self.HelpInfo = nil
  self.SelfInfo = nil
  self.ShareBtn = nil
  self.HelpRoot = nil
  self.DiggingHelpItem = nil
  self.Reward = nil
  self.RewardIcon = nil
  self.RewardRed = nil
  self.EffectCanGet1 = nil
  self.EffectCanGet2 = nil
end

local function DataDefine(self)
  self.mapData = nil
  self.blockItemList = {}
  self.helpItemList = {}
  self.lastRewardState = nil
end

local function DataDestroy(self)
  self.mapData = nil
  self.blockItemList = nil
  self.helpItemList = nil
  self.lastRewardState = nil
end

function DiggingLevelSingleView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DiggingGameOpen, self.OnOpen)
  self:AddUIListener(EventId.DiggingGameMapDataGetReward, self.UpdateReward)
end

function DiggingLevelSingleView:OnRemoveListener()
  self:RemoveUIListener(EventId.DiggingGameOpen, self.OnOpen)
  self:RemoveUIListener(EventId.DiggingGameMapDataGetReward, self.UpdateReward)
  base.OnRemoveListener(self)
end

function DiggingLevelSingleView:OnRefresh()
  local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(self.mapData.mapConfigId)
  if not levelConfig then
    self.ctrl:CloseSelf()
    UIUtil.ShowTipsId("120632")
    return
  end
  self.levelConfig = levelConfig
  if self.mapData.endTime and self.mapData.endTime > 0 then
    self.StartTime = nil
    self.EndTime = self.mapData.endTime
  else
    local mapInfo = DataCenter.DiggingDataManager:GetMapDataByUuid(self.mapData.uuid)
    if mapInfo then
      self.StartTime = mapInfo.startTime
      self.EndTime = mapInfo.endTime
    end
  end
  self:RefreshView()
  self:Update1000MS()
end

function DiggingLevelSingleView:RefreshView()
  if self.mapData.uid == LuaEntry.Player.uid then
    self:OnRefreshSelfGame()
  else
    self:OnRefreshOtherGame()
  end
end

function DiggingLevelSingleView:Update1000MS()
  if self.EndTime ~= nil then
    UIUtil.SetLeftTimeText(self.TimeText, self.StartTime, self.EndTime)
  end
end

function DiggingLevelSingleView:InitBlock()
  self.Layout:RemoveComponents(DiggingBlockInfo)
  self.ItemObj:GameObjectRecycleAll()
  self.blockItemList = {}
  if not self.levelConfig then
    return
  end
  local max = self.levelConfig.block and #self.levelConfig.block or 0
  if max == 0 then
    return
  end
  for i, blockId in ipairs(self.levelConfig.block) do
    self:UpdateBlock(blockId, i, DataCenter.DiggingDataManager:GetBlock(blockId, self.mapData.blockInfo), false, max)
  end
  self.Reward:SetSiblingIndex(max + 1)
  self:UpdateReward(self.mapData.uuid)
end

function DiggingLevelSingleView:UpdateBlock(bid, i, blockInfo, isDig, max)
  local theItem = self.blockItemList[i]
  if not theItem then
    theItem = self.ItemObj:GameObjectSpawn(self.Layout.transform)
    theItem.name = string.format("DiggingBlockInfo_%d", i)
    theItem:SetActive(true)
    theItem = self.Layout:AddComponent(DiggingBlockInfo, theItem.name)
    theItem:ReInit(i, bid, blockInfo, isDig)
    theItem:SetMax(max)
    self.blockItemList[i] = theItem
  end
end

function DiggingLevelSingleView:UpdateReward(uuid)
  if not self.mapData or self.mapData.uuid ~= uuid then
    return
  end
  if self.lastRewardState == self.mapData.rewardState then
    return
  end
  self.RewardAnim:Enable(false)
  if self.mapData.rewardState == 0 then
    self.EffectCanGet1:SetActive(false)
    self.EffectCanGet2:SetActive(false)
    self.RewardRed:SetActive(false)
    self.RewardIcon:LoadSprite(string.format(LoadPath.UIDiggingGame, "ljq_saijis3_yindiannaqiongsi_baoxiang_01"))
  elseif self.mapData.rewardState == 2 then
    if self.lastRewardState == 1 then
      self.RewardEffectOpen:Replay()
      self.tweenSeq = DOTween.Sequence()
      self.tweenSeq:AppendInterval(1)
      self.tweenSeq:AppendCallback(function()
        if self.mapData then
          self.ctrl:CloseSelf()
        end
      end)
    end
    self.EffectCanGet1:SetActive(false)
    self.EffectCanGet2:SetActive(false)
    self.RewardRed:SetActive(false)
    self.RewardIcon:LoadSprite(string.format(LoadPath.UIDiggingGame, "ljq_saijis3_yindiannaqiongsi_baoxiang_03"))
  elseif self.mapData and self.mapData.uid == LuaEntry.Player.uid then
    if self.lastRewardState == 0 and self.RewardAnim then
      self.RewardAnim:Enable(true)
    else
      self.RewardIcon:LoadSprite(string.format(LoadPath.UIDiggingGame, "ljq_saijis3_yindiannaqiongsi_baoxiang_02"))
      self.EffectCanGet1:SetActive(true)
      self.EffectCanGet2:SetActive(false)
      self.RewardRed:SetActive(true)
    end
  else
    self.EffectCanGet1:SetActive(false)
    self.EffectCanGet2:SetActive(false)
    self.RewardRed:SetActive(false)
    self.RewardIcon:LoadSprite(string.format(LoadPath.UIDiggingGame, "ljq_saijis3_yindiannaqiongsi_baoxiang_03"))
  end
  self.lastRewardState = self.mapData.rewardState
end

function DiggingLevelSingleView:ClickReward()
  if not self.mapData then
    return
  end
  if self.mapData.rewardState == 0 or self.mapData.rewardState == 2 or self.mapData.uid ~= LuaEntry.Player.uid then
    local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
    local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
    param.position = self.RewardBtn.transform.position
    param.deltaX = -55
    param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
    param.rewardList = self.levelConfig and DataCenter.RewardTemplateManager:GetList(self.levelConfig.reward)
    param.titleFontSize = 28
    param.titleAlignment = CS.TMPro.TextAlignmentOptions.MidlineLeft
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonDigGameGetPersonalReward, self.mapData.uuid)
end

function DiggingLevelSingleView:ShowUseItem(parent)
  if not parent then
    return
  end
  if self.theItem then
    local transform = self.theItem.transform
    transform:SetParent(parent.transform)
    transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.theItem:ReInit(DataCenter.DiggingDataManager.useItemId)
    return
  end
  if self.useItemHandle then
    return
  end
  self.useItemHandle = CS.GameEntry.Resource:InstantiateAsync(DiggingUseItemPrefab)
  self.useItemHandle:completed("+", function(handle)
    local theItem = handle.gameObject
    local transform = theItem.transform
    transform:SetParent(parent.transform)
    transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    theItem.name = string.format("DiggingUseItem")
    theItem = parent:AddComponent(DiggingUseItem, theItem.name)
    theItem:ReInit(DataCenter.DiggingDataManager.useItemId)
    self.theItem = theItem
  end)
end

function DiggingLevelSingleView:OnOpen(openData)
  if not openData then
    return
  end
  if openData.uuid ~= self.mapData.uuid then
    return
  end
  self.hasOpen = true
  if self.mapData.rewardState ~= 0 then
    self.DiggingMap:OpenBrick()
  end
  if not openData.blockInfo then
    return
  end
  self:UpdateReward(self.mapData.uuid)
end

function DiggingLevelSingleView:OnRefreshSelfGame()
  local hasHelpInfo = not table.IsNullOrEmpty(self.mapData.helpInfo)
  self.DiggingMap:OnRefresh(self.mapData, not hasHelpInfo and self.mapData.rewardState > 0)
  self:InitBlock()
  self:ShowUseItem(self.UseItemTop)
  self.TitleText:SetLocalText(self.levelConfig.name)
  self.HelpInfo:SetActive(false)
  self.SelfInfo:SetActive(true)
  self.ShareBtn:SetActive(true)
  if hasHelpInfo then
    self:ShowHelpList(self.mapData.helpInfo)
    self.mapData.helpInfo = nil
    SFSNetwork.SendMessage(MsgDefines.SeasonDigGameReadHelp, self.mapData.uuid)
  end
end

function DiggingLevelSingleView:OnClickShare()
  DataCenter.DiggingDataManager:ShareMap(self.mapData.uuid, self.mapData.mapConfigId, self.mapData.uid, self.mapData.endTime)
end

function DiggingLevelSingleView:ShowHelpList(helpList)
  self.HelpRoot:RemoveComponents(DiggingHelpItem)
  self.HelpObj:GameObjectRecycleAll()
  self.helpItemList = {}
  if table.IsNullOrEmpty(helpList) then
    return
  end
  local textList = {
    "season_activity_1000070_desc19",
    "season_activity_1000070_desc20",
    "season_activity_1000070_desc21"
  }
  local textCount = #textList
  for i, v in ipairs(helpList) do
    self.DiggingMap:CloseBrick(v.pos)
  end
  self.DiggingMap:LockBrick()
  self.ShowHelpCo = coroutine.start(function()
    for i, v in ipairs(helpList) do
      coroutine.waitforseconds(0.35)
      if not self.HelpRoot or not self.helpItemList then
        return
      end
      local helpItem = self.HelpObj:GameObjectSpawn(self.HelpRoot.transform)
      helpItem.name = string.format("DiggingHelpItem_%d", i)
      helpItem:SetActive(true)
      helpItem = self.HelpRoot:AddComponent(DiggingHelpItem, helpItem.name)
      helpItem:ReInit(v, textList[math.random(1, textCount)], 2)
      helpItem:ShowFadeInEffect()
      self.DiggingMap:OpenBrick(v.pos)
      self.helpItemList[i] = helpItem
    end
    coroutine.waitforseconds(0.2)
    if self.DiggingMap then
      self.DiggingMap:UnlockBrick()
    end
  end)
end

function DiggingLevelSingleView:OnRefreshOtherGame()
  self.DiggingMap:OnRefresh(self.mapData)
  self:InitBlock()
  self:ShowUseItem(self.UseItemTop)
  local allianceMember = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(self.mapData.uid)
  if allianceMember then
    local text = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(allianceMember.uid, allianceMember.name)
    self.TitleText:SetLocalText("season_activity_1000070_desc11", text)
  else
    self.TitleText:SetLocalText("season_activity_1000070_desc08")
  end
  self.HelpInfo:SetActive(true)
  self.SelfInfo:SetActive(false)
  self.ShareBtn:SetActive(false)
end

DiggingLevelSingleView.OnCreate = OnCreate
DiggingLevelSingleView.OnDestroy = OnDestroy
DiggingLevelSingleView.OnEnable = OnEnable
DiggingLevelSingleView.OnDisable = OnDisable
DiggingLevelSingleView.ComponentDefine = ComponentDefine
DiggingLevelSingleView.ComponentDestroy = ComponentDestroy
DiggingLevelSingleView.DataDefine = DataDefine
DiggingLevelSingleView.DataDestroy = DataDestroy
return DiggingLevelSingleView
