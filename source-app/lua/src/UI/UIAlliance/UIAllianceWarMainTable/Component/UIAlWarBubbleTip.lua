local base = UIAsyncContainer
local UIAlWarBubbleTip = BaseClass("UIAlWarBubbleTip", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function UIAlWarBubbleTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIAlWarBubbleTip:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAlWarBubbleTip:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

function UIAlWarBubbleTip:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.btn = nil
  self.textDesc = nil
  self.textTitle = nil
end

function UIAlWarBubbleTip:DataDefine()
  self.eventData = DataCenter.AllianceWarEventDataManager:GetBubbleWarEvent()
end

function UIAlWarBubbleTip:DataDestroy()
  self.eventData = nil
end

function UIAlWarBubbleTip:OnAddListener()
  base.OnAddListener(self)
end

function UIAlWarBubbleTip:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAlWarBubbleTip:OnBtnClick()
  if self.eventData then
    DataCenter.AllianceWarDataManager:OpenALWarMain(true, AllianceWarTabType.WarEvent)
  end
end

function UIAlWarBubbleTip:Init()
  if not self.eventData then
    return
  end
  local eventData = self.eventData
  self.textTitle:SetLocalText(eventData.template.name)
  self.textDesc:SetLocalText(eventData.template.desc)
  local color, icon = Color.white, eventData.template.icon
  if eventData.type == AlWarEventType.ATTACK_OUTPOST_WAR or eventData.type == AlWarEventType.DEFENSE_OUTPOST_WAR then
    local buildMeta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(eventData.buildId)
    if buildMeta then
      local cityFullName = UIUtil.FormatServerAllianceName(eventData.serverId, eventData.abbr, buildMeta:GetFullName())
      self.textDesc:SetLocalText(eventData.template.desc, cityFullName)
      color = eventData.type == AlWarEventType.ATTACK_OUTPOST_WAR and Color.New(0.97, 0.35, 0.4, 1) or Color.New(0.17, 0.65, 1, 1)
      icon = "Assets/Main/Sprites/LodIcon/zyf_daditu_lianmengzhongxin_01_white.png"
    end
  else
    local buildMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(eventData.buildId, eventData.serverId)
    if buildMeta then
      local cityFullName = UIUtil.FormatServerAllianceName(eventData.serverId, eventData.abbr, buildMeta:GetFullName())
      self.textDesc:SetLocalText(eventData.template.desc, cityFullName)
      color = DataCenter.WorldAllianceCityDataManager:GetAllianceLodIconColor(eventData.buildId, buildMeta.type, eventData.point)
      icon = DataCenter.WorldAllianceCityDataManager:GetAllianceLoadIcon(eventData.buildId, buildMeta.type, buildMeta.level)
    end
  end
  self.imgIcon:SetColor(color)
  self.imgIcon:LoadSprite(icon)
  self.imgIcon:SetNativeSize()
end

return UIAlWarBubbleTip
