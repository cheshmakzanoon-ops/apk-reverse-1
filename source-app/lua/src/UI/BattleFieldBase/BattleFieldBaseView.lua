local BattleFieldBaseView = BaseClass("BattleFieldBaseView", UIBaseView)
local base = UIBaseView
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local UIMainBtnItem = require("UI.LWMainUI.Component.UIMainBottom.UIMainBtnItem")
local UIMainCenter = require("UI.LWMainUI.Component.UIMainCenter.UIMainCenter")
local UIMainChangeScene = require("UI.LWMainUI.Component.UIMainBottom.UIMainChangeScene")
local UIMainChatItem = require("UI.LWMainUI.Component.UIMainBottom.UIMainChatItem")
local UIMainAllianceWarTip = require("UI.LWMainUI.Component.UIMainBottom.UIMainAllianceWarTip")
local UIMainAlarmObj = require("UI.LWMainUI.Component.UIMainBottom.UIMainAlarmObj")
local UIMainTroops = require("UI.UIMain.Component.UIMainBottom.UIMainTroops")
local UITroopsList = require("UI.UIMain.Component.UIMainBottom.TroopList.MainTroopList")
local BuffIcon = require("UI.LWMainUI.Component.UIMainLeft.BuffIcon")
local safe_area_path = "safeArea"
local center_layer_path = "safeArea/centerLayer"
local center_back_btn_path = "safeArea/centerLayer/WorldCenterBackBtn"
local top_layer_path = "safeArea/topLayer"
local troop_node_path = "safeArea/topLayer/troopNode"
local power_path = "safeArea/topLayer/Power"
local text_power_path = "safeArea/topLayer/Power/TextPower"
local coin_path = "safeArea/topLayer/Coin"
local text_coin_path = "safeArea/topLayer/Coin/TextCoin"
local buff_path = "safeArea/topLayer/Buff"
local btn_buff_path = "safeArea/topLayer/Buff/BtnBuff"
local bottom_layer_path = "safeArea/bottomLayer"
local chat_area_path = "safeArea/bottomLayer/ChatArea"
local hero_obj_path = "safeArea/bottomLayer/HeroObj"
local btn_left_path = "safeArea/bottomLayer/LeftObj/leftBtn"
local text_left_path = "safeArea/bottomLayer/LeftObj/leftBtnName"
local world_btn_path = "safeArea/bottomLayer/WorldBtn"
local rally_tip_obj_path = "safeArea/bottomLayer/RightBtnLayout/rallyTipObj"
local alarm_obj_path = "safeArea/bottomLayer/RightBtnLayout/alarmObj"
local mail_obj_path = "safeArea/bottomLayer/RightBtnLayout/mailObj"
local bag_obj_path = "safeArea/bottomLayer/RightBtnLayout/bagObj"
local left_btn_layout_path = "safeArea/bottomLayer/LeftBtnLayout"
local btn_defence_path = "safeArea/bottomLayer/LeftBtnLayout/defence/btnDefence"
local btn_team_path = "safeArea/bottomLayer/LeftBtnLayout/team/btnTeam"
local heart_path = "safeArea/bottomLayer/LeftBtnLayout/heart"
local btn_hospital_path = "safeArea/bottomLayer/LeftBtnLayout/heart/btnHospital"
local glow_green_path = "safeArea/bottomLayer/LeftBtnLayout/heart/glow_green"
local heart_effect_path = "safeArea/bottomLayer/LeftBtnLayout/heart/heartEffect"
local btn_transport_path = "safeArea/bottomLayer/LeftBtnLayout/transport/btnTransport"
local mv_effect_path = "safeArea/bottomLayer/LeftBtnLayout/transport/mvEffect"
local mv_time_bg_path = "safeArea/bottomLayer/LeftBtnLayout/transport/timeBg"
local mv_time_txt_path = "safeArea/bottomLayer/LeftBtnLayout/transport/timeTxt"
local btn_go_path = "safeArea/bottomLayer/BtnGo"
local text_btn_go_path = "safeArea/bottomLayer/BtnGo/GoText"
local tip_go_path = "safeArea/bottomLayer/TipGo"
local flashing_red_path = "topEffectLayer/flashingRed"
local text_end_cd_path = "topEffectLayer/EndCDText"
local PREFAB_WORLD_BUILD_BTN = "Assets/Main/Prefabs/UI/BattleField/LWMainWorldBuildBtn.prefab"
local PREFAB_WORLD_MAIN_BTN = "Assets/Main/Prefabs/UI/LWMainUI/BattleField/cityBackBtn.prefab"
local CLS_WORLD_BUILD_BTN = "UI.BattleFieldBase.Misc.WorldBuildBtn"
local CENTER_E_CITY_KEY = 9999

