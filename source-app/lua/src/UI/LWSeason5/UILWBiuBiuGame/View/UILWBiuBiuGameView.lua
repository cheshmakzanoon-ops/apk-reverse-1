local base = UIBaseView
local LWBiuBiuPveBoot = require("DataCenter.LWBiuBiu.LWBiuBiuPveBoot")
local UILWBiuBiuGameBulletItem = require("UI.LWSeason5.UILWBiuBiuGame.Component.UILWBiuBiuGameBulletItem")
local UILWBiuBiuGameView = BaseClass("UILWBiuBiuGameView", base)
local Localization = CS.GameEntry.Localization
local Client = CS.MiniGame.Biubiu.Client
local text_title_path = "TitleBar/TextTitle"
local content_path = "Bottom/Bullet/content"
local item_bullet_path = "Bottom/Bullet/content/item_bullet"
local game_root_path = "P0"
local btn_back_path = "Bottom/BtnBack"
local ValidationTime = 10

function UILWBiuBiuGameView:OnCreate()
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
end

function UILWBiuBiuGameView:OnDestroy()
  if Config.IsPC() then
    local bg = UIManager:GetInstance():GetLayer(UILayer.NormalBg.Name)
    if not IsNull(bg) then
      bg.transform.transform.localScale = Vector3.New(1, 1, 1)
    end
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBiuBiuGameView:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.item_bullet = self:AddComponent(UIImage, item_bullet_path)
  self.game_root = self:AddComponent(UIBaseContainer, game_root_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self, self.ClickCloseBtn))
  self.item_bullet.gameObject:GameObjectCreatePool()
  self.ctrl.boot = LWBiuBiuPveBoot.New()
  self.ctrl.boot:CreateHandle(self)
  self.ctrl.boot:BindCallback(BindCallback(self, self.EcsHandle))
  local configID = DataCenter.LWBiuBiuDataManager:GetCurrentLevelConfigID()
  local stageName = GetTableData(TableName.SEASON_BULLET_SHOOT_GAME, configID, "stage_name")
  self.ctrl.boot:Start(stageName, self.game_root.transform)
  self.updater = BindCallback(self, self.OnUpdate)
  UpdateManager:GetInstance():AddUpdate(self.updater)
end

function UILWBiuBiuGameView:ComponentDestroy()
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
  if self.updater then
    UpdateManager:GetInstance():RemoveUpdate(self.updater)
    self.updater = nil
  end
end

function UILWBiuBiuGameView:DataDefine()
  self.updateFinish = nil
  self.battleResult = nil
  self.waitTime = nil
  self.error = nil
  self.popWindow = nil
end

function UILWBiuBiuGameView:DataDestroy()
  self.updateFinish = nil
  self.battleResult = nil
  self.waitTime = nil
  self.error = nil
  self.popWindow = nil
  self.bulletViews = nil
end

function UILWBiuBiuGameView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonBiuBiuPveValidationEnd, self.SeasonBiuBiuPveValidationEndHandle)
  self:AddUIListener(EventId.SeasonBiuBiuPveStart, self.SeasonBiuBiuPveStartHandle)
end

function UILWBiuBiuGameView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonBiuBiuPveValidationEnd, self.SeasonBiuBiuPveValidationEndHandle)
  self:RemoveUIListener(EventId.SeasonBiuBiuPveStart, self.SeasonBiuBiuPveStartHandle)
  base.OnRemoveListener(self)
end

function UILWBiuBiuGameView:ClickCloseBtn()
  if self.ctrl.boot ~= nil then
    self.ctrl.boot:Dispose()
    self.ctrl.boot = nil
  end
  self.ctrl:CloseSelf()
end

function UILWBiuBiuGameView:SeasonBiuBiuPveValidationEndHandle(validation)
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
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuPveResult, {anim = true}, self.battleResult)
end

function UILWBiuBiuGameView:SeasonBiuBiuPveStartHandle()
  if self.ctrl.boot ~= nil then
    self.ctrl.boot.startSyncEnd = true
  end
end

function UILWBiuBiuGameView:InitFinish()
  return self.ctrl.boot ~= nil and self.ctrl.boot:IsDone()
end

