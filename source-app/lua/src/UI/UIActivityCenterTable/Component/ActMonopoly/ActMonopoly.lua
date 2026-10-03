local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ActMonopoly = BaseClass("ActMonopoly", base)
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local ResourceManager = CS.GameEntry.Resource
local ActMonopolyGridItem = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyGridItem")
local UIActMonopolyModelNewManager = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyModelNewManager.UIActMonopolyModelNewManager")
local ActMonopolyBottomBtnContent = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyBottomBtnContent")
local ActMonopolyBossContent = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyBossContent")
local ActMonopolyCostShowContent = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyCostShowContent")
local ActMonopolyRewardBoxContent = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyRewardBoxContent")
local ActMonopolyShopBtnContent = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyShopBtnContent")
local ActMonopolySaveEventContent = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolySaveEventContent")
local ActMonopolyTaskContent = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyTaskContent")
local ActMonopolyTopRightBtnsContent = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyTopRightBtnsContent")
local ActMonopolyEffectContent = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyEffectContent")
local ActMonopolyItemUseBtnContent = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyItemUseBtnContent")
local GRID_ITEM_PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/Item/monopolyGridItem.prefab"
local root_path = "root"
local rect_path = "root/rect"
local bg_raw_img_path = "root/bg/bgRawImg"
local bg_raw_img1_path = "root/bg/bgRawImg1"
local bg_raw_img2_path = "root/bg/bgRawImg2"
local txt_act_name_path = "root/rect/ActivityTopGo/Txt_ActName"
local txt_times_path = "root/rect/ActivityTopGo/TimeContent/bg/timeBg/Txt_Times"
local monopolyGridItem_path = "root/rect/CenterMonopolyContent/monopolyGridItem"
local content_path = "root/rect/CenterMonopolyContent/content"
local diceContent_path = "root/rect/diceContent"
local dice1_path = "root/rect/diceContent/dice_root/dice1"
local dice2_path = "root/rect/diceContent/dice_root/dice2"
local skipBtn_path = "root/rect/bottomContent/skipBtn"
local skipBtnBeSelect_path = "root/rect/bottomContent/skipBtn/skipBtnBeSelect"
local auto_btn_path = "root/rect/bottomContent/autoBtn"
local auto_btn_be_select_path = "root/rect/bottomContent/autoBtn/autoBtnBeSelect"
local auto_content_path = "root/rect/bottomContent/autoContent"
local stop_auto_btn_path = "root/rect/bottomContent/autoContent/StopAutoBtn"
local auto_content_text_path = "root/rect/bottomContent/autoContent/txtContent/AutoContentText"
local bg_effect_content_path = "root/bg/bgRawImg/bgEffectContent"
local model_show_raw_img_path = "root/rect/CenterMonopolyContent/modelShowContent/modelShowRawImg"
local time_content_path = "root/rect/ActivityTopGo/TimeContent"
local eff_ui_halloween2025_monopoly_up_root_path = "root/rect/Eff_ui_Halloween2025_Monopoly_up_Root"
local screen_eff_point_path = "root/rect/ScreenEffPoint"
local GridOriginPosX = 38.977
local GridOriginPosY = -84.7
local X_AxisVectorX = 72.325
local X_AxisVectorY = 51.6
local Y_AxisVectorX = -72.325
local Y_AxisVectorY = 51.6
local roleImgDiffPosY = -50
local oneDiceAniName = "Eff_ui_dfw_touzi_chuxian_dan"
local doubleDiceAniName = "Eff_ui_dfw_touzi_chuxian_shuang"
local normalSpeedTime = 0.5
local quickMultiple = 12
local diceTime = 2
local showRawImageSizeX = 800
local showRawImageSizeY = 900
local ActMonopolySkipBtnKeyStr = "ActMonopolySkipBtnKey"
local ActMonopolyAutoBtnKeyStr = "ActMonopolyAutoBtnKey"
local StopDiceReasonType = {None = 0, FreeNumEmpty = 1}

function ActMonopoly:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ActMonopoly:OnDestroy()
  self:StopDelayTimer()
  self:CloseAniSeq()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActMonopoly:ComponentDefine()
  self.aniRoot = self:AddComponent(UIAnimator, "")
  self.bg_raw_img = self:AddComponent(UIRawImage, bg_raw_img_path)
  self.txt_act_name = self:AddComponent(UITextMeshProUGUIEx, txt_act_name_path)
  self.txt_times = self:AddComponent(UIText, txt_times_path)
  self.gridItemDict = {}
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.diceContent = self:AddComponent(UIBaseContainer, diceContent_path)
  self.dice1 = self:AddComponent(UIImage, dice1_path)
  self.dice2 = self:AddComponent(UIImage, dice2_path)
  self.skipBtn = self:AddComponent(UIButton, skipBtn_path)
  self.skipBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickSkipBtn()
  end)
  self.skipBtnBeSelect = self:AddComponent(UIBaseContainer, skipBtnBeSelect_path)
  self.auto_btn = self:AddComponent(UIButton, auto_btn_path)
  self.auto_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickAutoBtn()
  end)
  self.auto_btn_be_select = self:AddComponent(UIBaseContainer, auto_btn_be_select_path)
  self.auto_content = self:AddComponent(UIBaseContainer, auto_content_path)
  self.stop_auto_btn = self:AddComponent(UIButton, stop_auto_btn_path)
  self.stop_auto_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickStopAutoBtn()
  end)
  self.model_show_raw_img = self:AddComponent(UIRawImage, model_show_raw_img_path)
  self.model_show_raw_img:SetActive(false)
  self.model_content = UIActMonopolyModelNewManager.New()
  self.model_content:SetRawImgData(self.model_show_raw_img, showRawImageSizeX, showRawImageSizeY)
  self.bottomBtnContent = self:AddComponent(ActMonopolyBottomBtnContent, rect_path)
  self.bossContent = self:AddComponent(ActMonopolyBossContent, rect_path)
  self.costShowContent = self:AddComponent(ActMonopolyCostShowContent, rect_path)
  self.rewardBoxContent = self:AddComponent(ActMonopolyRewardBoxContent, rect_path)
  self.shopBtnContent = self:AddComponent(ActMonopolyShopBtnContent, rect_path)
  self.saveEventContent = self:AddComponent(ActMonopolySaveEventContent, rect_path)
  self.taskContent = self:AddComponent(ActMonopolyTaskContent, rect_path)
  self.topRightBtnsContent = self:AddComponent(ActMonopolyTopRightBtnsContent, rect_path)
  self.auto_content_text = self:AddComponent(UITextMeshProUGUIEx, auto_content_text_path)
  self.effectContent = self:AddComponent(ActMonopolyEffectContent, rect_path)
  self.itemUseBtnContent = self:AddComponent(ActMonopolyItemUseBtnContent, rect_path)
  self.bg_effect_content = self:AddComponent(UIVfx, bg_effect_content_path)
  self.bg_raw_img1 = self:AddComponent(UIRawImage, bg_raw_img1_path)
  self.bg_raw_img2 = self:AddComponent(UIRawImage, bg_raw_img2_path)
  self.time_content = self:AddComponent(UIBaseContainer, time_content_path)
  local hLayout = typeof(CS.BidirectionalHorizontalLayoutGroup)
  self.sceneEffRoot = self:AddComponent(UIBaseComponent, eff_ui_halloween2025_monopoly_up_root_path)
  self.rootAni = self:AddComponent(UIAnimator, root_path)
  self.screenEffPoint = self:AddComponent(UIBaseComponent, screen_eff_point_path)
