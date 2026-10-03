local SeasonCrossServerAttackCityItem = BaseClass("SeasonCrossServerAttackCityItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local lock_path = "lock"
local lock_tip_path = "lock/lock_tip"
local info_path = "info"
local player_path = "info/player"
local abbr_path = "info/abbr"
local name_path = "info/name"
local btn_go_to_path = "info/BtnGoTo"
local btn_goto_text_path = "info/BtnGoTo/BtnGotoText"
local red_point_path = "info/BtnGoTo/RedPoint"
local pos_path = "info/BtnGoTo/pos"
local server_path = "info/ServerInfo/server"
local server_value_path = "info/ServerInfo/serverValue"
local icon_path = "info/icon"
local house_path = "info/House"
local home_icon_path = "info/House/homeIcon"
local tip_no_king_path = "info/tipNoKing"
local empty_path = "empty"
local btn_build_path = "empty/BtnBuild"
local btn_build_text_path = "empty/BtnBuild/BtnBuildText"
local tip1_path = "empty/tip1"
local tip2_path = "empty/tip2"

function SeasonCrossServerAttackCityItem:OnCreate()
  base.OnCreate(self)
  self.lockRoot = self:AddComponent(UIImage, lock_path)
  self.lock_tip = self:AddComponent(UIText, lock_tip_path)
  self.infoRoot = self:AddComponent(UIBaseContainer, info_path)
  self.playerUI = self:AddComponent(UICommonHead, player_path)
  self.abbr = self:AddComponent(UIText, abbr_path)
  self.name = self:AddComponent(UIText, name_path)
  self.btn_go_to = self:AddComponent(UIButton, btn_go_to_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.btn_goto_text = self:AddComponent(UIText, btn_goto_text_path)
  self.btn_goto_text:SetLocalText("110003")
  self.pos = self:AddComponent(UIText, pos_path)
  self.server = self:AddComponent(UIText, server_path)
  self.server_value = self:AddComponent(UIText, server_value_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.house = self:AddComponent(UIImage, house_path)
  self.home_icon = self:AddComponent(UIButton, home_icon_path)
  self.tip_no_king = self:AddComponent(UIText, tip_no_king_path)
  self.btn_go_to:SetOnClick(function()
    self:OnGotoClick()
  end)
  self.home_icon:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.data.serverId)
  end)
  self.playerUI:SetEnableClickShowInfo(true, true)
  self.emptyRoot = self:AddComponent(UIBaseContainer, empty_path)
  self.btn_build = self:AddComponent(UIButton, btn_build_path)
  self.btn_build_text = self:AddComponent(UIText, btn_build_text_path)
  self.btn_build_text:SetLocalText("110108")
  self.tip1 = self:AddComponent(UIText, tip1_path)
  self.tip2 = self:AddComponent(UIText, tip2_path)
  self.btn_build:SetOnClick(function()
    self:OnBuildClick()
  end)
  self.red_point:SetActive(false)
  self:OnAllianceDataUpdated()
end

function SeasonCrossServerAttackCityItem:OnDestroy()
  base.OnDestroy(self)
end

function SeasonCrossServerAttackCityItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceDataUpdated)
end

function SeasonCrossServerAttackCityItem:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.OnAllianceDataUpdated)
  base.OnRemoveListener(self)
end

function SeasonCrossServerAttackCityItem:OnAllianceDataUpdated()
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  CS.UIGray.SetGray(self.btn_build.transform, not hasAlliance, hasAlliance)
end

function SeasonCrossServerAttackCityItem:ChangeToBattleStatus()
  local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(self.data.serverId)
  local cfgId = kingInfo and kingInfo.badges.cfgId or 511001
  local king = kingInfo and kingInfo.king or nil
  if king == nil then
    self.tip_no_king:SetActive(true)
    self.playerUI:SetActive(false)
    self.abbr:SetActive(false)
    self.name:SetActive(false)
  else
    self.tip_no_king:SetActive(false)
    self.playerUI:SetActive(true)
    self.playerUI:ParseHeadInfo(king)
    self.abbr:SetActive(true)
    self.name:SetActive(true)
    self.abbr:SetText(king.allianceAbbr or "")
    self.name:SetText(king.name or "")
  end
  local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
  local tilePos = SceneUtils.IndexToTilePos(self.data.pointId, ForceChangeScene.World)
  local count = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonCrossAttackDesert" .. self.data.buildingId, false)
  self.btn_goto_text:SetLocalText("110003")
  self.red_point:SetActive(count == 0)
  self.pos:SetText(string.format("X:%s Y:%s", tilePos.x, tilePos.y))
  self.server:SetLocalText("800941")
  self.server_value:SetText(tostring(self.data.serverId))
  local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(cfgId)
  if itemCfg ~= nil then
    self.icon:SetActive(false)
    self.house:SetActive(true)
    self.home_icon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
  else
    self.icon:SetActive(true)
    self.house:SetActive(false)
  end
