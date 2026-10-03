local UIAllyDrillDonate = BaseClass("UIAllyDrillDonate", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")

function UIAllyDrillDonate:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UIAllyDrillDonate:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDrillDonate:ComponentDefine()
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "Root/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.quality = self:AddComponent(UIImage, "Root/quality")
  self.icon = self:AddComponent(UIImage, "Root/icon")
  self.smallIcon = self:AddComponent(UIImage, "Root/donateBtn/costTxt/smallIcon")
  self.numTxt = self:AddComponent(UIText, "Root/numTxt")
  self.slider = self:AddComponent(UISlider, "Root/slider")
  self.sliderTxt = self:AddComponent(UIText, "Root/sliderTxt")
  self.infoBtn = self:AddComponent(UIButton, "Root/tipBg/infoBtn")
  self.infoBtn:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.curTxt = self:AddComponent(UIText, "Root/curBg/curTxt")
  self.nextTxt = self:AddComponent(UIText, "Root/nextBg/nextTxt")
  self.mark = self:AddComponent(UIBaseComponent, "Root/curBg/mark")
  self.donateBtn = self:AddComponent(UIButton, "Root/donateBtn")
  self.donateBtn:SetOnClick(function()
    self:OnClickDonateBtn()
  end)
  self.donateAllBtn = self:AddComponent(UIButton, "Root/allBtn")
  self.donateAllBtn:SetActive(false)
  self.donateAllBtn:SetOnClick(function()
    self:OnClickDonateAllBtn()
  end)
  self.costTxt = self:AddComponent(UIText, "Root/donateBtn/costTxt")
end

function UIAllyDrillDonate:OnDiffDropChange(self)
  local choiceIndex = self.diffDrop:GetValue()
  Logger.LogError(choiceIndex)
end

function UIAllyDrillDonate:ComponentDestroy()
  self.returnBtn = nil
  self.closeBtn = nil
end

function UIAllyDrillDonate:DataDefine()
  self.goodsId = DataCenter.AllyDrillDataManager:GetDonateGoodsId()
end

function UIAllyDrillDonate:DataDestroy()
end

function UIAllyDrillDonate:OnEnable()
  base.OnEnable(self)
end

function UIAllyDrillDonate:OnDisable()
  base.OnDisable(self)
end

function UIAllyDrillDonate:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnAllyDrillDonateSuccess, self.OnDonateSuccess)
  self:AddUIListener(EventId.OnAllyDrillInfoRefresh, self.Refresh)
end

function UIAllyDrillDonate:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnAllyDrillDonateSuccess, self.OnDonateSuccess)
  self:RemoveUIListener(EventId.OnAllyDrillInfoRefresh, self.Refresh)
end