function BattleFieldBaseView:OnCreate()
  base.OnCreate(self)
  self.bfType = self:GetBfType()
  self.ctrl:SetBfType(self.bfType)
  self.safe_area = self:AddComponent(UICanvasGroup, safe_area_path)
  local centerBackBtn = self.transform:Find(center_back_btn_path)
  if centerBackBtn ~= nil then
    self.center = self:AddComponent(UIMainCenter, center_layer_path)
  else
    self.centerE = self:AddComponent(UIBaseContainer, center_layer_path)
  end
  self.btnPower = self:AddComponent(UIButton, power_path)
  self.btnPower:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.soldierInfo and self.soldierInfo.id then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleSoldierTip, {anim = true}, self.soldierInfo)
    end
  end)
  self.text_power = self:AddComponent(UITextMeshProUGUIEx, text_power_path)
  self.btnCoin = self:AddComponent(UIButton, coin_path)
  self.text_coin = self:AddComponent(UITextMeshProUGUIEx, text_coin_path)
  self.buff_content = self:AddComponent(UIButton, buff_path)
  self.btn_buff = self:AddComponent(UIBaseContainer, btn_buff_path)
  self.buff_content:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCityBuff, {anim = true})
  end)
  self.btnCoin:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.DiamondShop)
  end)
  self.top_layer = self:AddComponent(UIBaseContainer, top_layer_path)
  self.troop_obj = self:AddComponent(UIMainTroops, troop_node_path)
  self.troop_obj:SetActive(true)
  self.troopListObj = self:AddComponent(UITroopsList, troop_node_path)
  self.troopListObj:SetActive(true)
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
  local leftBtnTF = self.transform:Find(btn_left_path)
  if leftBtnTF ~= nil then
    self.btnLeft = self:AddComponent(UIButton, btn_left_path)
    self.btnLeft:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:DoBtnLeft()
    end)
  end
  local leftTextTF = self.transform:Find(text_left_path)
  if leftTextTF ~= nil then
    self.textLeft = self:AddComponent(UITextMeshProUGUIEx, text_left_path)
  end
  self.change_scene = self:AddComponent(UIMainChangeScene, world_btn_path)
  self.change_scene:CheckImage()
  if self.transform:Find(rally_tip_obj_path) then
    self.rally_tip_obj = self:AddComponent(UIMainAllianceWarTip, rally_tip_obj_path)
  end
  self.alarm_obj = self:AddComponent(UIMainAlarmObj, alarm_obj_path)
  self.alarm_obj:ReInit(AlarmUIOpenType.DesertBattleUI)
  self.mail_obj = self:AddComponent(UIMainBtnItem, mail_obj_path)
  self.mail_obj:ReInit(UIMainFunctionInfo.Mail)
  self.bag_obj = self:AddComponent(UIMainBtnItem, bag_obj_path)
  self.bag_obj:ReInit(UIMainFunctionInfo.Goods)
  self.bagRedDot = self:AddComponent(UIImage, bag_obj_path .. "/bagRedPointNum")
  self.bagRedDot:SetActive(false)
  self.left_btn_layout = self:AddComponent(UIBaseComponent, left_btn_layout_path)
  self.btnDefence = self:AddComponent(UIButton, btn_defence_path)
  self.btnDefence:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWCityDefence)
  end)
  self.btnTeam = self:AddComponent(UIButton, btn_team_path)
  self.btnTeam:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local info = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByIndex(1)
    if info ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.ParkingLotBuilding, info.buildingUuid)
    end
  end)
  self.heart = self.transform:Find(heart_path)
  if self.heart ~= nil then
    self.btnHospital = self:AddComponent(UIButton, btn_hospital_path)
    self.btnHospital:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      BattleFieldUtil.TryOpenHospital()
    end)
    self.glow_green_effect = self:AddComponent(UIBaseContainer, glow_green_path)
    self.eff_glow_green = self.transform:Find(glow_green_path):GetComponent(TypeParticleSystem)
    self.glow_green_effect:SetActive(false)
    self.heart_effect = self:AddComponent(UIBaseContainer, heart_effect_path)
    self.eff_heart = self.transform:Find(heart_effect_path):GetComponent(TypeParticleSystem)
    self.heart_effect:SetActive(false)
  end
  self.btnTransport = self:AddComponent(UIButton, btn_transport_path)
  self.btnTransport:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertMapTransport)
  end)
  self.mv_effect = self:AddComponent(UIBaseContainer, mv_effect_path)
  self.eff_mv = self.transform:Find(mv_effect_path):GetComponent(TypeParticleSystem)
  self.mv_effect:SetActive(false)
  self.mv_time_bg = self:AddComponent(UIImage, mv_time_bg_path)
  self.mv_time_bg:SetActive(false)
  self.mv_time_txt = self:AddComponent(UITextMeshProUGUIEx, mv_time_txt_path)
  self.mv_time_txt:SetActive(false)
  if self.transform:Find(btn_go_path) then
    self.btn_go = self:AddComponent(UIButton, btn_go_path)
    self.btn_go:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      if not BattleFieldUtil.isObserve then
        local logStr = string.format("[BattleFieldBaseView] btnGo click not isObserve, bfType=%s", self.bfType)
        Logger.LogWarning(logStr)
      end
      BattleFieldUtil.ClearBattleFieldCanEnterFlag(self.bfType)
      self:DoBtnGo()
    end)
    self.text_btn_go = self:AddComponent(UITextMeshProUGUIEx, text_btn_go_path)
  end
  if self.transform:Find(tip_go_path) then
    self.tip_go = self:AddComponent(UIBaseComponent, tip_go_path)
  end
  if self.transform:Find(flashing_red_path) then
    self.flashing_red = self:AddComponent(UIBaseContainer, flashing_red_path)
  end
  if self.transform:Find(text_end_cd_path) then
    self.text_end_cd = self:AddComponent(UITextMeshProUGUIEx, text_end_cd_path)
    self.text_end_cd:SetActive(false)
  end
  self.battleEndSec = self:GetEndSec() or 0
  self.battle_info = BattleFieldUtil.CreateBattleInfo(self.bfType, self, self.top_layer, Bind(self, self.OnBattleInfoReady))
  self.mini_map = BattleFieldUtil.CreateMiniMap(self.bfType, self, self.top_layer, Bind(self, self.OnMiniMapReady))
  self.signPop = BattleFieldUtil.CreateSignPop(self.bfType, self, self.top_layer, Bind(self, self.OnSignPopReady))
  self:ComponentDefine()
