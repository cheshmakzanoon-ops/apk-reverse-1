local UIMysteryFeatureProgress = require("UI.UIParkour.MainUI.Component.UIMysteryFeatureProgress")
local Const = require("Scene.LWBattle.Const")
local Resource = CS.GameEntry.Resource
local LWCountBattleMainView = BaseClass("LWCountBattleMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function LWCountBattleMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWCountBattleMainView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  if self.featureResourceReq ~= nil then
    self.featureResourceReq:Destroy()
    self.featureResourceReq = nil
  end
end

function LWCountBattleMainView:ComponentDefine()
  if CS.CommonUtils.IsDebug() then
    self.GMText = self:AddComponent(UIText, "GmWinBtn/GMText")
    self.GMText:SetText(DataCenter.LWBattleManager:GetCurBattleLogic():GetStageId())
    self.gm_win_btn = self:AddComponent(UIButton, "GmWinBtn")
    self.gm_win_btn:SetOnClick(function()
      DataCenter.LWBattleManager:GetCurBattleLogic().playerGroupProxy.group.DisableLogic = true
      DataCenter.LWBattleManager:GetCurBattleLogic():OnBattleWin()
    end)
    self.jump_guide_btn = self:AddComponent(UIButton, "Guide/jumpGuide")
    self.jump_guide_btn:SetOnClick(function()
      DataCenter.LWGuideManager:ClearData()
      DataCenter.LWBattleManager:SetGamePause(false)
      DataCenter.LWBattleManager:GetCurBattleLogic():OnBattleWin()
      local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Scene.Name)
      if CanvasNormal then
        CanvasNormal.gameObject:SetActive(true)
      end
      SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, GuideState.Over)
    end)
  else
    self.transform:Find("Guide/jumpGuide").gameObject:SetActive(false)
    self.transform:Find("GmWinBtn").gameObject:SetActive(false)
  end
  self.winConditionNode = self:AddComponent(UIBaseComponent, "WinCondition")
  self.winConditionNode:SetActive(false)
  self.winConditionArea = self.transform:Find("WinCondition")
  self.winConditionIcon = self:AddComponent(UIImage, "WinCondition/WinIcon")
  self.winConditionSlider = self:AddComponent(UISlider, "WinCondition/Slider")
  self.winConditionSliderEff = self:AddComponent(UIBaseComponent, "WinCondition/Slider/Eff_ui_beizengmen_guanka_jindu")
  self.winConditionSliderEff:SetActive(false)
  self.winConditionBarImg = self:AddComponent(UIImage, "WinCondition/Slider/FillArea/Fill")
  self.winConditionText = self:AddComponent(UIText, "WinCondition/WinBarText")
  self.winConditionIconView = self:AddComponent(UIBaseContainer, "WinCondition/WinIconList")
  self.winConditionIconListHolder = self.transform:Find("WinCondition/WinIconList/List")
  self.winConditionIconListCell = {}
  if self.winConditionIconListHolder then
    for _, transform in pairs(self.winConditionIconListHolder) do
      transform.gameObject:Destroy()
    end
  end
  self.animator = self:AddComponent(UIAnimator, "")
  self.winBanner = self:AddComponent(UIBaseComponent, "WinBanner")
  self.winBanner:SetActive(false)
  self.winBannerTxt = self:AddComponent(UIText, "WinBanner/WinBannerText")
  self.winBannerTxt:SetLocalText(GameDialogDefine.MISSION_COMPLETE)
  self.missionBar = self:AddComponent(UISimpleAnimation, "Mission")
  self.missionIcon = self:AddComponent(UIImage, "Mission/hengfu/MissionIcon")
  self.missionBg = self:AddComponent(UIImage, "Mission/hengfu/sanjiao")
  self.missionText = self:AddComponent(UIText, "Mission/hengfu/Text_0")
  self.missionTarText = self:AddComponent(UIText, "Mission/hengfu/Text_1")
  if self.missionBar then
    self.missionBar:SetActive(false)
  end
  self.back_btn = self:AddComponent(UIButton, "BackBtn")
  self.back_btn:SetActive(true)
  self.back_btn:SetOnClick(function()
    self:OnExitBtnClick()
  end)
  self.startGame_Btn = self:AddComponent(UIButton, "Guide/btnContent/startGameBtn")
  self.startGame_text = self:AddComponent(UIText, "Guide/btnContent/startGameBtn/Text")
  self.startGame_text:SetLocalText(100833)
  self.startGame_Btn:SetOnClick(function()
    self:OnStartGameClick()
  end)
  self.loginGameBtn = self:AddComponent(UIButton, "Guide/btnContent/loginGameBtn")
  self.loginBtnText = self:AddComponent(UIText, "Guide/btnContent/loginGameBtn/loginBtnText")
  self.loginBtnText:SetLocalText(110008)
  self.loginGameBtn:SetOnClick(function()
    self:OnLoginGameClick()
  end)
  local state = DataCenter.AccountManager:GetAccountBindState()
  self.loginGameBtn:SetActive(state ~= AccountBandState.Band)
  if CS.GameEntry.Setting.IsReview then
    self.loginGameBtn:SetActive(false)
  end
  local param = self:GetUserData()
  self.guide = self.transform:Find("Guide").gameObject
  self.guide:SetActive(param.showGuide)
  self.back_btn:SetActive(not param.showGuide)
  self.punchOK = 0
  if DataCenter.LWBattleManager.logic.param.enterType == PVEEnterType.StageFeatureBuilding then
    local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(DataCenter.LWBattleManager.logic.param.featureId)
    local index = table.indexof(feature.stages, DataCenter.LWBattleManager.logic.param.levelId)
    local iconUrl
    if feature.winType[index] ~= 3 then
      self.showConditionDelay = TimerManager:GetInstance():DelayInvoke(function()
        self.showConditionDelay = nil
        if self.transform then
          if #feature.winType == 1 then
            if feature.winType[index] == 1 then
              local content = Localization:GetString("newbies_fuben_coin_loading", tostring(feature.winNeedCount[index]))
              self:ShowCondition("", content, 1, feature.winType[index])
            elseif feature.winType[index] == 2 then
              if #feature.stages == 1 then
                local content = Localization:GetString("newbies_fuben_save_loading", tostring(feature.winNeedCount[index]))
                self:ShowCondition("", content, 1, feature.winType[index])
              else
                local content = Localization:GetString("newbies_fuben_battlefront_loading", tostring(feature.winNeedCount[index]))
                self:ShowCondition("", content, 1, feature.winType[index])
              end
            end
          elseif feature.winType[index] == 1 then
            local content = Localization:GetString("newbies_fuben_coin_loading", tostring(feature.winNeedCount[index]))
            self:ShowCondition("", content, 1, feature.winType[index])
          elseif feature.winType[index] == 2 then
            local content = Localization:GetString("newbies_fuben_save_loading", tostring(feature.winNeedCount[index]))
            self:ShowCondition("", content, 1, feature.winType[index])
          elseif feature.winType[index] == 0 then
            local content = Localization:GetString("newbies_fuben_attack_loading")
            self:ShowCondition("", content, 1, feature.winType[index])
          end
        end
      end, 1)
      if feature.winType[index] == 1 or feature.winType[index] == 2 then
        self.featureResourceReq = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/ParkourBattle/GrowResource.prefab")
        self.featureResourceReq:completed("+", function()
          self.resourceRoot = self:AddComponent(UIBaseContainer, "ResNode")
          local item = self.featureResourceReq.gameObject
          item.name = "Res1"
          item.transform:SetParent(self.resourceRoot.transform)
          item.transform:Set_localPosition(0, 0, 0)
          local featureProgress = self.resourceRoot:AddComponent(UIMysteryFeatureProgress, item.name)
          local param = {}
          if feature.winType[index] == 1 then
          elseif feature.winType[index] == 2 then
            iconUrl = "Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_zaobing.png"
            param.soldier = true
            self.resourceRoot:SetActive(true)
          end
          param.resourceType = 2
          param.iconName = iconUrl
          param.showCount = 0
          param.maxCount = feature.winNeedCount[index]
          featureProgress:SetZero(param)
        end)
      end
    end
  end
