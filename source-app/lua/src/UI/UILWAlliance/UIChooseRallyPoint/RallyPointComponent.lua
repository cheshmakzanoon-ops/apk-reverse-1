local base = UIBaseContainer
local RallyPointComponent = BaseClass("RallyPointComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function RallyPointComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RallyPointComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RallyPointComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgFlag = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgRecommend = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgCheckmark = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textPosition = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnToggle = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnToggle:SetOnClick(function()
    self:OnBtnToggleClick()
  end)
end

function RallyPointComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgFlag = nil
  self.imgRecommend = nil
  self.imgCheckmark = nil
  self.textPosition = nil
  self.btnToggle = nil
end

function RallyPointComponent:DataDefine()
end

function RallyPointComponent:DataDestroy()
  self.data = nil
end

function RallyPointComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChangeSelectRallyPoint, self.OnChangeSelectRallyPoint)
end

function RallyPointComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.ChangeSelectRallyPoint, self.OnChangeSelectRallyPoint)
  base.OnRemoveListener(self)
end

function RallyPointComponent:SetData(data, isRecommend)
  self.data = data
  self.isRecommend = isRecommend
  self.isSelected = isRecommend
end

function RallyPointComponent:UpdateData()
  local v2 = SceneUtils.IndexToTilePos(self.data:GetPointIndex(), ForceChangeScene.World)
  self.textPosition:SetText(string.format("#%s %s(%s,%s)", self.data.server, LuaEntry.Player:GetAllianceAbbr() or "", v2.x, v2.y))
  self.imgRecommend:SetActive(self.isRecommend)
  self.imgCheckmark:SetActive(self.isSelected)
  if self.data.type == MarkType.Alliance_rally then
    self.imgFlag:LoadSpriteAsync("Assets/Main/Sprites/UI/UIAllianceMark/zyf_lianmengjijiedian_biaoji.png")
  elseif self.data.type == MarkType.Alliance_OtherServerRally then
    self.imgFlag:LoadSpriteAsync("Assets/Main/Sprites/UI/UIAllianceMark/zyf_lianmengjijiedian_biaoji 1.png")
  end
end

function RallyPointComponent:OnBtnToggleClick()
  if self.isSelected then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.ChangeSelectRallyPoint, self.data.type)
end

function RallyPointComponent:OnChangeSelectRallyPoint(type)
  self.isSelected = self.data and self.data.type == type
  self.imgCheckmark:SetActive(self.isSelected)
end

return RallyPointComponent
