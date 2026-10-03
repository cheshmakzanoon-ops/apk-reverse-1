local p_img_camp_result_path = "p_img_camp_result"
local p_comp_member_1_path = "trans_member_root/p_comp_member_1"
local p_comp_member_2_path = "trans_member_root/p_comp_member_2"
local p_comp_member_3_path = "trans_member_root/p_comp_member_3"
local p_comp_member_4_path = "trans_member_root/p_comp_member_4"
local UILWSeasonSelectCampMemberComp = require("UI.LWSeason6.UILWSeasonSelectCamp.Comp.Select.UILWSeasonSelectCampMemberComp")
local base = UIBaseContainer
local UILWSeasonSelectCampCampComp = BaseClass("UILWSeasonSelectCampCampComp", UIBaseContainer)

function UILWSeasonSelectCampCampComp:ComponentDefine()
  self.p_img_camp_result = self:AddComponent(UIImage, p_img_camp_result_path)
  self.p_btn_camp_result = self:AddComponent(UIButton, p_img_camp_result_path)
  self.p_btn_camp_result:SetOnClick(BindCallback(self, self.OnClickCampResultBtn))
  self.p_comp_member_1 = self:AddComponent(UILWSeasonSelectCampMemberComp, p_comp_member_1_path)
  self.p_comp_member_2 = self:AddComponent(UILWSeasonSelectCampMemberComp, p_comp_member_2_path)
  self.p_comp_member_3 = self:AddComponent(UILWSeasonSelectCampMemberComp, p_comp_member_3_path)
  self.p_comp_member_4 = self:AddComponent(UILWSeasonSelectCampMemberComp, p_comp_member_4_path)
  self.comp_members = {
    self.p_comp_member_1,
    self.p_comp_member_2,
    self.p_comp_member_3,
    self.p_comp_member_4
  }
end

function UILWSeasonSelectCampCampComp:ComponentDestroy()
  self.p_img_camp_result = nil
  self.p_comp_member_1 = nil
  self.p_comp_member_2 = nil
  self.p_comp_member_3 = nil
  self.p_comp_member_4 = nil
end

function UILWSeasonSelectCampCampComp:DataDefine()
end

function UILWSeasonSelectCampCampComp:DataDestroy()
end

function UILWSeasonSelectCampCampComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonSelectCampCampComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonSelectCampCampComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSelectCampSelectIdUpdate, self.OnSelectIdUpdateEvt)
end

function UILWSeasonSelectCampCampComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonSelectCampSelectIdUpdate, self.OnSelectIdUpdateEvt)
  base.OnRemoveListener(self)
end

function UILWSeasonSelectCampCampComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function UILWSeasonSelectCampCampComp:InitData(data)
  if data ~= nil then
    self.Data = data
    self.CampData = data.CampData
    return self.CampData ~= nil
  end
  return false
end

function UILWSeasonSelectCampCampComp:InitUi()
  for i = 1, 4 do
    local memberData = {}
    memberData.Num = i
    memberData.ServerData = self.CampData:GetMemberByIndex(i)
    self.comp_members[i]:ReInit(memberData)
  end
end

function UILWSeasonSelectCampCampComp:UpdateData()
  local infoData = DataCenter.SeasonSelectCampManager.InfoData
  if infoData ~= nil and self.CampData ~= nil then
    self.CampData = infoData:GetCampDataByPos(checknumber(self.CampData.Pos))
    return self.CampData ~= nil
  end
  return false
end

function UILWSeasonSelectCampCampComp:UpdateUi()
  self.p_img_camp_result:LoadSpriteAsync(self.CampData:GetSelectIcon(true))
end

function UILWSeasonSelectCampCampComp:OnSelectIdUpdateEvt(evt)
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function UILWSeasonSelectCampCampComp:OnClickCampResultBtn()
  if not DataCenter.SeasonSelectCampManager:IsSelectState() then
    return
  end
  if DataCenter.SeasonSelectCampManager.InfoData ~= nil then
    local param = {}
    param.Title = CS.GameEntry.Localization:GetString("302027")
    param.ViewMode = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.S6SelectCampSelectView, {anim = true}, param)
  end
end

return UILWSeasonSelectCampCampComp
