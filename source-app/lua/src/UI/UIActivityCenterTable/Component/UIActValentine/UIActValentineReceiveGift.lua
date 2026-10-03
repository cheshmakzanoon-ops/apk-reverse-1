local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ResourceManager = CS.GameEntry.Resource
local UIActValentineReceiveGift = BaseClass("UIActValentineReceiveGift", base)
local BoxItem = require("UI.UIActivityCenterTable.Component.UIActValentine.Component.ValentineSmallGiftItemComponent")
local StarInfoItem = require("UI.UIActivityCenterTable.Component.UIActValentine.Component.ValentineStarItemComponent")
local RewardItem = require("UI.UIActivityCenterTable.Component.UIActValentine.Component.ValentineRewardItemComponent")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local txt_act_name_path = "Root/rect/BaseInfo/Txt_ActName"
local remain_time_text_path = "Root/rect/BaseInfo/RemainTimeContent/RemainTimeText"
local intro_btn_path = "Root/rect/BaseInfo/IntroBtn"
local rank_text_path = "Root/rect/TopArea/RankIconInfo/RankText"
local rank_img_path = "Root/rect/TopArea/RankIconInfo/RankIcon/RankRewardBtn/RankImg"
local progress_slider_path = "Root/rect/TopArea/ProgressInfo/ProgressSlider"
local progress_text_path = "Root/rect/TopArea/ProgressInfo/ProgressSlider/ProgressText"
local valentine_small_gift_item_path = "Root/rect/BottomArea/GiftBoxList/Viewport/Content/ValentineSmallGiftItem"
local content_path = "Root/rect/BottomArea/GiftBoxList/Viewport/Content"
local open_box_btn_path = "Root/rect/MiddleArea/OpenBoxBtn"
local open_box_btn_text_path = "Root/rect/MiddleArea/OpenBoxBtn/LW_Btn_Common_New_Base/OpenBoxBtnText"
local rank_reward_content_path = "Root/rect/TopArea/RankRewardInfo/Scroll View/Viewport/RankRewardContent"
local valentine_reward_item_path = "Root/rect/TopArea/RankRewardInfo/Scroll View/Viewport/RankRewardContent/ValentineRewardItem"
local chest_btn_path = "Root/rect/MiddleArea/ChestInfoBtn"
local get_rank_reward_btn_path = "Root/rect/TopArea/RankRewardInfo/GetRankRewardBtn"
local valentine_star_item_path = "Root/rect/TopArea/RankIconInfo/ValentineStarItem"
local star_chest_btn_path = "Root/rect/TopArea/ProgressInfo/StarChestBtn"
local star_red_dot_path = "Root/rect/TopArea/ProgressInfo/StarChestBtn/StarRedDot"
local star_box_num_text_path = "Root/rect/TopArea/ProgressInfo/StarChestBtn/StarRedDot/StarBoxNumText"
local frag_box_icon_img_path = "Root/rect/BottomArea/CurFragProgressInfo/FragBoxIconImg"
local frag_item_icon_path = "Root/rect/BottomArea/CurFragProgressInfo/layout/FragItemIcon"
local cur_frag_item_num_text_path = "Root/rect/BottomArea/CurFragProgressInfo/layout/CurFragItemNumText"
local frag_box_progress_img_path = "Root/rect/BottomArea/CurFragProgressInfo/FragBoxProgressImg"
local cur_frag_progress_info_path = "Root/rect/BottomArea/CurFragProgressInfo"
local next_chest_btn_path = "Root/rect/MiddleArea/NextChestBtn"
local prev_chest_btn_path = "Root/rect/MiddleArea/PrevChestBtn"
local rank_reward_text_path = "Root/rect/TopArea/RankRewardInfo/RankRewardText"
local box_cover_path = "Root/rect/MiddleArea/Chest/Box/BoxCover"
local box_path = "Root/rect/MiddleArea/Chest/Box"
local record_btn_path = "Root/rect/TopArea/RecordBtn"
local rank_btn_path = "Root/rect/TopArea/RankBtn"
local eff_ui_zone_saoguang_long_path = "Root/rect/TopArea/ProgressInfo/ProgressSlider/Fill Area/Fill/Eff_ui_Zone_saoguang_long"
local rank_reward_btn_path = "Root/rect/TopArea/RankIconInfo/RankIcon/RankRewardBtn"
local eff_ui_deco_shengji_trail_path = "Root/rect/ballEffRoot/Eff_ui_valentine_trail_normal"
local eff_ui_valentine_trail_special_path = "Root/rect/ballEffRoot/Eff_ui_valentine_trail_special"
local chest_path = "Root/rect/MiddleArea/Chest"
local share_btn_path = "Root/rect/TopArea/RankIconInfo/ShareBtn"
local record_text_path = "Root/rect/TopArea/RankBtn/RecordText"
local count_down_image_path = "Root/rect/TopArea/RankBtn/CountDownImage"
local rank_image_path = "Root/rect/TopArea/RankBtn/RankImage"
local count_down_text_path = "Root/rect/TopArea/RankBtn/CountDownText"
local frag_item_red_path = "Root/rect/BottomArea/CurFragProgressInfo/FragItemRed"
local star_chest_img_normal_path = "Root/rect/TopArea/ProgressInfo/StarChestBtn/StarChestImg_Normal"
local star_chest_img_full_path = "Root/rect/TopArea/ProgressInfo/StarChestBtn/StarChestImg_Full"
local reward_point_path = "Root/rect/TopArea/RankRewardInfo/Scroll View/Viewport/RankRewardContent/RewardPoint"
local progress_fly_point_path = "Root/rect/TopArea/ProgressInfo/ProgressSlider/ProgressFlyPoint"
local SINGLE_EXP_ANI_DURATION = 0.7
local FRAG_ITEM_NUM_ROLL_DURATION = 1.5
local SEGMENT_COUNT = 20
local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SEGMENT_COUNT)
local EFF_BALL_FLY_DURATION = 1
local Eff_BALL_TYPE = {NORMAL = 1, SPECIAL = 2}

function UIActValentineReceiveGift:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActValentineReceiveGift:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIActValentineReceiveGift:OnEnable()
  base.OnEnable(self)