function UILWBiuBiuGameView:EcsHandle(render)
  if render.Type == Client.UIRenderType.UIShowInfo then
    cast(render, typeof(Client.DataUIRenderMessage.UIShowInfo))
    self:RefreshBullet(render.GunBulletCount, render.GunBulletMax)
  end
  if render.Type == Client.UIRenderType.UIResult then
    cast(render, typeof(Client.DataUIRenderMessage.UIResult))
    self.battleResult = {
      validationStr = render.ValidationStr,
      fireCount = render.FireCount,
      level = DataCenter.LWBiuBiuDataManager:GetCurrentLevel(),
      battleTimeMills = render.BattleTimeMills,
      boot = self.ctrl.boot,
      stageCfgId = DataCenter.LWBiuBiuDataManager:GetStageCfgId()
    }
    if render.Win then
      local bid = DataCenter.LWBiuBiuDataManager:GetBid()
      local version = GetTableData(TableName.SEASON_BULLET_SHOOT_GAME, self.battleResult.stageCfgId, "version")
      SFSNetwork.SendMessage(MsgDefines.BiuBiuPVEGameEnd, bid, self.battleResult.validationStr, self.battleResult.fireCount[0], render.BattleTimeMills, "Release" .. tostring(version), self.battleResult.stageCfgId)
      self.waitTime = ValidationTime
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuPveFairResult, {anim = true}, self.battleResult)
      if not string.IsNullOrEmpty(self.battleResult.validationStr) then
        local FuncVersion = CS.MiniGame.Biubiu.Client.FuncVersion
        local codeMd5 = ""
        if FuncVersion then
          codeMd5 = FuncVersion.CSharpCodeMD5
        end
        Logger.Log("[LWBiuBiu] PVE BattleFair Replay is " .. self.battleResult.validationStr .. "version is Release" .. DataCenter.LWBiuBiuDataManager:GetVersion() .. "player uid is " .. LuaEntry.Player.uid .. "md5 is " .. codeMd5)
      end
    end
  end
end

function UILWBiuBiuGameView:OnUpdate()
  if self.waitTime ~= nil and self.waitTime > 0 then
    self.waitTime = self.waitTime - Time.deltaTime
    if self.waitTime < 0 then
      self.error = true
      self:PopTimeOut()
    end
  end
end

function UILWBiuBiuGameView:PopTimeOut()
  UIUtil.ShowSecondMessage("", Localization:GetString("season_s5_activity_1200045_desc34"), 2, "110006", "110106", function()
    self.ctrl:CloseSelf()
  end, nil, function()
  end, nil, nil, nil, nil, nil, nil, false, nil, nil)
  self.waitTime = nil
  self.popWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UISellConfirm)
end

function UILWBiuBiuGameView:PopValidation()
  UIUtil.ShowSecondMessage("", Localization:GetString("season_s5_activity_1200045_desc33"), 2, "110006", "110106", function()
    self.ctrl:CloseSelf()
  end, nil, function()
  end, nil, nil, nil, nil, nil, nil, false, nil, nil)
  self.popWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UISellConfirm)
end

function UILWBiuBiuGameView:Next()
  if self.ctrl.boot == nil then
    return false
  end
  self.ctrl.boot:Dispose()
  self.ctrl.boot:CreateHandle(self)
  SFSNetwork.SendMessage(MsgDefines.BiuBiuPVEGameStart, "Release" .. DataCenter.LWBiuBiuDataManager:GetVersion())
  self.ctrl.boot:BindCallback(BindCallback(self, self.EcsHandle))
  local configID = DataCenter.LWBiuBiuDataManager:GetCurrentLevelConfigID()
  local stageName = GetTableData(TableName.SEASON_BULLET_SHOOT_GAME, configID, "stage_name")
  self.ctrl.boot:Start(stageName, self.game_root.transform)
  return true
end

function UILWBiuBiuGameView:RefreshBullet(bulletCount, maxBulletCount)
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

function UILWBiuBiuGameView:RefreshUI()
  local tabData = LocalController:instance():getLine(TableName.Activity, EnumActivity.BiuBiu.ActId)
  self.text_title:SetLocalText(tabData.name)
end

return UILWBiuBiuGameView