end

function ActMonopoly:ComponentDestroy()
  self:ClearAllGridItem()
  self.txt_act_name = nil
  self.txt_times = nil
  self.intro_btn = nil
  self.btn_shop = nil
  self.bg_effect_content = nil
  self.bg_raw_img1 = nil
  self.bg_raw_img2 = nil
  if self.model_content then
    self.model_content:Delete()
    self.model_content = nil
  end
  self.time_content = nil
  if self.sceneEffReq then
    self.sceneEffReq:Destroy()
    self.sceneEffReq = nil
  end
  if self.screenDelayTimer then
    self.screenDelayTimer:Stop()
    self.screenDelayTimer = nil
  end
  if self.screenEffDisappearTimer then
    self.screenEffDisappearTimer:Stop()
    self.screenEffDisappearTimer = nil
  end
  if self.dinosaurDelayTimer then
    self.dinosaurDelayTimer:Stop()
    self.dinosaurDelayTimer = nil
  end
end

function ActMonopoly:ClearAllGridItem()
  self.content:RemoveComponents(ActMonopolyGridItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.gridItemDict = {}
  if self.allGridItemReqDic then
    for _, v in ipairs(self.allGridItemReqDic) do
      v:Destroy()
    end
    self.allGridItemReqDic = nil
  end
end

function ActMonopoly:DataDefine()
  self.activityId = nil
  self.activityInfo = nil
  self.activityDetailData = nil
  self.costData = nil
  self.isBoss = nil
  self.curState = ActMonopolyState.Idle
  self.actGridTempList = {}
  self.showGridOrderList = {}
  self.waitBackMsgTime = 0
  self.waitTaskContentRefresh = false
  self.tweenMsg = nil
  self.startIndex = nil
  self.endIndex = nil
  self.tweenMoveDir = nil
  self.curIndex = nil
  self.passOneIndexTween = nil
  self.havePlayPassOneIndexTween = nil
  self.aniSeq = nil
  self.delayTimer = nil
  self.isSkip = 0
  self.isAuto = 0
  self.isAutoStart = false
  self.isDiceUseFreeAtAuto = false
  self.loopTaskFlyItem = -1
  self.isRoleImgLoading = false
  self.isRoleImgLoadingMaxTime = 0
end

function ActMonopoly:DataDestroy()
  self.activityId = nil
  self.activityInfo = nil
  self.activityDetailData = nil
  self.loopTaskFlyItem = nil
  if self.diceSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.diceSoundHandle)
    self.diceSoundHandle = nil
  end
  if self.jumpSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.jumpSoundHandle)
    self.jumpSoundHandle = nil
  end
  if self.dikuai_shuaguangSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.dikuai_shuaguangSoundHandle)
    self.dikuai_shuaguangSoundHandle = nil
  end
  if self.dikuai_jiangliSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.dikuai_jiangliSoundHandle)
    self.dikuai_jiangliSoundHandle = nil
  end
end

function ActMonopoly:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMonopolyDetailData, self.GetActMonopolyDetailDataMsg)
  self:AddUIListener(EventId.GetActMonopolyDiceResultMsg, self.GetDiceResultMsg)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.GetOnRewardGetPanelCloseMsg)
  self:AddUIListener(EventId.ActMonopolyDailyRewardUpdate, self.RefreshView)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.RefreshView)
  self:AddUIListener(EventId.ActMonopolyShopViewClose, self.GetShopCloseMsg)
  self:AddUIListener(EventId.GetActMonopolyShopMsg, self.OnGetShopDataChangeMsg)
  self:AddUIListener(EventId.GetActMonopolyShoUpdatepMsg, self.OnGetShopDataChangeMsg)
  self:AddUIListener(EventId.ActMonopolyAutoEventDataAdd, self.OnGetActMonopolySaveEventDataAddMsg)
  self:AddUIListener(EventId.ActMonopolyAutoEventDataReceive, self.OnGetActMonopolySaveEventDataReceiveMsg)
  self:AddUIListener(EventId.ActMonopolyDamageRewardGet, self.OnGetActMonopolyDamageRewardGet)
  self:AddUIListener(EventId.ActTaskRewardGet, self.RefreshTaskContent)
  self:AddUIListener(EventId.GetActTaskDataUpdateMsg, self.RefreshTaskContentWithoutDic)
  self:AddUIListener(EventId.ActDetectTreasureInfoGet, self.RefreshActDetectTreasureRed)
  self:AddUIListener(EventId.ActMonopolyRoleLoadFin, self.OnActMonopolyRoleLoadFin)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:AddUIListener(EventId.ActMonopolyEventTipClose, self.EventTipClose)
  self:AddUIListener(EventId.UpdateGold, self.UpdateGoldMsg)
  self:AddUIListener(EventId.ActMonopolyAutoContinueDiceSpecial, self.GetActMonopolyAutoContinueDiceSpecialMsg)
end

function ActMonopoly:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActMonopolyDetailData, self.GetActMonopolyDetailDataMsg)
  self:RemoveUIListener(EventId.GetActMonopolyDiceResultMsg, self.GetDiceResultMsg)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.GetOnRewardGetPanelCloseMsg)
  self:RemoveUIListener(EventId.ActMonopolyDailyRewardUpdate, self.RefreshView)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.RefreshView)
  self:RemoveUIListener(EventId.ActMonopolyShopViewClose, self.GetShopCloseMsg)
  self:RemoveUIListener(EventId.GetActMonopolyShopMsg, self.OnGetShopDataChangeMsg)
  self:RemoveUIListener(EventId.GetActMonopolyShoUpdatepMsg, self.OnGetShopDataChangeMsg)
  self:RemoveUIListener(EventId.ActMonopolyAutoEventDataAdd, self.OnGetActMonopolySaveEventDataAddMsg)
  self:RemoveUIListener(EventId.ActMonopolyAutoEventDataReceive, self.OnGetActMonopolySaveEventDataReceiveMsg)
  self:RemoveUIListener(EventId.ActMonopolyDamageRewardGet, self.OnGetActMonopolyDamageRewardGet)
  self:RemoveUIListener(EventId.ActTaskRewardGet, self.RefreshTaskContent)
  self:RemoveUIListener(EventId.GetActTaskDataUpdateMsg, self.RefreshTaskContentWithoutDic)
  self:RemoveUIListener(EventId.ActDetectTreasureInfoGet, self.RefreshActDetectTreasureRed)
  self:RemoveUIListener(EventId.ActMonopolyRoleLoadFin, self.OnActMonopolyRoleLoadFin)
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:RemoveUIListener(EventId.ActMonopolyEventTipClose, self.EventTipClose)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldMsg)
  self:RemoveUIListener(EventId.ActMonopolyAutoContinueDiceSpecial, self.GetActMonopolyAutoContinueDiceSpecialMsg)
end

function ActMonopoly:OnEnable()
  base.OnEnable(self)
  if self.activityId then
    if self.activityInfo then
      self.model_content:StartShow(self.activityInfo.richman_para)
    end
    self.curState = ActMonopolyState.Idle
    self.isAutoStart = false
    self.isDiceUseFreeAtAuto = false
    self.isPlayShopBtnAni = false
    self.waitTaskContentRefresh = false
    self:RefreshView()
  end
  if self.screenEffReq and IsNotNull(self.screenEffReq.gameObject) then
    if self.dinosaurDelayTimer then
      self.dinosaurDelayTimer:Stop()
      self.dinosaurDelayTimer = nil
    end
    self.dinosaurDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.dinosaurSoundHandle = DataCenter.LWSoundManager:PlaySound(91128, false)
      self.dinosaurDelayTimer = nil
    end, 1.2)
  end
