local SeasonDeclareList = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareList")
local SeasonDeclareOther = BaseClass("SeasonDeclareOther", SeasonDeclareList)
local base = SeasonDeclareList

function SeasonDeclareOther:OnCreate()
  base.OnCreate(self)
  self.has_data = self:AddComponent(UIText, "hasData")
  self.no_data = self:AddComponent(UIText, "noData")
end

function SeasonDeclareOther:OnDestroy()
  base.OnDestroy(self)
end

function SeasonDeclareOther:ReInit(view, declareList, thePageItem, redPointKey)
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

return SeasonDeclareOther
