local BPDetailBtnContent = BaseClass("BPDetailBtnContent", UIBaseContainer)
local base = UIBaseContainer
local detail_btn_path = "DetailBtn"

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
  self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
  self.detail_btn:SetOnClick(function()
    self:OnClickDetailBtn()
  end)
end

local function ComponentDestroy(self)
  self.detail_btn = nil
end

local function DataDefine(self)
  self.actInfoData = nil
  self.gotoType = nil
  self.gotoParam = nil
end

local function DataDestroy(self)
  self.actInfoData = nil
  self.gotoType = nil
  self.gotoParam = nil
end

local function ReInit(self, actInfoData)
  self.actInfoData = actInfoData
  self.gotoType = nil
  self.gotoParam = nil
  local gotoVal = self.actInfoData.para_7
  if not string.IsNullOrEmpty(gotoVal) then
    local gotoValArr = string.split(gotoVal, "|")
    if #gotoValArr == 2 then
      self.gotoType = gotoValArr[1]
      self.gotoParam = gotoValArr[2]
    end
  end
  self.detail_btn:SetActive(self.gotoType ~= nil)
end

local function OnClickDetailBtn(self)
  if self.gotoType == nil then
    return
  end
  GoToUtil.GoToByTypeAndParam(tonumber(self.gotoType), {
    tonumber(self.gotoParam)
  })
end

BPDetailBtnContent.OnCreate = OnCreate
BPDetailBtnContent.OnDestroy = OnDestroy
BPDetailBtnContent.OnEnable = OnEnable
BPDetailBtnContent.OnDisable = OnDisable
BPDetailBtnContent.ComponentDefine = ComponentDefine
BPDetailBtnContent.ComponentDestroy = ComponentDestroy
BPDetailBtnContent.DataDefine = DataDefine
BPDetailBtnContent.DataDestroy = DataDestroy
BPDetailBtnContent.ReInit = ReInit
BPDetailBtnContent.OnClickDetailBtn = OnClickDetailBtn
return BPDetailBtnContent
