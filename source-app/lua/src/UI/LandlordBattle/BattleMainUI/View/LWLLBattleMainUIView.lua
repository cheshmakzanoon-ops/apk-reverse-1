local LWLLBattleMainUIView = BaseClass("LWLLBattleMainUIView", UIBaseView)
local base = UIBaseView
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local UIMainBtnItem = require("UI.LWMainUI.Component.UIMainBottom.UIMainBtnItem")
local UIMainCenter = require("UI.LWMainUI.Component.UIMainCenter.UIMainCenter")
local UIMainChangeScene = require("UI.LWMainUI.Component.UIMainBottom.UIMainChangeScene")
local UIMainChatItem = require("UI.LWMainUI.Component.UIMainBottom.UIMainChatItem")
local UIMainAllianceWarTip = require("UI.LWMainUI.Component.UIMainBottom.UIMainAllianceWarTip")
local UIMainAlarmObj = require("UI.LWMainUI.Component.UIMainBottom.UIMainAlarmObj")
local UIMainTroops = require("UI.UIMain.Component.UIMainBottom.UIMainTroops")
local UIMainGoldStore = require("UI.LWMainUI.Component.UIMainTop.UIMainGoldStore")
local UITroopsList = require("UI.UIMain.Component.UIMainBottom.TroopList.MainTroopList")
local UIMainPlayerObj = require("UI.LWMainUI.Component.UIMainLeft.UIMainPlayerObj")
local UIMainQuestItem = require("UI.LWMainUI.Component.UIMainBottom.UIMainQuestItem")
local LLMainUIScoreBar = require("UI.LandlordBattle.BattleMainUI.Component.LLMainUIScoreBar")
local UIMainPower = require("UI.LWMainUI.Component.UIMainTop.UIMainPower")
local LLMainUIBattleSkill = require("UI.LandlordBattle.BattleMainUI.Component.LLMainUIBattleSkill")
local UIMainCureBtnItem = require("UI.LWMainUI.Component.UIMainBottom.UIMainCureBtnItem")
local UIMainBuffList = require("UI.LWMainUI.Component.UIMainTop.UIMainBuffList")
local LLMainAllianceBubbles = require("UI.LandlordBattle.BattleMainUI.Component.LLMainAllianceBubbles")
local LLMainUIBattleMarkItem = require("UI.LandlordBattle.BattleMainUI.Component.LLMainUIBattleMarkItem")
local UIMainSearchItem = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnSearch")
local safe_area_path = "safeArea"
local safe_area2_path = "safeArea2"
local center_layer_path = "safeArea/centerLayer"
local center_back_btn_path = "safeArea/centerLayer/WorldCenterBackBtn"
local top_layer_path = "safeArea/topLayer"
local troop_node_path = "safeArea/topLayer/troopNode"
local player_obj_path = "safeArea/topLayer/playerObj"
local power_path = "safeArea/topLayer/Power"
local gold_store_path = "safeArea/topLayer/goldStore"
local bottom_layer_path = "safeArea/bottomLayer"
local chat_area_path = "safeArea/bottomLayer/ChatArea"
local hero_obj_path = "safeArea/bottomLayer/HeroObj"
local world_btn_path = "safeArea/bottomLayer/WorldBtn"
local rally_tip_obj_path = "safeArea/bottomLayer/RightBtnLayout/rallyTipObj"
local alarm_obj_path = "safeArea/bottomLayer/RightBtnLayout/alarmObj"
local mail_obj_path = "safeArea/bottomLayer/RightBtnLayout/mailObj"
local alliance_obj_path = "safeArea/bottomLayer/RightBtnLayout/allianceObj"
local alliance_obj_name_path = "safeArea/bottomLayer/RightBtnLayout/allianceObj/allianceName"
local bag_obj_path = "safeArea/bottomLayer/RightBtnLayout/bagObj"
local left_btn_layout_path = "safeArea/bottomLayer/LeftBtnLayout"
local battle_detail_path = "safeArea/bottomLayer/LeftBtnLayout/battleDetail"
local btn_battle_detail_path = "safeArea/bottomLayer/LeftBtnLayout/battleDetail/btnBattleDetail"
local btn_battle_detail_txt_path = "safeArea/bottomLayer/LeftBtnLayout/battleDetail/battleDetailTxt"
local transport_path = "safeArea/bottomLayer/LeftBtnLayout/transport"
local btn_transport_path = "safeArea/bottomLayer/LeftBtnLayout/transport/btnTransport"
local search_obj_path = "safeArea/bottomLayer/LeftBtnLayout/searchObj"
local mv_effect_path = "safeArea/bottomLayer/LeftBtnLayout/transport/mvEffect"
local mv_time_bg_path = "safeArea/bottomLayer/LeftBtnLayout/transport/timeBg"
local mv_time_txt_path = "safeArea/bottomLayer/LeftBtnLayout/transport/timeTxt"
local quest_obj_path = "safeArea/bottomLayer/questObj"
local score_bar_path = "safeArea/topLayer/ScoreBar"
local mark_root_path = "safeArea/topLayer/MarkRoot"
local mark_item_path = "safeArea/topLayer/MarkRoot/Item"
local flashing_red_path = "topEffectLayer/flashingRed"
local ll_activity_btn_path = "safeArea/topLayer/LLActivityBtn"
local ll_activity_btn_text_path = "safeArea/topLayer/LLActivityBtn/BtnText"
local ll_activity_red_path = "safeArea/topLayer/LLActivityBtn/RedPoint"
local back_main_ui_btn_path = "safeArea/topLayer/BackMainUIBtn"
local main_skill_path = "safeArea/bottomLayer/MainSkill"
local cure_btn_path = "safeArea/bottomLayer/LeftBtnLayout/cureBtn"
local buff_list_root_path = "safeArea/topLayer/BuffListRoot"
local alliance_bubbles_path = "safeArea/bottomLayer/RightBtnLayout/allianceObj/AllianceBubbles"
local CLS_NOTICE_DESTROY = "UI.LandlordBattle.BattleMainUI.Component.LLMainUIBattleDestroyNotice"
local CLS_NOTICE_PERCENT = "UI.LandlordBattle.BattleMainUI.Component.LLMainUIBattlePercentNotice"
local PREFAB_NOTICE_DESTROY = "Assets/Main/Prefabs/UI/LWMainUI/LandlordBattle/LWLandlordMainBattleDestroyNotice.prefab"
local PREFAB_NOTICE_PERCENT = "Assets/Main/Prefabs/UI/LWMainUI/LandlordBattle/LWLandlordMainBattlePercentNotice.prefab"
local CLS_NOTICE_TIME = "UI.LandlordBattle.BattleMainUI.Component.LLWorldBattleTimeNotice"
local PREFAB_NOTICE_TIME = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldBattleTimeNotice.prefab"
local SHOW_MINI_MAP_MIN_LOD = 3