end

function ActMonopoly:OnDisable()
  base.OnDisable(self)
  self:StopDelayTimer()
  self:CloseAniSeq()
  if self.dinosaurSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.dinosaurSoundHandle)
    self.dinosaurSoundHandle = nil
  end
  self.model_content:EndShow()
  if self.sceneEffReq then
    self.sceneEffReq:Destroy()
    self.sceneEffReq = nil
  end
end

function ActMonopoly:GetActMonopolyDetailDataMsg()
  self:SetData(self.activityId)
end

function ActMonopoly:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActMonopolyDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    self:RefreshNoDataView()
    return
  end
  self.isBoss = self.activityDetailData:IsOpenBoss()
  self.curState = ActMonopolyState.Idle
  self.isSkip = Setting:GetInt(ActMonopolySkipBtnKeyStr, 0)
  self.isAuto = Setting:GetInt(ActMonopolyAutoBtnKeyStr, 0)
  self.isAutoStart = false
  self.isDiceUseFreeAtAuto = false
  self.isPlayShopBtnAni = false
  self.waitTaskContentRefresh = false
  self.model_show_raw_img:SetActive(false)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.isRoleImgLoading = true
  self.isRoleImgLoadingMaxTime = curTime + 3000
  self:InitData()
  self:InitView()
  self:RefreshView()
  local rolePath, aniPath
  local showTemp = self.activityInfo:GetShowConfigTemp()
  if showTemp and not string.IsNullOrEmpty(showTemp.pic_spec5) then
    local dataStr = string.split(showTemp.pic_spec5, "|")
    if #dataStr == 2 then
      rolePath = dataStr[1]
      aniPath = dataStr[2]
    elseif #dataStr == 1 then
      rolePath = dataStr[1]
    end
  end
  self.model_content:SetIsMonsterShow(self.isBoss)
  self.model_content.modelNewRoleManager:SetRoleResPath(rolePath, aniPath)
  self.model_content:StartShow(self.activityInfo.richman_para)
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = true
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
end

function ActMonopoly:InitData()
  local group = self.activityDetailData.group
  self.actGridTempList = DataCenter.ActMonopolyDataManager:GetMonopolyTempListByGroup(group)
  self.showGridOrderList = {}
  for index, temp in ipairs(self.actGridTempList) do
    local data = {
      index = index,
      posShowOrder = temp.posShowOrder
    }
    table.insert(self.showGridOrderList, data)
  end
  table.sort(self.showGridOrderList, function(a, b)
    return a.posShowOrder > b.posShowOrder
  end)
  local sep1 = "|"
  local sep2 = ","
  local sep3 = ";"
  self.costData = {}
  local costStr = self.activityInfo.para_4
  local oneTypeCostStr = string.split(costStr, sep1)
  for i = 1, #oneTypeCostStr do
    local typeCostStr = oneTypeCostStr[i]
    local costRewardStr = string.split(typeCostStr, sep2)
    self.costData[i] = {}
    for j = 1, #costRewardStr do
      local rewardStr = costRewardStr[j]
      local rewardParam = string.split(rewardStr, sep3)
      if #rewardParam == 3 then
        local type = tonumber(rewardParam[1])
        local itemId = tonumber(rewardParam[2])
        local count = tonumber(rewardParam[3])
        local rewardType = type
        if type == 1 then
          rewardType = ResTypeToReward[itemId]
        end
        local rewardData = {
          type = rewardType,
          itemId = itemId,
          count = count
        }
        table.insert(self.costData[i], rewardData)
      end
    end
  end
end

function ActMonopoly:InitView()
  local bannerName = self.activityInfo.activity_pic
  if not string.IsNullOrEmpty(bannerName) then
    local bannerPath = string.format(UIAssets.UIActMonopolyTexturePath, bannerName)
    self.bg_raw_img:LoadSpriteAsync(bannerPath)
  end
  self:InitGridView()
  self:SetConfigView()
  local mainView = self
  self.bottomBtnContent:SetData(mainView, self.activityId, self.activityInfo, self.activityDetailData, self.costData, self.isBoss)
  self.bossContent:SetData(mainView, self.activityId, self.activityInfo, self.activityDetailData, self.costData, self.isBoss)
  self.costShowContent:SetData(mainView, self.activityId, self.activityInfo, self.activityDetailData, self.costData, self.isBoss)
  self.rewardBoxContent:SetData(mainView, self.activityId, self.activityInfo, self.activityDetailData, self.costData, self.isBoss)
  self.shopBtnContent:SetData(mainView, self.activityId, self.activityInfo, self.activityDetailData, self.costData, self.isBoss)
  self.saveEventContent:SetData(mainView, self.activityId, self.activityInfo, self.activityDetailData, self.costData, self.isBoss)
  self.taskContent:SetData(mainView, self.activityId, self.activityInfo, self.activityDetailData, self.costData, self.isBoss)
  self.topRightBtnsContent:SetData(mainView, self.activityId, self.activityInfo, self.activityDetailData, self.costData, self.isBoss)
  self.effectContent:SetData(mainView, self.activityId, self.activityInfo, self.activityDetailData, self.costData, self.isBoss)
  self.itemUseBtnContent:SetData(mainView, self.activityId, self.activityInfo, self.activityDetailData, self.costData, self.isBoss)
  self.model_content.modelNewGridItemManager:SetData(self.activityId, self.activityInfo, self.activityDetailData, self.actGridTempList)
end

function ActMonopoly:GetGridAAnchoredPosByIndex(index)
  local temp = self.actGridTempList[index]
  local posX = temp.posData.x
  local posY = temp.posData.y
  return self:GetGridAnchoredPos(posX, posY)
end

function ActMonopoly:GetGridAnchoredPos(posX, posY)
  local aPosX = 0
  local aPosY = 0
  local rate = 0.99
  aPosX = GridOriginPosX + (posX * X_AxisVectorX + posY * Y_AxisVectorX) * rate
  aPosY = GridOriginPosY + (posX * X_AxisVectorY + posY * Y_AxisVectorY) * rate
  return aPosX, aPosY
end

function ActMonopoly:InitGridView()
  self:ClearAllGridItem()
  self.allGridItemReqDic = self.allGridItemReqDic or {}
  local laodFinishCount = 0
  for showIndex, v in ipairs(self.showGridOrderList) do
    local index = v.index
    local itemReq = ResourceManager:InstantiateAsync(GRID_ITEM_PREFAB_PATH)
    itemReq:completed("+", function()
      if itemReq.isError then
        itemReq = nil
        self.allGridItemReqDic[index] = nil
        return
      end
      local gridObj = itemReq.gameObject
      gridObj.transform:SetParent(self.content.transform)
      gridObj.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      gridObj.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      local name = tostring(showIndex)
      gridObj.transform.name = name
      local obj = self.content:AddComponent(ActMonopolyGridItem, name)
      if not obj.actieSelf then
        obj:SetActive(true)
      end
      self.gridItemDict[index] = obj
      local aPosX, aPosY = self:GetGridAAnchoredPosByIndex(index)
      obj:SetAnchoredPositionXY(aPosX * CommonUtil.ArabicAutoMirrorFactor(), aPosY)
      laodFinishCount = laodFinishCount + 1
      if showIndex == laodFinishCount then
        self.gridLoadFin = true
        self:RefreshGridItemView()
      end
    end)
    self.allGridItemReqDic[index] = itemReq
  end
