local base = require("UI.UIDispatchTask.Main.Component.UIDispatchContentBase")
local DispatchTreasure = BaseClass("DispatchTreasure", base)
local DispatchTreasureItem = require("UI.UIDispatchTask.Main.Component.DispatchTreasureItem")
local UICommonTipsView = require("UI.UICommonTips.View.UICommonTipsView")
local Localization = CS.GameEntry.Localization
local DispatchTreasureCurveAnimNode = require("UI.UIDispatchTask.Main.Component.DispatchTreasureCurveAnimNode")
local OffSeasonTreasureBoxReward = require("UI.UIDispatchTask.Main.Component.S3BoxReward.OffSeasonTreasureBoxReward")
local TitleText_path = "Content/TitleText"
local ProgressText_path = "Content/TitleText/ProgressText"
local IntroBtn_path = "Content/IntroBtn"
local SelectSkipBtn_path = "Content/SkipPanel/SelectSkipBtn"
local SelectImg_path = "Content/SkipPanel/SelectSkipBtn/SelectImg"
local SkipTipText_path = "Content/SkipPanel/SkipTipText"
local DiggingBtn_path = "Content/btncontent/DiggingBtn"
local DiggingBtnText_path = "Content/btncontent/DiggingBtn/DiggingBtnText"
local ExchangeBtn_path = "Content/ExchangeBtn"
local FragContent_path = "BgClip/BgRawImg/FragContent"
local FragDigContent_path = "BgClip/BgRawImg/FragDigContent"
local CurveAnimNode_path = "BgClip/BgRawImg/CurveAnimNode"
local DiggingRedPoint_path = "Content/btncontent/DiggingBtn/CommonRedPoint"
local DiggingTenRedPoint_path = "Content/btncontent/DiggingTenBtn/CommonRedPointTen"
local ExchangeRePoint_path = "Content/ExchangeBtn/ExchangeRedPoint"
local PreviewBtn_path = "Content/PreviewBtn"
local DigSlider_path = "Content/DigPanel/Content/DigSlider"
local DigPercentTxt_path = "Content/DigPanel/Content/DigPercentTxt"
local DigBtn_path = "Content/DigPanel/Content/DigImage"
local fragBtn8_path = "BgClip/BgRawImg/FragContent/FragBtn8"
local fragDigBtn8_path = "BgClip/BgRawImg/FragDigContent/FragDigBtn8"
local mrEffect_path = "BgClip/BgRawImg/FragContent/Eff_ui_activitydispatchtreasure_ditu"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Update1000MS()
  DataCenter.DigTreasureManager:CheckIsShownPlot()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.CurveAnimNode then
    self.CurveAnimNode:SetActive(false)
  end
  self:Refresh()
end

local function OnDisable(self)
  base.OnDisable(self)
  self.inDigging = false
end

