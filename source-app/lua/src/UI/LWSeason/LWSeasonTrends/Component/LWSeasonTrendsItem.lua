local LWSeasonTrendsItemFun = require("UI.LWSeason.LWSeasonTrends.Component.LWSeasonTrendsItemFun")
local LWSeasonTrendsItem = BaseClass("LWSeasonTrendsItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local description_text = "TextDes"
local title_text = "titleGroup/TextTitle"
local item_bg_path = "itemBg"
local reward_flag_path = "rewardFlag"
local finish_mask_path = "finishBlackMask"
local rank_path = "rankGO"
local rank_btn_path = "rankGO/rankBtn"
local shareBtn_path = "titleGroup/shareBtn"
local countdown_path = "topArea/countdown"
local countdown_text_path = "topArea/countdown/countdownText"
local lock_path = "topArea/lock"
local progress_text_path = "bottom/ProgressBar/ProgressDes"
local progress_front_path = "bottom/ProgressBar/mask"
local front_path = "bottom/ProgressBar/mask/front"
local tip_path = "tip"
local title_path = "tip/bg/title"
local content_path = "tip/bg/content"
local point_path = "tip/point"
local junp_btn_path = "tip/junpBtn"
local bg_path = "tip/bg"
local tip_close_btn_path = "tip/tipCloseBtn"
local info_btn_path = "InfoBtn"
local get_reward_btn_path_new = "bottom/getRewardBtn"
local event_des_go_path = "eventDesGo"
local over_time_path = "eventDesGo/overTime"
local event_des_path = "eventDesGo/eventDes"
local event_bg_path = "eventDesGo/eventBg"
local func_item_path = "functions/funcItem"
local functions_path = "functions"
local donate_path = "donate"
local gold_btn_path = "donate/BtnGo/GoldBtn"
local res_btn_path = "donate/BtnGo/ResBtn"
local gold_cost_path = "donate/BtnGo/GoldBtn/GoldCost"
local res_cost_path = "donate/BtnGo/ResBtn/resCost"
local res_icon_path = "donate/BtnGo/ResBtn/resCost/resIcon"
local original_time_text_path = "donate/OriginalTimeText"
local back_path = "bottom/ProgressBar/back"
local v_f_x_ui_zhoukabaoxiang_xiao_path = "bottom/VFX_ui_zhoukabaoxiang_xiao"
local lock_des_path = "topArea/lock/lockDes"
local tip_bg_path = "rankGO/tipBg"
local player_head_path = "rankGO/tipBg/UIPlayerHead"
local functionPositionY1 = -177
local functionScale1 = 0.76
local functionPositionY2 = 57
local functionScale2 = 1

function LWSeasonTrendsItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWSeasonTrendsItem:OnDestroy()
  self:ComponentDestroy()
  self.trendData = nil
  self.rankId = nil
  self.endTime = nil
  base.OnDestroy(self)
end

function LWSeasonTrendsItem:ComponentDefine()
  self.item_bg = self:AddComponent(UIRawImage, item_bg_path)
  self.descriptionText = self:AddComponent(UITextMeshProUGUI, description_text)
  self.titleText = self:AddComponent(UITextMeshProUGUI, title_text)
  self.point = self:AddComponent(UIImage, point_path)
  self.rewardFlagCon = self:AddComponent(UIBaseContainer, reward_flag_path)
  self.finishMaskCon = self:AddComponent(UIBaseContainer, finish_mask_path)
  self.back = self:AddComponent(UIImage, back_path)
  self.rankGo = self:AddComponent(UIBaseContainer, rank_path)
  self.rankGo:SetActive(false)
  self.rankBtn = self:AddComponent(UIButton, rank_btn_path)
  self.rankBtn:SetOnClick(function()
    self:RankBtnClick()
  end)
  self.shareBtnN = self:AddComponent(UIButton, shareBtn_path)
  self.shareBtnN:SetOnClick(function()
    DataCenter.LWSeasonTrendsManager:ShareTask(self.trendData)
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:InfoBtnClick()
  end)
  self.countdownCon = self:AddComponent(UIBaseContainer, countdown_path)
  self.countdownText = self:AddComponent(UITextMeshProUGUI, countdown_text_path)
  self.lockCon = self:AddComponent(UIBaseContainer, lock_path)
  self.progressText = self:AddComponent(UIText, progress_text_path)
  self.progressFrontCon = self:AddComponent(UIBaseContainer, progress_front_path)
  self.progressFrontConSize = self.progressFrontCon:GetSizeDelta()
  self.tip_bg = self:AddComponent(UIBaseContainer, bg_path)
  self.tip = self:AddComponent(UIBaseContainer, tip_path)
  self.tip:SetActive(false)
  self.isShowTip = false
  self.title = self:AddComponent(UIText, title_path)
  self.content = self:AddComponent(UIText, content_path)
  self.junp_btn = self:AddComponent(UIButton, junp_btn_path)
  self.tip_close_btn = self:AddComponent(UIButton, tip_close_btn_path)
  self.junp_btn:SetOnClick(function()
    DataCenter.LWSeasonTrendsManager:JumpWithType(self.jumpType, self.jumpData)
  end)
  self.tip_close_btn:SetOnClick(function()
    self.isShowTip = false
    self.tip:SetActive(false)
    self.jumpType = nil
    self.jumpData = nil
  end)
  self.get_reward_btn_new = self:AddComponent(UIButton, get_reward_btn_path_new)
  self.get_reward_btn_new:SetOnClick(function()
    self:GetRewardBtnClick()
  end)
  self.get_reward_img = self:AddComponent(UIImage, get_reward_btn_path_new)
  self.front = self:AddComponent(UIImage, front_path)
  self.eventDesGo = self:AddComponent(UIBaseContainer, event_des_go_path)
  self.over_time = self:AddComponent(UITextMeshProUGUIEx, over_time_path)
  self.event_des = self:AddComponent(UITextMeshProUGUIEx, event_des_path)
  self.event_bg = self:AddComponent(UIImage, event_bg_path)
  self.func_item = self:AddComponent(UIBaseContainer, func_item_path)
  self.functions = self:AddComponent(UIBaseContainer, functions_path)
  self.func_item:SetActive(false)
  self.func_item.gameObject:GameObjectCreatePool()
  self.donate = self:AddComponent(UIBaseContainer, donate_path)
  self.gold_btn = self:AddComponent(UIButton, gold_btn_path)
  self.gold_btn.clickSound = 6100018
  self.gold_cost = self:AddComponent(UITextMeshProUGUIEx, gold_cost_path)
  self.res_cost = self:AddComponent(UITextMeshProUGUIEx, res_cost_path)
  self.res_icon = self:AddComponent(UIImage, res_icon_path)
  self.original_time_text = self:AddComponent(UITextMeshProUGUIEx, original_time_text_path)
  self.giftEffect = self:AddComponent(UIBaseContainer, v_f_x_ui_zhoukabaoxiang_xiao_path)
  self.lock_des = self:AddComponent(UITextMeshProUGUIEx, lock_des_path)
  self.gold_btn:SetOnClick(function()
    self:DonateGold()
  end)
  self.res_btn = self:AddComponent(UILongPressTrigger, res_btn_path)
  self.res_btn:SetCallback(function()
    return self:DonateRes()
  end)
  self.res_btn:StartLongPressListener()
  self.tip_bg = self:AddComponent(UIImage, tip_bg_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.tip_bg:SetActive(false)
end

function LWSeasonTrendsItem:ComponentDestroy()
  if self.progressFrontConSize then
    self.progressFrontCon:SetSizeDelta(self.progressFrontConSize)
  end
  self.res_btn:StopLongPressListener()
  self:ClearFunItem()
  self.item_bg = nil
  self.progressFrontConSize = nil
  self.descriptionText = nil
  self.titleText = nil
  self.tip_bg = nil
  self.point = nil
  self.lock_des = nil
  self.rewardFlagCon = nil
  self.info_btn = nil
  self.finishMaskCon = nil
  self.rankGo = nil
  self.rankBtn = nil
  self.countdownCon = nil
  self.countdownText = nil
  self.lockCon = nil
  self.progressText = nil
  self.progressFrontCon = nil
  self.tip = nil
  self.title = nil
  self.content = nil
  self.junp_btn = nil
  self.get_reward_btn_new = nil
  self.get_reward_img = nil
  self.eventDesGo = nil
  self.over_time = nil
  self.front = nil
  self.event_bg = nil
  self.event_des = nil
  self.func_item = nil
  self.functions = nil
  self.donate = nil
  self.gold_btn = nil
  self.res_btn = nil
  self.gold_cost = nil
  self.res_cost = nil
  self.res_icon = nil
  self.original_time_text = nil
  self.back = nil
  self.giftEffect = nil
end

function LWSeasonTrendsItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonTrendDataFirstRankChange, self.OnFirstRankChange)
  self:AddUIListener(EventId.LWSeasonTrendDataRewardFlagChange, self.OnGetRewardCallback)
  self:AddUIListener(EventId.LWSeasonTrendsDonateSuccess, self.DonateSuccess)
end

function LWSeasonTrendsItem:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonTrendDataFirstRankChange, self.OnFirstRankChange)
  self:RemoveUIListener(EventId.LWSeasonTrendDataRewardFlagChange, self.OnGetRewardCallback)
  self:RemoveUIListener(EventId.LWSeasonTrendsDonateSuccess, self.DonateSuccess)
  base.OnRemoveListener(self)
