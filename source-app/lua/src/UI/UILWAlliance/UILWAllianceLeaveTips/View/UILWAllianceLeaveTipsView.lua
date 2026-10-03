local base = UIBaseView
local UILWAllianceLeaveTipsView = BaseClass("UILWAllianceLeaveTipsView", base)
local UILWAllianceLeaveTipsItemRender = require("UI.UILWAlliance.UILWAllianceLeaveTips.Component.UILWAllianceLeaveTipsItemRender")
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local closeBtn_path = "PopUpContent/CloseBtn"
local allianceLeaveTipsScrollView_path = "PopUpContent/AllianceLeaveTipsScrollView"
local stayBtn_path = "PopUpContent/StayBtn"
local stayBtnText_path = "PopUpContent/StayBtn/StayBtnText"
local exitBtn_path = "PopUpContent/ExitBtn"
local exitBtnText_path = "PopUpContent/ExitBtn/VerticalLayout/ExitBtnText"
local exitCutDownText_path = "PopUpContent/ExitBtn/VerticalLayout/ExitCutDownText"
local tipsText_path = "PopUpContent/TipsText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.quitAllianceYesCallBack, self.quitAllianceNoCallBack, self.fromInvite = self:GetUserData()
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.allianceLeaveTipsScrollView = self:AddComponent(UIScrollView, allianceLeaveTipsScrollView_path)
  self.stayBtn = self:AddComponent(UIButton, stayBtn_path)
  self.stayBtnText = self:AddComponent(UIText, stayBtnText_path)
  self.exitBtn = self:AddComponent(UIButton, exitBtn_path)
  self.exitBtnText = self:AddComponent(UIText, exitBtnText_path)
  self.exitCutDownText = self:AddComponent(UIText, exitCutDownText_path)
  self.tipsText = self:AddComponent(UIText, tipsText_path)
  self.exitBtnIcon = self:AddComponent(UIImage, "PopUpContent/ExitBtn/cfm_tongyong_anniu_5")
  self.titleText:SetLocalText("alliance_leave_title")
  self.tipsText:SetLocalText("alliance_leave_desc")
  self.stayBtnText:SetLocalText("alliance_leave_btn_cancle")
  self.exitBtnText:SetLocalText("alliance_leave_btn_confirm")
  self.panelBtn:SetOnClick(function()
    self:CancelExitAllianceBtnClick()
  end)
  self.closeBtn:SetOnClick(function()
    self:CancelExitAllianceBtnClick()
  end)
  self.stayBtn:SetOnClick(function()
    self:CancelExitAllianceBtnClick()
  end)
  self.exitBtn:SetOnClick(function()
    self:ExitAllianceBtnClick()
  end)
  self.allianceLeaveTipsScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.allianceLeaveTipsScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.closeBtn = nil
  self.allianceLeaveTipsScrollView = nil
  self.stayBtn = nil
  self.stayBtnText = nil
  self.exitBtn = nil
  self.exitBtnText = nil
  self.exitCutDownText = nil
  self.tipsText = nil
  self.exitBtnIcon = nil
end

local function DataDefine(self)
  self.showTemplateList = {}
  self.exitBtnGrayContinueTime = 3
  self.isUpdate = false
end

local function DataDestroy(self)
  self.showTemplateList = nil
  self.exitBtnGrayContinueTime = nil
  self.isUpdate = true
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  if self.fromInvite then
    self.exitBtnText:SetLocalText("110007")
    self.exitBtnIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
  else
    self.exitBtnText:SetLocalText("alliance_leave_btn_confirm")
    self.exitBtnIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_5.png")
  end
  self:RefreshShowView()
  CS.UIGray.SetGray(self.exitBtn.transform, true, false)
  self.exitCutDownText:SetActive(true)
  self.exitCutDownText:SetText("(" .. self.exitBtnGrayContinueTime .. ")")
  self.isUpdate = true
end

local function Update1000MS(self)
  if not self.isUpdate then
    return
  end
  self.exitBtnGrayContinueTime = self.exitBtnGrayContinueTime - 1
  if self.exitBtnGrayContinueTime <= 0 then
    self.isUpdate = false
    CS.UIGray.SetGray(self.exitBtn.transform, false, true)
    self.exitCutDownText:SetActive(false)
  else
    self.exitCutDownText:SetText("(" .. self.exitBtnGrayContinueTime .. ")")
  end
end

local function RefreshShowView(self)
  self.showTemplateList = {}
  local allTemplates = DataCenter.LWAllianceLeaveTipsTemplateManager:GetAllTemplates()
  for id, template in pairs(allTemplates) do
    if template:IsUnlock() then
      table.insert(self.showTemplateList, template)
    end
  end
  local dataCount = table.count(self.showTemplateList)
  if 0 < dataCount then
    self.allianceLeaveTipsScrollView:SetTotalCount(dataCount)
    self.allianceLeaveTipsScrollView:RefillCells()
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.allianceLeaveTipsScrollView:AddComponent(UILWAllianceLeaveTipsItemRender, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.showTemplateList[index])
  end
end

local function OnItemMoveOut(self, itemObj, index)
  self.allianceLeaveTipsScrollView:RemoveComponent(itemObj.name, UILWAllianceLeaveTipsItemRender)
end

local function ClearScroll(self)
  self.allianceLeaveTipsScrollView:ClearCells()
  self.allianceLeaveTipsScrollView:RemoveComponents(UILWAllianceLeaveTipsItemRender)
end

local function ExitAllianceBtnClick(self)
  local callback = self.quitAllianceYesCallBack
  self.ctrl:CloseSelf()
  if callback ~= nil and type(callback) == "function" then
    callback(DataCenter.AllianceBaseDataManager:IsSelfLeader())
  end
end

local function CancelExitAllianceBtnClick(self)
  local callback = self.quitAllianceNoCallBack
  self.ctrl:CloseSelf()
  if callback ~= nil and type(callback) == "function" then
    callback()
  end
end

UILWAllianceLeaveTipsView.OnCreate = OnCreate
UILWAllianceLeaveTipsView.OnDestroy = OnDestroy
UILWAllianceLeaveTipsView.OnEnable = OnEnable
UILWAllianceLeaveTipsView.OnDisable = OnDisable
UILWAllianceLeaveTipsView.ComponentDefine = ComponentDefine
UILWAllianceLeaveTipsView.ComponentDestroy = ComponentDestroy
UILWAllianceLeaveTipsView.DataDefine = DataDefine
UILWAllianceLeaveTipsView.DataDestroy = DataDestroy
UILWAllianceLeaveTipsView.OnAddListener = OnAddListener
UILWAllianceLeaveTipsView.OnRemoveListener = OnRemoveListener
UILWAllianceLeaveTipsView.ReInit = ReInit
UILWAllianceLeaveTipsView.Update1000MS = Update1000MS
UILWAllianceLeaveTipsView.RefreshShowView = RefreshShowView
UILWAllianceLeaveTipsView.OnItemMoveIn = OnItemMoveIn
UILWAllianceLeaveTipsView.OnItemMoveOut = OnItemMoveOut
UILWAllianceLeaveTipsView.ClearScroll = ClearScroll
UILWAllianceLeaveTipsView.ExitAllianceBtnClick = ExitAllianceBtnClick
UILWAllianceLeaveTipsView.CancelExitAllianceBtnClick = CancelExitAllianceBtnClick
return UILWAllianceLeaveTipsView