function LWLLBattleMainUIView:OnCreate()
  base.OnCreate(self)
  self.safe_area = self:AddComponent(UICanvasGroup, safe_area_path)
  self.safe_area2 = self:AddComponent(UICanvasGroup, safe_area2_path)
  local centerBackBtn = self.transform:Find(center_back_btn_path)
  if centerBackBtn ~= nil then
    self.center = self:AddComponent(UIMainCenter, center_layer_path)
  else
    self.centerE = self:AddComponent(UIBaseContainer, center_layer_path)
  end
  self.gold_store = self:AddComponent(UIMainGoldStore, gold_store_path)
  self.top_layer = self:AddComponent(UIBaseContainer, top_layer_path)
  self.troop_obj = self:AddComponent(UIMainTroops, troop_node_path)
  self.troop_obj:SetActive(true)
  self.troopListObj = self:AddComponent(UITroopsList, troop_node_path)
  self.troopListObj:SetActive(true)
  self.playerObj = self:AddComponent(UIMainPlayerObj, player_obj_path)
  self.playerObj:SetActive(true)
  self.bottom_layer = self:AddComponent(UIBaseContainer, bottom_layer_path)
  self.chat_obj = self:AddComponent(UIMainChatItem, chat_area_path)
  self.chat_obj:ReInit()
  if CoppaUtil.IsCoppaLimit() then
    self.chat_obj:SetActive(false)
  end
  local heroTF = self.transform:Find(hero_obj_path)
  if heroTF ~= nil then
    self.hero_obj = self:AddComponent(UIMainBtnItem, hero_obj_path)
    self.hero_obj:ReInit(UIMainFunctionInfo.Hero)
  end
  self.change_scene = self:AddComponent(UIMainChangeScene, world_btn_path)
  self.change_scene:CheckImage()
  if self.transform:Find(rally_tip_obj_path) then
    self.rally_tip_obj = self:AddComponent(UIMainAllianceWarTip, rally_tip_obj_path)
  end
  self.alarm_obj = self:AddComponent(UIMainAlarmObj, alarm_obj_path)
  self.alarm_obj:ReInit(AlarmUIOpenType.MainUI)
  self.mail_obj = self:AddComponent(UIMainBtnItem, mail_obj_path)
  self.mail_obj:ReInit(UIMainFunctionInfo.Mail)
  self.bag_obj = self:AddComponent(UIMainBtnItem, bag_obj_path)
  self.bag_obj:ReInit(UIMainFunctionInfo.Goods)
  self.alliance_obj = self:AddComponent(UIMainBtnItem, alliance_obj_path)
  self.alliance_obj:SetRedPointType(CommonRedPointPriority.Level1)
  self.alliance_obj:ReInit(UIMainFunctionInfo.Alliance)
  self.allianceBtnName = self:AddComponent(UIText, alliance_obj_name_path)
  self.allianceBtnName:SetLocalText(390002)
  self.bagRedDot = self:AddComponent(UIImage, bag_obj_path .. "/bagRedPointNum")
  self.bagRedDot:SetActive(false)
  self.left_btn_layout = self:AddComponent(UIBaseComponent, left_btn_layout_path)
  self.search_obj = self:AddComponent(UIMainSearchItem, search_obj_path)
  self.search_obj:ReInit(UIMainFunctionInfo.Search, nil)
  self.transport = self:AddComponent(UIBaseContainer, transport_path)
  self.btnTransport = self:AddComponent(UIButton, btn_transport_path)
  self.btnTransport:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILLWorldMapTransport)
  end)
  self.btnBattleDetailContent = self:AddComponent(UIBaseContainer, battle_detail_path)
  self.btnBattleDetailTxt = self:AddComponent(UIText, btn_battle_detail_txt_path)
  self.btnBattleDetail = self:AddComponent(UIButton, btn_battle_detail_path)
  self.btnBattleDetail:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILLBattleDetail)
  end)
  self.mv_effect = self:AddComponent(UIBaseContainer, mv_effect_path)
  self.eff_mv = self.transform:Find(mv_effect_path):GetComponent(TypeParticleSystem)
  self.mv_effect:SetActive(false)
  self.mv_time_bg = self:AddComponent(UIImage, mv_time_bg_path)
  self.mv_time_bg:SetActive(false)
  self.mv_time_txt = self:AddComponent(UIText, mv_time_txt_path)
  self.mv_time_txt:SetActive(false)
  self.flashing_red = self:AddComponent(UIBaseContainer, flashing_red_path)
  self.ll_activity_btn = self:AddComponent(UIButton, ll_activity_btn_path)
  self.ll_activity_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local curStage = DataCenter.LandlordMgr:GetActCurStage()
    if curStage ~= LLConst.LandlordStage.NONE then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILandlordMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    else
      UIUtil.ShowTipsId("458272")
    end
  end)
  self.ll_activity_btn_text = self:AddComponent(UITextMeshProUGUIEx, ll_activity_btn_text_path)
  self.ll_activity_red = self:AddComponent(UIBaseComponent, ll_activity_red_path)
  self.back_main_ui_btn = self:AddComponent(UIButton, back_main_ui_btn_path)
  self.back_main_ui_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    DataCenter.LandlordMgr:TryHideBattleMainWindow()
  end)
  self.questObj = self:AddComponent(UIMainQuestItem, quest_obj_path)
  self.questObj:RefreshState()
  self.questObj:RefreshRedPoint()
  self.score_bar = self:AddComponent(LLMainUIScoreBar, score_bar_path)
  self.mainPower = self:AddComponent(UIMainPower, power_path)
  self.mainSkill = self:AddComponent(LLMainUIBattleSkill, main_skill_path)
  self.mainCureBtn = self:AddComponent(UIMainCureBtnItem, cure_btn_path)
  self.mainBuffList = self:AddComponent(UIMainBuffList, buff_list_root_path)
  self.mainAllianceBubbles = self:AddComponent(LLMainAllianceBubbles, alliance_bubbles_path)
  self.mark_root = self:AddComponent(UIBaseContainer, mark_root_path)
  self.markItem = self.transform:Find(mark_item_path).gameObject
  self.markItem:GameObjectCreatePool()
  self.markItem:SetActive(false)
  self.isCreateMiniMap = false
  self.markObjs = {}
  self.compTimeCtrl = self:LoadComponentAsync(CLS_NOTICE_TIME, PREFAB_NOTICE_TIME, self.safe_area2, function()
    if self.compTimeCtrl ~= nil then
      self.compTimeCtrl:SetOffsetMinXY(0, 0)
      self.compTimeCtrl:SetOffsetMaxXY(0, 0)
    end
  end)
  self.compTimeCtrl:SetSiblingIndex(0)
  DataCenter.LandlordMgr:ClearBattleCityNoticeMsgCache()
