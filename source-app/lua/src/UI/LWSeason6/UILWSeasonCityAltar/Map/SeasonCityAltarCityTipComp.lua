local prefab_path = "Assets/Main/SeasonRes/S6/Prefabs/UI/CityAltar/S6CityAltarOccupyTips.prefab"
local ResourceManager = CS.GameEntry.Resource
local SeasonCityAltarCityTipCell = require("UI.LWSeason6.UILWSeasonCityAltar.Map.SeasonCityAltarCityTipCell")
local base = UIBaseContainer
local SeasonCityAltarCityTipComp = BaseClass("SeasonCityAltarCityTipComp", UIBaseContainer)

function SeasonCityAltarCityTipComp:ComponentDefine()
  local time_tip_path = "Image/bg/time_tip"
  local pro1_root_path = "Image/pro1_root"
  local pro2_root_path = "Image/pro2_root"
  local pro3_root_path = "Image/pro3_root"
  self.time_tip = self:AddComponent(UITextMeshProUGUIEx, time_tip_path)
  self.pro1_root = self:AddComponent(SeasonCityAltarCityTipCell, pro1_root_path)
  self.pro2_root = self:AddComponent(SeasonCityAltarCityTipCell, pro2_root_path)
  self.pro3_root = self:AddComponent(SeasonCityAltarCityTipCell, pro3_root_path)
  self.occupy_list = {
    self.pro1_root,
    self.pro2_root,
    self.pro3_root
  }
end

function SeasonCityAltarCityTipComp:ComponentDestroy()
  self.occupy_list = nil
  self.time_tip = nil
  self.pro1_root = nil
  self.pro2_root = nil
  self.pro3_root = nil
end

function SeasonCityAltarCityTipComp:DataDefine()
end

function SeasonCityAltarCityTipComp:DataDestroy()
end

function SeasonCityAltarCityTipComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCityAltarCityTipComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCityAltarCityTipComp:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCityAltarCityTipComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCityAltarCityTipComp:__init(transform, serverId)
  local request = ResourceManager:InstantiateAsync(prefab_path)
  request:completed("+", function()
    local theWorld = CS.SceneManager.World
    if request.isError or transform == nil or theWorld == nil or IsNull(transform) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(transform)
    go.transform:Set_localPosition(0, 0.44, 0)
    go.transform:Set_localRotation(0, 0, 0, 1)
    go.transform:Set_localScale(0.005, 0.005, 1)
    base.Reinit(self, go, "")
    self.initActiveSelf = true
    self:OnCreate()
    self:OnEnable()
    self:SetLod(theWorld:GetLodLevel())
    self:InitUi()
    self:UpdateUi()
  end)
  self.lodCache = 0
  self.request = request
end

function SeasonCityAltarCityTipComp:__delete()
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
end

function SeasonCityAltarCityTipComp:ReInit(data, altarData)
  self.Data = data
  self.CityId = checknumber(data.id)
  self.CityType = checknumber(self.Data.type)
  self.AltarData = altarData
  self:UpdateUi()
end

function SeasonCityAltarCityTipComp:InitUi()
end

function SeasonCityAltarCityTipComp:UpdateUi()
  self.List = self.AltarData:GetSortedOccupyList()
  if IsNull(self.gameObject) then
    return
  end
  for i = 1, 3 do
    local occupyData = self.List[i]
    local occupyComp = self.occupy_list[i]
    if occupyData ~= nil then
      occupyComp:SetActive(true)
      occupyComp:ReInit(occupyData)
    else
      occupyComp:SetActive(false)
    end
  end
  self:Update1000MS()
end

function SeasonCityAltarCityTipComp:SetLod(lod)
  self.lodCache = checknumber(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 3)
  end
end

function SeasonCityAltarCityTipComp:Update1000MS()
  if self.lodCache >= 3 then
    return
  end
  if IsNull(self.gameObject) then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local _, time = self.AltarData:GetTimeState()
  local leftTime = Mathf.Max(0, time - now)
  self.time_tip:SetLocalText("season_s6_activity1200109_desc25", UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  for i = 1, 3 do
    local occupyData = self.List[i]
    local occupyComp = self.occupy_list[i]
    if occupyData ~= nil then
      occupyComp:Tick()
    end
  end
end

return SeasonCityAltarCityTipComp
