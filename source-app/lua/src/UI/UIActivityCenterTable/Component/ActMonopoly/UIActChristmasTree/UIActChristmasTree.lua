local UIActChristmasTree = BaseClass("UIActChristmasTree", UIBaseView)
local base = UIBaseView
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local UIActChristmasTreeTimeLine = require("UI.UIActivityCenterTable.Component.ActMonopoly.UIActChristmasTree.UIActChristmasTreeTimeLine")
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local timeLineImg_path = "centerContentMask/centerContent/timeLineImgMask/timeLineImg"
local eff_ui_chunjie_yanhua_huang_path = "BgMask/Bg1/Eff_ui_chunjie_yanhua_huang"
local entrance_btn_path = "EntranceBtn"
local entrance_btn_image_path = "EntranceBtn/EntranceBtnImage"
local entrance_btn_text_path = "EntranceBtn/EntranceBtnText"
local entrance_effect_node_path = "EntranceBtn/EntranceEffectNode"
local open_time_path = "RightView/Top/TimeContent/openTime"

function UIActChristmasTree:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActChristmasTree:OnDestroy()
  self:ClearAllItem()
  self:DeleteTimer()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIActChristmasTree:OnEnable()
  base.OnEnable(self)
end

function UIActChristmasTree:OnDisable()
  base.OnDisable(self)
  self:StopAnim()
  DataCenter.ArrowManager:RemoveArrow()
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self.timeLineImg:EndTimeLine()
end

