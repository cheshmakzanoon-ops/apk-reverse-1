local base = require("UI.UIRaceEntrance.View.ActDownloadViewBase")
local LWActMeteoriteMainView = BaseClass("LWActMeteoriteMainView", base)
local PREFAB = "Assets/Main/Prefabs/UI/LWUIActMeteorite/LWUIActMeteoriteRoot.prefab"
local CLS = "UI.LWActMeteorite.Component.LWActMeteoriteMainRoot"

function LWActMeteoriteMainView:OnCreate()
  base.OnCreate(self)
  self:SetRootCP(CLS, PREFAB)
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActMeteorite.Type)
  if actData then
    self.text_title:SetLocalText(actData.name or "yuntieBattle_name_1001")
    self:SetData(actData.id)
  end
end

function LWActMeteoriteMainView:GetCurIdx()
  if not self.compAct then
    return 0
  end
  return self.compAct.curIdx
end

function LWActMeteoriteMainView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function LWActMeteoriteMainView:LoadActFinish()
end

return LWActMeteoriteMainView