local function ComponentDefine(self)
  self.TitleText = self:AddComponent(UIText, TitleText_path)
  self.ProgressText = self:AddComponent(UIText, ProgressText_path)
  self.IntroBtn = self:AddComponent(UIButton, IntroBtn_path)
  self.SelectSkipBtn = self:AddComponent(UIButton, SelectSkipBtn_path)
  self.SelectImg = self:AddComponent(UIImage, SelectImg_path)
  self.SkipTipText = self:AddComponent(UIText, SkipTipText_path)
  self.DiggingBtn = self:AddComponent(UIButton, DiggingBtn_path)
  self.DiggingBtnText = self:AddComponent(UIBaseContainer, DiggingBtnText_path)
  self.ExchangeBtn = self:AddComponent(UIButton, ExchangeBtn_path)
  self.FragContent = self:AddComponent(UIBaseContainer, FragContent_path)
  self.CurveAnimNode = self:AddComponent(DispatchTreasureCurveAnimNode, CurveAnimNode_path)
  self.DiggingRedPoint = self:AddComponent(UICommonRedPoint, DiggingRedPoint_path)
  self.DiggingRedPoint:SetType(CommonRedPointPriority.Level1)
  self.DiggingTenRedPoint = self:AddComponent(UICommonRedPoint, DiggingTenRedPoint_path)
  self.DiggingTenRedPoint:SetType(CommonRedPointPriority.Level1)
  self.ExchangeRePoint = self:AddComponent(UIBaseContainer, ExchangeRePoint_path)
  self.PreviewBtn = self:AddComponent(UIButton, PreviewBtn_path)
  self.DigSlider = self:AddComponent(UISlider, DigSlider_path)
  self.DigPercentTxt = self:AddComponent(UIText, DigPercentTxt_path)
  self.DigBtn = self:AddComponent(UIButton, DigBtn_path)
  self.IntroBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTip()
  end)
  self.fragItems = {}
  local fragContentTrans = self.FragContent.transform
  local childCount = 7
  for i = 1, childCount do
    local trans = fragContentTrans:Find("FragBtn" .. i)
    local comp = self.FragContent:AddComponent(DispatchTreasureItem, trans.gameObject)
    table.insert(self.fragItems, comp)
  end
  self.fragBtn8 = self:AddComponent(UIBaseContainer, fragBtn8_path)
  self.fragMrEffect = self:AddComponent(UIBaseContainer, mrEffect_path)
  self.fragBtn8:SetActive(false)
  self.fragMrEffect:SetActive(false)
  self.DiggingBtn:SetOnClick(function()
    self:OnClickDiggingBtn()
  end)
  self.ExchangeBtn:SetOnClick(function()
    self:OnClickExchangeBtn()
  end)
  self.SelectSkipBtn:SetOnClick(function()
    local active = self.SelectImg:GetActive()
    self.SelectImg:SetActive(not active)
    DataCenter.ActDispatchTreasureManager:SetSkipAnimState(not active)
  end)
  self.PreviewBtn:SetOnClick(function()
    self:OnClickPreviewBtn()
  end)
  self.DigBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDigDispatchBtnClick()
  end)
  self.rawImgBg = self:AddComponent(UIRawImage, "BgClip/BgRawImg")
  self.FragDigContent = self:AddComponent(UIBaseContainer, FragDigContent_path)
  self.FragDigContent:SetActive(false)
  self.fragDigBtn8 = self:AddComponent(UIBaseContainer, fragDigBtn8_path)
  self.fragDigBtn8:SetActive(false)
  fragContentTrans = self.FragDigContent.transform
  self.fragDigItems = {}
  for i = 1, childCount do
    local trans = fragContentTrans:Find("FragBtn" .. i)
    local comp = self.FragDigContent:AddComponent(DispatchTreasureItem, trans.gameObject)
    table.insert(self.fragDigItems, comp)
  end
  self.CountDownObj = self:AddComponent(UIBaseContainer, "BgClip/BgRawImg/FragDigContent/CountDownObj")
  self.textCountDown = self:AddComponent(UITextMeshProUGUIEx, "BgClip/BgRawImg/FragDigContent/CountDownObj/CountDownText")
  self.textDigDesc = self:AddComponent(UITextMeshProUGUIEx, "BgClip/BgRawImg/FragDigContent/CountDownObj/CountDownDes")
  self.btnOpenDigTreasure = self:AddComponent(UIButton, "BgClip/BgRawImg/FragDigContent/btnOpenDigTreasure")
  self.btnOpenDigTreasure:SetOnClick(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDispatchTaskMain, {anim = false})
    DataCenter.DigTreasureManager:OpenDigTreasureView()
  end)
  self.actPreviewTrans = self:AddComponent(UIBaseContainer, "BgClip/BgRawImg/ActPreview")
  self.textPreviewCountDown = self:AddComponent(UITextMeshProUGUIEx, "BgClip/BgRawImg/ActPreview/TextCountDown")
  self.textPreviewCountDown:SetText("")
  self.actPreviewIcon = self:AddComponent(UIImage, "BgClip/BgRawImg/ActPreview/ImageBg2")
  self.actPreviewBtn = self:AddComponent(UIButton, "BgClip/BgRawImg/ActPreview/ActPreviewBtn")
  self.actPreviewBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDigTreasurePreview)
  end)
  self.btnTen = self:AddComponent(UIButton, "Content/btncontent/DiggingTenBtn")
  self.btnTenText = self:AddComponent(UITextMeshProUGUIEx, "Content/btncontent/DiggingTenBtn/DiggingTenBtnText")
  self.btnTen:SetOnClick(function()
    self:BtnTenReward()
  end)
  self.boxContent = self:AddComponent(UIBaseContainer, "BgClip/boxContent")
