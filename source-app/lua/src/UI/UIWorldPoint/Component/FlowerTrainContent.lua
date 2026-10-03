local base = UIAsyncContainer
local FlowerTrainContent = BaseClass("FlowerTrainContent", base)
local Localization = CS.GameEntry.Localization
local banner_img_path = "BannerArea/BannerImg"
local btn_share_path = "BannerArea/Btn_share"
local btn_mark_path = "BannerArea/Btn_mark"
local lv_img_path = "BannerArea/LvImg"
local info_btn_path = "BannerArea/PlayInfoBtn"
local flower_name_text_path = "BannerArea/FlowerNameText"
local remain_time_text_path = "BannerArea/RemainTimeContent/RemainTimeText"
local record_btn_path = "BannerArea/RecordBtn"
local lv_text_path = "BaseInfoArea/LvText"
local exp_slider_path = "BaseInfoArea/ExpProgressArea/Mask/ExpSlider"
local exp_progress_val_text_path = "BaseInfoArea/ExpProgressArea/ExpProgressValText"
local finish_reward_preview_area_path = "BaseInfoArea/FinishRewardPreviewArea"
local reward_img_path = "BaseInfoArea/FinishRewardPreviewArea/RewardImg"
local cur_reward_lv_text_path = "BaseInfoArea/FinishRewardPreviewArea/CurRewardLvText"
local like_btn_path = "ButtonArea/LikeBtn"
local cheer_btn_path = "ButtonArea/CheerBtn"
local bottom_tips_text_path = "BottomTipsArea/BottomTipsText"
local banner_tip_des_text_path = "BannerArea/BannerTipDesText"
local finish_reward_scroll_view_path = "FinishRewardArea/FinishRewardScrollView"
local cheer_reward_scroll_view_path = "CheerRewardArea/CheerRewardScrollView"
local finish_reward_content_path = "FinishRewardArea/FinishRewardScrollView/Viewport/FinishRewardContent"
local cheer_reward_content_path = "CheerRewardArea/CheerRewardScrollView/Viewport/CheerRewardContent"
local fire_img_path = "BaseInfoArea/ExpProgressArea/ExpIcon/FireImg"
local lv_info_btn_path = "BaseInfoArea/LvInfoBtn"
local cheer_reward_area_path = "CheerRewardArea"
local exp_desc_text_path = "BaseInfoArea/ExpDescText"
local fire_eff_point_path = "BaseInfoArea/ExpProgressArea/ExpIcon/FireEffPoint"
local full_exp_eff_root_path = "BaseInfoArea/ExpProgressArea/Mask/FullExpEffRoot"
local cost_icon_img_path = "ButtonArea/CheerBtn/LW_Btn_Common_New_Base/CostIconImg"
local cost_num_text_path = "ButtonArea/CheerBtn/LW_Btn_Common_New_Base/CostIconImg/CostNumText"
local DEFAULT_FIRE_EFF_PATH = "Assets/Main/Prefabs/UI/FlowerTrain/Effect/Eff_ui_Halloween_huachepaihang_flame1.prefab"
local FIRE_EFF_PATH = "Assets/Main/Prefabs/UI/FlowerTrain/Effect/Eff_ui_Halloween_huachepaihang_flame%s.prefab"
local FULL_EXP_EFF_PATH = "Assets/Main/Prefabs/UI/FlowerTrain/Effect/Eff_ui_Halloween_huachepaihang_slider_full.prefab"
local add_exp_eff_root_path = "BaseInfoArea/ExpProgressArea/Mask/ExpSlider/Fill Area/Fill/AddExpEffRoot"

function FlowerTrainContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FlowerTrainContent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FlowerTrainContent:OnEnable()
  base.OnEnable(self)
  self:AddTimer()
end

function FlowerTrainContent:OnDisable()
  base.OnDisable(self)
  self:RemoveTimer()
end

