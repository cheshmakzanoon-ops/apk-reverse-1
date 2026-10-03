local UILWFactionWarGroupLine = BaseClass("UILWFactionWarGroupLine", UIBaseContainer)
local base = UIBaseContainer

function UILWFactionWarGroupLine:OnCreate()
  base.OnCreate(self)
  self.t1 = self:AddComponent(UITextMeshProUGUIEx, "t1")
  self.t2 = self:AddComponent(UITextMeshProUGUIEx, "t2")
end

function UILWFactionWarGroupLine:OnDestroy()
  self.t1 = nil
  self.t2 = nil
  base.OnDestroy(self)
end

function UILWFactionWarGroupLine:SetEmpty()
  self.t1:SetText("<color=#FFFFFF>\226\139\174</color>")
  self.t2:SetText("<color=#FFFFFF>\226\139\174</color>")
end

function UILWFactionWarGroupLine:ReInit(index, startIndex, endIndex, myGroupIndex, thisWeek)
  if myGroupIndex and thisWeek and index == myGroupIndex then
    self.t1:SetLocalText("season_s4_activity_1200005_tips5", index)
    self.t2:SetLocalText("season_s4_activity_1200005_tips6", startIndex, endIndex)
    self.t1:SetColorHex("#5fef87")
    self.t2:SetColorHex("#5fef87")
  else
    self.t1:SetLocalText("season_s4_activity_1200005_tips5", index)
    self.t2:SetLocalText("season_s4_activity_1200005_tips6", startIndex, endIndex)
    self.t1:SetColorHex("#ffffff")
    self.t2:SetColorHex("#ffffff")
  end
end

return UILWFactionWarGroupLine
