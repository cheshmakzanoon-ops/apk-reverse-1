local LWUIGoldTreeThirdAuto = BaseClass("LWUIGoldTreeThirdAuto")
local LWUIGoldTreeInfoComView = require("UI.LWSeason4.LWUIGoldTreeThird.Component.LWUIGoldTreeInfoComView")
local LWUIGoldRankItemComView = require("UI.LWSeason4.LWUIGoldTreeThird.Component.LWUIGoldRankItemComView")
local LWUIGoldLotteryItemComView = require("UI.LWSeason4.LWUIGoldTreeThird.Component.LWUIGoldLotteryItemComView")
local remain_str = "safeArea/Top/Left/TimeBg/remain"
local infobtn_str = "safeArea/Top/InfoBtn"
local txt_bubble_str = "Spine/bubble/txt_bubble"
local lwuigoldtreeinfo_str = "Popup/LWUIGoldTreeInfo"
local lotterytime_str = "safeArea/Bottom/timeModule/lotteryTime"
local timemodule_str = "safeArea/Bottom/timeModule"
local txt_rewardcount_str = "safeArea/Center/reward/txt_rewardCount"
local lwuigoldrankitem_str = "safeArea/Center/Scroll View/rankContent/LWUIGoldRankItem"
local lwuigoldrankitem1_str = "safeArea/Center/Scroll View/rankContent/LWUIGoldRankItem1"
local lwuigoldrankitem2_str = "safeArea/Center/Scroll View/rankContent/LWUIGoldRankItem2"
local txt_lotterycount_str = "safeArea/Bottom/Lottery/lotteryInfo/txt_LotteryCount"
local btn_lotteryhelp_str = "safeArea/Bottom/Lottery/lotteryInfo/btn_LotteryHelp"
local notbuy_str = "safeArea/Bottom/Lottery/notbuy"
local buy_str = "safeArea/Bottom/Lottery/buy"
local lwuigoldlotteryitem_str = "safeArea/Bottom/Lottery/buy/content/LWUIGoldLotteryItem"
local lwuigoldlotteryitem1_str = "safeArea/Bottom/Lottery/buy/content/LWUIGoldLotteryItem1"
local lwuigoldlotteryitem2_str = "safeArea/Bottom/Lottery/buy/content/LWUIGoldLotteryItem2"
local lwuigoldlotteryitem3_str = "safeArea/Bottom/Lottery/buy/content/LWUIGoldLotteryItem3"
local lwuigoldlotteryitem5_str = "safeArea/Bottom/Lottery/notbuy/LWUIGoldLotteryItem5"
local txt_tip_str = "safeArea/Bottom/Lottery/notbuy/txt_tip"
local btnback_str = "safeArea/Bottom/BtnBack"
local recordbtn_str = "safeArea/Bottom/RecordBtn"
local time_tip_path = "safeArea/Bottom/timeTip"
local btn_time_info_path = "safeArea/Bottom/timeModule/txt_timeTip/btn_timeInfo"
local spine_path = "Spine"
local bubble_path = "Spine/bubble"

function LWUIGoldTreeThirdAuto:bind(view)
  view.txt_remain = view:AddComponent(UIText, remain_str)
  view.btn_infobtn = view:AddComponent(UIButton, infobtn_str)
  view.txt_bubble = view:AddComponent(UIText, txt_bubble_str)
  view.bind_lwuigoldtreeinfo = view:AddComponent(LWUIGoldTreeInfoComView, lwuigoldtreeinfo_str)
  view.txt_lotterytime = view:AddComponent(UIText, lotterytime_str)
  view.btn_time_info = view:AddComponent(UIButton, btn_time_info_path)
  view.timemodule = view:AddComponent(UIBaseContainer, timemodule_str)
  view.btn_spine = view:AddComponent(UIButton, spine_path)
  view.anim_bubble = view:AddComponent(UISimpleAnimation, bubble_path)
  view.g_center = {
    txt_rewardCount = view:AddComponent(UIText, txt_rewardcount_str),
    mul_bind_rankcontent = {
      view:AddComponent(LWUIGoldRankItemComView, lwuigoldrankitem_str),
      view:AddComponent(LWUIGoldRankItemComView, lwuigoldrankitem1_str),
      view:AddComponent(LWUIGoldRankItemComView, lwuigoldrankitem2_str)
    }
  }
  view.g_bottom = {
    txt_LotteryCount = view:AddComponent(UIText, txt_lotterycount_str),
    btn_LotteryHelp = view:AddComponent(UIButton, btn_lotteryhelp_str),
    notbuy = view:AddComponent(UIBaseContainer, notbuy_str),
    buy = view:AddComponent(UIBaseContainer, buy_str),
    mul_bind_content = {
      view:AddComponent(LWUIGoldLotteryItemComView, lwuigoldlotteryitem_str),
      view:AddComponent(LWUIGoldLotteryItemComView, lwuigoldlotteryitem1_str),
      view:AddComponent(LWUIGoldLotteryItemComView, lwuigoldlotteryitem2_str),
      view:AddComponent(LWUIGoldLotteryItemComView, lwuigoldlotteryitem3_str)
    },
    bind_lwuigoldlotteryitem5 = view:AddComponent(LWUIGoldLotteryItemComView, lwuigoldlotteryitem5_str),
    txt_tip = view:AddComponent(UIText, txt_tip_str),
    btn_btnback = view:AddComponent(UIButton, btnback_str),
    btn_recordbtn = view:AddComponent(UIButton, recordbtn_str),
    time_tip = view:AddComponent(UIBaseContainer, time_tip_path)
  }
end

function LWUIGoldTreeThirdAuto:unbind(view)
  view.btn_spine = nil
  view.txt_remain = nil
  view.btn_infobtn = nil
  view.txt_bubble = nil
  view.bind_lwuigoldtreeinfo = nil
  view.txt_lotterytime = nil
  view.btn_time_info = nil
  view.bubble = nil
  view.timemodule = nil
  view.g_center = nil
  view.g_bottom = nil
end

return LWUIGoldTreeThirdAuto
