local base = UIBaseContainer
local PondCellComponent = BaseClass("PondCellComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function PondCellComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function PondCellComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PondCellComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTxtLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textMemberTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnPos = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnPos:SetOnClick(function()
    self:OnBtnPosClick()
  end)
end

function PondCellComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textTxtLevel = nil
  self.textMemberTxt = nil
  self.text = nil
  self.btnPos = nil
end

function PondCellComponent:DataDefine()
end

function PondCellComponent:DataDestroy()
end

function PondCellComponent:OnAddListener()
  base.OnAddListener(self)
end

function PondCellComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function PondCellComponent:OnBtnPosClick()
  DataCenter.LWSoundManager:PlaySound(6100025, false)
  local worldPos = SceneUtils.TileToWorld(self.pos, ForceChangeScene.World)
  GoToUtil.GotoWorldPos(worldPos, nil, nil, nil, self.serverId, 0)
  GoToUtil.CloseAllWindows()
end

function PondCellComponent:SetData(pond)
  local cityTemplate = pond.cityTemplate
  if cityTemplate == nil then
    return
  end
  self.imgIcon:LoadSpriteAsync(cityTemplate:GetIconPath())
  if string.IsNullOrEmpty(pond.allianceId) then
    self.textTxtLevel:SetLocalText("456519")
  else
    self.textTxtLevel:SetText(UIUtil.FormatServerAllianceName(pond.serverId, pond.abbr))
  end
  self.textMemberTxt:SetText(pond.fishPlayerNum .. "/" .. cityTemplate.max_fisher)
  self.pos = cityTemplate.pos
  if pond.pondServerId == nil then
    pond.pondServerId = cityTemplate:GetServerIdByEnum(ServerEnum.Source)
  end
  self.serverId = pond.pondServerId
  self.text:SetText(UIUtil.FormatServerPosition(self.serverId, self.pos.x, self.pos.y))
  local myCamp = DataCenter.SeasonFactionWarDataManager.myCampId
  if pond.campId == 3 or pond.campId == 0 then
    self.textTxtLevel:SetColorRGBA(1, 1, 1, 1)
  elseif myCamp == pond.campId then
    self.textTxtLevel:SetColorRGBA(0.37, 0.94, 0.53, 1)
  else
    self.textTxtLevel:SetColorRGBA(1, 0.44, 0.47, 1)
  end
end

return PondCellComponent