end

function LWSeasonTrendsItem:OnFirstRankChange()
  if self.trendData then
    local firstRank = DataCenter.LWSeasonTrendsManager:GetTrendFirstRank(self.trendData.config_id)
    if firstRank then
      self.player_head:SetEnableClickShowInfo(true, true)
      self.player_head:ParseHeadInfo(firstRank)
      self.player_head:SetCustomClickCallback(function()
        self:RankBtnClick()
      end)
      self.tip_bg:SetActive(true)
    else
      self.tip_bg:SetActive(false)
    end
  end
end

function LWSeasonTrendsItem:SetSeasonTrendsItem(data, index)
  if index then
    self.index = index
  end
  self.tip_bg:SetActive(false)
  self.trendData = data
  self.endTime = nil
  local trendsConfig = LocalController:instance():getLine(TableName.LW_Season_Trends, self.trendData.config_id)
  self.targetCount = trendsConfig.para2
  self.info_btn:SetActive(trendsConfig.info and not string.IsNullOrEmpty(trendsConfig.info))
  self.shareBtnN:SetActive(trendsConfig.link and not string.IsNullOrEmpty(trendsConfig.link))
  self.rankId = trendsConfig.rank_name
  self.titleText:SetText(Localization:GetString(tostring(trendsConfig.stage_name)))
  self.descriptionText:SetText(Localization:GetString(trendsConfig.desc, self.targetCount))
  if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
    self.titleText:SetText("[" .. self.trendData.config_id .. "]" .. Localization:GetString(tostring(trendsConfig.stage_name)))
  end
  local state = DataCenter.LWSeasonTrendsManager:GetTrendsState(self.trendData)
  if state == SeasonTrendState.Open then
    self.endTime = self.trendData.end_time
    self:Update1000MS()
  end
  self.state = state
  self.eventDesGo:SetActive(state == SeasonTrendState.Expire)
  self.lockCon:SetActive(state == SeasonTrendState.NotOpen)
  self.item_bg:LoadSprite(trendsConfig.pic)
  local finishEvent = self.targetCount <= self.trendData.cur_count
  if state == SeasonTrendState.Expire then
    CS.UIGray.SetGray(self.item_bg.transform, true, false, true)
    CS.UIGray.SetGray(self.get_reward_img.transform, not finishEvent, true)
    CS.UIGray.SetGray(self.front.transform, not finishEvent)
    self.event_des:SetLocalText("season_trend_event_over")
    CS.UIGray.SetGray(self.event_bg.transform, false)
    self.over_time:SetColor(Color.New(0.6313725490196078, 0.7764705882352941, 0.19607843137254902, 1))
    self.event_des:SetColor(Color.New(0.6313725490196078, 0.7764705882352941, 0.19607843137254902, 1))
    local str = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.trendData.end_time)
    self.over_time:SetText(str)
  elseif state == SeasonTrendState.NotOpen then
    CS.UIGray.SetGray(self.item_bg.transform, false, false, true)
    CS.UIGray.SetGray(self.get_reward_img.transform, false, true)
    CS.UIGray.SetGray(self.front.transform, false)
    self.event_des:SetLocalText("season_trend_event_coming")
    CS.UIGray.SetGray(self.event_bg.transform, true)
    self.over_time:SetColor(Color.white)
    self.event_des:SetColor(Color.white)
    local str = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.trendData.start_time)
    self.over_time:SetText(str)
    local ymd = UITimeManager:GetInstance():GetTimeToLocalYMD(self.trendData.start_time)
    self.lock_des:SetText(ymd)
  else
    CS.UIGray.SetGray(self.item_bg.transform, false, false, true)
    CS.UIGray.SetGray(self.get_reward_img.transform, false, true)
    CS.UIGray.SetGray(self.front.transform, false)
  end
  if finishEvent then
    self.front:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_huang.png")
  else
    self.front:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_lv.png")
  end
  self.rewardFlagCon:SetActive(self.trendData.is_get_reward)
  self.giftEffect:SetActive(finishEvent and not self.trendData.is_get_reward)
  if finishEvent and self.trendData.is_get_reward then
    self.get_reward_btn_new:SetActive(false)
  else
    self.get_reward_btn_new:SetActive(true)
  end
  self.finishMaskCon:SetActive(false)
  self.countdownCon:SetActive(state == SeasonTrendState.Open)
  local rankFlag = not string.IsNullOrEmpty(trendsConfig.rank_name)
  self.rankGo:SetActive(rankFlag and (state == SeasonTrendState.Open or state == SeasonTrendState.Expire))
  self.progressText:SetText(self.trendData.cur_count .. "/" .. self.targetCount)
  local rate = self.trendData.cur_count / self.targetCount
  if 1 < rate then
    rate = 1
  elseif rate < 0 then
    rate = 0
  end
  self.progressFrontCon:SetSizeDeltaXY(self.progressFrontConSize.x * rate, self.progressFrontConSize.y)
  self.tip:SetActive(false)
  self.isShowTip = false
  self.rewards = self.trendData.reward_array
  if self.rewards then
  end
  self.donate:SetActive(state == SeasonTrendState.Open and trendsConfig.type == SeasonTrendTaskType.Dotnate)
  local data = DataCenter.LWSeasonTrendsManager:GetTrendsConfigData(self.trendData.groupIndex, self.trendData.config_id)
  if data and data.donataData then
    local remainCount = data.donataData.resource.count - self.trendData.day_donate
    if remainCount < 0 then
      remainCount = 0
      Logger.LogError("remainCount is less than 0\239\188\140 value:" .. remainCount)
    end
    self.original_time_text:SetLocalText(141114, remainCount .. "/" .. data.donataData.resource.count)
    local diamondCount = self:GetResourceNumByType(ResourceType.Gold)
    local resourceCount = self:GetResourceNumByType(data.donataData.resource.type)
    local spriteString = DataCenter.ResourceManager:GetResourceIconByType(data.donataData.resource.type)
    if diamondCount >= data.donataData.diamond then
      self.gold_cost:SetText(data.donataData.diamond)
    else
      self.gold_cost:SetText("<color=#ff0000>" .. data.donataData.diamond .. "</color>")
    end
    if resourceCount >= data.donataData.resource.cost then
      self.res_cost:SetText(data.donataData.resource.cost)
    else
      self.res_cost:SetText("<color=#ff0000>" .. data.donataData.resource.cost .. "</color>")
    end
    self.res_icon:LoadSprite(spriteString)
  end
  local functionActive = state ~= SeasonTrendState.Expire
  if functionActive then
    if functionUp then
      local functionUp = trendsConfig.type == SeasonTrendTaskType.Dotnate
      self.functions:SetLocalPositionXYZ(0, functionPositionY2, 0)
      self.functions:SetLocalScaleXYZ(functionScale2, functionScale2, functionScale2)
    else
      self.functions:SetLocalPositionXYZ(0, functionPositionY1, 0)
      self.functions:SetLocalScaleXYZ(functionScale1, functionScale1, functionScale1)
    end
    self:RefreshFunc()
    self.functions:SetActive(true)
  else
    self:ClearFunItem()
    self.functions:SetActive(false)
  end
  self:OnFirstRankChange()