end

function LWCountBattleMainView:ComponentDestroy()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self:ClearEffectRes()
  self.back_btn = nil
  if self.winConditionIconListHolder then
    for _, transform in pairs(self.winConditionIconListHolder) do
      transform.gameObject:Destroy()
    end
  end
  self.missionBar = nil
  self.missionText = nil
  self.missionTarText = nil
  self.missionIcon = nil
  self.missionBg = nil
  if self.showConditionDelay then
    self.showConditionDelay:Stop()
    self.showConditionDelay = nil
  end
end

function LWCountBattleMainView:ShowCondition(title, content, delay, winType)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_goal_show)
  self.missionBar:SetActive(true)
  self:ShowWinConditionImage(winType)
  self.missionBar.simpleAnimation:Play("Default")
  self.missionText:SetLocalText(title)
  self.missionTarText:SetLocalText(content)
  self.missionBar.simpleAnimation:Play("Default")
  self.showConditionDelay = TimerManager:GetInstance():DelayInvoke(function()
    self.showConditionDelay = nil
    self.missionBar.simpleAnimation:Play("Close")
    self.winConditionAreaTweener = self.winConditionArea:DOScale(Vector3.New(1, 1, 1), 0.3)
    self.winConditionAreaTweener:Delay(1)
  end, delay)
end

