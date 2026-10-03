local base = UIBaseView
local UIStageView = BaseClass("UIStageView", base)
local Localization = CS.GameEntry.Localization
local stageItemPrefab = "Assets/Main/Prefabs/UI/LWStage/StageItem.prefab"
local UIStageItemCell = require("UI.UIStage.View.UIStageItemCell")
local UIStageInfoView = require("UI.UIStage.View.UIStageInfoView")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  self:DisposeView()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.closeBtn = self:AddComponent(UIButton, "CloseBtn")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.nextBtn = self:AddComponent(UIButton, "NextBtn")
  self.nextBtn:SetOnClick(function()
    self:NextPageClick()
  end)
  self.previousBtn = self:AddComponent(UIButton, "PreviousBtn")
  self.previousBtn:SetOnClick(function()
    self:PreviousPageClick()
  end)
  self.continueBtn = self:AddComponent(UIButton, "ContinueBtn")
  self.continueBtn:SetOnClick(function()
    self:ContinueClick()
  end)
  self.continueBtnText = self:AddComponent(UIText, "ContinueBtn/ContinueBtnText")
  self.title = self:AddComponent(UIText, "Title")
  self.itemRoot = self:AddComponent(UIBaseContainer, "Items")
  self.topInfoView = self:AddComponent(UIStageInfoView, "ItemsInfo/TopStageInfo")
  self.topInfoView:SetActive(false)
  self.topInfoView.host = self
  self.bottomHeroList = self:AddComponent(UIBaseContainer, "ItemsInfo/BottomHeroList")
  self.bottomHeroList:SetActive(false)
  self.continueBtnText:SetText(Localization:GetString("171002"))
end

local function ComponentDestroy(self)
  self.closeBtn = nil
  self.nextBtn = nil
  self.previousBtn = nil
  self.continueBtn = nil
  self.continueBtnText = nil
  self.title = nil
  self.itemRoot = nil
  self.topInfoView = nil
  self.bottomHeroList = nil
  self.hangUpBtn = nil
end

local function DataDefine(self)
  self.stageGroupMeta = self:GetUserData()
end

local function DataDestroy(self)
  self.stageGroupMeta = nil
end

local itemPos = {
  [1] = Vector3.New(67, -259, 0),
  [2] = Vector3.New(-231, -198, 0),
  [3] = Vector3.New(269, -58, 0),
  [4] = Vector3.New(60, -45, 0),
  [5] = Vector3.New(-187, 66, 0),
  [6] = Vector3.New(102, 174, 0),
  [7] = Vector3.New(-71, 311, 0),
  [8] = Vector3.New(174, 360, 0)
}

local function InitUI(self)
  self.stageCells = {}
  self.stageCellReqs = {}
  self.showChapter = self.ctrl:GetCurrentChapterId()
  self:RefreshView()
end

local function DisposeView(self)
  if self.stageCellReqs ~= nil then
    for _, req in ipairs(self.stageCellReqs) do
      req:Destroy()
    end
  end
  self.stageCells = nil
end

local function ShowStageDetail(self, cell)
  self.topInfoView:SetActive(true)
  self.topInfoView:RefreshData(cell)
end

local function CheckHasPage(self, ChapterId)
  local has = false
  LocalController:instance():visitTable(TableName.LW_StageGroup, function(id, lineData)
    if lineData.chapter_group == ChapterId then
      has = true
      return true
    end
  end)
  return has
end

local function NextPageClick(self)
  local nextChapterId = self.showChapter + 1
  local hasNext = self:CheckHasPage(nextChapterId)
  if hasNext then
    self.showChapter = nextChapterId
    self:RefreshView()
  end
end

local function PreviousPageClick(self)
  local previousChapterId = self.showChapter - 1
  local hasPrevious = self:CheckHasPage(previousChapterId)
  if hasPrevious then
    self.showChapter = previousChapterId
    self:RefreshView()
  end
end

local function ContinueClick(self)
  local curStageId = DataCenter.StageManager.idleRewardStageId
  if not curStageId then
    return
  end
  local curChapter = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), curStageId, "group")
  if not DataCenter.ZombieBattleManager.gameOver and not DataCenter.ZombieBattleManager.gamePause then
    DataCenter.ZombieBattleManager:OnBattleLose()
  end
  DataCenter.ZombieBattleManager:Destroy()
  PveUtil.TryEnterBattle(curChapter, curStageId)
end

local function RefreshView(self)
  self.panelData = {}
  self.panelData.allStage = {}
  local chapterName = ""
  local idleChapterGroup = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), DataCenter.StageManager.idleRewardStageId, "group")
  LocalController:instance():visitTable(TableName.LW_StageGroup, function(id, lineData)
    if lineData.chapter_group == self.showChapter then
      table.insert(self.panelData.allStage, lineData.id)
      chapterName = lineData.chapter_name
    end
  end)
  self.title:SetText(Localization:GetString(chapterName))
  self.bottomHeroList.gameObject:SetActive(false)
  if self.stageCellReqs ~= nil then
    for _, req in ipairs(self.stageCellReqs) do
      req:Destroy()
    end
  end
  local index = 1
  for _, stageId in ipairs(self.panelData.allStage) do
    local pos = itemPos[index]
    local id = index
    index = index + 1
    local existCell = self.stageCells[id]
    if not existCell then
      if self.stageCellReqs == nil then
        self.stageCellReqs = {}
      end
      local req = self:GameObjectInstantiateAsync(stageItemPrefab, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.itemRoot.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform.localPosition = pos
        local nameStr = tostring(id)
        go.name = nameStr
        local cell = self.itemRoot:AddComponent(UIStageItemCell, nameStr)
        local cfg = LocalController:instance():getLine(TableName.LW_StageGroup, stageId)
        cell:RefreshData(self, cfg)
        self.stageCells[id] = cell
        self.stageCellReqs[id] = nil
      end)
      self.stageCellReqs[index] = req
    else
      existCell:SetActive(true)
      existCell.transform.localPosition = pos
      local cfg = LocalController:instance():getLine(TableName.LW_StageGroup, stageId)
      existCell:RefreshData(self, cfg)
    end
    if stageId == idleChapterGroup then
      self.bottomHeroList.transform.localPosition = pos
      self.bottomHeroList.gameObject:SetActive(true)
    end
  end
  for id, cell in ipairs(self.stageCells) do
    if id >= index then
      cell:SetActive(false)
    end
  end
  self.nextBtn.gameObject:SetActive(self:CheckHasPage(self.showChapter + 1))
  self.previousBtn.gameObject:SetActive(self:CheckHasPage(self.showChapter - 1))
end

UIStageView.OnCreate = OnCreate
UIStageView.OnDestroy = OnDestroy
UIStageView.ComponentDefine = ComponentDefine
UIStageView.ComponentDestroy = ComponentDestroy
UIStageView.DataDefine = DataDefine
UIStageView.DataDestroy = DataDestroy
UIStageView.InitUI = InitUI
UIStageView.DisposeView = DisposeView
UIStageView.ShowStageDetail = ShowStageDetail
UIStageView.RefreshView = RefreshView
UIStageView.CheckHasPage = CheckHasPage
UIStageView.NextPageClick = NextPageClick
UIStageView.PreviousPageClick = PreviousPageClick
UIStageView.ContinueClick = ContinueClick
return UIStageView
