local base = UIBaseView
local S6CityAltarFishView = BaseClass("S6CityAltarFishView", UIBaseView)

function S6CityAltarFishView:ComponentDefine()
  local p_btn_close_back_path = "p_btn_close_back"
  local p_btn_call_path = "PanelRoot/p_btn_call"
  local p_btn_close_path = "PanelRoot/p_btn_close"
  self.p_btn_close_back = self:AddComponent(UIButton, p_btn_close_back_path)
  self.p_btn_close_back:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_btn_call = self:AddComponent(UIButton, p_btn_call_path)
  self.p_btn_call:SetOnClick(BindCallback(self, self.OnCallClicked))
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_btn_close:SetOnClick(BindCallback(self, self.OnCloseClicked))
end

function S6CityAltarFishView:ComponentDestroy()
  self.p_btn_close_back = nil
  self.p_btn_call = nil
  self.p_btn_close = nil
end

function S6CityAltarFishView:DataDefine()
end

function S6CityAltarFishView:DataDestroy()
  self.Data = nil
end

function S6CityAltarFishView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function S6CityAltarFishView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6CityAltarFishView:OnAddListener()
  base.OnAddListener(self)
end

function S6CityAltarFishView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function S6CityAltarFishView:ReInit(data)
  if self:InitData(data) then
  end
end

function S6CityAltarFishView:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function S6CityAltarFishView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

function S6CityAltarFishView:OnCallClicked()
  if self.Data ~= nil then
    DataCenter.SeasonCityAltarManager:SendFish(self.Data.uuid, self.Data.serverId)
    self.ctrl:CloseSelf()
  end
end

return S6CityAltarFishView