end

function BattleFieldBaseView:OnDestroy()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.soldierInfo = nil
  self.worldBuildObjs = nil
  self.worldBuildInfos = nil
  self:DestroyBuff()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BattleFieldBaseView:PlayAnim(animName, force)
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

function BattleFieldBaseView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateFakeBuildingPos, self.UpdateConstructPos)
  self:AddUIListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:AddUIListener(EventId.DragonCityMoveCoolDown, self.OnCityMoveCoolDown)
  self:AddUIListener(EventId.DragonWatchStateChange, self.RefreshLeftBtn)
  self:AddUIListener(EventId.BattleFieldCanEnterPush, self.OnBattleFieldCanEnterPush)
  self:AddUIListener(EventId.UpdateGold, self.OnResourceUpdated)
  self:AddUIListener(EventId.PlayerPowerInfoUpdated, self.OnResourceUpdated)
  self:AddUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshBuff)
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
end

function BattleFieldBaseView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateFakeBuildingPos, self.UpdateConstructPos)
  self:RemoveUIListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:RemoveUIListener(EventId.DragonCityMoveCoolDown, self.OnCityMoveCoolDown)
  self:RemoveUIListener(EventId.DragonWatchStateChange, self.RefreshLeftBtn)
  self:RemoveUIListener(EventId.BattleFieldCanEnterPush, self.OnBattleFieldCanEnterPush)
  self:RemoveUIListener(EventId.UpdateGold, self.OnResourceUpdated)
  self:RemoveUIListener(EventId.PlayerPowerInfoUpdated, self.OnResourceUpdated)
  self:RemoveUIListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshBuff)
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
  base.OnRemoveListener(self)
