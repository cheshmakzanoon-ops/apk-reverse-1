local base = UIBaseContainer
local CityCannonCampBattle = BaseClass("CityCannonCampBattle", base)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh

function CityCannonCampBattle:__init(transform, serverId)
  local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UI/AllianceCityTip/CityCannonCampBattle.prefab")
  request:completed("+", function()
    local theWorld = CS.SceneManager.World
    if request.isError or transform == nil or theWorld == nil or IsNull(transform) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(transform)
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
  self.lodCache = 0
  self.request = request
end

function CityCannonCampBattle:__delete()
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

function CityCannonCampBattle:OnCreate()
  base.OnCreate(self)
  local trans = self.transform
  self.iconA = trans:Find("Root/IconCampA"):GetComponent(typeof(SpriteRenderer))
  self.iconB = trans:Find("Root/IconCampB"):GetComponent(typeof(SpriteRenderer))
  self.txtA = trans:Find("Root/TxtCampA"):GetComponent(typeof(SuperTextMesh))
  self.txtB = trans:Find("Root/TxtCampB"):GetComponent(typeof(SuperTextMesh))
  self.txtVS = trans:Find("Root/TxtCampVS"):GetComponent(typeof(SuperTextMesh))
end

function CityCannonCampBattle:OnAddListener()
  base.OnAddListener(self)
  self.registerListener = true
end

function CityCannonCampBattle:OnRemoveListener()
  if self.registerListener then
    self.registerListener = false
  end
  base.OnRemoveListener(self)
end

function CityCannonCampBattle:OnDestroy()
  base.OnDestroy(self)
end

function CityCannonCampBattle:SetLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.showUI and self.lodCache ~= 0)
  end
end

function CityCannonCampBattle:ReInit(data, extraInfo)
  self.data = data
  self.cityId = toInt(self.data.id)
  self.cityType = toInt(self.data.type)
  self.theExtraInfo = extraInfo
  self.showUI = self:UpdateData()
end

function CityCannonCampBattle:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local strategicAreaInfo = self.theExtraInfo and self.theExtraInfo.strategicAreaInfo
  if not strategicAreaInfo or table.IsNullOrEmpty(strategicAreaInfo.servers) then
    if IsNotNull(self.gameObject) then
      self:SetActive(false)
    end
    return
  end
  local campA, campB
  for _, v in ipairs(strategicAreaInfo.servers) do
    if v.campId == 1 then
      campA = v
    elseif v.campId == 2 then
      campB = v
    end
  end
  if not campA or not campB then
    if IsNotNull(self.gameObject) then
      self:SetActive(false)
    end
    return
  end
  self.txtA.text = string.format("#%s", campA.serverId)
  self.txtB.text = string.format("#%s", campB.serverId)
  self.txtVS.text = "VS"
  local campIconA = DataCenter.ZoneWarManager:GetCampIcon(campA.serverId, campA.campId)
  local campIconB = DataCenter.ZoneWarManager:GetCampIcon(campB.serverId, campB.campId)
  self.iconA:LoadSprite(campIconA or "")
  self.iconB:LoadSprite(campIconB or "")
  local aIsAlly = DataCenter.ZoneWarManager:IsAlly(campA.serverId)
  if aIsAlly then
    self.txtA.color32 = Color.New(68, 195, 255, 255)
    self.txtB.color32 = Color.New(255, 115, 135, 255)
  else
    self.txtA.color32 = Color.New(255, 115, 135, 255)
    self.txtB.color32 = Color.New(68, 195, 255, 255)
  end
  self:SetActive(self.lodCache ~= 0)
  return true
end

return CityCannonCampBattle
