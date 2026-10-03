local p_img_member_icon_path = "p_img_member_icon"
local p_text_member_server_path = "p_text_member_server"
local content_head_path = "content_head"
local p_comp_member_head_path = "content_head/p_comp_member_head"
local p_go_member_cur_path = "p_go_member_cur"
local img_member_num_base_path = "img_member_num_base"
local p_text_member_num_path = "img_member_num_base/p_text_member_num"
local base = UIBaseContainer
local UILWSeasonSelectCampMemberComp = BaseClass("UILWSeasonSelectCampMemberComp", UIBaseContainer)

function UILWSeasonSelectCampMemberComp:ComponentDefine()
  self.p_img_member_icon = self:AddComponent(UIImage, p_img_member_icon_path)
  self.p_text_member_server = self:AddComponent(UITextMeshProUGUIEx, p_text_member_server_path)
  self.content_head = self:AddComponent(UIBaseContainer, content_head_path)
  self.p_comp_member_head = self:AddComponent(UICommonHead, p_comp_member_head_path)
  self.p_go_member_cur = self:AddComponent(UIImage, p_go_member_cur_path)
  self.img_member_num_base = self:AddComponent(UIImage, img_member_num_base_path)
  self.p_text_member_num = self:AddComponent(UITextMeshProUGUIEx, p_text_member_num_path)
end

function UILWSeasonSelectCampMemberComp:ComponentDestroy()
  self.p_img_member_icon = nil
  self.p_text_member_server = nil
  self.content_head = nil
  self.p_comp_member_head = nil
  self.p_go_member_cur = nil
  self.img_member_num_base = nil
  self.p_text_member_num = nil
end

function UILWSeasonSelectCampMemberComp:DataDefine()
end

function UILWSeasonSelectCampMemberComp:DataDestroy()
  self.Data = nil
  self.ServerData = nil
  self.KingInfo = nil
end

function UILWSeasonSelectCampMemberComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonSelectCampMemberComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonSelectCampMemberComp:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonSelectCampMemberComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonSelectCampMemberComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonSelectCampMemberComp:InitData(data)
  if data ~= nil then
    self.Data = data
    if data.ServerData ~= nil then
      self.ServerData = data.ServerData
      if self.ServerData.IsLeaderServer then
        self.KingInfo = self.ServerData.KingInfo
      end
    end
    return true
  end
  return false
end

function UILWSeasonSelectCampMemberComp:InitUi()
  self.p_text_member_server:SetActive(checknumber(self.Data.Num) > 0)
  self.p_text_member_server:SetText(string.format("NO.%s", checknumber(self.Data.Num)))
  self.img_member_num_base:LoadSpriteAsync(self:GetServerBaseImg())
  if self.ServerData ~= nil then
    local serverId = checknumber(self.ServerData.ServerId)
    self.p_text_member_num:SetText(string.format("#%s", serverId))
    local color = serverId == LuaEntry.Player:GetSourceServerId() and "#5FEF87" or "#FFFFFF"
    self.p_text_member_num:SetColorHex(color)
    self.p_img_member_icon:LoadSpriteAsync(DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(serverId))
  end
  if self.KingInfo ~= nil then
    self.p_comp_member_head:SetHead(self.KingInfo.uid, self.KingInfo.pic, self.KingInfo.picVer, nil, nil)
    self.p_comp_member_head:SetEnableClickShowInfo(true, true)
    self.content_head:SetActive(true)
  else
    self.content_head:SetActive(false)
  end
  self.p_go_member_cur:SetActive(self.ServerData ~= nil and self.ServerData.ServerId == LuaEntry.Player:GetSourceServerId())
end

function UILWSeasonSelectCampMemberComp:GetServerBaseImg()
  local index = Mathf.Clamp(checknumber(self.Data.AreaIndex), 0, 2)
  if index == 1 then
    return "Assets/Main/SeasonRes/S6/Sprites/SelectCamp/ljq_s6_fuwuqibg01.png"
  elseif index == 2 then
    return "Assets/Main/SeasonRes/S6/Sprites/SelectCamp/ljq_s6_fuwuqibg02.png"
  end
  return "Assets/Main/SeasonRes/S6/Sprites/SelectCamp/lrb_zhanqvduijue_fuwuqibg01.png"
end

return UILWSeasonSelectCampMemberComp