end

function ActMonopoly:RefreshView()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  self:RefreshTopView()
  self:RefreshGridItemView()
  self:RefreshBottomView()
  self:RefreshDiceView()
  self:RefreshRoleImgView()
  self:RefreshContentView()
  self:RefreshAutoContentView()
  self:CheckScreenAniAndEffect()
end

function ActMonopoly:RefreshContentView()
  self.bottomBtnContent:RefreshView()
  self.bossContent:RefreshView()
  self.costShowContent:RefreshView()
  self.rewardBoxContent:RefreshView()
  self.shopBtnContent:RefreshView()
  self.saveEventContent:RefreshView()
  self.taskContent:RefreshView()
  self.topRightBtnsContent:RefreshView()
  self.itemUseBtnContent:RefreshView()
end

function ActMonopoly:RefreshAutoContentView()
  self.auto_content:SetActive(self.isAuto > 0 and self.isAutoStart)
  self.auto_btn_be_select:SetActive(self.isAuto > 0)
  local diceType = -1
  if self.isAuto > 0 and self.isAutoStart and self.tweenMsg then
    diceType = self.tweenMsg.diceType
  end
  self.bottomBtnContent:SetBtnEffectByDiceType(diceType)
  local autoStr = ""
  if diceType == ActMonopolyDiceType.Normal then
    autoStr = Localization:GetString("activity_sports_uitips_009")
  else
    autoStr = Localization:GetString("activity_sports_uitips_029")
  end
  self.auto_content_text:SetText(autoStr)
end

function ActMonopoly:RefreshNoDataView()
  if self.activityId then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
  end
end

function ActMonopoly:GetAngleByDir(dir)
  local angle = 0
  if dir == ActMonopolyGridDirType.Left then
    angle = 180
  elseif dir == ActMonopolyGridDirType.Right then
    angle = 0
  elseif dir == ActMonopolyGridDirType.Up then
    angle = -90
  elseif dir == ActMonopolyGridDirType.Down then
    angle = 90
  end
  return angle
end

function ActMonopoly:RefreshRoleImgView()
  local isAllLoadFin = self.model_content:GetIsAllLoadFinish()
  if isAllLoadFin == false then
    return
  end
  local curIndex = self.activityDetailData.nowGrid
  self.model_content:SetRoleLocalPosByGridIndex(curIndex)
  local curDir = self.activityDetailData.backUpTimes <= 0
  if curDir then
    local temp = self.actGridTempList[curIndex]
    local dir = ActMonopolyGridDirType.Left
    if temp then
      dir = temp.direction
    end
    local angle = self:GetAngleByDir(dir)
    self.model_content.modelNewRoleManager:SetRoleData(false, angle)
  else
    local preIndex = self:GetPreIndex(curIndex)
    local temp = self.actGridTempList[preIndex]
    local dir = ActMonopolyGridDirType.Left
    if temp then
      dir = temp.direction
    end
    dir = self:GetReverseDir(dir)
    local angle = self:GetAngleByDir(dir)
    self.model_content.modelNewRoleManager:SetRoleData(false, angle)
  end
end

function ActMonopoly:RefreshDiceView()
  self.diceContent:SetActive(false)
end

function ActMonopoly:RefreshTopView()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  self:Update1000MS()
end

function ActMonopoly:RefreshGridItemView()
  if not self.gridLoadFin then
    return
  end
  local isAllLoadFin = self.model_content:GetIsAllLoadFinish()
  for k, v in pairs(self.gridItemDict) do
    local temp = self.actGridTempList[k]
    v:SetData(self.activityId, self.activityDetailData, k, temp)
    if isAllLoadFin then
      self.model_content.modelNewGridItemManager:RefreshGridItemByIndex(k)
    end
  end
  if isAllLoadFin then
    self.model_content.modelNewGridItemManager:RefreshSpecialBox()
  end
end

function ActMonopoly:RefreshBottomView()
  self.skipBtnBeSelect:SetActive(self.isSkip > 0)
end

function ActMonopoly:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  if self.activityDetailData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.txt_times:SetText(countDownTimeStr)
  if self.isRoleImgLoading == true and curTime > self.isRoleImgLoadingMaxTime then
    self.isRoleImgLoading = false
    self.isRoleImgLoadingMaxTime = 0
    self.model_show_raw_img:SetActive(true)
    self:RefreshRoleImgView()
  end
  if self.isRoleImgLoading == false then
    self.model_content:OnUpdate1000MS()
  end
end

function ActMonopoly:Update()
  self.model_content:OnUpdate()
end

function ActMonopoly:ClickSkipBtn()
  if self.activityDetailData == nil then
    return
  end
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  if self.isSkip <= 0 then
    self.isSkip = 1
  else
    self.isSkip = 0
  end
  Setting:SetInt(ActMonopolySkipBtnKeyStr, self.isSkip)
  self:RefreshBottomView()
end

function ActMonopoly:ClickAutoBtn()
  if self.activityDetailData == nil then
    return
  end
  if self.isAuto <= 0 then
    if self:CanClickBtn() then
      self.isAuto = 1
    end
  else
    self.isAuto = 0
    self.isAutoStart = false
  end
  Setting:SetInt(ActMonopolyAutoBtnKeyStr, self.isAuto)
  self:RefreshAutoContentView()
end

function ActMonopoly:ClickStopAutoBtn()
  if self.activityDetailData == nil then
    return
  end
  self.isAutoStart = false
  Setting:SetInt(ActMonopolyAutoBtnKeyStr, self.isAuto)
  self:RefreshAutoContentView()
end

function ActMonopoly:OnAutoPlayingStop()
  if self.activityDetailData == nil then
    return
  end
  self.isAutoStart = false
  Setting:SetInt(ActMonopolyAutoBtnKeyStr, self.isAuto)
  self:RefreshAutoContentView()
end

function ActMonopoly:CanClickBtn()
  local canClick = true
  if self.isRoleImgLoading == true then
    canClick = false
  end
  if self.curState ~= ActMonopolyState.Idle then
    canClick = false
  end
  return canClick
end

function ActMonopoly:GetMaxIndex()
  return #self.actGridTempList
end

function ActMonopoly:GetNextIndex(curIndex)
  local nextIndex = curIndex + 1
  local maxIndex = self:GetMaxIndex()
  if nextIndex > maxIndex then
    nextIndex = 1
  end
  return nextIndex
end

function ActMonopoly:GetPreIndex(curIndex)
  local preIndex = curIndex - 1
  local maxIndex = self:GetMaxIndex()
  if preIndex <= 0 then
    preIndex = maxIndex
  end
  return preIndex
end

function ActMonopoly:GetReverseDir(curDir)
  local revDir = ActMonopolyGridDirType.Left
  if curDir == ActMonopolyGridDirType.Left then
    revDir = ActMonopolyGridDirType.Right
  elseif curDir == ActMonopolyGridDirType.Right then
    revDir = ActMonopolyGridDirType.Left
  elseif curDir == ActMonopolyGridDirType.Up then
    revDir = ActMonopolyGridDirType.Down
  elseif curDir == ActMonopolyGridDirType.Down then
    revDir = ActMonopolyGridDirType.Up
  end
  return revDir
end