end

function UIActValentineReceiveGift:OnDisable()
  base.OnDisable(self)
  if self.boxOpenSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.boxOpenSoundHandle)
    self.boxOpenSoundHandle = nil
  end
  if self.showExpBallFlySoundHandle then
    DataCenter.LWSoundManager:StopSound(self.showExpBallFlySoundHandle)
    self.showExpBallFlySoundHandle = nil
  end
  if self.selectGiftSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.selectGiftSoundHandle)
    self.selectGiftSoundHandle = nil
  end
  if self.rankUpgradeSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.rankUpgradeSoundHandle)
    self.rankUpgradeSoundHandle = nil
  end
end

function UIActValentineReceiveGift:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ValentineGetActivityReceiveData, self.OnActivityReceiveDataUpdate)
  self:AddUIListener(EventId.RefreshItems, self.OnItemDataUpdate)
  self:AddUIListener(EventId.ValentineReceiveRankReward, self.RefreshRewardInfo)
  self:AddUIListener(EventId.ValentineReceiveStarReward, self.RefreshRewardInfo)
  self:AddUIListener(EventId.ValentineReceiveBoxChipReward, self.OnReceiveFragReward)
  self:AddUIListener(EventId.ValentineReceiveChampionRewardData, self.GetChampionRewardData)
  self:AddUIListener(EventId.ValentineSuccessGetChampionReward, self.CheckChampionRewardViewPop)
  self:AddUIListener(EventId.UIMainFlyReward, self.PlayRewardFlyToTarget)
  self:AddUIListener(EventId.ValentinePlayFlyRewardAni, self.PlayRewardFlyToTarget)
end

function UIActValentineReceiveGift:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ValentineGetActivityReceiveData, self.OnActivityReceiveDataUpdate)
  self:RemoveUIListener(EventId.RefreshItems, self.OnItemDataUpdate)
  self:RemoveUIListener(EventId.ValentineReceiveRankReward, self.RefreshRewardInfo)
  self:RemoveUIListener(EventId.ValentineReceiveStarReward, self.RefreshRewardInfo)
  self:RemoveUIListener(EventId.ValentineReceiveBoxChipReward, self.OnReceiveFragReward)
  self:RemoveUIListener(EventId.ValentineReceiveChampionRewardData, self.GetChampionRewardData)
  self:RemoveUIListener(EventId.ValentineSuccessGetChampionReward, self.CheckChampionRewardViewPop)
  self:RemoveUIListener(EventId.UIMainFlyReward, self.PlayRewardFlyToTarget)
  self:RemoveUIListener(EventId.ValentinePlayFlyRewardAni, self.PlayRewardFlyToTarget)
end

function UIActValentineReceiveGift:ComponentDefine()
  self.txt_act_name = self:AddComponent(UIText, txt_act_name_path)
  self.txt_times = self:AddComponent(UIText, remain_time_text_path)
  self.infoBtn = self:AddComponent(UIButton, intro_btn_path)
  self.infoBtn:SetOnClick(function()
    self:OnIntroClick()
  end)
  self.rankTitleText = self:AddComponent(UIText, rank_text_path)
  self.rankImg = self:AddComponent(UIRawImage, rank_img_path)
  self.progressSlider = self:AddComponent(UISlider, progress_slider_path)
  self.progressText = self:AddComponent(UIText, progress_text_path)
  self.boxContent = self:AddComponent(UIBaseContainer, content_path)
  self.boxItemObj = self:AddComponent(UIBaseContainer, valentine_small_gift_item_path)
  self.boxItemObj.gameObject:GameObjectCreatePool()
  self.simpleAni = self:AddComponent(UISimpleAnimation, "")
  self.openBoxBtn = self:AddComponent(UIButton, open_box_btn_path)
  self.openBoxBtn:SetOnClick(function()
    self:OpenBox()
  end)
  self.openBoxBtnText = self:AddComponent(UIText, open_box_btn_text_path)
  self.rankRewardContent = self:AddComponent(UIBaseContainer, rank_reward_content_path)
  self.rankRewardObj = self:AddComponent(UIBaseContainer, valentine_reward_item_path)
  self.rankRewardObj.gameObject:GameObjectCreatePool()
  self.chestBtn = self:AddComponent(UIButton, chest_btn_path)
  self.chestBtn:SetOnClick(function()
    self:OnClickChestBtn()
  end)
  self.getRankRewardBtn = self:AddComponent(UIButton, get_rank_reward_btn_path)
  self.getRankRewardBtn:SetOnClick(function()
    self:RankRewardBtnClick()
  end)
  self.starInfoItem = self:AddComponent(StarInfoItem, valentine_star_item_path)
  self.starBoxRedObj = self:AddComponent(UIBaseContainer, star_red_dot_path)
  self.starBoxRedNumText = self:AddComponent(UIText, star_box_num_text_path)
  self.starBoxBtn = self:AddComponent(UIButton, star_chest_btn_path)
  self.starBoxBtn:SetOnClick(function()
    self:StarBtnClick()
  end)
  self.starBoxBtn:SetSafeClickMode(true)
  self.fragBoxIconImg = self:AddComponent(UIImage, frag_box_icon_img_path)
  self.fragItemIconImg = self:AddComponent(UIImage, frag_item_icon_path)
  self.fragItemNumText = self:AddComponent(UIText, cur_frag_item_num_text_path)
  self.fragBoxProgressImg = self:AddComponent(UIImage, frag_box_progress_img_path)
  self.fragBoxReceiveBtn = self:AddComponent(UIButton, cur_frag_progress_info_path)
  self.fragBoxReceiveBtn:SetOnClick(function()
    self:TryReceiveFragBox()
  end)
  self.fragSimpleAni = self:AddComponent(UISimpleAnimation, cur_frag_progress_info_path)
  self.selectNextBtn = self:AddComponent(UIButton, next_chest_btn_path)
  self.selectNextBtn:SetOnClick(function()
    self:SelectNextBtn()
  end)
  self.selectPrevBtn = self:AddComponent(UIButton, prev_chest_btn_path)
  self.selectPrevBtn:SetOnClick(function()
    self:SelectPrevBtn()
  end)
  self.nextRankRewardText = self:AddComponent(UIText, rank_reward_text_path)
  self.middleBoxCoverImg = self:AddComponent(UIRawImage, box_cover_path)
  self.middleBoxBodyImg = self:AddComponent(UIRawImage, box_path)
  self.record_btn = self:AddComponent(UIButton, record_btn_path)
  self.record_btn:SetOnClick(function()
    self:OnClickRecordBtn()
  end)
  self.rankBtn = self:AddComponent(UIButton, rank_btn_path)
  self.rankBtn:SetOnClick(function()
    self:OnClickRankBtn()
  end)
  self.progressAddEffObj = self:AddComponent(UIBaseContainer, eff_ui_zone_saoguang_long_path)
  self.rankRewardBtn = self:AddComponent(UIButton, rank_reward_btn_path)
  self.rankRewardBtn:SetOnClick(function()
    self:OnClickRankRewardBtn()
  end)
  self.rewardFlyBallEffObj = self:AddComponent(UIBaseContainer, eff_ui_deco_shengji_trail_path)
  self.rewardFlyBallEffObj.gameObject:GameObjectCreatePool()
  self.specialRewardFlyBallEffObj = self:AddComponent(UIBaseContainer, eff_ui_valentine_trail_special_path)
  self.specialRewardFlyBallEffObj.gameObject:GameObjectCreatePool()
  self.chestObj = self:AddComponent(UIBaseContainer, chest_path)
  self.shareRankBtn = self:AddComponent(UIButton, share_btn_path)
  self.shareRankBtn:SetOnClick(function()
    self:ShareBtnClick()
  end)
  self.recordText = self:AddComponent(UIText, record_text_path)
  self.countDownImage = self:AddComponent(UIImage, count_down_image_path)
  self.rankImage = self:AddComponent(UIImage, rank_image_path)
  self.countDownText = self:AddComponent(UIText, count_down_text_path)
  self.countDownText:SetAlpha(0)
  self.countDownImage:SetAlpha(0)
  self.recordText:SetAlpha(1)
  self.rankImage:SetAlpha(1)
  self.fragItemObj = self:AddComponent(UIBaseContainer, frag_item_red_path)
  self.starChestNormalImgObj = self:AddComponent(UIBaseContainer, star_chest_img_normal_path)
  self.starChestFullImgObj = self:AddComponent(UIBaseContainer, star_chest_img_full_path)
  self.rankRewardRedDotObj = self:AddComponent(UIBaseContainer, reward_point_path)
  self.progressFlyPointObj = self:AddComponent(UIBaseContainer, progress_fly_point_path)
