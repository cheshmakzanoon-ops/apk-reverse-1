local base = UIBaseView
local LWMainUIView = BaseClass("LWMainUIView", UIBaseView)
local UIMainTop = require("UI.LWMainUI.Component.UIMainTop.UIMainTop")
local UIMainLeft = require("UI.LWMainUI.Component.UIMainLeft.UIMainLeft")
local UIMainBottom = require("UI.LWMainUI.Component.UIMainBottom.UIMainBottom")
local UIMainTopEffect = require("UI.LWMainUI.Component.UIMainTopEffect.UIMainTopEffect")
local UIMainCenter = require("UI.LWMainUI.Component.UIMainCenter.UIMainCenter")
local UIMainShakeCollectRes = require("UI.LWMainUI.Component.UIMainShakeCollectRes")
local UIMainShakeMainBaseDisco = require("UI.LWMainUI.Component.UIMainShakeMainBaseDisco")
local top_path = "safeArea/topLayer"
local bottom_path = "safeArea/bottomLayer"
local left_path = "safeArea/leftLayer"
local anim_path = "safeArea"
local top_effecr_path = "topEffectLayer"
local center_path = "safeArea/centerLayer"
local bottom_RightBtnLayout_path = "safeArea/bottomLayer/RightBtnLayout"
local left_layout_path = "safeArea/leftLayer/layout"
local SHOW_MINI_MAP_MIN_LOD = 3

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitAnim()
  self:InitSavePos()
  self:ChangeClickSound()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWMainUIView:ChangeClickSound(parents)
  parents = parents or self
  if not parents.components then
    return
  end
  for _, v in pairs(parents.components) do
    for _, vv in pairs(v) do
      if vv.ForceUseDefaultSound1 ~= nil then
        vv.ForceUseDefaultSound1 = true
      elseif vv.components then
        self:ChangeClickSound(vv)
      end
    end
  end
end

