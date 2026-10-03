local SeasonDeclareInfo = BaseClass("SeasonDeclareInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_path = "Title"
local time_path = "Time"
local city_icon_path = "city/bg/CityIcon"
local pos_path = "city/pos"
local power_path = "city/power"
local flag_icon1_path = "Attack/vs/icon/UserSelf/flagIcon1"
local server1_path = "Attack/vs/icon/UserSelf/bg/server1"
local name1_path = "Attack/vs/icon/UserSelf/name1"
local flag_icon2_path = "Attack/vs/icon/UserOther/flagIcon2"
local server2_path = "Attack/vs/icon/UserOther/bg/server2"
local name2_path = "Attack/vs/icon/UserOther/name2"
local rank1_path = "Attack/vs/rank/rank1"
local rank2_path = "Attack/vs/rank/rank2"
local power1_path = "Attack/vs/power/power1"
local power2_path = "Attack/vs/power/power2"
local empty_path = "Attack/vs/icon/UserOther/empty"
local status_path = "city/bg/Status"
local status_text_path = "city/bg/Status/StatusText"
local bg_path = "city/bg"

function SeasonDeclareInfo:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UIText, title_path)
  self.remain_time = self:AddComponent(UIText, time_path)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(BindCallback(self, self.JumpTo))
  self.city_icon = self:AddComponent(UIImage, city_icon_path)
  self.pos = self:AddComponent(UIText, pos_path)
  self.power = self:AddComponent(UIText, power_path)
  self.flag_icon1 = self:AddComponent(UIButton, flag_icon1_path)
  self.server1 = self:AddComponent(UIText, server1_path)
  self.name1 = self:AddComponent(UIText, name1_path)
  self.flag_icon2 = self:AddComponent(UIButton, flag_icon2_path)
  self.server2 = self:AddComponent(UIText, server2_path)
  self.name2 = self:AddComponent(UIText, name2_path)
  self.empty = self:AddComponent(UIText, empty_path)
  self.rank1 = self:AddComponent(UIText, rank1_path)
  self.rank2 = self:AddComponent(UIText, rank2_path)
  self.power1 = self:AddComponent(UIText, power1_path)
  self.power2 = self:AddComponent(UIText, power2_path)
  self.status = self:AddComponent(UIImage, status_path)
  self.status_text = self:AddComponent(UIText, status_text_path)
  self.status:SetActive(false)
  self.flag_icon1:SetOnClick(function()
    self:OnAllianceDetailClick(self.myData)
  end)
  self.flag_icon2:SetOnClick(function()
    self:OnAllianceDetailClick(self.enemyData)
  end)
end

function SeasonDeclareInfo:OnDestroy()
  self.cityInfo = nil
  base.OnDestroy(self)
end

