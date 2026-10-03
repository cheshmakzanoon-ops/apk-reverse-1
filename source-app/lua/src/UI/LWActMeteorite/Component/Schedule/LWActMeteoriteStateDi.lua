local base = UIBaseContainer
local LWActMeteoriteStateDi = BaseClass("LWActMeteoriteStateDi", base)
local line_path = "line"
local light_path = "light"
local light_big_path = "lightBig"
local light2_path = "light2"
local light2_2_path = "light2_2"
local light_big2_path = "lightBig2"

function LWActMeteoriteStateDi:OnCreate()
  base.OnCreate(self)
  self.line = self:AddComponent(UIImage, line_path)
  self.light = self:AddComponent(UIImage, light_path)
  self.light_big = self:AddComponent(UIImage, light_big_path)
  if self.transform:Find(light2_path) then
    self.light2 = self:AddComponent(UIImage, light2_path)
  end
  if self.transform:Find(light2_2_path) then
    self.light2_2 = self:AddComponent(UIImage, light2_2_path)
  end
  if self.transform:Find(light_big2_path) then
    self.light_big2 = self:AddComponent(UIImage, light_big2_path)
  end
end

function LWActMeteoriteStateDi:OnDestroy()
  self.line = nil
  self.light = nil
  self.light_big = nil
  self.light2 = nil
  self.light2_2 = nil
  self.light_big2 = nil
  base.OnDestroy(self)
end

function LWActMeteoriteStateDi:SetData(index, stageId, stageInfo)
  if stageInfo.stage == MeteoriteState.GRAB then
    self.line:SetActive(index <= stageId)
    self.light:SetActive(false)
    self.light_big:SetActive(false)
    if self.light2 then
      self.light2:SetActive(stageId < index)
    end
    if self.light2_2 then
      self.light2_2:SetActive(index < stageId)
    end
    if self.light_big2 then
      self.light_big2:SetActive(index == stageId)
    end
  else
    self.line:SetActive(index <= stageId)
    self.light:SetActive(index < stageId)
    self.light_big:SetActive(index == stageId)
    if self.light2_2 then
      self.light2_2:SetActive(false)
    end
    if self.light2 then
      self.light2:SetActive(false)
    end
    if self.light_big2 then
      self.light_big2:SetActive(false)
    end
  end
end

return LWActMeteoriteStateDi
