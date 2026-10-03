local UIValentineNpcRewardCardCtrl = BaseClass("UIValentineNpcRewardCardCtrl", UIBaseCtrl)

function UIValentineNpcRewardCardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIValentineNpcRewardCard)
end

return UIValentineNpcRewardCardCtrl
