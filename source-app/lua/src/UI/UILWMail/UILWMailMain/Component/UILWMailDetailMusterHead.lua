local base = require("UI.UILWMail.UILWMailMain.Component.UILWMailDetailBase")
local UILWMailDetailMusterHead = BaseClass("UILWMailDetailMusterHead", base)
local MainResistanceInfo = require("UI.UILWMail.UILWMailMain.Component.MainResistanceInfo")
local MainVirusInfo = require("UI.UILWMail.UILWMailMain.Component.MainVirusInfo")
local MonsterBuffComponent = require("UI.UIWorldPoint.Component.MonsterBuffComponent")

function UILWMailDetailMusterHead:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailMusterHead:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailMusterHead:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailMusterHead:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailMusterHead:ComponentDefine()
  self.coordinateText = self:AddComponent(UIText, "coordinateText")
  self.coordinateBtn = self:AddComponent(UIButton, "coordinateText")
  self.coordinateBtn:SetOnClick(function()
    self:OnJumpClick()
  end)
  self.timeText = self:AddComponent(UIText, "timeText")
  self.cityNode = self:AddComponent(UIBaseComponent, "cityNode")
  self.cityIcon = self:AddComponent(UIImage, "cityNode/cityIcon")
  self.cityLvText = self:AddComponent(UIText, "cityNode/cityLvText")
  self.cityNameText = self:AddComponent(UIText, "cityNode/cityNameText")
  self.citySliderYellow = self:AddComponent(UISlider, "cityNode/citySliderYellow")
  self.citySliderRed = self:AddComponent(UISlider, "cityNode/citySliderRed")
  self.citySliderText = self:AddComponent(UIText, "cityNode/citySliderText")
  self.rootHpLost = self:AddComponent(UIBaseContainer, "cityNode/CityIconBubble")
  self.cityHpLost = self:AddComponent(UIText, "cityNode/CityIconBubble/cityHpLost")
  self.skillHpLost = self:AddComponent(UIText, "cityNode/CityIconBubble/skillHpLost")
  self.leaderRoot = self:AddComponent(UIBaseComponent, "Leader")
  self.leaderBg1 = self:AddComponent(UIBaseComponent, "Leader/bg1")
  self.leaderBg2 = self:AddComponent(UIBaseComponent, "Leader/bg2")
  self.leaderBg1Img = self:AddComponent(UIRawImage, "Leader/bg1")
  self.leaderBg2Img = self:AddComponent(UIRawImage, "Leader/bg2/bg")
  self.leaderHead1 = self:AddComponent(UICommonHead, "Leader/leaderHead1")
  self.leaderHead2 = self:AddComponent(UICommonHead, "Leader/leaderHead2")
  self.leaderName1 = self:AddComponent(UIText, "Leader/leaderName1")
  self.leaderName2 = self:AddComponent(UIText, "Leader/leaderName2")
  self.anonymityBtn1 = self:AddComponent(UIButton, "Leader/anonymityBtn1")
  self.anonymityBtn1:SetOnClick(function()
    self:OnClickAnonymityBtn1()
  end)
  self.anonymityBtn2 = self:AddComponent(UIButton, "Leader/anonymityBtn2")
  self.anonymityBtn2:SetOnClick(function()
    self:OnClickAnonymityBtn2()
  end)
  self.coordinateText1 = self:AddComponent(UIText, "Leader/coordinateText1")
  self.coordinateText2 = self:AddComponent(UIText, "Leader/coordinateText2")
  self.coordinateBtn1 = self:AddComponent(UIButton, "Leader/coordinateText1")
  self.coordinateBtn1:SetOnClick(function()
    self:OnJumpClick1()
  end)
  self.coordinateBtn2 = self:AddComponent(UIButton, "Leader/coordinateText2")
  self.coordinateBtn2:SetOnClick(function()
    self:OnJumpClick2()
  end)
  self.winNode = self:AddComponent(UIBaseComponent, "Leader/winNode")
  self.loseNode = self:AddComponent(UIBaseComponent, "Leader/loseNode")
  self.leaderSlider1 = self:AddComponent(UISlider, "Leader/leaderSlider1")
  self.leaderSlider2 = self:AddComponent(UISlider, "Leader/leaderSlider2")
  self.sliderText1 = self:AddComponent(UIText, "Leader/sliderText1")
  self.sliderText2 = self:AddComponent(UIText, "Leader/sliderText2")
  self.ResistanceRoot = self:AddComponent(MainResistanceInfo, "KangXingRoot")
  self.VirusRoot = self:AddComponent(MainVirusInfo, "KangXingVirusRoot")
  self.MonsterBuff = self:AddComponent(MonsterBuffComponent, "MonsterBuff")
  self.champion_duel_node = self:AddComponent(UIBaseComponent, "CD_Node")
  self.champion_duel_totalText = self:AddComponent(UIText, "CD_Node/CD_TotalText")
  self.champion_duel_surviveNum = self:AddComponent(UIText, "CD_Node/CD_Survive/CD_SurviveNum")
  self.champion_duel_killedNum = self:AddComponent(UIText, "CD_Node/CD_Killed/CD_KilledNum")
  self.champion_duel_winNum = self:AddComponent(UIText, "CD_Node/CD_Win/CD_WinNum")
  self.resNode = self:AddComponent(UIBaseComponent, "ResNode")
  self.resText = self:AddComponent(UIText, "ResNode/ResText")
  self.weightNode = self:AddComponent(UIBaseComponent, "ResNode/Weight")
  self.weightText = self:AddComponent(UIText, "ResNode/Weight/WeightText")
  self.weightText:SetLocalText(GameDialogDefine.MAIL_WEIGHT)
  self.weightNum = self:AddComponent(UIText, "ResNode/Weight/WeightNum")
  self.weightBtn = self:AddComponent(UIButton, "ResNode/Weight/WeightBtn")
  self.weightBtn:SetOnClick(function()
    self:OnWeightClick()
  end)
  self.rewardItem = self.transform:Find("MailResItem").gameObject
  self.rewardItem:GameObjectCreatePool()
  self.rewardItem:SetActive(false)
  self.rewardContent = self:AddComponent(UIBaseContainer, "ResNode/Viewport/Content")
  self.armyTitle = self:AddComponent(UIText, "ArmyNode/armyTitle")
  self.armyTitle:SetLocalText(GameDialogDefine.OVER_ALL)