function FlowerTrainContent:ComponentDefine()
  self.bannerImg = self:AddComponent(UIRawImage, banner_img_path)
  self.shareBtn = self:AddComponent(UIButton, btn_share_path)
  self.shareBtn:SetOnClick(function()
    self:OnShareBtnClick()
  end)
  self.markBtn = self:AddComponent(UIButton, btn_mark_path)
  self.markBtn:SetOnClick(function()
    self:OnMarkBtnClick()
  end)
  self.lvImg = self:AddComponent(UIImage, lv_img_path)
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.flowerNameText = self:AddComponent(UIText, flower_name_text_path)
  self.remainTimeText = self:AddComponent(UIText, remain_time_text_path)
  self.recordBtn = self:AddComponent(UIButton, record_btn_path)
  self.recordBtn:SetOnClick(function()
    self:OnRecordBtnClick()
  end)
  self.lvText = self:AddComponent(UIText, lv_text_path)
  self.expSlider = self:AddComponent(UISlider, exp_slider_path)
  self.expProgressValText = self:AddComponent(UIText, exp_progress_val_text_path)
  self.finishRewardPreviewArea = self:AddComponent(UIBaseContainer, finish_reward_preview_area_path)
  self.rewardPreviewBtn = self:AddComponent(UIButton, finish_reward_preview_area_path)
  self.rewardPreviewBtn:SetOnClick(function()
    self:OnRewardPreviewBtnClick()
  end)
  self.rewardBoxImg = self:AddComponent(UIImage, reward_img_path)
  self.curRewardLvText = self:AddComponent(UIText, cur_reward_lv_text_path)
  self.likeBtn = self:AddComponent(UIButton, like_btn_path)
  self.likeBtn:SetOnClick(function()
    self:LikeBtnClick()
  end)
  self.cheerBtn = self:AddComponent(UIButton, cheer_btn_path)
  self.cheerBtn:SetOnClick(function()
    self:CheerBtnClick()
  end)
  self.cheerBtn:SetSafeClickMode(true)
  self.cheerBtn:SetSafeClickModeTime(0.1)
  self.bottomTipsText = self:AddComponent(UIText, bottom_tips_text_path)
  self.ownerTipText = self:AddComponent(UIText, banner_tip_des_text_path)
  self.scroll_view_finish_reward = self:AddComponent(UILoopListView2, finish_reward_scroll_view_path)
  self.scroll_view_finish_reward:InitListView(0, function(loopView, index)
    return self:OnGetFinishRewardItemByIndex(loopView, index)
  end)
  self.finishRewardContent = self:AddComponent(UIBaseContainer, finish_reward_content_path)
  self.scroll_view_cheer_reward = self:AddComponent(UILoopListView2, cheer_reward_scroll_view_path)
  self.scroll_view_cheer_reward:InitListView(0, function(loopView, index)
    return self:OnGetCheerRewardItemByIndex(loopView, index)
  end)
  self.cheerRewardContent = self:AddComponent(UIBaseContainer, cheer_reward_content_path)
  self.fireImg = self:AddComponent(UIImage, fire_img_path)
  self.lvInfoBtn = self:AddComponent(UIButton, lv_info_btn_path)
  self.lvInfoBtn:SetOnClick(function()
    self:LvInfoBtnClick()
  end)
  self.cheerAreaObj = self:AddComponent(UIBaseComponent, cheer_reward_area_path)
  self.expDescText = self:AddComponent(UIText, exp_desc_text_path)
  self.cheerCostIcon = self:AddComponent(UIImage, cost_icon_img_path)
  self.cheerCostNum = self:AddComponent(UIText, cost_num_text_path)
  local defaultFireEffPath = string.format(FIRE_EFF_PATH, 1)
  self.fireEff = self:AddComponent(UIVfx, fire_eff_point_path, defaultFireEffPath, {
    lifeType = UIVfxLifeType.HideAfterOnce
  })
  self.fullExpEff = self:AddComponent(UIVfx, full_exp_eff_root_path, FULL_EXP_EFF_PATH, {
    lifeType = UIVfxLifeType.HideAfterOnce
  })
  local expEff = self:AddComponent(UIBaseComponent, add_exp_eff_root_path)
  local expEffScale = CommonUtil.ArabicAutoMirrorFactor()
  expEff.transform:Set_localScale(expEffScale, 1, 1)
  expEff.transform:Set_anchorMin(CommonUtil.IsArabicAutoMirrorOpen() and 0 or 1, 0.5)
  expEff.transform:Set_anchorMax(CommonUtil.IsArabicAutoMirrorOpen() and 0 or 1, 0.5)
end

