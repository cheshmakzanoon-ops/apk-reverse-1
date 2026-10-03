local T11SoldierResearchPlanView = BaseClass("T11SoldierResearchPlanView", UIBaseView)
local T11SoldierResearchPlanStageNodeComponent = require("UI.T11SoldierResearchPlan.Component.T11SoldierResearchPlanStageNodeComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local M = T11SoldierResearchPlanView
local OneProgressHeight = 551
local contentDelta = 50
local progressDelta = 40
local stageNodePath = "Assets/Main/Prefabs/UI/T11/T11SoldierResearchPlan/T11SoldierResearchPlanStageNode.prefab"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function M:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgLevelTotalProgress = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgLevelProgress = self.viewSkin:AddComponent(self, UIImage, 3)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compLevelProgressNode = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
end

function M:ComponentDestroy()
  self.viewSkin = nil
  self.imgLevelTotalProgress = nil
  self.textTitle = nil
  self.imgLevelProgress = nil
  self.btnClose = nil
  self.compContent = nil
  self.compLevelProgressNode = nil
end

function M:DataDefine()
  self.previewData = nil
  self.planNodeList = {}
end

function M:DataDestroy()
  self.previewData = nil
  self.planNodeList = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
end

function M:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function M:InitView()
  self.previewData = DataCenter.T11DataManager:GetPreviewData()
  self.stageNum = table.count(self.previewData)
  self.textTitle:SetLocalText("solider_eleven_preview_title")
  self:InitProgressHeight()
  self:InitContent()
end

function M:InitProgressHeight()
  local height = (self.stageNum - 1) * OneProgressHeight
  self.imgLevelTotalProgress:SetSizeDeltaY(height + progressDelta)
  self.compContent:SetSizeDeltaY(self.stageNum * OneProgressHeight + contentDelta)
  local curStage = T11Util.GetCurStage()
  local maxStage = DataCenter.T11DataManager.curT11LevelData.stageData:GetMaxStage()
  self.imgLevelProgress:SetSizeDeltaY(math.min(maxStage - 1, curStage) * OneProgressHeight)
end

function M:InitContent()
  self.planNodeList = {}
  self:ClearScroll()
  for i = 1, table.length(self.previewData) do
    self.planNodeList[i] = self:GameObjectInstantiateAsync(stageNodePath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.compLevelProgressNode.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.name = "item" .. i
      local cell = self.compLevelProgressNode:AddComponent(T11SoldierResearchPlanStageNodeComponent, go.name)
      cell:ParseInfo(self.previewData[i])
      local positionY = (i - 1) * OneProgressHeight
      cell:SetAnchorMaxXY(0.5, 1)
      cell:SetAnchorMinXY(0.5, 1)
      cell:SetAnchoredPosition(Vector2.New(0, -positionY))
    end)
  end
end

function M:ClearScroll()
  self.compLevelProgressNode:RemoveComponents(T11SoldierResearchPlanStageNodeComponent)
  if self.planNodeList ~= nil then
    for k, v in pairs(self.planNodeList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

return T11SoldierResearchPlanView
