local Vip18DesignBinder = BaseClass("Vip18DesignBinder")
local UIDecorationMainCity = require("UI.UIDecoration.UIDecorationMain.Component.UIDecorationMainCity")
local display_panel_path = "displayPanel"
local can_con_grouptopboxgift_str = "displayPanel/canvasGroup/content/groupTopBoxGift"
local can_con_grouptopmaliao_str = "displayPanel/canvasGroup/content/groupTopMaliao"
local can_con_grouptopskin_str = "displayPanel/canvasGroup/content/groupTopSkin"
local can_con_grouptopreward_str = "displayPanel/canvasGroup/content/groupTopReward"
local group_hua_cao_tu_path = "displayPanel/canvasGroup/content/groupHuaCaoTu"
local con_gro_btnleftarrow_str = "displayPanel/canvasGroup/content/groupTopSkin/btnLeftArrow"
local gro_cao_textnumber_str = "displayPanel/canvasGroup/content/groupTopSkin/caogao06bg/textNumber"
local bgb_gro_bgkong1_str = "displayPanel/canvasGroup/content/bgBottomCard/groupTimelineBgYou/bgKong1"
local bgb_gro_bgkong2_str = "displayPanel/canvasGroup/content/bgBottomCard/groupTimelineBgYou/bgKong2"
local bgb_gro_bgkong3_str = "displayPanel/canvasGroup/content/bgBottomCard/groupTimelineBgYou/bgKong3"
local bgb_gro_bgkong4_str = "displayPanel/canvasGroup/content/bgBottomCard/groupTimelineBgYou/bgKong4"
local bgb_ghi_btnprocess_str = "displayPanel/canvasGroup/content/bgBottomCard/gHistory/btnProcess"
local con_bgb_textbasicskin_str = "displayPanel/canvasGroup/content/bgBottomCard/groupContent/textBasicSkin"
local con_bgb_textkeywords_str = "displayPanel/canvasGroup/content/bgBottomCard/groupContent/textKeywords"
local con_bgb_textcontent_str = "displayPanel/canvasGroup/content/bgBottomCard/groupContent/textContent"
local con_bgb_textoption_str = "displayPanel/canvasGroup/content/bgBottomCard/textOption"
local con_gro_imageduihao_str = "groupAnonymity/imageDuihao"
local con_gro_btnanonymity_str = "groupAnonymity/btnAnonymity"
local gro_ste_gempty_str = "displayPanel/canvasGroup/content/bgBottomCard/groupStepB/step%d/gEmpty%d"
local gro_ste_gcurrent_str = "displayPanel/canvasGroup/content/bgBottomCard/groupStepT/step%d/gCurrent%d"
local gro_ste_gpass_str = "displayPanel/canvasGroup/content/bgBottomCard/groupStepB/step%d/gPass%d"
local con_gro_btnrightarrow_str = "displayPanel/canvasGroup/content/groupTopSkin/btnRightArrow"
local can_con_tmpdavidskinname_str = "displayPanel/canvasGroup/content/tmpDavidSkinName"
local btn_com_new_str = "displayPanel/canvasGroup/content/bgBottomCard/optionBtn/LW_Btn_Common_New"
local btn_com_btntext_str = "displayPanel/canvasGroup/content/bgBottomCard/optionBtn/LW_Btn_Common_New/LW_Btn_Common_New_Base/BtnText"
local con_gro_photochatphoto_str = "displayPanel/canvasGroup/content/groupTopSkin/Photo/ChatPhoto"
local con_gro_photoimgloading_str = "displayPanel/canvasGroup/content/groupTopSkin/Photo/ChatPhoto/ImgLoading"
local con_gro_photoimgloadingfail_str = "displayPanel/canvasGroup/content/groupTopSkin/Photo/ChatPhoto/ImgLoadFail"
local dis_inf_infoiconbtn_str = "infoIcon/infoIconBtn"
local skin_done_panel_path = "skinDonePanel"
local making_root_path = "skinDonePanel/makingRoot"
local complete_root_path = "skinDonePanel/completeRoot"
local u_i_player_head_path = "skinDonePanel/UIPlayerHead"
local city_name_path = "skinDonePanel/cityName"
local player_name_path = "skinDonePanel/playerName"
local desc_path = "skinDonePanel/descScrollView/Viewport/desc"
local city_render_texture_path = "skinDonePanel/completeRoot/cityRenderTexture"

