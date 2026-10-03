local UIScienceTabLockCell = BaseClass("UIScienceTabLockCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  data
}
local des_text_path = "DesText"
local goto_btn_path = "GotoBtn"
local goto_btn_name_path = "GotoBtn/btnTxt_green_small_new"

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
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn_name = self:AddComponent(UIText, goto_btn_name_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.goto_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.goto_btn = nil
  self.goto_btn_name = nil
  self.des_text = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.goto_btn_name:SetLocalText(GameDialogDefine.GOTO)
  if param.data.type == ScienceTabUnlockType.PreScienceTreePro then
    if table.count(param.data.para) > 1 then
      local tempTem = DataCenter.ScienceTemplateManager:GetScienceTabTemplate(param.data.para[1])
      if tempTem ~= nil then
        self.des_text:SetText(Localization:GetString(GameDialogDefine.NEED_PARAM1, Localization:GetString(tempTem.name) .. param.data.para[2] .. "%"))
      end
      local tempPro = DataCenter.ScienceTemplateManager:GetScienceTabPro(param.data.para[1])
      if tempPro * 100 < param.data.para[2] then
        self.goto_btn:SetActive(true)
      else
        self.goto_btn:SetActive(false)
      end
    end
  elseif param.data.type == ScienceTabUnlockType.PreScienceLevel then
    if table.count(param.data.para) > 1 then
      local tempTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(param.data.para[1], param.data.para[2])
      if tempTemplate ~= nil then
        self.des_text:SetText(Localization:GetString(GameDialogDefine.NEED_PRE_SCIENCE, Localization:GetString(tempTemplate.name), param.data.para[2]))
      end
      local level = DataCenter.ScienceManager:GetScienceLevel(param.data.para[1])
      if level < param.data.para[2] then
        self.goto_btn:SetActive(true)
      else
        self.goto_btn:SetActive(false)
      end
    end
  elseif param.data.type == ScienceTabUnlockType.PreBuildingLevel then
    if table.count(param.data.para) > 1 then
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(param.data.para[1])
      if template ~= nil then
        self.des_text:SetLocalText("science_condition", param.data.para[2], Localization:GetString(template.name))
      end
      local level = DataCenter.BuildManager:GetMaxBuildingLevel(param.data.para[1])
      if level < param.data.para[2] then
        self.goto_btn:SetActive(true)
      else
        self.goto_btn:SetActive(false)
      end
    end
  elseif param.data.type == ScienceTabUnlockType.RequireActivityId then
    self.goto_btn:SetActive(true)
  end
end

local function OnBtnClick(self)
  if self.param.data.type == ScienceTabUnlockType.PreScienceTreePro then
    local state = DataCenter.ScienceTemplateManager:GetTabState(self.param.data.para[1])
    if state == ScienceTabState.UnLock then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIScience, {anim = true, hideTop = true}, self.param.data.para[1])
    elseif state == ScienceTabState.Lock then
    elseif state == ScienceTabState.CanUnlock then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIScience, {anim = true, hideTop = true}, self.param.data.para[1])
    end
  elseif self.param.data.type == ScienceTabUnlockType.PreScienceLevel then
    GoToUtil.GotoScience(self.param.data.para[1])
  elseif self.param.data.type == ScienceTabUnlockType.PreBuildingLevel then
    GoToUtil.GotoCityByBuildId(self.param.data.para[1], WorldTileBtnType.City_Upgrade)
  elseif self.param.data.type == ScienceTabUnlockType.RequireActivityId then
  end
  if self.view ~= nil and self.view.ctrl ~= nil then
    self.view.ctrl:CloseSelf()
  end
end

UIScienceTabLockCell.OnCreate = OnCreate
UIScienceTabLockCell.OnDestroy = OnDestroy
UIScienceTabLockCell.Param = Param
UIScienceTabLockCell.OnEnable = OnEnable
UIScienceTabLockCell.OnDisable = OnDisable
UIScienceTabLockCell.ComponentDefine = ComponentDefine
UIScienceTabLockCell.ComponentDestroy = ComponentDestroy
UIScienceTabLockCell.DataDefine = DataDefine
UIScienceTabLockCell.DataDestroy = DataDestroy
UIScienceTabLockCell.ReInit = ReInit
UIScienceTabLockCell.OnBtnClick = OnBtnClick
return UIScienceTabLockCell