function ActMonopoly:GetDiceImgByNum(num)
  local imgName = "lrb_dafuweng_touzi_1"
  if num == 1 then
    imgName = "lrb_dafuweng_touzi_1"
  elseif num == 2 then
    imgName = "lrb_dafuweng_touzi_2"
  elseif num == 3 then
    imgName = "lrb_dafuweng_touzi_3"
  elseif num == 4 then
    imgName = "lrb_dafuweng_touzi_4"
  elseif num == 5 then
    imgName = "lrb_dafuweng_touzi_5"
  elseif num == 6 then
    imgName = "lrb_dafuweng_touzi_6"
  end
  local path = string.format(UIAssets.UIActMonopolySpritePath, imgName)
  return path
end

function ActMonopoly:GetDiceResultMsg(msg)
  if self.activityId ~= msg.activityId then
    return
  end
  self.waitBackMsgTime = 0
  if self.curState ~= ActMonopolyState.Idle then
    return
  end
  self:RefreshTopView()
  self.costShowContent:RefreshView()
  self.tweenMsg = msg
  self.startIndex = msg.oldGrid
  self.endIndex = math.abs(msg.nowGrid)
  self.tweenMoveDir = 0 < msg.firstDiceNum
  self.curIndex = msg.oldGrid
  self.passOneIndexTween = msg.startGridReward ~= nil
  self.havePlayPassOneIndexTween = false
  self.curState = ActMonopolyState.DiceAni
  if 0 < self.isAuto and 0 < self.tweenMsg.isAuto then
    local oldState = self.isAutoStart
    self.isAutoStart = true
    if oldState ~= self.isAutoStart then
      local diceType = self.tweenMsg.diceType
      PostEventLog.Track(PostEventLog.Defines.ActMonopolyAutoDice, {diceType = diceType})
    end
  end
  self:RefreshAutoContentView()
  self:TryTweenState()
end

function ActMonopoly:GetOnRewardGetPanelCloseMsg(msg)
  if self.curState ~= ActMonopolyState.WaitCycleRewardClose then
    return
  end
  self.curState = ActMonopolyState.Move
  self:TryTweenState()
end

function ActMonopoly:GetShopCloseMsg()
  if self.isPlayShopBtnAni == false then
    return
  end
  if self.curState ~= ActMonopolyState.Idle then
    return
  end
  self.isPlayShopBtnAni = false
  local flyTime = 0.8
  local curPos = self.content.transform.position
  local flyPos = self.shopBtnContent.shopBtn.transform.position
  DataCenter.FlyController.DoFly(RewardType.ActGiftBox, 1, "", curPos, flyPos, 100, 100, nil, nil, flyTime)
  self:StopDelayTimer()
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self ~= nil then
      self.shopBtnContent.shopBtnEffect:SetActive(false)
      self.shopBtnContent.shopBtnEffect:SetActive(true)
    end
  end, flyTime)
end

function ActMonopoly:CloseAniSeq()
  if self.aniSeq ~= nil then
    self.aniSeq:Kill()
    self.aniSeq = nil
  end
end

function ActMonopoly:TryTweenState()
  if self.curState == ActMonopolyState.DiceAni then
    self:TryDiceAniTweenState()
  elseif self.curState == ActMonopolyState.Move then
    self:TryMoveTweenState()
  elseif self.curState == ActMonopolyState.Idle then
    self:TryAutoRecruitBtn()
  end
end

function ActMonopoly:TryDiceAniTweenState()
  local oneNum = math.abs(self.tweenMsg.firstDiceNum)
  local secondNum = math.abs(self.tweenMsg.secondDiceNum)
  local aniName = oneDiceAniName
  if 0 < secondNum then
    aniName = doubleDiceAniName
  else
    aniName = oneDiceAniName
  end
  local dice1Path = self:GetDiceImgByNum(oneNum)
  self.dice1:LoadSpriteAsync(dice1Path)
  if 0 < secondNum then
    local dice2Path = self:GetDiceImgByNum(secondNum)
    self.dice2:LoadSpriteAsync(dice2Path)
  end
  local speed = 1.3
  local useTime = diceTime / speed
  if 0 < self.isSkip then
    speed = 50
    useTime = diceTime / speed + 0.3
  else
    self.diceSoundHandle = DataCenter.LWSoundManager:PlaySound(91102)
  end
  self.diceContent:SetActive(true)
  self.aniRoot:SetSpeed(speed)
  self.aniRoot:Play(aniName)
  self:StopDelayTimer()
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self ~= nil then
      self:StopDelayTimer()
      self.diceContent:SetActive(false)
      self.curState = ActMonopolyState.Move
      self:TryTweenState()
    end
  end, useTime)
end

function ActMonopoly:TryAutoRecruitBtn()
  if self.isAuto <= 0 then
    self.isAutoStart = false
    return
  end
  if self.isAutoStart and self.tweenMsg and self.tweenMsg.diceType then
    local diceType = self.tweenMsg.diceType
    if diceType == ActMonopolyDiceType.Normal then
      local isCanClick, lackData = self.bottomBtnContent:CanClickBtnRecruit1()
      if not isCanClick then
        self:OnAutoPlayingStop()
        if lackData then
          local rewardName = RewardUtil.GetName(lackData.type, lackData.itemId)
          UIUtil.ShowTips(Localization:GetString("snow_season_buy_alert2", rewardName))
        end
      else
        self.bottomBtnContent:ClickBtnRecruit1()
        self.bottomBtnContent:DoBtnClickAni(diceType)
      end
    elseif diceType == ActMonopolyDiceType.Special then
      local isCanClick, lackData = self.bottomBtnContent:CanClickBtnRecruit2()
      if not isCanClick then
        self:OnAutoPlayingStop()
        if lackData then
          local rewardName = RewardUtil.GetName(lackData.type, lackData.itemId)
          UIUtil.ShowTips(Localization:GetString("snow_season_buy_alert2", rewardName))
        end
      else
        local isContinueDice = true
        local stopReasonTtype = StopDiceReasonType.None
        if self.isDiceUseFreeAtAuto then
          local freeNum = self.activityDetailData.freeHighDice
          if freeNum <= 0 then
            isContinueDice = false
            stopReasonTtype = StopDiceReasonType.NoFreeDice
          end
        end
        if isContinueDice then
          self.bottomBtnContent:ClickBtnRecruit2()
          self.bottomBtnContent:DoBtnClickAni(diceType)
        else
          self:OnAutoPlayingStop()
          local message = Localization:GetString("activity_auto_alerttips1")
          UIUtil.TryShowConfirm(TodayNoSecondConfirmType.ActMonopolyFreeNumEmptyTip, message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            EventManager:GetInstance():Broadcast(EventId.ActMonopolyAutoContinueDiceSpecial)
          end, function()
          end, nil, nil, false, nil, nil)
        end
      end
    end
  end
end

