local LWUIMigrationView_StateDi = BaseClass("LWUIMigrationView_StateDi", UIBaseContainer)
local base = UIBaseContainer
local line_path = "line"
local light_path = "light"
local light_big_path = "lightBig"

function LWUIMigrationView_StateDi:OnCreate()
  base.OnCreate(self)
  self.line = self:AddComponent(UIBaseComponent, line_path)
  self.light = self:AddComponent(UIBaseComponent, light_path)
  self.lightBig = self:AddComponent(UIBaseComponent, light_big_path)
end

function LWUIMigrationView_StateDi:OnDestroy()
  self.line = nil
  self.light = nil
  self.lightBig = nil
  base.OnDestroy(self)
end

function LWUIMigrationView_StateDi:SetData(index, curIdx)
  self.line:SetActive(index <= curIdx)
  self.light:SetActive(index < curIdx)
  self.lightBig:SetActive(index == curIdx)
end

return LWUIMigrationView_StateDi
