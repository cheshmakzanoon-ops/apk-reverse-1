local LWSeasonRankCtrl = BaseClass("LWSeasonRankCtrl", UIBaseCtrl)

function LWSeasonRankCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonRank)
end

function LWSeasonRankCtrl:GetImageNameByRankType(rankType)
  local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
  local seasonType = SeasonUtil.GetSeasonType(false, true)
  local result = {}
  result.iconPath = "Assets/Main/TextureEx/Season/Activity/lrb_saijipaihangbang_banner01.png"
  result.nameBgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_icon_bg_02.png"
  result.rankIconBgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/Mjc_saiji2_paihangbang_icon_bg_01.png"
  if rankType == SeasonRankType.AlliancePower then
    if seasonType == SeasonMapType.NineNation then
      result.iconPath = "Assets/Main/SeasonRes/S5/Textures/BountyShop/mjc_saijipaihangbang_s501_banner.png"
    elseif seasonType == SeasonMapType.NineNationRainforest then
      result.iconPath = "Assets/Main/SeasonRes/S6/Textures/CampRank/ljq_s6_paihang_01_banner.png"
      result.rankIconBgPath = "Assets/Main/SeasonRes/S6/Sprites/ServerDetailS6/ljq_s6_slzzl_zhutibg.png"
    else
      result.iconPath = "Assets/Main/TextureEx/Season/Activity/lrb_saijipaihangbang_banner01.png"
    end
  elseif rankType == SeasonRankType.PersonalPower then
    result.iconPath = "Assets/Main/TextureEx/Season/Activity/lrb_saijipaihangbang_banner02.png"
  elseif rankType == SeasonRankType.ServerPower then
    if seasonType == SeasonMapType.NineNation then
      result.iconPath = "Assets/Main/SeasonRes/S5/Textures/BountyShop/mjc_saijipaihangbang_s501_banner.png"
    elseif seasonType == SeasonMapType.NineNationRainforest then
      result.iconPath = "Assets/Main/SeasonRes/S6/Textures/CampRank/ljq_s6_paihang_02.png"
      result.rankIconBgPath = "Assets/Main/SeasonRes/S6/Sprites/ServerDetailS6/ljq_s6_slzzl_zhutibg.png"
    else
      result.iconPath = "Assets/Main/TextureEx/Season/Activity/lrb_saijipaihangbang_banner03.png"
    end
  elseif rankType == SeasonRankType.AllianceRareLand or rankType == SeasonRankType.AllianceCamp1RareLand or rankType == SeasonRankType.AllianceCamp2RareLand then
    if seasonType == SeasonMapType.Mummy then
      result.iconPath = "Assets/Main/SeasonRes/S3/Textures/SeasonRankBanner/wxy_saijipaihangbang_banner_s301.png"
      result.nameBgPath = "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/wxy_saiji3_paihangbang_icon_bg_02.png"
      result.rankIconBgPath = "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/wxy_saiji3_paihangbang_icon_bg_01.png"
    elseif seasonType == SeasonMapType.Darkness then
      result.iconPath = "Assets/Main/SeasonRes/S4/Textures/SeasonRankBanner/mjc_saijipaihangbang_s402_banner.png"
      result.nameBgPath = "Assets/Main/SeasonRes/S4/Sprites/UI/LWCommon/wxy_saiji4_paihangbang_icon_bg_02.png"
      result.rankIconBgPath = "Assets/Main/SeasonRes/S4/Sprites/UI/LWCommon/wxy_saiji4_paihangbang_icon_bg_01.png"
    else
      result.iconPath = "Assets/Main/TextureEx/Season/S2/SeasonRank/ljq_saijipaihangbang_banner_s201.png"
      result.nameBgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/ljq_saiji2_paihangbang_icon_bg_02.png"
      result.rankIconBgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/ljq_saiji2_paihangbang_icon_bg_01.png"
    end
  elseif rankType == SeasonRankType.ServerRareLand then
    if seasonType == SeasonMapType.Mummy then
      result.iconPath = "Assets/Main/SeasonRes/S3/Textures/SeasonRankBanner/wxy_saijipaihangbang_s302_banner.png"
      result.nameBgPath = "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/wxy_saiji3_paihangbang_icon_bg_02.png"
      result.rankIconBgPath = "Assets/Main/SeasonRes/S3/Sprites/UI/LWCommon/wxy_saiji3_paihangbang_icon_bg_01.png"
    elseif seasonType == SeasonMapType.Darkness then
      result.iconPath = "Assets/Main/SeasonRes/S4/Textures/SeasonRankBanner/mjc_saijipaihangbang_s401_banner.png"
      result.nameBgPath = "Assets/Main/SeasonRes/S4/Sprites/UI/LWCommon/wxy_saiji4_paihangbang_icon_bg_02.png"
      result.rankIconBgPath = "Assets/Main/SeasonRes/S4/Sprites/UI/LWCommon/wxy_saiji4_paihangbang_icon_bg_01.png"
    else
      result.iconPath = "Assets/Main/TextureEx/Season/S2/SeasonRank/ljq_saijipaihangbang_banner_s202.png"
      result.nameBgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/ljq_saiji2_paihangbang_icon_bg_02.png"
      result.rankIconBgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/ljq_saiji2_paihangbang_icon_bg_01.png"
    end
  elseif rankType == SeasonRankType.ServerFamer then
    result.iconPath = "Assets/Main/TextureEx/Season/FarmerRankBanner/mjc_S1YH_lianmengjianshezhe_paihangbang_banner1.png"
    result.nameBgPath = "Assets/Main/Sprites/UI/UISeason/UISeason1/Activity/ljq_saiji2_paihangbang_icon_bg_02.png"
    result.rankIconBgPath = "Assets/Main/Sprites/UI/UISeason/UISeasonFarmer/mjc_S1YH_lianmengjianshezhe_icon_2.png"
  elseif rankType == SeasonRankType.AllianceCamp1Power or rankType == SeasonRankType.AllianceCamp2Power then
    result.iconPath = "Assets/Main/SeasonRes/S6/Textures/CampRank/ljq_s6_paihang_01_banner.png"
    result.rankIconBgPath = "Assets/Main/SeasonRes/S6/Sprites/ServerDetailS6/ljq_s6_slzzl_zhutibg.png"
  end
  return result
end

return LWSeasonRankCtrl
