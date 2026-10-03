local UICommonSpecRemindView = BaseClass("UICommonSpecRemindView", UIBaseView)
local base = UIBaseView
local title_path = "UICommonRewardPopUp/Panel/Title"
local desc_path = "UICommonRewardPopUp/Panel/Desc"
local icon_path = "UICommonRewardPopUp/Panel/BigSkill/Icon"
local goto_btn_path = "UICommonRewardPopUp/Panel/GotoBtn"
local btn_text_path = "UICommonRewardPopUp/Panel/GotoBtn/LW_Btn_Common_New_Base/BtnText"
local title_icon_path = "UICommonRewardPopUp/Panel/Title/TitleIcon"
local ICON_PATH = "Assets/Main/Sprites/UI/LWUIZoneMobilization/%s.png"

function UICommonSpecRemindView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UICommonSpecRemindView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICommonSpecRemindView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "UICommonRewardPopUp/Panel")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title:SetLocalText("zone_mobilization_donated_surprise_popup")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn:SetOnClick(BindCallback(self, self.OnGotoBtnClick))
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
  self.btn_text:SetLocalText("zone_mobilization_donated_go_btn")
  self.title_icon = self:AddComponent(UIImage, title_icon_path)
end

function UICommonSpecRemindView:ComponentDestroy()
  self.title = nil
  self.desc = nil
  self.icon = nil
  self.goto_btn = nil
  self.btn_text = nil
  self.title_icon = nil
end

function UICommonSpecRemindView:DataDefine()
  self.pointId = nil
end

function UICommonSpecRemindView:DataDestroy()
  self.pointId = nil
end

function UICommonSpecRemindView:Init()
  local message = self:GetUserData()
  if message == nil then
    self.ctrl:CloseSelf()
    return
  end
  local configId = message.surpriseId
  if message.type == ZoneMobilizationDonatePushType.ResourcePoint then
    if configId then
      local line = LocalController:instance():tryGetLine(TableName.AllianceMine, configId)
      if line then
        local name = CS.GameEntry.Localization:GetString(line.name)
        self.desc:SetLocalText("zone_mobilization_donated_popup", line.city_level, name)
        local special_flag = line.special_flag
        local type = tonumber(special_flag) == 1 and 0 or 1
        local iconPath = DataCenter.LWZoneMobilizationManager:GetSuppliesIcon(type)
        self.icon:LoadSprite(string.format(ICON_PATH, iconPath))
      end
    end
  elseif message.type == ZoneMobilizationDonatePushType.SuppliesPoint and configId then
    local line = LocalController:instance():tryGetLine(TableName.LWIceSupplies, configId)
    if line then
      local name = CS.GameEntry.Localization:GetString(line.name)
      self.desc:SetLocalText("zone_mobilization_donated_popup", line.level, name)
      local type = line.type == 6 and 0 or 1
      local iconPath = DataCenter.LWZoneMobilizationManager:GetResourceIcon(type)
      self.icon:LoadSprite(string.format(ICON_PATH, iconPath))
    end
  end
  self.pointId = message.pointId
  self.title_icon:LoadSprite(string.format(LoadPath.LWUIZoneMobilizationSpritePath, "ljq_tongyong_zhanqudongyuan_feitingjifen"))
end

function UICommonSpecRemindView:OnGotoBtnClick()
  if self.pointId and self.pointId > 0 then
    local pos = SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
    self.ctrl:CloseSelf()
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(pos)
  end
end

return UICommonSpecRemindView