end

function LWSeasonTrendsItem:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.countdownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.endTime = nil
      self.countdownText:SetText("")
    end
  end
  if self.rankGo and self.rankGo:GetActive() and self.tip_bg and not self.tip_bg:GetActive() then
    self:OnFirstRankChange()
  end
end

function LWSeasonTrendsItem:RankBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsRank, CommonRankPanelType.TrendsRank, self.trendData.config_id)
end

function LWSeasonTrendsItem:GetRewardBtnClick()
  if self.state == SeasonTrendState.NotOpen then
    UIUtil.ShowTips(Localization:GetString("390978"))
    return
  end
  local showTip = false
  if self.trendData.is_get_reward or self.trendData.cur_count < self.targetCount then
    showTip = true
  else
    showTip = false
  end
  if not showTip then
    SFSNetwork.SendMessage(MsgDefines.LWSeasonTrendReward, self.trendData.config_id)
  elseif self.rewards then
    local parame = self.rewards
    local x = self.get_reward_btn_new.transform.position.x
    local y = self.get_reward_btn_new.transform.position.y
    local width = self.get_reward_btn_new.rectTransform.rect.width
    local btnAnchor = CommonBoxShowRewardTipAnchor.Right
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCommonBoxShowRewardTip, nil, x, y, btnAnchor, width, 0, parame)
  end
