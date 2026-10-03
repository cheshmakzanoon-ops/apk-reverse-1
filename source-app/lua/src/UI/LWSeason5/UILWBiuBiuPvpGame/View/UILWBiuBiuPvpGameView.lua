local base = UIBaseView
local LWBiuBiuPvpBoot = require("DataCenter.LWBiuBiu.LWBiuBiuPvpBoot")
local UILWBiuBiuGameBulletItem = require("UI.LWSeason5.UILWBiuBiuGame.Component.UILWBiuBiuGameBulletItem")
local UILWBiuBiuPvpPlayerHudItem = require("UI.LWSeason5.UILWBiuBiuPvpGame.Component.UILWBiuBiuPvpPlayerHudItem")
local Localization = CS.GameEntry.Localization
local UILWBiuBiuPvpGameView = BaseClass("UILWBiuBiuPvpGameView", base)
local Client = CS.MiniGame.Biubiu.Client
local text_title_path = "TitleBar/TextTitle"
local content_path = "Bottom/Bullet/content"
local item_bullet_path = "Bottom/Bullet/content/item_bullet"
local game_root_path = "P0"
local btn_back_path = "Bottom/BtnBack"
local hud_root_path = "HudRoot"
local one_p_hud_path = "HudRoot/OnePHud"
local two_p_hud_path = "HudRoot/TwoPHud"
local double_mark_path = "Bottom/Bullet/DoubleMark"

function UILWBiuBiuPvpGameView:OnCreate()
  if Config.IsPC() then
    local bg = UIManager:GetInstance():GetLayer(UILayer.NormalBg.Name)
    if not IsNull(bg) then
      bg.transform.transform.localScale = Vector3.New(0, 0, 0)
    end
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatNew_v2)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshUI()
  self.createFinish = true
end

function UILWBiuBiuPvpGameView:OnDestroy()
  if Config.IsPC() then
    local bg = UIManager:GetInstance():GetLayer(UILayer.NormalBg.Name)
    if not IsNull(bg) then
      bg.transform.transform.localScale = Vector3.New(1, 1, 1)
    end
  end
  self.createFinish = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBiuBiuPvpGameView:OnEnable()
  base.OnEnable(self)
end

function UILWBiuBiuPvpGameView:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.item_bullet = self:AddComponent(UIImage, item_bullet_path)
  self.game_root = self:AddComponent(UIBaseContainer, game_root_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.hud_root = self:AddComponent(UIBaseContainer, hud_root_path)
  self.double_mark = self:AddComponent(UIImage, double_mark_path)
  self.hudViewItems = {
    [0] = self:AddComponent(UILWBiuBiuPvpPlayerHudItem, one_p_hud_path),
    [1] = self:AddComponent(UILWBiuBiuPvpPlayerHudItem, two_p_hud_path)
  }
  for index = 0, 1 do
    self.hudViewItems[index]:InitData(index, self.hud_root.transform)
  end
  self.btn_back:SetOnClick(BindCallback(self, self.ClickCloseBtn))
  self.item_bullet.gameObject:GameObjectCreatePool()
  self.ctrl.boot = LWBiuBiuPvpBoot.New()
  self.ctrl.boot:CreateHandle(self)
  self.ctrl.boot:BindCallback(BindCallback(self, self.EcsHandle))
end

function UILWBiuBiuPvpGameView:ComponentDestroy()
  if self.ctrl.boot ~= nil then
    self.ctrl.boot:Dispose()
    self.ctrl.boot = nil
  end
  self.item_bullet.gameObject:GameObjectRecycleAll()
  self.item_bullet = nil
  self.text_title = nil
  self.content = nil
  self.game_root = nil
  self.btn_back = nil
  self.double_mark = nil
  self.hud_root = nil
  self.hudViewItems = nil
end

function UILWBiuBiuPvpGameView:DataDefine()
end

function UILWBiuBiuPvpGameView:DataDestroy()
end

function UILWBiuBiuPvpGameView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonBiuBiuPvpValidationEnd, self.SeasonBiuBiuPvpValidationEndHandle)
end

function UILWBiuBiuPvpGameView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonBiuBiuPvpValidationEnd, self.SeasonBiuBiuPvpValidationEndHandle)
  base.OnRemoveListener(self)
end

function UILWBiuBiuPvpGameView:ClickCloseBtn()
  if self.ctrl.boot ~= nil then
    self.ctrl.boot:Dispose()
    self.ctrl.boot = nil
  end
  self.ctrl:CloseSelf()
end

