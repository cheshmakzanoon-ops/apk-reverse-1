local UIMainChangeScene = BaseClass("UIMainChangeScene", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local btn_path = "Btn"
local btn_Text_path = "Btn/name"
local btnIcon_path = "Btn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:CheckImage()
  self:CheckRadarCenterUpgrade()
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btnIcon = self:AddComponent(UIImage, btnIcon_path)
  self.btnName = self:AddComponent(UIText, btn_Text_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.lod = 1
  self.canClick = true
  self.hasRadar = true
end

local function ComponentDestroy(self)
  self:ClearTimer()
  self.btn = nil
end

local function SetLod(self, lod)
  if self.lod ~= lod then
    self.lod = lod
    self:RefreshData()
  end
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnEnterCity, self.UpdateBtn)
  self:AddUIListener(EventId.OnEnterWorld, self.UpdateBtn)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnEnterCity, self.UpdateBtn)
  self:RemoveUIListener(EventId.OnEnterWorld, self.UpdateBtn)
end

local function RefreshData(self)
end

local function OnClick(self)
  local curScene = CS.SceneManager.CurrSceneID
  if curScene == SceneManagerSceneID.City then
    CommonUtil.FeatureExplorationTrack(FeatureExplorationType.World)
    local unlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_WorldBtn)
    if not unlock then
      UIUtil.ShowTipsId(lockTips)
      return
    end
  end
  if LuaEntry.Player:GetMainWorldPos() < 0 then
    SFSNetwork.SendMessage(MsgDefines.MoveCityToWorld)
  end
  if self.canClick == false then
    return
  end
  if self.view and self.view.bottom and self.view.bottom.ClearAlComponent then
    self.view.bottom:ClearAlComponent()
    self.view.bottom:RefreshAlBtns(false)
  end
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  if curScene == SceneManagerSceneID.City or curScene == SceneManagerSceneID.World then
    CS.UIGray.SetGray(self.btnIcon.transform, true, true)
    self.canClick = false
    if curScene == SceneManagerSceneID.World then
      if CrossServerUtil:GetIsCrossServer() then
        if BattleFieldUtil.InBattleField() then
          UIUtil.PlayCutSceneAnim(function()
            CrossServerUtil.OnBackSelfServerFromDragonWorld(SceneType.City)
            SceneUtils.ChangeToCity(function()
              if self.btnIcon ~= nil and not IsNull(self.btnIcon.transform) then
                CS.UIGray.SetGray(self.btnIcon.transform, false, true)
              end
              self.canClick = true
              self:ClearTimer()
              self:AfterChangeToCity()
            end)
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.SwitchScene01, false)
          end, nil, loginServerId)
          return
        end
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World, loginServerId), nil, 0.02, function()
          SceneUtils.ChangeToCity(function()
            if self.btnIcon ~= nil and not IsNull(self.btnIcon.transform) then
              CS.UIGray.SetGray(self.btnIcon.transform, false, true)
            end
            self.canClick = true
            self:ClearTimer()
            self:AfterChangeToCity()
          end)
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.SwitchScene01, false)
        end, loginServerId)
      else
        SceneUtils.ChangeToCity(function()
          if self.btnIcon ~= nil and not IsNull(self.btnIcon.transform) then
            CS.UIGray.SetGray(self.btnIcon.transform, false, true)
          end
          self.canClick = true
          self:ClearTimer()
          self:AfterChangeToCity()
        end)
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SwitchScene01, false)
      end
    else
      SceneUtils.ChangeToWorld(function()
        CS.UIGray.SetGray(self.btnIcon.transform, false, true)
        self.canClick = true
        self:ClearTimer()
      end)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.SwitchScene01, false)
    end
  end
  if not self.canClick then
    if self.fullbackTimer then
      self.fullbackTimer:Stop()
    end
    self.fullbackTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.canClick = true
      if self.btnIcon then
        CS.UIGray.SetGray(self.btnIcon.transform, false, true)
        self:CheckImage()
      end
      self.fullbackTimer = nil
    end, 2)
  end
end

local function ClearTimer(self)
  if self.fullbackTimer then
    self.fullbackTimer:Stop()
    self.fullbackTimer = nil
  end
end

local function UpdateBtn(self)
  self.canClick = true
  if self.btnIcon then
    CS.UIGray.SetGray(self.btnIcon.transform, false, true)
    self:CheckImage()
  end
end

local function OnChangeSceneEnd(self)
  if self.uiPveLoading then
    self.uiPveLoading:Quit()
    self.uiPveLoading = nil
  end
end

local function CheckImage(self)
  if SceneUtils.GetIsInCity() then
    self.btnIcon:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_shijie.png")
    self.btnName:SetLocalText("main_ui_world")
  elseif SceneUtils.GetIsInWorld() then
    self.btnIcon:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_daben.png")
    self.btnName:SetLocalText("main_ui_base")
  end
end

local function CheckRadarCenterUpgrade(self)
  local canShow = true
  if canShow == false then
    CS.UIGray.SetGray(self.btnIcon.transform, true, true)
    self.canClick = false
    self.hasRadar = false
  else
    CS.UIGray.SetGray(self.btnIcon.transform, false, true)
    self.canClick = true
    self.hasRadar = true
  end
end

function UIMainChangeScene:AfterChangeToCity()
  local monoMgr = DataCenter.MonopolyManager
  if monoMgr then
    monoMgr:TryMoveCameraEnterCity()
  end
end

UIMainChangeScene.OnCreate = OnCreate
UIMainChangeScene.OnDestroy = OnDestroy
UIMainChangeScene.OnEnable = OnEnable
UIMainChangeScene.OnDisable = OnDisable
UIMainChangeScene.ComponentDefine = ComponentDefine
UIMainChangeScene.ComponentDestroy = ComponentDestroy
UIMainChangeScene.DataDefine = DataDefine
UIMainChangeScene.DataDestroy = DataDestroy
UIMainChangeScene.OnAddListener = OnAddListener
UIMainChangeScene.OnRemoveListener = OnRemoveListener
UIMainChangeScene.OnChangeSceneEnd = OnChangeSceneEnd
UIMainChangeScene.RefreshData = RefreshData
UIMainChangeScene.OnClick = OnClick
UIMainChangeScene.SetLod = SetLod
UIMainChangeScene.CheckImage = CheckImage
UIMainChangeScene.CheckRadarCenterUpgrade = CheckRadarCenterUpgrade
UIMainChangeScene.ClearTimer = ClearTimer
UIMainChangeScene.UpdateBtn = UpdateBtn
return UIMainChangeScene