end

local function ComponentDestroy(self)
  self.actPreviewIcon = nil
  self.btnTen = nil
  self.boxContent = nil
  self.TitleText = nil
  self.ProgressText = nil
  self.btnTenText = nil
  self.IntroBtn = nil
  self.SelectSkipBtn = nil
  self.SelectImg = nil
  self.SkipTipText = nil
  self.DiggingBtn = nil
  self.DiggingBtnText = nil
  self.ExchangeBtn = nil
  self.CountDownObj = nil
  self.FragContent = nil
  self.CurveAnimNode = nil
  self.DiggingRedPoint = nil
  self.DiggingTenRedPoint = nil
  self.ExchangeRePoint = nil
  self.PreviewBtn = nil
  self.DigSlider = nil
  self.DigPercentTxt = nil
  self.DigBtn = nil
  self.fragItems = nil
  self.fragBtn8 = nil
  self.fragMrEffect = nil
end

local function DataDefine(self)
  self.activityId = 0
  self.data = nil
  self.canDigNum = 0
  self.inDigging = false
  self.digMaxNum = LuaEntry.DataConfig:TryGetNum("Treasure_map_reward_guarantees", "k4", 1)
  self.isDigActOpen = DataCenter.DigTreasureManager:IsActivityOpen()
  self.isBoxActOpen = DataCenter.DigTreasureManager:IsNewActivityOpen()
end

local function DataDestroy(self)
  self.offSeasonBoxReward = nil
  if self.rewardReqs then
    self.rewardReqs:Destroy()
    self.rewardReqs = nil
  end
  self.activityId = nil
  self.data = nil
  self.inDigging = nil
  self.canDigNum = nil
  self.isBoxActOpen = nil
  self.boxActData = nil
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self:SendGetDigTreasureInfoMsg()
  self:UpdatePreviewState()
end

function DispatchTreasure:JudgeCanDig(num, callBack)
  if self.isBoxActOpen then
    local nowScore = DataCenter.DigTreasureBoxRewardManager:GetBoxRewardItemCount()
    local max = DataCenter.DigTreasureBoxRewardManager:GetMaxNum()
    if max < nowScore + 50 * num then
      local param = {
        contentText = Localization:GetString("Treasure_map_72"),
        btnNum = 2,
        confirmBtnParam = {action = callBack}
      }
      UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.DiggingTreasureConfirmTip, param)
      return
    end
  end
  callBack()
end

function DispatchTreasure:SendDiggingMessage(times)
  self.inDigging = true
  self:RefreshDigBtn()
  local digType = (self.isDigActOpen or self.isBoxActOpen) and SplinterExchangeType.DigTreasure.Id or SplinterExchangeType.DispatchTreasure.Id
  if DataCenter.ActDispatchTreasureManager.selectSkip then
    SFSNetwork.SendMessage(MsgDefines.DispatchDigTreasure, digType, times)
  else
    self.fragMrEffect:SetActive(true)
    TimerManager:GetInstance():DelayInvoke(function()
      if self.fragBtn8 then
        TimerManager:GetInstance():DelayInvoke(function()
          if self.CurveAnimNode then
            self.fragBtn8:SetActive(true)
            self.CurveAnimNode:SetActive(true)
            self.CurveAnimNode:ShowCurveAnim(function()
              SFSNetwork.SendMessage(MsgDefines.DispatchDigTreasure, digType, times)
            end)
          end
        end, 0.5)
      end
    end, 0.5)
  end
end

