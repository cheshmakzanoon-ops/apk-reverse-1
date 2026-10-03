local LWUITrailTowerStageView = BaseClass("LWUITrailTowerStageView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUITrailTowerStageItemRender = require("UI.LWTrailTower.Stage.Component.LWUITrailTowerStageItemRender")
local titleText_path = "Root/Title"
local curStageText_path = "Root/BottomContainer/CurStageText"
local closeBtn_path = "Root/CloseBtn"
local rewardScrollView_path = "Root/BottomContainer/RewardScrollView"
local stage_path = "Root/StageScrollView/Viewport/StageContent/StageItem"
local fight_btn_path = "Root/BottomContainer/HorLayout/FightBtn"
local fight_btn_text_path = "Root/BottomContainer/HorLayout/FightBtn/FightBtnText"
local one_click_sweep_btn_path = "Root/BottomContainer/HorLayout/OneClickSweepBtn"
local one_click_sweep_btn_text_path = "Root/BottomContainer/HorLayout/OneClickSweepBtn/OneClickSweepBtnText"
local stageRawImage_path = "Root/StageScrollView/Viewport/StageContent/StageRawImage"
local stageContent_path = "Root/StageScrollView/Viewport/StageContent"
local sweep_tips_content_path = "Root/SweepTipsContent"
local sweep_tips_text_path = "Root/SweepTipsContent/SweepTipsText"
local tankStagePosConfig = {
  {x = -121.3, y = -171.3},
  {x = 46.59, y = -160.1},
  {x = 206.2, y = -142.7},
  {x = 340.3, y = -226.9},
  {x = 323.4, y = -396.3},
  {x = 173.9, y = -454.3},
  {x = -25.7, y = -425.8},
  {x = -188.8, y = -483.8},
  {x = -70.2, y = -631.3},
  {x = -219.4, y = -778.7},
  {x = -235, y = -923},
  {x = -270.3, y = -1089.3},
  {x = -292, y = -1281},
  {x = -161, y = -1410},
  {x = 58, y = -1423},
  {x = 236.1, y = -1283},
  {x = 233.5, y = -1080},
  {x = 107, y = -944},
  {x = 122.1, y = -794},
  {x = 233.2, y = -665}
}
local tankStagePointConfig = {
  {
    {x = 34.6, y = -70.9},
    {x = 62.99997, y = -70.1},
    {x = 91.39996, y = -67.6},
    {x = 120.2, y = -63.30001}
  },
  {
    {x = 34.7, y = -59.2},
    {x = 61.4001, y = -55.20004},
    {x = 89.50009, y = -51.70004},
    {x = 116.7001, y = -49.80001}
  },
  {
    {x = 37.9, y = -76.3},
    {x = 63.69994, y = -86.10004},
    {x = 87.09994, y = -99.60004}
  },
  {
    {x = 3, y = -78.3},
    {x = 11.5, y = -103.6001},
    {x = 11.5, y = -130.2001}
  },
  {
    {x = -31.8, y = -76.1},
    {x = -54.6001, y = -90.00004},
    {x = -79.80009, y = -100.1},
    {x = -106.3001, y = -106.4001}
  },
  {
    {x = -38.2, y = -54},
    {x = -65.79999, y = -50},
    {x = -93.49998, y = -45.29999},
    {x = -120.3, y = -39.79999},
    {x = -149.3, y = -34.29999}
  },
  {
    {x = -34.5, y = -53},
    {x = -63.60006, y = -53.70004},
    {x = -92.00006, y = -57.20004},
    {x = -120.4001, y = -66.40005}
  },
  {
    {x = -9.2, y = -77.8},
    {x = -5.40006, y = -108.2},
    {x = 10.89994, y = -134.7999},
    {x = 32.39994, y = -154.4999},
    {x = 56.19995, y = -169.5999},
    {x = 80.59994, y = -182.3999}
  },
  {
    {x = -5, y = -89.7},
    {x = -23.8, y = -107.8},
    {x = -46.2, y = -123},
    {x = -70.39999, y = -138.1},
    {x = -95.39999, y = -151.7}
  },
  {
    {x = -27.1, y = -85.4},
    {x = -34.20006, y = -113.8}
  },
  {
    {x = -1.3, y = -81.4},
    {x = 0.7999778, y = -107.9},
    {x = -2.000025, y = -134.4}
  },
  {
    {x = -21.5, y = -96},
    {x = -29.3999, y = -124.2},
    {x = -36.69993, y = -152}
  },
  {
    {x = -2, y = -75},
    {x = 13.10004, y = -98.89999},
    {x = 29.90005, y = -122},
    {x = 49.40004, y = -143.3},
    {x = 71.30005, y = -161.9},
    {x = 93.70004, y = -179.2}
  },
  {
    {x = 15.7, y = -78.1},
    {x = 43.10011, y = -86.80009},
    {x = 72.00011, y = -90.80009},
    {x = 100.3001, y = -94.30009},
    {x = 128.6001, y = -94.30009},
    {x = 157.5001, y = -93.10007},
    {x = 186.4001, y = -89.10007}
  },
  {
    {x = 50.9, y = -51.9},
    {x = 77.60013, y = -39.40005},
    {x = 102.0001, y = -24.50008},
    {x = 124.6001, y = -6.400045},
    {x = 145.4001, y = 13.49992},
    {x = 163.0001, y = 36.09995},
    {x = 179.3001, y = 59.99992}
  },
  {
    {x = 32, y = 30.1},
    {x = 30.89996, y = 58.70002},
    {x = 25.89996, y = 87.9},
    {x = 17.09996, y = 115.4}
  },
  {
    {x = -39.1, y = 11.3},
    {x = -57.49993, y = 32.2},
    {x = -79.09994, y = 52},
    {x = -99.99993, y = 66.8}
  },
  {
    {x = -44.7, y = -23.5},
    {x = -53, y = -0.9999542},
    {x = -48.9, y = 22.40005},
    {x = -33.8, y = 44.00005},
    {x = -13.6, y = 62.80005}
  },
  {
    {x = 42.7, y = -40.7},
    {x = 63.80001, y = -20.50006},
    {x = 83.10001, y = 0.5999432},
    {x = 99.60001, y = 24.89994},
    {x = 111.1, y = 50.09994}
  }
}
local airPlanePosConfig = {
  {x = 310.9, y = -500},
  {x = 345.6, y = -332},
  {x = 236, y = -174},
  {x = 68.3, y = -111},
  {x = -81, y = -123.5},
  {x = -203.3, y = -217},
  {x = -81.3, y = -315},
  {x = 63.5, y = -407},
  {x = -83.4, y = -473},
  {x = -223.6, y = -547},
  {x = 15.7, y = -707},
  {x = 273.4, y = -844},
  {x = 331, y = -1115},
  {x = 236, y = -1372},
  {x = -22.6, y = -1459},
  {x = -37.1, y = -1268},
  {x = -73.5, y = -1076.1},
  {x = -309.4, y = -959.2},
  {x = -187.9, y = -860.1},
  {x = -22, y = -894.5}
}
local airPlanePointConfig = {
  {
    {x = 36.3, y = 20.9},
    {x = 41.49998, y = 50.79998},
    {x = 42.79997, y = 78.79998}
  },
  {
    {x = -42.7, y = 43.9},
    {x = -61.59998, y = 65.99996},
    {x = -83.09998, y = 84.89993}
  },
  {
    {x = -47.4, y = -27.9},
    {x = -73.40012, y = -17.49984},
    {x = -99.40012, y = -8.399864},
    {x = -128.0001, y = 0.1001358}
  },
  {
    {x = -46.8, y = -54},
    {x = -74.80004, y = -54.00012},
    {x = -103.4, y = -57.30011}
  },
  {
    {x = -35.8, y = -66.9},
    {x = -62.29993, y = -78.09981},
    {x = -85.99993, y = -92.79982}
  },
  {
    {x = -3.8, y = -77.2},
    {x = 11.60007, y = -103.6999},
    {x = 33.00008, y = -123.8999},
    {x = 58.60007, y = -138.7999},
    {x = 84.20007, y = -150.6999}
  },
  {
    {x = 14.9, y = -73.3},
    {x = 41.69987, y = -82.20011},
    {x = 67.29987, y = -92.90009},
    {x = 91.69987, y = -104.8001}
  },
  {
    {x = -19, y = -89},
    {x = -42.19994, y = -100.9},
    {x = -68.39994, y = -107.4},
    {x = -95.19994, y = -112.2}
  },
  {
    {x = -31.9, y = -53.2},
    {x = -59.8999, y = -54.99994},
    {x = -89.0999, y = -57.99994}
  },
  {
    {x = -11.3, y = -73.2},
    {x = 1.200007, y = -102.3},
    {x = 18.50001, y = -125.9},
    {x = 39.30001, y = -145.3},
    {x = 62.20001, y = -161.9},
    {x = 87.10001, y = -177.8},
    {x = 112.7, y = -190.3},
    {x = 139, y = -201.4},
    {x = 166.3, y = -211.1},
    {x = 192.7, y = -219}
  },
  {
    {x = 38, y = -79},
    {x = 64.9, y = -84.1},
    {x = 91.8, y = -90.5},
    {x = 117.4, y = -100.1},
    {x = 142.4, y = -110.4},
    {x = 166.1, y = -124.5},
    {x = 189.2, y = -139.9},
    {x = 210.4, y = -157.2},
    {x = 229.6, y = -177.1}
  },
  {
    {x = 3.3, y = -84.1},
    {x = 16.79997, y = -107.7999},
    {x = 27.09995, y = -132.7999},
    {x = 36.09996, y = -160.3999},
    {x = 41.89997, y = -187.2999},
    {x = 46.39997, y = -213.9999},
    {x = 49.39997, y = -240.6999}
  },
  {
    {x = -6.8, y = -80.6},
    {x = -9.299908, y = -108.2999},
    {x = -13.79991, y = -135.4998},
    {x = -18.29991, y = -163.1998},
    {x = -25.6999, y = -189.3998},
    {x = -34.59993, y = -216.0998},
    {x = -44.49992, y = -241.2999},
    {x = -58.89991, y = -266.0999}
  },
  {
    {x = -36.9, y = -87},
    {x = -61.20012, y = -100.9},
    {x = -86.00011, y = -112.8},
    {x = -112.2001, y = -122.7001},
    {x = -138.4001, y = -130.1},
    {x = -165.6001, y = -136.5001},
    {x = -192.3001, y = -139.5001},
    {x = -220.0001, y = -141.5001}
  },
  {
    {x = -45, y = -45},
    {x = -69.69991, y = -34.90015},
    {x = -93.19991, y = -20.90015},
    {x = -112.1999, y = -3.800171},
    {x = -127.3999, y = 17.79987},
    {x = -134.3999, y = 41.29987},
    {x = -126.7999, y = 64.09985},
    {x = -107.7999, y = 80.59985},
    {x = -84.4999, y = 94.69983},
    {x = -59.0999, y = 106.0999},
    {
      x = -54.8,
      x = -33.6999,
      y = 118.4999
    }
  },
  {
    {x = 32.1, y = -42.8},
    {x = 49.89994, y = -17.39999},
    {x = 55.79993, y = 12.89999},
    {x = 48.19993, y = 42.60001},
    {x = 35.79993, y = 69.10001},
    {x = 16.89994, y = 92.39999},
    {x = -3.700066, y = 111.9}
  },
  {
    {x = -38.7, y = -30.89996},
    {x = -63.60001, y = -17.89996},
    {x = -89, y = -6},
    {x = -115, y = 5.900024},
    {x = -140.4, y = 17.30005},
    {x = -166.9, y = 28.10004},
    {x = -191.8, y = 40.00003}
  },
  {
    {x = -38.2, y = -8.4},
    {x = -46.89988, y = 14.89992},
    {x = -44.69987, y = 39.79993},
    {x = -32.29987, y = 60.89993},
    {x = -10.69987, y = 75.49992},
    {x = 13.10012, y = 81.39993},
    {x = 38.50014, y = 75.99992},
    {x = 64.50013, y = 64.59992},
    {x = 88.30013, y = 52.69992}
  },
  {
    {x = 16.6, y = -74},
    {x = 42.00008, y = -86.99992},
    {x = 69.60007, y = -97.79993},
    {x = 97.70007, y = -103.6999},
    {x = 125.8001, y = -106.8999}
  }
}
local missilePlanePosConfig = {
  {x = 302, y = -432},
  {x = 341, y = -283},
  {x = 191, y = -141},
  {x = 34, y = -125},
  {x = -123, y = -173},
  {x = -255.8, y = -283},
  {x = -312.8, y = -433},
  {x = -150, y = -511},
  {x = 44, y = -533},
  {x = 191, y = -662},
  {x = 119, y = -895},
  {x = 225.9, y = -1074},
  {x = 300.5, y = -1284},
  {x = 176.9, y = -1419},
  {x = -13.1, y = -1463},
  {x = -183.1, y = -1383},
  {x = -87.2, y = -1204},
  {x = 8.1, y = -1004},
  {x = -144.7, y = -866},
  {x = -313.7, y = -783}
}
local missilePlanePointConfig = {
  {
    {x = 38.1, y = 14.2},
    {x = 43.7, y = 42.59999},
    {x = 42.79998, y = 70.6}
  },
  {
    {x = -53, y = 22.9},
    {x = -75.50009, y = 41.49996},
    {x = -100.2001, y = 55.69997},
    {x = -124.9001, y = 67.79995}
  },
  {
    {x = -29.1, y = -54.3},
    {x = -57.59998, y = -48.30009},
    {x = -86.09998, y = -44.5001},
    {x = -114, y = -42.30009}
  },
  {
    {x = -43.6, y = -67.5},
    {x = -71.49991, y = -74.6001},
    {x = -97.79991, y = -83.90015},
    {x = -124.6999, y = -94.30011}
  },
  {
    {x = -43.3, y = -82.8},
    {x = -68.10001, y = -98.60001},
    {x = -90.60001, y = -115.3}
  },
  {
    {x = -34.4, y = -90.2},
    {x = -48.79998, y = -115.6001}
  },
  {
    {x = 19.6, y = -80.3},
    {x = 41.49999, y = -101},
    {x = 66.49998, y = -116},
    {x = 92.79998, y = -127.3},
    {x = 120.4, y = -134.8}
  },
  {
    {x = 42.8, y = -64.9},
    {x = 71.60001, y = -64.89999},
    {x = 97.90001, y = -66.79998},
    {x = 125.9, y = -71.09998},
    {x = 152.4, y = -78.29998}
  },
  {
    {x = 9.9, y = -75.8},
    {x = 34.1, y = -87.5},
    {x = 57.6, y = -102.9},
    {x = 79.7, y = -119.8},
    {x = 101, y = -137.4}
  },
  {
    {x = 0, y = -76},
    {x = 10, y = -99},
    {x = 17, y = -126},
    {x = 19, y = -153},
    {x = 14, y = -177},
    {x = 1, y = -201},
    {x = -17, y = -219},
    {x = -38, y = -236}
  },
  {
    {x = -24.7, y = -69.7},
    {x = -33.1, y = -97},
    {x = -34.4, y = -127.4},
    {x = -22.6, y = -155.8},
    {x = -1.5, y = -177.3},
    {x = 22.3, y = -193},
    {x = 47.9, y = -205.6},
    {x = 73, y = -219.1}
  },
  {
    {x = 30.5, y = -88.6},
    {x = 47.6, y = -111.1},
    {x = 60, y = -135.1},
    {x = 70.1, y = -159.1}
  },
  {
    {x = -12.5, y = -81.3},
    {x = -26.3, y = -104.6},
    {x = -42.7, y = -126.6},
    {x = -62.2, y = -146},
    {x = -82.9, y = -162.4}
  },
  {
    {x = -31, y = -69.2},
    {x = -56.7, y = -80},
    {x = -83, y = -88.8},
    {x = -110, y = -94.8},
    {x = -137, y = -98.9}
  },
  {
    {x = -30.1, y = -54.8},
    {x = -56, y = -51.8},
    {x = -83.7, y = -45.6},
    {x = -109.6, y = -35.8},
    {x = -131.8, y = -22.8},
    {x = -150.9, y = -4.9}
  },
  {
    {x = 24.5, y = 39.9},
    {x = 38.8, y = 61.8},
    {x = 56.9, y = 82.9},
    {x = 75.1, y = 104.1}
  },
  {
    {x = 40.5, y = -15.7},
    {x = 59.1, y = 5},
    {x = 77, y = 28.7},
    {x = 91.4, y = 53.8},
    {x = 100.7, y = 81},
    {x = 106.4, y = 110.4}
  },
  {
    {x = -55, y = 35},
    {x = -78.7, y = 50.6},
    {x = -104.4, y = 62.8}
  },
  {
    {x = -34.3, y = -51.2},
    {x = -62.7, y = -48.4},
    {x = -90.2, y = -43.4},
    {x = -115, y = -35.1},
    {x = -137, y = -20.9},
    {x = -154.1, y = -1.5}
  }
}

function LWUITrailTowerStageView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self.trailTowerId, self.selectDifficultyGroup, self.isBattleSweep = self:GetUserData()
  self:ReInit()
end

function LWUITrailTowerStageView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUITrailTowerStageView:DataDefine()
  self.stageItemRenderList = {}
  self.difficultyLimit = LuaEntry.DataConfig:TryGetNum("trialtower_yijian_limit", "k1")
  self.unlockBattleSweep = false
end

function LWUITrailTowerStageView:DataDestroy()
  self.stageItemRenderList = nil
  self.difficultyLimit = nil
  self.unlockBattleSweep = nil
end

function LWUITrailTowerStageView:OnAddListener()
  self:AddUIListener(EventId.EffectNumChange, self.RefreshSweepBtnStatus)
  self:AddUIListener(EventId.TrailTowerPickGroup, self.RefreshView)
  base.OnAddListener(self)
end

function LWUITrailTowerStageView:OnRemoveListener()
  self:RemoveUIListener(EventId.EffectNumChange, self.RefreshSweepBtnStatus)
  self:RemoveUIListener(EventId.TrailTowerPickGroup, self.RefreshView)
  base.OnRemoveListener(self)
end

function LWUITrailTowerStageView:ComponentDefine()
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.curStageText = self:AddComponent(UIText, curStageText_path)
  self.fightBtnText = self:AddComponent(UITextMeshProUGUIEx, fight_btn_text_path)
  self.stageRawImage = self:AddComponent(UIRawImage, stageRawImage_path)
  self.stageContent = self:AddComponent(UIBaseContainer, stageContent_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(function()
    if self.trailTowerInfo and self.trailTowerInfo:IsEnd() then
      UIUtil.ShowTipsId("trialtower_error_01")
      GoToUtil.CloseAllWindows()
      return
    end
    if self.isBattleSweep and not self.battleSweepAniFinish and self.trailTowerLevelTemplate then
      DataCenter.LWTrailTowerManager:SetNeedShowBattleSweepResultStageId(self.trailTowerLevelTemplate.id, true)
    end
    self:CloseBtnClick()
  end)
  self.fightBtn = self:AddComponent(UIButton, fight_btn_path)
  self.fightBtn:SetOnClick(function()
    self:FightBtnClick()
  end)
  self.one_click_sweep_btn = self:AddComponent(UIButton, one_click_sweep_btn_path)
  self.one_click_sweep_btn:SetOnClick(function()
    self:OnClickSweepBtnClick()
  end)
  self.one_click_sweep_btn_text = self:AddComponent(UITextMeshProUGUIEx, one_click_sweep_btn_text_path)
  self.one_click_sweep_btn_text:SetLocalText("trialtower_yijian_01")
  self.sweep_tips_content = self:AddComponent(UIBaseContainer, sweep_tips_content_path)
  self.sweep_tips_content:SetActive(false)
  self.sweep_tips_text = self:AddComponent(UITextMeshProUGUIEx, sweep_tips_text_path)
  self.sweep_tips_text:SetLocalText("trialtower_yijian_02")
  self.rewardScrollView = self:AddComponent(UIScrollView, rewardScrollView_path)
  self.rewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.rewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  for i = 1, 20 do
    local path = stage_path .. i
    local stageItemRender = self:AddComponent(LWUITrailTowerStageItemRender, path)
    table.insert(self.stageItemRenderList, stageItemRender)
  end
end

function LWUITrailTowerStageView:ComponentDestroy()
  self:ClearDelayTimer()
  self:ClearTween()
  self.titleText = nil
  self.curStageText = nil
  self.closeBtn = nil
  self:ClearRewardScroll()
  self.rewardScrollView = nil
  self.fightBtnText = nil
  self.fightBtn = nil
  self.stageRawImage = nil
  self.stageContent = nil
  self.one_click_sweep_btn = nil
  self.one_click_sweep_btn_text = nil
  self.sweep_tips_content = nil
  self.sweep_tips_text = nil
end

function LWUITrailTowerStageView:ReInit()
  self.titleText:SetLocalText("trialtower_011")
  self.fightBtnText:SetLocalText("trialtower_019")
  local bgImgPath = LocalController:instance():getValue(TableName.LW_Trail_Tower, self.trailTowerId, "level_map")
  self.stageRawImage:LoadSprite(bgImgPath)
  self.battleSweepAniFinish = false
  self.trailTowerInfo = DataCenter.LWTrailTowerManager:GetTrailTowerInfoById(self.trailTowerId)
  self.curSelectStageId = 1
  self.curSelectStageIndex = 1
  self.battleSweepStartStageIndex = 1
  self.isPassAllStage = false
  self:RefreshView()
end

function LWUITrailTowerStageView:RefreshView()
  local battleSweepStartStageOrder = 1
  self:RefreshSweepBtnStatus()
  self.trailTowerStageList = DataCenter.LWTrailTowerTemplateManager:GetTrailTowerLevelTemplateList(self.trailTowerId, self.selectDifficultyGroup)
  local stageListCount = table.count(self.trailTowerStageList)
  if self.trailTowerInfo ~= nil and 0 < stageListCount then
    if self.isBattleSweep then
      if DataCenter.LWTrailTowerManager.battleIsWin then
        self.curSelectStageId = self.trailTowerStageList[stageListCount].id
        self.isPassAllStage = true
      else
        self.curSelectStageId = self.trailTowerInfo.curStage
      end
      local battleSweepEndStageOrder = LocalController:instance():getValue(TableName.LW_Trail_Tower_Level, self.curSelectStageId, "level_order", 1)
      if not self.isPassAllStage then
        battleSweepEndStageOrder = battleSweepEndStageOrder - 1
      end
      battleSweepStartStageOrder = battleSweepEndStageOrder - DataCenter.LWTrailTowerManager.winNum + 1
    elseif self.trailTowerInfo.curStage == 0 then
      self.curSelectStageId = self.trailTowerStageList[1].id
    elseif self.trailTowerInfo.curStage == -1 then
      self.curSelectStageId = self.trailTowerStageList[stageListCount].id
      self.isPassAllStage = true
    else
      self.curSelectStageId = self.trailTowerInfo.curStage
    end
    local count = table.count(self.stageItemRenderList)
    for i = 1, count do
      local stageItemRender = self.stageItemRenderList[i]
      local trailTowerLevelTemplate = self.trailTowerStageList[i]
      if trailTowerLevelTemplate then
        if trailTowerLevelTemplate.id == self.curSelectStageId then
          self.trailTowerLevelTemplate = trailTowerLevelTemplate
          self.curSelectStageIndex = i
        end
        if trailTowerLevelTemplate.levelOrder == battleSweepStartStageOrder then
          self.battleSweepStartStageIndex = i
        end
        stageItemRender:SetActive(true)
        local pos = self:GetStagePos(i)
        local pointPosList = self:GetStagePointPosList(i)
        stageItemRender:SetAnchoredPositionXY(pos.x, pos.y, 0)
        stageItemRender:SetData(trailTowerLevelTemplate, self.curSelectStageId, pointPosList, self.isBattleSweep, self.isPassAllStage, battleSweepStartStageOrder)
      else
        stageItemRender:SetActive(false)
      end
    end
    if self.isBattleSweep then
      local trailTowerLevelTemplate = DataCenter.LWTrailTowerTemplateManager:GetTrailTowerLevelTemplateByOrder(self.trailTowerId, self.selectDifficultyGroup, battleSweepStartStageOrder)
      if trailTowerLevelTemplate ~= nil then
        self:RefreshShowCurSelectStage(trailTowerLevelTemplate)
        self:JumpToTargetStagePos(self.battleSweepStartStageIndex, true)
      end
      if DataCenter.LWTrailTowerManager.winNum == 0 then
        self.battleSweepAniFinish = true
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrailTowerSweepBattleResult, {anim = true, playEffect = 10023}, false, self.trailTowerLevelTemplate.id)
      end
    else
      self:RefreshShowCurSelectStage(self.trailTowerLevelTemplate)
      self:JumpToTargetStagePos(self.curSelectStageIndex, false)
    end
  end
end

function LWUITrailTowerStageView:RefreshNextStagePlayAniInfo()
  if self.battleSweepAniFinish or not self.isBattleSweep then
    return
  end
  self.battleSweepStartStageIndex = self.battleSweepStartStageIndex + 1
  if self.battleSweepStartStageIndex > self.curSelectStageIndex then
    self.battleSweepStartStageIndex = self.curSelectStageIndex
  end
  local trailTowerLevelTemplate = self.trailTowerStageList[self.battleSweepStartStageIndex]
  if trailTowerLevelTemplate ~= nil then
    self:RefreshShowCurSelectStage(trailTowerLevelTemplate)
    self:JumpToTargetStagePos(self.battleSweepStartStageIndex, true)
    local targetStageItem = self.stageItemRenderList[self.battleSweepStartStageIndex]
    if targetStageItem then
      targetStageItem:RefreshView(trailTowerLevelTemplate.levelOrder)
    end
    if self.battleSweepStartStageIndex >= self.curSelectStageIndex then
      self.battleSweepAniFinish = true
      local isWin = DataCenter.LWTrailTowerManager.battleIsWin
      if isWin then
        self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
          self:ClearDelayTimer()
          if self.trailTowerLevelTemplate then
            DataCenter.LWTrailTowerManager:SetNeedShowBattleSweepResultStageId(self.trailTowerLevelTemplate.id, false)
          end
          self:CloseBtnClick()
        end, 1)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrailTowerSweepBattleResult, {anim = true, playEffect = 10023}, false, self.trailTowerLevelTemplate.id)
      end
    end
  end