function UIActChristmasTree:ComponentDefine()
  self._bg_img_mask = self:AddComponent(UIRawImage, "BgMask/Bg1")
  self.boxGoft1 = self:AddComponent(UIButton, "centerContentMask/centerContent/boxGiftContent/boxGoft1")
  self.boxGoft2 = self:AddComponent(UIButton, "centerContentMask/centerContent/boxGiftContent/boxGoft2")
  self.boxGoft3 = self:AddComponent(UIButton, "centerContentMask/centerContent/boxGiftContent/boxGoft3")
  self.boxGoft4 = self:AddComponent(UIButton, "centerContentMask/centerContent/boxGiftContent/boxGoft4")
  self.boxGoft5 = self:AddComponent(UIButton, "centerContentMask/centerContent/boxGiftContent/boxGoft5")
  self.boxGoftList = {
    self.boxGoft1,
    self.boxGoft2,
    self.boxGoft3,
    self.boxGoft4,
    self.boxGoft5
  }
  for i = 1, #self.boxGoftList do
    local index = i
    self.boxGoftList[index]:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnBoxGoftBtnClick(index)
    end)
  end
  self.boxGoftEffect1 = self:AddComponent(UIBaseContainer, "centerContentMask/centerContent/boxGiftContent/boxGoft1/boxGoft1Effect")
  self.boxGoftEffect2 = self:AddComponent(UIBaseContainer, "centerContentMask/centerContent/boxGiftContent/boxGoft2/boxGoft2Effect")
  self.boxGoftEffect3 = self:AddComponent(UIBaseContainer, "centerContentMask/centerContent/boxGiftContent/boxGoft3/boxGoft3Effect")
  self.boxGoftEffect4 = self:AddComponent(UIBaseContainer, "centerContentMask/centerContent/boxGiftContent/boxGoft4/boxGoft4Effect")
  self.boxGoftEffect5 = self:AddComponent(UIBaseContainer, "centerContentMask/centerContent/boxGiftContent/boxGoft5/boxGoft5Effect")
  self.boxGoftEffectList = {
    self.boxGoftEffect1,
    self.boxGoftEffect2,
    self.boxGoftEffect3,
    self.boxGoftEffect4,
    self.boxGoftEffect5
  }
  for k, v in ipairs(self.boxGoftEffectList) do
    v:SetActive(false)
  end
  self._actName_txt = self:AddComponent(UIText, "RightView/Top/title")
  self.intro_btn = self:AddComponent(UIButton, "RightView/Top/InfoBtn")
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnIntroClick()
  end)
  self.rank_btn = self:AddComponent(UIButton, "RightView/Top/RankBtn")
  self.rank_btn_txt = self:AddComponent(UIText, "RightView/Top/RankBtn/RankBtnText")
  self.rank_btn_txt:SetLocalText(2000232)
  self.rank_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickRank()
  end)
  self.reward_btn = self:AddComponent(UIButton, "RightView/Top/RewardBtn")
  self.reward_btn_txt = self:AddComponent(UIText, "RightView/Top/RewardBtn/RewardBtnText")
  self.reward_btn_txt:SetLocalText(458131)
  self.reward_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickReward()
  end)
  self._donate_btn = self:AddComponent(UIButton, "RightView/Rect_Bottom/DonateBtn")
  self._donate_btn_txt = self:AddComponent(UIText, "RightView/Rect_Bottom/DonateBtn/DonateBtnText")
  self._donate_btn_txt:SetLocalText("thanksactivity_UI034")
  self._donate_btn:SetOnClick(function()
    self:OnClickDonate()
  end)
  self._slider = self:AddComponent(UISlider, "RightView/Top/ScoreSlider")
  self._slider_txt = self:AddComponent(UIText, "RightView/Top/ScoreSlider/ScoreText")
  self._donate_red_dot_rect = self:AddComponent(UIBaseContainer, "RightView/Rect_Bottom/DonateBtn/RedPoint (1)")
  self._box_red_dot_rect = self:AddComponent(UIBaseContainer, "RightView/Top/ScoreBtn/RedPoint")
  self._score_btn = self:AddComponent(UIButton, "RightView/Top/ScoreBtn")
  self._score_btn_txt = self:AddComponent(UIText, "RightView/Top/ScoreBtn/ScoreBtnText")
  self._score_btn:SetOnClick(function()
    self:OnClickScore()
  end)
  self.curScoreText = self:AddComponent(UIText, "RightView/Top/CurScoreText")
  self._banquet_level_txt = self:AddComponent(UIText, "RightView/Rect_Bottom/BanquetLevelText")
  self._slider_effect = self:AddComponent(UIBaseContainer, "RightView/Top/ScoreSlider/Fill Area/Fill/Eff_ui_ganenjie_jindutiao_faguang")
  self._slider_effect_particle = self._slider_effect.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self._slider_effect:SetActive(false)
  self._open_tip_txt = self:AddComponent(UIText, "RightView/Top/OpenTipText")
  self._desc_tip_txt = self:AddComponent(UIText, "RightView/Rect_Bottom/DescTipText")
  self._desc_tip_txt:SetText("")
  self.itemBar1 = self:AddComponent(UITopItem, "RightView/Top/ItemBar1")
  self.itemBar1:SetData(DataCenter.ActBanquetData.actBanquetTemplate.donate_item_id)
  self.timeLineImg = self:AddComponent(UIActChristmasTreeTimeLine, timeLineImg_path)
  self.rankRewardList = {}
  self.content = self:AddComponent(UIBaseContainer, "RightView/Top/rankRewardShow/rankRewardShowContent")
  self.uiCommonResItem = self:AddComponent(UICommonResItem, "RightView/Top/rankRewardShow/UICommonResItem")
  self.uiCommonResItem:SetActive(false)
  self.uiCommonResItem.gameObject:GameObjectCreatePool()
  self.eff_ui_chunjie_yanhua_huang = self:AddComponent(UIBaseContainer, eff_ui_chunjie_yanhua_huang_path)
  self.eff_ui_chunjie_yanhua_huang:SetActive(false)
  self.entranceBtn = self:AddComponent(UIButton, entrance_btn_path)
  self.entranceBtn:SetActive(false)
  self.entranceBtn:SetOnClick(function()
    self:OnEntranceBtn()
  end)
  self.entranceBtnImage = self:AddComponent(UIImage, entrance_btn_image_path)
  self.entranceBtnText = self:AddComponent(UIText, entrance_btn_text_path)
  self.entranceEffectNode = self:AddComponent(UIBaseContainer, entrance_effect_node_path)
  self.remainText = self:AddComponent(UITextMeshProUGUIEx, open_time_path)
end

function UIActChristmasTree:ClearAllItem()
  self.content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.uiCommonResItem.gameObject:GameObjectRecycleAll()
  self.rankRewardList = {}
