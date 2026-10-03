local GMLogPanelItemRenderer = BaseClass("GMLogPanelItemRenderer", UIBaseContainer)
local base = UIBaseContainer
local gray_path = "Gray"
local icon_path = "Icon"
local tmp_time_path = "TmpTime"
local tmp_detail_path = "TmpDetail"

local function OnCreate(self)
  base.OnCreate(self)
  self.gray = self:AddComponent(UIImage, gray_path)
  self.imgIcon = self:AddComponent(UIImage, icon_path)
  self.tmpTime = self:AddComponent(UIText, tmp_time_path)
  self.tmpDetail = self:AddComponent(UIText, tmp_detail_path)
  self.btnSelf = self:AddComponent(UIButton, self.gameObject)
  self.btnSelf:SetOnClick(BindCallback(self, self.ShowDetail))
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

function GMLogPanelItemRenderer:SetData(index, data, host)
  self.index = index
  self.host = host
  self.data = data
  self.gray:SetAlpha(index % 2 == 0 and 0.3 or 0.7)
  self.tmpTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(data.time))
  self.tmpDetail:SetText(data.truncatedCondition)
  local icon = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_jinggao.png"
  if data.logType ~= 2 then
    icon = "Assets/Main/Sprites/UI/LWUITacticalWeaponChip/FX_wurenjixingpian_jianhao.png"
  end
  self.imgIcon:LoadSpriteAuto(icon)
end

function GMLogPanelItemRenderer:ShowDetail()
  if self.host then
    self.host:ShowSingleLog(self.data)
  end
end

GMLogPanelItemRenderer.OnCreate = OnCreate
GMLogPanelItemRenderer.OnDestroy = OnDestroy
GMLogPanelItemRenderer.OnEnable = OnEnable
GMLogPanelItemRenderer.OnDisable = OnDisable
return GMLogPanelItemRenderer
