local BattleFieldMainSignItem = BaseClass("BattleFieldMainSignItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "root/Icon"
local title_path = "root/TitleText"
local btn_path = "root/Button"
local desc_path = "root/DescText"

function BattleFieldMainSignItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
end

function BattleFieldMainSignItem:OnDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  base.OnDestroy(self)
end

function BattleFieldMainSignItem:OnBtnClick()
  local sId = LuaEntry.Player:GetCrossServerId()
  local wId = LuaEntry.Player:GetCurWorldId()
  local wType = LuaEntry.Player:GetCurWorldType()
  GoToUtil.GotoDragonPos(SceneUtils.TileIndexToWorld(self.pid, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, sId, wId, wType)
end

function BattleFieldMainSignItem:ReInit(orderData)
  local cfg = orderData.cfg
  self.showTime = cfg.request_duration
  self.icon:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldCommanderPath, cfg.icon))
  self.title:SetText(string.format("<u>%s</u>", Localization:GetString(cfg.name)))
  self.pid = orderData.pid
  if not string.IsNullOrEmpty(cfg.request_text) then
    self.desc:SetLocalText(cfg.request_text)
    self.desc:SetColor(Color.white)
  else
    local theWorld = CS.SceneManager.World
    local pInfo = theWorld ~= nil and theWorld:GetPointInfo(self.pid) or nil
    local showStr, color = nil, Color.white
    if pInfo ~= nil then
      if pInfo.PointType == WorldPointType.WINTER_ENTITY or pInfo.PointType == WorldPointType.EPIDEMIC_BUILD then
        local buildInfo = pInfo.detail
        if buildInfo ~= nil then
          local buildCfg = BattleFieldUtil.GetBattlefieldBuildTemplate(buildInfo.BuildId)
          local buildName = buildCfg ~= nil and buildCfg.name
          if not string.IsNullOrEmpty(buildName) then
            showStr = Localization:GetString(buildName)
            color = Color.white
          end
        end
      elseif pInfo.PointType == WorldPointType.PlayerBuilding then
        cast(pInfo, typeof(CS.BuildPointInfo))
        if pInfo ~= nil then
          local bEnemy = false
          if BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
            local ActMgr = DataCenter.ActEpidemicZoneManager
            local battleInfo = ActMgr:GetBattleInfo()
            local _, aInfo = battleInfo:GetAlMemberByPlayerUid(pInfo.ownerUid)
            showStr = aInfo ~= nil and aInfo.name or ""
            bEnemy = ActMgr:GetWorldCampInEpidemic(pInfo.allianceId) == WorldCamp.Enemy
          elseif BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
            local ActMgr = DataCenter.ActWinterStormManager
            local mySide = ActMgr:GetMySide()
            local teamArr = ActMgr:GetTeamArr(pInfo.ownerUid)
            if teamArr ~= nil and mySide ~= teamArr.side then
              bEnemy = true
              showStr = teamArr.name
            end
          end
          local colorType = bEnemy and CityLabelColorType.Red or CityLabelColorType.Blue
          color = CityLabelColors[colorType] or CityLabelWhiteColor
        end
      end
    end
    if string.IsNullOrEmpty(showStr) then
      local v2 = SceneUtils.IndexToTilePos(self.pid, ForceChangeScene.World)
      showStr = Localization:GetString(300015, v2.x, v2.y)
      color = Color.white
    end
    self.desc:SetText(showStr)
    if color then
      self.desc:SetColor(color)
    end
  end
end

function BattleFieldMainSignItem:PlayAnim(cb)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  local halfTime = 0
  local showTime = math.max(self.showTime or 0, halfTime)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.timer then
      self.timer:Stop()
      self.timer = nil
    end
    if cb then
      cb()
    end
  end, showTime)
end

return BattleFieldMainSignItem