end

function UIActValentineReceiveGift:ComponentDestroy()
  self:StopAllTimer()
  self.boxContent:RemoveAllComponentes(BoxItem)
  self.rankRewardContent:RemoveAllComponentes(RewardItem)
  self.boxItemObj.gameObject:GameObjectRecycleAll()
  self.rankRewardObj.gameObject:GameObjectRecycleAll()
  self.rewardFlyBallEffObj.gameObject:GameObjectRecycleAll()
  self.specialRewardFlyBallEffObj.gameObject:GameObjectRecycleAll()
  if self.openBoxAniTimer then
    self.openBoxAniTimer:Stop()
    self.openBoxAniTimer = nil
  end
  if self.closeBoxAniTimer then
    self.closeBoxAniTimer:Stop()
    self.closeBoxAniTimer = nil
  end
  self.record_btn = nil
  if self.expTween then
    self.expTween:Kill()
    self.expTween = nil
  end
  if self.fragNumRollTween then
    self.fragNumRollTween:Kill()
    self.fragNumRollTween = nil
  end
  for _, v in ipairs(self.allFlyTweenList) do
    v:Kill()
  end
  self.allFlyTweenList = nil
  for _, v in ipairs(self.ballEffDelayRecycleList) do
    if v then
      v:Stop()
    end
  end
  self.allFlyTweenList = nil
  self.recordText = nil
  self.countDownImage = nil
  self.rankImage = nil
  self.countDownText = nil
end

function UIActValentineReceiveGift:DataDefine()
  self.allItemList = {}
  self.allRankRewardItemList = {}
  self.days = nil
  self.progressAniParamList = {}
  self.showExpEffTimer = nil
  self.allFlyTweenList = {}
  self.ballEffDelayRecycleList = {}
  self.beforeSettlementTime = 0
  self.showSettlement = false
  self.isNeedPopReceiveGiftView = false
end

function UIActValentineReceiveGift:DataDestroy()
  self.allItemList = nil
  self.allRankRewardItemList = nil
  self.days = nil
  self.progressAniParamList = nil
  self.beforeSettlementTime = nil
  self.showSettlement = nil
  self.isNeedPopReceiveGiftView = nil
end

function UIActValentineReceiveGift:SetData(activityId)
  base.SetData(self, activityId)
  self:StopAllTimer()
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self:ResetData()
  self:CalCurActDay()
  self.txt_act_name:SetLocalText(self.activityInfo.name)
  self:Update1000MS()
  self:RefreshUI()
  self:ReqServerData()
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = false
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
end

function UIActValentineReceiveGift:ResetData()
  if self.expTween then
    self.expTween:Kill()
    self.expTween = nil
  end
  if self.fragNumRollTween then
    self.fragNumRollTween:Kill()
    self.fragNumRollTween = nil
  end
  self.progressAniParamList = {}
end

function UIActValentineReceiveGift:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.txt_times:SetText(countDownTimeStr)
  self:CalCurActDay()
  self:ShowSettlementTime()
end

function UIActValentineReceiveGift:StopAllTimer()
  if self.showExpEffTimer then
    self.showExpEffTimer:Stop()
    self.showExpEffTimer = nil
  end
  if self.delayPlayProgressAniTimer then
    self.delayPlayProgressAniTimer:Stop()
    self.delayPlayProgressAniTimer = nil
  end
  if self.fragAniTimer then
    self.fragAniTimer:Stop()
    self.fragAniTimer = nil
  end
  if self.reqChampionDataTimer then
    self.reqChampionDataTimer:Stop()
    self.reqChampionDataTimer = nil
  end
end