end

function UIActChristmasTree:DataDefine()
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  if self.passDayTimer then
    self.passDayTimer:Stop()
    self.passDayTimer = nil
  end
end

function UIActChristmasTree:DataDestroy()
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  if self.passDayTimer then
    self.passDayTimer:Stop()
    self.passDayTimer = nil
  end
  self.remainText = nil
end

function UIActChristmasTree:OnFreeRewardReceive()
  self:RefreshTopItem()
end

function UIActChristmasTree:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBanquetCloseScoreDetail, self.OnCloseScoreDetail)
  self:AddUIListener(EventId.GetActBanquetDetailInfo, self.OnRefresh)
  self:AddUIListener(EventId.ActBanquetScoreRewardReceive, self.OnGetScoreRewardMsg)
  self:AddUIListener(EventId.OnBanquetDonate, self.OnDonateSuccess)
  self:AddUIListener(EventId.ActFreeRewardReceive, self.OnFreeRewardReceive)
  self:AddUIListener(EventId.OnRecSkinPartyList, self.OnRecSkinPartyList)
  self:AddUIListener(EventId.RefreshSkinPartyList, self.OnRecSkinPartyList)
  self:AddUIListener(EventId.RemindChristmasTreeDonate, self.ShowArrow)
end

function UIActChristmasTree:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBanquetCloseScoreDetail, self.OnCloseScoreDetail)
  self:RemoveUIListener(EventId.GetActBanquetDetailInfo, self.OnRefresh)
  self:RemoveUIListener(EventId.ActBanquetScoreRewardReceive, self.OnGetScoreRewardMsg)
  self:RemoveUIListener(EventId.OnBanquetDonate, self.OnDonateSuccess)
  self:RemoveUIListener(EventId.ActFreeRewardReceive, self.OnFreeRewardReceive)
  self:RemoveUIListener(EventId.OnRecSkinPartyList, self.OnRecSkinPartyList)
  self:RemoveUIListener(EventId.RefreshSkinPartyList, self.OnRecSkinPartyList)
  self:RemoveUIListener(EventId.RemindChristmasTreeDonate, self.ShowArrow)
end

function UIActChristmasTree:OnFreeRewardReceive()
  self:RefreshRedPoint()
end

local function StartPassDayTimer(self)
  if self.passDayTimer then
    self.passDayTimer:Stop()
  end
  local remainTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
  local delayS = remainTimeS + 1
  self.passDayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnPassDay()
  end, delayS)
end

function UIActChristmasTree:SetData(activityId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.activityId = activityId
  self.actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyInfo, tonumber(activityId))
  self:SetConstTxt()
  StartPassDayTimer(self)
  self.timeLineImg:StartTimeLine()
  self.eff_ui_chunjie_yanhua_huang:SetActive(false)
  local bannerName = self.actListData.activity_pic
  if not string.IsNullOrEmpty(bannerName) then
    local bannerPath = string.format(UIAssets.UIActMonopolyTexturePath, bannerName)
    self._bg_img_mask:LoadSprite(bannerPath)
  end
  self:OnRefresh()
  self:InitEntranceBtn()
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = false
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
end

function UIActChristmasTree:OnRefresh()
  self.actBanquetId = DataCenter.ActBanquetData.actBanquetId
  if self.actListData then
    self:RefreshTime(self.actListData)
    self:AddTimer(self.actListData)
    self:RefreshBanquetLevel(true)
    self:RefreshTitle(self.actListData)
    self:ShowScore(false)
    self:RefreshOpenTips()
    self:RefreshRedPoint()
    self:RefreshTopItem()
    self:RefreshRankRewardShow()
    self:RefreshDescTip()
  end
end

function UIActChristmasTree:RefreshRankRewardShow()
  self:ClearAllItem()
  local rank_reward_show_list = DataCenter.ActBanquetData.actBanquetTemplate.rank_reward_show_list
  for k, v in ipairs(rank_reward_show_list) do
    local index = k
    local item = self.uiCommonResItem.gameObject:GameObjectSpawn(self.content.transform)
    item.name = index
    local obj = self.content:AddComponent(UICommonResItem, item.name)
    obj:SetActive(true)
    obj:ReInit(v)
    obj:SetImgQuailtyShow(false)
    obj:SetItemCountActive(false)
    self.rankRewardList[index] = obj
  end