end

function LWUITrailTowerStageView:ClearDelayTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function LWUITrailTowerStageView:JumpToTargetStagePos(index, playTween)
  local count = table.count(self.stageItemRenderList)
  if index <= count then
    local targetStageItem = self.stageItemRenderList[index]
    local targetSizeDelta = targetStageItem:GetSizeDelta()
    local targetPosY = -targetStageItem:GetAnchoredPositionY() - targetSizeDelta.y / 2 - 200
    local posX = self.stageContent:GetAnchoredPositionX()
    if not playTween then
      self.stageContent:SetAnchoredPositionXY(posX, targetPosY)
    else
      self:ClearTween()
      self.stageMoveTween = CS.DG.Tweening.DOTween.To(function()
        return self.stageContent:GetAnchoredPositionY()
      end, function(value)
        self.stageContent:SetAnchoredPositionXY(posX, value)
      end, targetPosY, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
    end
  end
end

function LWUITrailTowerStageView:ClearTween()
  if self.stageMoveTween then
    self.stageMoveTween:Kill()
    self.stageMoveTween = nil
  end
end

function LWUITrailTowerStageView:RefreshShowCurSelectStage(trailTowerLevelTemplate)
  local stageDes = trailTowerLevelTemplate.levelGroup .. "-" .. trailTowerLevelTemplate.levelOrder
  self.curStageText:SetText(Localization:GetString("trialtower_018", stageDes))
  self.stageRewardList = trailTowerLevelTemplate:GetReward()
  local rewardCount = #self.stageRewardList
  self:ClearRewardScroll()
  if 0 < rewardCount then
    self.rewardScrollView:SetTotalCount(rewardCount)
    self.rewardScrollView:RefillCells()
  end
  local canBattle = self.curSelectStageId == trailTowerLevelTemplate.id and not self.isPassAllStage
  self.fightBtn:SetActive(canBattle)
  if canBattle then
    self:RefreshSweepBtnStatus()
  else
    self.one_click_sweep_btn:SetActive(false)
  end
end

function LWUITrailTowerStageView:OnStageItemClick(trailTowerLevelTemplate)
  self:RefreshShowCurSelectStage(trailTowerLevelTemplate)
end

function LWUITrailTowerStageView:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  itemObj.transform:Set_localScale(0.9, 0.9, 0.9)
  local itemRender = self.rewardScrollView:AddComponent(UICommonResItem, itemObj)
  if itemRender ~= nil then
    itemRender:ReInit(self.stageRewardList[index])
  end
end

function LWUITrailTowerStageView:OnRewardItemMoveOut(itemObj, index)
  itemObj.transform:Set_localScale(1, 1, 1)
  self.rewardScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function LWUITrailTowerStageView:ClearRewardScroll()
  self.rewardScrollView:ClearCells()
  self.rewardScrollView:RemoveComponents(UICommonResItem)
end

function LWUITrailTowerStageView:FightBtnClick()
  if self.isBattleSweep and not self.battleSweepAniFinish then
    UIUtil.ShowTipsId("trialtower_yijian_07")
    return
  end
  if self.trailTowerInfo and self.trailTowerInfo:IsEnd() then
    UIUtil.ShowTipsId("trialtower_error_01")
    GoToUtil.CloseAllWindows()
    return
  end
  if self.trailTowerLevelTemplate == nil then
    return
  end
  local param = {}
  param.type = PVEType.FakePVP
  param.enterType = PVEEnterType.TrailTower
  param.levelId = self.trailTowerLevelTemplate.levelArmyId
  param.sceneId = self.trailTowerLevelTemplate.sceneId
  param.extraData = {}
  param.extraData.trailTowerLevelTemplate = self.trailTowerLevelTemplate
  param.extraData.isBattleSweep = false
  DataCenter.LWBattleManager:Enter(param)
  DataCenter.LWTrailTowerManager.autoOpenTrailTowerPanelWhenBackToCity = true
end

function LWUITrailTowerStageView:OnClickSweepBtnClick()
  if self.isBattleSweep and not self.battleSweepAniFinish then
    UIUtil.ShowTipsId("trialtower_yijian_07")
    return
  end
  if not self.unlockBattleSweep then
    UIUtil.ShowTipsId("trialtower_yijian_08")
    return
  end
  if self.trailTowerInfo and self.trailTowerInfo:IsEnd() then
    UIUtil.ShowTipsId("trialtower_error_01")
    GoToUtil.CloseAllWindows()
    return
  end
  if self.trailTowerLevelTemplate == nil then
    return
  end
  if DataCenter.LWTrailTowerManager:IsAutoNextStage(self.trailTowerInfo.trailTowerId) then
    DataCenter.LWTrailTowerManager:ClearAutoNextData(self.trailTowerInfo.trailTowerId)
  end
  local param = {}
  param.type = PVEType.FakePVP
  param.enterType = PVEEnterType.TrailTower
  param.levelId = self.trailTowerLevelTemplate.levelArmyId
  param.sceneId = self.trailTowerLevelTemplate.sceneId
  param.extraData = {}
  param.extraData.trailTowerLevelTemplate = self.trailTowerLevelTemplate
  param.extraData.isBattleSweep = true
  DataCenter.LWBattleManager:Enter(param)
  DataCenter.LWTrailTowerManager.autoOpenTrailTowerPanelWhenBackToCity = true
end

function LWUITrailTowerStageView:CloseBtnClick()
  local isOpen = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWTrailTowerMain)
  if not isOpen then
    DataCenter.LWTrailTowerManager:SetJumpToTrailTowerIdData(self.trailTowerId)
    DataCenter.LWTrailTowerManager:OpenTrailTowerMainPanel(TrailTowerTabType.TrailTower)
  end
  self.ctrl:CloseSelf()
