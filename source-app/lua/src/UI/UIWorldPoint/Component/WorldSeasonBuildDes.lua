local WorldSeasonBuildDes = BaseClass("WorldSeasonBuildDes", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "icon"
local player_des_path = "layout1/playerDes"
local player_name_path = "layout1/playerName"
local btn_user_path = "layout1/btnUser"
local slider_path = "Slider"
local season_build_value_path = "seasonBuildValue"
local xy_path = "xy"
local desc_root_path = "DescRoot"
local des_txt_path = "DescRoot/ScrollView/Viewport/Content/desTxt"

function WorldSeasonBuildDes:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.player_des = self:AddComponent(UIText, player_des_path)
  self.player_name = self:AddComponent(UIText, player_name_path)
  self.btn_user = self:AddComponent(UIButton, btn_user_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.collectNum_txt = self:AddComponent(UIText, season_build_value_path)
  self.xy = self:AddComponent(UIText, xy_path)
  self.desc_root = self:AddComponent(UIImage, desc_root_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.btn_user:SetOnClick(function()
    self:OnClickHead()
  end)
  self.player_des:SetText("")
end

function WorldSeasonBuildDes:OnDestroy()
  base.OnDestroy(self)
end

function WorldSeasonBuildDes:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetPlayerInfo)
end

function WorldSeasonBuildDes:OnDisable()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetPlayerInfo)
  base.OnDisable(self)
end

function WorldSeasonBuildDes:OnGetPlayerInfo()
  local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.view.ctrl.ownerUid, true)
  if info == nil then
    return
  end
  local name = info.name or ""
  if not string.IsNullOrEmpty(info.alAbbr) then
    name = string.format("[%s]%s", info.alAbbr, info.name or "")
  end
  local srcServer = info.serverId
  local otherServerPlayer = srcServer ~= nil and srcServer ~= 0 and srcServer ~= LuaEntry.Player:GetSourceServerId()
  if self.view.ctrl.ownerUid == LuaEntry.Player.uid then
    self.player_name:SetText("<color=#0e9500>" .. name .. "</color>")
  elseif self.view.ctrl.isAlliance then
    self.player_name:SetText("<color=#0091e8>" .. name .. "</color>")
  elseif otherServerPlayer then
    self.player_name:SetText("<color=#e64141>" .. name .. "</color>")
  else
    self.player_name:SetText("<color=#2A2830>" .. name .. "</color>")
  end
end

function WorldSeasonBuildDes:UpdateInfo(data)
  self.serverData = data
  if self.view.ctrl.type == WorldPointUIType.Build then
    local info = CS.SceneManager.World:GetPointInfoByUuid(self.view.ctrl.uuid)
    local buildId
    if info then
      cast(info, typeof(CS.BuildPointInfo))
      if info then
        buildId = info.itemId
        if info.destroyStartTime > 0 then
          self.isRuins = true
        end
        self.buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
        if self.buildTemplate and self.buildTemplate.des then
          self.des_txt:SetLocalText(self.buildTemplate.des)
        end
        local name = info.playerName or ""
        local pos = SceneUtils.IndexToTilePos(info.pointIndex, ForceChangeScene.World)
        self.xy:SetText(string.format("X:%s Y:%s", pos.x, pos.y))
        if string.IsNullOrEmpty(name) then
          local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.view.ctrl.ownerUid, true)
          if playerInfo == nil then
            SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, self.view.ctrl.ownerUid)
          else
            self:OnGetPlayerInfo()
          end
        else
          if not string.IsNullOrEmpty(info.alAbbr) then
            name = string.format("[%s]%s", info.alAbbr, info.playerName or "")
          end
          local srcServer = self.serverData.srcServer
          local otherServerPlayer = srcServer ~= nil and srcServer ~= 0 and srcServer ~= LuaEntry.Player:GetSourceServerId()
          if self.view.ctrl.ownerUid == LuaEntry.Player.uid then
            self.player_name:SetText("<color=#0e9500>" .. name .. "</color>")
          elseif self.view.ctrl.isAlliance then
            self.player_name:SetText("<color=#0091e8>" .. name .. "</color>")
          elseif otherServerPlayer then
            self.player_name:SetText("<color=#e64141>" .. name .. "</color>")
          else
            self.player_name:SetText("<color=#2A2830>" .. name .. "</color>")
          end
        end
      end
    end
    local name = Localization:GetString("140002", info.level) .. " " .. Localization:GetString(self.serverData.name)
    if buildId then
      self.icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(buildId, 1), DefaultImage)
    end
    self.name = name
    self:Update1000MS()
  end
end

function WorldSeasonBuildDes:RefreshData(param)
  self.isRuins = false
  self.isDetectCollect = false
  self.recoverSpeed = LuaEntry.DataConfig:TryGetNum("building_attack", "k2")
  self.data = param
  if self.view.info.isSeasonPlayerBuilding and self.view.info.recoverSpeed then
    self.recoverSpeed = self.view.info.recoverSpeed
  end
end

function WorldSeasonBuildDes:GetName()
  return self.name or self.serverData and self.serverData.name or ""
end

function WorldSeasonBuildDes:OnClickHead()
  if self.view.ctrl.ownerUid ~= nil and self.view.ctrl.ownerUid ~= "" then
    self.view.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.view.ctrl.ownerUid)
  end
end

function WorldSeasonBuildDes:Update1000MS()
  if self.serverData == nil or self.serverData.curHp == nil or self.serverData.maxHp == nil or self.serverData.maxHp == 0 then
    self.collectNum_txt:SetText("0/0")
    self.slider:SetValue(0)
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.view.ctrl == nil then
    return
  end
  if self.view.ctrl.type == WorldPointUIType.Build then
    local maxHp = string.GetFormattedSeparatorNum(math.floor(self.serverData.maxHp))
    if self.serverData.maxHp and self.serverData.curHp and self.serverData.curHp < self.serverData.maxHp then
      local deltaTime = curTime / 1000 - self.serverData.lastHpTime
      if self.serverData.maxHp > 0 then
        if self.isRuins == true then
          self.collectNum_txt:SetText("0/" .. string.GetFormattedSeparatorNum(math.floor(self.serverData.maxHp)))
          self.slider:SetValue(0)
        else
          local realBlood = math.min(deltaTime * self.recoverSpeed + self.serverData.curHp, self.serverData.maxHp)
          local percent = math.min(realBlood / self.serverData.maxHp, 1)
          self.collectNum_txt:SetText(string.GetFormattedSeparatorNum(math.floor(realBlood)) .. "/" .. maxHp)
          self.slider:SetValue(percent)
        end
      else
        self.collectNum_txt:SetText("0/0")
        self.slider:SetValue(0)
      end
    else
      self.collectNum_txt:SetText(maxHp .. "/" .. maxHp)
      self.slider:SetValue(1)
    end
  end
end

function WorldSeasonBuildDes:OnReturnClick()
  self.desc_root:SetActive(false)
end

function WorldSeasonBuildDes:OnInfoClick()
  if self.buildTemplate and self.buildTemplate.des then
    self.desc_root:SetActive(true)
  end
end

return WorldSeasonBuildDes