end

function SeasonCrossServerAttackCityItem:ReInit(index, data, fightStartTime, fightEndTime)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.data = data
  self.openTime = nil
  self.fightStartTime = fightStartTime
  self.fightEndTime = fightEndTime
  if curTime < data.openTime then
    self.lockRoot:SetActive(true)
    self.emptyRoot:SetActive(false)
    self.infoRoot:SetActive(false)
    self.openTime = data.openTime
    self:Update1000MS()
  elseif data.hasCreate == 0 then
    self.lockRoot:SetActive(false)
    self.emptyRoot:SetActive(true)
    self.infoRoot:SetActive(false)
    self:ChangeToOpenStatus()
  else
    self.lockRoot:SetActive(false)
    self.emptyRoot:SetActive(false)
    self.infoRoot:SetActive(true)
    self:ChangeToBattleStatus()
  end
  self:OnAllianceDataUpdated()
end

function SeasonCrossServerAttackCityItem:ChangeToOpenStatus()
  self.openTime = nil
  self.lockRoot:SetActive(false)
  self.emptyRoot:SetActive(true)
  self.infoRoot:SetActive(false)
  self.tip1:SetText("")
  if SeasonUtil.GetSeasonType() == SeasonMapType.CityStronghold then
    local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.data.buildingId)
    if meta ~= nil and not string.IsNullOrEmpty(meta.sever_intrusion_guide) then
      self.tip2:SetLocalText(meta.sever_intrusion_guide, meta.level)
    else
      self.tip2:SetLocalText("season_sever_intrusion_005")
    end
  else
    self.tip2:SetLocalText("season_sever_intrusion_005")
  end
end

function SeasonCrossServerAttackCityItem:Update1000MS()
  if self.openTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.openTime - curTime
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.data.buildingId)
      if meta ~= nil then
        local city_level = toInt(meta.level)
        if 0 < city_level then
          local str1 = Localization:GetString("season_activity1000017_desc005", city_level)
          local str2 = Localization:GetString("season_sever_intrusion_021", showTime)
          self.lock_tip:SetText(str1 .. "\n" .. str2)
          return
        end
      end
      self.lock_tip:SetLocalText("season_sever_intrusion_021", showTime)
    else
      self.openTime = nil
      self.lock_tip:SetText("")
      self:ChangeToOpenStatus()
    end
  end
end

function SeasonCrossServerAttackCityItem:OnGotoClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.red_point:SetActive(false)
  if self.data.buildingId then
    local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
    UIUtil.GetActiveCount(theSeasonStartTime, "SeasonCrossAttackDesert" .. self.data.buildingId, true)
  end
  if self.fightEndTime and curTime >= self.fightEndTime then
    UIUtil.ShowTipsId("458272")
    return
  end
  if self.data then
    if LuaEntry.Player:GetSelfServerId() == self.data.serverId then
      GoToUtil.CloseAllWindows()
      GoToUtil.MoveToWorldPointAndOpen(self.data.pointId, nil, nil, self.data.curServerId, 0)
    else
      math.randomseed(SafeLocalOsTime())
      local tilePos = SceneUtils.IndexToTilePos(self.data.pointId, ForceChangeScene.World)
      local x = math.random(tilePos.x - 7, tilePos.x + 7)
      local y = math.random(tilePos.y - 7, tilePos.y + 7)
      if x >= WorldTileCount or y >= WorldTileCount or x <= 0 or y <= 0 then
        CrossServerUtil.JumpToServerByServerId(self.data.serverId, MoveCrossServerType.SeasonBattleDesert, self.data.pointId, SeasonCrossCameraHeight)
      else
        local pointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.World)
        CrossServerUtil.JumpToServerByServerId(self.data.serverId, MoveCrossServerType.SeasonBattleDesert, pointId, SeasonCrossCameraHeight)
      end
    end
  end
end

function SeasonCrossServerAttackCityItem:OnBuildClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.fightEndTime and curTime >= self.fightEndTime then
    UIUtil.ShowTipsId("458272")
    return
  end
  if self.data then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonServerGroup, {anim = true}, JumpServerMode.PutAllianceBuild, self.data)
  end
end

return SeasonCrossServerAttackCityItem
