local DetectEventItemInfoView = BaseClass("DetectEventItemInfoView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local UIGiftRewardCell = require("UI.UIGiftPackageRewardGet.Component.UIGiftRewardCell")
local DetectEventRewardCell = require("UI.UILWRadarCenter.UIDetectEvent.Component.DetectEventRewardCell")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UICommonHorseLampTMP = require("UI.UICommonTMPHorseRaceLamp.Component.UICommonHorseLampTMP")
local title_text_path = "Detect_Event_Info_Title_Text"
local detect_event_time_go_path = "Detect_Event_Time_GO"
local disappear_time_text_path = "Detect_Event_Time_GO/Detect_Event_Info_Time_Text"
local Detect_Event_Cost_GO_path = "Detect_Event_Cost_GO"
local costNumTxt_path = "Detect_Event_Cost_GO/costNumTxt"
local description_text_path = "Detect_Event_Info_Description_Text"
local goto_btn_path = "Detect_Event_Info_Goto_Btn"
local goto_btn_text_path = "Detect_Event_Info_Goto_Btn/Detect_Event_Info_Goto_Btn_Layout/Detect_Event_Info_Goto_Btn_Text"
local goto_btn_img_path = "Detect_Event_Info_Goto_Btn/Detect_Event_Info_Goto_Btn_Layout/Detect_Event_Info_Goto_Btn_Img"
local reward_get_btn_path = "Detect_Event_Info_Reward_Get_Btn"
local reward_get_btn_text_path = "Detect_Event_Info_Reward_Get_Btn/Detect_Event_Info_Reward_Get_Btn_Text"
local gather_goto_btn_path = "Detect_Event_Info_Gather_Goto_Btn"
local gather_goto_btn_text_path = "Detect_Event_Info_Gather_Goto_Btn/Detect_Event_Info_Gather_Goto_Btn_Txt"
local marching_text_path = "Detect_Event_Marching_Text"
local scroll_view_path = "ScrollView"
local heroSpineContainerPath = "HeroSpineContainer"
local heroSpineContainerConPath = "HeroSpineContainer/Container"
local workerIconPath = "workerIcon"
local DetectEventBigIconPath = "DetectEventBigIcon"
local dialoguePosPath = "dialoguePos"
local dialogueTxtPath = "dialoguePos/kuangContent/kuangText"
local playerContent_path = "playerContent"
local uiPlayerHead_path = "playerContent/UIPlayerHead"
local frozen_mask_path = "frozenMask"
local multi_receive_text_path = "MultiReceiveText"
local item_pos_1 = 5
local item_pos_2 = 0

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UICommonHorseLampTMP, title_text_path)
  self.disappear_time_text = self:AddComponent(UIText, disappear_time_text_path)
  self.description_text = self:AddComponent(UIText, description_text_path)
  self.goto_btn_text = self:AddComponent(UIText, goto_btn_text_path)
  self.goto_btn_img = self:AddComponent(UIImage, goto_btn_img_path)
  self.reward_get_btn_text = self:AddComponent(UIText, reward_get_btn_text_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.reward_get_btn = self:AddComponent(UIButton, reward_get_btn_path)
  self.detect_event_time_go = self:AddComponent(UIBaseContainer, detect_event_time_go_path)
  self.marching_text = self:AddComponent(UIText, marching_text_path)
  self.detect_Event_Cost_GO = self:AddComponent(UIBaseContainer, Detect_Event_Cost_GO_path)
  self.costNumTxt = self:AddComponent(UIText, costNumTxt_path)
  self.reward_get_btn_text:SetLocalText(GameDialogDefine.GET_REWARD)
  self.marching_text:SetLocalText(GameDialogDefine.GO_TO_DETECT_EVENT_POINT)
  self.goto_btn_text:SetLocalText(GameDialogDefine.GOTO)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainerPath)
  self.heroSpineContainerCon = self:AddComponent(UIBaseContainer, heroSpineContainerConPath)
  self.workerIcon = self:AddComponent(UIRawImage, workerIconPath)
  self.DetectEventBigIcon = self:AddComponent(UIRawImage, DetectEventBigIconPath)
  self.playerContent = self:AddComponent(UIBaseContainer, playerContent_path)
  self.uiPlayerHead = self:AddComponent(UICommonHead, uiPlayerHead_path)
  self.dialoguePos = self:AddComponent(UIBaseContainer, dialoguePosPath)
  self.dialogueTxt = self:AddComponent(UIText, dialogueTxtPath)
  self.frozen_mask = self:AddComponent(UIImage, frozen_mask_path)
  self.frozen_mask:SetActive(false)
  self.goto_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.targetJumpUuid = self.uuid
    self.view.ctrl:Goto(self.uuid)
  end)
  self.reward_get_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:GetReward()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.gather_goto_btn = self:AddComponent(UIButton, gather_goto_btn_path)
  self.gather_goto_btn_text = self:AddComponent(UIText, gather_goto_btn_text_path)
  self.gather_goto_btn_text:SetLocalText(800826)
  self.gather_goto_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view.ctrl:Goto(self.uuid)
  end)
  self.multiReceiveTipText = self:AddComponent(UIText, multi_receive_text_path)