function ActMonopoly:TryMoveTweenState()
  if self.startIndex == self.curIndex then
    local obj = self.gridItemDict[self.curIndex]
  end
  if self.curIndex == 1 and self.passOneIndexTween and self.havePlayPassOneIndexTween == false then
    self.havePlayPassOneIndexTween = true
    local time = self:GetMoveTime()
    local allGridItemNum = self:GetMaxIndex()
    local triggerGridItemNum = self.tweenMsg.randomItemGridList ~= nil and #self.tweenMsg.randomItemGridList or 0
    local curIndex = self.curIndex
    self.model_content:SetRoleLocalPosByGridIndex(curIndex)
    local temp = self.actGridTempList[curIndex]
    local dir = ActMonopolyGridDirType.Left
    if temp then
      dir = temp.direction
    end
    local angle = self:GetAngleByDir(dir)
    self.model_content.modelNewRoleManager:SetRoleData(false, angle)
    local time1 = time / 6
    local time2 = time / 2
    local totalTime = allGridItemNum * time1 + triggerGridItemNum * time2
    self:CloseAniSeq()
    self.aniSeq = DOTween.Sequence()
    for i = 1, allGridItemNum do
      local index = i
      self.aniSeq:AppendCallback(function()
        local obj = self.gridItemDict[index]
        if obj then
          self.model_content.modelNewGridItemManager:PlayGridEffect(ActMonopolyGridEffectType.Eff_ui_dfw_dikuai_shuaguang, index)
        end
      end)
      self.aniSeq:AppendInterval(time1)
    end
    if 0 >= self.isSkip then
      self.dikuai_shuaguangSoundHandle = DataCenter.LWSoundManager:PlaySound(91104, false)
    end
    for i = 1, triggerGridItemNum do
      local index = self.tweenMsg.randomItemGridList[i].order
      self.aniSeq:AppendCallback(function()
        local obj = self.gridItemDict[index]
        if obj then
          self.model_content.modelNewGridItemManager:PlayGridEffect(ActMonopolyGridEffectType.Eff_ui_dfw_dikuai_jiangli, index)
          if self.isSkip <= 0 then
            self.dikuai_jiangliSoundHandle = DataCenter.LWSoundManager:PlaySound(91105, false)
          end
          self.model_content.modelNewGridItemManager:RefreshGridItemByIndex(index, self.tweenMsg.randomItemGridList[i].lv, self.tweenMsg.randomItemGridList[i].exp)
          local tryPlayLv = obj:TryPlayLevelUpEffect(self.tweenMsg.randomItemGridList[i].lv)
          if 0 <= tryPlayLv then
            self.effectContent:TryPlayLevelUpEffect(tryPlayLv, obj:GetAnchoredPositionX(), obj:GetAnchoredPositionY() + 130)
          end
        end
      end)
      self.aniSeq:AppendInterval(time2)
    end
    self.aniSeq:AppendCallback(function()
      if self.tweenMsg.cycleBossGrid and #self.tweenMsg.cycleBossGrid > 0 then
        for i = 1, #self.tweenMsg.cycleBossGrid do
          local posIndex = self.tweenMsg.cycleBossGrid[i]
          local obj = self.gridItemDict[posIndex]
          local flyTime = 0.8
          local curPos = obj.transform.position
          local flyPos = self.atk_boss_content2.transform.position
          DataCenter.FlyController.DoFly(RewardType.ActGiftBox, 1, "", curPos, flyPos, 100, 100, nil, nil, flyTime)
        end
      end
    end)
    self.aniSeq:OnComplete(function()
      self:CloseAniSeq()
    end)
    self:StopDelayTimer()
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self ~= nil then
        self:StopDelayTimer()
        local reward = self.tweenMsg.startGridReward
        if reward ~= nil and 0 < #reward then
          local rewardData = {reward = reward}
          if 0 < self.tweenMsg.isAuto then
            local obj = self.gridItemDict[self.curIndex]
            local startPos
            if obj then
              startPos = obj.oneIcon:GetPosition()
              self:DoRewardFly(reward, startPos, self.rewardBoxContent.reward_btn.transform.position)
            end
          else
            DataCenter.RewardManager:ShowCommonReward(rewardData)
            self.curState = ActMonopolyState.WaitCycleRewardClose
          end
        end
        self:TryTweenState()
      end
    end, totalTime)
  elseif self.curIndex == self.endIndex then
    local reward = self.tweenMsg.gridReward
    if reward ~= nil and 0 < #reward then
      local obj = self.gridItemDict[self.curIndex]
      local rewardData = {reward = reward}
      if 0 < self.tweenMsg.isAuto then
        local startPos
        if obj then
          startPos = obj.oneIcon:GetPosition()
          self:DoRewardFly(reward, startPos, self.rewardBoxContent.reward_btn.transform.position)
        end
      else
        DataCenter.RewardManager:ShowCommonReward(rewardData)
      end
      if obj then
        self.model_content.modelNewGridItemManager:PlayGridEffect(ActMonopolyGridEffectType.Eff_ui_dfw_dikuai_jiangli, self.curIndex)
        local tryPlayLv = obj:TryPlayLevelUpEffect()
        if 0 <= tryPlayLv then
          self.effectContent:TryPlayLevelUpEffect(tryPlayLv, obj:GetAnchoredPositionX(), obj:GetAnchoredPositionY() + 130)
        end
      end
    end
    local addLoopTaskProgress = self.taskContent:GetCurLoopTaskProgressAddNum()
    if 0 < addLoopTaskProgress then
      local obj = self.gridItemDict[self.curIndex]
      if 0 > self.loopTaskFlyItem then
        local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(self.activityInfo.richman_para)
        if paraTemp and not string.IsNullOrEmpty(paraTemp.grid_add_score) then
          local grid_add_score_data = string.split(paraTemp.grid_add_score, ";")
          if grid_add_score_data and #grid_add_score_data == 2 then
            self.loopTaskFlyItem = toInt(grid_add_score_data[1]) or 0
          end
        end
      end
      local itemId = self.loopTaskFlyItem
      if 0 < itemId then
        local addNum = addLoopTaskProgress
        local startPos = obj.oneIcon:GetPosition()
        local endPos = self.taskContent.icon.transform.position
        local flyTime = 1
        if 0 < self.isSkip then
          flyTime = 0.5
        end
        self:TryPlayGoodsAddNum({
          itemId = itemId,
          addNum = addNum,
          startPos = startPos,
          endPos = endPos,
          flyTime = flyTime
        }, obj:GetAnchoredPositionX() + 100 * CommonUtil.ArabicAutoMirrorFactor(), obj:GetAnchoredPositionY() + 180)
      end
    end
    self.waitTaskContentRefresh = false
    local eventId = self.tweenMsg.gridRet.eventId
    if eventId and 0 < tonumber(eventId) then
      local line = LocalController:instance():getLine(TableName.RichManEvent, eventId)
      if line then
        if line.event == ActMonopolyEventType.Shop then
          if 0 < self.isAuto then
            self.shopBtnContent:RefreshView()
            TimerManager:GetInstance():DelayInvoke(function()
              if self ~= nil then
                local flyTime = 0.6
                local obj = self.gridItemDict[self.curIndex]
                local curPos = obj.transform.position
                local flyPos = self.shopBtnContent.shopBtn.transform.position
                DataCenter.FlyController.DoFly(RewardType.ActGiftBox, 1, "", curPos, flyPos, 100, 100, nil, nil, flyTime)
              end
            end, 0.1)
          else
            self.isPlayShopBtnAni = true
            local topTipId
            if self.tweenMsg.storeDetail then
              topTipId = self.tweenMsg.storeDetail.storeKey
            end
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIActMonopolyShop, {anim = true}, self.activityId, self.activityDetailData, topTipId)
          end
        elseif 0 < self.isAuto then
          if line.event == ActMonopolyEventType.GetReward then
          elseif DataCenter.ActMonopolyDataManager:EventTypeIsToAutoEventSave(line.event) then
            self.saveEventContent:RefreshView()
            TimerManager:GetInstance():DelayInvoke(function()
              if self ~= nil then
                local flyTime = 0.6
                local obj = self.gridItemDict[self.curIndex]
                local curPos = obj.transform.position
                local targetItem = self.saveEventContent:GetItemByEventId(tonumber(line.id))
                local flyPos = self.saveEventContent.event_list.transform.position
                if targetItem then
                  flyPos = targetItem.transform.position
                end
                DataCenter.FlyController.DoFly(RewardType.ActGiftBox, 1, "", curPos, flyPos, 100, 100, nil, nil, flyTime)
              end
            end, 0.1)
          else
            self:OpenActMonopolyTipView(line)
            self:OnAutoPlayingStop()
          end
        else
          self:OpenActMonopolyTipView(line)
        end
      end
    end
    self:RefreshRoleImgView()
    self:StopDelayTimer()
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self ~= nil then
        self.taskContent:TryPlayTaskEffect()
        self:StopDelayTimer()
        self:RefreshView()
        self.curState = ActMonopolyState.Idle
        self:TryTweenState()
      end
    end, 0.7)
  else
    local roleOldLocalPos = Vector3.zero
    local roleNewLocalPos = Vector3.zero
    if self.tweenMoveDir then
      local nextIndex = self:GetNextIndex(self.curIndex)
      local oldIndex = self.curIndex
      self.curIndex = nextIndex
      local temp = self.actGridTempList[oldIndex]
      local dir = ActMonopolyGridDirType.Left
      if temp then
        dir = temp.direction
      end
      local angle = self:GetAngleByDir(dir)
      self.model_content.modelNewRoleManager:SetRoleData(true, angle)
      roleOldLocalPos = self.model_content.modelNewGridItemManager:GetGridItemRoleLocalPosByIndex(oldIndex)
      roleNewLocalPos = self.model_content.modelNewGridItemManager:GetGridItemRoleLocalPosByIndex(nextIndex)
    else
      local nextIndex = self:GetPreIndex(self.curIndex)
      local oldIndex = self.curIndex
      self.curIndex = nextIndex
      local temp = self.actGridTempList[nextIndex]
      local dir = ActMonopolyGridDirType.Left
      if temp then
        dir = temp.direction
      end
      dir = self:GetReverseDir(dir)
      local angle = self:GetAngleByDir(dir)
      self.model_content.modelNewRoleManager:SetRoleData(true, angle)
      roleOldLocalPos = self.model_content.modelNewGridItemManager:GetGridItemRoleLocalPosByIndex(oldIndex)
      roleNewLocalPos = self.model_content.modelNewGridItemManager:GetGridItemRoleLocalPosByIndex(nextIndex)
    end
    local moveTime = self:GetMoveTime()
    local aniSpeed = self:GetAniSpeed()
    self:CloseAniSeq()
    self.aniSeq = DOTween.Sequence()
    local curPos = roleOldLocalPos
    local endPos = roleNewLocalPos
    local midPos = Vector3(curPos.x, curPos.y, curPos.z) + (endPos - curPos) * 0.5
    local roleTrans = self.model_content.modelNewRoleManager:GetRoleTransform()
    self.aniSeq:Append(roleTrans:DOLocalMove(midPos, moveTime / 2):SetEase(CS.DG.Tweening.Ease.Linear))
    self.aniSeq:AppendCallback(function()
      self.model_content.modelNewGridItemManager:PlayJumpAniByIndex(self.curIndex, aniSpeed)
    end)
    self.aniSeq:Append(roleTrans:DOLocalMove(endPos, moveTime / 2):SetEase(CS.DG.Tweening.Ease.Linear))
    self.aniSeq:OnComplete(function()
      self:CloseAniSeq()
    end)
    self:StopDelayTimer()
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self ~= nil then
        self:StopDelayTimer()
        self:TryTweenState()
        if self.isSkip <= 0 then
          self.jumpSoundHandle = DataCenter.LWSoundManager:PlaySound(91103, false)
        end
      end
    end, moveTime)
  end