function FlowerTrainContent:ComponentDestroy()
  self.bannerImg = nil
  self.shareBtn = nil
  self.markBtn = nil
  self.lvImg = nil
  self.infoBtn = nil
  self.flowerNameText = nil
  self.remainTimeText = nil
  self.recordBtn = nil
  self.lvText = nil
  self.expSlider = nil
  self.expProgressValText = nil
  self.finishRewardPreviewArea = nil
  self.rewardBoxImg = nil
  self.curRewardLvText = nil
  self.likeBtn = nil
  self.cheerBtn = nil
  self.bottomTipsText = nil
  self.finishRewardContent:RemoveComponents(UICommonResItem)
  self.scroll_view_finish_reward:ClearAllItems()
  self.finishRewardContent = nil
  self.cheerRewardContent:RemoveComponents(UICommonResItem)
  self.scroll_view_cheer_reward:ClearAllItems()
  self.cheerRewardContent = nil
end

function FlowerTrainContent:DataDefine()
  function self.timer_action(temp)
    self:Update1000MS()
  end
  
  self.lastFetchHistoryTime = nil
  self.cacheLv = 0
end

function FlowerTrainContent:DataDestroy()
  self.timer_action = nil
  self.lastFetchHistoryTime = nil
  self.cacheLv = nil
end

function FlowerTrainContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FlowerTrainSuccessLike, self.OnFlowerTrainSuccessLike)
  self:AddUIListener(EventId.FlowerTrainSuccessCheer, self.OnFlowerTrainSuccessCheer)
end

function FlowerTrainContent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.FlowerTrainSuccessLike, self.OnFlowerTrainSuccessLike)
  self:RemoveUIListener(EventId.FlowerTrainSuccessCheer, self.OnFlowerTrainSuccessCheer)
end

function FlowerTrainContent:RefreshView(flowerTrainGroupData, carIndex)
  self.flowerTrainData = flowerTrainGroupData
  if not self.flowerTrainData then
    Logger.LogError("FlowerTrainContent:RefreshView flowerTrainData is nil")
    return
  end
  self.singleTrainData = self.flowerTrainData:GetSingleTrainDataByIndex(carIndex or 0)
  if not self.singleTrainData then
    Logger.LogError("FlowerTrainContent:RefreshView singleTrainData is nil")
    self.view.ctrl:CloseSelf()
    return
  end
  self:ReInit()
end

function FlowerTrainContent:ReInit()
  if not self.singleTrainData then
    return
  end
  self.showMeta = self.singleTrainData.showMeta
  if not self.showMeta then
    Logger.LogError("FlowerTrainContent:RefreshView showMeta is nil")
    return
  end
  self.isSelf = self.singleTrainData.isSelf
  self.cacheLv = self.singleTrainData:GetFlowerTrainLv()
  self:RefreshBaseInfo()
  self:RefreshExpInfo()
  self:RefreshFinishRewardInfo()
  self:RefreshCheerRewardInfo()
  self:BottomTipsText()
  self:CrossShowHideCheck()
  self:RefreshBtn()
end

function FlowerTrainContent:FetchLikeAndCheerHistory()
  FlowerTrainUtils.ShowRecentlyLikeAndCheers()
end

function FlowerTrainContent:CrossShowHideCheck()
  local isCross = CrossServerUtil.NeedIntercept()
  self.cheerAreaObj:SetActive(not isCross)
  self.cheerBtn:SetActive(not isCross)
end

function FlowerTrainContent:RefreshBaseInfo()
  local lvImgPath = self.singleTrainData:GetLvImgPath()
  self.lvImg:LoadSpriteAsync(lvImgPath)
  local bannerImgPath = self.showMeta.world_banner
  self.bannerImg:LoadSpriteAsyncWithCallback(bannerImgPath, function(texture)
    self.bannerImg:SetNativeSize()
  end)
  local abbr = self.singleTrainData.abbr
  local name = self.singleTrainData.name
  self.ownerTipText:SetLocalText("2025halloween_reward_owner", UIUtil.FormatAllianceAndName(abbr, name))
  self.flowerNameText:SetLocalText(self.singleTrainData:GetFlowerTrainName())
  self.recordBtn:SetActive(self.isSelf)
  self:RefreshTime()
end

function FlowerTrainContent:Update1000MS()
  self:CheckUpgrade()
  self:RefreshTime()
end

function FlowerTrainContent:CheckUpgrade()
  if not self.cacheLv then
    return
  end
  local curLv = self.singleTrainData:GetFlowerTrainLv()
  if curLv == self.cacheLv then
    return
  end
  self:OnFlowerTrainUpgrade()
end

function FlowerTrainContent:OnFlowerTrainUpgrade()
  self:ReInit()
  if self.fullExpEff then
    self.fullExpEff:Replay()
  end