local function OnClickDiggingBtn(self)
  if self.canDigNum > 0 and not self.inDigging then
    self:JudgeCanDig(1, function()
      self:SendDiggingMessage(1)
    end)
  else
    UIUtil.ShowTipsId("Treasure_map_23")
  end
end

local function OnClickExchangeBtn(self)
  if self.isDigActOpen or self.isBoxActOpen then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISplinterExchange, {anim = true}, SplinterExchangeType.DigTreasure.Id, 1)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISplinterExchange, {anim = true}, SplinterExchangeType.DispatchTreasure.Id, 1)
  end
end

function DispatchTreasure:RefreshBoxAct()
  self:RefreshDigActState()
  self:Refresh()
end

local function Refresh(self)
  if self.inDigging then
    return
  end
  if not DataCenter.ActDispatchTreasureManager:IsHaveFragGoodsIdList() then
    return
  end
  local fragItems
  if self.isDigActOpen then
    self.FragDigContent:SetActive(true)
    self.FragContent:SetActive(false)
    self.boxContent.gameObject:SetActive(false)
    fragItems = self.fragDigItems
    self.rawImgBg:LoadSprite(string.format(LoadPath.UIDisPatchTreasureBannerPath, "FX_S3_xiusaiqi_jidongduiwabao_BG3_banner"))
  elseif self.isBoxActOpen then
    self.FragDigContent:SetActive(true)
    self.FragContent:SetActive(false)
    self.CountDownObj.gameObject:SetActive(false)
    fragItems = self.fragDigItems
    self.rawImgBg:LoadSprite(string.format(LoadPath.UIDisPatchTreasureBannerPath, "FX_S3_xiusaiqi_jidongduiwabao_BG3_banner"))
    self.btnOpenDigTreasure.gameObject:SetActive(false)
    self.boxContent.gameObject:SetActive(true)
    self:UpdateOffSeasonBoxReward()
  else
    self.FragDigContent:SetActive(false)
    self.FragContent:SetActive(true)
    self.boxContent.gameObject:SetActive(false)
    fragItems = self.fragItems
    self.rawImgBg:LoadSprite(string.format(LoadPath.UIDisPatchTreasureBannerPath, "FX_WB_bg_New"))
  end
  self.fragBtn8:SetActive(false)
  self.fragDigBtn8:SetActive(false)
  self.fragMrEffect:SetActive(false)
  self.SelectImg:SetActive(DataCenter.ActDispatchTreasureManager.selectSkip)
  for i = 1, #fragItems do
    local num = DataCenter.ActDispatchTreasureManager:GetGoodsCountByIndex(i)
    fragItems[i]:SetData(DataCenter.ActDispatchTreasureManager:GetGoodsIdByIndex(i), num)
  end
  self:RefreshDigBtn()
  self.ProgressText:SetText(Localization:GetString("Treasure_map_03"))
  DataCenter.ActDispatchTreasureManager:SetDayFirstIsShow()
  self:RefreshDiggingRedPoint()
  self:RefreshExchangeRedPoint(SplinterExchangeType.DispatchTreasure.Id)
  self:RefreshDigDispathNum()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.Refresh)
  self:AddUIListener(EventId.DispatchTreasureRefreshDigRedPoint, self.RefreshDiggingRedPoint)
  self:AddUIListener(EventId.SplinterRefreshExchangeRedPoint, self.RefreshExchangeRedPoint)
  self:AddUIListener(EventId.DispatchTreasureDigReward, self.ShowRewardView)
  self:AddUIListener(EventId.DigTreasureUpdateActivityData, self.OnDigActDataUpdate)
  self:AddUIListener(EventId.OnDispatchTreasureRewardEscClose, self.OnEscCloseRewardPanel)
  self:AddUIListener(EventId.TreasureBoxRewardActRefresh, self.RefreshBoxAct)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.Refresh)
  self:RemoveUIListener(EventId.DispatchTreasureRefreshDigRedPoint, self.RefreshDiggingRedPoint)
  self:RemoveUIListener(EventId.SplinterRefreshExchangeRedPoint, self.RefreshExchangeRedPoint)
  self:RemoveUIListener(EventId.DispatchTreasureDigReward, self.ShowRewardView)
  self:RemoveUIListener(EventId.DigTreasureUpdateActivityData, self.OnDigActDataUpdate)
  self:RemoveUIListener(EventId.OnDispatchTreasureRewardEscClose, self.OnEscCloseRewardPanel)
  self:RemoveUIListener(EventId.TreasureBoxRewardActRefresh, self.RefreshBoxAct)
  base.OnRemoveListener(self)
