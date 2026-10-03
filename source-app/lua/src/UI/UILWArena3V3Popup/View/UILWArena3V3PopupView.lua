local UILWArena3V3PopupView = BaseClass("UILWArena3V3PopupView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "txtSub",
    name = "txtSub",
    type = UIText
  },
  {
    path = "btnGo/txtBtnGo",
    name = "txtBtnGo",
    type = UIText
  },
  {
    path = "btnGo",
    name = "btnGo",
    type = UIButton
  },
  {
    path = "btnBack",
    name = "btnBack",
    type = UIButton
  }
}

function UILWArena3V3PopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWArena3V3PopupView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWArena3V3PopupView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UILWArena3V3PopupView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  local openTime = DataCenter.LW3V3ArenaManager.startTime or 0
  local endTime = DataCenter.LW3V3ArenaManager.endTime or 0
  local openTimeFormatted = UITimeManager:GetInstance():TimeStampToDayForLocal(openTime)
  local endTimeFormatted = UITimeManager:GetInstance():TimeStampToDayForLocal(endTime)
  self.txtSub:SetText(Localization:GetString("500274", openTimeFormatted, endTimeFormatted))
  self.btnBack:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnGo:SetOnClick(function()
    local state = DataCenter.LW3V3ArenaManager.state
    if state ~= PVPArenaState.Invalide then
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PVP_ARENA)
      if buildData == nil then
        return
      end
      local posEnd = buildData.pointId
      self.ctrl:CloseSelf()
      GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
        DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.Arena3V3, nil)
      end)
    else
      self.ctrl:CloseSelf()
    end
  end)
end

return UILWArena3V3PopupView
