local CareerEffect = BaseClass("CareerEffect")
local ResourceManager = CS.GameEntry.Resource
local complete_icon_path = "Go/Bg1"
local not_complete_icon_path = "Go/Bg2"
local num_text_path = "Go/Bg2/NumText"

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  if not self.defend then
    self.complete_icon = self.transform:Find(complete_icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.not_complete_icon = self.transform:Find(not_complete_icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.num_text = self.transform:Find(num_text_path):GetComponent(typeof(CS.SuperTextMesh))
    local template = DataCenter.PlayerCareerManager:GetCareerEffectTemplate(CareerEffect_10302)
    local effectStr = ""
    if template ~= nil and table.count(template.effectVals) > 0 then
      effectStr = tostring(template.effectVals[1])
    end
    self.num_text.text = effectStr
    self.defend = true
    self.complete_icon.gameObject:SetActive(false)
    self.not_complete_icon.gameObject:SetActive(false)
    self.num_text.gameObject:SetActive(false)
  end
end

local function ComponentDestroy(self)
  self.complete_icon = nil
  self.not_complete_icon = nil
  self.num_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.defend = nil
end

local function ReInit(self, queueUid)
  self.queueUid = queueUid
  self:RefreshView()
end

local function RefreshView(self)
  local queueData = DataCenter.QueueDataManager:GetQueueByUuid(self.queueUid)
  if queueData ~= nil then
    local isIrrigated = queueData:CheckIfIrrigated()
    self.complete_icon.gameObject:SetActive(isIrrigated)
    self.not_complete_icon.gameObject:SetActive(not isIrrigated)
    self.num_text.gameObject:SetActive(not isIrrigated)
  end
end

CareerEffect.OnCreate = OnCreate
CareerEffect.OnDestroy = OnDestroy
CareerEffect.ComponentDefine = ComponentDefine
CareerEffect.ComponentDestroy = ComponentDestroy
CareerEffect.DataDefine = DataDefine
CareerEffect.DataDestroy = DataDestroy
CareerEffect.ReInit = ReInit
CareerEffect.RefreshView = RefreshView
return CareerEffect
