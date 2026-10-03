local BaseNoteItemComponent = require("UI.UIActCrazyRock.PlayView.Component.BaseNoteItemComponent")
local base = BaseNoteItemComponent
local GuideLineItemComponent = BaseClass("GuideLineItemComponent", BaseNoteItemComponent)
local empty_line_path = "EmptyLine"
local single_line_path = "SingleLine"
local continue_line_path = "ContinueLine"
local tip_text_path = "TipText"
local Localization = CS.GameEntry.Localization

function GuideLineItemComponent:OnCreate()
  base.OnCreate(self)
end

function GuideLineItemComponent:OnDestroy()
  base.OnDestroy(self)
end

function GuideLineItemComponent:ComponentDefine()
  base.ComponentDefine(self)
  self.emptyLine = self:AddComponent(UIBaseContainer, empty_line_path)
  self.singleLine = self:AddComponent(UIBaseContainer, single_line_path)
  self.continueLine = self:AddComponent(UIBaseContainer, continue_line_path)
  self.tipText = self:AddComponent(UIText, tip_text_path)
  self.tipTextCanvasGroup = self:AddComponent(UICanvasGroup, tip_text_path)
end

function GuideLineItemComponent:ComponentDestroy()
  base.ComponentDestroy(self)
end

function GuideLineItemComponent:DataDefine()
  base.DataDefine(self)
end

function GuideLineItemComponent:DataDestroy()
  base.DataDestroy(self)
end

function GuideLineItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function GuideLineItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GuideLineItemComponent:RefreshNoteView()
  base.RefreshNoteView(self)
  self.emptyLine:SetActive(self.noteType == CrazyRockNoteType.Empty)
  self.singleLine:SetActive(self.noteType == CrazyRockNoteType.SingleClick)
  self.continueLine:SetActive(self.noteType == CrazyRockNoteType.Continue)
  self.tipText:SetText(string.format("%s-%s", self.noteData.meterId, self.noteData.noteIndex))
end

function GuideLineItemComponent:OnUpdatePos(lerp)
end

return GuideLineItemComponent