end

function ActMonopoly:StopDelayTimer()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.screenDelayTimer then
    self.screenDelayTimer:Stop()
    self.screenDelayTimer = nil
  end
  if self.screenEffDisappearTimer then
    self.screenEffDisappearTimer:Stop()
    self.screenEffDisappearTimer = nil
  end
end

function ActMonopoly:GetMoveTime()
  if self.isSkip > 0 then
    return normalSpeedTime / quickMultiple
  else
    return normalSpeedTime
  end
end

function ActMonopoly:GetAniSpeed()
  local speed = 1
  if self.isSkip > 0 then
    speed = quickMultiple
  end
  return speed
end

function ActMonopoly:OnGetShopDataChangeMsg()
  self.shopBtnContent:OnGetShopDataChangeMsg()
  self.costShowContent:RefreshView()
end

function ActMonopoly:OnGetActMonopolySaveEventDataAddMsg(eventId)
  self.saveEventContent:OnGetDataChangeMsg()
end

function ActMonopoly:OnGetActMonopolySaveEventDataReceiveMsg(t)
  self:RefreshView()
  local eventId = t.eventId
  if eventId and tonumber(eventId) > 0 then
    local line = LocalController:instance():getLine(TableName.RichManEvent, eventId)
    if line then
      self:OpenActMonopolyTipView(line)
    end
  end
end

function ActMonopoly:OnGetActMonopolyDamageRewardGet()
  self.rewardBoxContent:RefreshView()
  self.itemUseBtnContent:RefreshView()
end

function ActMonopoly:RefreshTaskContent()
  self.taskContent:RefreshView()
  self.itemUseBtnContent:RefreshView()
end

function ActMonopoly:RefreshTaskContentWithoutDic()
  if self.waitTaskContentRefresh then
    return
  end
  self.taskContent:RefreshView()
  self.itemUseBtnContent:RefreshView()
end

function ActMonopoly:DoRewardFly(rewardData, startPos, endPos)
  local rewardShowList = DataCenter.RewardManager:ReturnRewardParamForView(rewardData)
  if rewardShowList == nil or #rewardShowList == 0 then
    return
  end
  for k, v in ipairs(rewardShowList) do
    if v.rewardType == RewardType.GOODS or v.rewardType == RewardType.RESOURCE_ITEM then
      local rewardType = v.rewardType
      local itemId = v.itemId
      local addNum = v.count
      local pic = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
      local flyNum = math.floor(addNum / 10)
      flyNum = math.max(flyNum, 1)
      flyNum = math.min(flyNum, 10)
      UIUtil.DoFly(rewardType, flyNum, pic, startPos, endPos, 100, 100, nil, nil, 1)
    end
  end
end

function ActMonopoly:SendDicMsg(dicType)
  self.taskContent:RecordCurLoopTaskProgress()
  self.waitTaskContentRefresh = true
  SFSNetwork.SendMessage(MsgDefines.RichManDice, self.activityId, dicType, self.isAuto)
  if self.isAuto > 0 and self.isAutoStart == false then
    if dicType == ActMonopolyDiceType.Normal then
      local freeNum = self.activityDetailData.freeNormalDice
      self.isDiceUseFreeAtAuto = 0 < freeNum
    elseif dicType == ActMonopolyDiceType.Special then
      local freeNum = self.activityDetailData.freeHighDice
      self.isDiceUseFreeAtAuto = 0 < freeNum
    end
  end
end

function ActMonopoly:OpenActMonopolyTipView(line)
  if line.event == ActMonopolyEventType.Sport then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActMonopolyTip, {anim = true, playEffect = 91106}, line)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActMonopolyTip2, {anim = true}, line)
  end
end

function ActMonopoly:RefreshActDetectTreasureRed()
  self.topRightBtnsContent:RefrshRadarTreasureRed()
