local UILWAllianceLogItem = BaseClass("UILWAllianceLogItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local bg_path = "bg"
local bg_icon_path = "bgIcon"
local bg_color_path = "bgColor"
local txt_time_path = "Txt_Time"
local txt_des_path = "Txt_Des"

function UILWAllianceLogItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAllianceLogItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWAllianceLogItem:ComponentDefine()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(function()
    self:onJumpToPos()
  end)
  self.bg_icon = self:AddComponent(UIImage, bg_icon_path)
  self.bg_color = self:AddComponent(UIImage, bg_color_path)
  self.txt_time = self:AddComponent(UIText, txt_time_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_des:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
end

function UILWAllianceLogItem:ComponentDestroy()
  self.bg = nil
  self.bg_icon = nil
  self.txt_time = nil
  self.txt_des = nil
end

function UILWAllianceLogItem:DataDefine()
  self.pos = nil
end

function UILWAllianceLogItem:DataDestroy()
  self.pos = nil
end

function UILWAllianceLogItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAllianceLogItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAllianceLogItem:SetItem(logInfo)
  if logInfo == nil then
    return
  end
  if string.IsNullOrEmpty(logInfo.icon) then
    self.bg_icon:SetActive(false)
  else
    self.bg_icon:SetActive(true)
    self.bg_icon:LoadSprite(string.find(logInfo.icon, "^Assets/Main") == 1 and logInfo.icon or string.format("Assets/Main/Sprites/UI/UILWAllianceLog/%s", logInfo.icon))
    self.bg_icon:SetNativeSize()
  end
  if string.IsNullOrEmpty(logInfo.color) then
    self.bg_color:SetActive(false)
  else
    self.bg_color:SetActive(true)
    self.bg_color:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWAllianceLog/%s", logInfo.color))
  end
  self.txt_des:SetText(logInfo:GetStrLog(true))
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(logInfo.time))
  self.pos = logInfo:GetPos()
end

function UILWAllianceLogItem:onJumpToPos()
  if self.pos ~= nil then
    if not SceneUtils.CheckCanGotoWorld() then
      return
    end
    local rightPos = SceneUtils.TileIndexToWorld(self.pos, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(rightPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
    end)
  end
end

function UILWAllianceLogItem:OnPointerClick(clickPos)
  if self.txt_des == nil then
    return
  end
  local linkId = self.txt_des:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    self:onJumpToPos()
  elseif string.find(linkId, "http:") or string.find(linkId, "https:") then
    CS.SDKManager.OpenURL(linkId)
  else
    local linkMsg = base64.decode(linkId)
    linkMsg = rapidjson.decode(linkMsg)
    GoToUtil.TryJumpToWorld(linkMsg)
  end
end

return UILWAllianceLogItem