function UIActValentineReceiveGift:OnIntroClick()
  local propertyInfo
  if self.rData and self.rData.activityGetData then
    propertyInfo = self.rData.activityGetData:GetBoxRewardPropertyInfo()
  end
  if self.activityInfo and not string.IsNullOrEmpty(self.activityInfo.story) then
    UIUtil.ShowIntro(Localization:GetString("302027"), Localization:GetString("2800015"), Localization:GetString(self.activityInfo.story, table.unpack(propertyInfo)))
  end
end

function UIActValentineReceiveGift:RefreshUI()
  local targetData = DataCenter.ValentineDataManager:GetActivityReceiveData(self.activityId)
  if targetData == nil then
    return
  end
  self.rData = targetData
  self:RefreshRankInfo(false)
  self:RefreshBottomInfo()
end

function UIActValentineReceiveGift:ReqServerData()
  SFSNetwork.SendMessage(MsgDefines.ValentineGetActivityInfo, self.activityId, 2)
end

function UIActValentineReceiveGift:OnActivityReceiveDataUpdate()
  local targetData = DataCenter.ValentineDataManager:GetActivityReceiveData(self.activityId)
  if targetData.activityId ~= self.activityId then
    return
  end
  local isNeedShow = self:CheckChampionRewardViewPop()
  if not isNeedShow then
    self:CheckGetGiftUpPop()
  end
end

function UIActValentineReceiveGift:RefreshRankInfo(isShowAni)
  self.prevRankData = self.rankData
  self.prevExp = self.curExp or 0
  self.rankData = self.rData:GetCurRankData()
  self.curExp = self.rData:GetCurExp()
  self:RefreshProgressInfo(isShowAni)
  if not isShowAni then
    self:RefreshRankIconInfo(self.rankData)
  end
  if not isShowAni then
    self:RefreshStarInfo(isShowAni)
  end
  self:RefreshRewardInfo(isShowAni)
end

function UIActValentineReceiveGift:RefreshRankIconInfo(targetRankData, isShowAni)
  if not targetRankData then
    return
  end
  local path = string.format("Assets/Main/TextureEx/UIActValentineMainTex/ljq_qingrenjie_duanwei_%s.png", targetRankData.type)
  self.rankImg:LoadSprite(path)
  self.rankImg:SetNativeSize()
  self.rankTitleText:SetLocalText(targetRankData.key_big)
  if isShowAni then
    self.simpleAni:Play("RankUpgrade")
    if self.rankUpgradeSoundHandle then
      DataCenter.LWSoundManager:StopSound(self.rankUpgradeSoundHandle)
      self.rankUpgradeSoundHandle = nil
    end
    self.rankUpgradeSoundHandle = DataCenter.LWSoundManager:PlaySound(202635, false)
  end
end

function UIActValentineReceiveGift:RefreshProgressInfo(showAni)
  if not self.rData then
    return
  end
  local curTotalExp = self.curExp or 0
  local curRankData = self.rankData
  local curShowExp = curTotalExp - (curRankData.exp_all or 0)
  local curProgressVal = Mathf.Clamp(curShowExp / self.rankData.exp_cost, 0, 1) or 0
  
  local function refreshFunc()
    self.progressSlider:SetValue(curProgressVal)
    local width = 410
    if curRankData.isTopRank == 1 then
      width = 460
    end
    self.progressSlider.rectTransform:Set_sizeDelta(width, 55)
    local isMaxLv = not string.IsNullOrEmpty(self.rankData.circulate)
    if isMaxLv then
      self.progressText:SetText(string.format("%s/%s", curShowExp, Localization:GetString(110000)))
    else
      self.progressText:SetText(string.format("%s/%s", curShowExp, self.rankData.exp_cost))
    end
  end
  
  if not (showAni and self.prevExp) or not self.prevRankData then
    refreshFunc()
    self.progressAddEffObj:SetActive(false)
  else
    local fromExp = self.prevExp
    local toExp = self.curExp
    if fromExp == toExp then
      return
    end
    local addExp = toExp - fromExp
    local remainExp = addExp
    local curVirtualExp = fromExp
    local loopCount = 0
    while 0 < remainExp do
      local targetRankData = self.rData:GetRankDataByExp(curVirtualExp)
      local upgradeRemainExp = targetRankData.exp_all + targetRankData.exp_cost
      local realCostExp = math.min(upgradeRemainExp - curVirtualExp, remainExp)
      local virtualExpAfterChange = curVirtualExp + realCostExp
      remainExp = remainExp - realCostExp
      local aniParam = {}
      aniParam.fromExp = curVirtualExp
      aniParam.toExp = virtualExpAfterChange
      aniParam.rankData = targetRankData
      curVirtualExp = curVirtualExp + realCostExp
      table.insert(self.progressAniParamList, aniParam)
      if remainExp <= 0 then
        break
      end
      loopCount = loopCount + 1
      if 20 <= loopCount then
        break
      end
    end
    if not self.delayPlayProgressAniTimer then
      self.delayPlayProgressAniTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.delayPlayProgressAniTimer = nil
        self:CheckAndPlayExpProgressAni()
      end, EFF_BALL_FLY_DURATION)
    end
  end
end

