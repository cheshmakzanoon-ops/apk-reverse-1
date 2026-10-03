local UICityVisitorDesItem = BaseClass("UICityVisitorDesItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ContentSizeFitter = CS.UnityEngine.UI.ContentSizeFitter
local Const = require("Scene.CityVisitor.Const")
local text_Path = "visitorDesText"

function UICityVisitorDesItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UICityVisitorDesItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICityVisitorDesItem:ComponentDefine()
  self.text = self:AddComponent(UIText, text_Path)
  self.fitter = self.text.unity_text:GetComponent(typeof(ContentSizeFitter))
end

function UICityVisitorDesItem:DataDefine()
  self.param = {}
end

function UICityVisitorDesItem:DataDestroy()
  self.param = nil
end

function UICityVisitorDesItem:ComponentDestroy()
  self.text = nil
end

function UICityVisitorDesItem:ReInit(param)
  self.param = param
  local text = Localization:GetString(self.param)
  self.text:SetText(text)
  if self.text:GetWidth() > Const.desMaxWidth then
    self.fitter.horizontalFit = ContentSizeFitter.FitMode.Unconstrained
    self.text:SetPreferSize({
      x = Const.desMaxWidth,
      y = self.text:GetHeight()
    })
  end
end

return UICityVisitorDesItem
