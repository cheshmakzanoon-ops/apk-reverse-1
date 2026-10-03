local BirthdayGoodsTipBtn = BaseClass("BirthdayGoodsTipBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function BirthdayGoodsTipBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function BirthdayGoodsTipBtn:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BirthdayGoodsTipBtn:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OpenSetView()
  end)
end

function BirthdayGoodsTipBtn:ComponentDestroy()
  self.btn = nil
end

function BirthdayGoodsTipBtn:OpenSetView()
  local targetGoodsId
  local birthdayGroupType = LetterGroupTypeStr.Birthday
  local items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_160)
  if items and 0 < #items then
    for _, item in ipairs(items) do
      if item.para1 == birthdayGroupType then
        local otherParamData = item:GetOtherParamTab()
        if otherParamData.state == nil or toInt(otherParamData.state) == 0 then
          targetGoodsId = item.itemId
          break
        end
      end
    end
  end
  local data
  if targetGoodsId then
    data = {jumpGoodsId = targetGoodsId}
  end
  GoToUtil.GotoOpenView(UIWindowNames.UILWBagMain, {}, data)
end

return BirthdayGoodsTipBtn