end

function UIActChristmasTree:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function UIActChristmasTree:RefreshTime(actListData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if actListData then
    if curTime > actListData.endTime then
      self:DeleteTimer()
      self.remainText:SetLocalText(2000409)
      UIUtil.ShowMessage(Localization:GetString("370100"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        EventManager:GetInstance():Broadcast(EventId.ActThanksGivingTimeEnd)
      end, nil, function()
        EventManager:GetInstance():Broadcast(EventId.ActThanksGivingTimeEnd)
      end)
    else
      self.remainText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(actListData.endTime - curTime))
    end
  else
    self:DeleteTimer()
    self.remainText:SetText("")
  end
end

function UIActChristmasTree:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIActChristmasTree:OnCloseScoreDetail()
end

function UIActChristmasTree:OnClickScore()
end

function UIActChristmasTree:OnPassDay()
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyInfo, self.activityId)
end

function UIActChristmasTree:RefreshTitle(actListData)
  self._actName_txt:SetLocalText(actListData.name)
end

function UIActChristmasTree:SetConstTxt()
end

function UIActChristmasTree:RefreshDescTip()
  local extra_desc1 = DataCenter.ActBanquetData.actBanquetTemplate.extra_desc1
  if not string.IsNullOrEmpty(extra_desc1) then
    self._desc_tip_txt:SetLocalText(extra_desc1)
  end
end

function UIActChristmasTree:OnRefreshScore(isAdd, reward)
  self:ShowScore(isAdd, reward)
end

function UIActChristmasTree:ShowScore(isAdd, rewards)
  local score = DataCenter.ActBanquetData:GetActScore()
  local nextTargetScore = DataCenter.ActBanquetData:GetActNextTargetScore()
  local curLevel = DataCenter.ActBanquetData:GetCurBanquetLevel()
  local maxLevel = DataCenter.ActBanquetData:GetBanquetMaxLevel()
  if score then
    self._slider_effect:SetActive(isAdd)
    self._slider_effect_particle:Play()
    if nextTargetScore then
      self._slider_txt:SetText(score .. "/" .. nextTargetScore)
      self._score_btn_txt:SetText(curLevel .. "/" .. maxLevel)
      self.curScoreText:SetLocalText("2000275", curLevel)
      self:StopAnim()
      self.sequence = CS.DG.Tweening.DOTween.Sequence()
      self.sequence:AppendInterval(0.2)
      self.sequence:Append(self._slider:DOValue(score / nextTargetScore, 0.6))
      self.sequence:AppendInterval(0.2)
      self.sequence:AppendCallback(function()
        if rewards then
          DataCenter.RewardManager:ShowCommonReward({reward = rewards})
        end
      end)
    else
      self._slider:SetValue(1)
      self._slider_txt:SetText(score)
      self._score_btn_txt:SetText(maxLevel)
      self.curScoreText:SetLocalText("2000275", maxLevel)
      if rewards then
        DataCenter.RewardManager:ShowCommonReward({reward = rewards})
      end
    end
  end
end

function UIActChristmasTree:StopAnim()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function UIActChristmasTree:OnIntroClick()
  local param = {}
  param.activityRulesStr = Localization:GetString(self.actListData.story, DataCenter.ActBanquetData:GetBanquetAddScore())
  param.activityId = self.activityId
  param.hideSubTile = true
  param.titleLocalText = "302027"
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailCommon, {anim = true}, param)
end

function UIActChristmasTree:OnClickRank()
end

function UIActChristmasTree:OnClickReward()
  if self.activityId then
    local isUse = DataCenter.ActFestivalPopUpManager:CheckActFestivalUseNewSkin(self.activityId, UIWindowNames.UIActChristmasRankAndRewardCommon)
    if isUse then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActChristmasRankAndRewardCommon, {anim = true}, toInt(self.activityId), self.actBanquetId)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActChristmasRankAndReward, {anim = true}, toInt(self.activityId), self.actBanquetId)
    end
  end