function UIActValentineReceiveGift:CheckAndPlayExpProgressAni()
  if not self.progressAniParamList or #self.progressAniParamList <= 0 then
    self:RefreshRankInfo()
    return
  end
  if self.delayPlayProgressAniTimer then
    return
  end
  if self.expTween then
    return
  end
  local aniData = self.progressAniParamList[1]
  if not aniData then
    return
  end
  table.remove(self.progressAniParamList, 1)
  local fromExp = aniData.fromExp
  local toExp = aniData.toExp
  local targetRankData = aniData.rankData
  local curRankCostExp = 0
  local curRankAllExp = 0
  local isMaxRank = false
  local isUpgrade = false
  if targetRankData then
    curRankCostExp = targetRankData.exp_cost
    curRankAllExp = targetRankData.exp_all
    isMaxRank = not string.IsNullOrEmpty(targetRankData.circulate)
    isUpgrade = toExp >= curRankAllExp + curRankCostExp
  end
  local fromVal = fromExp
  
  local function Getter()
    return fromVal
  end
  
  local function Setter(x)
    fromVal = x
  end
  
  if self.expTween then
    self.expTween:Kill()
    self.expTween = nil
  end
  self.expTween = DOTween.To(Getter, Setter, toExp, SINGLE_EXP_ANI_DURATION):SetEase(CS.DG.Tweening.Ease.InOutCubic):OnComplete(function()
    self.expTween = nil
    if isUpgrade then
      self:CheckPlayUpgradeStarOrRank(fromExp, toExp, function()
        self:CheckAndPlayExpProgressAni()
      end)
    elseif #self.progressAniParamList > 0 then
      self:CheckAndPlayExpProgressAni()
    else
      self:RefreshProgressInfo(false)
      self:ShowExpAddEff()
    end
  end)
  self.expTween:OnUpdate(function()
    local showExp = fromVal - curRankAllExp
    local curProgressVal = Mathf.Clamp(showExp / curRankCostExp, 0, 1)
    self.progressSlider:SetValue(curProgressVal)
    showExp = math.floor(showExp + 0.5)
    if isMaxRank then
      self.progressText:SetText(string.format("%s/%s", showExp, Localization:GetString(110000)))
    else
      self.progressText:SetText(string.format("%s/%s", showExp, targetRankData.exp_cost))
    end
  end)
end

function UIActValentineReceiveGift:ShowExpAddEff()
  if self.showExpEffTimer then
    return
  end
  self.progressAddEffObj:SetActive(false)
  self.progressAddEffObj:SetActive(true)
  self.showExpEffTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.progressAddEffObj:SetActive(false)
    self.showExpEffTimer = nil
  end, 1)
end

function UIActValentineReceiveGift:CheckPlayUpgradeStarOrRank(fromExp, toExp, callback)
  if not self.rData then
    if callback then
      callback()
    end
    return
  end
  local fromRankData = self.rData:GetRankDataByExp(fromExp)
  local toRankData = self.rData:GetRankDataByExp(toExp)
  if not fromRankData or not toRankData then
    if callback then
      callback()
    end
    return
  end
  if toRankData.type > fromRankData.type then
    local param = {}
    param.prevRankData = fromRankData
    param.curRankData = toRankData
    
    function param.closeFunc()
      callback()
      self.starInfoItem:RefreshByActivityAndRankData(self.activityId, toExp, false)
      self:RefreshRankIconInfo(toRankData, true)
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineSuccessUpgrade, {anim = true, playEffect = 202634}, param)
  elseif toRankData.star > fromRankData.star then
    self.starInfoItem:RefreshByActivityAndRankData(self.activityId, toExp, true)
    if callback then
      callback()
    end
  elseif callback then
    callback()
  end
end

function UIActValentineReceiveGift:RefreshStarInfo()
  self.starInfoItem:RefreshSelf(self.activityId)
end

function UIActValentineReceiveGift:RefreshRewardInfo(isShowAni)
  self:RefreshTitleText()
  self:RefreshRankReward()
  self:RefreshStarReward()
  if isShowAni then
    if not self.fragAniTimer then
      self.fragAniTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.fragAniTimer = nil
        self:RefreshFragBoxInfo(isShowAni)
      end, EFF_BALL_FLY_DURATION)
    end
  else
    self:RefreshFragBoxInfo(isShowAni)
  end
end

function UIActValentineReceiveGift:OnReceiveFragReward(data)
  if data then
    local dataList = {}
    for _, v in pairs(data) do
      local param = {}
      param.startPos = self.fragBoxIconImg.transform.position
      param[2] = v
      table.insert(dataList, param)
    end
    self:PlayRewardFlyToTarget(dataList)
  end
end

function UIActValentineReceiveGift:RefreshTitleText()
  if not self.rData then
    return
  end
  local curRewardRankData = self.rData:GetCurShowRewardRankData()
  if not curRewardRankData then
    self.nextRankRewardText:SetLocalText("activity_99136_40")
  else
    local rankFullName = curRewardRankData:GetRankFullName()
    self.nextRankRewardText:SetLocalText("activity_99136_38", rankFullName)
  end
end

function UIActValentineReceiveGift:RefreshRankReward()
  self.rankRewardObj.gameObject:GameObjectRecycleAll()
  self.rankRewardContent:RemoveAllComponentes(RewardItem)
  self.allRankRewardItemList = {}
  if not self.rData then
    return
  end
  if not self.rData.rankReward then
    return
  end
  for _, v in pairs(self.rData.rankReward) do
    local gameObject = self.rankRewardObj.gameObject:GameObjectSpawn(self.rankRewardContent.transform)
    local name = "item_" .. NameCount
    gameObject.name = name
    NameCount = NameCount + 1
    local rewardItem = self.rankRewardContent:AddComponent(RewardItem, name)
    local param = {}
    param.rewardData = v
    param.isShowReceived = self.rData:IsReceiveAllReward()
    rewardItem:ReInit(param)
    table.insert(self.allRankRewardItemList, rewardItem)
  end
  self.rankRewardRedDotObj:SetActive(self.rData:CheckIsExistRankReward())
  self.getRankRewardBtn:SetActive(self.rData:CheckIsExistRankReward())
end

function UIActValentineReceiveGift:RefreshStarReward()
  if not self.rData then
    return
  end
  local starBoxNum = self.rData.starRewardNum or 0
  self.starBoxRedObj:SetActive(0 < starBoxNum)
  self.starBoxRedNumText:SetText(starBoxNum)
  self.starChestNormalImgObj:SetActive(starBoxNum <= 0)
  self.starChestFullImgObj:SetActive(0 < starBoxNum)
end