end

function LWLLBattleMainUIView:OnDestroy()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.markItem:GameObjectRecycleAll()
  self.markItem = nil
  self.mark_root:RemoveComponents(LLMainUIBattleMarkItem)
  self.markObjs = nil
  self.soldierInfo = nil
  self.isCreateMiniMap = nil
  self._llCityNoticeDestroyComp = nil
  self._llCityNoticePercentComp = nil
  self.compTimeCtrl = nil
  base.OnDestroy(self)
end

function LWLLBattleMainUIView:PlayAnim(animName)
  if self.safe_area == nil then
    return
  end
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  if animName == UIMainAnimType.AllShow or animName == UIMainAnimType.ChangeAllShow or animName == UIMainAnimType.LeftRightBottomShow then
    self.safe_area:SetActive(true)
    sequence:Append(self.safe_area:FadeIn(0.3))
    sequence:OnComplete(function()
      self.sequence = nil
    end)
  else
    sequence:Append(self.safe_area:FadeOut(0.3))
    sequence:OnComplete(function()
      self.safe_area:SetActive(false)
      self.sequence = nil
    end)
  end
  self.sequence = sequence
end

function LWLLBattleMainUIView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateFakeBuildingPos, self.UpdateConstructPos)
  self:AddUIListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:AddUIListener(EventId.LandlordFreeMvEndTimeUpdate, self.OnCityMoveCoolDown)
  self:AddUIListener(EventId.DragonWatchStateChange, self.RefreshLeftBtn)
  self:AddUIListener(EventId.HospitalUpdate, self.OnHospitalUpdate)
  self:AddUIListener(EventId.SoldierDataChanged, self.OnHospitalUpdate)
  self:AddUIListener(EventId.AllianceWarNew, self.OnRefreshAllianceWarTip)
  self:AddUIListener(EventId.UpdateMainAllianceRedCount, self.OnAllianceUpdate)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceUpdate)
  self:AddUIListener(EventId.UpdateMainUIRallyTipRedPoint, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.AllianceWarUpdate, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.UpdateAllianceAutoRallyInfo, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.ALLIANCE_WAR_DELETE, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.UpdateAlertRedPoint, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.CrossServerWar, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.ChapterTask, self.ChapterTaskRefresh)
  self:AddUIListener(EventId.MainTaskUpdate, self.ChapterTaskRefresh)
  self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:AddUIListener(EventId.LuaEntryEffectRefreshStatus, self.ReInitMainSkill)
  self:AddUIListener(EventId.LandlordActStageChange, self.OnLandlordActStageChange)
  self:AddUIListener(EventId.LandlordActInfoRefresh, self.OnActInfoRefresh)
  self:AddUIListener(EventId.LandlordRedRefresh, self.RefreshRed)
  self:AddUIListener(EventId.LandlordBattleCityNotice, self.OnLandlordBattleCityNotice)
  self:AddUIListener(EventId.CountryMarkUpdate, self.OnCountryMarkUpdate)
