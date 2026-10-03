local LWUIGoldTreeRecordAuto = BaseClass("LWUIGoldTreeRecordAuto")
local LWUIGoldRankItemComView = require("UI.LWSeason4.LWUIGoldTreeThird.Component.LWUIGoldRankItemComView")
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local LWUIGoldTreeInfoComView = require("UI.LWSeason4.LWUIGoldTreeThird.Component.LWUIGoldTreeInfoComView")
local uicommontabgroup_str = "Root/topArea/UICommonTabGroup"
local emptydes_str = "Root/emptyDes"
local lwuigoldrankitem_str = "Root/topArea/rankContent/LWUIGoldRankItem"
local lwuigoldrankitem1_str = "Root/topArea/rankContent/LWUIGoldRankItem1"
local lwuigoldrankitem2_str = "Root/topArea/rankContent/LWUIGoldRankItem2"
local helpbtn_str = "Root/topArea/TopBar/helpBtn"
local btnback_str = "Root/BottomBar/BtnBack"
local lwuigoldtreeinfo_str = "Popup/LWUIGoldTreeInfo"
local rank_content_path = "Root/topArea/rankContent"

function LWUIGoldTreeRecordAuto:bind(view)
  view.bind_uicommontabgroup = view:AddComponent(UICommonTabGroup, uicommontabgroup_str)
  view.txt_emptydes = view:AddComponent(UIText, emptydes_str)
  view.mul_bind_rankcontent = {
    view:AddComponent(LWUIGoldRankItemComView, lwuigoldrankitem_str),
    view:AddComponent(LWUIGoldRankItemComView, lwuigoldrankitem1_str),
    view:AddComponent(LWUIGoldRankItemComView, lwuigoldrankitem2_str)
  }
  view.btn_helpbtn = view:AddComponent(UIButton, helpbtn_str)
  view.btn_btnback = view:AddComponent(UIButton, btnback_str)
  view.bind_lwuigoldtreeinfo = view:AddComponent(LWUIGoldTreeInfoComView, lwuigoldtreeinfo_str)
  view.rank_content = view:AddComponent(UIBaseContainer, rank_content_path)
end

function LWUIGoldTreeRecordAuto:unbind(view)
  view.bind_uicommontabgroup = nil
  view.txt_emptydes = nil
  view.mul_bind_rankcontent = nil
  view.btn_helpbtn = nil
  view.btn_btnback = nil
  view.bind_lwuigoldtreeinfo = nil
  view.rank_content = nil
end

return LWUIGoldTreeRecordAuto
