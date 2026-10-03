local UILWAlDeclareWarNode = BaseClass("UILWAlDeclareWarNode", UIAsyncProxy)
local base = UIAsyncProxy
local LuaPath = "UI.LWMainUI.Component.UIMainBottom.UILWAlDeclareWarTip"
local PrefabPath = "Assets/Main/Prefabs/UI/Alliance/Component/UILWAlDeclareWarTip.prefab"
local Localization = CS.GameEntry.Localization

function UILWAlDeclareWarNode:OnCreate()
  base.OnCreate(self)
  self.clicked = {}
end

function UILWAlDeclareWarNode:OnDestroy()
  self.hide = nil
  base.OnDestroy(self)
end

function UILWAlDeclareWarNode:OnEnable()
  base.OnEnable(self)
  self:OnRefreshShow()
end

function UILWAlDeclareWarNode:OnDisable()
  base.OnDisable(self)
end

function UILWAlDeclareWarNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DeclareWar_InfoChanged, self.OnRefreshShow)
  self:AddUIListener(EventId.AllianceQuitOK, self.OnHideTip)
  self:AddUIListener(EventId.DeclareWar, self.OnRefreshShow)
end

function UILWAlDeclareWarNode:OnRemoveListener()
  self:RemoveUIListener(EventId.DeclareWar_InfoChanged, self.OnRefreshShow)
  self:RemoveUIListener(EventId.AllianceQuitOK, self.OnHideTip)
  self:RemoveUIListener(EventId.DeclareWar, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function UILWAlDeclareWarNode:OnHideTip()
  self:TrySetShow(false)
end

function UILWAlDeclareWarNode:IsAlreadyTip(serverId, cityId, mark)
  local key = string.format("%s_%s", serverId, cityId)
  if self.clicked[key] then
    return true
  end
  if mark then
    self.clicked[key] = true
  end
  return false
end

function UILWAlDeclareWarNode:OnRefreshShow()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
  if data and not self:IsAlreadyTip(data.serverId or loginServerId, data.content, false) and DataCenter.AllianceDeclareWarManager:IsDeclareWarStart() then
    self.dataWar = data
    self:TrySetShow(true)
    return
  end
  local dataList = DataCenter.AllianceDeclareWarManager:GetSelfBeDeclareWarData()
  if dataList then
    for k, v in pairs(dataList) do
      if v and not self:IsAlreadyTip(v.serverId, v.content, false) then
        self.dataWar = v
        self:TrySetShow(true)
        return
      end
    end
  end
  self.dataWar = nil
  self:TrySetShow(false)
end

function UILWAlDeclareWarNode:OnClick()
  self:OnHideTip()
  if self.dataWar and self.dataWar.content then
    local alId = LuaEntry.Player:GetAllianceUid()
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local cityId = toInt(self.dataWar.content)
    local serverId = toInt(self.dataWar.serverId or loginServerId)
    self:IsAlreadyTip(serverId, cityId, true)
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
    if meta then
      if self.dataWar.aId == alId then
        UIUtil.ShowTips(Localization:GetString("season_tips156", Localization:GetString(meta.name)))
      elseif self.dataWar.alAbbr and self.dataWar.alName then
        local enemyName = UIUtil.FormatAllianceAndName(self.dataWar.alAbbr, self.dataWar.alName)
        UIUtil.ShowTips(Localization:GetString("alliance_faction_war_city_warning", meta.level, Localization:GetString(meta.name), enemyName))
      end
      local v2 = meta.pos
      local worldPos = SceneUtils.TileToWorld(v2)
      GoToUtil.GotoWorldPos(worldPos, nil, nil, function()
      end, serverId, 0)
      return
    end
  end
  local data = DataCenter.SeasonDataManager.CrossDeclareWarInfo
  if data ~= nil and data.isDeclareWarDay and data.declareList then
    local myAllianceId = LuaEntry.Player:GetAllianceUid()
    for k, v in ipairs(data.declareList) do
      if v and v.atk and v.def and v.cityId and v.serverId and v.atk.id == myAllianceId then
        local cityData = DataCenter.AllianceCityTemplateManager:GetTemplate(tonumber(v.cityId))
        if cityData then
          UIUtil.ShowTips(Localization:GetString("season_tips156", Localization:GetString(cityData.name)))
          local v2 = cityData.pos
          local worldPos = SceneUtils.TileToWorld(v2)
          GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom, nil, nil, v.serverId)
          return
        end
      end
    end
  end
  data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
  if data and data.content then
    local cityData = DataCenter.AllianceCityTemplateManager:GetTemplate(tonumber(data.content))
    if cityData then
      UIUtil.ShowTips(Localization:GetString("season_tips156", Localization:GetString(cityData.name)))
      local v2 = cityData.pos
      local worldPos = SceneUtils.TileToWorld(v2)
      GoToUtil.GotoWorldPos(worldPos)
    end
  end
end

function UILWAlDeclareWarNode:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.Declare, bool)
end

function UILWAlDeclareWarNode:SetShow(bool)
  self:SetActiveAsync(bool, LuaPath, PrefabPath)
end

return UILWAlDeclareWarNode