end

local function ShowCells(self)
  self:ClearScroll()
  if self.rewardList == nil then
    return
  end
  local count = table.count(self.rewardList)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICommonResItem)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  local rewardParam = self.rewardList[index]
  local param = DetectEventRewardCell.Param.New()
  param.rewardType = rewardParam.rewardType
  param.itemId = rewardParam.itemId
  param.count = rewardParam.count
  local effectVal = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_RADAR_RES_REWARD_ADD)
  if 0 < effectVal and (param.rewardType == RewardType.METAL or param.rewardType == RewardType.FOOD or param.rewardType == RewardType.WOOD) then
    param.isShowArrow = true
    param.count = math.min(param.count * (1 + effectVal))
  end
  if param.rewardType == RewardType.FOOD then
  elseif param.rewardType == RewardType.RESOURCE_ITEM and param.itemId == ResourceItemId.HeroExp then
    param.count = DataCenter.HeroStationManager:CalcEffectedValue(param.count, HeroStationEffectType.HeroExp)
    param.count = Mathf.Round(param.count)
  end
  cellItem:ReInit(param)
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, DetectEventRewardCell)
end

local function DataDefine(self)
  self.uuid = ""
  self.rewardList = {}
  self.lastSpinePath = nil
  self.heroSpineLoadRequest = nil
  self.targetJumpUuid = -1
  self.detectEventIsDoing = false
end

local function DataDestroy(self)
  self.uuid = nil
  self.rewardList = nil
  self.targetJumpUuid = nil
  self.frozen_mask = nil
  self.detectEventIsDoing = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self.heroSpineContainer = nil
  self.heroSpineContainerCon = nil
  self.lastSpinePath = nil
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self:RemoveCountdownSizeTween()
end

local function SetCurrentSelectUuid(self, uuid)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.RadarMissionsBtn, false)
  self.uuid = uuid
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  self.frozen_mask:SetActive(data.isFrozen)
  if data ~= nil then
    self.rewardList = {}
    for k, v in ipairs(data.rewardList) do
      table.insert(self.rewardList, v)
    end
    local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    if config ~= nil and config.type == 2 then
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(config.para)
      if monster ~= nil and monster:ExistAssociateActivity() then
        local rewardListNew = {}
        for _, item in ipairs(data.rewardList) do
          table.insert(rewardListNew, item)
        end
        local mgr = DataCenter.RewardManager
        local extra_reward_show = monster.with_extra_reward_show
        for _, v in ipairs(extra_reward_show) do
          if v ~= nil and v ~= "" then
            local show_info, itemId, rewardType, itemNum = string.match(v, "(%d+)[,;](%d+)[,;](%d+)[,;](%d+)")
            if show_info ~= nil then
              local existIt = false
              for _, item in ipairs(rewardListNew) do
                if item ~= nil and tonumber(item.itemId) == tonumber(itemId) then
                  item.count = item.count + tonumber(itemNum)
                  existIt = true
                  break
                end
              end
              if not existIt then
                local item = mgr:ParseOneRewardStr(v)
                if item ~= nil then
                  table.insert(rewardListNew, 1, item)
                end
              end
            end
          end
        end
        self.rewardList = rewardListNew
      end
    end
  end
  local vipWorkerEffectVal1 = toInt(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_VIP_WORKER_DETECT_REWARD_LIMIT))
  local vipWorkerEffectVal2 = toInt(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_VIP_WORKER_DETECT_REWARD_ADD_COUNT))
  local vipWorkerEffectVal3 = toInt(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_VIP_WORKER_DETECT_REWARD_CHANGE_ITEM))
  local accumulateCount = DataCenter.WorkerDataManager:GetVipWorkerAccumulateCount() or 0
  local vipWorkerGetNumToday = DataCenter.WorkerDataManager:GetVipWorkerRewardTimes()
  if 0 < vipWorkerEffectVal1 and 0 < vipWorkerEffectVal2 and 0 < vipWorkerEffectVal3 and vipWorkerGetNumToday < accumulateCount then
    local curCanGetNum = vipWorkerEffectVal2
    local maxGetNum = accumulateCount - vipWorkerGetNumToday
    curCanGetNum = math.min(curCanGetNum, maxGetNum)
    local vipWorkerRewardData = {
      rewardType = RewardType.GOODS,
      itemId = vipWorkerEffectVal3,
      count = curCanGetNum
    }
    table.insert(self.rewardList, 1, vipWorkerRewardData)
  end
  self:RefreshView()