end

function ActMonopoly:TryPlayGoodsAddNum(data, sPosX, sPosY)
  self.effectContent:TryPlayGoodsNumEffect(data, sPosX, sPosY)
end

function ActMonopoly:OnActMonopolyRoleLoadFin()
  self.isRoleImgLoading = false
  self.isRoleImgLoadingMaxTime = 0
  self.model_show_raw_img:SetActive(true)
  self:RefreshRoleImgView()
end

function ActMonopoly:UseItemSuccessHandle()
  self.itemUseBtnContent:RefreshView()
end

function ActMonopoly:EventTipClose()
  self.saveEventContent:OnEventTipClose()
end

function ActMonopoly:UpdateGoldMsg()
  self.costShowContent:RefreshView()
  self.bottomBtnContent:RefreshView()
end

function ActMonopoly:GetActMonopolyAutoContinueDiceSpecialMsg()
  local isCanClick, lackData = self.bottomBtnContent:CanClickBtnRecruit2()
  if isCanClick then
    self.bottomBtnContent:ClickBtnRecruit2()
    self.bottomBtnContent:DoBtnClickAni(ActMonopolyDiceType.Special)
  end
end

function ActMonopoly:SetConfigView()
  local showTemp = self.activityInfo:GetShowConfigTemp()
  if showTemp and not string.IsNullOrEmpty(showTemp.banner_effect) then
    local path = showTemp.banner_effect
    self.bg_effect_content:Play(path, {
      lifeType = UIVfxLifeType.Stay
    })
  end
  if showTemp then
    UIActivityCenterCommonUtil.SetTopViewColor(self.txt_act_name.gameObject, nil, self.txt_times.gameObject, showTemp)
    if showTemp.bg_mask then
      if showTemp.bg_mask[1] then
        self.bg_raw_img2:SetActive(true)
        local imgPath = string.format(UIAssets.UIActMonopolyTexturePath, showTemp.bg_mask[1])
        self.bg_raw_img2:LoadSpriteAsync(imgPath)
      else
        self.bg_raw_img2:SetActive(false)
      end
      if showTemp.bg_mask[2] then
        self.bg_raw_img1:SetActive(true)
        local imgPath = string.format(UIAssets.UIActMonopolyTexturePath, showTemp.bg_mask[2])
        self.bg_raw_img1:LoadSpriteAsync(imgPath)
      else
        self.bg_raw_img1:SetActive(false)
      end
    end
  end
  local name = not string.IsNullOrEmpty(self.activityInfo.bannerTittle) and self.activityInfo.bannerTittle or self.activityInfo.name
  self.txt_act_name:SetLocalText(name)
  self:CreateUIEffect(showTemp.banner_effect_front)
end

function ActMonopoly:CreateUIEffect(effectPath)
  if string.IsNullOrEmpty(effectPath) then
    return
  end
  self.sceneEffReq = ResourceManager:InstantiateAsync(effectPath)
  self.sceneEffReq:completed("+", function()
    if self.sceneEffReq.isError then
      self.sceneEffReq = nil
      return
    end
    local effObj = self.sceneEffReq.gameObject
    effObj.transform:SetParent(self.sceneEffRoot.transform)
    effObj.gameObject:SetActive(true)
    effObj.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    effObj.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    effObj.gameObject.transform:Set_offsetMin(0, 0)
    effObj.gameObject.transform:Set_offsetMax(0, 0)
    effObj.gameObject.transform:Set_anchorMin(0, 0)
    effObj.gameObject.transform:Set_anchorMax(1, 1)
  end)
end

function ActMonopoly:CheckScreenAniAndEffect()
  if not self.activityInfo then
    return
  end
  local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(self.activityInfo.richman_para)
  if not paraTemp then
    return
  end
  local effInfoArr = paraTemp.trigger_effect
  if not effInfoArr or #effInfoArr < 4 then
    return
  end
  local screenEffFirstDelayTime = toInt(effInfoArr[1])
  local screenEffLoopCheckInterval = toInt(effInfoArr[2])
  local screenEffDuration = toInt(effInfoArr[3])
  self.screenEffPath = effInfoArr[4]
  self.screenEffAniCtrlAssetPath = effInfoArr[5]
  self.screenEffAnimName = effInfoArr[6]
  local saveKey = "ActMonopoly_" .. self.activityId
  local isFirstShow = CommonUtil.PlayerPrefsGetBool(saveKey, true)
  CommonUtil.PlayerPrefsSetBool(saveKey, true)
  local delay = isFirstShow and screenEffFirstDelayTime or screenEffLoopCheckInterval
  if delay < 0 then
    self:PlayEffAndScreenAni(screenEffDuration, function()
      self:CheckScreenAniAndEffect()
    end)
  else
    if self.screenDelayTimer then
      self.screenDelayTimer:Stop()
      self.screenDelayTimer = nil
    end
    self.screenDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:PlayEffAndScreenAni(screenEffDuration, function()
        self:CheckScreenAniAndEffect()
      end)
    end, delay)
  end
end

function ActMonopoly:PlayEffAndScreenAni(duration, finishCallback)
  if self.screenEffDisappearTimer then
    return
  end
  if not string.IsNullOrEmpty(self.screenEffPath) then
    if not self.screenEffReq then
      self.screenEffReq = self:GameObjectInstantiateAsync(self.screenEffPath, function(req)
        if req.isError then
          return
        end
        local screenEffObj = req.gameObject
        local trans = screenEffObj.transform
        trans:SetParent(self.sceneEffRoot.transform)
        trans:Set_anchorMin(0, 0)
        trans:Set_anchorMax(1, 1)
        trans:Set_offsetMin(0, 0)
        trans:Set_offsetMax(0, 0)
        trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        if self.dinosaurDelayTimer then
          self.dinosaurDelayTimer:Stop()
          self.dinosaurDelayTimer = nil
        end
        self.dinosaurDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
          self.dinosaurSoundHandle = DataCenter.LWSoundManager:PlaySound(91128, false)
          self.dinosaurDelayTimer = nil
        end, 1.2)
      end)
    elseif not IsNull(self.screenEffReq.gameObject) then
      self.screenEffReq.gameObject:SetActive(false)
      self.screenEffReq.gameObject:SetActive(true)
      self.dinosaurSoundHandle = DataCenter.LWSoundManager:PlaySound(91128, false)
      if self.dinosaurDelayTimer then
        self.dinosaurDelayTimer:Stop()
        self.dinosaurDelayTimer = nil
      end
      self.dinosaurDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.dinosaurSoundHandle = DataCenter.LWSoundManager:PlaySound(91128, false)
        self.dinosaurDelayTimer = nil
      end, 1.2)
    end
  end
  if not string.IsNullOrEmpty(self.screenEffAniCtrlAssetPath) then
    self.rootAni.enable = true
    if not self.screenAniLoadFlag then
      self.screenAniLoadFlag = true
      self.rootAni:TryLoadAnimation(self.screenEffAniCtrlAssetPath, function()
        self.rootAni:Play(self.screenEffAnimName)
        self.screenAniLoadFinishFlag = true
      end)
    elseif self.screenAniLoadFinishFlag then
      self.rootAni:Play(self.screenEffAnimName)
    end
  end
  self.screenEffDisappearTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.screenEffObj then
      self.screenEffObj:SetActive(false)
    end
    self.rootAni.enable = false
    self.screenEffDisappearTimer = nil
    if finishCallback then
      finishCallback()
    end
  end, duration)
end

return ActMonopoly
