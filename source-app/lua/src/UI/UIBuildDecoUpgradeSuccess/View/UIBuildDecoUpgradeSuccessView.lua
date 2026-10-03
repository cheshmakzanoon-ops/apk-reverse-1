local UIBuildDecoUpgradeSuccessView = BaseClass("UIBuildDecoUpgradeSuccessView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDesCell = require("UI.UIBuildUpgrade.Component.UIDesCell4DecoLevelUpPanel")
local text_title_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local content_path = "UIGarageRefitUpgrade/Root/Content"
local root_path = "UIGarageRefitUpgrade/Root"
local next_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.param = self:GetUserData()
  self:ReInit()
end

local function OnDestroy(self)
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
  self.titleText = self:AddComponent(UIText, text_title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.root_anim = self:AddComponent(UIAnimator, root_path)
  self.next_btn = self:AddComponent(UIButton, next_path)
  self.next_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleText:SetLocalText(120062)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.desCells = {}
end

local function DataDestroy(self)
  if self.desCells then
    for _, v in ipairs(self.desCells) do
      v.inst:Destroy()
    end
  end
  self.desCells = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIBuildDecoUpgradeSuccessView:ReInit()
  if self.root_anim ~= nil then
    self.root_anim:Play("V_ui_bujianshengji_01_anim", 0, 0)
  end
  local buildingId = self.param.buildingId
  local oldLevel = self.param.oldLevel
  local oldProgress = self.param.oldProgress
  local newLevel = self.param.newLevel or 0
  local newProgress = self.param.newProgress or 0
  local paramList = BuildingUtils.GetDecorationProgressUpValue(buildingId, oldLevel, oldProgress, newLevel, newProgress)
  for i = 1, #paramList do
    paramList[i].index = i
  end
  self:GenDescInfo(paramList)
end

function UIBuildDecoUpgradeSuccessView:GenDescInfo(paramList)
  for i = 1, #paramList do
    local index = i
    local param = paramList[i]
    local decsCell = self.desCells[i]
    if decsCell then
      decsCell.model:ReInit(param, true)
    else
      do
        local cell = {}
        cell.param = param
        table.insert(self.desCells, cell)
        cell.inst = self:GameObjectInstantiateAsync(UIAssets.DesCell4DecoLevelUpPanel, function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go:SetActive(true)
          go.transform:SetParent(self.content.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          go.transform:SetAsLastSibling()
          local nameStr = tostring(NameCount)
          go.name = nameStr
          NameCount = NameCount + 1
          local temp = self.content:AddComponent(UIDesCell, nameStr)
          temp:ReInit(cell.param, true)
          temp:DelayPlayShowAnim(index * 0.05)
          cell.model = temp
        end)
      end
    end
  end
end

UIBuildDecoUpgradeSuccessView.OnCreate = OnCreate
UIBuildDecoUpgradeSuccessView.OnDestroy = OnDestroy
UIBuildDecoUpgradeSuccessView.OnEnable = OnEnable
UIBuildDecoUpgradeSuccessView.OnDisable = OnDisable
UIBuildDecoUpgradeSuccessView.ComponentDefine = ComponentDefine
UIBuildDecoUpgradeSuccessView.ComponentDestroy = ComponentDestroy
UIBuildDecoUpgradeSuccessView.DataDefine = DataDefine
UIBuildDecoUpgradeSuccessView.DataDestroy = DataDestroy
UIBuildDecoUpgradeSuccessView.OnAddListener = OnAddListener
UIBuildDecoUpgradeSuccessView.OnRemoveListener = OnRemoveListener
return UIBuildDecoUpgradeSuccessView