end

function BattleFieldBaseView:OnEnable()
  base.OnEnable(self)
  if self.center ~= nil then
    if self.bfType == BattleFieldType.WinterStorm or self.bfType == BattleFieldType.EpidemicZone then
      self.center:ReInit(450)
    else
      self.center:ReInit()
    end
  end
  self.troop_obj:ReInit()
  self:RefreshCameraPoint()
  self.troop_obj:AddCurMarchList()
  self:CheckEnterShow()
  self:RefreshLeftBtn()
  self:OnResourceUpdated()
  self:RefreshBuff()
  self:OnHospitalUpdate()
  local rectSize = self.rectTransform.rect
  local scaleWidth = rectSize.width / DefaultScreenWidth
  local scaleHeight = rectSize.height / DefaultScreenHeight
  if self.flashing_red then
    self.flashing_red:SetLocalScaleXYZ(scaleWidth, scaleHeight, 1)
  end
  self.alarm_obj:RefreshMarchItemTargetMe()
  local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
  if mainUIView then
    mainUIView:SetActive(false)
    mainUIView:TryHideMiniMap()
  end
  local _, func = self:GetUserData()
  if func and type(func) == "function" then
    func()
  end
end

function BattleFieldBaseView:OnDisable()
  DataCenter.BattleFieldAnimManager:ClearAll()
  base.OnDisable(self)
end

function BattleFieldBaseView:GetBfType()
end

function BattleFieldBaseView:InitPolygonPoints()
  if self.centerE == nil then
    return
  end
  if self.polygonPoints then
    return self.polygonPoints
  end
  local points = {}
  local rect = self.centerE.rectTransform.rect
  local width, height = rect.width, rect.height
  local hr = 60
  table.insert(points, {
    100 + hr,
    200
  })
  table.insert(points, {
    width - 130 - hr,
    200
  })
  table.insert(points, {
    width - 130 - hr,
    height - 340
  })
  table.insert(points, {
    100 + hr,
    height - 340
  })
  self.polygonPoints = points
end

function BattleFieldBaseView:ComponentDefine()
end

function BattleFieldBaseView:ComponentDestroy()
end

function BattleFieldBaseView:OnBattleInfoReady()
end

function BattleFieldBaseView:OnMiniMapReady()
end

function BattleFieldBaseView:OnSignPopReady()
end

function BattleFieldBaseView:DoBtnGo()
end

function BattleFieldBaseView:DoBtnLeft()
end

function BattleFieldBaseView:IsCurWatchIdx()
end

function BattleFieldBaseView:CheckEnterShow()
end

function BattleFieldBaseView:OnObserveChange()
end