local function ComponentDefine(self)
  self.top = self:AddComponent(UIMainTop, top_path)
  self.bottom = self:AddComponent(UIMainBottom, bottom_path)
  self.left = self:AddComponent(UIMainLeft, left_path)
  self.topEffect = self:AddComponent(UIMainTopEffect, top_effecr_path)
  self.center = self:AddComponent(UIMainCenter, center_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.bottom_RightBtnLayout = self:AddComponent(UIBaseContainer, bottom_RightBtnLayout_path)
  self.leftLayout = self:AddComponent(UIBaseContainer, left_layout_path)
  self.shakeCollectRes = self:AddComponent(UIMainShakeCollectRes, "")
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Darkness then
    self.shakeMainBaseDisco = self:AddComponent(UIMainShakeMainBaseDisco, "")
  end
  self:CheckFunctionUnlock()
  if FIRST_TIME_ENTER_CITY then
    DataCenter.LWSoundManager:InitAudioMixerUsable(function()
      CommonUtil.PlayGameBgMusic()
    end)
    FIRST_TIME_ENTER_CITY = false
  end
end

local function ComponentDestroy(self)
  self.top = nil
  self.bottom = nil
  self.left = nil
  self.topEffect = nil
  self.anim = nil
  self.center = nil
end

local function DataDefine(self)
  self.isCreateMiniMap = false
end

local function DataDestroy(self)
  self.isCreateMiniMap = false
  self.dynamicPosList = nil
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.worldBannerInst then
    self.worldBannerInst:Destroy()
    self.worldBannerInst = nil
  end
end

local function RefreshPanel(self)
  self.top:ReInit()
  self.bottom:ReInit()
  self.left:ReInit()
  self.center:ReInit()
end

function LWMainUIView:ShowHeroExpEffect()
  if self.bottom then
    self.bottom:ShowHeroExpEffect()
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshPanel(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.QuitDragonWorld, self.OnQuitDragonWorld)
  self:AddUIListener(EventId.EnterDragonWorld, self.OnEnterDragonWorld)
  self:AddUIListener(EventId.UIMAIN_VISIBLE, self.SetVisible)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:AddUIListener(EventId.OnEnterWorld, self.OnEnterWorld)
  self:AddUIListener(EventId.OnEnterCity, self.OnEnterCity)
  self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:AddUIListener(EventId.GoTroopListShow, self.SetTroopListShow)
  self:AddUIListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:AddUIListener(EventId.UpdateFakeBuildingPos, self.UpdateConstructPos)
  self:AddUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:AddUIListener(EventId.RefreshResourceItem, self.UpdateResourceItemSignal)
  self:AddUIListener(EventId.RefreshMainUIHeroRedPoint, self.OnHeroRedPointUpdate)
  self:AddUIListener(EventId.GF_hero_squad_saved, self.OnHeroRedPointUpdate)
  self:AddUIListener(EventId.MailPush, self.UpdateMailCount)
  self:AddUIListener(EventId.UpdateMarchItem, self.FlashingRedResetTime)
  self:AddUIListener(EventId.BuildLevelUp, self.OnBuildInfoChange)
  self:AddUIListener(EventId.ShowMainUIExtraResource, self.ShowMainUIExtraResourceSignal)
  self:AddUIListener(EventId.HideMainUIExtraResource, self.HideMainUIExtraResourceSignal)
  self:AddUIListener(EventId.UpdateMainAllianceRedCount, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.AllianceWarUpdate, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.UpdateAllianceAutoRallyInfo, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.ALLIANCE_WAR_DELETE, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.UpdateAlertRedPoint, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.CrossServerWar, self.RefreshAllianceRedPoint)
  self:AddUIListener(EventId.PlayMainUIAnim, self.OnPlayMainUIAnim)
  self:AddUIListener(EventId.OnLeagueMatchStageChange, self.OnLeagueMatchStageChangeSignal)
  self:AddUIListener(EventId.MainUILeftPosRefresh, self.RefreshLeftPos)
  self:AddUIListener(EventId.MainUIBottomHide, self.OnBottomHide)
  self:AddUIListener(EventId.MainUIBottomShow, self.OnBottomShow)
  self:AddUIListener(EventId.FIRST_PAY_BUILD_ADD, self.OnBuildAdd)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.QuitDragonWorld, self.OnQuitDragonWorld)
  self:RemoveUIListener(EventId.EnterDragonWorld, self.OnEnterDragonWorld)
  self:RemoveUIListener(EventId.UIMAIN_VISIBLE, self.SetVisible)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:RemoveUIListener(EventId.OnEnterWorld, self.OnEnterWorld)
  self:RemoveUIListener(EventId.OnEnterCity, self.OnEnterCity)
  self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:RemoveUIListener(EventId.GoTroopListShow, self.SetTroopListShow)
  self:RemoveUIListener(EventId.BuildMainZeroUpgradeSuccess, self.BuildMainZeroUpgradeSuccessSignal)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:RemoveUIListener(EventId.UpdateFakeBuildingPos, self.UpdateConstructPos)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.UpdateResourceItemSignal)
  self:RemoveUIListener(EventId.RefreshMainUIHeroRedPoint, self.OnHeroRedPointUpdate)
  self:RemoveUIListener(EventId.MailPush, self.UpdateMailCount)
  self:RemoveUIListener(EventId.UpdateMarchItem, self.FlashingRedResetTime)
  self:RemoveUIListener(EventId.BuildLevelUp, self.OnBuildInfoChange)
  self:RemoveUIListener(EventId.ShowMainUIExtraResource, self.ShowMainUIExtraResourceSignal)
  self:RemoveUIListener(EventId.HideMainUIExtraResource, self.HideMainUIExtraResourceSignal)
  self:RemoveUIListener(EventId.UpdateMainAllianceRedCount, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.AllianceWarUpdate, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.UpdateAllianceAutoRallyInfo, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.ALLIANCE_WAR_DELETE, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.UpdateAlertRedPoint, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.CrossServerWar, self.RefreshAllianceRedPoint)
  self:RemoveUIListener(EventId.PlayMainUIAnim, self.OnPlayMainUIAnim)
  self:RemoveUIListener(EventId.OnLeagueMatchStageChange, self.OnLeagueMatchStageChangeSignal)
  self:RemoveUIListener(EventId.GF_hero_squad_saved, self.OnHeroRedPointUpdate)
  self:RemoveUIListener(EventId.MainUILeftPosRefresh, self.RefreshLeftPos)
  self:RemoveUIListener(EventId.MainUIBottomHide, self.OnBottomHide)
  self:RemoveUIListener(EventId.MainUIBottomShow, self.OnBottomShow)
  self:RemoveUIListener(EventId.FIRST_PAY_BUILD_ADD, self.OnBuildAdd)
end

local function SetVisible(self, isVisible)
  if SceneUtils.GetIsInWorld() then
    local world = CS.SceneManager.World
    if world then
      local lod = world:GetLodLevel()
      if isVisible and lod < SHOW_MINI_MAP_MIN_LOD then
        self:PlayAnim(UIMainAnimType.ChangeAllShow)
      else
        self:PlayAnim(UIMainAnimType.AllHide)
      end
    end
  elseif isVisible then
    self:PlayAnim(UIMainAnimType.ChangeAllShow)
  else
    self:PlayAnim(UIMainAnimType.AllHide)
  end
  self.ctrl:SetVisibleState(isVisible)
