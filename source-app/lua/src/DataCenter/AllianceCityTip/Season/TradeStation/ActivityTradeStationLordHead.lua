local base = UIAsyncContainer
local ActivityTradeStationLordHead = BaseClass("ActivityTradeStationLordHead", base)
local u_i_player_head_path = "lordInfo/headParent/UIPlayerHead"
local player_frame_path = "lordInfo/headParent/playerFrame"

function ActivityTradeStationLordHead:OnCreate()
  base.OnCreate(self)
  self.lordHead = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.player_frame = self:AddComponent(UIImage, player_frame_path)
  self.lordHead:SetEnableClickShowInfo(true, true)
end

function ActivityTradeStationLordHead:OnDestroy()
  self.player_frame = nil
  self.lordHead = nil
  self.worldPos = nil
  base.OnDestroy(self)
end

function ActivityTradeStationLordHead:SetWorldPos(worldPos)
  self.worldPos = worldPos
end

function ActivityTradeStationLordHead:UpdateData()
  self:DoRefresh()
end

function ActivityTradeStationLordHead:SetLod(lod)
  self:CheckLod(lod)
end

function ActivityTradeStationLordHead:CheckLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    local isBattle = SeasonUtil.CityIsInBattle(self.serverId, self.cityId)
    if self.lodCache ~= 8 or isBattle then
      self:SetActive(false)
      return
    end
    self:SetActive(true)
    if self.worldPos ~= nil then
      self.gameObject.transform.position = self.worldPos + Vector3.New(0, -50, 0)
      self.gameObject.transform:Set_localScale(1, 1, 1)
    end
  end
end

function ActivityTradeStationLordHead:ReInit(occupyInfoUserInfo, tradeId, serverId)
  self.data = occupyInfoUserInfo
  self.cityId = tradeId
  self.serverId = serverId or LuaEntry.Player:GetCurServerId()
  self:DoRefresh()
end

function ActivityTradeStationLordHead:DataRefresh()
  if self.cityId == nil or self.serverId == nil then
    return
  end
  local tradeInfo = DataCenter.SeasonTradeDataManager:GetServerTradeStationData(self.cityId, self.serverId)
  if tradeInfo ~= nil then
    local pointLord = tradeInfo.occupyInfoUserInfo
    if tradeInfo ~= nil and pointLord ~= nil then
      self.data = pointLord
      self:DoRefresh()
    end
  end
end

function ActivityTradeStationLordHead:DoRefresh()
  if IsNotNull(self.gameObject) then
    if self.data then
      self.lordHead:ParseHeadInfo(self.data, true)
      local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId, self.serverId)
      if cityMeta and not string.IsNullOrEmpty(cityMeta.lord_cap) then
        self.player_frame:SetActive(true)
        self.player_frame:LoadSprite(cityMeta.lord_cap)
      else
        self.player_frame:SetActive(false)
      end
    else
      self.lordHead:SetHead()
    end
    self:CheckLod(self.lodCache)
  end
end

return ActivityTradeStationLordHead
