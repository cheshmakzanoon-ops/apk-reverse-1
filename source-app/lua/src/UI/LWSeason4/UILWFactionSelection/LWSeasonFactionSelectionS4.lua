local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LWSeasonFactionSelectionS4 = BaseClass("LWSeasonFactionSelectionS4", base)

function LWSeasonFactionSelectionS4:OnCreate()
  base.OnCreate(self)
  SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionInfo)
end

function LWSeasonFactionSelectionS4:OnDestroy()
  base.OnDestroy(self)
end

function LWSeasonFactionSelectionS4:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionInfoUpdate, self.UpdateData)
end

function LWSeasonFactionSelectionS4:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function LWSeasonFactionSelectionS4:SetData(activityId)
  base.SetData(self, activityId)
  if toInt(activityId) > 0 then
    self.activityId = activityId
    self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    self:UpdateData()
  end
end

function LWSeasonFactionSelectionS4:UpdateData()
  local actData = self.activityData
  if actData ~= nil then
    local groupingActInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingActInfo()
    local campInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingData()
    if groupingActInfo then
      if groupingActInfo.hasSubStep then
        groupingActInfo.stepEndTime = groupingActInfo.subStepEndTime
        self:CreateKingNode()
      else
        self:CreateNormalNode()
      end
    elseif campInfo then
      self:CreateNormalNode()
      self.normalNode:SetData(self.activityId)
    end
  end
end

function LWSeasonFactionSelectionS4:CreateKingNode()
  if self.kingNode == nil then
    local luaPath = "UI.LWSeason4.UILWFactionSelection.LWSeasonFactionSelectionS4King"
    local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/FactionSelection/FactionSelectionKing.prefab"
    self.kingNode = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self)
  end
  if self.kingNode ~= nil then
    self.kingNode:SetData(self.activityId)
    self.kingNode:SetActive(true)
  end
  if self.normalNode ~= nil then
    self.normalNode:SetActive(false)
  end
end

function LWSeasonFactionSelectionS4:CreateNormalNode()
  if self.normalNode == nil then
    local luaPath = "UI.LWSeason4.UILWFactionSelection.LWSeasonFactionSelectionS4Normal"
    local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/FactionSelection/FactionSelectionNormal.prefab"
    self.normalNode = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self)
  end
  if self.kingNode ~= nil then
    self.kingNode:SetActive(false)
  end
  if self.normalNode ~= nil then
    self.normalNode:SetData(self.activityId)
    self.normalNode:SetActive(true)
  end
end

return LWSeasonFactionSelectionS4