end

local function OnPlayMainUIAnim(self, params)
  local animMask = params[1]
  local isShow = params[2]
  self:PlayAnim(animMask, isShow)
end

local function InitAnim(self)
  self.ctrl:InitVisibleState()
  self.ctrl:InitAnim(self.transform)
  self:InitSavePos()
  if DataCenter.GuideManager:IsCanDoUIMainAnim() then
    self.curAnimState = UIMainAnimType.AllShow
  else
    self.curAnimState = UIMainAnimType.AllHide
    self.ctrl:PlayAnim(UIMainAnimMask.All, false)
  end
end

local function GetAnimMaskByAnimName(oldAnimName)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    if oldAnimName == UIMainAnimType.AllShow then
      return UIMainAnimMask.ArabicAll, true
    elseif oldAnimName == UIMainAnimType.AllHide then
      return UIMainAnimMask.ArabicAll, false
    elseif oldAnimName == UIMainAnimType.LeftRightBottomShow then
      return UIMainAnimMask.ArabicBottom + UIMainAnimFlag.ArabicTopLeft + UIMainAnimFlag.ArabicTopRight, true
    elseif oldAnimName == UIMainAnimType.LeftRightBottomHide then
      return UIMainAnimMask.ArabicBottom + UIMainAnimFlag.ArabicTopLeft + UIMainAnimFlag.ArabicTopRight, false
    elseif oldAnimName == UIMainAnimType.BottomShow then
      return UIMainAnimMask.ArabicBottom, true
    elseif oldAnimName == UIMainAnimType.BottomHide then
      return UIMainAnimMask.ArabicBottom, false
    elseif oldAnimName == UIMainAnimType.ChangeAllShow then
      return UIMainAnimMask.ArabicAll, true
    end
  elseif oldAnimName == UIMainAnimType.AllShow then
    return UIMainAnimMask.All, true
  elseif oldAnimName == UIMainAnimType.AllHide then
    return UIMainAnimMask.All, false
  elseif oldAnimName == UIMainAnimType.LeftRightBottomShow then
    return UIMainAnimMask.Bottom + UIMainAnimFlag.TopLeft + UIMainAnimFlag.TopRight, true
  elseif oldAnimName == UIMainAnimType.LeftRightBottomHide then
    return UIMainAnimMask.Bottom + UIMainAnimFlag.TopLeft + UIMainAnimFlag.TopRight, false
  elseif oldAnimName == UIMainAnimType.BottomShow then
    return UIMainAnimMask.Bottom, true
  elseif oldAnimName == UIMainAnimType.BottomHide then
    return UIMainAnimMask.Bottom, false
  elseif oldAnimName == UIMainAnimType.ChangeAllShow then
    return UIMainAnimMask.All, true
  end
  return 0, false
end

local function PlayAnim(self, animName, force)
  if BattleFieldUtil.InBattleField() then
    local uiStr = BattleFieldUtil.GetMainUIName()
    if not string.IsNullOrEmpty(uiStr) then
      local MainDesertUI = UIManager:GetInstance():GetWindow(uiStr)
      if MainDesertUI then
        local desertUI = MainDesertUI.View
        if desertUI then
          desertUI:PlayAnim(animName, force)
        end
      end
    end
    if animName ~= UIMainAnimType.AllHide then
      return
    end
  elseif DataCenter.LandlordMgr:GetIsShowingLLMainUI() then
    DataCenter.LandlordMgr:PlayLLMainUIAnim(animName)
    if animName ~= UIMainAnimType.AllHide then
      return
    end
  end
  if force or DataCenter.GuideManager:IsCanDoUIMainAnim() then
    animName = self:CheckDoAnimName(animName)
    if animName ~= nil then
      if (self.inDragonWorld == true or BattleFieldUtil.InBattleField()) and animName ~= UIMainAnimType.AllHide then
        return
      end
      self.curAnimState = animName
      local animMask, isShow = GetAnimMaskByAnimName(animName)
      self.ctrl:PlayAnim(animMask, isShow)
      if self:CheckCenterShow() then
        if self.center then
          self.center:UpdateMilePointer(true)
          self.center:UpdateFireworkBackBtnMilePointer(true)
        end
      elseif self.center then
        self.center:UpdateMilePointer(false)
        self.center:UpdateFireworkBackBtnMilePointer(false)
      end
      if self.top then
        self.top:UpdateWhenAnim(animName)
      end
      if self.bottom then
        self.bottom:UpdateWhenAnim(animName)
      end
      if self.left then
        self.left:UpdateWhenAnim(animName)
      end
    end
  end
