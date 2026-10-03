local base = UIBaseContainer
local SeasonSelectLocationMapComp = BaseClass("SeasonSelectLocationMapComp", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local SeasonSelectLocationAreaComp = require("UI.LWSeason5.SeasonSelectLocation.Comp.SeasonSelectLocationAreaComp")

function SeasonSelectLocationMapComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonSelectLocationMapComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationMapComp:ComponentDefine()
  local content_path = "p_pos_content"
  self.compAreas = {}
  for i = 1, 9 do
    local index = i
    local templatePath = string.format("%s/p_pos_%s/p_pos_template_%s", content_path, i, i)
    local comp = {}
    comp.TextArea = self:AddComponent(UITextMeshProUGUIEx, string.format("%s/p_text_area_name_%s", templatePath, i))
    comp.TextServer = self:AddComponent(UITextMeshProUGUIEx, string.format("%s/p_text_area_owner_%s", templatePath, i))
    comp.GoCur = self:AddComponent(UIBaseContainer, string.format("%s/p_go_area_cur_%s", templatePath, i))
    comp.BtnArea = self:AddComponent(UIButton, string.format("%s/p_btn_area_%s", templatePath, i))
    comp.BtnArea:SetOnClick(function()
      self:OnBtnAreaClick(index)
    end)
    table.insert(self.compAreas, comp)
  end
end

function SeasonSelectLocationMapComp:OnBtnAreaClick(pos)
  if self.WorldSkinCells == nil then
    return
  end
  if DataCenter.SeasonSelectLocationManager.PosData == nil then
    return
  end
  local skinCell = self.WorldSkinCells[pos]
  if skinCell ~= nil then
    local param = {}
    param.Pos = pos
    param.WorldSkinCell = skinCell
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonSelectLocationDetails, {anim = true}, param)
  end
end

function SeasonSelectLocationMapComp:ComponentDestroy()
end

function SeasonSelectLocationMapComp:DataDefine()
  self.NamePrefix = "comp_%s_%s"
  self.NameIndex = 0
end

function SeasonSelectLocationMapComp:DataDestroy()
end

function SeasonSelectLocationMapComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSelectLocationPosDataUpdate, self.OnPosDataUpdate)
end

function SeasonSelectLocationMapComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonSelectLocationPosDataUpdate, self.OnPosDataUpdate)
  base.OnRemoveListener(self)
end

function SeasonSelectLocationMapComp:ReInit()
  if self:InitData() then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonSelectLocationMapComp:InitData()
  return true
end

function SeasonSelectLocationMapComp:InitUi()
end

function SeasonSelectLocationMapComp:UpdateData()
  self.WorldSkinCells = DataCenter.SeasonSelectLocationManager:GetWorldSkinCells()
  return not table.IsNullOrEmpty(self.WorldSkinCells)
end

function SeasonSelectLocationMapComp:UpdateUi()
  for i = 1, 9 do
    local comp = self.compAreas[i]
    local skinCell = self.WorldSkinCells[i]
    local posData = DataCenter.SeasonSelectLocationManager:GetPosData(i)
    if comp ~= nil and skinCell ~= nil then
      comp.TextArea:SetLocalText(skinCell.aliases)
      if posData ~= nil and i ~= 5 then
        comp.TextServer:SetActive(true)
        comp.TextServer:SetText(string.format("#%s", posData.ServerId))
        comp.TextServer:SetColor(self:GetTextColor(posData.ServerId))
        comp.TextArea:SetColor(self:GetTextColor(posData.ServerId))
        comp.GoCur:SetActive(posData.ServerId == LuaEntry.Player.serverId)
      else
        comp.TextServer:SetActive(false)
        comp.TextArea:SetColor(self:GetTextColor(0))
        comp.GoCur:SetActive(false)
      end
    end
  end
end

function SeasonSelectLocationMapComp:GetTextColor(serverId)
  if serverId ~= LuaEntry.Player.serverId then
    return Color.New(1, 1, 1)
  else
    return Color.New(0.3803921568627451, 0.9372549019607843, 0.5333333333333333)
  end
end

function SeasonSelectLocationMapComp:OnPosDataUpdate()
  if self:UpdateData() then
    self:UpdateUi()
  end
end

return SeasonSelectLocationMapComp
