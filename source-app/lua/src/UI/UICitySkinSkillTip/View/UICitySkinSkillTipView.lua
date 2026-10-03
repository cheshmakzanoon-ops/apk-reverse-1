local UICitySkinSkillTipView = BaseClass("UICitySkinSkillTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local content_pos_path = "ContentPos"
local contentbg_path = "Contentbg"
local tip1_path = "Contentbg/tip1"
local tip2_path = "Contentbg/tip2"
local status_icon_path = "Contentbg/statusIcon"
local waitTime = 4
local closeTime = 0.3

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.content_pos = self:AddComponent(UIBaseContainer, content_pos_path)
  self.contentbg = self:AddComponent(UIRawImage, contentbg_path)
  self.tip1 = self:AddComponent(UITextMeshProUGUIEx, tip1_path)
  self.tip2 = self:AddComponent(UITextMeshProUGUIEx, tip2_path)
  self.status_icon = self:AddComponent(UIImage, status_icon_path)
  self.contentbg.transform:DOKill()
end

local function ComponentDestroy(self)
  self.contentbg.transform:DOKill()
  self.content_pos = nil
  self.contentbg = nil
  self.tip1 = nil
  self.tip2 = nil
  self.status_icon = nil
end

local function DataDefine(self)
  self.seq = nil
  self.waitTime = waitTime
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  self.statusId = self:GetUserData()
  self.contentbg:SetLocalScaleXYZ(1, 1, 1)
  self.contentbg.transform.position = self.content_pos.transform.position
  self.tip1:SetText("")
  if self.statusId and self.statusId > 0 then
    local name = GetTableData(TableName.StatusTab, self.statusId, "name") or ""
    self.tip1:SetLocalText(name)
    local icon = GetTableData(TableName.StatusTab, self.statusId, "icon") or ""
    self.status_icon:LoadSprite(icon)
  end
  self:Update1000MS()
end

local function Update1000MS(self)
  if self.waitTime >= 0 then
    self.waitTime = self.waitTime - 1
    self.tip2:SetLocalText("close_tips1", self.waitTime)
    if self.waitTime == 0 then
      local pos = self.contentbg.position
      local mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
      if mainUI and mainUI.View then
        pos = mainUI.View:GetBuffIconPosByIndex(1)
      end
      self.contentbg.transform:DOScale(Vector3(0, 0, 0), closeTime)
      self.contentbg.transform:DOMove(pos, closeTime)
    elseif self.waitTime == -1 then
      self.ctrl:CloseSelf()
    end
  else
    self.ctrl:CloseSelf()
  end
end

UICitySkinSkillTipView.OnCreate = OnCreate
UICitySkinSkillTipView.OnDestroy = OnDestroy
UICitySkinSkillTipView.OnEnable = OnEnable
UICitySkinSkillTipView.OnDisable = OnDisable
UICitySkinSkillTipView.ComponentDefine = ComponentDefine
UICitySkinSkillTipView.ComponentDestroy = ComponentDestroy
UICitySkinSkillTipView.DataDefine = DataDefine
UICitySkinSkillTipView.DataDestroy = DataDestroy
UICitySkinSkillTipView.ReInit = ReInit
UICitySkinSkillTipView.Update1000MS = Update1000MS
return UICitySkinSkillTipView