end

local function CheckDoAnimName(self, animName)
  if animName == UIMainAnimType.AllShow then
    if self.curAnimState ~= UIMainAnimType.AllShow then
      return animName
    end
  elseif animName == UIMainAnimType.LeftRightBottomShow then
    if self.curAnimState ~= UIMainAnimType.LeftRightBottomShow then
      return animName
    end
  elseif animName == UIMainAnimType.BottomShow then
    if self.curAnimState == UIMainAnimType.BottomHide then
      return animName
    end
  elseif animName == UIMainAnimType.AllHide then
    if self.curAnimState ~= UIMainAnimType.AllHide then
      return animName
    end
  elseif animName == UIMainAnimType.LeftRightBottomHide then
    if self.curAnimState ~= UIMainAnimType.LeftRightBottomHide then
      return animName
    end
  elseif animName == UIMainAnimType.BottomHide then
    if self.curAnimState ~= UIMainAnimType.BottomHide then
      return animName
    end
  elseif animName == UIMainAnimType.ChangeAllShow then
    if self.curAnimState == UIMainAnimType.AllHide then
      return UIMainAnimType.AllShow
    elseif self.curAnimState == UIMainAnimType.LeftRightBottomHide then
      return UIMainAnimType.LeftRightBottomShow
    elseif self.curAnimState == UIMainAnimType.BottomHide then
      return UIMainAnimType.BottomShow
    else
      return UIMainAnimType.AllShow
    end
  end
  if animName == self.curAnimState or animName == UIMainAnimType.ChangeAllShow and self.curAnimState == UIMainAnimType.AllShow then
  else
    Logger.LogError("Anim return nil  animName:" .. animName .. " cutAnimState:" .. self.curAnimState)
  end
  return nil
end

local function UpdateResourceSignal(self)
  self.top:RefreshResource()
end

local function UpdateResourceItemSignal(self)
end

local function UpdateItemSignal(self)
  self.top:RefreshAllianceItemSignal()
end

local function ShowMainUIExtraResourceSignal(self, data)
  if data ~= nil then
    self.top:ShowExtraResource(data)
  end
end

local function HideMainUIExtraResourceSignal(self, data)
  self.top:HideExtraResource(data)
end

local function OnHeroRedPointUpdate(self)
  if self.bottom ~= nil then
    self.bottom:OnUpdateRedPot(UIMainFunctionInfo.Hero)
  end
end

local function RefreshAllianceRedPoint(self)
  if self.bottom ~= nil then
    self.bottom:OnUpdateRedPot(UIMainFunctionInfo.Alliance)
  end
end

local function OnEnterWorld(self)
  self.bottom:OnEnterWorld()
  self.left:OnEnterWorld()
  if self.battleFailNoticeInst then
    self.battleFailNoticeInst:Destroy()
    self.battleFailNoticeInst = nil
  end
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.worldBannerInst then
    self.worldBannerInst:Destroy()
    self.worldBannerInst = nil
  end
  if DataCenter.BuildManager.MainLv < 15 then
    local worldBanner = "Assets/Main/Prefabs/UI/LWMainUI/LWMainUIWorldBanner.prefab"
    self.worldBannerInst = self:GameObjectInstantiateAsync(worldBanner, function(request)
      local go = request.gameObject
      go.transform:SetParent(self.center.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_offsetMin(0, 0)
      go.transform:Set_offsetMax(0, 0)
      local canvasGroup = go:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
      canvasGroup.alpha = 0
      self.tweenSeq = DOTween.Sequence()
      self.tweenSeq:AppendInterval(0.5)
      self.tweenSeq:Append(canvasGroup:DOFade(1, 1))
      self.tweenSeq:AppendInterval(1.5)
      self.tweenSeq:Append(canvasGroup:DOFade(0, 1))
      self.tweenSeq:AppendCallback(function()
        if self.worldBannerInst then
          self.worldBannerInst:Destroy()
          self.worldBannerInst = nil
        end
      end)
    end)
  end
end

local function OnEnterCity(self, params)
  self.bottom:OnEnterCity()
  self.left:OnEnterCity()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.worldBannerInst then
    self.worldBannerInst:Destroy()
    self.worldBannerInst = nil
  end
end

local function OnEnterDragonWorld(self)
  self.inDragonWorld = true
  if self.isCreateDesertMainUI ~= true then
    local uiStr = BattleFieldUtil.GetMainUIName()
    if not string.IsNullOrEmpty(uiStr) then
      UIManager:GetInstance():OpenWindow(uiStr, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, LuaEntry.Player:GetCurWorldType())
      self:PlayAnim(UIMainAnimType.AllHide)
      self.isCreateDesertMainUI = true
    end
  end
end

local function OnQuitDragonWorld(self)
  self.inDragonWorld = false
  if self.isCreateDesertMainUI == true then
    local uiStr = BattleFieldUtil.GetMainUIName()
    if not string.IsNullOrEmpty(uiStr) then
      UIManager:GetInstance():DestroyWindow(uiStr, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllShow
      })
      self.isCreateDesertMainUI = false
    end
  end
  self:PlayAnim(UIMainAnimType.AllShow)