function SeasonDeclareInfo:ReInit(declareData)
  local cityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(declareData.cityId)
  self.cityId = declareData.cityId
  self.serverId = declareData.serverId
  self.pointId = cityInfo:GetPointId()
  self.cityInfo = cityInfo
  self.declareData = declareData
  local myData, enemyData
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  if myAllianceId == declareData.atk.id then
    myData = declareData.atk
    enemyData = declareData.def
    if declareData.result == 1 then
      self.status:SetActive(true)
      self.status:SetColorRGBA255(17, 190, 78)
      self.status_text:SetLocalText("season_sever_declare_war_016")
    elseif declareData.result == 2 then
      self.status:SetActive(true)
      self.status:SetColorRGBA255(190, 24, 17)
      self.status_text:SetLocalText("311108")
    end
  else
    myData = declareData.def
    enemyData = declareData.atk
    if declareData.result == 2 then
      self.status:SetActive(true)
      self.status:SetColorRGBA255(17, 190, 78)
      self.status_text:SetLocalText("311109")
    elseif declareData.result == 1 then
      self.status:SetActive(true)
      self.status:SetColorRGBA255(190, 24, 17)
      self.status_text:SetLocalText("season_sever_declare_war_017")
    end
  end
  self.myData = myData
  self.enemyData = enemyData
  self.title:SetText(Localization:GetString("310128", cityInfo.level, cityInfo:GetName()))
  self.endTime = declareData.endTime
  self.city_icon:LoadSprite(cityInfo:GetIconPath(false))
  self.pos:SetText(string.format("#%s (X:%s Y:%s)", declareData.serverId, cityInfo.pos.x, cityInfo.pos.y))
  if cityInfo.force and cityInfo.force > 0 then
    self.power:SetText(Localization:GetString("season_sever_intrusion_008") .. string.GetFormattedSeperatorNum(cityInfo.force))
  else
    self.power:SetText("")
  end
  self.flag_icon1:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(myData.icon)))
  self.server1:SetText("#" .. myData.serverId)
  self.name1:SetText(string.format("[%s]%s", myData.abbr, myData.name))
  if myData.forceRank and 0 < myData.forceRank then
    self.rank1:SetText(myData.forceRank)
  else
    self.rank1:SetText(CS.GameEntry.Localization:GetString("361054"))
  end
  self.power1:SetText(string.GetFormattedSeparatorNum(myData.power or 0))
  if enemyData == nil or string.IsNullOrEmpty(enemyData.abbr) then
    self.flag_icon2:SetActive(false)
    self.empty:SetActive(true)
    self.server2:SetText("")
    self.name2:SetText("")
    self.rank2:SetText("-")
    self.power2:SetText("-")
  else
    self.flag_icon2:SetActive(true)
    self.empty:SetActive(false)
    self.flag_icon2:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(enemyData.icon)))
    self.server2:SetText("#" .. enemyData.serverId)
    self.name2:SetText(string.format("[%s]%s", enemyData.abbr, enemyData.name))
    if enemyData.forceRank and 0 < enemyData.forceRank then
      self.rank2:SetText(enemyData.forceRank)
    else
      self.rank2:SetText(CS.GameEntry.Localization:GetString("361054"))
    end
    self.power2:SetText(string.GetFormattedSeparatorNum(enemyData.power or 0))
  end
end

function SeasonDeclareInfo:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.endTime then
    local deltaTime = self.endTime - curTime
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.remain_time:SetText(showTime)
    else
      self.remain_time:SetText("")
    end
  end
end

function SeasonDeclareInfo:JumpTo()
  if self.declareData then
    GoToUtil.CloseAllWindows()
    if self.serverId == LuaEntry.Player:GetSelfServerId() then
      local worldPos = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
      GoToUtil.GotoWorldPos(worldPos, nil, nil, nil, self.serverId)
      return
    end
    math.randomseed(SafeLocalOsTime())
    local tilePos = SceneUtils.IndexToTilePos(self.pointId, ForceChangeScene.World)
    local x = math.random(tilePos.x - 7, tilePos.x + 7)
    local y = math.random(tilePos.y - 7, tilePos.y + 7)
    local pointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.World)
    CrossServerUtil.JumpToServerByServerId(self.serverId, MoveCrossServerType.SeasonBattleDesert, pointId, SeasonCrossCameraHeight)
  end
end

function SeasonDeclareInfo:RemoveRedPoint()
  local v = self.declareData
  if v and v.serverId and v.cityId and v.startTime then
    local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
    local identify = string.format("DeclareWar_%s_%s_%s", v.serverId, v.cityId, v.startTime)
    UIUtil.GetActiveCount(theSeasonStartTime, identify, true)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonCrossDeclareWarRedPointUpdate)
  end
end

function SeasonDeclareInfo:OnAllianceDetailClick(data)
  if data ~= nil and data.id and data.serverId and not string.IsNullOrEmpty(data.abbr) then
    local serverId = data.serverId
    local allianceId = data.id
    local allianceName = data.name
    UIUtil.TryShowAllianceInfo(serverId, allianceId, allianceName)
  end
end

return SeasonDeclareInfo