end

function UILWMailDetailMusterHead:ComponentDestroy()
  self:ClearReward()
  self.leaderName1 = nil
  self.leaderName2 = nil
end

function UILWMailDetailMusterHead:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  if not self.mailData then
    return
  end
  self.extData = self.mailData:GetMailExt()
  self:ShowTop(true)
  if self.mailData and self.mailData:HasMummyJoin() then
    self.leaderBg1Img:LoadSprite("Assets/Main/SeasonRes/Shared/Textures/MummyAttack/ljq_zhanbao_banner.png")
    self.leaderBg2Img:LoadSprite("Assets/Main/SeasonRes/Shared/Textures/MummyAttack/ljq_zhanbao_banner.png")
  else
    self.leaderBg1Img:LoadSprite("Assets/Main/TextureEx/UILWMail/lyp_zhanbao_beijing01.png")
    self.leaderBg2Img:LoadSprite("Assets/Main/TextureEx/UILWMail/lyp_zhanbao_beijing01.png")
  end
end

function UILWMailDetailMusterHead:ShowAnonymityBtn1()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if not self.leaderName1 then
      return
    end
    local pos = self.leaderName1:GetLocalPosition()
    local width = self.leaderName1:GetWidth() + self.anonymityBtn1:GetSizeDelta().x
    pos.x = pos.x + 0.5 * width
    self.anonymityBtn1:SetLocalPosition(pos)
    self.anonymityBtn1:SetActive(true)
  end, 2)
end

function UILWMailDetailMusterHead:ShowAnonymityBtn2()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    if not self.leaderName2 then
      return
    end
    local pos = self.leaderName2:GetLocalPosition()
    local width = self.leaderName2:GetWidth() + self.anonymityBtn2:GetSizeDelta().x
    pos.x = pos.x - 0.5 * width
    self.anonymityBtn2:SetLocalPosition(pos)
    self.anonymityBtn2:SetActive(true)
  end, 2)
end

return UILWMailDetailMusterHead