end

local function UpdateLod(self, lod)
  self.bottom:UpdateLod(lod)
  self.left:UpdateLod(lod)
  if BattleFieldUtil.InBattleField() then
    if self.isCreateDesertMainUI ~= true then
      local uiStr = BattleFieldUtil.GetMainUIName()
      if not string.IsNullOrEmpty(uiStr) then
        UIManager:GetInstance():OpenWindow(uiStr, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        })
        self.isCreateDesertMainUI = true
      end
    end
    return
  end
  if self.isCreateDesertMainUI == true then
    local uiStr = BattleFieldUtil.GetMainUIName()
    if not string.IsNullOrEmpty(uiStr) then
      UIManager:GetInstance():DestroyWindow(uiStr, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllShow
      })
      self.isCreateDesertMainUI = false
    end
  end
  if lod >= SHOW_MINI_MAP_MIN_LOD then
    self:TryShowMiniMap()
  else
    self:TryHideMiniMap()
  end
end

local function InitSavePos(self)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bottom_RightBtnLayout.rectTransform)
  self.posList = {}
  self.posList[UIMainSavePosType.Quest] = self.bottom:GetQuestPosition()
  self.posList[UIMainSavePosType.Build] = self.bottom:GetBuildBtnPos()
  self.posList[UIMainSavePosType.LWBattleBtn] = self.bottom:GetPveBtnPos()
  self.posList[UIMainSavePosType.PlayerLevel] = self.left:GetPlayerLevelPos()
  self.posList[UIMainSavePosType.HeroBtn] = self.bottom:GetHeroBtnPos()
  self.posList[UIMainSavePosType.BagBtn] = self.bottom:GetBagBtnPos()
  self.posList[UIMainSavePosType.AllianceBtn] = self.bottom:GetAllianceBtnPos()
  self.posList[UIMainSavePosType.MailBtn] = self.bottom:GetMailBtnPos()
  self.posList[UIMainSavePosType.VisitorBtn] = self.bottom:GetVisitorBtnPos()
  self.posList[UIMainSavePosType.HeroBtn] = self.bottom:GetHeroBtnPos()
  self.posList[UIMainSavePosType.Goods] = self.top:GetGoodsPos()
  self.posList[UIMainSavePosType.Gold] = self.top:GetGoldBtnPos()
  self.posList[UIMainSavePosType.Power] = self.top:GetPowerPosition()
  self.posList[UIMainSavePosType.Mummy] = self.bottom:GetMummyBtnPos()
  self:RefreshLeftPos()
  self:InitSavePosDynamic()
end

local function InitSavePosDynamic(self)
  self.dynamicPosList = self.dynamicPosList or {}
  self.dynamicPosList[UIMainSavePosType.Search] = function()
    return self.bottom and self.bottom:GetSearchBtnPos() or nil
  end
  self.dynamicPosList[UIMainSavePosType.GoldBrickBtn] = function()
    return self.top and self.top:GetGoldBrickPos() or nil
  end
end

local function GetSavePosFromDynamic(self, posType)
  if not self.dynamicPosList or not self.dynamicPosList[posType] then
    return nil
  end
  return self.dynamicPosList[posType]()
end

local function RefreshLeftPos(self)
  if self.posList then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.leftLayout.rectTransform)
    self.posList[UIMainSavePosType.StorageLimit] = self.left:GetPlayerLevelPos()
    self.posList[UIMainSavePosType.Stamina] = self.left:GetPlayerLevelPos()
    self.posList[UIMainSavePosType.BuildQueue] = self.left:GetBuildQueuePos()
    self.posList[UIMainSavePosType.SaveGirlWarning] = self.left:GetSaveGirlWarningPos()
  end
end

local function GetSavePos(self, posType)
  local pos = self.posList[posType]
  pos = pos or self:GetSavePosFromDynamic(posType)
  if pos == nil then
    Logger.LogError(posType .. " not found on mainUI")
    pos = self.posList[UIMainSavePosType.PlayerLevel]
  end
  return pos
