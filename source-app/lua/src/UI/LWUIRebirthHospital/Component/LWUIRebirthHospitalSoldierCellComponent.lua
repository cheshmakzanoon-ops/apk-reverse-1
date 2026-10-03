local LWUIRebirthHospitalSoldierCellComponent = BaseClass("LWUIRebirthHospitalSoldierCellComponent", UIBaseContainer)
local UISoldierItem = require("UI/UIBuildDispatching/Component/UISoldierItem")
local base = UIBaseContainer

function LWUIRebirthHospitalSoldierCellComponent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUIRebirthHospitalSoldierCellComponent:ComponentDefine()
  self.objInRebirth = self:AddComponent(UIBaseContainer, "ContentInRebirth")
  self.objDead = self:AddComponent(UIBaseContainer, "ContentDead")
  self.sliderInRebirth = self:AddComponent(UISlider, "ContentInRebirth/InRebirthSlider")
  self.textCountInRebirth = self:AddComponent(UIText, "ContentInRebirth/InRebirthCountText")
  self.sliderDead = self:AddComponent(UISlider, "ContentDead/Slider")
  self.sliderDead:SetOnValueChanged(function(value)
    self:OnCountSliderValueChanged(value)
  end)
  self.textCountDead = self:AddComponent(UIText, "ContentDead/count_text")
  self.soldierDetail = self:AddComponent(UISoldierItem, "UISoldierDetails_Item")
  self.objSoldierLevel = self:AddComponent(UIBaseContainer, "UISoldierDetails_Item/WorkerLevelText")
  self.btnAdd = self:AddComponent(UIButton, "ContentDead/addBtn")
  self.btnSubtract = self:AddComponent(UIButton, "ContentDead/subtractBtn")
  self.btnAdd:SetOnClick(function()
    self:OnAddBtnClick()
  end)
  self.btnSubtract:SetOnClick(function()
    self:OnSubtractBtnClick()
  end)
end

function LWUIRebirthHospitalSoldierCellComponent:ReInit(param)
  self.info = param
  if self.info == nil then
    return
  end
  self.callBack = param.callback
  self.index = param.index
  local elevenData = T11Util.GetSelfCurSoldierData()
  self.soldierDetail:SetData(DataCenter.SoldierDataManager:GetTemplate(self.info.armyId), elevenData)
  local isShowDead = self.info:GetRebirthCount() <= 0
  self.objDead:SetActive(isShowDead)
  self.objInRebirth:SetActive(not isShowDead)
  if isShowDead then
    self.sliderDead.unity_uislider.maxValue = self.info:GetDeadCount()
    self.sliderDead.unity_uislider.minValue = 0
    self.textCountDead:SetText(tostring(param.curCount or 0) .. "/" .. tostring(math.floor(self.sliderDead.unity_uislider.maxValue)))
    self.sliderDead:SetValue(param.curCount)
    self.objSoldierLevel:SetLocalPosition(Vector3.New(self.objSoldierLevel:GetLocalPosition().x, 36, self.objSoldierLevel:GetLocalPosition().z))
  else
    local curValue = self.info:GetCurRebirthProgress()
    local totalValue = self.info:GetRebirthCount()
    if totalValue ~= 0 then
      self.sliderInRebirth:SetValue(curValue / totalValue)
      self.textCountInRebirth:SetText(tostring(totalValue))
    else
      self.objInRebirth:SetActive(false)
    end
    self.objSoldierLevel:SetLocalPosition(Vector3.New(self.objSoldierLevel:GetLocalPosition().x, 18.2, self.objSoldierLevel:GetLocalPosition().z))
  end
end

function LWUIRebirthHospitalSoldierCellComponent:OnCountSliderValueChanged(value)
  local number = math.floor(value)
  if self.callBack ~= nil then
    self.callBack(self.info, number)
  end
  self.textCountDead:SetText(tostring(number) .. "/" .. tostring(math.floor(self.sliderDead.unity_uislider.maxValue)))
end

function LWUIRebirthHospitalSoldierCellComponent:OnAddBtnClick()
  if self.sliderDead.unity_uislider.value < self.sliderDead.unity_uislider.maxValue then
    self.sliderDead:SetValue(self.sliderDead.unity_uislider.value + 1)
  end
end

function LWUIRebirthHospitalSoldierCellComponent:OnSubtractBtnClick()
  if self.sliderDead.unity_uislider.value > self.sliderDead.unity_uislider.minValue then
    self.sliderDead:SetValue(self.sliderDead.unity_uislider.value - 1)
  end
end

function LWUIRebirthHospitalSoldierCellComponent:DataDefine()
  self.info = nil
  self.callBack = nil
  self.index = nil
end

function LWUIRebirthHospitalSoldierCellComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIRebirthHospitalSoldierCellComponent:DataDestroy()
  self.info = nil
  self.callBack = nil
  self.index = nil
end

function LWUIRebirthHospitalSoldierCellComponent:ComponentDestroy()
  self.slider = nil
  self.count_text = nil
  self.soldierDetail = nil
  self.addBtn = nil
  self.subtractBtn = nil
end

return LWUIRebirthHospitalSoldierCellComponent
