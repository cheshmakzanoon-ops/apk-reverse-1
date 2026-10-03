local Season5DeclareList = require("UI.LWSeason5.DeclareCity.Season5DeclareList")
local Season5DeclareOther = BaseClass("Season5DeclareOther", Season5DeclareList)
local base = Season5DeclareList

function Season5DeclareOther:OnCreate()
  base.OnCreate(self)
  self.has_data = self:AddComponent(UIText, "hasData")
  self.no_data = self:AddComponent(UIText, "noData")
end

function Season5DeclareOther:OnDestroy()
  base.OnDestroy(self)
end

function Season5DeclareOther:ReInit(view, declareList, thePageItem, redPointKey)
  base.ReInit(self, view, declareList, thePageItem, redPointKey)
  self.declareList = declareList
  if declareList and 0 < #declareList then
    self.has_data:SetActive(true)
    self.no_data:SetActive(false)
  else
    self.has_data:SetActive(false)
    self.no_data:SetActive(true)
  end
end

return Season5DeclareOther
