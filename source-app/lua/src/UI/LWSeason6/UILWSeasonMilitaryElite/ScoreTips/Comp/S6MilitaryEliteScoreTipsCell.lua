local t1_path = "t1"
local v1_path = "v1"
local base = UIBaseContainer
local S6MilitaryEliteScoreTipsCell = BaseClass("S6MilitaryEliteScoreTipsCell", UIBaseContainer)

function S6MilitaryEliteScoreTipsCell:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "")
  self.t1 = self:AddComponent(UITextMeshProUGUIEx, t1_path)
  self.v1 = self:AddComponent(UITextMeshProUGUIEx, v1_path)
end

function S6MilitaryEliteScoreTipsCell:ComponentDestroy()
  self.Data = nil
  self.bg = nil
  self.t1 = nil
  self.v1 = nil
end

function S6MilitaryEliteScoreTipsCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function S6MilitaryEliteScoreTipsCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6MilitaryEliteScoreTipsCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function S6MilitaryEliteScoreTipsCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function S6MilitaryEliteScoreTipsCell:InitUi()
  if self.Data.IsTitle then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di2.png")
  elseif self.Data.Index % 2 == 0 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di3.png")
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIGovernment/Sprites/Popup/zyf_zhanqupaiming_tanchuang_di1.png")
  end
  self.t1:SetActive(self.Data.IsTitle)
  self.v1:SetActive(not self.Data.IsTitle)
  if not self.Data.IsTitle then
    self.v1:SetText(self.Data.Desc)
  end
end

return S6MilitaryEliteScoreTipsCell
