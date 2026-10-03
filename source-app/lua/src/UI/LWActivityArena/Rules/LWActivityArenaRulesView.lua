local LWActivityArenaRulesView = BaseClass("LWActivityArenaRulesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = "302027"
  },
  {
    path = "btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "scrollContent/Viewport/Content",
    name = "txtContent",
    type = UIText,
    text = ""
  },
  {
    path = "black",
    name = "btnBlack",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  }
}

function LWActivityArenaRulesView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.txtContent:SetText(Localization:GetString(self:GetUserData()))
end

function LWActivityArenaRulesView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWActivityArenaRulesView:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function LWActivityArenaRulesView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

return LWActivityArenaRulesView