end

function LWSeasonTrendsItem:ClickScreen(touchInfo)
  if self.isShowTip then
    local x = touchInfo.pointerPos.x
    local y = touchInfo.pointerPos.y
    local tipRect = self.tip_bg.rectTransform
    local uiPos = PosConverse.ScreenToUIPos(tipRect, touchInfo.pointerPos)
    if not tipRect.rect:Contains(uiPos) then
      self.isShowTip = false
      self.tip:SetActive(false)
      self.jumpType = nil
      self.jumpData = nil
    else
    end
  end
end

function LWSeasonTrendsItem:OnGetRewardCallback(trendId)
  if self.trendData.config_id == trendId then
    self:SetSeasonTrendsItem(self.trendData)
  end
end

function LWSeasonTrendsItem:InfoBtnClick()
  local trendsConfig = LocalController:instance():getLine(TableName.LW_Season_Trends, self.trendData.config_id)
  local param = {}
  param.type = "desc"
  param.desc = trendsConfig.info
  param.alignObject = self.info_btn
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function LWSeasonTrendsItem:ShowEventTip(jumpType, data, pos)
  local parent = self.rectTransform
  local _screenPos = PosConverse.UIWorldToScreenPos(pos)
  local targetScreenPos = _screenPos
  local uiPos = PosConverse.ScreenToUIPos(parent, targetScreenPos)
  local x = uiPos.x
  uiPos.y = uiPos.y + 160
  uiPos.x = 0
  self.tip.transform.anchoredPosition = uiPos
  uiPos.y = self.point.transform.anchoredPosition.y
  uiPos.x = x
  self.point.transform.anchoredPosition = uiPos
  self.isShowTip = true
  self.jumpType = jumpType
  self.jumpData = data
  local titleText, contentText
  if jumpType == SeasonTrendJumpType.Function or jumpType == SeasonTrendJumpType.City then
    self.junp_btn:SetActive(not string.IsNullOrEmpty(self.jumpData.jump))
  elseif jumpType == SeasonTrendJumpType.CardPool then
    self.junp_btn:SetActive(self.jumpData.cardId and 0 < self.jumpData.cardId)
  end
  titleText = CS.GameEntry.Localization:GetString(self.jumpData.name)
  contentText = CS.GameEntry.Localization:GetString(self.jumpData.desc)
  self.title:SetText(titleText)
  self.content:SetText(contentText)
  self.tip:SetActive(true)