end

function LWLLBattleMainUIView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateFakeBuildingPos, self.UpdateConstructPos)
  self:RemoveUIListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:RemoveUIListener(EventId.LandlordFreeMvEndTimeUpdate, self.OnCityMoveCoolDown)
  self:RemoveUIListener(EventId.DragonWatchStateChange, self.RefreshLeftBtn)
  self:RemoveUIListener(EventId.HospitalUpdate, self.OnHospitalUpdate)
  self:RemoveUIListener(EventId.SoldierDataChanged, self.OnHospitalUpdate)
  self:RemoveUIListener(EventId.AllianceWarNew, self.OnRefreshAllianceWarTip)
  self:RemoveUIListener(EventId.UpdateMainAllianceRedCount, self.OnAllianceUpdate)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceUpdate)
  self:RemoveUIListener(EventId.UpdateMainUIRallyTipRedPoint, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.AllianceWarUpdate, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.UpdateAllianceAutoRallyInfo, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.ALLIANCE_WAR_DELETE, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.UpdateAlertRedPoint, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.CrossServerWar, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.ChapterTask, self.ChapterTaskRefresh)
  self:RemoveUIListener(EventId.MainTaskUpdate, self.ChapterTaskRefresh)
  self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:RemoveUIListener(EventId.LuaEntryEffectRefreshStatus, self.ReInitMainSkill)
  self:RemoveUIListener(EventId.LandlordActStageChange, self.OnLandlordActStageChange)
  self:RemoveUIListener(EventId.LandlordActInfoRefresh, self.OnActInfoRefresh)
  self:RemoveUIListener(EventId.LandlordRedRefresh, self.RefreshRed)
  self:RemoveUIListener(EventId.LandlordBattleCityNotice, self.OnLandlordBattleCityNotice)
  self:RemoveUIListener(EventId.CountryMarkUpdate, self.OnCountryMarkUpdate)
  base.OnRemoveListener(self)
