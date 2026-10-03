local UILWCityBuffSourceItem = BaseClass("UILWCityBuffSourceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWCityBuffSourceItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIRawImage, "icon")
  self.pos = self:AddComponent(UITextMeshProUGUIEx, "pos")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.goto_btn = self:AddComponent(UIButton, "gotoBtn")
  self.icon_btn = self:AddComponent(UIButton, "icon")
  self.text = self:AddComponent(UITextMeshProUGUIEx, "gotoBtn/Text")
  self.goto_btn:SetOnClick(function()
    self:GotoBuildPos()
  end)
  self.icon_btn:SetOnClick(function()
    self:GotoBuildPos()
  end)
end

function UILWCityBuffSourceItem:OnDestroy()
  self.icon = nil
  self.pos = nil
  self.name = nil
  self.desc = nil
  self.goto_btn = nil
  self.text = nil
  base.OnDestroy(self)
end

function UILWCityBuffSourceItem:GotoBuildPos()
  if self.data and self.buildData then
    local serverId = toInt(self.data.allianceServerId)
    local worldPointPos = SceneUtils.TileIndexToWorld(toInt(self.data.pointId), ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom, 0.2, nil, serverId, 0)
    TimerManager:GetInstance():DelayInvoke(function()
      local uiPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPointPos)
      local param = {}
      param.position = Vector3.New(uiPos.x, uiPos.y, uiPos.z)
      param.arrowType = ArrowType.Building
      param.positionType = PositionType.Screen
      param.isPanel = false
      param.isAutoClose = 2
      DataCenter.ArrowManager:ShowArrow(param)
    end, 0.5)
  end
end

function UILWCityBuffSourceItem:ReInit(index, data, buildData)
  self.data = data
  self.buildData = buildData
  local serverId = toInt(self.data.allianceServerId)
  local tilePos = SceneUtils.IndexToTilePos(toInt(self.data.pointId), ForceChangeScene.World)
  local targetStr = string.format("<u>%s</u>", UIUtil.FormatServerPosition(serverId, tilePos.x, tilePos.y))
  self.icon:LoadSprite(buildData:GetIconPath())
  self.pos:SetText(targetStr)
  self.name:SetText(string.format("%s (%s)", Localization:GetString(buildData.name), data.abbr))
  self.desc:SetText(buildData:GetDesc())
  self.text:SetLocalText("450037")
end

return UILWCityBuffSourceItem