end

function FlowerTrainContent:RefreshTime()
  if not self.singleTrainData then
    self.view.ctrl:CloseSelf()
    return
  end
  self:RefreshRemainTime()
  self:RefreshExpProgressInfo()
  if self.singleTrainData:GetIsArrived() then
    self.view.ctrl:CloseSelf()
  end
end

function FlowerTrainContent:RefreshRemainTime()
  if not self.singleTrainData then
    return
  end
  local endTime = self.singleTrainData.arriveTime or 0
  local now = UITimeManager:GetInstance():GetServerTime()
  local remainTime = endTime - now
  self.remainTimeText:SetText(UITimeManager:GetInstance():SecondToFmtString(remainTime / 1000))
end

function FlowerTrainContent:RefreshExpInfo()
  local curLv = self.singleTrainData.lv
  self.lvText:SetLocalText("treasure_lvup_showmax", curLv)
  self.curRewardLvText:SetLocalText(140002, curLv)
  local previewBoxPic = self.singleTrainData:GetPreviewBoxPicPath()
  self.rewardBoxImg:LoadSpriteAsync(previewBoxPic)
  local fireImgPath, curExpIndex = self.singleTrainData:GetExpFireImgPath()
  self.fireImg:LoadSpriteAsync(fireImgPath)
  self.expDescText:SetLocalText("2025halloween_reward_levelspeed", self.singleTrainData:GetAddExpPerSecond())
  self:RefreshExpProgressInfo()
  if self.curExpIndex ~= curExpIndex then
    self.curExpIndex = curExpIndex
    self:UpdateCurExpAddEff()
  end
end

function FlowerTrainContent:UpdateCurExpAddEff()
  if self.curExpIndex then
    self.curExpAddEffPath = string.format(FIRE_EFF_PATH, self.curExpIndex)
  end
end

function FlowerTrainContent:RefreshExpProgressInfo()
  if not self.singleTrainData then
    return
  end
  local curTotalExp = self.singleTrainData:GetCurTotalExp()
  local curLvFullExp = self.singleTrainData:GetCurLvFullExp()
  curLvFullExp = self.singleTrainData:IsMaxLv() and LongMaxValue or curLvFullExp
  curTotalExp = Mathf.Clamp(curTotalExp, 0, curLvFullExp)
  local curLvUpgradeTotalExp = self.singleTrainData:GetCurLvUpgradeCostTotalExp()
  local curLvUpgradeExp = self.singleTrainData:GetCurLvUpgradeCostExp()
  if self.singleTrainData:IsMaxLv() then
    self.expSlider:SetValue(1)
    self.expProgressValText:SetText(curTotalExp)
  else
    self.expProgressValText:SetLocalText(135225, curTotalExp, curLvUpgradeTotalExp + curLvUpgradeExp)
    local expProgressVal = Mathf.Clamp((curTotalExp - curLvUpgradeTotalExp) / curLvUpgradeExp, 0, 1)
    self.expSlider:SetValue(expProgressVal)
  end
end