function UIAllyDrillDonate:Refresh()
  self.actInfo = DataCenter.AllyDrillDataManager:GetActInfo()
  if not self.actInfo then
    return
  end
  local need = 0
  local cur = self.actInfo.data.donateExp
  local curLevel = self.actInfo.data.donateLevel
  local sliderValue = 0
  local sliderText = ""
  local curText = ""
  local nextTxt = ""
  local curSelectDifficultyLevel = self.actInfo.data.difficultyLevel
  if DataCenter.AllyDrillDataManager:GetBossType() == AllyDrillBoss.HugeSandWorm then
    local donateCfgData = DataCenter.AllyDrillDataManager:GetNewBossDonateLevelCfg(curSelectDifficultyLevel)
    if donateCfgData then
      need = donateCfgData.needNumber[curLevel + 1] or 1
      if curLevel == 0 then
        sliderValue = 0 < need and cur / need or 1
        sliderText = string.format("%s/%s", cur, need)
        curText = Localization:GetString("2010372")
        local buffValue = string.GetFormattedPercentStr(donateCfgData.bonus[curLevel + 1] or 0)
        nextTxt = Localization:GetString("new_alliance_boss_tips_13", "Lv." .. curLevel + 1, buffValue)
      elseif curLevel == #donateCfgData.needNumber then
        sliderValue = 1
        sliderText = Localization:GetString("150072")
        local buffValue = string.GetFormattedPercentStr(donateCfgData.bonus[curLevel] or 0)
        curText = Localization:GetString("new_alliance_boss_tips_13", "Lv." .. curLevel, buffValue)
        nextTxt = Localization:GetString("150072")
      elseif curLevel < #donateCfgData.needNumber then
        sliderValue = 0 < need and cur / need or 1
        sliderText = string.format("%s/%s", cur, need)
        local buffValue = string.GetFormattedPercentStr(donateCfgData.bonus[curLevel] or 0)
        curText = Localization:GetString("new_alliance_boss_tips_13", "Lv." .. curLevel, buffValue)
        buffValue = string.GetFormattedPercentStr(donateCfgData.bonus[curLevel + 1] or 0)
        nextTxt = Localization:GetString("new_alliance_boss_tips_13", "Lv." .. curLevel + 1, buffValue)
      else
        Logger.LogError("\231\173\137\231\186\167\232\182\138\231\149\140" .. curLevel .. #donateCfgData.needNumber)
      end
    end
  else
    local meta = DataCenter.AllyDrillDataManager:GetCfg(self.actInfo.data.difficultyLevel)
    if meta then
      if curLevel == 0 then
        need = meta.donate_level[curLevel + 1] or 1
        sliderValue = 0 < need and cur / need or 1
        sliderText = string.format("%s/%s", cur, need)
        curText = Localization:GetString("2010372")
        local buffValue = string.GetFormattedPercentStr(meta.donate_level_bonus[curLevel + 1])
        nextTxt = Localization:GetString("2010328", "Lv." .. curLevel + 1, buffValue)
      elseif curLevel == #meta.donate_level then
        need = meta.donate_level[curLevel] or 1
        sliderValue = 1
        sliderText = Localization:GetString("150072")
        local buffValue = string.GetFormattedPercentStr(meta.donate_level_bonus[curLevel])
        curText = Localization:GetString("2010328", "Lv." .. curLevel, buffValue)
        nextTxt = Localization:GetString("150072")
      elseif curLevel < #meta.donate_level then
        need = meta.donate_level[curLevel + 1] or 1
        sliderValue = 0 < need and cur / need or 1
        sliderText = string.format("%s/%s", cur, need)
        local buffValue = string.GetFormattedPercentStr(meta.donate_level_bonus[curLevel])
        curText = Localization:GetString("2010328", "Lv." .. curLevel, buffValue)
        buffValue = string.GetFormattedPercentStr(meta.donate_level_bonus[curLevel + 1])
        nextTxt = Localization:GetString("2010328", "Lv." .. curLevel + 1, buffValue)
      else
        Logger.LogError("\231\173\137\231\186\167\232\182\138\231\149\140" .. curLevel .. #meta.donate_level)
      end
    end
  end
  self.slider:SetValue(sliderValue)
  self.sliderTxt:SetText(sliderText)
  self.curTxt:SetText(curText)
  self.nextTxt:SetText(nextTxt)
  local score = LuaEntry.DataConfig:TryGetNum("alliance_boss", "k1", 500)
  self.numTxt:SetText("x" .. score)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.goodsId)
  self.quality:LoadSprite(UIUtil.GetItemQualityBg(template.quality))
  self.icon:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
  self.smallIcon:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
  local own = DataCenter.ItemData:GetItemCount(self.goodsId)
  self.costTxt:SetText(own .. "/1")
  self.costTxt:SetColor(0 < own and GreenColor or RedColor)
end

function UIAllyDrillDonate:OnClickDonateBtn()
  local own = DataCenter.ItemData:GetItemCount(self.goodsId)
  if 0 < own then
    DataCenter.AllyDrillDataManager:SendMsgAllianceBossDonate(1)
    self.clickPos = self.donateBtn.transform.position
  else
    UIUtil.ShowTipsId(2010384)
  end
end

function UIAllyDrillDonate:OnDonateSuccess(msg)
  self.donateAllBtn:SetActive(msg.item.count > 0)
  self:Refresh()
  DataCenter.AllianceBaseDataManager:UpdateAccPoint(msg.accInfo.accPoint, self.clickPos)
end

function UIAllyDrillDonate:OnClickDonateAllBtn()
  local own = DataCenter.ItemData:GetItemCount(self.goodsId)
  if 0 < own then
    DataCenter.AllyDrillDataManager:SendMsgAllianceBossDonate(own)
    self.clickPos = self.donateAllBtn.transform.position
  end
end

function UIAllyDrillDonate:OnClickInfoBtn()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.infoBtn.transform.position + Vector3.New(0, 33, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("2010324")
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 150
  param.pivot = 0.5
  param.position = position
  param.deltaX = 0
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

return UIAllyDrillDonate
