local base = UIAsyncContainer
local UIEBR_Mvp = BaseClass("UIEBR_Mvp", base)
local UIEBR_MvpItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleResult.Component.UIEBR_MvpItem")

function UIEBR_Mvp:OnCreate()
  base.OnCreate(self)
  self.mvpCells = {}
  for i = 1, 4 do
    local cell = self:AddComponent(UIEBR_MvpItem, "MvpCell" .. i)
    table.insert(self.mvpCells, cell)
  end
end

function UIEBR_Mvp:OnDestroy()
  self.mvpCells = {}
  base.OnDestroy(self)
end

function UIEBR_Mvp:UpdateData()
  local msg = self.view.msg
  local mvps = msg.mvp or {}
  for i, v in ipairs(self.mvpCells) do
    local info = mvps[i]
    if info then
      v:SetData(info)
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
  DataCenter.LWSoundManager:PlaySound(93016, false)
end

return UIEBR_Mvp