end

local function RefreshView(self)
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if data == nil then
    return
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if data == nil or template == nil then
    return
  end
  local isGoto = DataCenter.RadarCenterDataManager:IsDetectEventDoing(self.uuid)
  self.detectEventIsDoing = isGoto
  local isCanGoType = data.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH or data.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD
  self.goto_btn:SetActive(isCanGoType and not isGoto)
  if isCanGoType and isGoto then
    if template.type == DetectEventType.GATHER_RESOURCE then
      self.gather_goto_btn:SetActive(true)
      self.marching_text:SetActive(false)
    else
      self.gather_goto_btn:SetActive(false)
      self.marching_text:SetActive(true)
    end
  else
    self.gather_goto_btn:SetActive(false)
    self.marching_text:SetActive(false)
  end
  self.reward_get_btn:SetActive(data.state == DetectEventState.DETECT_EVENT_STATE_FINISHED)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.title_text:SetTextWithLength(template:GetRealName(), 515, NoRollingAlignment.Right)
  else
    self.title_text:SetTextWithLength(template:GetRealName(), 515, NoRollingAlignment.Left)
  end
  self.description_text:SetLocalText(template.description)
  local qualityText = CommonUtil.GetDetectEventQualityName(template.quality)
  local color = CommonUtil.GetDetectEventQualityColor(template.quality)
  local queueImgPath = self.view.ctrl.GetQueueImgByType(template.type)
  if queueImgPath then
    self.goto_btn_img:SetActive(true)
    self.goto_btn_img:LoadSprite(queueImgPath)
    self.goto_btn_img:SetNativeSize()
  else
    self.goto_btn_img:SetActive(false)
  end
  if template.type == DetectEventType.HELPER then
    self.detect_Event_Cost_GO:SetActive(true)
    local CostNum = DataCenter.RadarCenterDataManager:GetDetectHelpTypeCostNum()
    self.costNumTxt:SetText(CostNum)
  else
    self.detect_Event_Cost_GO:SetActive(false)
  end
  self:ShowCells()
  self:ShowBigImg()
  self:CheckReceiveDoubleTip(data.startTime, template.type)
end

local function CheckReceiveDoubleTip(self, startTime, type)
  if IsNull(self.goto_btn) then
    return
  end
  if not (startTime and type) or type ~= DetectEventType.TREASURE or not self.goto_btn.gameObject.activeSelf then
    self.multiReceiveTipText:SetActive(false)
    return false
  end
  local curReceiveNumVal = MultiRewardDropUtils.GetCurRadarTreasureReceiveMultiValue(startTime / 1000)
  if curReceiveNumVal and 1 < curReceiveNumVal then
    self.multiReceiveTipText:SetActive(true)
    self.multiReceiveTipText:SetLocalText("activity_multiple_tips2", curReceiveNumVal)
  else
    self.multiReceiveTipText:SetActive(false)
  end
end