end

local function GetResourcePos(self, resourceType)
  if self.top then
    return self.top:GetResourcePos(resourceType)
  else
    return self.posList[UIMainSavePosType.PlayerLevel]
  end
end

local function GetAllianceItemPos(self, aItemType)
  if self.top then
    return self.top:GetAllianceItemPos(aItemType)
  else
    return self.posList[UIMainSavePosType.PlayerLevel]
  end
end

local function IsTroopListShow(self)
  return self.left ~= nil and self.left:IsTroopListShow()
end

local function SetTroopListShow(self, show, listIndex)
  self.left:SetTroopListShow(show, listIndex)
end

local function HideAllShowTip(self)
  self.left:HideAllShowTip()
end

local function OnSelectClick(self, uuid)
  self.left:OnSelectClick(uuid)
end

local function ShowFormationCreateTip(self, x, y, dataInfo)
  self.left:ShowFormationCreateTip(x, y, dataInfo)
end

local function GetTimeInFormation(self, uuid)
  return self.left:GetTimeInFormation(uuid)
end

local function ShowFormationArmyTip(self, x, y, dataInfo)
  self.left:ShowFormationArmyTip(x, y, dataInfo)
end

local function ShowFormationRallyTip(self, x, y, dataInfo)
  self.left:ShowFormationRallyTip(x, y, dataInfo)
end

local function OnAtkClick(self, uuid)
  self.left:OnAtkClick(uuid)
end

local function OnCreateClick(self, uuid)
  self.left:OnCreateClick(uuid)
end

local function OnEditClick(self, uuid, needAutoAdd)
  self.left:OnEditClick(uuid, needAutoAdd)
end

local function OnClickStartInvestigate(self, targetPointId)
  return self.left:OnClickStartInvestigate(targetPointId)
end

local function ResetScoutSelectTipPosition(self, posX, posY)
  return self.left:ResetScoutSelectTipPosition(posX, posY)
end

local function OnClickScoutTroopItem(self, formationIndex)
  return self.left:OnClickScoutTroopItem(formationIndex)
end

local function GetScoutTroopUnlockLv(self, formationIndex)
  return self.left:GetScoutTroopUnlockLv(formationIndex)
end

local function RefreshCameraPoint(self)
  if not self.center then
    return
  end
  if self:CheckCenterShow() then
    self.center:UpdateMilePointer(true)
    self.center:UpdateFireworkBackBtnMilePointer(true)
  else
    self.center:UpdateMilePointer(false)
    self.center:UpdateFireworkBackBtnMilePointer(false)
  end
end

local function CheckCenterShow(self)
  local isConstructing = self.ConstructingBuildID and self.ConstructingBuildID == BuildingTypes.APS_BUILD_WORMHOLE_SUB
  if self.curAnimState == UIMainAnimType.AllShow or self.curAnimState == UIMainAnimType.LeftRightBottomShow or isConstructing then
    return true
  end
  return false
end

local function BuildMainZeroUpgradeSuccessSignal(self)
  self.center:UpdateConstructPos(nil)
  self:RefreshCameraPoint()
  self:UpdateLod(CS.SceneManager.World:GetLodLevel())
end

local function UpdateConstructPos(self, tempPos)
  local tempPosV3
  if tempPos ~= nil then
    tempPosV3 = SceneUtils.TileIndexToWorld(tempPos)
  end
  self.center:UpdateConstructPos(tempPosV3)
  self.center:UpdateFireworkBackBtnConstructPos()
  self:RefreshCameraPoint()
end

local function TryShowMiniMap(self)
  if self.isCreateMiniMap == false then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMainMiniMap, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
    self.isCreateMiniMap = true
  end
end

local function TryHideMiniMap(self)
  if self.isCreateMiniMap == true then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMainMiniMap, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllShow
    })
    self.isCreateMiniMap = false
  end
end

local function FlashingRedResetTime(self)
end

local function UpdateMailCount(self, userdata)
  if self.bottom ~= nil then
    self.bottom:OnUpdateRedPot(UIMainFunctionInfo.Mail, userdata)
  end
end

local function RegisterFunctionUnlock(self, id, gameObject)
  if not self.functionUnlock then
    self.functionUnlock = {}
  end
  if not self.functionUnlock[id] then
    self.functionUnlock[id] = {}
  end
  table.insert(self.functionUnlock[id], gameObject)
end

local function OnBuildInfoChange(self)
  self:CheckFunctionUnlock()
  if self.top then
    self.top:OnBuildLevelUp()
  end
end

local function OnBuildAdd(self)
  self:CheckFunctionUnlock()
