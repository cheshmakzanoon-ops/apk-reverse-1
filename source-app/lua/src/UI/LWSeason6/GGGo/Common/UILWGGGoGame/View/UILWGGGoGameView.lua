local base = UIBaseView
local LWGGGoPveBoot = require("DataCenter.LWGGGo.LWGGGoPveBoot")
local UILWGGGoGameView = BaseClass("UILWGGGoGameView", base)
local Localization = CS.GameEntry.Localization
local Client = CS.MiniGame.GGGo.Client
local text_title_path = "TitleBar/TextTitle"
local head_icon_path = "ProgressRoot/Slider/SelfHeadRoot/SelfHead"
local game_root_path = "P0"
local btn_back_path = "Bottom/BtnBack"
local ValidationTime = 10

function UILWGGGoGameView:OnCreate()
  base.OnCreate(self)
  if Config.IsPC() then
    local bg = UIManager:GetInstance():GetLayer(UILayer.NormalBg.Name)
    if not IsNull(bg) then
      bg.transform.transform.localScale = Vector3.New(0, 0, 0)
    end
  end
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
  DataCenter.LWGGGoDataManager:PlaySeasonActivityBGM()
  EventManager:GetInstance():Broadcast(EventId.SmallGameUIOpenClose, true)
end

function UILWGGGoGameView:OnDestroy()
  EventManager:GetInstance():Broadcast(EventId.SmallGameUIOpenClose, false)
  if Config.IsPC() then
    local bg = UIManager:GetInstance():GetLayer(UILayer.NormalBg.Name)
    if not IsNull(bg) then
      bg.transform.transform.localScale = Vector3.New(1, 1, 1)
    end
  end
  DataCenter.LWGGGoDataManager:StopSeasonActivityBGM()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWGGGoGameView:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.game_root = self:AddComponent(UIBaseContainer, game_root_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self, self.ClickCloseBtn))
  self.PlayerHead = self:AddComponent(UICommonHead, head_icon_path)
  self.PlayerHead:SetAsMyself()
  self.ctrl.boot = LWGGGoPveBoot.New()
  self.ctrl.boot:CreateHandle(self)
  self.ctrl.boot:BindCallback(BindCallback(self, self.EcsHandle))
  local configID = DataCenter.LWGGGoDataManager:GetCurrentLevelConfigID()
  local stageName = GetTableData(TableName.SEASON_CAVE_EXPLORATION, configID, "game_level")
  self.ctrl.boot:Start(stageName, self.game_root.transform)
  Logger.Log("[LWGGGo] PVE Game Boot Start configID=" .. tostring(configID) .. " stageName=" .. tostring(stageName) .. " uid=" .. tostring(LuaEntry.Player.uid))
  self.updater = BindCallback(self, self.OnUpdate)
  UpdateManager:GetInstance():AddUpdate(self.updater)
end

function UILWGGGoGameView:ComponentDestroy()
  if self.ctrl.boot ~= nil then
    self.ctrl.boot:Dispose()
    self.ctrl.boot = nil
  end
  if self.soundStart then
    DataCenter.LWSoundManager:StopSound(self.soundStart)
    self.soundStart = nil
  end
  self.text_title = nil
  self.game_root = nil
  self.btn_back = nil
  if self.updater then
    UpdateManager:GetInstance():RemoveUpdate(self.updater)
    self.updater = nil
  end
end

function UILWGGGoGameView:DataDefine()
  self.updateFinish = nil
  self.battleResult = nil
  self.waitTime = nil
  self.error = nil
  self.popWindow = nil
end

function UILWGGGoGameView:DataDestroy()
  self.updateFinish = nil
  self.battleResult = nil
  self.waitTime = nil
  self.error = nil
  self.popWindow = nil
  self.bulletViews = nil
end

function UILWGGGoGameView:OnEnable()
  base.OnEnable(self)
end

function UILWGGGoGameView:OnDisable()
  base.OnDisable(self)
  DataCenter.LWGGGoDataManager:SetReplayMode(false)
end

function UILWGGGoGameView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonGGGoPveValidationEnd, self.SeasonGGGoPveValidationEndHandle)
  self:AddUIListener(EventId.SeasonGGGoPveStart, self.SeasonGGGoPveStartHandle)
end

function UILWGGGoGameView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonGGGoPveValidationEnd, self.SeasonGGGoPveValidationEndHandle)
  self:RemoveUIListener(EventId.SeasonGGGoPveStart, self.SeasonGGGoPveStartHandle)
  base.OnRemoveListener(self)
end

function UILWGGGoGameView:ClickCloseBtn()
  if self.ctrl.boot ~= nil then
    self.ctrl.boot:Dispose()
    self.ctrl.boot = nil
  end
  self.ctrl:CloseSelf()
end

function UILWGGGoGameView:SeasonGGGoPveValidationEndHandle(validation)
  self.waitTime = nil
  if validation.code ~= 0 then
    self:PopValidation()
    return
  end
  if self.popWindow ~= nil then
    self.popWindow.ctrl:CloseSelf()
    self.popWindow = nil
  end
  self.battleResult.validation = validation
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGGGoPveResult, {anim = true}, self.battleResult)
end

function UILWGGGoGameView:SeasonGGGoPveStartHandle()
  if self.ctrl and self.ctrl.boot ~= nil then
    self.ctrl.boot.startSyncEnd = true
  end
end

function UILWGGGoGameView:InitFinish()
  return self.ctrl and self.ctrl.boot ~= nil and self.ctrl.boot:IsDone()
end