end

function LWLLBattleMainUIView:OnEnable()
  base.OnEnable(self)
  if self.center ~= nil then
    self.center:ReInit()
  end
  self.playerObj:ReInit()
  self.troop_obj:ReInit()
  self.gold_store:ReInit()
  self.score_bar:ReInit()
  self.mainPower:ReInit()
  self.mainCureBtn:SetActiveEx(true)
  self.mainCureBtn:ReInit()
  self.mainBuffList:RefreshBuff()
  self:ReInitMainSkill()
  self:RefreshCameraPoint()
  self.troop_obj:AddCurMarchList()
  self:RefreshLeftBtn()
  self:OnHospitalUpdate()
  self:MainTaskRefresh()
  self:UpdateLod(CS.SceneManager.World:GetLodLevel())
  self:RefreshTransportActive()
  self:RefreshBattleDetailActive()
  self:RefreshActivityTimeCheck()
  self:RefreshRed()
  local rectSize = self.rectTransform.rect
  local scaleWidth = rectSize.width / DefaultScreenWidth
  local scaleHeight = rectSize.height / DefaultScreenHeight
  if self.flashing_red then
    self.flashing_red:SetLocalScaleXYZ(scaleWidth, scaleHeight, 1)
  end
  self.alarm_obj:RefreshMarchItemTargetMe()
  local _, func = self:GetUserData()
  if func and type(func) == "function" then
    func()
  end
end

function LWLLBattleMainUIView:RegisterFunctionUnlock()
end

function LWLLBattleMainUIView:UpdateConstructPos(tempPos)
  local tempPosV3
  if tempPos ~= nil then
    tempPosV3 = SceneUtils.TileIndexToWorld(tempPos)
  end
  if self.center ~= nil then
    self.center:UpdateConstructPos(tempPosV3)
  end
  self:RefreshCameraPoint()
end

function LWLLBattleMainUIView:BuildMainZeroUpgradeSuccessSignal()
  if self.center ~= nil then
    self.center:UpdateConstructPos(nil)
  end
  self:RefreshCameraPoint()
  self.alarm_obj:RefreshMarchItemTargetMe()
end

function LWLLBattleMainUIView:RefreshCameraPoint()
  if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
    return
  end
  if self.center ~= nil then
    self.center:UpdateMilePointer(true)
  end
end

function LWLLBattleMainUIView:RefreshLeftBtn()
end

function LWLLBattleMainUIView:OnHospitalUpdate()
end

function LWLLBattleMainUIView:OnRefreshAllianceWarTip(data)
  if self.rally_tip_obj then
    self.rally_tip_obj:RefreshTip(data)
  end
end

function LWLLBattleMainUIView:OnAllianceUpdate()
  self:RefreshAllianceRedPoint()
end

function LWLLBattleMainUIView:RefreshAllianceRedPoint()
  if self.rally_tip_obj ~= nil then
    self.rally_tip_obj:CheckRedPoint()
  end