function BattleFieldBaseView:OnHospitalUpdateEx()
end

function BattleFieldBaseView:RefreshCameraPointEx()
end

function BattleFieldBaseView:GetEndSec()
end

function BattleFieldBaseView:UpdateConstructPos(tempPos)
  local tempPosV3
  if tempPos ~= nil then
    tempPosV3 = SceneUtils.TileIndexToWorld(tempPos)
  end
  if self.center ~= nil then
    self.center:UpdateConstructPos(tempPosV3)
  end
  self:RefreshCameraPoint()
end

function BattleFieldBaseView:BuildMainZeroUpgradeSuccessSignal()
  if self.center ~= nil then
    self.center:UpdateConstructPos(nil)
  end
  self:RefreshCameraPoint()
  self.alarm_obj:RefreshMarchItemTargetMe()
end

function BattleFieldBaseView:RefreshCameraPoint()
  if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
    return
  end
  if BattleFieldUtil.isObserve then
    return
  end
  if self.center ~= nil then
    self.center:UpdateMilePointer(true)
  end
  self:RefreshCameraPointEx()
  if self.centerE ~= nil then
    local curPos = CS.SceneManager.World.CurTarget
    local curTile = SceneUtils.WorldToTile(curPos)
    local mainIndex = LuaEntry.Player:GetBattleFieldPos()
    local tarTile = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
    local dist = math.floor(Vector2.Distance(curTile, tarTile))
    SceneUtils.ReturnPoolV2(curTile)
    SceneUtils.ReturnPoolV2(tarTile)
    if self.worldBuildInfos == nil then
      self.worldBuildInfos = {}
    end
    if self.worldBuildInfos[CENTER_E_CITY_KEY] == nil then
      self.worldBuildInfos[CENTER_E_CITY_KEY] = {dist, mainIndex}
    else
      self.worldBuildInfos[CENTER_E_CITY_KEY][1] = dist
      self.worldBuildInfos[CENTER_E_CITY_KEY][2] = mainIndex
    end
    self:RefreshOneBuildBtn(CENTER_E_CITY_KEY)
  end
end

function BattleFieldBaseView:OnCityMoveCoolDown()
  local showEffect = false
  local bArbiter = false
  local data = BattleFieldUtil.CoolData()
  if not table.IsNullOrEmpty(data) then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= data.coolTime then
      showEffect = true
      self.mv_time_bg:SetActive(false)
      self.mv_time_txt:SetActive(false)
    else
      local remainTime = data.coolTime - curTime
      self.mv_time_bg:SetActive(true)
      self.mv_time_txt:SetActive(true)
      if self.bfType == BattleFieldType.Desert then
        local r, g, b, a = 255, 255, 255, 255
        local speedUp = data.buffValue or 0
        if speedUp ~= nil and 0 < speedUp then
          speedUp = math.max(0, math.min(speedUp, 9999))
          remainTime = remainTime / (1 - speedUp * 1.0E-4)
          r = 94
          g = 251
          b = 104
        end
        self.mv_time_txt:SetColorRGBA255(r, g, b, a)
      elseif self.bfType == BattleFieldType.EpidemicZone then
        bArbiter = data.reason == "arbiterBreak"
      elseif self.bfType == BattleFieldType.DsbDuel then
        local r, g, b, a = 255, 255, 255, 255
        local speedUp = data.buffValue or 0
        if speedUp ~= nil and 0 < speedUp then
          speedUp = math.max(0, math.min(speedUp, 9999))
          remainTime = remainTime / (1 - speedUp * 1.0E-4)
          r = 94
          g = 251
          b = 104
        end
        self.mv_time_txt:SetColorRGBA255(r, g, b, a)
      end
      local str = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
      self.mv_time_txt:SetText(str)
    end
  end
  if self.bfType == BattleFieldType.EpidemicZone then
    local old = self.lastBArbiter
    if old ~= bArbiter then
      self.lastBArbiter = bArbiter
      self.btnTransport:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, bArbiter and "mjc_yibianjunqu_btn_qiancheng_debuff" or "lrb_shamofengbao_btn_qiancheng"))
    end
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

