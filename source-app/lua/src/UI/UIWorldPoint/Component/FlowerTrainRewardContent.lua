local base = UIAsyncContainer
local FlowerTrainRewardContent = BaseClass("FlowerTrainRewardContent", base)
local Localization = CS.GameEntry.Localization
local banner_img_path = "BannerArea/BannerImg"
local btn_share_path = "BannerArea/Btn_share"
local btn_mark_path = "BannerArea/Btn_mark"
local info_btn_path = "BannerArea/InfoBtn"
local reward_scroll_view_path = "RewardArea/RewardScrollView"
local reward_content_path = "RewardArea/RewardScrollView/Viewport/RewardContent"
local remain_time_text_path = "BannerArea/RemainTimeContent/RemainTimeText"
local name_text_path = "BannerArea/NameText"
local owner_name_text_path = "BannerArea/OwnerNameText"
local bottom_tips_area_path = "BottomTipsArea"
local bottom_tips_text_path = "BottomTipsArea/BottomTipsText"

function FlowerTrainRewardContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FlowerTrainRewardContent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FlowerTrainRewardContent:OnEnable()
  base.OnEnable(self)
  self:AddTimer()
end

function FlowerTrainRewardContent:OnDisable()
  base.OnDisable(self)
  self:RemoveTimer()
end

function FlowerTrainRewardContent:ComponentDefine()
  self.bannerImg = self:AddComponent(UIRawImage, banner_img_path)
  self.shareBtn = self:AddComponent(UIButton, btn_share_path)
  self.shareBtn:SetOnClick(function()
    self:OnShareBtnClick()
  end)
  self.markBtn = self:AddComponent(UIButton, btn_mark_path)
  self.markBtn:SetOnClick(function()
    self:OnMarkBtnClick()
  end)
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.scroll_view_reward = self:AddComponent(UILoopListView2, reward_scroll_view_path)
  self.scroll_view_reward:InitListView(0, function(loopView, index)
    return self:OnGetRewardItemByIndex(loopView, index)
  end)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.remainTimeText = self:AddComponent(UIText, remain_time_text_path)
  self.nameText = self:AddComponent(UIText, name_text_path)
  self.ownerNameText = self:AddComponent(UIText, owner_name_text_path)
  self.bottomTipsArea = self:AddComponent(UIBaseContainer, bottom_tips_area_path)
  self.bottomTipText = self:AddComponent(UIText, bottom_tips_text_path)
end

function FlowerTrainRewardContent:ComponentDestroy()
  self.bannerImg = nil
  self.shareBtn = nil
  self.markBtn = nil
  self.lvImg = nil
  self.infoBtn = nil
  self.scroll_view_reward:ClearAllItems()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardContent = nil
  self.bottomTipsArea = nil
end

function FlowerTrainRewardContent:DataDefine()
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.cacheTrainName = nil
end

function FlowerTrainRewardContent:DataDestroy()
  self.timer_action = nil
  self.cacheTrainName = nil
end

function FlowerTrainRewardContent:OnAddListener()
  self:AddUIListener(EventId.FlowerTrainGetFlowerBoxInfoSuccess, self.OnFlowerTrainGetFlowerBoxInfoSuccess)
  base.OnAddListener(self)
end

function FlowerTrainRewardContent:OnRemoveListener()
  self:RemoveUIListener(EventId.FlowerTrainGetFlowerBoxInfoSuccess, self.OnFlowerTrainGetFlowerBoxInfoSuccess)
  base.OnRemoveListener(self)
end

function FlowerTrainRewardContent:RefreshView(data, topBtnAction)
  self.flowerTrainRewardData = data
  if not self.flowerTrainRewardData then
    Logger.LogError("FlowerTrainRewardContent:UpdateView flowerTrainRewardData is nil")
    return
  end
  self.boxServerId = LuaEntry.Player:GetCurServerId()
  self.pointId = data.pointId
  self.boxUuid = data.boxUuid
  self.trainUuid = data.trainUuid
  self.worldTreasureId = data.worldTreasureId
  self.goodsId = data.goodsId
  self.flowerTrainLv = data.flowerTrainLv
  self.info = data.info
  self.ownerName = data.info.ownerName
  self.shareBtnAction = topBtnAction.shareBtnAction
  self.markBtnAction = topBtnAction.markBtnAction
  self.pointData = CS.SceneManager.World:GetPointInfo(self.pointId)
  self.giftMeta = LocalController:instance():tryGetLine(TableName.WorldTreasure, self.worldTreasureId)
  self.isSelf = data.isSelf
  if self.giftMeta then
    local boxShowParaId = self.giftMeta.custom_para
    self.boxRewardShowMeta = DataCenter.FlowerTrainDataManager:GetWorldBoxRewardShowMeta(boxShowParaId)
  end
  self:RefreshBaseInfo()
  self:RefreshCheerRewardInfo()
  self:RefreshBottomTips()
