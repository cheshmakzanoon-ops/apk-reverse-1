local UIGhostreconRewardRecordBtn = BaseClass("UIGhostreconRewardRecordBtn", UIBaseContainer)
local base = UIBaseContainer

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
  self.btn = self:AddComponent(UIButton, "RecordBtn")
  self.btnText = self:AddComponent(UIText, "RecordBtn/StealRecordBtnText")
  self.btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconRecord, {anim = true}, self.stealData)
  end)
  self.btnText:SetLocalText("ghostrecon_btn04")
  self.zanBtn = self:AddComponent(UIButton, "ZanBtn")
  self.zanBtnText = self:AddComponent(UIText, "ZanBtn/ZanBtnText")
  self.zanBtn:SetOnClick(function()
    if self.zan then
      UIUtil.ShowTipsId("120289")
    else
      self.zan = true
      self.view:ZanAll()
      CS.UIGray.SetGray(self.zanBtn.transform, true, true)
    end
  end)
  CS.UIGray.SetGray(self.zanBtn.transform, false, true)
  self.zanBtnText:SetLocalText("ghostrecon_btn13")
end

local function ComponentDestroy(self)
  self.btn = nil
  self.btnText = nil
  self.zanBtn = nil
  self.zanBtnText = nil
end

local function DataDefine(self)
  self.zan = false
end

local function DataDestroy(self)
  self.stealData = nil
  self.memberList = nil
  self.zan = false
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function SetItem(self, data)
  if data then
    self.stealData = data
    if self.stealData and #self.stealData > 0 then
      self.btn:SetActive(true)
    else
      self.btn:SetActive(false)
    end
    self.memberList = data.memberList
    if self.memberList and 0 < #self.memberList then
      self.zanBtn:SetActive(true)
    else
      self.zanBtn:SetActive(false)
    end
  end
end

UIGhostreconRewardRecordBtn.OnCreate = OnCreate
UIGhostreconRewardRecordBtn.OnDestroy = OnDestroy
UIGhostreconRewardRecordBtn.OnEnable = OnEnable
UIGhostreconRewardRecordBtn.OnDisable = OnDisable
UIGhostreconRewardRecordBtn.ComponentDefine = ComponentDefine
UIGhostreconRewardRecordBtn.ComponentDestroy = ComponentDestroy
UIGhostreconRewardRecordBtn.DataDefine = DataDefine
UIGhostreconRewardRecordBtn.DataDestroy = DataDestroy
UIGhostreconRewardRecordBtn.OnAddListener = OnAddListener
UIGhostreconRewardRecordBtn.OnRemoveListener = OnRemoveListener
UIGhostreconRewardRecordBtn.SetItem = SetItem
return UIGhostreconRewardRecordBtn