end

function LWSeasonTrendsItem:ClearFunItem()
  self.functions:RemoveComponents(LWSeasonTrendsItemFun)
  self.func_item.gameObject:GameObjectRecycleAll()
end

function LWSeasonTrendsItem:RefreshFunc()
  local data = DataCenter.LWSeasonTrendsManager:GetTrendsConfigData(self.trendData.groupIndex, self.trendData.config_id)
  self:ClearFunItem()
  if data then
    if data.functionData then
      for index, value in ipairs(data.functionData) do
        local item = self.func_item.gameObject:GameObjectSpawn(self.functions.transform)
        item:SetActive(true)
        item.name = "function" .. tostring(index)
        local cell = self.functions:AddComponent(LWSeasonTrendsItemFun, item.name)
        cell:SetLocalPositionXYZ(0, 0, 0)
        cell:SetLocalScaleXYZ(1, 1, 1)
        cell:SetData(value, SeasonTrendJumpType.Function, self)
      end
    end
    if data.cityData then
      local item = self.func_item.gameObject:GameObjectSpawn(self.functions.transform)
      item:SetActive(true)
      item.name = "cityItem"
      local cell = self.functions:AddComponent(LWSeasonTrendsItemFun, item.name)
      cell:SetLocalPositionXYZ(0, 0, 0)
      cell:SetLocalScaleXYZ(1, 1, 1)
      cell:SetData(data.cityData, SeasonTrendJumpType.City, self)
    end
    if data.cardData then
      local item = self.func_item.gameObject:GameObjectSpawn(self.functions.transform)
      item:SetActive(true)
      item.name = "cardItem"
      local cell = self.functions:AddComponent(LWSeasonTrendsItemFun, item.name)
      cell:SetLocalPositionXYZ(0, 0, 0)
      cell:SetLocalScaleXYZ(1, 1, 1)
      cell:SetData(data.cardData, SeasonTrendJumpType.CardPool, self)
    end
  end
