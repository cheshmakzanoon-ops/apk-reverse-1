local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local Localization = CS.GameEntry.Localization
local LWUIQuestionnaireMain = BaseClass("LWUIQuestionnaireMain", base)
local LWUIQuestionnaireItemRender = require("UI.UIActivityCenterTable.Component.LWUIQuestionnaire.LWUIQuestionnaireItemRender")
local infoBtn_path = "InfoBtn"
local titleText_path = "TitleText"
local questionnaireLoopList_path = "QuestionnaireScrollView"
local questionnaireLoopContent_path = "QuestionnaireScrollView/Viewport/QuestionnaireScrollContent"
local desText_path = "DesText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearLoopView()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  DataCenter.LWQuestionnaireManager:SetQuestionnaireRedDotMark()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.questionnaireLoopList = self:AddComponent(UILoopListView2, questionnaireLoopList_path)
  self.questionnaireLoopContent = self:AddComponent(UIBaseContainer, questionnaireLoopContent_path)
  self.desText = self:AddComponent(UIText, desText_path)
  self.titleText:SetLocalText("wenjuan_01")
  self.desText:SetLocalText("wenjuan_05")
  self.infoBtn:SetOnClick(function()
    self:InfoBtnClick()
  end)
  self.questionnaireLoopList:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
end

local function ComponentDestroy(self)
  self.infoBtn = nil
  self.titleText = nil
  self.questionnaireLoopList = nil
  self.questionnaireLoopContent = nil
  self.desText = nil
end

local function DataDefine(self)
  self.questionnaireUuidList = {}
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.questionnaireUuidList = nil
  self.itemIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetQuestionnaireInfoData, self.ShowView)
  self:AddUIListener(EventId.RefreshCanShowQuestionnaireList, self.ShowView)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetQuestionnaireInfoData, self.ShowView)
  self:RemoveUIListener(EventId.RefreshCanShowQuestionnaireList, self.ShowView)
  base.OnRemoveListener(self)
end

local function SetData(self, activityId)
  base.SetData(self, activityId)
  self:ShowView()
end

local function ShowView(self)
  self.questionnaireUuidList = DataCenter.LWQuestionnaireManager:GetAllCanShowQuestionnaireList()
  local count = table.count(self.questionnaireUuidList)
  if 0 < count then
    self.questionnaireLoopList:SetListItemCount(count, false, false)
    self.questionnaireLoopList:RefreshAllShownItem()
  else
    self.view.ctrl:CloseSelf()
  end
end

local function OnGetItemByIndex(self, loopScroll, index)
  local count = table.count(self.questionnaireUuidList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = loopScroll:NewListViewItem("LWUIQuestionnaireItemRender")
  local script = self.questionnaireLoopContent:GetComponent(item.gameObject.name, LWUIQuestionnaireItemRender)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.questionnaireLoopContent:AddComponent(LWUIQuestionnaireItemRender, objectName)
  end
  script:SetActive(true)
  local uuid = self.questionnaireUuidList[index]
  script:SetData(uuid)
  return item
end

local function ClearLoopView(self)
  self.questionnaireLoopContent:RemoveComponents(LWUIQuestionnaireItemRender)
  self.questionnaireLoopList:ClearAllItems()
end

local function InfoBtnClick(self)
  local param = {}
  param.activityRulesStr = Localization:GetString("wenjuan_02")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

LWUIQuestionnaireMain.OnCreate = OnCreate
LWUIQuestionnaireMain.OnDestroy = OnDestroy
LWUIQuestionnaireMain.OnEnable = OnEnable
LWUIQuestionnaireMain.OnDisable = OnDisable
LWUIQuestionnaireMain.ComponentDefine = ComponentDefine
LWUIQuestionnaireMain.ComponentDestroy = ComponentDestroy
LWUIQuestionnaireMain.DataDefine = DataDefine
LWUIQuestionnaireMain.DataDestroy = DataDestroy
LWUIQuestionnaireMain.InfoBtnClick = InfoBtnClick
LWUIQuestionnaireMain.SetData = SetData
LWUIQuestionnaireMain.OnGetItemByIndex = OnGetItemByIndex
LWUIQuestionnaireMain.ClearLoopView = ClearLoopView
LWUIQuestionnaireMain.OnAddListener = OnAddListener
LWUIQuestionnaireMain.OnRemoveListener = OnRemoveListener
LWUIQuestionnaireMain.ShowView = ShowView
return LWUIQuestionnaireMain
