local base = UIBaseContainer
local SeasonSelectLocationAreaComp = BaseClass("SeasonSelectLocationAreaComp", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SeasonSelectLocationAreaComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonSelectLocationAreaComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationAreaComp:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnArea = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnArea:SetOnClick(function()
    self:OnBtnAreaClick()
  end)
  self.textAreaOwner = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textAreaName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function SeasonSelectLocationAreaComp:ComponentDestroy()
  self.viewSkin = nil
  self.btnArea = nil
  self.textAreaOwner = nil
  self.textAreaName = nil
end

function SeasonSelectLocationAreaComp:DataDefine()
end

function SeasonSelectLocationAreaComp:DataDestroy()
end

function SeasonSelectLocationAreaComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSelectLocationPosDataUpdate, self.OnPosDataUpdate)
end

function SeasonSelectLocationAreaComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonSelectLocationPosDataUpdate, self.OnPosDataUpdate)
  base.OnRemoveListener(self)
end

function SeasonSelectLocationAreaComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonSelectLocationAreaComp:InitData(data)
  if data ~= nil then
    self.Data = data
    self.WorldSkinCell = data.WorldSkinCell
    return true
  end
  return false
end

function SeasonSelectLocationAreaComp:InitUi()
  self.textAreaName:SetLocalText(self.WorldSkinCell.aliases)
end

function SeasonSelectLocationAreaComp:UpdateData()
  self.PosData = DataCenter.SeasonSelectLocationManager:GetPosData(self.Data.Pos)
  return true
end

function SeasonSelectLocationAreaComp:UpdateUi()
  if self.PosData ~= nil then
    self.textAreaOwner:SetText(string.format("#%s", self.PosData.ServerId))
  else
    self.textAreaOwner:SetText("")
  end
  self.textAreaOwner:SetColor(self:GetTextColor())
  self.textAreaName:SetColor(self:GetTextColor())
end

function SeasonSelectLocationAreaComp:GetTextColor()
  if self.PosData == nil or self.PosData.ServerId ~= LuaEntry.Player.serverId then
    return Color.New(1, 1, 1)
  else
    return Color.New(0.3803921568627451, 0.9372549019607843, 0.5333333333333333)
  end
end

function SeasonSelectLocationAreaComp:OnBtnAreaClick()
  if self.Data ~= nil then
    local param = {}
    param.Pos = self.Data.Pos
    param.WorldSkinCell = self.WorldSkinCell
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonSelectLocationDetails, {anim = true}, param)
  end
end

function SeasonSelectLocationAreaComp:OnPosDataUpdate(evt)
  if self:UpdateData() then
    self:UpdateUi()
  end
end

return SeasonSelectLocationAreaComp