function UILWGGGoGameView:EcsHandle(render)
  if render.Type == Client.UIRenderType.UIWait then
    cast(render, typeof(Client.DataUIRender.UIWait))
    UIUtil.ShowCountdownTimeUI(UITimeManager:GetInstance():GetServerTime() + render.WaitTime * 1000)
    self.soundStart = DataCenter.LWSoundManager:PlaySound(6100026, false)
    return
  end
  if render.Type == Client.UIRenderType.UIResult then
    cast(render, typeof(Client.DataUIRender.UIResult))
    self.battleResult = {
      validationStr = render.ValidationStr or "",
      level = DataCenter.LWGGGoDataManager:GetCurrentLevel(),
      battleTimeMills = render.battleTimeMills,
      boot = self.ctrl.boot,
      stageCfgId = DataCenter.LWGGGoDataManager:GetStageCfgId()
    }
    if render.IsWin then
      local bid = DataCenter.LWGGGoDataManager:GetBid()
      local version = DataCenter.LWGGGoDataManager:GetVersion(self.battleResult.stageCfgId)
      local activityType = DataCenter.LWGGGoDataManager:GetActivityType()
      local isReplay = DataCenter.LWGGGoDataManager:IsReplayMode()
      Logger.Log("[LWGGGo] PVE Game Win level=" .. tostring(self.battleResult.level) .. " stageCfgId=" .. tostring(self.battleResult.stageCfgId) .. " battleTimeMills=" .. tostring(render.battleTimeMills) .. " bid=" .. tostring(bid) .. " isReplay=" .. tostring(isReplay) .. " uid=" .. tostring(LuaEntry.Player.uid))
      local message = isReplay and MsgDefines.ActivityLittleGamePveEndReplay or MsgDefines.ActivityLittleGamePveEnd
      SFSNetwork.SendMessage(message, bid, self.battleResult.validationStr, render.battleTimeMills, version, self.battleResult.stageCfgId, activityType)
      self.waitTime = ValidationTime
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGGGoPveFairResult, {anim = true}, self.battleResult)
      if not string.IsNullOrEmpty(self.battleResult.validationStr) then
        local FuncVersion = CS.MiniGame.GGGo.Client.FuncVersion
        local codeMd5 = ""
        if FuncVersion then
          codeMd5 = FuncVersion.CSharpCodeMD5
        end
        Logger.Log("[LWGGGo] PVE BattleFair Replay is " .. self.battleResult.validationStr .. "version is " .. DataCenter.LWGGGoDataManager:GetVersion() .. "player uid is " .. LuaEntry.Player.uid .. "md5 is " .. codeMd5)
      end
    end
  end
  if render.Type == Client.UIRenderType.UINetWork then
    cast(render, typeof(Client.DataUIRender.UINetWork))
    if not render.SuccOrFair then
      UIUtil.ShowSecondMessage("", Localization:GetString("season_s5_activity_1200045_desc34"), 1, "110006", nil, function()
        if self.ctrl then
          self.ctrl:CloseSelf()
        end
      end, nil, nil, function()
        if self.ctrl then
          self.ctrl:CloseSelf()
        end
      end, nil, nil, nil, nil, nil, false, nil, nil)
      self.popWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UISellConfirm)
    end
  end
end

function UILWGGGoGameView:OnUpdate()
  if self.waitTime ~= nil and self.waitTime > 0 then
    self.waitTime = self.waitTime - Time.deltaTime
    if self.waitTime < 0 then
      self.error = true
      self:PopTimeOut()
    end
  end
end

function UILWGGGoGameView:PopTimeOut()
  UIUtil.ShowSecondMessage("", Localization:GetString("season_s5_activity_1200045_desc34"), 2, "110006", "110106", function()
    self.ctrl:CloseSelf()
  end, nil, function()
  end, nil, nil, nil, nil, nil, nil, false, nil, nil)
  self.waitTime = nil
  self.popWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UISellConfirm)
end

function UILWGGGoGameView:PopValidation()
  UIUtil.ShowSecondMessage("", Localization:GetString("season_s5_activity_1200045_desc33"), 2, "110006", "110106", function()
    self.ctrl:CloseSelf()
  end, nil, function()
  end, nil, nil, nil, nil, nil, nil, false, nil, nil)
  self.popWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UISellConfirm)
end

function UILWGGGoGameView:Next()
  if self.ctrl.boot == nil then
    return false
  end
  self.ctrl.boot:Dispose()
  self.ctrl.boot:CreateHandle(self)
  local isReplay = DataCenter.LWGGGoDataManager:IsReplayMode()
  local message = isReplay and MsgDefines.ActivityLittleGamePveStartReplay or MsgDefines.ActivityLittleGamePveStart
  SFSNetwork.SendMessage(message, DataCenter.LWGGGoDataManager:GetVersion(), DataCenter.LWGGGoDataManager:GetActivityType())
  Logger.Log("[LWGGGo] PVE Next Game Start version=" .. tostring(DataCenter.LWGGGoDataManager:GetVersion()) .. " activityType=" .. tostring(DataCenter.LWGGGoDataManager:GetActivityType()) .. " isReplay=" .. tostring(isReplay) .. " uid=" .. tostring(LuaEntry.Player.uid))
  self.ctrl.boot:BindCallback(BindCallback(self, self.EcsHandle))
  local configID = DataCenter.LWGGGoDataManager:GetCurrentLevelConfigID()
  local stageName = GetTableData(TableName.SEASON_CAVE_EXPLORATION, configID, "game_level")
  self.ctrl.boot:Start(stageName, self.game_root.transform)
  return true
end

function UILWGGGoGameView:RefreshBullet(bulletCount, maxBulletCount)
end

function UILWGGGoGameView:RefreshUI()
  local tabData = LocalController:instance():getLine(TableName.Activity, EnumActivity.GGGo.ActId)
  self.text_title:SetLocalText(tabData.name)
end

return UILWGGGoGameView