local function ShowBigImg(self)
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  local modelId = template.appearance_id
  local dialogueId = template.plot_id
  self.playerContent:SetActive(false)
  self.heroSpineContainer:SetActive(false)
  self.workerIcon:SetActive(false)
  self.DetectEventBigIcon:SetActive(false)
  if template.type == DetectEventType.HELPER then
    self.playerContent:SetActive(true)
    local framePath = DataCenter.DecorationDataManager:GetHeadFrame(data.helpInfo.headSkinId, data.helpInfo.headSkinET, false)
    local activityHeadIcon = DataCenter.ActivityListDataManager:GetActivityRadarHeadIcon(true)
    self.uiPlayerHead:SetData(data.helpInfo.uid, activityHeadIcon and activityHeadIcon or data.helpInfo.pic, data.helpInfo.picVer, nil, framePath)
  elseif 0 < modelId and template.type ~= DetectEventType.FAKE_PLAYER then
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(modelId)
    local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
    if string.IsNullOrEmpty(spinePath) == false then
      self.heroSpineContainer:SetActive(true)
      if self.lastSpinePath ~= spinePath then
        if self.heroSpineLoadRequest ~= nil then
          self.heroSpineLoadRequest:Destroy()
          self.heroSpineLoadRequest = nil
        end
        local request = ResourceManager:InstantiateAsync(spinePath)
        self.heroSpineLoadRequest = request
        request:completed("+", function()
          if request.isError or request.gameObject == nil then
            self.heroSpineLoadRequest = nil
            return
          end
          request.gameObject:SetActive(true)
          local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
          if rectTransform ~= nil then
            local spineScale = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_scale")
            local spinePos = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_pos")
            rectTransform:SetParent(self.heroSpineContainerCon.transform)
            rectTransform:Set_localScale(spineScale, spineScale, 1)
            rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
          end
        end)
        self.lastSpinePath = spinePath
      end
      self.heroSpineContainer:SetActive(false)
      self.heroSpineContainer:SetActive(true)
    else
      self.workerIcon:SetActive(true)
      self.workerIcon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(modelId, HeroIconType.pose_icon_path), function(texture)
        if self and self.workerIcon then
          self.workerIcon:SetNativeSize()
        end
      end)
    end
  else
    self.DetectEventBigIcon:SetActive(true)
    local digIcon
    if template.type == DetectEventType.TREASURE then
      digIcon = DataCenter.ActivityListDataManager:GetActivityRadarDigImage()
    end
    if data.isFrozen then
      self.DetectEventBigIcon:LoadSpriteAsync(digIcon and digIcon or template:GetDetectEventBannerImage1Path())
    else
      self.DetectEventBigIcon:LoadSpriteAsync(digIcon and digIcon or template:GetDetectEventBannerImagePath())
    end
  end
  self:TryPlayDialogue(dialogueId)
end

local function TryPlayDialogue(self, dialogueId)
  local uuid = self.uuid
  local dialogueId = dialogueId
  local isFirst = DataCenter.RadarCenterDataManager:IsDetectEventFirstOpen(uuid)
  if 0 < dialogueId and isFirst then
    DataCenter.RadarCenterDataManager:RecordDetectEventFirstOpen(uuid)
    self.dialogueTxt:SetLocalText(dialogueId)
    self.dialoguePos:SetActive(false)
    self.dialoguePos:SetActive(true)
  else
    self.dialoguePos:SetActive(false)
  end
end

local function Update(self)
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if data == nil or data.state == DetectEventState.DETECT_EVENT_STATE_REWARDED then
    self.view:SetCurrentSelectItemId(nil)
    return
  end
  local refreshTime = data.endTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = (refreshTime - curTime) / 1000
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
  if template.type == DetectEventType.DetectEventTypeSpecial or template.type == DetectEventType.DetectEventRadarRally or template.type == DetectEventType.DetectEventPVE or template.type == DetectEventType.SPECIAL_OPS or template.type == DetectEventType.ZOMBIE_BUS_TRAIN or template.type == DetectEventType.PARKOUR_BATTLE or data.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
    self.detect_event_time_go:SetActive(false)
    self:RemoveCountdownSizeTween()
  else
    self.detect_event_time_go:SetActive(true)
    if 0 <= leftTime then
      self.disappear_time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(leftTime))
      local isOutTime = leftTime <= 3600
      local showTween = isOutTime and data.state ~= DetectEventState.DETECT_EVENT_STATE_FINISHED and not self.detectEventIsDoing
      if showTween then
        self:PlayCountdownSizeTween()
      else
        self:RemoveCountdownSizeTween()
      end
    else
      self:RemoveCountdownSizeTween()
      if data.state ~= DetectEventState.DETECT_EVENT_STATE_FINISHED then
        EventManager:GetInstance():Broadcast(EventId.DetectInfoChange)
      end
    end
  end