end

function UIActChristmasTree:OnClickDonate()
  self.donateItemId = DataCenter.ActBanquetData:GetBanquetDonateItemId()
  local haveCount = DataCenter.ItemData:GetItemCount(self.donateItemId)
  local onceDonateNum = DataCenter.ActBanquetData.actBanquetTemplate.unit_num or 1
  if haveCount < onceDonateNum then
    LWResourceLackUtil:GotoGoodsItemLack(self.donateItemId, 1)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActBanquetDonate, toInt(self.activityId), self.actBanquetId)
  end
end

function UIActChristmasTree:RefreshRedPoint()
  self._box_red_dot_rect:SetActive(DataCenter.ActBanquetData:GetCanGetScoreBoxCount() > 0)
  self.donateItemId = DataCenter.ActBanquetData:GetBanquetDonateItemId()
  local haveCount = DataCenter.ItemData:GetItemCount(self.donateItemId)
  local onceDonateNum = DataCenter.ActBanquetData.actBanquetTemplate.unit_num or 1
  self._donate_red_dot_rect:SetActive(haveCount >= onceDonateNum or DataCenter.ActBanquetData:CanGetFreePack())
end

function UIActChristmasTree:RefreshTopItem()
  self.itemBar1:RefreshData()
end

function UIActChristmasTree:OnDonateSuccess(reward)
  self:RefreshBanquetLevel(false)
  self:OnRefreshScore(true, reward)
  self:RefreshRedPoint()
  self:RefreshTopItem()
end

function UIActChristmasTree:RefreshBanquetLevel(isInit)
  local level = DataCenter.ActBanquetData.banquetLevel
  self._banquet_level_txt:SetText(Localization:GetString("thanksactivity_UI032") .. " " .. level)
  DataCenter.ArrowManager:RemoveArrow()
  local haveAddArrow = false
  local boxDataList = DataCenter.ActBanquetData:GetActScoreList()
  for i = 1, #self.boxGoftList do
    local param = boxDataList[i]
    if param and level >= param.targetLevel - 1 then
      self.boxGoftList[i]:SetActive(true)
      local canGet = false
      if param.state ~= 1 and level >= param.targetLevel then
        canGet = true
      end
      if self.boxGoftEffectList[i] then
        self.boxGoftEffectList[i]:SetActive(canGet)
        if canGet and not haveAddArrow then
          haveAddArrow = true
          local param = {}
          param.position = self.boxGoftEffectList[i].transform.position
          param.arrowType = ArrowType.Normal
          param.positionType = PositionType.Screen
          TimerManager:GetInstance():DelayInvoke(function()
            DataCenter.ArrowManager:ShowArrow(param)
          end, 0.1)
        end
      end
    else
      self.boxGoftList[i]:SetActive(false)
    end
  end
end

function UIActChristmasTree:OnBoxGoftBtnClick(index)
  local level = DataCenter.ActBanquetData.banquetLevel
  local boxDataList = DataCenter.ActBanquetData:GetActScoreList()
  local param = boxDataList[index]
  if param and param.state ~= 1 and level >= param.targetLevel then
    local sendParam = {}
    sendParam.aid = tonumber(self.activityId)
    sendParam.id = DataCenter.ActBanquetData.actBanquetId
    sendParam.level = param.targetLevel
    SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyLevelReward, sendParam)
  else
    local numRight = -30
    local numLeft = 30
    if CommonUtil.IsArabicAutoMirrorOpen() then
      numRight = 30
      numLeft = -30
    end
    local boxObj = self.boxGoftList[index]
    local tipParam = UIPersonalArmsRewardTipView.ParamDataClass.New()
    tipParam.position = boxObj:GetPosition()
    tipParam.dir = tipParam.position.x > -1150 and UIPersonalArmsRewardTipView.Direction.RIGHT or UIPersonalArmsRewardTipView.Direction.LEFT
    tipParam.deltaX = tipParam.dir == UIPersonalArmsRewardTipView.Direction.RIGHT and numRight or numLeft
    tipParam.rewardList = param.reward
    tipParam.closePassClick = true
    if CommonUtil.IsArabicAutoMirrorOpen() then
      if tipParam.dir == UIPersonalArmsRewardTipView.Direction.LEFT then
        tipParam.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
      elseif tipParam.dir == UIPersonalArmsRewardTipView.Direction.RIGHT then
        tipParam.dir = UIPersonalArmsRewardTipView.Direction.LEFT
      end
    end
    if param and param.state ~= 1 then
      local key = "activity_party_reward_tips1"
      tipParam.titleStr = Localization:GetString(key, param.targetLevel)
    else
      local key = "activity_party_reward_tips2"
      tipParam.titleStr = Localization:GetString(key, param.targetLevel)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, tipParam)
  end
