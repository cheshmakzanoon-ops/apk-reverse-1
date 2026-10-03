local p_text_sticker_group_title_path = "img/p_text_sticker_group_title"
local p_btn_sticker_group_info_path = "img/p_btn_sticker_group_info"
local base = UIBaseContainer
local UIDecorationStickersAutoTitleCell = BaseClass("UIDecorationStickersAutoTitleCell", UIBaseContainer)

function UIDecorationStickersAutoTitleCell:ComponentDefine()
  self.p_text_sticker_group_title = self:AddComponent(UITextMeshProUGUIEx, p_text_sticker_group_title_path)
  self.p_btn_sticker_group_info = self:AddComponent(UIButton, p_btn_sticker_group_info_path)
  self.p_btn_sticker_group_info:SetOnClick(BindCallback(self, self.OnInfoClicked))
end

function UIDecorationStickersAutoTitleCell:ComponentDestroy()
  self.p_text_sticker_group_title = nil
  self.p_btn_sticker_group_info = nil
end

function UIDecorationStickersAutoTitleCell:DataDefine()
end

function UIDecorationStickersAutoTitleCell:DataDestroy()
end

function UIDecorationStickersAutoTitleCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationStickersAutoTitleCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickersAutoTitleCell:OnAddListener()
  base.OnAddListener(self)
end

function UIDecorationStickersAutoTitleCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDecorationStickersAutoTitleCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UIDecorationStickersAutoTitleCell:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UIDecorationStickersAutoTitleCell:InitUi()
  self.p_text_sticker_group_title:SetText(self.Data.GroupName)
  self.p_btn_sticker_group_info:SetActive(not string.IsNullOrEmpty(self.Data.Info))
end

function UIDecorationStickersAutoTitleCell:OnInfoClicked()
  if self.Data ~= nil and not string.IsNullOrEmpty(self.Data.Info) then
    local data = {}
    data.TargetPos = self.p_btn_sticker_group_info.transform.position
    data.Desc = CS.GameEntry.Localization:GetString(self.Data.Info)
    EventManager:GetInstance():Broadcast(EventId.DecorationStickerAutoStickerGroupInfo, data)
  end
end

return UIDecorationStickersAutoTitleCell