end

local function OnAddListener(self)
  self:AddUIListener(EventId.GetAllDetectInfo, self.DoWhenDataChange)
  self:AddUIListener(EventId.UpgradeDetectPower, self.DoWhenDataChange)
  self:AddUIListener(EventId.DetectInfoChange, self.DoWhenDataChange)
  self:AddUIListener(EventId.DetectEventGetRealPoint, self.DoGetEventRealPoint)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetAllDetectInfo, self.DoWhenDataChange)
  self:RemoveUIListener(EventId.UpgradeDetectPower, self.DoWhenDataChange)
  self:RemoveUIListener(EventId.DetectInfoChange, self.DoWhenDataChange)
  self:RemoveUIListener(EventId.DetectEventGetRealPoint, self.DoGetEventRealPoint)
end

local function DoWhenDataChange(self)
  self:RefreshView()
end

local function GetReward(self)
  SFSNetwork.SendMessage(MsgDefines.DetectEventRewardReceive, self.uuid)
  self.view:SetCurrentSelectItemId(nil)
end

local function OnInfoClick(self)
end

local function OnResetClick(self)
  self.view.ctrl:ResetDetectEvent(self.uuid)
  self.view:SetCurrentSelectItemId(nil)
end

local function DoGetEventRealPoint(self, uuid)
  if self.targetJumpUuid == uuid then
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
    if data ~= nil and data.state ~= DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD then
      self.view.ctrl:Goto(self.uuid)
    end
  end
end

local function PlayCountdownSizeTween(self)
  if self.tweenSequence == nil then
    self.tweenSequence = CS.DG.Tweening.DOTween.Sequence()
    self.tweenSequence:Append(self.detect_event_time_go.transform:DOScale(Vector3.New(1.2, 1.2, 2), 0.5):SetEase(CS.DG.Tweening.Ease.Linear))
    self.tweenSequence:Append(self.detect_event_time_go.transform:DOScale(Vector3.New(1, 1, 1), 0.5):SetEase(CS.DG.Tweening.Ease.Linear))
    self.tweenSequence:SetLoops(-1)
  end
end

local function RemoveCountdownSizeTween(self)
  if self.tweenSequence then
    self.tweenSequence:Kill()
    self.tweenSequence = nil
    if self.detect_event_time_go then
      self.detect_event_time_go:SetLocalScaleXYZ(1, 1, 1)
    end
  end
end

DetectEventItemInfoView.OnCreate = OnCreate
DetectEventItemInfoView.OnDestroy = OnDestroy
DetectEventItemInfoView.ComponentDefine = ComponentDefine
DetectEventItemInfoView.ComponentDestroy = ComponentDestroy
DetectEventItemInfoView.DataDefine = DataDefine
DetectEventItemInfoView.DataDestroy = DataDestroy
DetectEventItemInfoView.SetCurrentSelectUuid = SetCurrentSelectUuid
DetectEventItemInfoView.RefreshView = RefreshView
DetectEventItemInfoView.OnAddListener = OnAddListener
DetectEventItemInfoView.OnRemoveListener = OnRemoveListener
DetectEventItemInfoView.DoWhenDataChange = DoWhenDataChange
DetectEventItemInfoView.OnCreateCell = OnCreateCell
DetectEventItemInfoView.OnDeleteCell = OnDeleteCell
DetectEventItemInfoView.GetReward = GetReward
DetectEventItemInfoView.Update = Update
DetectEventItemInfoView.ShowCells = ShowCells
DetectEventItemInfoView.ClearScroll = ClearScroll
DetectEventItemInfoView.OnInfoClick = OnInfoClick
DetectEventItemInfoView.OnResetClick = OnResetClick
DetectEventItemInfoView.ShowBigImg = ShowBigImg
DetectEventItemInfoView.TryPlayDialogue = TryPlayDialogue
DetectEventItemInfoView.DoGetEventRealPoint = DoGetEventRealPoint
DetectEventItemInfoView.CheckReceiveDoubleTip = CheckReceiveDoubleTip
DetectEventItemInfoView.PlayCountdownSizeTween = PlayCountdownSizeTween
DetectEventItemInfoView.RemoveCountdownSizeTween = RemoveCountdownSizeTween
return DetectEventItemInfoView