function UILWBiuBiuPvpGameView:SeasonBiuBiuPvpValidationEndHandle()
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  local battleResult = room:GetBattleResult()
  if battleResult:GetResult() == 4 then
    if self.ctrl.boot ~= nil then
      self.ctrl.boot:Dispose()
      self.ctrl.boot = nil
    end
    self.ctrl:CloseSelf()
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc66")
    return
  end
  battleResult:BindBoot(self.ctrl.boot, 0)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuPvpResult, {anim = true}, battleResult)
end

function UILWBiuBiuPvpGameView:InitFinish()
  if self.ctrl.boot == nil then
    return false
  end
  local done = self.ctrl.boot:IsDone()
  return done
end

function UILWBiuBiuPvpGameView:CheckEnterFail()
  if self.ctrl.boot == nil then
    return true
  end
  return self.ctrl.boot:CheckEnterFail()
end

function UILWBiuBiuPvpGameView:EcsHandle(render)
  if render.Type == Client.UIRenderType.UIWait then
    cast(render, typeof(Client.DataUIRenderMessage.UIWait))
    UIUtil.ShowCountdownTimeUI(UITimeManager:GetInstance():GetServerTime() + 3000, Localization:GetString("season_s5_activity_1200045_desc45"))
  end
  if render.Type == Client.UIRenderType.UIShowInfo then
    cast(render, typeof(Client.DataUIRenderMessage.UIShowInfo))
    self:RefreshBullet(render.GunBulletCount, render.GunBulletMax)
    self:RefreshPlayerHudInfo(render)
  end
  if render.Type == Client.UIRenderType.UIPlayerBind then
    cast(render, typeof(Client.DataUIRenderMessage.UIPlayerBind))
    local index = render.Controller.PlayerID
    local hubView = self.hudViewItems[index]
    if hubView ~= nil then
      hubView:BindController(render)
    end
  end
  if render.Type == Client.UIRenderType.UIResult then
    cast(render, typeof(Client.DataUIRenderMessage.UIResult))
    local room = DataCenter.LWBiuBiuDataManager:GetRoom()
    local fireCountToLua = {}
    for i = 0, render.FireCount.Length - 1 do
      fireCountToLua[i + 1] = render.FireCount[i]
    end
    room:GameLiftResult({
      fireCount = fireCountToLua,
      battleTimeMills = render.BattleTimeMills,
      SelfPlayerID = render.SelfPlayerID + 1,
      HeadShot = render.HeadShot
    })
  end
  if render.Type == Client.UIRenderType.UINetWork then
    cast(render, typeof(Client.DataUIRenderMessage.UINetWork))
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

function UILWBiuBiuPvpGameView:RefreshPlayerHudInfo(render)
  for _, hudView in pairs(self.hudViewItems) do
    hudView:RefreshInfo(render)
  end
end

function UILWBiuBiuPvpGameView:RefreshBullet(bulletCount, maxBulletCount)
  self.double_mark:SetActive(10 < bulletCount)
  maxBulletCount = math.min(maxBulletCount, 10)
  if 10 < bulletCount then
    bulletCount = bulletCount - 10
  end
  if self.bulletViews == nil then
    self.bulletViews = {}
    for index = 1, maxBulletCount do
      local goItem = self.item_bullet.gameObject:GameObjectSpawn(self.content.transform)
      goItem.name = "item_bullet" .. index
      goItem:SetActive(true)
      local goItemScript = self.content:AddComponent(UILWBiuBiuGameBulletItem, goItem.name)
      goItemScript:InitData(index)
      table.insert(self.bulletViews, goItemScript)
    end
  end
  local scale = 1 - (maxBulletCount - 6) * 0.1
  self.content:SetLocalScaleXYZ(scale, scale, scale)
  if self.bulletViews ~= nil then
    for index = 1, #self.bulletViews do
      local view = self.bulletViews[index]
      view:RefreshUI(maxBulletCount - bulletCount)
    end
  end
end

function UILWBiuBiuPvpGameView:Agent()
  self.ctrl.boot:Dispose()
  self.ctrl.boot:BindCallback(BindCallback(self, self.EcsHandle))
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  local stageCfgId = room:GetStageCfgId()
  self.ctrl.boot:Start(stageCfgId, self.game_root.transform)
end

function UILWBiuBiuPvpGameView:EnterGame()
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  local stageCfgId = room:GetStageCfgId()
  self.ctrl.boot:Start(stageCfgId, self.game_root.transform)
end

function UILWBiuBiuPvpGameView:RefreshUI()
  local tabData = LocalController:instance():getLine(TableName.Activity, EnumActivity.BiuBiu.ActId)
  self.text_title:SetLocalText(tabData.name)
end

return UILWBiuBiuPvpGameView
