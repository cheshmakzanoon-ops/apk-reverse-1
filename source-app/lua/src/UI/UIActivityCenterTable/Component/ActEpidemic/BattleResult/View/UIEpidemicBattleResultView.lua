local UIEpidemicBattleResultView = BaseClass("UIEpidemicBattleResultView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local Script_base = "UI.UIActivityCenterTable.Component.ActEpidemic.BattleResult.Component.%s"
local Prefab_base = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/%s.prefab"
local ENUM_STEP = {
  {
    prefab = "BattleResultDetail",
    cls = "UIEBR_Detail"
  },
  {
    prefab = "BattleResultMvp",
    cls = "UIEBR_Mvp"
  },
  {
    prefab = "BattleResultMyData",
    cls = "UIEBR_MyData"
  }
}

function UIEpidemicBattleResultView:OnCreate()
  base.OnCreate(self)
  self.cells = {}
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(BindCallback(self, self.OnClick))
  self.msg = self:GetUserData() or {}
  self:LoadStep(1)
end

function UIEpidemicBattleResultView:OnDestroy()
  self.panel = nil
  self.cells = nil
  base.OnDestroy(self)
end

function UIEpidemicBattleResultView:OnClick()
  local curCell = self.cells[self.curStep]
  if not (curCell and curCell.AsyncLoadDone) or not curCell:AsyncLoadDone() then
    return
  end
  if self.curStep == 1 then
    self:LoadStep(self.curStep + 1)
  elseif self.curStep == 2 then
    if BattleFieldUtil.isObserve then
      self.ctrl:CloseSelf()
    else
      self:LoadStep(self.curStep + 1)
    end
  elseif self.curStep >= 3 then
    self.ctrl:CloseSelf()
  end
end

function UIEpidemicBattleResultView:LoadStep(step)
  local curCell = self.cells[self.curStep]
  if curCell then
    curCell:SetActive(false)
  end
  self.curStep = step
  curCell = self.cells[step]
  if curCell and curCell.AsyncLoadDone and curCell:AsyncLoadDone() then
    curCell:SetActive(true)
    curCell:RefreshView()
    return
  end
  local info = ENUM_STEP[step]
  local cls = require(string.format(Script_base, info.cls))
  local prefab = string.format(Prefab_base, info.prefab)
  curCell = self:LoadComponentAsync(cls, prefab, self)
  self.cells[step] = curCell
end

return UIEpidemicBattleResultView