end

local function CheckFunctionUnlock(self)
  if not self.functionUnlock then
    return
  end
  local mgr = DataCenter.LWFunctionUnlockManager
  for unlockId, compList in pairs(self.functionUnlock) do
    local unlock = mgr:CheckCanShow(unlockId)
    for _, comp in ipairs(compList) do
      if not IsNull(comp) then
        if unlockId == LWFunctionUnlockType.MainUI_FirstPay then
          self.top.firstChargeBtn:RefreshShowState()
        elseif unlockId == LWFunctionUnlockType.MainUI_GoldBar then
          comp:SetActive(unlock)
          if unlock then
            self.top.goldStoreN:RefreshStoreRedPoint()
          end
        elseif unlockId == LWFunctionUnlockType.MainUI_Stamina then
          comp:SetActive(unlock)
          if unlock then
            self.left.player_bg.transform:Set_pivot(0.5, 0.5)
            self.left.player_bg.transform:Set_anchoredPosition(0, -13.5)
            self.left.player_bg:SetSizeDeltaXY(108, 144)
          else
            self.left.player_bg.transform:Set_pivot(0.5, 1)
            self.left.player_bg.transform:Set_anchoredPosition(0, 60)
            self.left.player_bg:SetSizeDeltaXY(108, 108)
          end
        else
          comp:SetActive(unlock)
        end
      else
        self.functionUnlock[unlockId] = nil
        Logger.LogError("mainui unlock check missing:" .. unlockId)
      end
    end
    if unlockId == LWFunctionUnlockType.MainUI_BuildQueue then
      self.left.build_queue:Refresh()
    end
    if unlockId == LWFunctionUnlockType.MainUI_Chat then
      self.bottom.chat_obj:ReInit(true)
    end
  end
end

local function RefreshPopupPackageEntrances(self)
  if self.top then
    self.top:RefreshPopupPackageEntrances()
  end
end

function LWMainUIView:RefreshPopupPackageEntrances()
  if self.top ~= nil then
    self.top:OnLeagueMatchStageChangeSignal()
  end
end

function LWMainUIView:OnShowCrossServerTip()
  if self.top then
    self.top:OnShowCrossServerTip()
  end
end

local function ShowAlarmEffect(self, alarmType)
  if self.topEffect and self.topEffect.ShowAlarmEffect then
    self.topEffect:ShowAlarmEffect(alarmType)
  end
end

function LWMainUIView:GetBtnPosByType(mainUITipType)
  if mainUITipType == MainUITipType.Alliance then
    if self.bottom then
      return self.bottom:GetBtnPosByType(mainUITipType)
    end
  elseif (mainUITipType == MainUITipType.Activity or mainUITipType == MainUITipType.Gift or mainUITipType == MainUITipType.AllyCity or mainUITipType == MainUITipType.WarZone or mainUITipType == MainUITipType.AllyDuel or mainUITipType == MainUITipType.Season or mainUITipType == MainUITipType.AccountBind or mainUITipType == MainUITipType.MeteoriteBattle or mainUITipType == MainUITipType.ActMigration or mainUITipType > MainUITipType.Special) and self.top then
    return self.top:GetBtnPosByType(mainUITipType)
  end
  return nil
end

local function GetBuffIconPosByIndex(self, index)
  return self.top:GetBuffIconPosByIndex(index)
end

function LWMainUIView:OnBottomHide()
  self:PlayAnim(UIMainAnimType.BottomHide)
end

function LWMainUIView:OnBottomShow()
  self:PlayAnim(UIMainAnimType.BottomShow)
end

function LWMainUIView:GetMultiKillTime(isPve)
  if not self.multiKillPve then
    self.multiKillPvp = LuaEntry.DataConfig:TryGetNum("killstreak_report_UI", "k2", 5)
    self.multiKillPve = LuaEntry.DataConfig:TryGetNum("killstreak_report_UI", "k4", 5)
  end
  return isPve and self.multiKillPve or self.multiKillPvp
end

function LWMainUIView:RecoverFromInactive()
  if SceneUtils.GetIsInWorld() and CS.SceneManager.World and CS.SceneManager.World.Camera then
    local curLod = CS.SceneManager.World:GetLodLevel()
    self:UpdateLod(curLod)
    if curLod < SHOW_MINI_MAP_MIN_LOD then
      self:OnPlayMainUIAnim({
        UIMainAnimType.ChangeAllShow,
        true
      })
    end
  end
end