function BattleFieldBaseView:OnBattleFieldCanEnterPush(worldType)
  if worldType ~= nil and toInt(worldType) ~= toInt(self.bfType) then
    return
  end
  self:RefreshLeftBtn()
end

function BattleFieldBaseView:RefreshLeftBtn()
  local isObserve = BattleFieldUtil.isObserve
  self.left_btn_layout:SetActive(not isObserve)
  if self.btn_go then
    self.btn_go:SetActive(isObserve)
  end
  if isObserve then
    local flag = self:IsCurWatchIdx()
    if self.btn_go then
      self.btn_go:SetInteractable(flag)
    end
    if self.tip_go then
      self.tip_go:SetActive(isObserve and flag and BattleFieldUtil.GetBattleFieldCanEnterFlag(self.bfType))
    end
    if self.text_btn_go then
      if flag then
        self.text_btn_go:SetLocalText("458006")
      else
        self.text_btn_go:SetLocalText("Desert_strom_tips1031")
      end
    end
  else
    if self.tip_go then
      self.tip_go:SetActive(false)
    end
    CommonUtil.PlayerPrefsSetString(EnterDragonWorld .. self.bfType, tostring(UITimeManager:GetInstance():GetServerSeconds()))
  end
  self:OnObserveChange()
end

function BattleFieldBaseView:OnResourceUpdated()
  self.text_coin:SetText(string.GetFormattedGoldNum(LuaEntry.Player.gold))
end

function BattleFieldBaseView:RefreshBuff()
  self:DestroyBuff()
  self.buffIcons = {}
  local effectList = BattleFieldUtil.GetEffectListWithInfo()
  if effectList and 0 < #effectList then
    local nextSec = 0
    self.btn_buff:SetActive(true)
    for i, effect in ipairs(effectList) do
      if effect.template ~= nil then
        if effect.expireTime ~= nil and (nextSec == 0 or nextSec > effect.expireTime) then
          nextSec = effect.expireTime
        end
        if i <= 5 then
          self:GetOneBuffIcon(i, effect.template.effect_icon or effect.template.icon)
        end
      end
    end
    if 0 < nextSec then
      local curSec = UITimeManager:GetInstance():GetServerSeconds()
      local remainSec = nextSec - curSec
      if 0 < remainSec then
        self.buffAutoRefreshSeq = TimerManager:GetInstance():DelayInvoke(function()
          self.buffAutoRefreshSeq = nil
          EventManager:GetInstance():Broadcast(EventId.LuaEntryEffectRefreshStatus)
        end, remainSec + 0.1)
      end
    end
  else
    self.btn_buff:SetActive(false)
  end
end

function BattleFieldBaseView:GetOneBuffIcon(idx, icon)
  self.buffIcons[idx] = self:GameObjectInstantiateAsync(UIAssets.BuffIcon, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.buff_content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.name = "BuffIcon" .. idx
    local cell = self.buff_content:AddComponent(BuffIcon, go.name)
    cell:ReInit({
      meta = {icon = icon}
    })
  end)
end

function BattleFieldBaseView:DestroyBuff()
  if self.buffAutoRefreshSeq ~= nil then
    self.buffAutoRefreshSeq:Stop()
    self.buffAutoRefreshSeq = nil
  end
  self.buff_content:RemoveComponents(BuffIcon)
  if self.buffIcons ~= nil then
    for k, v in pairs(self.buffIcons) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.buffIcons = nil
  end
end

function BattleFieldBaseView:OnHospitalUpdate()
  local info = BattleFieldUtil.GetSoldiersInfo()
  if info.id then
    self.soldierInfo = info
    self.text_power:SetText(string.GetFormattedStr(info.count) .. "/" .. string.GetFormattedStr(info.total))
  else
    self.soldierInfo = nil
    self.text_power:SetText(0)
  end
  self:OnHospitalUpdateEx()
