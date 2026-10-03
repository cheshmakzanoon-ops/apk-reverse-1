local UIDelAllAcctUnderReview = {
  Name = UIWindowNames.UIDelAllAcctUnderReview,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIAccount2.UIDeleteAllAccount.UIDelAllAcctUnderReview.Controller.UIDelAllAcctUnderReviewCtrl"),
  View = require("UI.UIAccount2.UIDeleteAllAccount.UIDelAllAcctUnderReview.View.UIDelAllAcctUnderReviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAccount/UIDeleteAllAccount/UIDelAllAcctUnderReview.prefab"
}
return {UIDelAllAcctUnderReview = UIDelAllAcctUnderReview}