end

local function ClickTip(self)
  if self.isBoxActOpen then
    if self.boxActData == nil then
      self.boxActData = DataCenter.DigTreasureManager:GetNewActivityData()
    end
    if self.boxActData and not table.IsNullOrEmpty(self.boxActData.howtoplay) and self.boxActData.story ~= nil then
      local param = {}
      param.howToPlayList = self.boxActData.howtoplay
      param.story = self.boxActData.story
      param.defaultTitle = self.boxActData.name
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
      return
    end
  end
  if DataCenter.DigTreasureManager:IsActivityOpen() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 1520)
    return
  end
  if self.data and not table.IsNullOrEmpty(self.data.howtoplay) and self.data.story ~= nil then
    local param = {}
    param.howToPlayList = self.data.howtoplay
    param.story = self.data.story
    param.defaultTitle = self.data.name
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
    return
  end
  if self.data ~= nil and self.data.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.data.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

local function RefreshDiggingRedPoint(self)
  self.DiggingRedPoint:SetDefaultVisible(DataCenter.ActDispatchTreasureManager:GetDigRedPoint())
  self.DiggingTenRedPoint:SetDefaultVisible(DataCenter.ActDispatchTreasureManager:GetCanDigCount() > 1)
end

local function RefreshExchangeRedPoint(self, type)
  if type == SplinterExchangeType.DispatchTreasure.Id then
    self.ExchangeRePoint:SetActive(DataCenter.ActDispatchTreasureManager:GetExchangeLogRedPoint())
  end
end

local function CheckPlot(self)
  if not DataCenter.ActDispatchTreasureManager.isShowPlot then
    DataCenter.ActDispatchTreasureManager:ShowPlot()
  end
end

local function DelayOpenRewardView(self, message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  if message.times and message.times > 1 then
    TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.TreasureTenRewardPanelView, {anim = true}, message, function()
        if self and self.DiggingBtn then
          self.inDigging = false
          self:Refresh()
          if message.boxArray and #message.boxArray > 0 then
            EventManager:GetInstance():Broadcast(EventId.TreasureBoxRewardAni, message.boxArray)
          end
        end
      end)
    end, 0.2)
  else
    TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTreasureReward, {anim = true}, message, function()
        if self and self.DiggingBtn then
          self.inDigging = false
          self:Refresh()
          if message.boxArray and #message.boxArray > 0 then
            EventManager:GetInstance():Broadcast(EventId.TreasureBoxRewardAni, message.boxArray)
          end
        end
      end)
    end, 0.2)
  end
end

local function ShowRewardView(self, message)
  self.CurveAnimNode:SetActive(false)
  if message and message.reward then
    self:DelayOpenRewardView(message)
  else
    self.inDigging = false
    self:Refresh()
  end
  self:RefreshDigDispathNum()
  EventManager:GetInstance():Broadcast(EventId.DispatchTreasureRefreshTabRedPoint)
end

local function RefreshDigDispathNum(self)
  self.digDispathNum = DataCenter.ActivityListDataManager:GetExtraData(DIG_DISPATCH_GUARANTEE_NUM, 0)
  local percent = Mathf.Clamp01(self.digDispathNum / self.digMaxNum)
  self.DigSlider:SetValue(percent)
  local colorStr = self.digDispathNum == self.digMaxNum and "5FEF87" or "FFFFFF"
  self.DigPercentTxt:SetText(string.format("<color=#%s>%s</color>/%s", colorStr, self.digDispathNum, self.digMaxNum))
