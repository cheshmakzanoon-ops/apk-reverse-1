local base = UIBaseContainer
local CampScienceIconInfo = BaseClass("CampScienceIconInfo", base)
local Localization = CS.GameEntry.Localization
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local CampScienceDonateInfo = require("UI.LWSeasonShared.UICampScienceInfo.Component.CampScienceDonateInfo")
local build_icon_path = "IconBg/UICampScienceCell/ScienceBg/ScienceIcon"
local science_name_path = "IconBg/UICampScienceCell/ScienceBg/ScienceName"
local science_des_path = "IconBg/ScienceDes"
local science_level_text_path = "IconBg/UICampScienceCell/ScienceBg/LevelText"
local buff_content_path = "IconBg/BuffContent"
local buff_txt1_path = "IconBg/BuffContent/CurrentLv/txt1"
local buff_value1_path = "IconBg/BuffContent/CurrentLv/value1"
local buff_txt2_path = "IconBg/BuffContent/NextLv/txt2"
local buff_value2_path = "IconBg/BuffContent/NextLv/value2"
local confirm_btn_path = "ConfirmBtn"
local confirm_btn_txt_path = "ConfirmBtn/ConfirmBtnTxt"
local buff_next_lv_path = "IconBg/BuffContent/NextLv"
local btn_rateBtn_path = "rateBtnContent/rateBtn"
local go_DonateInfoGo_path = "DonateInfoGo"
local img_leaderRecommend_path = "IconBg/UICampScienceCell/ScienceBg/leaderRecommend"
local txt_RecommendRewardTip_path = "IconBg/RecommendRewardTip"
local img_maxText_path = "IconBg/UICampScienceCell/ScienceBg/maxText"

function CampScienceIconInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function CampScienceIconInfo:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CampScienceIconInfo:ComponentDefine()
  self.build_icon = self:AddComponent(UIImage, build_icon_path)
  self.science_name = self:AddComponent(UIText, science_name_path)
  self.science_des = self:AddComponent(UILWScienceDetailDesc, science_des_path)
  self.science_level_text = self:AddComponent(UIText, science_level_text_path)
  self.buff_content = self:AddComponent(UIImage, buff_content_path)
  self.buff_txt1 = self:AddComponent(UIText, buff_txt1_path)
  self.buff_value1 = self:AddComponent(UIText, buff_value1_path)
  self.buff_txt2 = self:AddComponent(UIText, buff_txt2_path)
  self.buff_value2 = self:AddComponent(UIText, buff_value2_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn_txt = self:AddComponent(UIText, confirm_btn_txt_path)
  self.buff_next_lv = self:AddComponent(UIBaseContainer, buff_next_lv_path)
  self.btn_rateBtn = self:AddComponent(UIButton, btn_rateBtn_path)
  self.go_DonateInfoGo = self:AddComponent(CampScienceDonateInfo, go_DonateInfoGo_path)
  self.img_leaderRecommend = self:AddComponent(UIBaseContainer, img_leaderRecommend_path)
  self.txt_RecommendRewardTip = self:AddComponent(UIText, txt_RecommendRewardTip_path)
  self.img_maxText = self:AddComponent(UIImage, img_maxText_path)
  self.confirm_btn:SetOnClick(BindCallback(self, self.view.ctrl.CloseSelf))
  self.btn_rateBtn:SetActive(false)
  self.txt_RecommendRewardTip:SetActive(false)
  self.buff_txt1:SetLocalText(454100)
  self.buff_txt2:SetLocalText(454103)
end

function CampScienceIconInfo:ComponentDestroy()
  self.build_icon = nil
  self.science_name = nil
  self.science_des = nil
  self.science_level_text = nil
  self.buff_content = nil
  self.buff_txt1 = nil
  self.buff_value1 = nil
  self.buff_txt2 = nil
  self.buff_value2 = nil
  self.confirm_btn = nil
  self.confirm_btn_txt = nil
  self.buff_next_lv = nil
  self.btn_rateBtn = nil
  self.go_DonateInfoGo = nil
  self.img_leaderRecommend = nil
  self.txt_RecommendRewardTip = nil
  self.img_maxText = nil
end

function CampScienceIconInfo:OnAddListener()
  self:AddUIListener(EventId.UpdateCampRecommendScience, self.UpdateCampRecommendScienceHandle)
end

function CampScienceIconInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateCampRecommendScience, self.UpdateCampRecommendScienceHandle)
end

function CampScienceIconInfo:RefreshData(scienceData)
  self.scienceData = scienceData
  self.build_icon:LoadSprite(self.scienceData.icon)
  self.science_name:SetLocalText(self.scienceData.name)
  
  local function ProcessDesc(desc)
    local modifiedText = string.gsub(desc, "<link=", string.format("<color=%s><u><link=", "#EF6B00"))
    modifiedText = string.gsub(modifiedText, "</link>", "</link></u></color>")
    return modifiedText
  end
  
  local desLocal = ProcessDesc(self.scienceData:GetDesc())
  self.science_des:SetText(desLocal)
  self.science_level_text:SetText(self.scienceData.curLevel .. "/" .. self.scienceData.maxLevel)
  local nextLevel = 0
  self.buff_value1:SetText(self.scienceData:GetInfoText(self.scienceData.curLevel))
  local isMax = self.scienceData:IsMax()
  self.img_maxText:SetActive(isMax)
  if not isMax then
    nextLevel = self.scienceData.curLevel + 1
    self.buff_next_lv:SetActive(true)
    self.buff_value2:SetText(self.scienceData:GetInfoText(nextLevel))
    self.confirm_btn:SetActive(false)
  else
    self.confirm_btn:SetActive(true)
    self.buff_next_lv:SetActive(false)
    nextLevel = self.scienceData.curLevel
    self.confirm_btn_txt:SetLocalText(393010)
  end
  if self.scienceData.isLock then
    self.go_DonateInfoGo:SetActive(false)
  else
    self.go_DonateInfoGo:SetActive(true)
    self.go_DonateInfoGo:RefreshData(scienceData)
  end
  self:UpdateCampRecommendScienceHandle(DataCenter.CampScienceDataManager:GetRecommendScienceId())
end

function CampScienceIconInfo:UpdateCampRecommendScienceHandle(scienceId)
  local isShow = scienceId and self.scienceData.scienceId == scienceId
  self.img_leaderRecommend:SetActive(isShow)
  self.txt_RecommendRewardTip:SetActive(false)
end

function CampScienceIconInfo:OnClickRateBtn()
  UIUtil.ShowIntro(Localization:GetString("302027"), Localization:GetString("2800015"), Localization:GetString("drop_info_desc6"))
end

return CampScienceIconInfo