function UIActValentineReceiveGift:RefreshBottomInfo()
  self.boxItemObj.gameObject:GameObjectRecycleAll()
  self.allItemList = {}
  self.boxContent:RemoveAllComponentes(BoxItem)
  if not (self.rData and self.rData.openBoxInfo) or not self.rData.openBoxLimitDic then
    return
  end
  for _, v in ipairs(self.rData.openBoxInfo) do
    local gameObject = self.boxItemObj.gameObject:GameObjectSpawn(self.boxContent.transform)
    local name = "item_" .. NameCount
    gameObject.name = name
    NameCount = NameCount + 1
    local boxItem = self.boxContent:AddComponent(BoxItem, name)
    local param = {}
    param.itemId = v
    param.limitUseCount = self.rData.openBoxLimitDic[param.itemId]
    
    function param.clickCallback(itemId)
      self:SelectOneBox(itemId)
    end
    
    boxItem:ReInit(param)
    table.insert(self.allItemList, boxItem)
  end
  if #self.allItemList > 0 then
    self:SelectOneBox(self.allItemList[1].itemId)
  end
end

function UIActValentineReceiveGift:SelectNextBtn()
  local curSelectIndex = self:GetCurSelectItemIndex()
  curSelectIndex = curSelectIndex + 1
  self:SetCurSelectBoxByIndex(curSelectIndex)
end

function UIActValentineReceiveGift:SelectPrevBtn()
  local curSelectIndex = self:GetCurSelectItemIndex()
  curSelectIndex = curSelectIndex - 1
  self:SetCurSelectBoxByIndex(curSelectIndex)
end

function UIActValentineReceiveGift:SetCurSelectBoxByIndex(index)
  local targetIndex = Mathf.Clamp(index, 1, #self.allItemList)
  local item = self.allItemList[targetIndex]
  if not item and not item.itemId then
    return
  end
  self:SelectOneBox(item.itemId)
end

function UIActValentineReceiveGift:SelectOneBox(itemId)
  if self.openBoxAniTimer then
    return
  end
  if self.selectGiftSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.selectGiftSoundHandle)
    self.selectGiftSoundHandle = nil
  end
  self.selectGiftSoundHandle = DataCenter.LWSoundManager:PlaySound(202637, false)
  for _, v in pairs(self.allItemList) do
    local isSelect = v.itemId == itemId
    v:SetSelectState(isSelect)
  end
  if self.simpleAni:IsPlaying("BoxSelect") then
    self.simpleAni:Rewind("BoxSelect")
  else
    self.simpleAni:Stop()
    self.simpleAni:Play("BoxSelect")
  end
  self.curSelectItemId = toInt(itemId)
  self:RefreshMiddleBox()
  self:RefreshNextAndPrevBtn()
end

function UIActValentineReceiveGift:RefreshNextAndPrevBtn()
  local curSelectIndex = self:GetCurSelectItemIndex()
  local isSelectFirst = curSelectIndex == 1
  local isSelectLast = curSelectIndex == #self.allItemList
  self.selectNextBtn:SetActive(not isSelectLast)
  self.selectPrevBtn:SetActive(not isSelectFirst)
end

function UIActValentineReceiveGift:GetCurSelectItemIndex()
  local ret = 0
  for index, v in ipairs(self.allItemList) do
    if v.itemId == self.curSelectItemId then
      ret = index
      break
    end
  end
  return ret
end

function UIActValentineReceiveGift:OnItemDataUpdate()
  self:RefreshRankInfo(true)
  for _, v in pairs(self.allItemList) do
    v:UpdateItemNum()
  end
  self:RefreshMiddleBox()
end

function UIActValentineReceiveGift:RefreshMiddleBox()
  local maxOpenNum = self.rData:GetMaxCanOpenNum(self.curSelectItemId)
  local curItemNum = DataCenter.ItemData:GetItemCount(self.curSelectItemId)
  self.curCanOpenNum = Mathf.Clamp(curItemNum, 0, maxOpenNum)
  if self.curCanOpenNum <= 0 then
    self.openBoxBtnText:SetLocalText(2000630)
  else
    self.openBoxBtnText:SetLocalText("activity_99136_41", self.curCanOpenNum)
  end
  if self.rData and self.rData.openBoxPicDic then
    local boxPicInfo = self.rData.openBoxPicDic[self.curSelectItemId]
    if boxPicInfo then
      if boxPicInfo.cover then
        self.middleBoxCoverImg:LoadSprite(boxPicInfo.cover)
      end
      if boxPicInfo.body then
        self.middleBoxBodyImg:LoadSprite(boxPicInfo.body)
      end
    end
  end
end

function UIActValentineReceiveGift:RefreshFragBoxInfo(isShowAni)
  if not self.rData or not self.rData.boxDataDic then
    return
  end
  local boxData = self.rData.boxDataDic[self.rData.boxId]
  if boxData then
    local iconPath = DataCenter.ItemTemplateManager:GetIconPath(boxData.box_id)
    if iconPath then
      self.fragBoxIconImg:LoadSprite(iconPath)
    end
  end
  local fragItem = self.rData.activityGetData.pieces
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(fragItem)
  if iconPath then
    self.fragItemIconImg:LoadSprite(iconPath)
  end
  local curFragItemCount = DataCenter.ItemData:GetItemCount(fragItem)
  if self.prevFragItemCount and curFragItemCount <= self.prevFragItemCount then
    isShowAni = false
    if self.fragNumRollTween then
      self.fragNumRollTween:Kill()
      self.fragNumRollTween = nil
    end
  end
  self.prevFragItemCount = curFragItemCount
  local costItemNum = 0
  if boxData then
    costItemNum = toInt(boxData.cost)
  end
  
  local function refreshFunc()
    local progressVal = Mathf.Clamp(curFragItemCount / costItemNum, 0, 1)
    self.fragBoxProgressImg:SetFillAmount(progressVal)
    if curFragItemCount >= costItemNum then
      if self.fragSimpleAni:IsPlaying("Shake") then
        self.fragSimpleAni:Rewind("Shake")
      else
        self.fragSimpleAni:Stop()
        self.fragSimpleAni:Play("Shake")
      end
      self.fragItemObj:SetActive(true)
    else
      self.fragItemObj:SetActive(false)
    end
    self.fragItemNumText:SetText(string.format("%s/%s", curFragItemCount, costItemNum))
  end
  
  if not isShowAni then
    refreshFunc()
  else
    if self.fragNumRollTween then
      self.fragNumRollTween:Kill()
      self.fragNumRollTween = nil
    end
    local fromVal = 0
    local curNumInfo = string.split(self.fragItemNumText.unity_tmpro.text, "/")
    fromVal = toInt(curNumInfo[1])
    
    local function Getter()
      return fromVal
    end
    
    local function Setter(x)
      fromVal = x
    end
    
    self.fragNumRollTween = DOTween.To(Getter, Setter, curFragItemCount, FRAG_ITEM_NUM_ROLL_DURATION):SetEase(CS.DG.Tweening.Ease.InOutCubic):OnComplete(function()
      self.fragNumRollTween = nil
      refreshFunc()
    end)
    self.fragNumRollTween:OnUpdate(function()
      self.fragItemNumText:SetText(string.format("%s/%s", math.floor(fromVal + 0.5), costItemNum))
      if fromVal < costItemNum then
        local progressVal = Mathf.Clamp(fromVal / costItemNum, 0, 1)
        self.fragBoxProgressImg:SetFillAmount(progressVal)
      end
    end)
  end