end

function LWUITrailTowerStageView:GetStagePos(index)
  if self.trailTowerInfo.trailTowerId == TrailTowerType.Tank then
    return tankStagePosConfig[index]
  elseif self.trailTowerInfo.trailTowerId == TrailTowerType.AirPlane then
    return airPlanePosConfig[index]
  else
    return missilePlanePosConfig[index]
  end
end

function LWUITrailTowerStageView:GetStagePointPosList(index)
  if self.trailTowerInfo.trailTowerId == TrailTowerType.Tank then
    if tankStagePointConfig[index] then
      return tankStagePointConfig[index]
    end
  elseif self.trailTowerInfo.trailTowerId == TrailTowerType.AirPlane then
    if airPlanePointConfig[index] then
      return airPlanePointConfig[index]
    end
  elseif missilePlanePointConfig[index] then
    return missilePlanePointConfig[index]
  end
end

function LWUITrailTowerStageView:RefreshSweepBtnStatus()
  local effectValue_50217 = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_TRAIL_TOWER_SWEEP)
  local achievementDifficulty = false
  if self.trailTowerInfo ~= nil then
    achievementDifficulty = self.trailTowerInfo.passGroup >= self.difficultyLimit
  end
  self.unlockBattleSweep = 0 < effectValue_50217 or achievementDifficulty
  self.one_click_sweep_btn:SetActive(true)
  CS.UIGray.SetGray(self.one_click_sweep_btn.transform, not self.unlockBattleSweep, true)
end

return LWUITrailTowerStageView