function Vip18DesignBinder:bind(view)
  view.display_panel = view:AddComponent(UIBaseContainer, display_panel_path)
  view.can_con_grouptopskin = view:AddComponent(UIBaseContainer, can_con_grouptopskin_str)
  view.can_con_grouptopboxgift = view:AddComponent(UIBaseContainer, can_con_grouptopboxgift_str)
  view.can_con_grouptopmaliao = view:AddComponent(UIBaseContainer, can_con_grouptopmaliao_str)
  view.can_con_grouptopreward = view:AddComponent(UIBaseContainer, can_con_grouptopreward_str)
  view.group_hua_cao_tu = view:AddComponent(UIBaseContainer, group_hua_cao_tu_path)
  view.gro_cao_textnumber = view:AddComponent(UIText, gro_cao_textnumber_str)
  view.mul_bgb_gro_steps = {}
  for i = 1, 5 do
    view.mul_bgb_gro_steps[i] = {
      gro_ste_gempty = view:AddComponent(UIBaseContainer, string.format(gro_ste_gempty_str, i, i)),
      gro_ste_gcurrent = view:AddComponent(UIBaseContainer, string.format(gro_ste_gcurrent_str, i, i)),
      gro_ste_gpass = view:AddComponent(UIBaseContainer, string.format(gro_ste_gpass_str, i, i))
    }
  end
  view.mul_bgb_gro_bgkong1 = {
    view:AddComponent(UIBaseContainer, bgb_gro_bgkong1_str),
    view:AddComponent(UIBaseContainer, bgb_gro_bgkong2_str),
    view:AddComponent(UIBaseContainer, bgb_gro_bgkong3_str),
    view:AddComponent(UIBaseContainer, bgb_gro_bgkong4_str)
  }
  view.bgb_ghi_btnprocess = view:AddComponent(UIButton, bgb_ghi_btnprocess_str)
  view.con_bgb_textbasicskin = view:AddComponent(UIText, con_bgb_textbasicskin_str)
  view.con_bgb_textkeywords = view:AddComponent(UIText, con_bgb_textkeywords_str)
  view.con_bgb_textcontent = view:AddComponent(UIText, con_bgb_textcontent_str)
  view.con_bgb_textoption = view:AddComponent(UIText, con_bgb_textoption_str)
  view.con_gro_imageduihao = view:AddComponent(UIImage, con_gro_imageduihao_str)
  view.con_gro_btnanonymity = view:AddComponent(UIButton, con_gro_btnanonymity_str)
  view.BtnChatPhoto = view:AddComponent(UIButton, con_gro_photochatphoto_str)
  view.RawImgChatPhoto = view:AddComponent(UIRawImage, con_gro_photochatphoto_str)
  view.ChatSendPhotoNode = view:AddComponent(UIBaseContainer, con_gro_photochatphoto_str)
  view.RootImgLoading = view:AddComponent(UIBaseContainer, con_gro_photoimgloading_str)
  view.RootImgLoadFail = view:AddComponent(UIBaseContainer, con_gro_photoimgloadingfail_str)
  view.con_gro_btnleftarrow = view:AddComponent(UIButton, con_gro_btnleftarrow_str)
  view.con_gro_btnrightarrow = view:AddComponent(UIButton, con_gro_btnrightarrow_str)
  view.can_con_tmpdavidskinname = view:AddComponent(UIText, can_con_tmpdavidskinname_str)
  view.btn_com_new = view:AddComponent(UIButton, btn_com_new_str)
  view.btn_com_btntext = view:AddComponent(UIText, btn_com_btntext_str)
  view.dis_inf_infoiconbtn = view:AddComponent(UIButton, dis_inf_infoiconbtn_str)
  view.historyRedPoint = view:AddComponent(UIBaseContainer, "displayPanel/canvasGroup/content/bgBottomCard/gHistory/RedDotWithoutNum1")
  view.optionRedPoint = view:AddComponent(UIBaseContainer, "displayPanel/canvasGroup/content/bgBottomCard/optionBtn/RedDotWithoutNum2")
  view.optionLightFrame = view:AddComponent(UIBaseContainer, "displayPanel/canvasGroup/content/bgBottomCard/optionBtn/LW_Select_Frame")
  view.skin_done_panel = view:AddComponent(UIBaseContainer, skin_done_panel_path)
  view.city_name = view:AddComponent(UITextMeshProUGUIEx, city_name_path)
  view.making_root = view:AddComponent(UIBaseContainer, making_root_path)
  view.complete_root = view:AddComponent(UIBaseContainer, complete_root_path)
  view.compUIPlayerHead = view:AddComponent(UICommonHead, u_i_player_head_path)
  view.player_name = view:AddComponent(UITextMeshProUGUIEx, player_name_path)
  view.desc = view:AddComponent(UITextMeshProUGUIEx, desc_path)
end

function Vip18DesignBinder:unbind(view)
  view.grouptopskin = nil
  view.btnleftarrow = nil
  view.textnumber = nil
  view.grouptopboxgift = nil
  view.group_hua_cao_tu = nil
  view.mul_bgb_gro_step1 = nil
  view.mul_bgb_gro_bgkong1 = nil
  view.btnprocess = nil
  view.textbasicskin = nil
  view.textkeywords = nil
  view.textcontent = nil
  view.textoption = nil
  view.imageduihao = nil
  view.btnanonymity = nil
  view.step = nil
  view.btnrightarrow = nil
  view.cityrendertexture = nil
  view.tmpdavidskinname = nil
  view.lw_btn_common_new = nil
  view.historyRedPoint = nil
  view.optionRedPoint = nil
  view.optionLightFrame = nil
  view.compUIPlayerHead = nil
  view.city_name = nil
  view.making_root = nil
  view.complete_root = nil
  view.bg = nil
  view.player_name = nil
  view.desc = nil
  view.skin_done_panel = nil
  view.display_panel = nil
end

return Vip18DesignBinder
