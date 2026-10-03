local base = UIAsyncContainer
local FishPondTipCellComponent = BaseClass("FishPondTipCellComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function FishPondTipCellComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FishPondTipCellComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FishPondTipCellComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPosTxt = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPosTxt:SetOnClick(function()
    self:OnBtnPosTxtClick()
  end)
  self.textPosTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textNameTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textAbbrTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

function FishPondTipCellComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnPosTxt = nil
  self.textPosTxt = nil
  self.textNameTxt = nil
  self.textAbbrTxt = nil
end

function FishPondTipCellComponent:DataDefine()
end

function FishPondTipCellComponent:DataDestroy()
  self.pond = nil
  self.pos = nil
end

function FishPondTipCellComponent:OnAddListener()
  base.OnAddListener(self)
end

function FishPondTipCellComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FishPondTipCellComponent:OnBtnPosTxtClick()
  DataCenter.LWSoundManager:PlaySound(6100025, false)
  if self.pos then
    local worldPos = SceneUtils.TileToWorld(self.pos, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(worldPos, nil, nil, nil, self.serverId, 0)
    GoToUtil.CloseAllWindows()
  end
end

function FishPondTipCellComponent:SetData(pond)
  self.pond = pond
end

function FishPondTipCellComponent:UpdateData()
  local pond = self.pond
  if not pond then
    return
  end
  if pond.cityTemplate == nil then
    pond.cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(pond.pondId)
  end
  local cityTemplate = pond.cityTemplate
  if cityTemplate == nil then
    return
  end
  self.textAbbrTxt:SetText(UIUtil.FormatServerAllianceName(pond.serverId, pond.abbr))
  self.textNameTxt:SetText(pond.allianceName)
  self.pos = cityTemplate.pos
  if pond.pondServerId == nil then
    pond.pondServerId = cityTemplate:GetServerIdByEnum(ServerEnum.Source)
  end
  self.serverId = pond.pondServerId
  self.textPosTxt:SetText(UIUtil.FormatServerPosition(self.serverId, self.pos.x, self.pos.y))
end

return FishPondTipCellComponent