end

local function OnDigDispatchBtnClick(self)
  local param = UICommonTipsView.ParamDataClass.New()
  local digDispathNum = DataCenter.ActivityListDataManager:GetExtraData(DIG_DISPATCH_GUARANTEE_NUM, 0)
  if digDispathNum >= self.digMaxNum then
    param.content = Localization:GetString("Treasure_map_61")
  else
    param.content = Localization:GetString("Treasure_map_60", Mathf.Max(0, self.digMaxNum - digDispathNum))
  end
  param.position = self.DigSlider:GetPosition()
  param.deltaY = 50
  param.contentX = -20
  param.exe = {}
  param.exe.reversal = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonTips, {anim = false}, param)
end

local function RefreshDigBtn(self)
  self.canDigNum = DataCenter.ActDispatchTreasureManager:GetCanDigCount()
  local count = self.canDigNum
  if 10 < count then
    count = 10
  elseif count <= 1 then
    count = 2
  end
  self.btnTenText:SetLocalText("Treasure_map_63", count)
  local canClick = self.canDigNum > 0 and not self.inDigging
  CS.UIGray.SetGray(self.DiggingBtn.transform, not canClick, canClick)
  local canTenClick = self.canDigNum > 1 and not self.inDigging
  CS.UIGray.SetGray(self.btnTen.transform, not canTenClick, canTenClick)
end

local function SendGetDigTreasureInfoMsg(self)
  if self.isDigActOpen then
    SFSNetwork.SendMessage(MsgDefines.DigTreasureGameInfo)
  end
  if self.isBoxActOpen then
    DataCenter.DigTreasureBoxRewardManager:SendMainBoxRewardUIMessage()
  end
end

local function Update1000MS(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.isDigPreviewActOpen then
    local previewEndTime = DataCenter.DigTreasureManager:GetDigTreasurePreviewActEndTime()
    local previewLeftTime = previewEndTime - curTime
    if previewLeftTime < 0 then
      self.isDigPreviewActOpen = nil
      self.actPreviewTrans.gameObject:SetActive(false)
      self:RefreshDigActState()
    else
      self.textPreviewCountDown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, previewLeftTime)))
    end
  end
  if not self.isDigActOpen then
    return
  end
  local endTime = DataCenter.DigTreasureManager:GetActivityResetTime()
  if not endTime then
    return
  end
  local leftTime = endTime - curTime
  if leftTime <= 0 then
    self:RefreshDigActState()
    return
  end
  self.textCountDown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, leftTime)))
end

local function RefreshDigActState(self)
  self.isDigActOpen = DataCenter.DigTreasureManager:IsActivityOpen()
  self.isBoxActOpen = DataCenter.DigTreasureManager:IsNewActivityOpen()
  self:SendGetDigTreasureInfoMsg()
end

local function OnDigActDataUpdate(self)
  self:Update1000MS()
  self:Refresh()
  self:RefreshDigTreasureLayer()
end

local function RefreshDigTreasureLayer(self)
  local curLayerNum = DataCenter.DigTreasureManager:GetCurLayer()
  local maxLayerNum = DataCenter.DigTreasureManager:GetMaxLayer()
  local str = Localization:GetString("treasure_map_UI_01")
  local text = string.format("%s (%s/%s)", str, curLayerNum, maxLayerNum)
  self.textDigDesc:SetText(text)
end

local function OnClickPreviewBtn(self)
  if self.isBoxActOpen then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTreasureGetBoxReward, {anim = true}, TreasureRewardType.BoxRewardAct)
  elseif self.isDigActOpen then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTreasureGetBoxReward, {anim = true}, TreasureRewardType.MapNew)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTreasureGetBoxReward, {anim = true}, TreasureRewardType.Map)
  end
end

local function OnEscCloseRewardPanel(self)
  if self and self.DiggingBtn then
    self.inDigging = false
    self:Refresh()
  end
end

