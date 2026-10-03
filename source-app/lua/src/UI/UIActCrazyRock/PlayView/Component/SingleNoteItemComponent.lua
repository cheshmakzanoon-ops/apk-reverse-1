local BaseNoteItemComponent = require("UI.UIActCrazyRock.PlayView.Component.BaseNoteItemComponent")
local base = BaseNoteItemComponent
local SingleNoteItemComponent = BaseClass("SingleNoteItemComponent", BaseNoteItemComponent)
local Localization = CS.GameEntry.Localization

function SingleNoteItemComponent:OnCreate()
  base.OnCreate(self)
end

function SingleNoteItemComponent:OnDestroy()
  base.OnDestroy(self)
end

function SingleNoteItemComponent:ComponentDefine()
  base.ComponentDefine(self)
end

function SingleNoteItemComponent:ComponentDestroy()
  base.ComponentDestroy(self)
end

function SingleNoteItemComponent:DataDefine()
  base.DataDefine(self)
end

function SingleNoteItemComponent:DataDestroy()
  base.DataDestroy(self)
end

function SingleNoteItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function SingleNoteItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return SingleNoteItemComponent
