local UITrainDetailView = BaseClass("UITrainDetailView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UITrainDetailCell = require("UI.UITrain.Component.UITrainDetailCell")
local TipsDecVecDelta = Vector3.New(0, 30, 0)
local Param = DataClass("Param", ParamData)
local ParamData = {
  template
}
local detail_type_image_path = "DetailTypeImage"
local detail_type_type_path = "DetailTypeText"
local detail_des_path = "DetailDesText"
local tips_path = "Tips"
local tips_des_path = "Tips/TipsDes"
local tips_cancel_btn_path = "TipCancelBtn"
local content_path = "AddCondition"

local function OnCreate(self)
  base.OnCreate(self)
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
  if not self.detailDefine then
    self.detail_type_image = self:AddComponent(UIImage, detail_type_image_path)
    self.detail_type_type = self:AddComponent(UIText, detail_type_type_path)
    self.detail_des = self:AddComponent(UIText, detail_des_path)
    self.tips_cancel_btn = self:AddComponent(UIButton, tips_cancel_btn_path)
    self.content = self:AddComponent(UIBaseContainer, content_path)
    self.tips = self:AddComponent(UIAnimator, tips_path)
    self.tips_button = self:AddComponent(UIButton, tips_path)
    self.tips_des = self:AddComponent(UIText, tips_des_path)
    self.tips_button:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:SetTipsActive(false)
    end)
    self.tips_cancel_btn:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:SetTipsActive(false)
    end)
    self.detailDefine = true
  end
end

local function ComponentDestroy(self)
  if self.detailDefine then
    self.detail_type_image = nil
    self.detail_type_type = nil
    self.detail_des = nil
    self.tips_cancel_btn = nil
    self.content = nil
    self.tips = nil
    self.tips_button = nil
    self.tips_des = nil
    self.detailDefine = false
  end
end

local function DataDefine(self)
  self.detailDefine = false
  self.param = {}
  self.tipsActive = nil
  self.detailCells = {}
  self.freeDetailCells = {}
end

local function DataDestroy(self)
  self.detailDefine = nil
  self.param = nil
  self.tipsActive = nil
  self.detailCells = nil
  self.freeDetailCells = nil
end

local function ReInit(self, param)
  self.param = param
  self:ComponentDefine()
  self:SetTipsActive(false)
  if param.template ~= nil then
    self.detail_type_image:LoadSprite(string.format(LoadPath.UISoldier, param.template.kind))
    self.detail_type_type:SetLocalText(param.template.name)
    self.detail_des:SetLocalText(param.template.des)
    self:ShowDetailCells()
  end
end

local function ShowDetailCells(self)
  for k, v in pairs(self.detailCells) do
    v:SetActive(false)
    table.insert(self.freeDetailCells, v)
  end
  self.detailCells = {}
  for k1, v1 in ipairs(UITrainDetailTypeList) do
    local param = UITrainDetailCell.Param.New()
    param.detailType = v1
    param.template = self.param.template
    
    function param.callBack(des, pos)
      self:ShowTip(des, pos)
    end
    
    self:AddOneDetailCell(param)
  end
end

local function AddOneDetailCell(self, param)
  if #self.freeDetailCells > 0 then
    local temp = table.remove(self.freeDetailCells)
    if temp ~= nil then
      temp:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.content.transform)
      temp.transform:SetAsLastSibling()
      self.detailCells[param.detailType] = temp
    end
  else
    self:GameObjectInstantiateAsync(UIAssets.UITrainDetailCell, function(request)
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
      self.detailCells[param.detailType] = self.content:AddComponent(UITrainDetailCell, nameStr)
      self.detailCells[param.detailType]:ReInit(param)
    end)
  end
end

local function ShowTip(self, des, position)
  self:SetTipsActive(true)
  self.tips_des:SetText(des)
  self.tips:Play("CommonPopup_movein", 0, 0)
  self.tips.transform.position = position + TipsDecVecDelta
end

local function SetTipsActive(self, value)
  if self.tipsActive ~= value then
    self.tipsActive = value
    self.tips:SetActive(value)
  end
end

UITrainDetailView.OnCreate = OnCreate
UITrainDetailView.OnDestroy = OnDestroy
UITrainDetailView.Param = Param
UITrainDetailView.OnEnable = OnEnable
UITrainDetailView.OnDisable = OnDisable
UITrainDetailView.ComponentDefine = ComponentDefine
UITrainDetailView.ComponentDestroy = ComponentDestroy
UITrainDetailView.DataDefine = DataDefine
UITrainDetailView.DataDestroy = DataDestroy
UITrainDetailView.ReInit = ReInit
UITrainDetailView.ShowDetailCells = ShowDetailCells
UITrainDetailView.AddOneDetailCell = AddOneDetailCell
UITrainDetailView.SetTipsActive = SetTipsActive
UITrainDetailView.ShowTip = ShowTip
return UITrainDetailView
