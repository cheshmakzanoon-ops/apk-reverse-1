local LWUITrailTowerTabItemRender = BaseClass("LWUITrailTowerTabItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local selectImage_path = "SelectImage"
local selectText_path = "SelectImage/SelectTabText"
local noSelectText_path = "NoSelectImage/NoSelectTabText"
local btn_path = "NoSelectImage"

function LWUITrailTowerTabItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUITrailTowerTabItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUITrailTowerTabItemRender:ComponentDefine()
  self.selectImage = self:AddComponent(UIImage, selectImage_path)
  self.selectText = self:AddComponent(UIText, selectText_path)
  self.noSelectText = self:AddComponent(UIText, noSelectText_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:BtnClick()
  end)
end

function LWUITrailTowerTabItemRender:ComponentDestroy()
  self.selectImage = nil
  self.selectText = nil
  self.noSelectText = nil
  self.btn = nil
end

function LWUITrailTowerTabItemRender:SetData(trailTowerType, name, select)
  self.trailTowerType = trailTowerType
  self.selectText:SetText(name)
  self.noSelectText:SetText(name)
  self:SetSelectState(select)
end

function LWUITrailTowerTabItemRender:SetSelectState(select)
  self.selectImage:SetActive(select)
end

function LWUITrailTowerTabItemRender:BtnClick()
  self.view:OnTabItemClick(self.trailTowerType)
end

return LWUITrailTowerTabItemRender
