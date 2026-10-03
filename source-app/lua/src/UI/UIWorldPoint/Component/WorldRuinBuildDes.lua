local WorldRuinBuildDes = BaseClass("WorldRuinBuildDes", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local desc_path = "Desc"
local time_path = "timeLabel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:OnSelect(false)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.time_label = self:AddComponent(UIText, time_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
end

local function ComponentDestroy(self)
  self.desc_text = nil
  self.info_btn = nil
  self.time_label = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshData(self, data, pointId)
  if CS.SceneManager:IsInCity() then
    self:SetActive(false)
    return
  end
  self.pointId = pointId
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  self.isAlly = allianceData and data.alAbbr == allianceData.abbr
  self.desc_text:SetLocalText("Teleport_Territory_tips_1", data.name, data.alAbbr)
  self.EndTime = nil
  self.EndTime = data.endTime
  self:Update1000MS()
  self.time_label:SetActive(self.EndTime ~= nil)
  self:SetActive(true)
  self:OnSelect(true)
end

function WorldRuinBuildDes:Update1000MS()
  if self.EndTime then
    UIUtil.SetLeftTimeText(self.time_label, nil, self.EndTime)
  end
end

function WorldRuinBuildDes:OnSelect(flag)
  if not flag then
    if not self.modelSel then
      return
    end
    self.modelSel:Destroy()
    self.modelSel = nil
    return
  end
  if not self.modelSel then
    if not self.pointId then
      return
    end
    local obj = CS.SceneManager.World:GetObjectByPoint(self.pointId)
    local gameObject = obj:GetGameObject()
    local root = gameObject.transform:Find("ModelGo/Normal")
    local prefab = self.isAlly and UIAssets.RuinBuildSelectEffect or UIAssets.RuinBuildSelectEffectRed
    self.modelSel = self:GameObjectInstantiateAsync(prefab, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(root)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end)
  else
    self.modelSel.gameObject:SetActive(true)
  end
end

WorldRuinBuildDes.OnCreate = OnCreate
WorldRuinBuildDes.OnDestroy = OnDestroy
WorldRuinBuildDes.OnEnable = OnEnable
WorldRuinBuildDes.OnDisable = OnDisable
WorldRuinBuildDes.ComponentDefine = ComponentDefine
WorldRuinBuildDes.ComponentDestroy = ComponentDestroy
WorldRuinBuildDes.DataDefine = DataDefine
WorldRuinBuildDes.DataDestroy = DataDestroy
WorldRuinBuildDes.RefreshData = RefreshData
return WorldRuinBuildDes