end

function UIActValentineReceiveGift:TryReceiveFragBox()
  if not self.rData or not self.rData.activityGetData then
    return
  end
  local fragItem = self.rData.activityGetData.pieces
  local curFragItemCount = DataCenter.ItemData:GetItemCount(fragItem)
  local costItemNum = 0
  local boxData = self.rData.boxDataDic[self.rData.boxId]
  if boxData then
    costItemNum = toInt(boxData.cost)
  end
  if curFragItemCount < costItemNum then
    UIUtil.ShowTipsId("chocolateStar_nocoin1_tips")
    local param = {}
    param.positionType = PositionType.Screen
    param.position = self.openBoxBtn.transform.position + Vector3.New(60, -60, 0)
    param.isAutoClose = 3
    DataCenter.ArrowManager:ShowFingerArrow(param)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ValentineGetReceiveBoxReward, self.activityId)
end

function UIActValentineReceiveGift:OpenBox()
  DataCenter.ArrowManager:RemoveFingerArrow()
  if self.openBoxAniTimer then
    return
  end
  if not self.curSelectItemId or self.curSelectItemId < 0 or not self.rData then
    return
  end
  if 0 >= self.curCanOpenNum then
    LWResourceLackUtil:GotoGoodsItemLack(self.curSelectItemId, 1)
    return
  end
  if self.simpleAni:IsPlaying("BoxOpen") then
    self.simpleAni:Rewind("BoxOpen")
  else
    self.simpleAni:Stop()
    self.simpleAni:Play("BoxOpen")
    if self.boxOpenSoundHandle then
      DataCenter.LWSoundManager:StopSound(self.boxOpenSoundHandle)
      self.boxOpenSoundHandle = nil
    end
    self.boxOpenSoundHandle = DataCenter.LWSoundManager:PlaySound(202633, false)
  end
  self.openBoxAniTimer = TimerManager:GetInstance():DelayInvoke(function()
    local param = {}
    param.activityId = self.activityId
    param.boxItemId = self.curSelectItemId
    param.num = self.curCanOpenNum
    SFSNetwork.SendMessage(MsgDefines.ValentineOpenBox, param)
    self.openBoxAniTimer = nil
  end, 1)
  if self.closeBoxAniTimer then
    self.closeBoxAniTimer:Stop()
    self.closeBoxAniTimer = nil
  end
  self.closeBoxAniTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.simpleAni:Play("BoxSelect")
    self.closeBoxAniTimer = nil
  end, 2)
end

function UIActValentineReceiveGift:OnClickChestBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineBoxProbability, {anim = true}, self.activityId)
end

function UIActValentineReceiveGift:RankRewardBtnClick()
  if not self.rData or not self.rData:CheckIsExistRankReward() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ValentineReceiveRankReward, self.activityId)
end

function UIActValentineReceiveGift:StarBtnClick()
  if not self.rData then
    return
  end
  local canReceiveBoxNum = self.rData.starRewardNum or 0
  if canReceiveBoxNum <= 0 then
    UIUtil.ShowTipsId("chocolateStar_nobox1_tips")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ValentineReceiveStarReward, self.activityId)
end

function UIActValentineReceiveGift:CalCurActDay()
  if not self.activityInfo then
    return
  end
  local oldDays = self.days
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.endTime = self.activityInfo.endTime
  local actTotalDays = (self.activityInfo.endTime - self.activityInfo.startTime) / (OneDayTime * 1000) + 1
  if curTime >= self.activityInfo.startTime and curTime < self.activityInfo.endTime then
    local value = (curTime - self.activityInfo.startTime) / 1000
    for i = 1, actTotalDays do
      if value <= i * OneDayTime then
        self.days = i
        break
      end
    end
  end
  if oldDays and self.days and oldDays < self.days then
    self:OnCrossDay()
  end
end

function UIActValentineReceiveGift:OnCrossDay()
  self:CheckChampionRewardViewPop()
end

function UIActValentineReceiveGift:CheckChampionRewardViewPop()
  if not self.rData or not self.days then
    return false
  end
  local lastCanReceiveRewardDay = self.rData.lastOpenDay + 1
  if lastCanReceiveRewardDay < self.days then
    if self.reqChampionDataTimer then
      self.reqChampionDataTimer:Stop()
      self.reqChampionDataTimer = nil
    end
    self.reqChampionDataTimer = TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.ValentineViewDayInfo, self.activityId, lastCanReceiveRewardDay)
    end, 1)
    return true
  end
  self.isNeedPopReceiveGiftView = true
  return false
end

function UIActValentineReceiveGift:CheckGetGiftUpPop()
  if not self.rData or not self.rData.fromLastReceiveGift then
    return
  end
  if not self.rData.fromLastReceiveGift.newGiftArr or #self.rData.fromLastReceiveGift.newGiftArr <= 0 then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineGetGiftUpAtEnter, {anim = true}, self.rData)
end

function UIActValentineReceiveGift:GetChampionRewardData(param)
  if not param then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineChampionDisplay, {anim = true, playEffect = 202640}, param)
end

function UIActValentineReceiveGift:OnClickRecordBtn()
  if self.activityId == nil then
    return
  end
  if self.activityInfo == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineReceiveGiftRecord, {anim = true}, self.activityId)
end

function UIActValentineReceiveGift:OnClickRankBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActValentineRankView, {anim = true}, self.activityId)
end

