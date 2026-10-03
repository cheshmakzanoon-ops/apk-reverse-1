local UICapacityBoxSelectTypeTWSkillChipItem = BaseClass("UICapacityBoxSelectTypeTWSkillChipItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local SkillChipItem = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipItem")
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")
local select_box_item_path = ""
local be_select_bg_path = "beSelectBg"
local u_i_l_w_t_w_skill_chip_item_path = "UILWTWSkillChipItem"
local name_path = "name"
local check_btn_path = "checkBtn"
local be_select_img_path = "beSelectContent/beSelectImg"

function UICapacityBoxSelectTypeTWSkillChipItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICapacityBoxSelectTypeTWSkillChipItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxSelectTypeTWSkillChipItem:OnEnable()
  base.OnEnable(self)
end

function UICapacityBoxSelectTypeTWSkillChipItem:OnDisable()
  base.OnDisable(self)
end

function UICapacityBoxSelectTypeTWSkillChipItem:ComponentDefine()
  self.select_box_item = self:AddComponent(UIButton, select_box_item_path)
  self.be_select_bg = self:AddComponent(UIImage, be_select_bg_path)
  self.u_i_l_w_t_w_skill_chip_item = self:AddComponent(SkillChipItem, u_i_l_w_t_w_skill_chip_item_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.check_btn = self:AddComponent(UIButton, check_btn_path)
  self.be_select_img = self:AddComponent(UIImage, be_select_img_path)
  self.select_box_item:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.check_btn:SetOnClick(function()
    self:OnCheckBtnClick()
  end)
  self.starTitle = self:AddComponent(UITextMeshProUGUIEx, "starNode/title")
  self.starLayout = self:AddComponent(UIBaseContainer, "starNode/stars")
  self.starDesc = self:AddComponent(UITextMeshProUGUIEx, "desc")
end

function UICapacityBoxSelectTypeTWSkillChipItem:ComponentDestroy()
  self.select_box_item = nil
  self.be_select_bg = nil
  self.u_i_l_w_t_w_skill_chip_item = nil
  self.name = nil
  self.check_btn = nil
  self.be_select_img = nil
end

function UICapacityBoxSelectTypeTWSkillChipItem:DataDefine()
  self.param = nil
  self.index = nil
  self.clickFunc = nil
  self.isSelect = nil
  self.stars = {}
end

function UICapacityBoxSelectTypeTWSkillChipItem:DataDestroy()
  self.param = nil
  self.index = nil
  self.clickFunc = nil
  self.isSelect = nil
end

function UICapacityBoxSelectTypeTWSkillChipItem:RefreshData(param, index, clickFunc, isSelect)
  self.param = param
  self.index = index
  self.clickFunc = clickFunc
  self.isSelect = isSelect
  self:RefreshView()
end

function UICapacityBoxSelectTypeTWSkillChipItem:RefreshSelectData(isSelect)
  self.isSelect = isSelect
  self:RefreshSelectBg()
end

function UICapacityBoxSelectTypeTWSkillChipItem:RefreshView()
  self:RefreshSelectBg()
  local chipInfo = TWSkillChipInfo.New()
  chipInfo:CreateFromTemplate(self.param.chipId, 1, 0)
  self.u_i_l_w_t_w_skill_chip_item:SetData(chipInfo)
  self.name:SetLocalText(self.param.itemtemp.name)
  self:RefreshNeedStar()
end

function UICapacityBoxSelectTypeTWSkillChipItem:RefreshSelectBg()
  self.be_select_bg:SetActive(self.isSelect)
  self.be_select_img:SetActive(self.isSelect)
end

function UICapacityBoxSelectTypeTWSkillChipItem:OnBtnClick()
  if self.clickFunc ~= nil then
    self.clickFunc(self.param, self.index)
  end
end

function UICapacityBoxSelectTypeTWSkillChipItem:OnCheckBtnClick()
  local param = {}
  param.alignObject = self.check_btn.transform
  param.width = 574
  param.chipConfigId = self.param.chipId
  param.showArrow = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalChipPlanNeedTip, {anim = true}, param)
end

function UICapacityBoxSelectTypeTWSkillChipItem:RefreshNeedStar()
  self:ClearStars()
  self.starTitle:SetLocalText("drone_skillchip_make_15_limit_18")
  self.starDesc:SetActive(false)
  local chipData = DataCenter.TacticalChipManager:GetBestStarChip(self.param.chipId)
  if not chipData then
    return
  end
  self.starTitle:SetLocalText("drone_skillchip_make_1_limit_10")
  local showPreview, ownNumStr, needNum = DataCenter.TacticalChipManager.GetUpgradeStarNeedNumFormat(chipData)
  if showPreview then
    self.starDesc:SetActive(true)
    self.starDesc:SetLocalText("drone_skillchip_detail_12_limit_10", ownNumStr, needNum)
    if chipData:GetStar() == 0 then
      self.starTitle:SetLocalText("drone_skillchip_make_16_limit_18")
    end
  else
    local isMaxStar = chipData:IsMaxStar()
    if isMaxStar then
      self.starDesc:SetActive(true)
      self.starDesc:SetLocalText("drone_skillchip_detail_14_limit_12")
    else
      self.starDesc:SetActive(false)
    end
  end
  self:SetStars(chipData:GetStar())
end

function UICapacityBoxSelectTypeTWSkillChipItem:SetStars(starCount)
  if 0 < starCount then
    local showStarCount = math.min(starCount, 5)
    local leftWindow = math.max(0, starCount - 5)
    local rightWindow = starCount
    for i = 1, showStarCount do
      local starRequest = self:GameObjectInstantiateAsync(UIAssets.UIHeroSkillStar, function(request)
        if IsNull(request.gameObject) then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.starLayout.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        local cell = self.starLayout:AddComponent(UIHeroSkillStar, go)
        cell:SetFilled(true)
        local viewStarIndex = rightWindow - i + 1
        cell:SetStarIndex(viewStarIndex)
        cell.transform:Set_sizeDelta(22.12, 23.26)
      end)
      table.insert(self.stars, starRequest)
    end
  end
end

function UICapacityBoxSelectTypeTWSkillChipItem:ClearStars()
  if self.stars then
    self.starLayout:RemoveComponents(UIHeroSkillStar)
    for i, v in ipairs(self.stars) do
      self:GameObjectDestroy(v)
    end
    self.stars = {}
  end
end

return UICapacityBoxSelectTypeTWSkillChipItem
