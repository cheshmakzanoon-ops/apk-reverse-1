local UIDesertMapTransportView = BaseClass("UIDesertMapTransportView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local bg_go_path = "PopUpTitle/Common_bg_orange2/GameObject/bg"
local btn_go_path = "PopUpTitle/Common_bg_orange2/GameObject/bg/BtnGo"
local btn_jump_path = "PopUpTitle/Common_bg_orange2/BtnJump"
local desc_path = "PopUpTitle/Common_bg_orange2/GameObject/desc"
local tips_path = "PopUpTitle/Common_bg_orange2/tips"
local tips_main_path = "PopUpTitle/Common_bg_orange2/GameObject/bg/mainTips"

function UIDesertMapTransportView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function UIDesertMapTransportView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertMapTransportView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DragonCityMoveCoolDown, self.OnDragonCityMoveCoolDown)
end

function UIDesertMapTransportView:OnRemoveListener()
  self:RemoveUIListener(EventId.DragonCityMoveCoolDown, self.OnDragonCityMoveCoolDown)
  base.OnRemoveListener(self)
end

function UIDesertMapTransportView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.bg_go = self:AddComponent(UIBaseContainer, bg_go_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_jump = self:AddComponent(UIButton, btn_jump_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.tips = self:AddComponent(UIText, tips_path)
  self.mainTips = self:AddComponent(UIText, tips_main_path)
  local buildTemplateId = 10030
  local mainTipsKey = 458042
  local tipsKey = 458044
  local descKey = 458043
  if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
    descKey = 458043
    self.bg_go:SetActive(true)
  elseif BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
    descKey = "winter_battlefield_tips1016"
    self.bg_go:SetActive(false)
  elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    descKey = "YiBianJinQu_errorcode_14"
    self.bg_go:SetActive(false)
  elseif BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
    descKey = "dsb_duel_tips_1027"
    mainTipsKey = "dsb_duel_tips_1026"
    self.bg_go:SetActive(true)
  end
  self.tips:SetLocalText(tipsKey)
  self.mainTips:SetLocalText(mainTipsKey)
  self.desc:SetLocalText(descKey)
  self.btn_go:SetOnClick(function()
    local mgr = BattleFieldUtil.GetTemplateMgrActive()
    local config = mgr and mgr:GetBuildTemplate(buildTemplateId)
    if config ~= nil then
      local worldPos = SceneUtils.TileIndexToWorld(config.mainIndex, ForceChangeScene.World)
      GoToUtil.GotoDragonPos(worldPos, CS.SceneManager.World.InitZoom, 0.02, function()
        CS.SceneManager.World:UpdateViewRequest(true)
      end, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId())
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertMapTransport)
    end
  end)
  self.btn_jump:SetOnClick(function()
    local pointId = SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget)
    if MoveCityUtil.OnClickMoveCity(LuaEntry.Player:GetCurServerId(), pointId) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertMapTransport)
    end
  end)
  self:OnDragonCityMoveCoolDown()
end

function UIDesertMapTransportView:ComponentDestroy()
  self.btn_back = nil
end

function UIDesertMapTransportView:OnDragonCityMoveCoolDown()
  local isFree = false
  local data = BattleFieldUtil.CoolData()
  self.coolTime = nil
  if not table.IsNullOrEmpty(data) then
    if data.costCount == 0 then
      isFree = true
    else
      self.coolTime = data.coolTime
    end
  end
  self.tips:SetActive(true)
  if isFree then
    self.tips:SetLocalText(458044)
  else
    self.tips:SetText("")
    self:Update1000MS()
  end
end

function UIDesertMapTransportView:Update1000MS()
  if self.coolTime ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.coolTime - curTime
    if 0 < remainTime then
      self.tips:SetText(Localization:GetString("458265") .. " " .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.tips:SetLocalText(458044)
      self.coolTime = nil
    end
  end
end

return UIDesertMapTransportView