function UIActValentineReceiveGift:OnClickRankRewardBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActValentineRankRewardView, {anim = true}, self.activityId)
end

function UIActValentineReceiveGift:PlayRewardFlyToTarget(data)
  if not data then
    return
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.ValentineChampionDisplay) then
    return
  end
  if self.isNeedPopReceiveGiftView then
    self:CheckGetGiftUpPop()
    self.isNeedPopReceiveGiftView = false
  end
  local isShowExpBallFly = false
  for k, v in pairs(data) do
    local startPos = self.chestObj.transform.position
    if v.startPos then
      startPos = v.startPos
    end
    local itemData = v[2]
    local endPos, isHaveRandom, isVerticalRandom, effType = self:GetFlyParamsByItemData(itemData)
    if endPos then
      isShowExpBallFly = true
      for i = 1, 3 do
        self:PlayExpBallFly(startPos, endPos, isHaveRandom, isVerticalRandom, effType)
      end
    end
  end
  if isShowExpBallFly then
    self.showExpBallFlySoundHandle = DataCenter.LWSoundManager:PlaySound(202631, false)
  end
end

function UIActValentineReceiveGift:GetFlyParamsByItemData(itemData)
  if not (self.rData and self.rData.activityGetData) or not itemData then
    return
  end
  local fragItemId = self.rData.activityGetData.pieces
  local expItemId = self.rData.activityGetData.exp
  local openBoxItemIdDic = self.rData.openBoxLimitDic
  local itemId = toInt(itemData.itemId)
  local itemNum = itemData.count
  local isHaveRandom = false
  local isVerticalRandom = false
  local effType = Eff_BALL_TYPE.NORMAL
  if itemId == fragItemId then
    return self.fragBoxReceiveBtn.transform.position, isHaveRandom, isVerticalRandom, effType
  elseif itemId == expItemId then
    isHaveRandom = true
    return self.progressFlyPointObj.transform.position, isHaveRandom, isVerticalRandom, effType
  elseif self.allItemList then
    for index, v in ipairs(self.allItemList) do
      if v.itemId == itemId then
        isVerticalRandom = true
        if index == #self.allItemList then
          effType = Eff_BALL_TYPE.SPECIAL
          v:PlaySpecialReceiveItemAi(EFF_BALL_FLY_DURATION)
        end
        return v.transform.position, isHaveRandom, isVerticalRandom, effType
      end
    end
  end
end

function UIActValentineReceiveGift:PlayExpBallFly(startPos, destPos, isRandomOffset, isVerticalRandom, effType)
  local ballEff
  if effType == Eff_BALL_TYPE.NORMAL then
    ballEff = self.rewardFlyBallEffObj.gameObject:GameObjectSpawn(self.transform)
  else
    ballEff = self.specialRewardFlyBallEffObj.gameObject:GameObjectSpawn(self.transform)
  end
  local startPos = startPos
  local destPos = destPos
  local randomSign = math.random(0, 1) == 0 and -1 or 1
  if isRandomOffset then
    startPos = startPos + Vector3.New(math.random(-5, 5), math.random(-2, 2), 0)
    destPos = destPos + Vector3.New(1, 0, 0) * math.random(-50, 50)
  end
  local controlDir = isVerticalRandom and Vector3.New(0, 1, 0) or Vector3.New(1, 0, 0)
  local controlPos = (startPos + destPos) * 0.5 + controlDir * math.random(100, 350) * randomSign
  ballEff.transform.position = startPos
  local pathVec = self:Bezier2Path(startPos, controlPos, destPos)
  local randomTime = EFF_BALL_FLY_DURATION - math.random(2, 3) * 0.1
  local pathTween = ballEff.transform:DOPath(pathVec, randomTime):SetEase(CS.DG.Tweening.Ease.InQuad)
  pathTween:OnComplete(function()
    local tweenIndex = table.indexof(self.allFlyTweenList, pathTween)
    table.remove(self.allFlyTweenList, tweenIndex)
    pathTween = nil
    local cycleDelayTimer
    cycleDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      local delayTimerIndex = table.indexof(self.ballEffDelayRecycleList, cycleDelayTimer)
      table.remove(self.ballEffDelayRecycleList, delayTimerIndex)
      ballEff:GameObjectRecycle()
    end, 0.3)
    table.insert(self.ballEffDelayRecycleList, cycleDelayTimer)
  end)
  table.insert(self.allFlyTweenList, pathTween)
end

function UIActValentineReceiveGift:Bezier2Path(startPos, controlPos, endPos)
  for i = 1, SEGMENT_COUNT do
    local t = i / SEGMENT_COUNT
    local pixel = self:CalculateCubicBezierPointFor2C(t, startPos, controlPos, endPos)
    paths[i - 1] = pixel
  end
  return paths
end

function UIActValentineReceiveGift:CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

function UIActValentineReceiveGift:ShareBtnClick()
  SFSNetwork.SendMessage(MsgDefines.ValentineGetShareInfo, self.activityId)
end

function UIActValentineReceiveGift:IfBeforeSettleTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.activityInfo.endTime - OneDayTime * 1000 * 2 and curTime < self.activityInfo.endTime - OneDayTime * 1000 * 1 then
    return true
  end
  return false
end

function UIActValentineReceiveGift:ShowSettlementTime()
  if self:IfBeforeSettleTime() then
    self.beforeSettlementTime = self.beforeSettlementTime + 1
    if self.beforeSettlementTime > 5 then
      self.showSettlement = not self.showSettlement
      self.beforeSettlementTime = 0
      if self.showSettlement then
        self.countDownText:DOFade(1, 0.2)
        self.countDownImage:DOFade(1, 0.2)
        self.rankImage:DOFade(0, 0.2)
      else
        self.countDownText:DOFade(0, 0.2)
        self.countDownImage:DOFade(0, 0.2)
        self.rankImage:DOFade(1, 0.2)
      end
    end
  end
  if self.showSettlement then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.activityInfo.endTime - curTime - OneDayTime * 1000
    if 0 < leftTime then
      local timeText = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.countDownText:SetText(timeText)
    end
  end
end

return UIActValentineReceiveGift