function LWCountBattleMainView:ShowWinConditionImage(winType)
  self:ClearEffectRes()
  if winType then
    if winType == 3 or winType == 4 then
      self.missionTarText:SetColor(WhiteColor)
    else
      self.missionTarText:SetColor(ParkourYellowColor)
    end
    if Const.ParkourWinConditionTypeAtlas[winType] then
      self.missionIcon:LoadSpriteAuto(Const.ParkourWinConditionTypeAtlas[winType])
      self.missionBg:LoadSpriteAuto(Const.ParkourWinConditionBgAtlas[winType])
      if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
      end
      self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:LoadEffectPrefabs(Const.ParkourWinConditionBgEffect[winType], self.missionBg, "effectBg")
      end, 0.11)
      self:LoadEffectPrefabs(Const.ParkourWinConditionIconEffect[winType], self.missionIcon, "effectIcon")
    else
      self.missionIcon:LoadSpriteAuto(Const.ParkourWinConditionDefaultAtlas[1])
      self.missionBg:LoadSpriteAuto(Const.ParkourWinConditionDefaultAtlas[2])
    end
  end
end

function LWCountBattleMainView:LoadEffectPrefabs(path, parent, effectName)
  if self.effectResHandles == nil then
    self.effectResHandles = {}
  end
  if string.IsNullOrEmpty(path) then
    return
  end
  effectName = effectName or "effect_" .. tostring(#self.effectResHandles + 1)
  if self.effectResHandles[effectName] ~= nil then
    self.effectResHandles[effectName]:Destroy()
    self.effectResHandles[effectName] = nil
  end
  local request = CS.GameEntry.Resource:InstantiateAsync(path)
  self.effectResHandles[effectName] = request
  request:completed("+", function()
    if request.isError or request.gameObject == nil then
      self.effectResHandles[effectName] = nil
      return
    end
    request.gameObject:SetActive(true)
    local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTransform ~= nil then
      rectTransform:SetParent(parent.transform, false)
      rectTransform:Set_localScale(1, 1, 1)
      rectTransform:Set_anchoredPosition(0, 0)
    end
  end)
end

function LWCountBattleMainView:ClearEffectRes()
  if self.effectResHandles then
    for name, effect in pairs(self.effectResHandles) do
      if effect then
        effect:Destroy()
        effect = nil
      end
    end
    self.effectResHandles = nil
  end
end

function LWCountBattleMainView:SetWinConditionBar(percent)
  if not self.transform then
    return
  end
  self.winConditionSlider:SetValue(Mathf.Clamp(percent, 0, 1))
  if 1 <= percent then
    self.winConditionSliderEff:SetActive(true)
  end
end

function LWCountBattleMainView:SetWinConditionText(txt, punch)
  if not self.transform then
    return
  end
  if self.winConditionText and self.winConditionText:GetText() ~= txt then
    self.winConditionText:SetText(txt)
    if punch then
      local now = UITimeManager:GetInstance():GetServerTime()
      if now > self.punchOK then
        self.punchOK = now + PUNCH_CD * 1000
        self.winConditionText.transform:DOKill()
        self.winConditionText.transform:Set_localScale(1, 1, 1)
        self.winConditionText.transform:DOPunchScale(Vector3.New(1, 1, 1), PUNCH_CD, 1, 0.4)
      end
    end
  end
end

function LWCountBattleMainView:OnAddListener()
  base.OnAddListener(self)
end

function LWCountBattleMainView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWCountBattleMainView:OnStartGameClick()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_battle_start_btn, false)
  self.guide:SetActive(false)
  DataCenter.LWGuideManager:GuideStartGame()
end

function LWCountBattleMainView:OnLoginGameClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChooseSwitchAccount, 110008)
end

function LWCountBattleMainView:OnExitBtnClick()
  if DataCenter.LWBattleManager.logic.winTimer or DataCenter.LWBattleManager.gameOver then
    return
  end
  self:OnExit()
end

function LWCountBattleMainView:OnExit()
  PostEventLog.BattleResultLog(PVEType.Count, 2)
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic and logic.param and logic.param.enterType == PVEEnterType.StageFeatureScene then
    DataCenter.LWBattleManager:SetBattleExitFlag(true)
  end
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "quit")
end

function LWCountBattleMainView:OnBattleWin()
  self.back_btn:SetActive(false)
  self.winBanner:SetActive(true)
  self.animator:Play("Eff_ui_beizengmen_mubiao_wancheng", 0, 0)
  TimerManager:GetInstance():DelayInvoke(function()
    if self.winBanner then
      self.winBanner:SetActive(false)
    end
    if self.winConditionNode then
      self.winConditionNode:SetActive(false)
    end
  end, 1.8)
end

function LWCountBattleMainView:OnBattleLose()
  self.back_btn:SetActive(false)
end

function LWCountBattleMainView:UpdateEndType2Condition(total, curr)
  if curr == 0 then
    self.winConditionNode:SetActive(true)
    self.winConditionIcon:LoadSprite("Assets/Main/Sprites/UI/UIZombieBattleMain/zyf_guanqia_guai_icon")
    self.winConditionBarImg:LoadSprite("Assets/Main/Sprites/UI/UIZombieBattleMain/guanqia_cfm_tubiao_jindutiao_2")
  end
  self:SetWinConditionBar(math.max(0, total - curr) / total)
  self:SetWinConditionText(string.format("%d", math.max(0, total - curr)), true)
end

return LWCountBattleMainView