end

function BattleFieldBaseView:OnRefreshAllianceWarTip(data)
  if self.rally_tip_obj then
    self.rally_tip_obj:RefreshTip(data)
  end
end

function BattleFieldBaseView:OnAllianceUpdate()
  if self.bfType ~= BattleFieldType.Desert then
    return
  end
  if not LuaEntry.Player:IsInAlliance() then
    DataCenter.ActDragonManager:ReqLevelDragonWorld()
    BattleFieldUtil.BackToCity(self.bfType)
  end
  self:RefreshAllianceRedPoint()
end

function BattleFieldBaseView:RefreshAllianceRedPoint()
  if self.rally_tip_obj ~= nil then
    self.rally_tip_obj:CheckRedPoint()
  end
end

function BattleFieldBaseView:Update()
  DataCenter.BattleFieldAnimManager:OnUpdate()
end

function BattleFieldBaseView:Update1000MS()
  local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
  if BattleFieldUtil.InBattleField() then
    if mainUIView and mainUIView:GetActive() then
      mainUIView:SetActive(false)
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWLLBattleMainUIView) then
      DataCenter.LandlordMgr:TryCloseBattleMainWindow()
    end
    if not self.view:GetActive() then
      self.view:SetActive(true)
    end
  else
    if mainUIView then
      mainUIView:SetActive(true)
    end
    self.view:SetActive(false)
    if self.view.ctrl then
      self.view.ctrl:CloseSelf()
    end
  end
  if self.safe_area and self.safe_area.unity_canvas_group and self.safe_area:GetActive() ~= true then
    local stackCount = UIManager:GetInstance():GetStackWindowCount()
    if stackCount == 0 then
      self.safe_area:SetActive(true)
      self.safe_area:FadeIn(0.3)
    end
  end
  if self.heart ~= nil then
    local showHospitalEffect, showHospitalEffectGreen = BattleFieldUtil.CheckHospitalEffState()
    if showHospitalEffect then
      if not self.heart_effect:GetActive() then
        self.heart_effect:SetActive(true)
        self.eff_heart:Play()
      end
      self.eff_glow_green:Stop()
      self.glow_green_effect:SetActive(false)
    else
      self.eff_heart:Stop()
      self.heart_effect:SetActive(false)
    end
    if showHospitalEffectGreen then
      if not self.glow_green_effect:GetActive() then
        self.glow_green_effect:SetActive(true)
        self.eff_glow_green:Play()
        self:OnHospitalUpdate()
      end
      self.eff_heart:Stop()
      self.heart_effect:SetActive(false)
    elseif self.glow_green_effect:GetActive() then
      self.glow_green_effect:SetActive(false)
      self.eff_glow_green:Stop()
      self:OnHospitalUpdate()
    end
  end
  if self.text_end_cd then
    local remainTime = self.battleEndSec - UITimeManager:GetInstance():GetServerSeconds()
    if 0 < remainTime and remainTime <= DESERT_BATTLE_END_COUNTDOWN_TIME then
      self.text_end_cd:SetActive(true)
      self.text_end_cd:SetText(toInt(remainTime))
    elseif self.text_end_cd:GetActive() then
      self.text_end_cd:SetActive(false)
    end
  end
  self:OnCityMoveCoolDown()
end

function BattleFieldBaseView:ShowAlarmEffect(type)
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