end

function UIActChristmasTree:RefreshOpenTips()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local openDays = UITimeManager:GetInstance():GetBetweenDaysForServer(self.actListData.startTime / 1000, curTime / 1000)
  local openDic = DataCenter.ActBanquetData.actBanquetTemplate.open_dic
  for k, v in ipairs(openDic) do
    if k > openDays + 1 then
      local endDayTime = self.actListData.startTime / 1000 + (k - 1) * 86400
      self._open_tip_txt:SetLocalText("thanksactivity_UI065", UITimeManager:GetInstance():SecondToFmtString(endDayTime - curTime / 1000))
      return
    end
  end
  self._open_tip_txt:SetText("")
end

function UIActChristmasTree:Update1000MS()
  self:RefreshOpenTips()
end

function UIActChristmasTree:OnGetScoreRewardMsg()
  self.eff_ui_chunjie_yanhua_huang:SetActive(false)
  self.eff_ui_chunjie_yanhua_huang:SetActive(true)
  self:OnRefresh()
end

function UIActChristmasTree:InitEntranceBtn()
  local entranceShow = tonumber(DataCenter.ActBanquetData.actBanquetTemplate.concert_entrance) == 1
  self.entranceBtn:SetActive(entranceShow)
  if not entranceShow then
    return
  end
  local entranceName = DataCenter.ActBanquetData.actBanquetTemplate.concert_entrance_name
  local entranceIcon = DataCenter.ActBanquetData.actBanquetTemplate.concert_entrance_icon
  if not string.IsNullOrEmpty(entranceIcon) then
    self.entranceBtnImage:LoadSprite(entranceIcon)
  end
  if not string.IsNullOrEmpty(entranceName) then
    self.entranceBtnText:SetLocalText(entranceName)
  end
  local entrancePrefab = DataCenter.ActBanquetData.actBanquetTemplate.concert_entrance_prefab
  if entrancePrefab and not string.IsNullOrEmpty(entrancePrefab) then
    local request = ResourceManager:InstantiateAsync(entrancePrefab)
    request:completed("+", function()
      if request.isError or IsNull(self.entranceEffectNode) then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.entranceEffectNode.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      self.entranceEffect = go
      self.entranceEffect:SetActive(false)
      if not CrossServerUtil:NeedIntercept() then
        DataCenter.ActConcertDataManager:RequestSkinPartyList(self.activityId)
      end
    end)
    self.request = request
  elseif not CrossServerUtil:NeedIntercept() then
    DataCenter.ActConcertDataManager:RequestSkinPartyList(self.activityId)
  end
end

function UIActChristmasTree:OnEntranceBtn()
  if CrossServerUtil:NeedIntercept(458585) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWActConcertList, {anim = true}, self.activityId)
end

function UIActChristmasTree:OnRecSkinPartyList()
  if not self.entranceEffect then
    return
  end
  local partyList = DataCenter.ActConcertDataManager:GetConcertList()
  if partyList and table.length(partyList) > 0 then
    self.entranceEffect:SetActive(false)
    self.entranceEffect:SetActive(true)
  else
    self.entranceEffect:SetActive(false)
  end
end

function UIActChristmasTree:ShowArrow()
  local param = {}
  param.position = self._donate_btn.transform.position
  param.position.y = param.position.y + 10
  param.arrowType = ArrowType.Normal
  param.positionType = PositionType.Screen
  param.isAutoClose = 2
  DataCenter.ArrowManager:ShowArrow(param)
end

return UIActChristmasTree
