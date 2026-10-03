local base = UIBaseView
local LWGGGoPvpBoot = require("DataCenter.LWGGGo.LWGGGoPvpBoot")
local UILWGGGoPvpGameView = BaseClass("UILWGGGoPvpGameView", base)
local Client = CS.MiniGame.GGGo.Client
local Localization = CS.GameEntry.Localization
local text_title_path = "TitleBar/TextTitle"
local game_root_path = "P0"
local btn_back_path = "Bottom/BtnBack"
local u_i_player_head1_path = "Head1/UIPlayerHead1"
local u_i_player_head2_path = "Head2/UIPlayerHead2"
local loadingObj = "LoadingObj"

function UILWGGGoPvpGameView:OnCreate()
  if Config.IsPC() then
    local bg = UIManager:GetInstance():GetLayer(UILayer.NormalBg.Name)
    if not IsNull(bg) then
      bg.transform.transform.localScale = Vector3.New(0, 0, 0)
    end
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatNew_v2)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoRoom)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
  self.createFinish = true
  self:ConnectGameLift(self:GetUserData())
  DataCenter.LWGGGoDataManager:PlaySeasonActivityBGM()
  EventManager:GetInstance():Broadcast(EventId.SmallGameUIOpenClose, true)
end

function UILWGGGoPvpGameView:OnDestroy()
  EventManager:GetInstance():Broadcast(EventId.SmallGameUIOpenClose, false)
  if Config.IsPC() then
    local bg = UIManager:GetInstance():GetLayer(UILayer.NormalBg.Name)
    if not IsNull(bg) then
      bg.transform.transform.localScale = Vector3.New(1, 1, 1)
    end
  end
  DataCenter.LWGGGoDataManager:StopSeasonActivityBGM()
  self.createFinish = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWGGGoPvpGameView:OnEnable()
  base.OnEnable(self)
end

function UILWGGGoPvpGameView:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.game_root = self:AddComponent(UIBaseContainer, game_root_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.u_i_player_head1 = self:AddComponent(UICommonHead, u_i_player_head1_path)
  self.u_i_player_head2 = self:AddComponent(UICommonHead, u_i_player_head2_path)
  self.loading_obj = self:AddComponent(UIBaseContainer, loadingObj)
  self.loading_obj:SetActive(false)
  self.btn_back:SetOnClick(BindCallback(self, self.ClickCloseBtn))
  self.ctrl.boot = LWGGGoPvpBoot.New()
  self.ctrl.boot:CreateHandle(self)
  self.ctrl.boot:BindCallback(BindCallback(self, self.EcsHandle))
end

function UILWGGGoPvpGameView:ComponentDestroy()
  if self.ctrl.boot ~= nil then
    self.ctrl.boot:Dispose()
    self.ctrl.boot = nil
  end
  self.text_title = nil
  self.game_root = nil
  self.btn_back = nil
  self.u_i_player_head1 = nil
  self.u_i_player_head2 = nil
  self.loading_obj = nil
end

function UILWGGGoPvpGameView:DataDefine()
  self.isReconnecting = false
  self.isSettled = false
  self.loadingDelayTimer = nil
end

function UILWGGGoPvpGameView:DataDestroy()
  self:CancelLoadingDelay()
  self.isReconnecting = false
  self.isSettled = false
end

function UILWGGGoPvpGameView:CancelLoadingDelay()
  if self.loadingDelayTimer ~= nil then
    self.loadingDelayTimer:Stop()
    self.loadingDelayTimer = nil
  end
end

function UILWGGGoPvpGameView:HideLoading()
  self:CancelLoadingDelay()
  if self.loading_obj then
    self.loading_obj:SetActive(false)
  end
end

function UILWGGGoPvpGameView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonGGGoPvpValidationEnd, self.SeasonGGGoPvpValidationEndHandle)
  self:AddUIListener(EventId.SeasonGGGoPvpTryReconnect, self.OnServerTryReconnect)
  self:AddUIListener(EventId.SeasonGGGoPvpReconnected, self.OnServerReconnected)
  self:AddUIListener(EventId.SeasonGGGoPvpDisconnected, self.OnServerDisconnected)
end

function UILWGGGoPvpGameView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonGGGoPvpValidationEnd, self.SeasonGGGoPvpValidationEndHandle)
  self:RemoveUIListener(EventId.SeasonGGGoPvpTryReconnect, self.OnServerTryReconnect)
  self:RemoveUIListener(EventId.SeasonGGGoPvpReconnected, self.OnServerReconnected)
  self:RemoveUIListener(EventId.SeasonGGGoPvpDisconnected, self.OnServerDisconnected)
  base.OnRemoveListener(self)
end

function UILWGGGoPvpGameView:ClickCloseBtn(callback)
  callback = callback or function()
    if self.ctrl.boot ~= nil then
      self.ctrl.boot:Dispose()
      self.ctrl.boot = nil
    end
    self.ctrl:CloseSelf()
  end
  UIUtil.ShowConfirmNew({
    contentText = CS.GameEntry.Localization:GetString("season_s6_exit_confirmation_limit"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {action = callback}
  })
end

function UILWGGGoPvpGameView:SeasonGGGoPvpValidationEndHandle()
  self.isSettled = true
  self:HideLoading()
  local room = DataCenter.LWGGGoDataManager:GetRoom()
  local battleResult = room:GetBattleResult()
  if battleResult:GetResult() == 4 then
    if self.ctrl.boot ~= nil then
      self.ctrl.boot:Dispose()
      self.ctrl.boot = nil
    end
    self.ctrl:CloseSelf()
    UIUtil.ShowTipsId("season_s6_activity_minigame_erro_tips")
    return
  end
  battleResult:BindBoot(self.ctrl.boot, 0)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGGGoPvpResult, {anim = true}, battleResult)
