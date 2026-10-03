local UIBuildRobotFreeView = BaseClass("UIBuildRobotFreeView", UIBaseContainer)
local base = UIBaseContainer
local Des_Text_path = "Root/Des/Des_Text"
local Root_path = "Root"
local Build_Btn_path = "Root/Btns/Build_Btn"
local Science_Btn_path = "Root/Btns/Science_Btn"
local Farm_Btn_path = "Root/Btns/Farm_Btn"
local Factory_Btn_path = "Root/Btns/Factory_Btn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.Des_Text = self:AddComponent(UIText, Des_Text_path)
  self.Root = self:AddComponent(UIBaseContainer, Root_path)
  self.Build_Btn = self:AddComponent(UIButton, Build_Btn_path)
  self.Science_Btn = self:AddComponent(UIButton, Science_Btn_path)
  self.Farm_Btn = self:AddComponent(UIButton, Farm_Btn_path)
  self.Factory_Btn = self:AddComponent(UIButton, Factory_Btn_path)
  self.Build_Btn:SetOnClick(BindCallback(self.view.ctrl, self.view.ctrl.DoWhenClickBuild))
  self.Science_Btn:SetOnClick(BindCallback(self.view.ctrl, self.view.ctrl.DoWhenClickScience))
  self.Farm_Btn:SetOnClick(BindCallback(self.view.ctrl, self.view.ctrl.DoWhenClickFarm))
  self.Factory_Btn:SetOnClick(BindCallback(self.view.ctrl, self.view.ctrl.DoWhenClickFactory))
end

local function SetData(self, robotQueueIndex, pos)
  self.robotQueueIndex = robotQueueIndex
  self.pos = pos
  self.showData = self.view.ctrl:GetShowData(self.robotQueueIndex)
  self:RefreshView()
end

local function ComponentDestroy(self)
  self.Des_Text = nil
  self.closeBtn = nil
  self.Build_Btn = nil
  self.Science_Btn = nil
  self.Farm_Btn = nil
  self.Factory_Btn = nil
  self.Root = nil
end

local function RefreshView(self)
  self.Des_Text:SetText(self.showData.desc)
  self.Farm_Btn:SetActive(self.showData.farmFlag)
  self.Factory_Btn:SetActive(self.showData.factoryFlat)
  self.Root.transform.position = self.pos
end

UIBuildRobotFreeView.RefreshView = RefreshView
UIBuildRobotFreeView.OnCreate = OnCreate
UIBuildRobotFreeView.OnDestroy = OnDestroy
UIBuildRobotFreeView.ComponentDefine = ComponentDefine
UIBuildRobotFreeView.ComponentDestroy = ComponentDestroy
UIBuildRobotFreeView.SetData = SetData
return UIBuildRobotFreeView