LWMainUIView.OnShowCrossServerTip = OnShowCrossServerTip
LWMainUIView.OnCreate = OnCreate
LWMainUIView.OnDestroy = OnDestroy
LWMainUIView.ComponentDefine = ComponentDefine
LWMainUIView.ComponentDestroy = ComponentDestroy
LWMainUIView.DataDefine = DataDefine
LWMainUIView.DataDestroy = DataDestroy
LWMainUIView.RefreshPanel = RefreshPanel
LWMainUIView.OnEnable = OnEnable
LWMainUIView.OnDisable = OnDisable
LWMainUIView.OnAddListener = OnAddListener
LWMainUIView.OnRemoveListener = OnRemoveListener
LWMainUIView.SetVisible = SetVisible
LWMainUIView.PlayAnim = PlayAnim
LWMainUIView.InitAnim = InitAnim
LWMainUIView.CheckDoAnimName = CheckDoAnimName
LWMainUIView.UpdateResourceSignal = UpdateResourceSignal
LWMainUIView.InitSavePos = InitSavePos
LWMainUIView.InitSavePosDynamic = InitSavePosDynamic
LWMainUIView.GetSavePosFromDynamic = GetSavePosFromDynamic
LWMainUIView.GetSavePos = GetSavePos
LWMainUIView.OnEnterWorld = OnEnterWorld
LWMainUIView.OnEnterCity = OnEnterCity
LWMainUIView.UpdateLod = UpdateLod
LWMainUIView.GetResourcePos = GetResourcePos
LWMainUIView.GetAllianceItemPos = GetAllianceItemPos
LWMainUIView.IsTroopListShow = IsTroopListShow
LWMainUIView.SetTroopListShow = SetTroopListShow
LWMainUIView.HideAllShowTip = HideAllShowTip
LWMainUIView.OnSelectClick = OnSelectClick
LWMainUIView.ShowFormationCreateTip = ShowFormationCreateTip
LWMainUIView.GetTimeInFormation = GetTimeInFormation
LWMainUIView.ShowFormationArmyTip = ShowFormationArmyTip
LWMainUIView.ShowFormationRallyTip = ShowFormationRallyTip
LWMainUIView.OnAtkClick = OnAtkClick
LWMainUIView.OnCreateClick = OnCreateClick
LWMainUIView.OnEditClick = OnEditClick
LWMainUIView.OnClickStartInvestigate = OnClickStartInvestigate
LWMainUIView.ResetScoutSelectTipPosition = ResetScoutSelectTipPosition
LWMainUIView.OnClickScoutTroopItem = OnClickScoutTroopItem
LWMainUIView.GetScoutTroopUnlockLv = GetScoutTroopUnlockLv
LWMainUIView.BuildMainZeroUpgradeSuccessSignal = BuildMainZeroUpgradeSuccessSignal
LWMainUIView.RefreshCameraPoint = RefreshCameraPoint
LWMainUIView.CheckCenterShow = CheckCenterShow
LWMainUIView.UpdateConstructPos = UpdateConstructPos
LWMainUIView.UpdateResourceItemSignal = UpdateResourceItemSignal
LWMainUIView.UpdateItemSignal = UpdateItemSignal
LWMainUIView.ShowMainUIExtraResourceSignal = ShowMainUIExtraResourceSignal
LWMainUIView.HideMainUIExtraResourceSignal = HideMainUIExtraResourceSignal
LWMainUIView.OnHeroRedPointUpdate = OnHeroRedPointUpdate
LWMainUIView.RefreshAllianceRedPoint = RefreshAllianceRedPoint
LWMainUIView.TryShowMiniMap = TryShowMiniMap
LWMainUIView.TryHideMiniMap = TryHideMiniMap
LWMainUIView.UpdateMailCount = UpdateMailCount
LWMainUIView.FlashingRedResetTime = FlashingRedResetTime
LWMainUIView.OnBuildInfoChange = OnBuildInfoChange
LWMainUIView.RegisterFunctionUnlock = RegisterFunctionUnlock
LWMainUIView.CheckFunctionUnlock = CheckFunctionUnlock
LWMainUIView.RefreshPopupPackageEntrances = RefreshPopupPackageEntrances
LWMainUIView.OnPlayMainUIAnim = OnPlayMainUIAnim
LWMainUIView.OnEnterDragonWorld = OnEnterDragonWorld
LWMainUIView.OnQuitDragonWorld = OnQuitDragonWorld
LWMainUIView.RefreshLeftPos = RefreshLeftPos
LWMainUIView.GetBuffIconPosByIndex = GetBuffIconPosByIndex
LWMainUIView.ShowAlarmEffect = ShowAlarmEffect
LWMainUIView.OnBuildAdd = OnBuildAdd
return LWMainUIView