end

function UILWGGGoPvpGameView:InitFinish()
  if self.ctrl.boot == nil then
    return false
  end
  local done = self.ctrl.boot:IsDone()
  return done
end

function UILWGGGoPvpGameView:CheckEnterFail()
  if self.ctrl.boot == nil then
    return true
  end
  return self.ctrl.boot:CheckEnterFail()
end

function UILWGGGoPvpGameView:EcsHandle(render)
  if render.Type == Client.UIRenderType.UIWait then
    cast(render, typeof(Client.DataUIRender.UIWait))
    local _fdr = DataCenter.LWGGGoDataManager:GetRoom():GetBattleFightDescribeResult()
    local reconnecting = _fdr ~= nil and _fdr.reconnect == true
    if not reconnecting then
      UIUtil.ShowCountdownTimeUI(UITimeManager:GetInstance():GetServerTime() + render.WaitTime * 1000, Localization:GetString("season_s6_minigame_pvp_limit6"))
      DataCenter.LWSoundManager:PlaySound(6100026, false)
    end
    local room = DataCenter.LWGGGoDataManager:GetRoom()
    local selfParams = room:GetSelfHeadParams()
    local otherParams = room:GetOpponentHeadParams()
    if selfParams and self.u_i_player_head1 then
      self.u_i_player_head1:SetHead(selfParams.uid, selfParams.pic, selfParams.picVer, nil, selfParams.headFrame)
    end
    if otherParams and self.u_i_player_head2 then
      self.u_i_player_head2:SetHead(otherParams.uid, otherParams.pic, otherParams.picVer, nil, otherParams.headFrame)
    end
    return
  end
  if render.Type == Client.UIRenderType.UIRefresh then
    cast(render, typeof(Client.DataUIRender.UIRefresh))
    if render.IsStart then
      self:SetLocalScaleXYZ(1, 1, 1)
    end
  end
  if render.Type == Client.UIRenderType.UIResult then
    cast(render, typeof(Client.DataUIRender.UIResult))
    local room = DataCenter.LWGGGoDataManager:GetRoom()
    room:GameLiftResult({
      battleTimeMills = render.battleTimeMills,
      SelfPlayerID = render.SelfPlayerID + 1
    })
  end
  if render.Type == Client.UIRenderType.UINetWork then
    cast(render, typeof(Client.DataUIRender.UINetWork))
    if not render.SuccOrFair then
      UIUtil.ShowTipsId("season_s5_activity_1200045_desc34")
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end
  end
end

function UILWGGGoPvpGameView:RefreshPlayerHudInfo(render)
end

function UILWGGGoPvpGameView:OnServerTryReconnect()
  Logger.LogInfo("[GGGo] UILWGGGoPvpGameView:OnServerTryReconnect")
  if self.isSettled or self.isReconnecting then
    return
  end
  self.isReconnecting = true
  self:CancelLoadingDelay()
  self.loadingDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.loadingDelayTimer = nil
    if self.isReconnecting and not self.isSettled and self.loading_obj then
      self.loading_obj:SetActive(true)
    end
  end, 1.0)
end

function UILWGGGoPvpGameView:OnServerReconnected()
  Logger.LogInfo("[GGGo] UILWGGGoPvpGameView:OnServerReconnected")
  if self.isSettled then
    return
  end
  self.isReconnecting = false
  self:HideLoading()
end

function UILWGGGoPvpGameView:OnServerDisconnected()
  Logger.LogInfo("[GGGo] UILWGGGoPvpGameView:OnServerDisconnected")
  if self.isSettled then
    return
  end
  self.isReconnecting = false
  self:HandleReconnectFailed()
end

function UILWGGGoPvpGameView:HandleReconnectFailed()
  self:HideLoading()
  if self.ctrl.boot ~= nil then
    self.ctrl.boot:Dispose()
    self.ctrl.boot = nil
  end
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
  UIUtil.ShowSecondMessage("", Localization:GetString("season_s5_activity_1200045_desc34"), 1, "110006", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, false, nil, nil)
end

function UILWGGGoPvpGameView:Agent()
  self.ctrl.boot:Dispose()
  self.ctrl.boot:BindCallback(BindCallback(self, self.EcsHandle))
  local room = DataCenter.LWGGGoDataManager:GetRoom()
  local stageCfgId = room:GetStageCfgId()
  self.ctrl.boot:Start(stageCfgId, self.game_root.transform)
end

function UILWGGGoPvpGameView:EnterGame()
end

function UILWGGGoPvpGameView:RefreshUI()
  local tabData = LocalController:instance():getLine(TableName.Activity, EnumActivity.GGGo.ActId)
  self.text_title:SetLocalText(tabData.name)
end

function UILWGGGoPvpGameView:ConnectGameLift(ConnectFair, ConnectFinish)
  if not ConnectFair or not ConnectFinish then
    return
  end
  if self.ctrl and self.ctrl.boot then
    self:SetLocalScaleXYZ(0, 0, 0)
    self.ctrl.boot:ConnectGameLift(ConnectFair, ConnectFinish)
  else
    UIUtil.ShowTipsId("season_s6_activity_minigame_erro_tips")
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
  end
end

return UILWGGGoPvpGameView