end

function LWLLBattleMainUIView:Update1000MS()
  if self.safe_area and self.safe_area.unity_canvas_group and self.safe_area:GetActive() ~= true then
    local stackCount = UIManager:GetInstance():GetStackWindowCount()
    if stackCount == 0 then
      self.safe_area:SetActive(true)
      self.safe_area:FadeIn(0.3)
    end
  end
  self:OnCityMoveCoolDown()
  self:RefreshBattleDetailTxt()
  self:RefreshActivityBtnTxt()
end

function LWLLBattleMainUIView:ShowAlarmEffect(type)
  local storageCurExtra = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_ALARM_OPEN) == 1
  if not storageCurExtra or self.flashing_red == nil then
    return
  end
  local isOn = CommonUtil.PlayerPrefsGetBool("ScreenEffects", true)
  local effectType = isOn and type ~= nil and AlarmType[type]
  if effectType == AlarmEffect.Pvp then
    self.bFlashing = true
    self.flashing_red:SetActive(true)
    return
  end
  self.bFlashing = false
  self.flashing_red:SetActive(false)
end

function LWLLBattleMainUIView:SetTroopListShow(show, loopListIndex)
  if show then
    if loopListIndex == 1 then
      self.troopListObj:ShowMarchItemList()
    elseif loopListIndex == 2 then
      self.troopListObj:ShowDetectItemList()
    end
  else
    if loopListIndex == 1 then
      self.troopListObj:HideMarchItemList()
    elseif loopListIndex == 2 then
      self.troopListObj:HideDetectItemList()
    end
    self.ctrl:SetSelectFormationUuid(0)
    self:HideAllShowTip()
  end
end

function LWLLBattleMainUIView:HideAllShowTip()
  self.troopListObj:HideAllShowTip()
end

function LWLLBattleMainUIView:IsTroopListShow()
  return self.troopListObj ~= nil and self.troopListObj:GetActive()
end

function LWLLBattleMainUIView:ShowFormationRallyTip(x, y, dataInfo)
  self.troopListObj:ShowFormationRallyTip(x, y, dataInfo)
end

function LWLLBattleMainUIView:OnSelectClick(uuid)
  self.troopListObj:OnSelectClick(uuid)
end

function LWLLBattleMainUIView:ShowFormationCreateTip(x, y, dataInfo)
  self.troopListObj:ShowFormationCreateTip(x, y, dataInfo)
end

function LWLLBattleMainUIView:OnAtkClick(uuid)
  self.troopListObj:OnAtkClick(uuid)
end

function LWLLBattleMainUIView:OnCreateClick(uuid)
  self.troopListObj:OnCreateClick(uuid)
end

function LWLLBattleMainUIView:OnEditClick(uuid, needAutoAdd)
  self.troopListObj:OnEditClick(uuid, needAutoAdd)
end

function LWLLBattleMainUIView:GetTimeInFormation(uuid)
  return self.troopListObj:GetTimeInFormation(uuid)
end

function LWLLBattleMainUIView:OnClickStartInvestigate(targetPointId)
  self.troopListObj:OnClickStartInvestigate(targetPointId)
end

function LWLLBattleMainUIView:ResetScoutSelectTipPosition(posX, posY)
  return self.troopListObj:ResetScoutSelectTipPosition(posX, posY)
end

function LWLLBattleMainUIView:OnClickScoutTroopItem(formationIndex)
  return self.troopListObj:OnClickScoutTroopItem(formationIndex)
end

function LWLLBattleMainUIView:GetScoutTroopUnlockLv(formationIndex)
  return self.troopListObj:GetScoutTroopUnlockLv(formationIndex)
end

function LWLLBattleMainUIView:ShowFormationArmyTip(x, y, dataInfo)
  self.troopListObj:ShowFormationArmyTip(x, y, dataInfo)
end

function LWLLBattleMainUIView:ShowCollectRewardFlyEff(rewards)
  self.troop_obj:PlayCollectRewardFlyEff(rewards)
end

function LWLLBattleMainUIView:ChapterTaskRefresh(isGetReward)
  if self.isInPve == true then
    return
  end
  local ok, err = pcall(function()
    self.questObj:RefreshState()
  end)
  if not ok then
    Logger.LogError("ChapterTaskRefresh", err)
  end