local function UpdateOffSeasonBoxReward(self)
  if self.rewardReqs == nil then
    self.rewardReqs = self:GameObjectInstantiateAsync(UIAssets.OffSeasonTreasureBoxRewardPath, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local nameStr = "OffSeasonTreasureBoxReward"
      go.name = nameStr
      go:SetActive(true)
      local transform = go.transform
      transform:SetParent(self.boxContent.transform)
      transform:Set_localScale(1, 1, 1)
      transform:Set_pivot(0, 1)
      local item = self.boxContent:AddComponent(OffSeasonTreasureBoxReward, nameStr)
      item:ReInit(nil, true)
      self.offSeasonBoxReward = item
    end)
  end
end

function DispatchTreasure:BtnTenReward()
  if self.canDigNum > 1 and not self.inDigging then
    local times = self.canDigNum
    if 10 < times then
      times = 10
    end
    self:JudgeCanDig(times, function()
      self:SendDiggingMessage(times)
    end)
  else
    UIUtil.ShowTipsId("Treasure_map_23")
  end
end

function DispatchTreasure:UpdatePreviewState()
  self.isDigPreviewActOpen = DataCenter.DigTreasureManager:IsActPreviewOpen()
  if not table.IsNullOrEmpty(self.isDigPreviewActOpen) and not string.IsNullOrEmpty(self.isDigPreviewActOpen.activityId) then
    local para = LocalController:instance():getValue(TableName.Activity, self.isDigPreviewActOpen.activityId, "para")
    if not string.IsNullOrEmpty(para) then
      self.actPreviewIcon:LoadSpriteAsyncWithCallback(para, function(sprite)
        if self.actPreviewIcon then
          self.actPreviewIcon:SetNativeSize()
        end
      end)
    end
  end
  self.actPreviewTrans.gameObject:SetActive(self.isDigPreviewActOpen ~= nil)
end

DispatchTreasure.OnCreate = OnCreate
DispatchTreasure.OnDestroy = OnDestroy
DispatchTreasure.OnEnable = OnEnable
DispatchTreasure.OnDisable = OnDisable
DispatchTreasure.ComponentDefine = ComponentDefine
DispatchTreasure.ComponentDestroy = ComponentDestroy
DispatchTreasure.DataDefine = DataDefine
DispatchTreasure.DataDestroy = DataDestroy
DispatchTreasure.SetData = SetData
DispatchTreasure.OnClickDiggingBtn = OnClickDiggingBtn
DispatchTreasure.OnClickExchangeBtn = OnClickExchangeBtn
DispatchTreasure.Refresh = Refresh
DispatchTreasure.OnAddListener = OnAddListener
DispatchTreasure.OnRemoveListener = OnRemoveListener
DispatchTreasure.ClickTip = ClickTip
DispatchTreasure.RefreshDiggingRedPoint = RefreshDiggingRedPoint
DispatchTreasure.RefreshExchangeRedPoint = RefreshExchangeRedPoint
DispatchTreasure.CheckPlot = CheckPlot
DispatchTreasure.ShowRewardView = ShowRewardView
DispatchTreasure.RefreshDigBtn = RefreshDigBtn
DispatchTreasure.DelayOpenRewardView = DelayOpenRewardView
DispatchTreasure.RefreshDigDispathNum = RefreshDigDispathNum
DispatchTreasure.OnDigDispatchBtnClick = OnDigDispatchBtnClick
DispatchTreasure.SendGetDigTreasureInfoMsg = SendGetDigTreasureInfoMsg
DispatchTreasure.Update1000MS = Update1000MS
DispatchTreasure.OnDigActDataUpdate = OnDigActDataUpdate
DispatchTreasure.RefreshDigTreasureLayer = RefreshDigTreasureLayer
DispatchTreasure.OnClickPreviewBtn = OnClickPreviewBtn
DispatchTreasure.RefreshDigActState = RefreshDigActState
DispatchTreasure.OnEscCloseRewardPanel = OnEscCloseRewardPanel
DispatchTreasure.UpdateOffSeasonBoxReward = UpdateOffSeasonBoxReward
return DispatchTreasure
