local base = UIBaseContainer
local ProbOneCaseItem = BaseClass("ProbOneCaseItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ProbOneCaseItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ProbOneCaseItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ProbOneCaseItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.icon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.costNum_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.prob_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function ProbOneCaseItem:ComponentDestroy()
  self.viewSkin = nil
  self.icon = nil
  self.costNum_txt = nil
  self.prob_txt = nil
end

function ProbOneCaseItem:DataDefine()
end

function ProbOneCaseItem:DataDestroy()
end

function ProbOneCaseItem:OnAddListener()
  base.OnAddListener(self)
end

function ProbOneCaseItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ProbOneCaseItem:SetData(dataOrCostNum, prob, iconPath)
  local data
  if type(dataOrCostNum) == "table" then
    data = dataOrCostNum
  else
    data = {
      costNum = dataOrCostNum,
      prob = prob,
      iconPath = iconPath
    }
  end
  if self.icon and not string.IsNullOrEmpty(data.iconPath) then
    self.icon:LoadSprite(data.iconPath)
  end
  if self.costNum_txt then
    self.costNum_txt:SetText(tostring(data.costNum or ""))
  end
  if self.prob_txt then
    self.prob_txt:SetText(tostring(data.prob or ""))
  end
end

return ProbOneCaseItem