function FlowerTrainContent:RefreshFinishRewardInfo()
  self.finishRewarDataList = self.singleTrainData:GetFinishRewardData()
  if not self.finishRewarDataList then
    return
  end
  self.scroll_view_finish_reward:SetListItemCount(#self.finishRewarDataList, false, false)
  self.scroll_view_finish_reward:RefreshAllShownItem()
end

function FlowerTrainContent:RefreshCheerRewardInfo()
  self.cheerRewarDataList = self.singleTrainData:GetCheerRewardData()
  if not self.cheerRewarDataList then
    return
  end
  self.scroll_view_cheer_reward:SetListItemCount(#self.cheerRewarDataList, false, false)
  self.scroll_view_cheer_reward:RefreshAllShownItem()
end

function FlowerTrainContent:BottomTipsText()
  if CrossServerUtil.NeedIntercept() then
    self.bottomTipsText:SetColorHex("#F43D42")
    self.bottomTipsText:SetLocalText("2025halloween_reward_desc2")
    return
  end
  local likeExp = 0
  local cheerExp = 0
  if self.singleTrainData then
    likeExp = self.singleTrainData:GetAddExpFromLike() or 0
    cheerExp = self.singleTrainData:GetAddExpFromCheer() or 0
  end
  self.bottomTipsText:SetColorHex("#736863")
  self.bottomTipsText:SetLocalText("2025halloween_reward_desc1", likeExp, cheerExp)
end

function FlowerTrainContent:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function FlowerTrainContent:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function FlowerTrainContent:OnGetFinishRewardItemByIndex(loopView, index)
  index = index + 1
  if index < 1 or index > #self.finishRewarDataList then
    return nil
  end
  local item = loopView:NewListViewItem("UICommonResItem")
  local script = self.finishRewardContent:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    local objectName = tostring(NameCount)
    NameCount = NameCount + 1
    item.gameObject.name = objectName
    script = self.finishRewardContent:AddComponent(UICommonResItem, objectName)
  end
  script:SetActive(true)
  item.transform.localScale = Vector3.New(0.8, 0.8, 0.8)
  local rewardData = self.finishRewarDataList[index]
  if rewardData then
    script:ReInit(rewardData)
  end
  return item
end

function FlowerTrainContent:OnGetCheerRewardItemByIndex(loopView, index)
  index = index + 1
  if index < 1 or index > #self.cheerRewarDataList then
    return nil
  end
  local item = loopView:NewListViewItem("UICommonResItem")
  local script = self.cheerRewardContent:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    local objectName = tostring(NameCount)
    NameCount = NameCount + 1
    item.gameObject.name = objectName
    script = self.cheerRewardContent:AddComponent(UICommonResItem, objectName)
  end
  script:SetActive(true)
  item.transform.localScale = Vector3.New(0.8, 0.8, 0.8)
  local rewardData = self.cheerRewarDataList[index]
  if rewardData then
    script:ReInit(rewardData)
  end
  return item
end

function FlowerTrainContent:LikeBtnClick()
  if not self.singleTrainData then
    return
  end
  if self.singleTrainData:IsSelfFlowerTrain() then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  local playerUid = tonumber(self.singleTrainData.playerUid)
  local carUuid = tonumber(self.singleTrainData.uuid)
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainPraise, playerUid, carUuid)
end

function FlowerTrainContent:CheerBtnClick()
  if not self.singleTrainData then
    return
  end
  local cheerCostGoodsId = self.singleTrainData.cheerCostGoodsId
  local cheerCostGoodsNum = self.singleTrainData.cheerCostGoodsNum
  local have = DataCenter.ItemData:GetItemCount(cheerCostGoodsId)
  if cheerCostGoodsNum > have then
    local need = Mathf.Clamp(cheerCostGoodsNum - have, 0, cheerCostGoodsNum)
    LWResourceLackUtil:GotoGoodsItemLack(cheerCostGoodsId, need)
    return
  end
  if not FlowerTrainUtils.IsCanCheer(500019) then
    return
  end
  if self.singleTrainData:IsSelfFlowerTrain() then
    UIUtil.ShowTipsId("activity_treasure_error_alert16")
    return
  end
  local carUuid = self.singleTrainData.uuid
  local targetUid = self.singleTrainData.playerUid
  local trainItemId = self.singleTrainData.fromGoodsId
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainCheer, carUuid, targetUid, trainItemId)
  if GMUtils.GetBool(GMConst.FlowerTrainSuperCheerModeEnable, false) then
    FlowerTrainUtils.SuperCheer(self.singleTrainData:GetFlowerTrainUuid())
  end
end

function FlowerTrainContent:OnShareBtnClick()
  local share_time = CommonUtil.PlayerPrefsGetLong(SettingKeys.FLOWER_TRAIN_POSITION_SHARE_TIME, 0)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local configMeta = FlowerTrainUtils.GetFlowerTrainConfigByGoodsId(self.singleTrainData.fromGoodsId)
  if curTime - share_time <= toInt(configMeta.share_cd) * 1000 then
    local leftTime = (toInt(configMeta.share_cd) * 1000 - curTime + share_time) // 1000
    UIUtil.ShowTips(Localization:GetString("treasure_world_share_cooldown", leftTime))
    return
  end
  if not self.singleTrainData then
    return
  end
  local share_param = {}
  share_param.marchUuid = self.flowerTrainData.marchUuid
  share_param.serverId = self.singleTrainData.serverId
  share_param.uuid = self.singleTrainData.uuid
  share_param.post = PostType.FLOWER_TRAIN_POSITION_SHARE
  share_param.postType = PostType.FLOWER_TRAIN_POSITION_SHARE
  share_param.uid = self.singleTrainData.playerUid
  share_param.worldId = LuaEntry.Player:GetCurWorldId()
  share_param.goodsId = self.singleTrainData.fromGoodsId
  share_param.lv = self.singleTrainData.lv
  share_param.exp = self.singleTrainData:GetCurTotalExp()
  local curPointId = self.singleTrainData:GetCurMarchPointId()
  local location = SceneUtils.IndexToTilePos(curPointId, ForceChangeScene.World)
  share_param.posStr = string.format("<u>X:%s,Y:%s</u>", location.x, location.y)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  self.view.ctrl:CloseSelf()
