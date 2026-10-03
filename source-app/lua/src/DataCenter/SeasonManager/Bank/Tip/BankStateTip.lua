local base = UIBaseContainer
local BankStateTip = BaseClass("BankStateTip", base)
local ResourceManager = CS.GameEntry.Resource
local bg_path = "bg"

function BankStateTip:__init(gameObject)
  self.parentTabs = gameObject.transform
  self.lodCache = 1
  self:InitPrefab()
end

function BankStateTip:__delete()
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
  self.parentTabs = nil
  self.lodCache = 1
end

function BankStateTip:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
end

function BankStateTip:OnDestroy()
  base.OnDestroy(self)
end

function BankStateTip:UpdateData()
  self:DoRefresh()
end

function BankStateTip:SetLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 7)
  end
end

function BankStateTip:CheckLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.lodCache < 7)
  end
end

function BankStateTip:ReInit(cityId, hasBankBattle)
  self.cityId = cityId
  self.hasBankBattle = hasBankBattle
  self:DoRefresh()
end

function BankStateTip:DoRefresh()
  if IsNull(self.gameObject) then
    return
  end
  self.bg:SetLocalPositionXYZ(0, self.hasBankBattle and 147 or 88, 0)
end

function BankStateTip:InitPrefab()
  local request = ResourceManager:InstantiateAsync("Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/Group/BankStateTip.prefab")
  request:completed("+", function()
    local theWorld = CS.SceneManager.World
    if request.isError or theWorld == nil or IsNull(self.parentTabs) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.parentTabs)
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

return BankStateTip
