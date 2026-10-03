local base = UIBaseContainer
local ActivityTradeStationLordInfo = BaseClass("ActivityTradeStationLordInfo", base)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local u_i_player_head_path = "lordInfo/headParent/UIPlayerHead"
local player_frame_path = "lordInfo/headParent/playerFrame"

function ActivityTradeStationLordInfo:__init(gameObject)
  self.parentTrabs = gameObject.transform
  self.lodCache = 1
  self:InitPrefab()
end

function ActivityTradeStationLordInfo:__delete()
  if self.gameObject ~= nil then
    self:OnDisable()
    self:OnDestroy()
  else
    self.holder = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self.parentTrabs = nil
  self.lodCache = 1
end

function ActivityTradeStationLordInfo:InitPrefab()
  local request = ResourceManager:InstantiateAsync("Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceCityTip/TradeStationLordHead.prefab")
  request:completed("+", function()
    local theWorld = CS.SceneManager.World
    if request.isError or theWorld == nil or IsNull(self.parentTrabs) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.parentTrabs)
    go.transform:Set_localScale(0.01, 0.01, 0.01)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localRotation(0, 0, 0, 1)
    base.Reinit(self, go, "")
    self.initActiveSelf = true
    self:OnCreate()
    self:OnEnable()
    self:SetLod(theWorld:GetLodLevel())
    self:UpdateData()
  end)
  self.request = request
end

function ActivityTradeStationLordInfo:OnCreate()
  base.OnCreate(self)
  self.lordHead = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.player_frame = self:AddComponent(UIImage, player_frame_path)
  self.lordHead:SetEnableClickShowInfo(true)
end

function ActivityTradeStationLordInfo:OnDestroy()
  self.player_frame = nil
  self.lordHead = nil
  base.OnDestroy(self)
end

function ActivityTradeStationLordInfo:UpdateData()
  self:DoRefresh()
end

function ActivityTradeStationLordInfo:SetLod(lod)
  self:CheckLod(lod)
end

function ActivityTradeStationLordInfo:CheckLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0)
    if self.lodCache < 3 then
      self.gameObject.transform:Set_localScale(0.01, 0.01, 0.01)
      self.gameObject.transform:Set_localPosition(0, 0, 0)
    else
      self.gameObject.transform:Set_localScale(0.006, 0.006, 0.006)
      self.gameObject.transform:Set_localPosition(0, 0.25, 0)
    end
    self.lordHead:SetEnableClickShowInfo(self.lodCache < 6, true)
  end
end

function ActivityTradeStationLordInfo:ReInit(occupyInfoUserInfo, tradeId, serverId)
  self.data = occupyInfoUserInfo
  self.cityId = tradeId
  self.serverId = serverId or LuaEntry.Player:GetCurServerId()
  self:DoRefresh()
end

function ActivityTradeStationLordInfo:DoRefresh()
  if IsNotNull(self.gameObject) then
    if self.data then
      self.lordHead:ParseHeadInfo(self.data, true)
      local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId, self.serverId)
      if cityMeta and not string.IsNullOrEmpty(cityMeta.lord_cap) then
        self.player_frame:LoadSprite(cityMeta.lord_cap)
      else
        self.player_frame:SetActive(false)
      end
    else
      self.lordHead:SetHead()
    end
  end
end

return ActivityTradeStationLordInfo