end

function LWSeasonTrendsItem:DonateRes()
  local data = DataCenter.LWSeasonTrendsManager:GetTrendsConfigData(self.trendData.groupIndex, self.trendData.config_id)
  local dayCount = toInt(self.trendData.day_donate)
  if dayCount < data.donataData.resource.count then
    local resourceCount = self:GetResourceNumByType(data.donataData.resource.type)
    if resourceCount >= data.donataData.resource.cost then
      DataCenter.LWSoundManager:PlaySound(6100018, false)
      SFSNetwork.SendMessage(MsgDefines.LWSeasonTrendDonate, self.trendData.config_id, 1)
      return true
    else
      UIUtil.ShowTips(Localization:GetString("season_trends_donata_tip001", DataCenter.ResourceManager:GetResourceNameByType(data.donataData.resource.type)))
    end
  else
    UIUtil.ShowTips(Localization:GetString("season_trends_donata_tip003"))
  end
  return false
end

function LWSeasonTrendsItem:GetResourceNumByType(resourceType)
  if DataCenter.ItemTemplateManager:GetItemTemplate(resourceType) ~= nil then
    local item = DataCenter.ItemData:GetItemById(resourceType)
    if item ~= nil then
      return item.count
    end
    return 0
  end
  return LuaEntry.Resource:GetCntByResType(resourceType)
end

function LWSeasonTrendsItem:DonateGold()
  local diamondCount = self:GetResourceNumByType(ResourceType.Gold)
  local data = DataCenter.LWSeasonTrendsManager:GetTrendsConfigData(self.trendData.groupIndex, self.trendData.config_id)
  if diamondCount >= data.donataData.diamond then
    SFSNetwork.SendMessage(MsgDefines.LWSeasonTrendDonate, self.trendData.config_id, 2)
  else
    UIUtil.ShowTips(Localization:GetString("season_trends_donata_tip001", DataCenter.ResourceManager:GetResourceNameByType(ResourceType.Gold)))
  end
end

function LWSeasonTrendsItem:DonateSuccess(data)
  if self.trendData.config_id == data.id then
    self:SetSeasonTrendsItem(self.trendData)
    local iconPath2 = DataCenter.ItemTemplateManager:GetAllianceItemIconPath(RewardType.ALLIANCE_DONATE)
    local startPos
    if data.type == 1 then
      startPos = self.res_btn.transform.position
    elseif data.type == 2 then
      startPos = self.gold_btn.transform.position
    end
    if startPos then
      UIUtil.DoFly(RewardType.GOODS, 3, iconPath2, startPos, self.back.transform.position)
    end
  end
end

return LWSeasonTrendsItem
