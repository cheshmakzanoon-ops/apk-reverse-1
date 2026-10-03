local base = UIBaseContainer
local AllianceCityTipResetFirstHeadInfo = BaseClass("AllianceCityTipResetFirstHeadInfo", base)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local u_i_player_head_path = "lordInfo/headParent/UIPlayerHead"

function AllianceCityTipResetFirstHeadInfo:__init(gameObject)
  self.parentTrans = gameObject.transform
  self.lodCache = 1
  self:InitPrefab()
end

function AllianceCityTipResetFirstHeadInfo:__delete()
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
  self.parentTrans = nil
  self.lodCache = 1
end

function AllianceCityTipResetFirstHeadInfo:InitPrefab()
  local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UI/LWOffSeason1/AllianceCityTip/AllianceCityTipResetFirstHead.prefab")
  request:completed("+", function()
    local theWorld = CS.SceneManager.World
    if request.isError or theWorld == nil or IsNull(self.parentTrans) then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.parentTrans)
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

function AllianceCityTipResetFirstHeadInfo:OnCreate()
  base.OnCreate(self)
  self.lordHead = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.lordHead:SetEnableClickShowInfo(true)
end

function AllianceCityTipResetFirstHeadInfo:OnDestroy()
  self.player_frame = nil
  self.lordHead = nil
  base.OnDestroy(self)
end

function AllianceCityTipResetFirstHeadInfo:UpdateData()
  self:DoRefresh()
end

function AllianceCityTipResetFirstHeadInfo:SetLod(lod)
  self:CheckLod(lod)
end

function AllianceCityTipResetFirstHeadInfo:CheckLod(lod)
  self.lodCache = toInt(lod)
  if IsNotNull(self.gameObject) then
    self:SetActive(self.lodCache ~= 0 and self.data ~= nil)
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

function AllianceCityTipResetFirstHeadInfo:ReInit(data)
  self.data = data
  self:DoRefresh()
end

function AllianceCityTipResetFirstHeadInfo:DoRefresh()
  if IsNotNull(self.gameObject) and self.data then
    self.lordHead:ParseHeadInfo(self.data, true)
  end
end

return AllianceCityTipResetFirstHeadInfo