end

function LWLLBattleMainUIView:MainTaskRefresh(taskId)
  if self.isInPve == true then
    return
  end
  if self.quest_early then
    self:ChapterTaskRefresh()
    self:RefreshMainQuest()
  end
end

function LWLLBattleMainUIView:RefreshMainQuest()
  local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
  local allNum = DataCenter.ChapterTaskManager:GetAllNum()
  if 0 < allNum and chapterId < self.quest_earlyId then
    return
  else
    DataCenter.NpcTaskBubbleManager:StartUp()
  end
end

function LWLLBattleMainUIView:UpdateLod(lod)
  if not self.activeSelf then
    return
  end
  if lod >= SHOW_MINI_MAP_MIN_LOD then
    self:PlayAnim(UIMainAnimType.AllHide)
    self:TryShowMiniMap()
  else
    self:PlayAnim(UIMainAnimType.AllShow)
    self:TryHideMiniMap()
  end
end

function LWLLBattleMainUIView:TryShowMiniMap()
  if self.isCreateMiniMap == false then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMainMiniMap, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
    self.isCreateMiniMap = true
  end
end

function LWLLBattleMainUIView:TryHideMiniMap()
  if self.isCreateMiniMap == true then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMainMiniMap, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllShow
    })
    self.isCreateMiniMap = false
  end
end

function LWLLBattleMainUIView:ReInitMainSkill()
  self.mainSkill:ReInit(LLConst.IronCurtainStatusId)
end

function LWLLBattleMainUIView:OnLandlordActStageChange()
  self:RefreshTransportActive()
  self:RefreshBattleDetailActive()
  self:RefreshActivityTimeCheck()
end

function LWLLBattleMainUIView:RefreshTransportActive()
  self.transport:SetActive(DataCenter.LandlordMgr:GetActCurStage() == LLConst.LandlordStage.BATTLE)
end

function LWLLBattleMainUIView:OnCityMoveCoolDown()
  local showEffect = false
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local nextFreeEndTime = DataCenter.LandlordMgr:GetFreeMoveInfoEndTime() or 0
  if curTime >= nextFreeEndTime then
    showEffect = true
    self.mv_time_bg:SetActive(false)
    self.mv_time_txt:SetActive(false)
  else
    self.mv_time_bg:SetActive(true)
    self.mv_time_txt:SetActive(true)
    local r, g, b, a = 94, 251, 104, 255
    self.mv_time_txt:SetColorRGBA255(r, g, b, a)
    local remainTime = nextFreeEndTime - curTime
    local str = UITimeManager:GetInstance():GetFormattedTime(remainTime / 1000)
    self.mv_time_txt:SetText(str)
  end
  local isActive = self.mv_effect:GetActive()
  if showEffect then
    if not isActive then
      self.mv_effect:SetActive(true)
      self.eff_mv:Play()
    end
  elseif isActive then
    self.eff_mv:Stop()
    self.mv_effect:SetActive(false)
  end
end

function LWLLBattleMainUIView:RefreshBattleDetailActive()
  local isInBattle = DataCenter.LandlordMgr:IsInBattle()
  self.btnBattleDetailContent:SetActive(isInBattle)
  if isInBattle then
    local stageInfo = DataCenter.LandlordMgr:GetActCurStageInfo()
    self.battleStageEndTime = stageInfo and stageInfo.eTime * 1000 or 0
  end
end

function LWLLBattleMainUIView:RefreshBattleDetailTxt()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.battleStageEndTime and curTime < self.battleStageEndTime then
    self.btnBattleDetailTxt:SetText(DataCenter.LandlordMgr:SecondToFmtString((self.battleStageEndTime - curTime) / 1000))
  end
end

function LWLLBattleMainUIView:RefreshActivityTimeCheck()
  local actData = DataCenter.LandlordMgr:GetActData()
  local curStageInfo = actData ~= nil and actData:GetCurStageInfo() or nil
  local stage = curStageInfo ~= nil and curStageInfo.stage or nil
  if stage == LLConst.LandlordStage.PREPARE or stage == LLConst.LandlordStage.BATTLE then
    self.llETime = curStageInfo.eTime or 0
    self.llStage = stage
    self:RefreshActivityBtnTxt()
  else
    self.llStage = nil
    self.llETime = 0
    self:SetActivityBtnTxtDefault()
  end
