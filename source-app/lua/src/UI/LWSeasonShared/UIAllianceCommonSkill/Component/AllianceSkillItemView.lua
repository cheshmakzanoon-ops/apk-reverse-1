local base = UIBaseContainer
local AllianceSkillItemView = BaseClass("AllianceSkillItemView", base)
local img_icon_path = "img_kuang/img_icon"
local txt_name_path = "txt_name"
local txt_cost_path = "txt_cost"
local txt_cd_path = "unlock/txt_cd"
local btn_UIPlayerHead_path = "unlock/UIPlayerHead"
local go_unlock_path = "unlock"
local img_lock_path = "lock"
local txt_offical_path = "unlock/txt_offical"
local btn_img_kuang_path = "img_kuang"
local btn_img_offical_path = "unlock/img_offical"

function AllianceSkillItemView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function AllianceSkillItemView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceSkillItemView:ComponentDefine()
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_name = self:AddComponent(UIText, txt_name_path)
  self.txt_cost = self:AddComponent(UIText, txt_cost_path)
  self.txt_cd = self:AddComponent(UIText, txt_cd_path)
  self.btn_UIPlayerHead = self:AddComponent(UIButton, btn_UIPlayerHead_path)
  self.go_unlock = self:AddComponent(UIBaseContainer, go_unlock_path)
  self.img_lock = self:AddComponent(UIImage, img_lock_path)
  self.txt_offical = self:AddComponent(UIText, txt_offical_path)
  self.btn_img_kuang = self:AddComponent(UIButton, btn_img_kuang_path)
  self.btn_img_offical = self:AddComponent(UIButton, btn_img_offical_path)
  self.btn_UIPlayerHead = self:AddComponent(UICommonHead, btn_UIPlayerHead_path)
  self.btn_UIPlayerHead:SetEnableClickShowInfo(true, true)
  self.btn_img_offical:SetOnClick(BindCallback(self, self.OnClickOffical))
  self.btn_img_kuang:SetOnClick(BindCallback(self, self.OnClickKuang))
end

function AllianceSkillItemView:ComponentDestroy()
  self.img_icon = nil
  self.txt_name = nil
  self.txt_cost = nil
  self.txt_cd = nil
  self.btn_UIPlayerHead = nil
  self.go_unlock = nil
  self.img_lock = nil
  self.txt_offical = nil
  self.btn_img_kuang = nil
  self.btn_img_offical = nil
end

function AllianceSkillItemView:OnClickOffical()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMember, {anim = true, hideTop = true})
end

function AllianceSkillItemView:OnClickKuang()
  self.holder.view:OnToggleBySkillId(self.data.config.id)
end

function AllianceSkillItemView:ReInit(data)
  self.data = data
  local config = data.config
  self.go_unlock:SetActive(true)
  self.img_lock:SetActive(false)
  self.img_icon:LoadSpriteAsync(config.skill_icon)
  self.txt_name:SetLocalText(config.name)
  self.txt_cost:SetLocalText("season_s6_government_skill_desc42", string.GetFormattedStr(config.consume_energy))
  self.txt_offical:SetLocalText(LWAlMemberOffcialParam[config.type].Text)
  self.btn_img_offical:LoadSprite(LWAlMemberOffcialParam[config.type].Icon)
  if config.type == LWAlMemberOffcialType.Al_MASTER then
    self.btn_img_offical:SetSizeDeltaXY(190, 105)
  else
    self.btn_img_offical:SetSizeDeltaXY(105, 105)
  end
  self.txt_cd:SetActive(true)
  local user = data.user
  self:RefreshTime()
  self.btn_UIPlayerHead:SetActive(user ~= nil)
  self.btn_img_offical:SetActive(user == nil)
  if user then
    self.btn_UIPlayerHead:SetActive(true)
    local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(user.headSkinId, user.headSkinET, false)
    self.btn_UIPlayerHead:SetHead(user.uid, user.headPic, user.headPicVer, nil, headFrame)
  end
end

function AllianceSkillItemView:RefreshTime()
  if self.data == nil then
    return
  end
  local data = self.data
  local lock = data:IsLock()
  if not lock then
    local hasCd = data:InCd()
    if hasCd then
      local cd = data:GetCD()
      local cdStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(cd)
      self.txt_cd:SetLocalText("season_s6_government_skill_desc43", cdStr)
    elseif data.user then
      self.txt_cd:SetActive(false)
    else
      self.txt_cd:SetLocalText("season_s6_government_skill_desc50")
    end
  else
    self.txt_cd:SetLocalText("season_s6_government_skill_desc45")
  end
end

function AllianceSkillItemView:Update1000MS()
  self:RefreshTime()
end

return AllianceSkillItemView
