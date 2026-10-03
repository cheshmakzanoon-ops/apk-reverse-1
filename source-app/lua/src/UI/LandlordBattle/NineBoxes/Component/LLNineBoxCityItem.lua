local base = UIBaseContainer
local LLNineBoxCityItem = BaseClass("LLNineBoxCityItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LLNineBoxCityItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLNineBoxCityItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLNineBoxCityItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 2)
  self.btnDetail = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

function LLNineBoxCityItem:ComponentDestroy()
  self.viewSkin = nil
  self.textTips = nil
  self.imgBg = nil
  self.btnDetail = nil
  self.textScore = nil
end

function LLNineBoxCityItem:DataDefine()
end

function LLNineBoxCityItem:DataDestroy()
  self.data = nil
  self.index = nil
  self.tipCb = nil
end

function LLNineBoxCityItem:OnAddListener()
  base.OnAddListener(self)
end

function LLNineBoxCityItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLNineBoxCityItem:OnBtnDetailClick()
  if self.data == nil or self.tipCb == nil then
    return
  end
  self.tipCb(self.btnDetail, self.index)
end

function LLNineBoxCityItem:SetData(data, index, tipCb)
  self.data = data
  self.index = index
  self.tipCb = tipCb
  self.imgBg:LoadSpriteAuto(string.format(LoadPath.LandlordPath, data.icon))
  self.textTips:SetLocalText(data.name)
  local scoreMin = data.scoreMin
  local scoreMax = data.scoreMax
  if scoreMin ~= scoreMax then
    self.textScore:SetText(string.format("%s-%s", scoreMin, scoreMax))
  else
    self.textScore:SetText(scoreMin)
  end
end

return LLNineBoxCityItem
