local UIChampionDuelStateDi = BaseClass("UIChampionDuelStateDi", UIBaseContainer)
local base = UIBaseContainer
local line_path = "line"
local light_path = "light"
local light_big_path = "lightBig"

function UIChampionDuelStateDi:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIChampionDuelStateDi:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelStateDi:ComponentDefine()
  self.line = self:AddComponent(UIImage, line_path)
  self.light = self:AddComponent(UIImage, light_path)
  self.lightBig = self:AddComponent(UIImage, light_big_path)
end

function UIChampionDuelStateDi:ComponentDestroy()
  self.line = nil
  self.light = nil
  self.lightBig = nil
end

function UIChampionDuelStateDi:ReInit(index)
  local stageId = DataCenter.ChampionDuelManager:GetCurStageId()
  self.line:SetActive(index <= stageId)
  self.light:SetActive(index < stageId)
  self.lightBig:SetActive(index == stageId)
end

return UIChampionDuelStateDi