end

function FlowerTrainContent:OnMarkBtnClick()
  UIUtil.ShowTipsId("E100008")
end

function FlowerTrainContent:OnInfoBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainRules, {anim = true}, {
    itemId = self.singleTrainData.fromGoodsId
  })
  PostEventLog.Track(PostEventLog.Defines.FlowerTrain_Show_Info_Panel)
end

function FlowerTrainContent:OnRecordBtnClick()
  local param = {}
  param.uuid = self.singleTrainData.uuid
  param.itemId = self.singleTrainData.fromGoodsId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainLikeAndCheerList, {anim = true}, param)
end

function FlowerTrainContent:OnRewardPreviewBtnClick()
  if not self.singleTrainData then
    return
  end
  local param = {}
  param.alignObject = self.rewardPreviewBtn
  param.showArrow = true
  param.customNameText = Localization:GetString("2025halloween_reward_previewtips_title")
  param.customDesText = Localization:GetString("2025halloween_reward_previewtips_desc")
  param.customTipsType = GOODS_TIPS_TYPE.BoxWithoutProbability
  param.customDataList = self.singleTrainData:GetCurFinishRewardBoxTipsData()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBoxItemTips, {anim = true}, param)
end

function FlowerTrainContent:LvInfoBtnClick()
  if not self.singleTrainData or not self.singleTrainData.paraMeta then
    Logger.LogError("FlowerTrainContent:LvInfoBtnClick paraMeta is nil")
    return
  end
  local introStr = self.singleTrainData.paraMeta.level_info
  if not introStr then
    Logger.LogError("FlowerTrainContent:LvInfoBtnClick introStr is nil")
    return
  end
  introStr = string.split(introStr, "|")
  if #introStr < 2 then
    Logger.LogError("FlowerTrainContent:LvInfoBtnClick introStr is less than 2")
    return
  end
  local curLvBoxMeta = self.singleTrainData:GetCurLvBoxData()
  if not curLvBoxMeta then
    return
  end
  local lvUpRewardWaitTime = self.singleTrainData:GetWaitingRewardTime() / 1000
  local expireTime = curLvBoxMeta.expire_time
  local title = introStr[1]
  local content = introStr[2]
  local param = {}
  param.title = title
  local showKey = content
  param.activityRulesStr = Localization:GetString(showKey, lvUpRewardWaitTime, expireTime)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  PostEventLog.Track(PostEventLog.Defines.FlowerTrain_Show_Level_Panel)
end

function FlowerTrainContent:IsResearchMaxLikeCount()
  if not self.singleTrainData then
    return false
  end
  local maxLikeCountPerPlayer = self.singleTrainData.maxLikeCountPerPlayer
  local curLikeCount = FlowerTrainUtils.GetFlowerTrainLikeCount(self.singleTrainData.fromGoodsId)
  return maxLikeCountPerPlayer <= curLikeCount
end

function FlowerTrainContent:OnFlowerTrainSuccessLike()
  self:PlayExpAddEff()
end

function FlowerTrainContent:OnFlowerTrainSuccessCheer()
  self:PlayExpAddEff()
end

function FlowerTrainContent:PlayExpAddEff()
  local path = self.curExpAddEffPath or DEFAULT_FIRE_EFF_PATH
  if self.fireEff and self.curExpAddEffPath then
    self.fireEff:PlayByOnce(path)
  end
end

function FlowerTrainContent:RefreshBtn()
  if not self.singleTrainData then
    Logger.LogError("FlowerTrainContent:RefreshBtn singleTrainData is nil")
    return
  end
  local costId, costNum = self.singleTrainData:GetCheerCostGoodsIdAndNum()
  if costId then
    local costIcon = DataCenter.ItemTemplateManager:GetIconPath(costId)
    self.cheerCostIcon:LoadSpriteAsync(costIcon, function(texture)
    end)
  end
  self.cheerCostNum:SetLocalText("390902", costNum or 1)
end

return FlowerTrainContent