function BattleFieldBaseView:RefreshOneBuildBtn(idx)
  self:InitPolygonPoints()
  if table.IsNullOrEmpty(self.polygonPoints) then
    return
  end
  local btn = self.worldBuildObjs ~= nil and self.worldBuildObjs[idx] or nil
  local info = self.worldBuildInfos ~= nil and self.worldBuildInfos[idx] or nil
  if btn ~= nil then
    if btn:AsyncLoadDone() then
      if table.IsNullOrEmpty(info) then
        btn:UpdateMilePointer()
      else
        btn:UpdateMilePointer(SceneUtils.TileIndexToWorld(info[2], ForceChangeScene.World), info[3], info[4], self.centerE)
      end
    end
    return
  end
  if table.IsNullOrEmpty(info) then
    return
  end
  local prefab = idx == CENTER_E_CITY_KEY and PREFAB_WORLD_MAIN_BTN or PREFAB_WORLD_BUILD_BTN
  btn = self:LoadComponentAsync(CLS_WORLD_BUILD_BTN, prefab, self.centerE, function(_, go)
    if idx == CENTER_E_CITY_KEY then
      go.transform:SetAsLastSibling()
    else
      go.transform:SetAsFirstSibling()
    end
    go.name = "WorldBuildBtn_" .. idx
    info = self.worldBuildInfos ~= nil and self.worldBuildInfos[idx] or nil
    btn:SetRange(self.polygonPoints)
    if table.IsNullOrEmpty(info) then
      btn:UpdateMilePointer()
    else
      btn:UpdateMilePointer(SceneUtils.TileIndexToWorld(info[2], ForceChangeScene.World), info[3], info[4], self.centerE)
    end
  end)
  self.worldBuildObjs = self.worldBuildObjs or {}
  self.worldBuildObjs[idx] = btn
end

function BattleFieldBaseView:SetTroopListShow(show, loopListIndex)
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
    self.view.ctrl:SetSelectFormationUuid(0)
    self.view:HideAllShowTip()
  end
end

function BattleFieldBaseView:HideAllShowTip()
  self.troopListObj:HideAllShowTip()
end

function BattleFieldBaseView:IsTroopListShow()
  return self.troopListObj ~= nil and self.troopListObj:GetActive()
end

function BattleFieldBaseView:ShowFormationRallyTip(x, y, dataInfo)
  self.troopListObj:ShowFormationRallyTip(x, y, dataInfo)
end

function BattleFieldBaseView:OnSelectClick(uuid)
  self.troopListObj:OnSelectClick(uuid)
end

function BattleFieldBaseView:ShowFormationCreateTip(x, y, dataInfo)
  self.troopListObj:ShowFormationCreateTip(x, y, dataInfo)
end

function BattleFieldBaseView:OnAtkClick(uuid)
  self.troopListObj:OnAtkClick(uuid)
end

function BattleFieldBaseView:OnCreateClick(uuid)
  self.troopListObj:OnCreateClick(uuid)
end

function BattleFieldBaseView:OnEditClick(uuid, needAutoAdd)
  self.troopListObj:OnEditClick(uuid, needAutoAdd)
end

function BattleFieldBaseView:GetTimeInFormation(uuid)
  return self.troopListObj:GetTimeInFormation(uuid)
end

function BattleFieldBaseView:OnClickStartInvestigate(targetPointId)
  self.troopListObj:OnClickStartInvestigate(targetPointId)
end

function BattleFieldBaseView:ResetScoutSelectTipPosition(posX, posY)
  return self.troopListObj:ResetScoutSelectTipPosition(posX, posY)
end

function BattleFieldBaseView:OnClickScoutTroopItem(formationIndex)
  return self.troopListObj:OnClickScoutTroopItem(formationIndex)
end

function BattleFieldBaseView:GetScoutTroopUnlockLv(formationIndex)
  return self.troopListObj:GetScoutTroopUnlockLv(formationIndex)
end

function BattleFieldBaseView:ShowFormationArmyTip(x, y, dataInfo)
  self.troopListObj:ShowFormationArmyTip(x, y, dataInfo)
end

function BattleFieldBaseView:ShowCollectRewardFlyEff(rewards)
  self.troop_obj:PlayCollectRewardFlyEff(rewards)
end

return BattleFieldBaseView
