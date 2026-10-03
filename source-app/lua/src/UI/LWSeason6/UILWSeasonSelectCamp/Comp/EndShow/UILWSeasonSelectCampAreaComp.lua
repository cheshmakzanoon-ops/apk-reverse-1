local p_img_member_icon_path = "p_img_member_icon"
local p_img_member_num_base_path = "p_img_member_num_base"
local p_text_member_num_path = "p_img_member_num_base/p_text_member_num"
local p_go_member_cur_path = "p_go_member_cur"
local p_text_member_no_path = "p_text_member_No"
local base = UIBaseContainer
local UILWSeasonSelectCampAreaComp = BaseClass("UILWSeasonSelectCampAreaComp", UIBaseContainer)

function UILWSeasonSelectCampAreaComp:ComponentDefine()
  self.p_img_base = self:AddComponent(UIImage, "")
  self.p_img_member_icon = self:AddComponent(UIImage, p_img_member_icon_path)
  self.p_img_member_num_base = self:AddComponent(UIImage, p_img_member_num_base_path)
  self.p_text_member_num = self:AddComponent(UITextMeshProUGUIEx, p_text_member_num_path)
  self.p_go_member_cur = self:AddComponent(UIImage, p_go_member_cur_path)
  self.p_text_member_no = self:AddComponent(UITextMeshProUGUIEx, p_text_member_no_path)
end

function UILWSeasonSelectCampAreaComp:ComponentDestroy()
  self.p_img_base = nil
  self.p_img_member_icon = nil
  self.p_img_member_num_base = nil
  self.p_text_member_num = nil
  self.p_go_member_cur = nil
  self.p_text_member_no = nil
end

function UILWSeasonSelectCampAreaComp:DataDefine()
  self.Index2Color = {
    [1] = "#5AA763",
    [2] = "#2F91B1"
  }
end

function UILWSeasonSelectCampAreaComp:DataDestroy()
end

function UILWSeasonSelectCampAreaComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonSelectCampAreaComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonSelectCampAreaComp:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonSelectCampAreaComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonSelectCampAreaComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonSelectCampAreaComp:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UILWSeasonSelectCampAreaComp:InitUi()
  self.p_img_base:SetColorHex(self.Index2Color[self.Data.AreaIndex])
  self.p_img_member_num_base:LoadSpriteAsync(self:GetServerBaseImg())
  self.p_text_member_num:SetText(string.format("#%s", self.Data.ServerId))
  local color = self.Data.ServerId == LuaEntry.Player:GetSourceServerId() and "#5FEF87" or "#FFFFFF"
  self.p_text_member_num:SetColorHex(color)
  self.p_go_member_cur:SetActive(self.Data.ServerId == LuaEntry.Player:GetSourceServerId())
  self.p_img_member_icon:LoadSpriteAsync(DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(self.Data.ServerId))
  self.p_text_member_no:SetTextFormat("NO.%s", self.Data.No)
end

function UILWSeasonSelectCampAreaComp:GetServerBaseImg()
  local index = Mathf.Clamp(checknumber(self.Data.AreaIndex), 0, 2)
  if index == 1 then
    return "Assets/Main/SeasonRes/S6/Sprites/SelectCamp/ljq_s6_fuwuqibg01.png"
  elseif index == 2 then
    return "Assets/Main/SeasonRes/S6/Sprites/SelectCamp/ljq_s6_fuwuqibg02.png"
  end
  return "Assets/Main/SeasonRes/S6/Sprites/SelectCamp/lrb_zhanqvduijue_fuwuqibg01.png"
end

return UILWSeasonSelectCampAreaComp