end

function FlowerTrainRewardContent:RefreshBottomTips()
  local isCross = CrossServerUtil.NeedIntercept()
  if isCross then
    self.bottomTipText:SetLocalText(458585)
    self.bottomTipText:SetColorHex("#F43D42")
    return
  end
  self.bottomTipText:SetColorHex("#736863")
  if self.cacheTrainName and self.cacheTrainName ~= "" then
    self.bottomTipText:SetLocalText("activity_treasurebox_tipsdesc3", self.cacheTrainName)
    return
  end
  self.bottomTipText:SetText("")
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainTreasureInfo, self.boxServerId, self.boxUuid)
end

function FlowerTrainRewardContent:RefreshBaseInfo()
  self:RefreshBannerImg()
  if not self.giftMeta then
    Logger.LogError("FlowerTrainRewardContent:RefreshBaseInfo giftMeta is nil")
    return
  end
  local abbr = self.info.allianceAbbr
  local name = self.info.ownerName
  self.ownerNameText:SetText(UIUtil.FormatAllianceAndName(abbr, name))
  self.nameText:SetLocalText(self.giftMeta.name)
  self:RefreshTime()
end

function FlowerTrainRewardContent:RefreshBannerImg()
  if not self.boxRewardShowMeta then
    Logger.LogError("FlowerTrainRewardContent:RefreshBannerImg boxRewardShowMeta is nil")
    return
  end
  local bannerImgPath = self.boxRewardShowMeta.pic2
  self.bannerImg:LoadSpriteAsync(bannerImgPath)
end

function FlowerTrainRewardContent:RefreshTime()
  if not self.info then
    return
  end
  self:RefreshRemainTime()
end

function FlowerTrainRewardContent:RefreshRemainTime()
  if not self.info then
    return
  end
  local endTime = self.info.expireTime
  local now = UITimeManager:GetInstance():GetServerTime()
  local remainTime = endTime - now
  self.remainTimeText:SetText(UITimeManager:GetInstance():SecondToFmtString(remainTime / 1000))
end

function FlowerTrainRewardContent:RefreshCheerRewardInfo()
  if not self.boxRewardShowMeta then
    Logger.LogError("FlowerTrainRewardContent:RefreshCheerRewardInfo boxRewardShowMeta is nil")
    return
  end
  self.rewardDataList = FlowerTrainUtils.ParseRewardStr(self.boxRewardShowMeta.box_show_reward)
  if not self.rewardDataList then
    Logger.LogError("FlowerTrainRewardContent:RefreshCheerRewardInfo rewardDataList is nil")
    return
  end
  self.scroll_view_reward:SetListItemCount(#self.rewardDataList, false, false)
  self.scroll_view_reward:RefreshAllShownItem()
end

function FlowerTrainRewardContent:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function FlowerTrainRewardContent:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function FlowerTrainRewardContent:OnGetRewardItemByIndex(loopView, index)
  index = index + 1
  if index < 1 or index > #self.rewardDataList then
    return nil
  end
  local item = loopView:NewListViewItem("UICommonResItem")
  local script = self.rewardContent:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    local objectName = tostring(NameCount)
    NameCount = NameCount + 1
    item.gameObject.name = objectName
    script = self.rewardContent:AddComponent(UICommonResItem, objectName)
  end
  script:SetActive(true)
  item.transform.localScale = Vector3.New(0.8, 0.8, 0.8)
  local rewardData = self.rewardDataList[index]
  if rewardData then
    script:ReInit(rewardData)
  end
  return item
end

function FlowerTrainRewardContent:OnShareBtnClick()
  if self.shareBtnAction then
    self.shareBtnAction()
  end
end

function FlowerTrainRewardContent:OnMarkBtnClick()
  if self.markBtnAction then
    self.markBtnAction()
  end
end

function FlowerTrainRewardContent:OnInfoBtnClick()
  if not self.boxRewardShowMeta then
    Logger.LogError("FlowerTrainRewardContent:RefreshBannerImg boxRewardShowMeta is nil")
    return
  end
  local infoStrList = self.boxRewardShowMeta.info
  if not infoStrList or #infoStrList < 2 then
    Logger.LogError("FlowerTrainRewardContent:OnInfoBtnClick infoStrList is nil or length is less than 2")
    return
  end
  local param = {}
  param.title = infoStrList[1]
  param.activityRulesStr = Localization:GetString(infoStrList[2])
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function FlowerTrainRewardContent:OnFlowerTrainGetFlowerBoxInfoSuccess(params)
  if not params then
    return
  end
  if self.boxUuid ~= params.uuid then
    return
  end
  self.bottomTipsArea:SetActive(true)
  self.bottomTipText:SetLocalText("activity_treasurebox_tipsdesc3", params.name)
  self.cacheTrainName = params.name
end

return FlowerTrainRewardContent