end

function LWLLBattleMainUIView:SetActivityBtnTxtDefault()
  self.ll_activity_btn_text:SetLocalText("zonewar_landlord_tittle_10016")
end

function LWLLBattleMainUIView:RefreshActivityBtnTxt()
  local remain = 0
  local needRefresh = false
  if self.llStage == LLConst.LandlordStage.PREPARE then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    remain = self.llETime - curSec
    if remain <= 0 then
      remain = 0
      self.llStage = nil
      self.llETime = 0
      needRefresh = true
    elseif remain > OneHourTime then
      remain = 0
      self:SetActivityBtnTxtDefault()
    end
  elseif self.llStage == LLConst.LandlordStage.BATTLE then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    remain = self.llETime - curSec
    if remain <= 0 then
      remain = 0
      self.llStage = nil
      self.llETime = 0
      needRefresh = true
    end
  end
  if 0 < remain then
    self.ll_activity_btn_text:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutHour(remain))
  end
  if needRefresh then
    self:RefreshActivityTimeCheck()
  end
end

function LWLLBattleMainUIView:OnActInfoRefresh()
  self:RefreshActivityTimeCheck()
  self:RefreshRed()
end

function LWLLBattleMainUIView:RefreshRed()
  local hasRedPoint = DataCenter.LandlordMgr:CheckRed()
  self.ll_activity_red:SetActive(hasRedPoint)
end

function LWLLBattleMainUIView:OnLandlordBattleCityNotice(msg)
  local progress = toInt(msg.progress)
  local isDestroyNotice = progress == 100 or progress == 0
  local target
  if isDestroyNotice then
    target = self._llCityNoticeDestroyComp
  else
    target = self._llCityNoticePercentComp
  end
  if target == nil then
    local cls = isDestroyNotice and CLS_NOTICE_DESTROY or CLS_NOTICE_PERCENT
    local prefab = isDestroyNotice and PREFAB_NOTICE_DESTROY or PREFAB_NOTICE_PERCENT
    local parent = isDestroyNotice and self.safe_area2 or self.btnBattleDetailContent
    local x = isDestroyNotice and 90 or -30
    local y = isDestroyNotice and self.safe_area2.rectTransform.rect.height * 0.5 - 260 or 50
    target = self:LoadComponentAsync(cls, prefab, parent)
    target:SetLocalPositionXYZ(x, y, 0)
    if isDestroyNotice then
      self._llCityNoticeDestroyComp = target
      self._llCityNoticeDestroyComp:SetSiblingIndex(1)
    else
      self._llCityNoticePercentComp = target
    end
  end
  target:CheckShow()
end

function LWLLBattleMainUIView:OnCountryMarkUpdate(type)
  if type == nil or self.markObjs == nil then
    return
  end
  local markData = DataCenter.WorldFavoDataManager:GetCountryBookmarkByType(type, LuaEntry.Player:GetCurServerId())
  if markData == nil then
    return
  end
  local pos = markData ~= nil and markData.pos or nil
  if pos ~= nil then
    local edgeL = pos % 10
    pos = (pos - edgeL) / 10
  end
  local template = pos ~= nil and DataCenter.LandlordMgr:GetCityTemplateByPid(pos) or nil
  if template == nil then
    return
  end
  if #self.markObjs == 2 then
    self:RemoveOneMark(self.markObjs[1])
  end
  local obj = self.markItem:GameObjectSpawn(self.mark_root.transform)
  local key = UIUtil.GetLoopListItemIndex("Mark")
  obj.name = key
  table.insert(self.markObjs, obj)
  local item = self.mark_root:AddComponent(LLMainUIBattleMarkItem, key)
  item:SetActive(true)
  item:ReInit(markData, template)
  item:PlayAnim(function()
    self:RemoveOneMark(obj)
  end)
end

function LWLLBattleMainUIView:RemoveOneMark(obj)
  if IsNull(obj) then
    return
  end
  local name = obj.name
  for i, v in ipairs(self.markObjs) do
    if v.name == name then
      obj:GameObjectRecycle()
      self.mark_root:RemoveComponent(name, LLMainUIBattleMarkItem)
      table.remove(self.markObjs, i)
      break
    end
  end
end

return LWLLBattleMainUIView
